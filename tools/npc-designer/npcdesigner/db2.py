"""Item names, quality and prices from the server's extracted client tables.

Pandaria 5.4.8: dbc/Item-sparse.db2   (WDB2)
BFA 8.3.7:      dbc/<locale>/ItemSparse.db2   (WDC3)
WotLK has no item names in its client tables; the world DB's item_template has them.
"""

from __future__ import annotations

import struct
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterator, Optional


@dataclass
class ItemInfo:
    id: int
    name: str
    quality: int = 1
    buy_price: int = 0
    buy_count: int = 1


class Db2Error(Exception):
    pass


def _cstr(blob: bytes, start: int) -> str:
    if start < 0 or start >= len(blob):
        return ""
    end = blob.find(b"\0", start)
    if end < 0:
        end = len(blob)
    return blob[start:end].decode("utf-8", "replace")


# ---------------------------------------------------------------- WDB2 (5.x)

# Item-sparse.db2 fields (pandaria_5.4.8 DB2fmt.h ItemSparsefmt): every field is 4 bytes.
WDB2_ITEMSPARSE_FIELDS = 134
WDB2_ID, WDB2_QUALITY, WDB2_BUYCOUNT, WDB2_BUYPRICE, WDB2_NAME = 0, 1, 7, 8, 100


def read_wdb2_itemsparse(data: bytes) -> Iterator[ItemInfo]:
    if data[:4] != b"WDB2":
        raise Db2Error("not a WDB2 file")
    (records, fields, record_size, string_size, _hash, build, _ts) = struct.unpack_from("<7I", data, 4)
    pos = 32
    if build > 12880:
        min_id, max_id, _locale, _copy = struct.unpack_from("<4I", data, pos)
        pos += 16
        if max_id:
            n = max_id - min_id + 1
            pos += n * 4 + n * 2
    if fields != WDB2_ITEMSPARSE_FIELDS or record_size != fields * 4:
        raise Db2Error(f"unexpected Item-sparse layout ({fields} fields, {record_size} bytes per row)")
    strings_at = pos + records * record_size
    strings = data[strings_at:strings_at + string_size]
    for r in range(records):
        row = struct.unpack_from(f"<{fields}I", data, pos + r * record_size)
        yield ItemInfo(row[WDB2_ID], _cstr(strings, row[WDB2_NAME]), row[WDB2_QUALITY],
                       row[WDB2_BUYPRICE], max(row[WDB2_BUYCOUNT], 1))


# ---------------------------------------------------------------- WDC3 (8.x)

# ItemSparse.db2 fields in file order (BFA-HavenCore DB2Metadata.h ItemSparseMeta, 62 fields).
WDC3_ITEMSPARSE_FIELDS = 62
WDC3_NAME, WDC3_BUYPRICE, WDC3_BUYCOUNT, WDC3_QUALITY = 5, 17, 18, 61
# Field types and array sizes in file order, for the sparse layout where fields are read one after another
# (L long, S string, F float, I int, H short, B byte).
WDC3_ITEMSPARSE_META = ([("L", 1)] + [("S", 1)] * 5 + [("F", 1), ("I", 1), ("F", 1), ("I", 1), ("F", 1),
                        ("F", 10), ("I", 10)] + [("I", 1)] * 6 + [("F", 1), ("F", 1), ("I", 4), ("I", 1)] +
                        [("H", 1)] * 8 + [("H", 2)] + [("H", 1)] * 11 + [("B", 1)] * 4 + [("B", 3)] +
                        [("B", 1)] * 6 + [("B", 10)] + [("B", 1)] * 7)

STORAGE_NONE, STORAGE_BITPACKED, STORAGE_COMMON, STORAGE_INDEXED, STORAGE_INDEXED_ARRAY, \
    STORAGE_SIGNED = range(6)


def _bits(rec: bytes, offset: int, size: int) -> int:
    start = offset >> 3
    end = (offset + size + 7) >> 3
    return (int.from_bytes(rec[start:end], "little") >> (offset & 7)) & ((1 << size) - 1)


class Wdc3:
    HEADER = struct.Struct("<4s9IHH7I")
    SECTION = struct.Struct("<Q8I")
    STORAGE = struct.Struct("<HHIIIII")

    def __init__(self, data: bytes, meta=None):
        if data[:4] != b"WDC3":
            raise Db2Error("not a WDC3 file")
        h = self.HEADER.unpack_from(data, 0)
        (_, self.record_count, self.field_count, self.record_size, self.string_size, _th, _lh,
         _min, _max, _loc, self.flags, self.id_index, _total, _bp_off, _lookup, storage_size,
         common_size, pallet_size, section_count) = h
        pos = self.HEADER.size
        sections = []
        for _ in range(section_count):
            sections.append(self.SECTION.unpack_from(data, pos))
            pos += self.SECTION.size
        # field_structure: bytes per value = 4 - unused_bits / 8 (only needed for sparse files)
        self.field_bytes = [4 - struct.unpack_from("<h", data, pos + 4 * f)[0] // 8
                            for f in range(self.field_count)]
        pos += self.field_count * 4
        self.storage = []
        for _ in range(storage_size // self.STORAGE.size):
            self.storage.append(self.STORAGE.unpack_from(data, pos))
            pos += self.STORAGE.size
        pallet = data[pos:pos + pallet_size]
        pos += pallet_size
        common = data[pos:pos + common_size]

        # each field's slice of the pallet / common blocks, in field order
        self.pallets, self.commons = {}, {}
        p_off = c_off = 0
        for f, (_o, _s, extra, stype, a, b, c) in enumerate(self.storage):
            if stype in (STORAGE_INDEXED, STORAGE_INDEXED_ARRAY):
                self.pallets[f] = struct.unpack_from(f"<{extra // 4}I", pallet, p_off)
                p_off += extra
            elif stype == STORAGE_COMMON:
                pairs = struct.unpack_from(f"<{extra // 4}I", common, c_off)
                self.commons[f] = (a, dict(zip(pairs[0::2], pairs[1::2])))
                c_off += extra

        self.records = []  # (id, record bytes, global index)
        self.sparse = bool(self.flags & 1)
        if self.sparse:
            if meta is None or len(meta) != self.field_count:
                raise Db2Error("sparse WDC3 file needs its field layout")
            self.meta = meta
            self._load_sparse(data, sections)
            return
        strings = bytearray()
        global_index = 0
        for (_key, file_offset, n, s_size, _end, id_size, rel_size, _om, copy_count) in sections:
            p = file_offset
            block = data[p:p + n * self.record_size]
            p += n * self.record_size
            strings += data[p:p + s_size]
            p += s_size
            ids = struct.unpack_from(f"<{id_size // 4}I", data, p) if id_size else ()
            p += id_size
            copies = struct.unpack_from(f"<{copy_count * 2}I", data, p) if copy_count else ()
            section_rows = {}
            for r in range(n):
                rec = block[r * self.record_size:(r + 1) * self.record_size] + b"\0" * 8
                if ids:
                    rid = ids[r] if r < len(ids) else 0
                else:  # no id list: the id is one of the fields
                    rid = self.value(0, rec, self.id_index)
                if rid:
                    self.records.append((rid, rec, global_index + r))
                    section_rows[rid] = (rec, global_index + r)
            for new_id, old_id in zip(copies[0::2], copies[1::2]):
                if old_id in section_rows:
                    rec, gi = section_rows[old_id]
                    self.records.append((new_id, rec, gi))
            global_index += n
        self.strings = bytes(strings)

    def _load_sparse(self, data, sections):
        """Records of varying size listed in an offset map; strings sit inline in the record.

        Per section, at offset_records_end: record ids (uint32 x n), copy table (uint32 new, uint32 source
        x copy_count), offset map (uint32 file offset, uint16 size x n). Same order as BFA-HavenCore's
        DB2FileLoaderSparseImpl::LoadCatalogData.
        """
        for (_key, _file_offset, _n, _s, end, _id_size, _rel, count, copy_count) in sections:
            p = end
            if not count or p + count * 10 + copy_count * 8 > len(data):
                continue
            ids = struct.unpack_from(f"<{count}I", data, p)
            p += count * 4
            copies = struct.unpack_from(f"<{copy_count * 2}I", data, p)
            p += copy_count * 8
            by_id = {}
            for n in range(count):
                offset, size = struct.unpack_from("<IH", data, p + n * 6)
                if not ids[n] or not size or offset + size > len(data):
                    continue  # encrypted section left empty, or a hole in the id range
                rec = data[offset:offset + size]
                self.records.append((ids[n], rec, 0))
                by_id[ids[n]] = rec
            for new_id, old_id in zip(copies[0::2], copies[1::2]):
                if old_id in by_id:
                    self.records.append((new_id, by_id[old_id], 0))

    def sparse_fields(self, rec: bytes, wanted) -> dict:
        """Read the wanted fields of a sparse record: {field: int or str}.

        Fields are packed one after another and strings are NUL-terminated, so only the strings move the
        fields behind them. Fixed-size fields after the last string are looked up by a precomputed offset.
        """
        if not hasattr(self, "_tail"):
            last_string = max((f for f, (k, _) in enumerate(self.meta) if k == "S"), default=-1)
            self._tail_start = last_string + 1
            self._tail, off = {}, 0
            for f in range(self._tail_start, len(self.meta)):
                kind, count = self.meta[f]
                width = 4 if kind == "F" else self.field_bytes[f]
                self._tail[f] = (off, width)
                off += width * count
        out, pos = {}, 0
        for f in range(self._tail_start):
            kind, count = self.meta[f]
            for _ in range(count):
                if kind == "S":
                    end = rec.find(b"\0", pos)
                    end = len(rec) if end < 0 else end
                    value, pos = rec[pos:end].decode("utf-8", "replace"), end + 1
                else:
                    width = 4 if kind == "F" else self.field_bytes[f]
                    value, pos = int.from_bytes(rec[pos:pos + width], "little"), pos + width
                if f in wanted and f not in out:
                    out[f] = value
        for f in wanted:
            if f >= self._tail_start:
                off, width = self._tail[f]
                out[f] = int.from_bytes(rec[pos + off:pos + off + width], "little")
        return out

    def value(self, rid: int, rec: bytes, f: int) -> int:
        offset, size, _extra, stype, a, b, c = self.storage[f]
        if stype == STORAGE_NONE:
            return int.from_bytes(rec[offset >> 3:(offset >> 3) + size // 8], "little")
        if stype in (STORAGE_BITPACKED, STORAGE_SIGNED):
            v = _bits(rec, offset, size)
            if stype == STORAGE_SIGNED and v >> (size - 1):
                v -= 1 << size
            return v
        if stype == STORAGE_COMMON:
            default, values = self.commons[f]
            return values.get(rid, default)
        if stype == STORAGE_INDEXED:
            return self.pallets[f][_bits(rec, offset, size)]
        if stype == STORAGE_INDEXED_ARRAY:
            return self.pallets[f][_bits(rec, offset, size) * c]
        raise Db2Error(f"unknown storage type {stype}")

    def string(self, rec: bytes, global_index: int, f: int) -> str:
        field_byte = self.storage[f][0] >> 3
        ofs = int.from_bytes(rec[field_byte:field_byte + 4], "little")
        # offsets count from the field itself, as if all records were followed by all string tables
        pos = global_index * self.record_size + field_byte + ofs - self.record_count * self.record_size
        return _cstr(self.strings, pos)


def read_wdc3_itemsparse(data: bytes) -> Iterator[ItemInfo]:
    fields = struct.unpack_from("<I", data, 8)[0] if data[:4] == b"WDC3" else 0
    if fields != WDC3_ITEMSPARSE_FIELDS:
        raise Db2Error(f"unexpected ItemSparse layout ({fields} fields, expected 62 for 8.3.7)")
    db = Wdc3(data, WDC3_ITEMSPARSE_META)
    if db.sparse:
        want = (WDC3_NAME, WDC3_BUYPRICE, WDC3_BUYCOUNT, WDC3_QUALITY)
        for rid, rec, _gi in db.records:
            v = db.sparse_fields(rec, want)
            yield ItemInfo(rid, v[WDC3_NAME], v[WDC3_QUALITY] & 0xFF, v[WDC3_BUYPRICE],
                           max(v[WDC3_BUYCOUNT], 1))
        return
    for rid, rec, gi in db.records:
        yield ItemInfo(rid, db.string(rec, gi, WDC3_NAME), db.value(rid, rec, WDC3_QUALITY) & 0xFF,
                       db.value(rid, rec, WDC3_BUYPRICE), max(db.value(rid, rec, WDC3_BUYCOUNT), 1))


# ---------------------------------------------------------------- lookup

def find_itemsparse(folder: Path) -> Optional[Path]:
    """The dbc folder (or the server data folder above it) -> the item table file."""
    folder = Path(folder).expanduser()
    for name in ("ItemSparse.db2", "Item-sparse.db2"):
        for candidate in [folder / name, folder / "dbc" / name]:
            if candidate.is_file():
                return candidate
        for locale in ("enUS", "enGB"):
            for base in (folder, folder / "dbc"):
                if (base / locale / name).is_file():
                    return base / locale / name
        hits = sorted(folder.glob(f"**/{name}"))
        if hits:
            return hits[0]
    return None


def load_items(path: Path) -> Dict[int, ItemInfo]:
    data = Path(path).read_bytes()
    if data[:4] == b"WDB2":
        rows = read_wdb2_itemsparse(data)
    elif data[:4] == b"WDC3":
        rows = read_wdc3_itemsparse(data)
    else:
        raise Db2Error(f"{path.name}: unsupported format {data[:4]!r}")
    return {i.id: i for i in rows if i.id}
