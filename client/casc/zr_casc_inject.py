#!/usr/bin/env python3
"""Put an edited Blackrock Depths root WMO into a WoW Circle 8.3.7 client, the way a patch would.

The client verifies every stored file against its key, so the original data is never edited.
Instead this adds new, correctly keyed entries and points the client at them:

  1. the edited WMO (new content key, new encoded key)
  2. a new ROOT file: file ID 108299 -> the edited WMO
  3. a new ENCODING file that also knows both new files
  4. a new build config naming the new ROOT and ENCODING
  5. .fzbuildnfo (WoW Circle's renamed .build.info) switched to the new build config

The three new files go into a new Data/data/data.NNN, and their keys are added to the .idx files
(the original .idx files are backed up first). Nothing else changes, so 'uninject' only has to
point .fzbuildnfo back at the original build config.

Needs offline mode: .fzbuildnfo present and WoW Circle's patch server blocked (otherwise the
client asks that server which build to use and ignores ours).

Usage (game closed):
  python3 zr_casc_inject.py "<client folder>" status
  python3 zr_casc_inject.py "<client folder>" inject off|swap|probe
  python3 zr_casc_inject.py "<client folder>" uninject
"""
import hashlib
import json
import os
import shutil
import struct
import sys
import zlib

WMO_FDID = 108299
WMO_CKEY = bytes.fromhex("ba1f2379e67cfe1f5ecdf70469363c1c")     # blackrock_lower_instance.wmo (35662)
MFOG_DATA = 103160
MFOG_COUNT = 9
VARIANT_MD5 = {
    "original": "ba1f2379e67cfe1f5ecdf70469363c1c",
    "off": "1da7587f5a744ccc335be5ab5d31234f",
    "swap": "6e3f8087c7fb64fc719793da9d0ab9ab",
    "probe": "338b43010004c7df669ebca381c57ddd",
}
BACKUP_DIR = "zr_casc_backup"
INFO_NAMES = (".fzbuildnfo",)


class Fail(Exception):
    pass


def md5(b):
    return hashlib.md5(b).digest()


# --------------------------------------------------------------------------- the edit

def make_variant(orig, name):
    d = bytearray(orig)
    if d[MFOG_DATA - 8:MFOG_DATA - 4] != b"GOFM" or struct.unpack_from("<I", d, MFOG_DATA - 4)[0] != 48 * MFOG_COUNT:
        raise Fail("the WMO has no 9-entry MFOG chunk where expected")
    if name == "probe":                       # test only: all 57 materials use material 0's texture
        tex = d[104:108]
        for i in range(57):
            d[92 + 64 * i + 12:92 + 64 * i + 16] = tex
    for i in range(MFOG_COUNT if name in ("off", "swap") else 0):
        e = MFOG_DATA + 48 * i
        if name == "off":
            d[e + 16:e + 24] = bytes(8)          # smaller + larger radius = 0
        else:
            for c in (e + 32, e + 44):           # fog + underwater colour, swap B and R
                d[c], d[c + 2] = d[c + 2], d[c]
    d = bytes(d)
    if name not in VARIANT_MD5 or hashlib.md5(d).hexdigest() != VARIANT_MD5[name]:
        raise Fail("built '%s' variant does not match the expected file" % name)
    return d


def state_of(content):
    h = hashlib.md5(content).hexdigest()
    for k, v in VARIANT_MD5.items():
        if v == h:
            return k
    return "unknown (" + h + ")"


# --------------------------------------------------------------------------- paths / config

def cpath(base, *parts):
    p = base
    for part in parts:
        q = os.path.join(p, part)
        if not os.path.exists(q) and os.path.isdir(p):
            for name in os.listdir(p):
                if name.lower() == part.lower():
                    q = os.path.join(p, name)
                    break
        p = q
    return p


def info_file(client):
    for n in INFO_NAMES:
        p = os.path.join(client, n)
        if os.path.isfile(p):
            return p
    return None


def info_build_key(path):
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        lines = [l.rstrip("\r\n") for l in f if l.strip()]
    cols = [c.split("!")[0] for c in lines[0].split("|")]
    for row in lines[1:]:
        rec = dict(zip(cols, row.split("|")))
        if rec.get("Active", "1") == "1" and rec.get("Build Key"):
            return rec["Build Key"].strip().lower()
    raise Fail("no active Build Key in " + path)


def config_path(client, key):
    return cpath(client, "Data", "config", key[0:2], key[2:4], key)


def read_config(client, key):
    p = config_path(client, key)
    if not os.path.isfile(p):
        raise Fail("build config %s not found" % key)
    with open(p, "rb") as f:
        raw = f.read()
    if hashlib.md5(raw).hexdigest() != key:
        raise Fail("build config %s does not match its name" % key)
    kv = {}
    for line in raw.decode("utf-8", "replace").splitlines():
        if " = " in line:
            k, v = line.split(" = ", 1)
            kv[k.strip()] = v.split()
    return raw, kv


# --------------------------------------------------------------------------- Jenkins lookup3

_M32 = 0xFFFFFFFF


def _rot(x, k):
    return ((x << k) | (x >> (32 - k))) & _M32


def _mix(a, b, c):
    a = (a - c) & _M32; a ^= _rot(c, 4); c = (c + b) & _M32
    b = (b - a) & _M32; b ^= _rot(a, 6); a = (a + c) & _M32
    c = (c - b) & _M32; c ^= _rot(b, 8); b = (b + a) & _M32
    a = (a - c) & _M32; a ^= _rot(c, 16); c = (c + b) & _M32
    b = (b - a) & _M32; b ^= _rot(a, 19); a = (a + c) & _M32
    c = (c - b) & _M32; c ^= _rot(b, 4); b = (b + a) & _M32
    return a, b, c


def _final(a, b, c):
    c ^= b; c = (c - _rot(b, 14)) & _M32
    a ^= c; a = (a - _rot(c, 11)) & _M32
    b ^= a; b = (b - _rot(a, 25)) & _M32
    c ^= b; c = (c - _rot(b, 16)) & _M32
    a ^= c; a = (a - _rot(c, 4)) & _M32
    b ^= a; b = (b - _rot(a, 14)) & _M32
    c ^= b; c = (c - _rot(b, 24)) & _M32
    return a, b, c


def hashlittle2(data, pc=0, pb=0):
    length = len(data)
    a = b = c = (0xDEADBEEF + length + pc) & _M32
    c = (c + pb) & _M32
    i = 0
    while length > 12:
        a = (a + int.from_bytes(data[i:i + 4], "little")) & _M32
        b = (b + int.from_bytes(data[i + 4:i + 8], "little")) & _M32
        c = (c + int.from_bytes(data[i + 8:i + 12], "little")) & _M32
        a, b, c = _mix(a, b, c)
        length -= 12
        i += 12
    if length == 0:
        return c, b
    tail = data[i:i + length] + bytes(12 - length)
    a = (a + int.from_bytes(tail[0:4], "little")) & _M32
    b = (b + int.from_bytes(tail[4:8], "little")) & _M32
    c = (c + int.from_bytes(tail[8:12], "little")) & _M32
    a, b, c = _final(a, b, c)
    return c, b


def hashlittle(data, initval=0):
    return hashlittle2(data, initval, 0)[0]


_OFFS_TABLE = [0x049396B8, 0x72A82A9B, 0xEE626CCA, 0x9917754F, 0x15DE40B1, 0xF5A8A9B6, 0x421EAC7E, 0xA9D55C9A,
               0x317FD40C, 0x04FAF80D, 0x3D6BE971, 0x52933CFD, 0x27F64B7D, 0xC6F5C11B, 0xD5757E3A, 0x6C388745]


def span_header(ekey, blte_len, offset, flags=b"\0\0"):
    """30-byte header in front of each file in data.NNN (layout and checksums as in CascLib)."""
    h = ekey[::-1] + struct.pack("<I", blte_len + 30) + flags
    jen = hashlittle(h, 0x3D6BE971).to_bytes(4, "little")
    v = (offset + 30) & _M32
    enc_off = (_OFFS_TABLE[v & 0xF] ^ v).to_bytes(4, "little")
    hh = bytearray(4)
    part = h + jen
    for i in range(0x1A):
        hh[i & 3] ^= part[i]
    chk = bytes(hh[(0x1A + j) & 3] ^ enc_off[(0x1A + j) & 3] for j in range(4))
    return h + jen + chk


# --------------------------------------------------------------------------- local storage

def bucket_of(ekey):
    x = 0
    for b in ekey[:9]:
        x ^= b
    return (x & 0xF) ^ (x >> 4)


class IdxFile:
    def __init__(self, path):
        self.path = path
        with open(path, "rb") as f:
            self.raw = bytearray(f.read())
        hsize, hhash = struct.unpack_from("<II", self.raw, 0)
        if hsize != 16 or hashlittle(bytes(self.raw[8:24]), 0) != hhash:
            raise Fail("unexpected index header in " + path)
        rev, self.bucket, _, sz_b, off_b, key_b, self.seg_bits = struct.unpack_from("<HBBBBBB", self.raw, 8)
        self.max_size = struct.unpack_from("<Q", self.raw, 16)[0]
        if rev != 7 or (sz_b, off_b, key_b) != (4, 5, 9):
            raise Fail("unexpected index format in " + path)
        self.blk = 32
        bsz = struct.unpack_from("<I", self.raw, self.blk)[0]
        self.entries = [bytes(self.raw[40 + 18 * i:40 + 18 * i + 18]) for i in range(bsz // 18)]

    def find(self, ekey):
        for e in self.entries:
            if e[:9] == ekey[:9]:
                so = int.from_bytes(e[9:14], "big")
                return so >> self.seg_bits, so & ((1 << self.seg_bits) - 1), struct.unpack_from("<I", e, 14)[0]
        return None

    def add(self, ekey, archive, offset, size):
        e = ekey[:9] + ((archive << self.seg_bits) | offset).to_bytes(5, "big") + struct.pack("<I", size)
        ents = [x for x in self.entries if x[:9] != ekey[:9]] + [e]
        ents.sort(key=lambda x: x[:9])
        body = b"".join(ents)
        if 40 + len(body) > len(self.raw):
            raise Fail("no room in " + os.path.basename(self.path))
        pc = pb = 0
        for x in ents:
            pc, pb = hashlittle2(x, pc, pb)
        old_len = 18 * len(self.entries)
        self.raw[self.blk:self.blk + 8] = struct.pack("<II", len(body), pc)
        self.raw[40:40 + max(old_len, len(body))] = body + bytes(max(0, old_len - len(body)))
        self.entries = ents

    def save(self):
        with open(self.path, "r+b") as f:
            f.write(self.raw)
            f.flush()
            os.fsync(f.fileno())


class Storage:
    def __init__(self, client):
        self.client = client
        self.dir = cpath(client, "Data", "data")
        self.by_bucket = {}
        for fn in os.listdir(self.dir):
            if fn.lower().endswith(".idx") and len(fn) == 14:
                try:
                    b, v = int(fn[0:2], 16), int(fn[2:10], 16)
                except ValueError:
                    continue
                self.by_bucket.setdefault(b, []).append((v, os.path.join(self.dir, fn)))
        if len(self.by_bucket) != 16:
            raise Fail("expected 16 index buckets in " + self.dir)
        for b in self.by_bucket:
            self.by_bucket[b].sort()
        self._cache = {}

    def newest(self, bucket):
        p = self.by_bucket[bucket][-1][1]
        if p not in self._cache:
            self._cache[p] = IdxFile(p)
        return self._cache[p]

    def all_idx(self, bucket):
        out = []
        for _, p in self.by_bucket[bucket]:
            if p not in self._cache:
                self._cache[p] = IdxFile(p)
            out.append(self._cache[p])
        return out

    def data_path(self, archive):
        return os.path.join(self.dir, "data.%03d" % archive)

    def locate(self, ekey):
        loc = self.newest(bucket_of(ekey)).find(ekey)
        if loc is None:
            raise Fail("encoded key %s is not in local storage" % ekey.hex())
        return loc

    def read(self, ekey):
        arc, off, size = self.locate(ekey)
        with open(self.data_path(arc), "rb") as f:
            f.seek(off)
            span = f.read(size)
        if len(span) != size or span[0:16][::-1][:9] != ekey[:9] or span[30:34] != b"BLTE":
            raise Fail("stored data for %s is not valid" % ekey.hex())
        blte = span[30:]
        if blte_ekey(blte) != ekey:
            raise Fail("stored data for %s does not match its key" % ekey.hex())
        return span, blte

    def archives(self):
        return sorted(int(f[5:]) for f in os.listdir(self.dir) if f.lower().startswith("data.") and f[5:].isdigit())


# --------------------------------------------------------------------------- BLTE

def blte_parse(blte):
    if blte[0:4] != b"BLTE":
        raise Fail("no BLTE signature")
    hsize = struct.unpack_from(">I", blte, 4)[0]
    if hsize == 0:
        return 0, [(blte[8:], None)]
    count = int.from_bytes(blte[9:12], "big")
    frames, pos = [], hsize
    for i in range(count):
        esize, csize = struct.unpack_from(">II", blte, 12 + 24 * i)
        frames.append((blte[pos:pos + esize], csize))
        pos += esize
    return hsize, frames


def blte_ekey(blte):
    hsize = struct.unpack_from(">I", blte, 4)[0]
    return md5(blte[0:hsize]) if hsize else md5(blte)


def _frame_decode(enc):
    if enc[0:1] == b"N":
        return enc[1:]
    if enc[0:1] == b"Z":
        return zlib.decompress(enc[1:])
    raise Fail("unsupported BLTE frame mode %r" % enc[0:1])


def blte_decode(blte):
    return b"".join(_frame_decode(f) for f, _ in blte_parse(blte)[1])


def blte_encode_like(orig_blte, data):
    """Encode data with the same frame layout (frame sizes and modes) as an existing BLTE file."""
    hsize, frames = blte_parse(orig_blte)

    def enc(mode, chunk):
        return (b"N" + chunk) if mode == b"N" else (b"Z" + zlib.compress(chunk, 6))

    if hsize == 0:
        return b"BLTE" + bytes(4) + enc(frames[0][0][0:1], data)
    sizes = [c for _, c in frames]
    modes = [f[0:1] for f, _ in frames]
    if sum(sizes) != len(data):                 # size changed: keep the first frame's size for all
        step = sizes[0]
        sizes = [min(step, len(data) - i) for i in range(0, len(data), step)]
        modes = [b"Z"] * len(sizes)
    out, pos = [], 0
    for m, s in zip(modes, sizes):
        out.append(enc(m, data[pos:pos + s]))
        pos += s
    head = b"BLTE" + struct.pack(">I", 12 + 24 * len(out)) + b"\x0f" + len(out).to_bytes(3, "big")
    for f, s in zip(out, sizes):
        head += struct.pack(">II", len(f), s) + md5(f)
    blte = head + b"".join(out)
    if blte_decode(blte) != data:
        raise Fail("BLTE self-check failed")
    return blte


# --------------------------------------------------------------------------- ENCODING

class Encoding:
    """ENCODING manifest. Pages we do not touch are written back byte for byte; a page that gets
    a new entry is re-serialized, and split in two if it no longer fits."""

    def __init__(self, raw):
        if raw[0:2] != b"EN" or raw[2] != 1 or raw[3] != 16 or raw[4] != 16:
            raise Fail("unexpected ENCODING header")
        self.raw = raw
        self.cpsize = struct.unpack_from(">H", raw, 5)[0] * 1024
        self.epsize = struct.unpack_from(">H", raw, 7)[0] * 1024
        ccount, ecount = struct.unpack_from(">II", raw, 9)
        self.unk = raw[17]
        espec_size = struct.unpack_from(">I", raw, 18)[0]
        self.espec_block = raw[22:22 + espec_size]
        self.especs = self.espec_block.split(b"\0")
        p = 22 + espec_size
        self.cpages = self._read_pages(raw, p, ccount, self.cpsize, self._centries)
        p += ccount * (32 + self.cpsize)
        self.epages = self._read_pages(raw, p, ecount, self.epsize, self._eentries)
        p += ecount * (32 + self.epsize)
        self.trailer = raw[p:]
        self.epad = None
        for pg in self.epages:
            used = sum(len(e) for e in pg["entries"])
            if len(pg["bytes"]) - used >= 25:
                self.epad = pg["bytes"][used:used + 25]
                break
        if self.epad is None:
            self.epad = bytes(16) + b"\xff\xff\xff\xff" + bytes(5)

    @staticmethod
    def _read_pages(raw, p, count, size, parse):
        index = raw[p:p + 32 * count]
        base = p + 32 * count
        pages = []
        for i in range(count):
            page = raw[base + i * size:base + (i + 1) * size]
            if md5(page) != index[32 * i + 16:32 * i + 32]:
                raise Fail("ENCODING page checksum mismatch")
            pages.append({"first": index[32 * i:32 * i + 16], "bytes": page, "entries": parse(page), "dirty": False})
        return pages

    @staticmethod
    def _centries(page):
        out, q = [], 0
        while q + 6 <= len(page) and page[q] != 0:
            ln = 6 + 16 + 16 * page[q]
            out.append(page[q:q + ln])
            q += ln
        return out

    def _eentries(self, page):
        out, q = [], 0
        n_specs = len(self.especs)
        while q + 25 <= len(page):
            e = page[q:q + 25]
            if e[0:16] == bytes(16) or struct.unpack_from(">I", e, 16)[0] >= n_specs:
                break
            out.append(e)
            q += 25
        return out

    def ekeys_for(self, ckey):
        for pg in self.cpages:
            for e in pg["entries"]:
                if e[6:22] == ckey:
                    return [e[22 + 16 * k:38 + 16 * k] for k in range(e[0])]
        return []

    def espec_index(self, ekey):
        for pg in self.epages:
            for e in pg["entries"]:
                if e[0:16] == ekey:
                    return struct.unpack_from(">I", e, 16)[0]
        raise Fail("no encoding spec for " + ekey.hex())

    @staticmethod
    def _insert(pages, key, entry, keyof):
        i = 0
        for j, pg in enumerate(pages):
            if pg["first"] <= key:
                i = j
        pg = pages[i]
        ents = [e for e in pg["entries"] if keyof(e) != key] + [entry]
        ents.sort(key=keyof)
        pg["entries"], pg["dirty"] = ents, True

    def add(self, ckey, csize, ekey, espec_idx, esize):
        self._insert(self.cpages, ckey, b"\x01" + csize.to_bytes(5, "big") + ckey + ekey, lambda e: e[6:22])
        self._insert(self.epages, ekey, ekey + struct.pack(">I", espec_idx) + esize.to_bytes(5, "big"), lambda e: e[0:16])

    @staticmethod
    def _serialize(pages, size, pad_unit, keyof):
        out = []
        for pg in pages:
            if not pg["dirty"]:
                out.append((pg["first"], pg["bytes"]))
                continue
            groups, cur = [], []
            for e in pg["entries"]:
                if sum(len(x) for x in cur) + len(e) > size:
                    groups.append(cur)
                    cur = []
                cur.append(e)
            groups.append(cur)
            if len(groups) == 2:                       # split evenly so both halves have room
                allents = groups[0] + groups[1]
                half = len(allents) // 2
                groups = [allents[:half], allents[half:]]
            for g in groups:
                body = b"".join(g)
                fill = size - len(body)
                if fill < 0:
                    raise Fail("ENCODING page overflow")
                out.append((keyof(g[0]), body + (pad_unit * (fill // len(pad_unit) + 1))[:fill]))
        return out

    def build(self):
        cp = self._serialize(self.cpages, self.cpsize, b"\0", lambda e: e[6:22])
        ep = self._serialize(self.epages, self.epsize, self.epad, lambda e: e[0:16])
        head = b"EN\x01\x10\x10" + struct.pack(">HHII", self.cpsize // 1024, self.epsize // 1024, len(cp), len(ep))
        head += bytes([self.unk]) + struct.pack(">I", len(self.espec_block)) + self.espec_block
        out = [head]
        out += [f + md5(b) for f, b in cp] + [b for _, b in cp]
        out += [f + md5(b) for f, b in ep] + [b for _, b in ep]
        out.append(self.trailer)
        return b"".join(out)


# --------------------------------------------------------------------------- ROOT (8.x TSFM / legacy)

def root_blocks(root):
    pos = 12 if root[0:4] == b"TSFM" else 0
    while pos + 12 <= len(root):
        n, cflags, lflags = struct.unpack_from("<III", root, pos)
        start = pos
        pos += 12
        deltas = struct.unpack_from("<%di" % n, root, pos)
        pos += 4 * n
        ck_at = pos
        pos += 16 * n
        if not (root[0:4] == b"TSFM" and cflags & 0x10000000):
            pos += 8 * n
        fd = -1
        ids = []
        for d in deltas:
            fd += d + 1
            ids.append(fd)
        yield start, ids, ck_at


def root_get(root, fdid):
    out = []
    for _, ids, ck_at in root_blocks(root):
        for i, f in enumerate(ids):
            if f == fdid:
                out.append(root[ck_at + 16 * i:ck_at + 16 * i + 16])
    return out


def root_replace(root, fdid, old, new):
    r = bytearray(root)
    n = 0
    for _, ids, ck_at in root_blocks(root):
        for i, f in enumerate(ids):
            if f == fdid and r[ck_at + 16 * i:ck_at + 16 * i + 16] == old:
                r[ck_at + 16 * i:ck_at + 16 * i + 16] = new
                n += 1
    if n == 0:
        raise Fail("file %d not found in ROOT" % fdid)
    return bytes(r)


# --------------------------------------------------------------------------- reading a build

def load_build(st, client, key):
    raw, kv = read_config(client, key)
    enc_ck, enc_ek = bytes.fromhex(kv["encoding"][0]), bytes.fromhex(kv["encoding"][1])
    _, enc_blte = st.read(enc_ek)
    enc_raw = blte_decode(enc_blte)
    if md5(enc_raw) != enc_ck:
        raise Fail("ENCODING content does not match the build config")
    enc = Encoding(enc_raw)
    root_ck = bytes.fromhex(kv["root"][0])
    root_ek = enc.ekeys_for(root_ck)[0]
    _, root_blte = st.read(root_ek)
    root = blte_decode(root_blte)
    if md5(root) != root_ck:
        raise Fail("ROOT content does not match its key")
    return {"key": key, "raw": raw, "kv": kv, "enc": enc, "enc_raw": enc_raw, "enc_blte": enc_blte,
            "root": root, "root_ck": root_ck, "root_ek": root_ek, "root_blte": root_blte}


def wmo_of(st, b):
    cks = set(root_get(b["root"], WMO_FDID))
    if len(cks) != 1:
        raise Fail("file %d has %d different content keys in ROOT" % (WMO_FDID, len(cks)))
    ck = cks.pop()
    ek = b["enc"].ekeys_for(ck)[0]
    _, blte = st.read(ek)
    data = blte_decode(blte)
    if md5(data) != ck:
        raise Fail("WMO content does not match its key")
    return ck, ek, blte, data


# --------------------------------------------------------------------------- commands

def state_path(client):
    return os.path.join(client, BACKUP_DIR, "inject.json")


def load_state(client):
    p = state_path(client)
    if os.path.isfile(p):
        with open(p) as f:
            return json.load(f)
    return None


def cmd_status(client):
    info = info_file(client)
    if not info:
        print("no .fzbuildnfo: the client is in online mode and uses WoW Circle's patch server")
        return
    st = Storage(client)
    key = info_build_key(info)
    b = load_build(st, client, key)
    ck, ek, blte, data = wmo_of(st, b)
    s = load_state(client)
    print("build config  %s%s" % (key, "  (injected; original %s)" % s["orig_key"] if s and s.get("new_key") == key else ""))
    print("WMO %d       ckey %s ekey %s" % (WMO_FDID, ck.hex(), ek.hex()))
    print("WMO state     %s" % state_of(data))


def cmd_inject(client, variant):
    info = info_file(client)
    if not info:
        raise Fail("no .fzbuildnfo in the client folder; set up offline mode first")
    st = Storage(client)
    s = load_state(client) or {}
    cur_key = info_build_key(info)
    base_key = s.get("orig_key", cur_key) if s.get("new_key") == cur_key else cur_key
    print("base build config %s" % base_key)
    print("reading ENCODING and ROOT ...", flush=True)
    b = load_build(st, client, base_key)
    if b["enc"].build() != b["enc_raw"]:
        raise Fail("ENCODING rebuild self-test failed on this client; nothing written")
    ck, ek, wmo_blte, wmo = wmo_of(st, b)
    if ck != WMO_CKEY:
        raise Fail("base build's WMO is not the original (%s)" % state_of(wmo))
    enc = b["enc"]

    new_wmo = make_variant(wmo, variant)
    w_blte = blte_encode_like(wmo_blte, new_wmo)
    w_ck, w_ek = md5(new_wmo), blte_ekey(w_blte)

    print("building new ROOT ...", flush=True)
    new_root = root_replace(b["root"], WMO_FDID, ck, w_ck)
    r_blte = blte_encode_like(b["root_blte"], new_root)
    r_ck, r_ek = md5(new_root), blte_ekey(r_blte)

    enc.add(w_ck, len(new_wmo), w_ek, enc.espec_index(ek), len(w_blte))
    enc.add(r_ck, len(new_root), r_ek, enc.espec_index(b["root_ek"]), len(r_blte))
    print("building new ENCODING ...", flush=True)
    new_enc = enc.build()
    e_blte = blte_encode_like(b["enc_blte"], new_enc)
    e_ck, e_ek = md5(new_enc), blte_ekey(e_blte)
    if Encoding(new_enc).ekeys_for(w_ck) != [w_ek] or Encoding(new_enc).ekeys_for(r_ck) != [r_ek]:
        raise Fail("new ENCODING self-check failed")

    # new build config
    lines = []
    for line in b["raw"].decode("utf-8").split("\n"):
        k = line.split(" = ", 1)[0] if " = " in line else None
        if k == "root":
            line = "root = " + r_ck.hex()
        elif k == "encoding":
            line = "encoding = %s %s" % (e_ck.hex(), e_ek.hex())
        elif k == "encoding-size":
            line = "encoding-size = %d %d" % (len(new_enc), len(e_blte))
        lines.append(line)
    new_cfg = "\n".join(lines).encode("utf-8")
    new_key = hashlib.md5(new_cfg).hexdigest()

    print("writing ...", flush=True)
    # back up everything that is changed in place
    bdir = os.path.join(client, BACKUP_DIR)
    os.makedirs(os.path.join(bdir, "idx"), exist_ok=True)
    if not os.path.isfile(os.path.join(bdir, "fzbuildnfo.orig")):
        shutil.copy2(info, os.path.join(bdir, "fzbuildnfo.orig"))
    blobs = [(w_ek, w_blte), (r_ek, r_blte), (e_ek, e_blte)]
    for bk in sorted({bucket_of(e) for e, _ in blobs}):
        for x in st.all_idx(bk):
            dst = os.path.join(bdir, "idx", os.path.basename(x.path))
            if not os.path.isfile(dst):
                shutil.copy2(x.path, dst)

    # data file: our own, appended
    arc = s.get("archive")
    if arc is None or not os.path.isfile(st.data_path(arc)):
        arc = st.archives()[-1] + 1
        open(st.data_path(arc), "wb").close()
    max_size = st.newest(0).max_size
    with open(st.data_path(arc), "r+b") as f:
        f.seek(0, 2)
        off = f.tell()
        for ekey, blte in blobs:
            if off + 30 + len(blte) > max_size:
                raise Fail("data.%03d would exceed the data file size limit" % arc)
            span = span_header(ekey, len(blte), off) + blte
            f.write(span)
            for x in st.all_idx(bucket_of(ekey)):
                x.add(ekey, arc, off, len(span))
            off += len(span)
        f.flush()
        os.fsync(f.fileno())
    for bk in sorted({bucket_of(e) for e, _ in blobs}):
        for x in st.all_idx(bk):
            x.save()

    cp = config_path(client, new_key)
    if not os.path.isdir(os.path.dirname(cp)):
        cp = os.path.join(cpath(client, "Data", "config"), new_key[0:2], new_key[2:4], new_key)
        os.makedirs(os.path.dirname(cp), exist_ok=True)
    with open(cp, "wb") as f:
        f.write(new_cfg)

    with open(info, "r", encoding="utf-8") as f:
        txt = f.read()
    with open(info, "w", encoding="utf-8", newline="") as f:
        f.write(txt.replace(cur_key, new_key))

    s.update({"orig_key": base_key, "new_key": new_key, "archive": arc, "variant": variant})
    with open(state_path(client), "w") as f:
        json.dump(s, f, indent=1)

    # read it all back the way the client will
    st2 = Storage(client)
    b2 = load_build(st2, client, info_build_key(info))
    got = wmo_of(st2, b2)[3]
    print("new build config %s (data.%03d, %d new files)" % (new_key, arc, len(blobs)))
    print("WMO %d now reads back as: %s" % (WMO_FDID, state_of(got)))
    if got != new_wmo:
        raise Fail("read-back mismatch")


def cmd_uninject(client):
    s = load_state(client)
    info = info_file(client)
    orig = os.path.join(client, BACKUP_DIR, "fzbuildnfo.orig")
    if not s or not info or not os.path.isfile(orig):
        raise Fail("nothing to undo")
    shutil.copy2(orig, info)
    s["new_key"] = None
    with open(state_path(client), "w") as f:
        json.dump(s, f, indent=1)
    print(".fzbuildnfo points at the original build config %s again" % info_build_key(info))


def main(argv):
    cmds = ("status", "inject", "uninject")
    if len(argv) < 3 or argv[2] not in cmds or (argv[2] == "inject" and (len(argv) < 4 or argv[3] not in ("off", "swap", "probe"))):
        print(__doc__)
        return 2
    client = argv[1]
    if not os.path.isdir(cpath(client, "Data", "data")):
        print("error: %s has no Data/data folder" % client)
        return 1
    try:
        if argv[2] == "status":
            cmd_status(client)
        elif argv[2] == "inject":
            cmd_inject(client, argv[3])
        else:
            cmd_uninject(client)
    except Fail as e:
        print("error: %s" % e)
        return 1
    except PermissionError as e:
        print("error: %s (close the game first)" % e)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
