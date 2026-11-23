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
  python3 zr_casc_inject.py "<client folder>" inject off|swap|probe|fogwide|liqfix|liqoff|lighttest|lightfix
      off/swap/probe edit the root WMO (MFOG / textures); fogwide gives all 9 MFOG fogs a
              5000-yard outer radius, so the camera is never outside the dungeon's own fog;
      liqfix: in the 6 BRD group files with liquid, the hidden liquid tiles' vertices (height 0.0)
              are lowered to the liquid's base height (the lava stays);
      liqoff: test only, every liquid tile in those 6 files is hidden (no lava surfaces)
      lighttest: test only, the default outdoor light (Light 1: params 3/10/12/13) gets pure
              green direct + ambient colour in LightData.db2
      lightfix: Light.db2 gets a map-wide light for Blackrock Depths (map 230) that uses an
              all-black LightParams, so the client stops falling back to the default
              outdoor light (blue at night) there
  python3 zr_casc_inject.py "<client folder>" inject file <file ID>=<path> [<file ID>=<path> ...]
      replaces whole files with your own (for example an edited login-screen Lua file found
      with 'find')
  python3 zr_casc_inject.py "<client folder>" uninject
  python3 zr_casc_inject.py "<client folder>" extract <out folder> brd|<file ID> [<file ID> ...]
      (read-only: writes files from the current build, 'brd' = the BRD root WMO and all its
       group files, and prints the liquid planes found in those group files)
  python3 zr_casc_inject.py "<client folder>" find <out folder> [--all] [<text> ...]
      (read-only: reads every stored text file (Lua, XML, TOC, ...) and lists the file IDs that
       contain one of the texts, ignoring case; default texts "fstorm" and "live changelog".
       --all also searches binary files (DB2 etc., UTF-8 and UTF-16), skipping textures, sound
       and models. Each hit is written to <out folder>/<file ID>.txt or .bin)
"""
import hashlib
import json
import re
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
    "fogwide": "7108ba85777e4c487a682d2b47ba7897",
}
# BRD group files that hold liquid (MLIQ), with their original content keys (35662)
LIQUID_GROUPS = {
    108314: "7b4c0c6778734868ef65be96634b1ac1",
    108328: "2082290989fc79cb9c951bc534e43aa9",
    108329: "b819e55468c4ca3ee3d1ed28fdaf30ff",
    108331: "51839c5a832c183959b43f7d31055eac",
    108337: "60100a37c11e62dcf5fc3f3b9ee46de4",
    108345: "de9ccd15a0aeaf40e73146a6122de399",
}
LIGHTDATA_FDID = 1375580
LIGHTDATA_CKEY = bytes.fromhex("b3d232221aca5f67caec330a2a6bacc5")   # LightData.db2 (35662)
WMO_VARIANTS = ("off", "swap", "probe", "fogwide")
LIGHT_FDID = 1375579
LIGHT_CKEY = bytes.fromhex("f54439ded7a87f04b0c304af5149ceb0")       # Light.db2 (35662)
BRD_MAP = 230
DARK_LIGHTPARAMS = 1989       # a LightParams with all-black colours, used by no Light row
LIGHT_VARIANTS = ("lighttest", "lightfix")
LIQUID_VARIANTS = ("liqfix", "liqoff")
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
    for i in range(MFOG_COUNT if name in ("off", "swap", "fogwide") else 0):
        e = MFOG_DATA + 48 * i
        if name == "fogwide":                 # larger radius 5000: the camera is always inside the fog
            struct.pack_into("<f", d, e + 20, 5000.0)
        elif name == "off":
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
            why = ("short read: got %d of %d bytes (file is %d bytes)" % (len(span), size, os.path.getsize(self.data_path(arc)))
                   if len(span) != size else "key in span header %s" % span[0:16][::-1].hex()
                   if span[0:16][::-1][:9] != ekey[:9] else "no BLTE signature")
            raise Fail("stored data for %s is not valid (data.%03d @%d size %d: %s; first bytes %s)"
                       % (ekey.hex(), arc, off, size, why, span[:40].hex()))
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


def blte_decode_lenient(blte):
    """Like blte_decode, but encrypted ('E') frames come back as zeros. Returns (data, n_encrypted)."""
    out, n = [], 0
    for f, csize in blte_parse(blte)[1]:
        if f[0:1] == b"E":
            n += 1
            out.append(b"\0" * (csize or 0))
        else:
            out.append(_frame_decode(f))
    return b"".join(out), n


def blte_encode_like(orig_blte, data):
    """Encode data with the same frame layout (frame sizes and modes) as an existing BLTE file."""
    hsize, frames = blte_parse(orig_blte)

    def enc(mode, chunk):
        return (b"N" + chunk) if mode == b"N" else (b"Z" + zlib.compress(chunk, 6))

    if hsize == 0:
        return b"BLTE" + bytes(4) + enc(frames[0][0][0:1], data)
    sizes = [c for _, c in frames]
    modes = [f[0:1] for f, _ in frames]
    if sum(sizes) != len(data):                 # size changed: plain 1 MB zlib frames
        step = max(max(sizes), 1 << 20)
        sizes = [min(step, len(data) - i) for i in range(0, len(data), step)]
        modes = [b"Z"] * len(sizes)
    out, pos = [], 0
    for m, s in zip(modes, sizes):
        out.append(enc(m, data[pos:pos + s]))
        pos += s
    head = [b"BLTE" + struct.pack(">I", 12 + 24 * len(out)) + b"\x0f" + len(out).to_bytes(3, "big")]
    for f, s in zip(out, sizes):
        head.append(struct.pack(">II", len(f), s) + md5(f))
    blte = b"".join(head) + b"".join(out)
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
        # pages are sorted by content key: look in the last page whose first key <= ckey
        lo, hi = 0, len(self.cpages) - 1
        while lo < hi:
            mid = (lo + hi + 1) // 2
            ents = self.cpages[mid]["entries"]
            if ents and ents[0][6:22] <= ckey:
                lo = mid
            else:
                hi = mid - 1
        for pg in self.cpages[max(lo - 1, 0):lo + 2]:
            for e in pg["entries"]:
                if e[6:22] == ckey:
                    return [e[22 + 16 * k:38 + 16 * k] for k in range(e[0])]
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

    _LAYOUT = re.compile(rb"^b:\{22=n,(\d+)=z,(\d+)=n,(\d+)=n,(\d+)=n,(\d+)=n,\*=z\}$")

    def sections(self):
        """The file as its 7 natural sections; the trailing layout spec is updated to the new sizes."""
        cp = self._serialize(self.cpages, self.cpsize, b"\0", lambda e: e[6:22])
        ep = self._serialize(self.epages, self.epsize, self.epad, lambda e: e[0:16])
        head = b"EN\x01\x10\x10" + struct.pack(">HHII", self.cpsize // 1024, self.epsize // 1024, len(cp), len(ep))
        head += bytes([self.unk]) + struct.pack(">I", len(self.espec_block))
        secs = [head, self.espec_block,
                b"".join(f + md5(b) for f, b in cp), b"".join(b for _, b in cp),
                b"".join(f + md5(b) for f, b in ep), b"".join(b for _, b in ep)]
        trailer = self.trailer
        if self._LAYOUT.match(trailer):
            trailer = ("b:{22=n,%d=z,%d=n,%d=n,%d=n,%d=n,*=z}" % tuple(len(x) for x in secs[1:])).encode()
        return secs + [trailer]

    def build(self):
        return b"".join(self.sections())

    def encode_blte(self, orig_blte):
        """BLTE in the layout the file's own trailing spec describes (one frame per section)."""
        secs = self.sections()
        if not self._LAYOUT.match(secs[-1]):
            return blte_encode_like(orig_blte, b"".join(secs))
        modes = [b"N", b"Z", b"N", b"N", b"N", b"N", b"Z"]
        frames = [(b"N" + x) if m == b"N" else (b"Z" + zlib.compress(x, 6)) for x, m in zip(secs, modes)]
        head = [b"BLTE" + struct.pack(">I", 12 + 24 * len(frames)) + b"\x0f" + len(frames).to_bytes(3, "big")]
        for f, x in zip(frames, secs):
            head.append(struct.pack(">II", len(f), len(x)) + md5(f))
        blte = b"".join(head) + b"".join(frames)
        if blte_decode(blte) != b"".join(secs):
            raise Fail("ENCODING BLTE self-check failed")
        return blte


# --------------------------------------------------------------------------- ROOT (8.x TSFM / legacy)

def root_blocks(root, with_locale=False):
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
        yield (start, ids, ck_at, lflags) if with_locale else (start, ids, ck_at)


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


def file_entry(st, b, fdid):
    cks = set(root_get(b["root"], fdid))
    if len(cks) != 1:
        raise Fail("file %d has %d different content keys in ROOT" % (fdid, len(cks)))
    ck = cks.pop()
    eks = b["enc"].ekeys_for(ck)
    if not eks:
        raise Fail("file %d is not in ENCODING" % fdid)
    _, blte = st.read(eks[0])
    data = blte_decode(blte)
    if md5(data) != ck:
        raise Fail("file %d does not match its key" % fdid)
    return ck, eks[0], blte, data


def liquid_edit(g, mode):
    """Edit the MLIQ chunk of a WMO group file in place (same size)."""
    d = bytearray(g)
    hit = 0
    for tag, o, n in wmo_chunks(g):
        if tag != "MOGP":
            continue
        for t2, o2, n2 in wmo_chunks(g, o + 68, o + n):
            if t2 != "MLIQ":
                continue
            hit += 1
            xv, yv, xt, yt = struct.unpack_from("<4I", g, o2)
            bz = struct.unpack_from("<f", g, o2 + 24)[0]
            vat = o2 + 30
            tat = vat + 8 * xv * yv
            if mode == "off":
                for i in range(xt * yt):
                    d[tat + i] |= 0x0F
                continue
            shown = set()
            for ty in range(yt):
                for tx in range(xt):
                    if g[tat + ty * xt + tx] & 0x0F != 0x0F:
                        shown.update(((ty, tx), (ty, tx + 1), (ty + 1, tx), (ty + 1, tx + 1)))
            for vy in range(yv):
                for vx in range(xv):
                    if (vy, vx) not in shown:
                        struct.pack_into("<f", d, vat + 8 * (vy * xv + vx) + 4, bz)
    if hit != 1:
        raise Fail("expected one liquid chunk, found %d" % hit)
    return bytes(d)


def _bits_get(b, off, n):
    v = int.from_bytes(b[off // 8:(off + n + 7) // 8 + 1], "little")
    return (v >> (off % 8)) & ((1 << n) - 1)


def _bits_set(b, off, n, val):
    lo, hi = off // 8, (off + n + 7) // 8 + 1
    v = int.from_bytes(b[lo:hi], "little")
    mask = ((1 << n) - 1) << (off % 8)
    v = (v & ~mask) | ((val & ((1 << n) - 1)) << (off % 8))
    b[lo:hi] = v.to_bytes(hi - lo, "little")


def lightdata_edit(db, params, colour):
    """LightData.db2 (WDC3): set DirectColor + AmbientColor (fields 2, 3) of every row whose
    LightParamID (field 0) is in params."""
    d = bytearray(db)
    hdr = struct.unpack_from("<4s9IHH7I", d, 0)
    if hdr[0] != b"WDC3" or hdr[18] != 1:
        raise Fail("LightData.db2 is not a single-section WDC3 file")
    rec_size, fields, fsis = hdr[3], hdr[2], hdr[15]
    sec = struct.unpack_from("<Q8I", d, 72)
    p = 72 + 40 + 4 * fields
    fsi = [struct.unpack_from("<HHIIIII", d, p + 24 * i) for i in range(fsis // 24)]
    if fsi[0][3] != 1 or fsi[2][3] != 5 or fsi[3][3] != 5:
        raise Fail("LightData.db2 layout is not the expected one")
    base, count = sec[1], sec[2]
    n = 0
    for r in range(count):
        at = base + r * rec_size
        rec = bytearray(d[at:at + rec_size] + bytes(8))
        if _bits_get(rec, fsi[0][0], fsi[0][5]) in params:
            for f in (2, 3):
                _bits_set(rec, fsi[f][0], fsi[f][5], colour)
            d[at:at + rec_size] = rec[:rec_size]
            n += 1
    if n == 0:
        raise Fail("no LightData rows found for params %s" % sorted(params))
    return bytes(d)


def light_add_map(db, mapid, params_id):
    """Light.db2 (WDC3): append a map-wide light (position 0,0,0) for mapid using params_id in all
    eight slots. Refuses if the map already has a light."""
    d = bytes(db)
    hdr = list(struct.unpack_from("<4s9IHH7I", d, 0))
    if hdr[0] != b"WDC3" or hdr[18] != 1 or hdr[3] != 40 or hdr[2] != 5:
        raise Fail("Light.db2 is not the expected single-section WDC3 file")
    sec = list(struct.unpack_from("<Q8I", d, 72))
    tk, fo, rc, sts, ore, idls, rels, omc, ctc = sec
    if rels or omc or idls != 4 * rc:
        raise Fail("Light.db2 section layout is not the expected one")
    p = 72 + 40 + 4 * hdr[2]
    fsi = [struct.unpack_from("<HHIIIII", d, p + 24 * i) for i in range(hdr[15] // 24)]
    want = [(0, 96), (96, 32), (128, 32), (160, 16), (176, 128)]
    if [(f[0], f[1]) for f in fsi] != want or any(f[3] for f in fsi):
        raise Fail("Light.db2 fields are not the expected ones")
    recs = d[fo:fo + 40 * rc]
    for r in range(rc):
        if struct.unpack_from("<H", recs, 40 * r + 20)[0] == mapid:
            raise Fail("Light.db2 already has a light for map %d" % mapid)
    ids_at = fo + 40 * rc + sts
    ids = list(struct.unpack_from("<%dI" % rc, d, ids_at))
    new_id = max(hdr[8], max(ids)) + 1
    rec = struct.pack("<3fffH8H", 0.0, 0.0, 0.0, 0.0, 0.0, mapid, *([params_id] * 8)) + b"\0\0"
    out = bytearray(d[:fo]) + recs + rec + d[fo + 40 * rc:ids_at] + struct.pack("<%dI" % (rc + 1), *(ids + [new_id])) \
        + d[ids_at + idls:]
    hdr[1] += 1
    hdr[8] = new_id
    struct.pack_into("<4s9IHH7I", out, 0, *hdr)
    sec[2], sec[5] = rc + 1, idls + 4
    struct.pack_into("<Q8I", out, 72, *sec)
    return bytes(out)


def parse_file_args(args):
    """['12345=/path/news.lua', ...] -> [(12345, data)]"""
    out = []
    for a in args:
        fd, sep, path = a.partition("=")
        if not sep or not fd.strip().isdigit():
            raise Fail("expected <file ID>=<path>, got %r" % a)
        path = os.path.expanduser(path)
        if not os.path.isfile(path):
            raise Fail("no such file: " + path)
        with open(path, "rb") as f:
            out.append((int(fd), f.read()))
    if not out:
        raise Fail("inject file needs at least one <file ID>=<path>")
    return out


def variant_edits(variant, extra=()):
    """[(file ID, original content key or None, edit function)]"""
    if variant == "file":
        return [(fd, None, lambda d, x=data: x) for fd, data in parse_file_args(extra)]
    if variant in WMO_VARIANTS:
        return [(WMO_FDID, WMO_CKEY, lambda d: make_variant(d, variant))]
    if variant in LIQUID_VARIANTS:
        mode = "fix" if variant == "liqfix" else "off"
        return [(f, bytes.fromhex(ck), lambda d, m=mode: liquid_edit(d, m)) for f, ck in sorted(LIQUID_GROUPS.items())]
    if variant == "lighttest":
        return [(LIGHTDATA_FDID, LIGHTDATA_CKEY, lambda d: lightdata_edit(d, {3, 10, 12, 13}, 0x00FF00))]
    if variant == "lightfix":
        return [(LIGHT_FDID, LIGHT_CKEY, lambda d: light_add_map(d, BRD_MAP, DARK_LIGHTPARAMS))]
    raise Fail("unknown variant " + variant)


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
    if s and s.get("new_key") == key:
        print("injected      %s" % s.get("variant"))


def cmd_inject(client, variant, extra=()):
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
    enc = b["enc"]
    files = []      # (fdid, old ck, new data, new ck, new ek, new blte, old ek)
    for fdid, orig_ck, fn in variant_edits(variant, extra):
        ck, ek, blte, data = file_entry(st, b, fdid)
        if orig_ck is not None and ck != orig_ck:
            raise Fail("base build's file %d is not the original (%s)" % (fdid, ck.hex()))
        nd = fn(data)
        nb = blte_encode_like(blte, nd)
        files.append((fdid, ck, nd, md5(nd), blte_ekey(nb), nb, ek))

    print("building new ROOT ...", flush=True)
    new_root = b["root"]
    for fdid, ck, nd, n_ck, n_ek, nb, ek in files:
        new_root = root_replace(new_root, fdid, ck, n_ck)
    r_blte = blte_encode_like(b["root_blte"], new_root)
    r_ck, r_ek = md5(new_root), blte_ekey(r_blte)

    for fdid, ck, nd, n_ck, n_ek, nb, ek in files:
        enc.add(n_ck, len(nd), n_ek, enc.espec_index(ek), len(nb))
    enc.add(r_ck, len(new_root), r_ek, enc.espec_index(b["root_ek"]), len(r_blte))
    print("building new ENCODING ...", flush=True)
    new_enc = enc.build()
    e_blte = enc.encode_blte(b["enc_blte"])
    e_ck, e_ek = md5(new_enc), blte_ekey(e_blte)
    chk = Encoding(new_enc)
    if chk.ekeys_for(r_ck) != [r_ek] or any(chk.ekeys_for(f[3]) != [f[4]] for f in files):
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
    blobs = [(f[4], f[5]) for f in files] + [(r_ek, r_blte), (e_ek, e_blte)]
    for bk in sorted({bucket_of(e) for e, _ in blobs}):
        for x in st.all_idx(bk):
            dst = os.path.join(bdir, "idx", os.path.basename(x.path))
            if not os.path.isfile(dst):
                shutil.copy2(x.path, dst)

    # data file: our own, appended
    # an index entry holds the offset in seg_bits bits (1 GiB), whatever the header's max size says
    max_size = min([st.newest(bk).max_size for bk in range(16)] + [1 << st.newest(bk).seg_bits for bk in range(16)])
    need = sum(30 + len(x) for _, x in blobs)
    arc = s.get("archive")
    if arc is None or not os.path.isfile(st.data_path(arc)) or os.path.getsize(st.data_path(arc)) + need > max_size:
        arc = st.archives()[-1] + 1
        open(st.data_path(arc), "wb").close()
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

    # read the new blobs back before the client is pointed at them
    st_chk = Storage(client)
    names = ["file %d" % f[0] for f in files] + ["ROOT", "ENCODING"]
    for (ekey, blte), name in zip(blobs, names):
        try:
            got = st_chk.read(ekey)[1]
        except Fail as e:
            raise Fail("%s: %s\n.fzbuildnfo was NOT changed; the client still uses build %s" % (name, e, cur_key))
        if got != blte:
            raise Fail("%s reads back different\n.fzbuildnfo was NOT changed; the client still uses build %s" % (name, cur_key))

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

    s.update({"orig_key": base_key, "new_key": new_key, "archive": arc,
              "variant": variant if variant != "file" else "file " + " ".join(str(f[0]) for f in files)})
    with open(state_path(client), "w") as f:
        json.dump(s, f, indent=1)

    # read it all back the way the client will
    st2 = Storage(client)
    b2 = load_build(st2, client, info_build_key(info))
    print("new build config %s (data.%03d, %d new files)" % (new_key, arc, len(blobs)))
    for fdid, ck, nd, n_ck, n_ek, nb, ek in files:
        got = file_entry(st2, b2, fdid)[3]
        if got != nd:
            raise Fail("read-back mismatch for file %d" % fdid)
        print("file %d now reads back as: %s" % (fdid, state_of(got) if fdid == WMO_FDID and variant != "file"
                                                  else "%s (%d bytes)" % (variant, len(got))))


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


def cmd_layout(client):
    """Read-only: how the original ENCODING/ROOT/WMO are stored, and what we wrote."""
    st = Storage(client)
    s = load_state(client) or {}
    key = s.get("orig_key") or info_build_key(info_file(client))
    raw, kv = read_config(client, key)
    print("== build config %s" % key)
    print(raw.decode("utf-8", "replace"))
    b = load_build(st, client, key)

    def show(name, ek, blte):
        arc, off, size = st.locate(ek)
        hsize, frames = blte_parse(blte)
        print("== %s ekey %s at data.%03d @%d size %d, header %d, %d frames" % (name, ek.hex(), arc, off, size, hsize, len(frames)))
        print("   frames (csize/mode/esize):", [(c, f[0:1].decode("latin1"), len(f)) for f, c in frames[:12]], "..." if len(frames) > 12 else "")
        print("   last frames:", [(c, f[0:1].decode("latin1"), len(f)) for f, c in frames[-3:]])
        with open(st.data_path(arc), "rb") as f:
            f.seek(off)
            print("   span header:", f.read(30).hex())

    enc_ek = bytes.fromhex(kv["encoding"][1])
    show("ENCODING", enc_ek, b["enc_blte"])
    show("ROOT", b["root_ek"], b["root_blte"])
    ck, ek, wblte, _ = wmo_of(st, b)
    show("WMO", ek, wblte)
    e = b["enc"]
    print("== ENCODING: cpage %d x %d, epage %d x %d, %d especs, trailer %r" % (
        len(e.cpages), e.cpsize, len(e.epages), e.epsize, len(e.especs), e.trailer[:300]))
    print("   especs:", [x.decode("latin1") for x in e.especs[:15]])
    for name, k in (("ENCODING", enc_ek), ("ROOT", b["root_ek"]), ("WMO", ek)):
        try:
            print("   espec of %s: %s" % (name, e.especs[e.espec_index(k)].decode("latin1")))
        except Fail as x:
            print("   espec of %s: %s" % (name, x))
    shm = cpath(client, "Data", "data", "shmem")
    if os.path.isfile(shm):
        with open(shm, "rb") as f:
            d = f.read()
        print("== shmem %d bytes, head %s" % (len(d), d[:300].hex()))
        print("   strings:", [t for t in d.split(b"\0") if len(t) > 4][:10])
    print("== data files:", st.archives()[-3:], [os.path.getsize(st.data_path(a)) for a in st.archives()[-3:]])


def file_of(st, b, fdid):
    # a file can have several content keys (one per locale); prefer enUS, then any that is stored
    cks = []
    for _, ids, ck_at, lflags in root_blocks(b["root"], with_locale=True):
        for i, f in enumerate(ids):
            if f == fdid:
                ck = b["root"][ck_at + 16 * i:ck_at + 16 * i + 16]
                cks.append((0 if lflags & 0x2 else 1, ck))
    if not cks:
        raise Fail("file %d is not in ROOT" % fdid)
    err = None
    for _, ck in sorted(cks):
        eks = b["enc"].ekeys_for(ck)
        if not eks:
            err = "content key %s is not in ENCODING" % ck.hex()
            continue
        try:
            _, blte = st.read(eks[0])
        except Fail as e:
            err = str(e)
            continue
        data, enc = blte_decode_lenient(blte)
        if enc:
            print("file %d: %d encrypted piece(s) written as zeros" % (fdid, enc))
            return data
        if md5(data) == ck:
            return data
        err = "does not match its key"
    raise Fail("file %d: %s" % (fdid, err))


def wmo_chunks(data, start=0, end=None):
    end = len(data) if end is None else end
    o = start
    while o + 8 <= end:
        tag = data[o:o + 4][::-1].decode("latin-1")
        n = struct.unpack_from("<I", data, o + 4)[0]
        yield tag, o + 8, n
        o += 8 + n


def liquid_summary(gi, fdid, g):
    for tag, o, n in wmo_chunks(g):
        if tag != "MOGP":
            continue
        flags = struct.unpack_from("<I", g, o + 8)[0]
        fog = tuple(g[o + 48:o + 52])
        liq = struct.unpack_from("<I", g, o + 52)[0]
        found = False
        for t2, o2, n2 in wmo_chunks(g, o + 68, o + n):
            if t2 != "MLIQ":
                continue
            found = True
            xv, yv, xt, yt = struct.unpack_from("<4I", g, o2)
            bx, by, bz = struct.unpack_from("<3f", g, o2 + 16)
            mat = struct.unpack_from("<H", g, o2 + 28)[0]
            hs = [struct.unpack_from("<f", g, o2 + 30 + 8 * i + 4)[0] for i in range(xv * yv)]
            tiles = g[o2 + 30 + 8 * xv * yv:o2 + 30 + 8 * xv * yv + xt * yt]
            hidden = sum(1 for t in tiles if t & 0x0F == 0x0F)
            print("group %2d file %6d flags %08x liquid %3d mat %2d at %7.1f %7.1f z %7.1f..%7.1f  %dx%d tiles, %d shown, %d hidden"
                  % (gi, fdid, flags, liq, mat, -bx, -by, min(hs) if hs else bz, max(hs) if hs else bz,
                     xt, yt, xt * yt - hidden, hidden))
        if not found and liq:
            print("group %2d file %6d flags %08x liquid %3d (no MLIQ)" % (gi, fdid, flags, liq))


def cmd_extract(client, out, ids):
    info = info_file(client) or os.path.join(client, ".build.info")
    if not os.path.isfile(info):
        raise Fail("no .fzbuildnfo or .build.info in the client folder")
    st = Storage(client)
    key = info_build_key(info)
    b = load_build(st, client, key)
    os.makedirs(out, exist_ok=True)
    todo = []
    for a in ids:
        if a == "brd":
            root = file_of(st, b, WMO_FDID)
            gfid = []
            for tag, o, n in wmo_chunks(root):
                if tag == "GFID":
                    gfid = list(struct.unpack_from("<%dI" % (n // 4), root, o))
            todo.append(("root", WMO_FDID))
            todo += [(i, f) for i, f in enumerate(gfid)]
        else:
            todo.append(("file", int(a)))
    print("build config %s" % key)
    written = 0
    for gi, fdid in todo:
        try:
            data = file_of(st, b, fdid)
        except Fail as e:
            print("skipped: %s" % e)
            continue
        written += 1
        name = "%d.wmo" % fdid if gi != "file" else "%d.bin" % fdid
        if gi not in ("root", "file"):
            name = "group_%03d_%d.wmo" % (gi, fdid)
        with open(os.path.join(out, name), "wb") as f:
            f.write(data)
        if isinstance(gi, int):
            liquid_summary(gi, fdid, data)
    print("wrote %d of %d files to %s" % (written, len(todo), out))


def _looks_like_text(head):
    if head.startswith(b"\xef\xbb\xbf"):
        head = head[3:]
    if not head or b"\0" in head:
        return False
    ok = sum(1 for c in head if c >= 0x20 or c in (9, 10, 13))
    return ok >= 0.97 * len(head)


def _span_head(head, n=512):
    """First bytes of a stored span -> the first n bytes of the file, or None."""
    blte = head[30:]
    if blte[0:4] != b"BLTE" or len(blte) < 9:
        return None
    hsize = struct.unpack_from(">I", blte, 4)[0]
    frame = blte[8:] if hsize == 0 else blte[hsize:]
    if not frame:
        return None
    mode, body = frame[0:1], frame[1:]
    if mode == b"N":
        return body[:n]
    if mode == b"Z":
        try:
            return zlib.decompressobj().decompress(body, n)
        except zlib.error:
            return None
    return None


# files that cannot hold readable text: textures, sound, models, animations, maps, video
_SKIP_MAGIC = (b"BLP2", b"OggS", b"RIFF", b"MD21", b"MD20", b"ID3", b"fLaC", b"\xff\xfb", b"\xff\xf3",
               b"SKB1", b"AFM2", b"AFSA", b"AFSB", b"SFID", b"TXAC", b"LDOM", b"MVER", b"REVM", b"KNIS",
               b"PFID", b"TEXS", b"BIK", b"KB2", b"MAOS")


def _context(data, i, n):
    a, b = max(0, i - 60), min(len(data), i + n + 100)
    return "".join(chr(c) if 32 <= c < 127 else "." for c in data[a:b])


def cmd_find(client, out, texts):
    every = "--all" in texts
    texts = [t for t in texts if t != "--all"]
    texts = [t.lower().encode("utf-8") for t in (texts or ["fstorm", "live changelog"])]
    wide = [t.decode("utf-8").encode("utf-16-le") for t in texts]
    info = info_file(client) or os.path.join(client, ".build.info")
    if not os.path.isfile(info):
        raise Fail("no .fzbuildnfo or .build.info in the client folder")
    st = Storage(client)
    key = info_build_key(info)
    b = load_build(st, client, key)
    # every stored file, in disk order
    spans = {}
    for bk in range(16):
        x = st.newest(bk)
        for e in x.entries:
            so = int.from_bytes(e[9:14], "big")
            spans[e[:9]] = (so >> x.seg_bits, so & ((1 << x.seg_bits) - 1), struct.unpack_from("<I", e, 14)[0])
    order = sorted((v, k) for k, v in spans.items())
    print("build config %s, %d stored files; looking for %s in %s" % (
        key, len(order), ", ".join(repr(t.decode()) for t in texts),
        "all files except textures/sound/models" if every else "text files"), flush=True)
    hits = {}           # ekey9 -> (data, [(text, line)])
    texty = done = 0
    cur_arc, f = None, None
    try:
        for (arc, off, size), ek9 in order:
            done += 1
            if done % 50000 == 0:
                print("  %d / %d files read, %d searched, %d hits so far" % (done, len(order), texty, len(hits)), flush=True)
            if arc != cur_arc:
                if f:
                    f.close()
                p = st.data_path(arc)
                f = open(p, "rb") if os.path.isfile(p) else None
                cur_arc = arc
            if f is None or size < 40:
                continue
            f.seek(off)
            head = f.read(min(size, 4096))
            first = _span_head(head)
            if first is None:
                continue
            is_text = _looks_like_text(first)
            if not is_text and (not every or first.startswith(_SKIP_MAGIC)):
                continue
            span = head + (f.read(size - len(head)) if size > len(head) else b"")
            try:
                data, _ = blte_decode_lenient(span[30:])
            except (Fail, zlib.error, struct.error):
                continue
            texty += 1
            low = data.lower()
            found = []
            if not is_text:
                for t in texts + wide:
                    i = low.find(t)
                    while i >= 0 and len(found) < 20:
                        ln = _context(data, i, len(t))
                        if ln not in found:
                            found.append(ln)
                        i = low.find(t, i + len(t))
                if found:
                    hits[ek9] = (data, found)
                continue
            for t in texts:
                if t in low:
                    for line in data.split(b"\n"):
                        if t in line.lower():
                            ln = line.strip()[:200].decode("utf-8", "replace")
                            if ln not in found:
                                found.append(ln)
            if found:
                hits[ek9] = (data, found)
    finally:
        if f:
            f.close()
    print("%d files searched, %d contain the text" % (texty, len(hits)))
    if not hits:
        return
    # encoded key -> content key -> file IDs in this build
    ck_of = {}
    for pg in b["enc"].cpages:
        for e in pg["entries"]:
            for k in range(e[0]):
                ek = e[22 + 16 * k:38 + 16 * k]
                if ek[:9] in hits:
                    ck_of[ek[:9]] = e[6:22]
    fd_of = {}
    want = set(ck_of.values())
    for _, ids, ck_at, lflags in root_blocks(b["root"], with_locale=True):
        for i, fd in enumerate(ids):
            ck = b["root"][ck_at + 16 * i:ck_at + 16 * i + 16]
            if ck in want:
                fd_of.setdefault(ck, set()).add(fd)
    os.makedirs(out, exist_ok=True)
    for ek9, (data, found) in sorted(hits.items(), key=lambda kv: sorted(fd_of.get(ck_of.get(kv[0]), {0}))):
        ck = ck_of.get(ek9)
        fds = sorted(fd_of.get(ck, ())) if ck else []
        name = ("%d" % fds[0]) if fds else ("unused_" + ek9.hex())
        ext = ".txt" if _looks_like_text(data[:512]) else ".bin"
        with open(os.path.join(out, name + ext), "wb") as w:
            w.write(data)
        print("== %s  file ID %s  (%d bytes)%s" % (name + ext, ", ".join(map(str, fds)) or "-", len(data),
                                                   "" if fds else "  not used by the current build"))
        for line in found[:8]:
            print("     " + line)
        if len(found) > 8:
            print("     ... %d more lines" % (len(found) - 8))
    print("wrote %d files to %s" % (len(hits), out))


def main(argv):
    cmds = ("status", "inject", "uninject", "layout", "extract", "find")
    if len(argv) < 3 or argv[2] not in cmds or (argv[2] == "inject" and (len(argv) < 4 or argv[3] not in WMO_VARIANTS + LIQUID_VARIANTS + LIGHT_VARIANTS + ("file",))):
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
            cmd_inject(client, argv[3], argv[4:])
        elif argv[2] == "layout":
            cmd_layout(client)
        elif argv[2] == "extract":
            if len(argv) < 5:
                print(__doc__)
                return 2
            cmd_extract(client, argv[3], argv[4:])
        elif argv[2] == "find":
            if len(argv) < 4:
                print(__doc__)
                return 2
            cmd_find(client, argv[3], argv[4:])
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
