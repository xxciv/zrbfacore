#!/usr/bin/env python3
"""Patch the Blackrock Depths fog (root WMO MFOG chunk) inside an 8.3.7 client's CASC storage.

The WoW Circle 8.3.7 client ignores loose files, so this edits the stored copy of
world/wmo/.../blackrock_lower_instance.wmo (content key ba1f2379e67cfe1f5ecdf70469363c1c)
in place, inside Data/data/data.NNN:

  .build.info -> build config -> ENCODING -> encoded key -> Data/data/*.idx -> data.NNN offset

Only the BLTE frame that holds the fog chunk is re-encoded, to exactly the same byte size,
so no index, encoding or config file changes. The original bytes are saved first and
'restore' puts them back.

Usage (close the game first):
  python brd_fog_casc.py "<client folder>" status
  python brd_fog_casc.py "<client folder>" apply off     # 9 fog zones disabled (radius 0)
  python brd_fog_casc.py "<client folder>" apply swap    # fog colour red/blue swapped
  python brd_fog_casc.py "<client folder>" apply probe   # TEST: whole dungeon uses one texture
  python brd_fog_casc.py "<client folder>" restore       # put the original bytes back

<client folder> is the folder that contains Data (and .build.info). Works on Linux
(python3, e.g. a Wine/Proton install) and Windows (py).
"""
import hashlib
import json
import os
import struct
import sys
import zlib

WMO_CKEY = bytes.fromhex("ba1f2379e67cfe1f5ecdf70469363c1c")  # blackrock_lower_instance.wmo, 8.3.7 35662
WMO_SIZE = 105424
MFOG_DATA = 103160      # offset of the MFOG payload (after the 8-byte chunk header)
MFOG_COUNT = 9
VARIANT_MD5 = {
    "original": "ba1f2379e67cfe1f5ecdf70469363c1c",
    "off": "1da7587f5a744ccc335be5ab5d31234f",
    "swap": "6e3f8087c7fb64fc719793da9d0ab9ab",
    "probe": "338b43010004c7df669ebca381c57ddd",
}
BACKUP_DIR = "zr_casc_backup"


class Fail(Exception):
    pass


# --------------------------------------------------------------------------- variants

def make_variant(orig, name):
    d = bytearray(orig)
    if d[MFOG_DATA - 8:MFOG_DATA - 4] != b"GOFM" or struct.unpack_from("<I", d, MFOG_DATA - 4)[0] != 48 * MFOG_COUNT:
        raise Fail("the WMO has no 9-entry MFOG chunk where expected")
    if name == "probe":
        # test only: every material (MOMT, 57 x 64 bytes at 92) uses material 0's texture
        tex = d[92 + 12:92 + 16]
        for i in range(57):
            d[92 + 64 * i + 12:92 + 64 * i + 16] = tex
    for i in range(MFOG_COUNT if name != "probe" else 0):
        e = MFOG_DATA + 48 * i
        if name == "off":
            d[e + 16:e + 24] = bytes(8)          # smaller + larger radius = 0
        elif name == "swap":
            for c in (e + 32, e + 44):           # fog colour, underwater colour (BGRA)
                d[c], d[c + 2] = d[c + 2], d[c]
        else:
            raise Fail("unknown variant " + name)
    d = bytes(d)
    if hashlib.md5(d).hexdigest() != VARIANT_MD5[name]:
        raise Fail("built '%s' variant does not match the expected file" % name)
    return d


def state_of(content):
    h = hashlib.md5(content).hexdigest()
    for k, v in VARIANT_MD5.items():
        if v == h:
            return k
    return "unknown (" + h + ")"


# --------------------------------------------------------------------------- storage lookup

def cpath(base, *parts):
    """Join path parts, matching each folder/file name case-insensitively (Linux/Wine installs)."""
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


def read_build_key(client):
    bi = cpath(client, ".build.info")
    if os.path.isfile(bi):
        with open(bi, "r", encoding="utf-8", errors="replace") as f:
            lines = [l.rstrip("\r\n") for l in f if l.strip()]
        cols = [c.split("!")[0] for c in lines[0].split("|")]
        for row in lines[1:]:
            vals = row.split("|")
            rec = dict(zip(cols, vals))
            if rec.get("Active", "1") == "1" and rec.get("Build Key"):
                return rec["Build Key"].strip().lower()
    # no .build.info (repacked client): find the 35662 build config in Data/config
    cfg = cpath(client, "Data", "config")
    for root, _, files in os.walk(cfg):
        for fn in files:
            p = os.path.join(root, fn)
            try:
                with open(p, "r", encoding="utf-8", errors="replace") as f:
                    txt = f.read(4096)
            except OSError:
                continue
            if "build-name" in txt and "35662" in txt and "\nencoding = " in "\n" + txt:
                return fn.lower()
    raise Fail("no .build.info and no 35662 build config under Data/config")


def read_build_config(client, key):
    p = cpath(client, "Data", "config", key[0:2], key[2:4], key)
    if not os.path.isfile(p):
        raise Fail("build config %s not found at %s" % (key, p))
    cfg = {}
    with open(p, "r", encoding="utf-8", errors="replace") as f:
        for line in f:
            if " = " in line:
                k, v = line.strip().split(" = ", 1)
                cfg[k] = v.split()
    if "encoding" not in cfg:
        raise Fail("build config has no encoding line")
    return cfg


def bucket_of(ekey):
    x = 0
    for b in ekey[:9]:
        x ^= b
    return (x & 0xF) ^ (x >> 4)


def idx_files(client):
    d = cpath(client, "Data", "data")
    best = {}
    for fn in os.listdir(d):
        if fn.lower().endswith(".idx") and len(fn) == 14:
            try:
                b, v = int(fn[0:2], 16), int(fn[2:10], 16)
            except ValueError:
                continue
            if b not in best or v > best[b][0]:
                best[b] = (v, os.path.join(d, fn))
    if not best:
        raise Fail("no .idx files in " + d)
    return {b: p for b, (v, p) in best.items()}


def idx_lookup(client, ekey):
    files = idx_files(client)
    b = bucket_of(ekey)
    p = files.get(b)
    if p is None:
        raise Fail("no index file for bucket %02x" % b)
    with open(p, "rb") as f:
        data = f.read()
    hsize = struct.unpack_from("<I", data, 0)[0]
    hdr = data[8:8 + hsize]
    rev, bidx, flags, sz_b, off_b, key_b, seg_bits = struct.unpack_from("<HBBBBBB", hdr, 0)
    if rev != 7 or key_b != 9 or off_b != 5 or sz_b != 4:
        raise Fail("unexpected index format in " + p)
    pos = 8 + hsize
    pos = (pos + 15) & ~15                                   # entries block is 16-byte aligned
    block_size = struct.unpack_from("<I", data, pos)[0]
    pos += 8
    elen = key_b + off_b + sz_b
    end = min(len(data), pos + block_size)
    want = ekey[:9]
    while pos + elen <= end:
        if data[pos:pos + 9] == want:
            so = int.from_bytes(data[pos + 9:pos + 14], "big")
            size = struct.unpack_from("<I", data, pos + 14)[0]
            return so >> seg_bits, so & ((1 << seg_bits) - 1), size, p
        pos += elen
    raise Fail("encoded key %s not in %s" % (ekey.hex(), os.path.basename(p)))


def data_path(client, archive):
    return cpath(client, "Data", "data", "data.%03d" % archive)


def read_span(client, ekey):
    archive, offset, size, idxp = idx_lookup(client, ekey)
    path = data_path(client, archive)
    with open(path, "rb") as f:
        f.seek(offset)
        blob = f.read(size)
    if len(blob) != size:
        raise Fail("short read from " + path)
    if blob[0:16] not in (ekey[::-1], ekey) and blob[30:34] != b"BLTE":
        raise Fail("data at %s:%d is not the expected file" % (path, offset))
    return path, offset, blob


# --------------------------------------------------------------------------- BLTE

def blte_frames(blob):
    """Split a stored span (30-byte header + BLTE) into (prefix, header_end, frames)."""
    base = 30 if blob[0:4] != b"BLTE" else 0
    if blob[base:base + 4] != b"BLTE":
        raise Fail("no BLTE signature")
    hsize = struct.unpack_from(">I", blob, base + 4)[0]
    frames = []
    if hsize == 0:
        frames.append({"enc": blob[base + 8:], "csize": None, "md5_at": None})
        return base, base + 8, frames
    if blob[base + 8] != 0x0F:
        raise Fail("bad BLTE frame table")
    count = int.from_bytes(blob[base + 9:base + 12], "big")
    pos = base + hsize
    for i in range(count):
        t = base + 12 + 24 * i
        esize, csize = struct.unpack_from(">II", blob, t)
        frames.append({"enc": blob[pos:pos + esize], "csize": csize, "md5_at": t + 8})
        pos += esize
    if pos != len(blob):
        raise Fail("BLTE frame sizes do not add up")
    return base, base + hsize, frames


def decode_frame(enc):
    mode = enc[0:1]
    if mode == b"N":
        return enc[1:]
    if mode == b"Z":
        return zlib.decompress(enc[1:])
    raise Fail("unsupported BLTE frame mode %r (encrypted or unknown)" % mode)


def blte_decode(blob):
    _, _, frames = blte_frames(blob)
    return b"".join(decode_frame(f["enc"]) for f in frames)


# --------------------------------------------------------------------------- exact-size deflate

class BitReader:
    def __init__(self, data):
        self.d = data
        self.pos = 0

    def bits(self, n):
        v = 0
        for i in range(n):
            byte = self.d[self.pos >> 3]
            v |= ((byte >> (self.pos & 7)) & 1) << i
            self.pos += 1
        return v


def _huff(lengths):
    """Canonical Huffman decode table: {(len, code): symbol}."""
    maxl = max(lengths) if lengths else 0
    bl_count = [0] * (maxl + 1)
    for l in lengths:
        if l:
            bl_count[l] += 1
    code, next_code = 0, [0] * (maxl + 2)
    for b in range(1, maxl + 1):
        code = (code + bl_count[b - 1]) << 1
        next_code[b] = code
    table = {}
    for s, l in enumerate(lengths):
        if l:
            table[(l, next_code[l])] = s
            next_code[l] += 1
    return table


def _sym(br, table):
    code, l = 0, 0
    while True:
        code = (code << 1) | br.bits(1)
        l += 1
        s = table.get((l, code))
        if s is not None:
            return s
        if l > 15:
            raise Fail("bad deflate stream")


_LEN_EXTRA = [0] * 8 + [1] * 4 + [2] * 4 + [3] * 4 + [4] * 4 + [5] * 4 + [0]
_DIST_EXTRA = [0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13]
_FIXED_LIT = _huff([8] * 144 + [9] * 112 + [7] * 24 + [8] * 8)
_FIXED_DIST = _huff([5] * 30)
_CL_ORDER = [16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15]


def last_block_start(raw):
    """Walk a raw deflate stream; return (bit offset of the final block header, end bit)."""
    br = BitReader(raw)
    while True:
        start = br.pos
        final = br.bits(1)
        btype = br.bits(2)
        if btype == 0:
            br.pos = (br.pos + 7) & ~7
            ln = br.bits(16)
            br.bits(16)
            br.pos += 8 * ln
        elif btype in (1, 2):
            if btype == 1:
                lit, dist = _FIXED_LIT, _FIXED_DIST
            else:
                hlit, hdist, hclen = br.bits(5) + 257, br.bits(5) + 1, br.bits(4) + 4
                cl = [0] * 19
                for i in range(hclen):
                    cl[_CL_ORDER[i]] = br.bits(3)
                clt = _huff(cl)
                lens = []
                while len(lens) < hlit + hdist:
                    s = _sym(br, clt)
                    if s < 16:
                        lens.append(s)
                    elif s == 16:
                        lens += [lens[-1]] * (3 + br.bits(2))
                    elif s == 17:
                        lens += [0] * (3 + br.bits(3))
                    else:
                        lens += [0] * (11 + br.bits(7))
                lit, dist = _huff(lens[:hlit]), _huff(lens[hlit:])
            while True:
                s = _sym(br, lit)
                if s == 256:
                    break
                if s > 256:
                    br.bits(_LEN_EXTRA[s - 257])
                    d = _sym(br, dist)
                    br.bits(_DIST_EXTRA[d])
        else:
            raise Fail("bad deflate block type")
        if final:
            return start, br.pos


class BitWriter:
    def __init__(self, data, nbits):
        self.out = bytearray(data[:(nbits + 7) >> 3])
        self.n = nbits
        if nbits & 7:
            self.out[-1] &= (1 << (nbits & 7)) - 1

    def put(self, value, n):
        for i in range(n):
            if (self.n >> 3) == len(self.out):
                self.out.append(0)
            if (value >> i) & 1:
                self.out[self.n >> 3] |= 1 << (self.n & 7)
            self.n += 1

    def align(self):
        self.n = (self.n + 7) & ~7
        while len(self.out) < (self.n >> 3):
            self.out.append(0)


def _pad_plan(start_bits, target_bytes):
    """Sequence of empty blocks ('F' fixed 10 bits, 'S' stored) ending in a final one,
    so that the stream ends inside byte number target_bytes."""
    lo, hi = 8 * (target_bytes - 1) + 1, 8 * target_bytes

    def after(pos, op):
        if op == "F":
            return pos + 10
        return ((pos + 3 + 7) & ~7) + 32

    from collections import deque
    seen = {start_bits: []}
    q = deque([start_bits])
    while q:
        p = q.popleft()
        for op in ("F", "S"):
            e = after(p, op)
            if lo <= e <= hi:
                return seen[p] + [op]
            if e < lo and e not in seen:
                seen[e] = seen[p] + [op]
                q.append(e)
    return None


def deflate_exact(data, raw_len, max_wbits):
    """Raw deflate of data that is exactly raw_len bytes long, or None."""
    seen = set()
    cands = []
    for level in (9, 8, 7, 6, 5, 4):
        for mem in (9, 8):
            for strat in (0, 1):
                for wb in range(max_wbits, max(8, max_wbits - 4), -1):
                    c = zlib.compressobj(level, zlib.DEFLATED, -wb, mem, strat)
                    raw = c.compress(data) + c.flush()
                    if raw not in seen and len(raw) <= raw_len:
                        seen.add(raw)
                        cands.append(raw)
    cands.sort(key=len, reverse=True)       # least padding first
    cands = cands[:12]
    for raw in cands:
        if len(raw) == raw_len and zlib.decompress(raw, -15) == data:
            return raw
        start, end = last_block_start(raw)
        plan = _pad_plan(end, raw_len)
        if plan is None:
            continue
        w = BitWriter(raw, end)
        w.out[start >> 3] &= ~(1 << (start & 7)) & 0xFF   # clear BFINAL of the last real block
        for i, op in enumerate(plan):
            final = 1 if i == len(plan) - 1 else 0
            if op == "F":
                w.put(final, 1)
                w.put(1, 2)        # BTYPE 01
                w.put(0, 7)        # end-of-block (code 0000000)
            else:
                w.put(final, 1)
                w.put(0, 2)        # BTYPE 00
                w.align()
                w.put(0x0000, 16)
                w.put(0xFFFF, 16)
        out = bytes(w.out)
        if len(out) == raw_len and zlib.decompress(out, -15) == data:
            return out
    return None


# ---- fallback: keep the original deflate blocks and Huffman tables, fix only the tokens
# that no longer produce the new bytes (used when zlib cannot match the original size)

_LEN_BASE = [3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31, 35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258]
_DIST_BASE = [1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 257, 385, 513, 769, 1025, 1537, 2049, 3073,
              4097, 6145, 8193, 12289, 16385, 24577]


def _codes(lengths):
    maxl = max(lengths) if lengths else 0
    bl_count = [0] * (maxl + 1)
    for l in lengths:
        if l:
            bl_count[l] += 1
    code, next_code = 0, [0] * (maxl + 2)
    for b in range(1, maxl + 1):
        code = (code + bl_count[b - 1]) << 1
        next_code[b] = code
    out = {}
    for s, l in enumerate(lengths):
        if l:
            out[s] = (next_code[l], l)
            next_code[l] += 1
    return out


def parse_deflate(raw):
    """Full parse: list of blocks with header bit range, code lengths and tokens."""
    br = BitReader(raw)
    blocks = []
    while True:
        b = {"start": br.pos}
        final = br.bits(1)
        btype = br.bits(2)
        b["final"], b["type"] = final, btype
        if btype == 0:
            br.pos = (br.pos + 7) & ~7
            ln = br.bits(16)
            br.bits(16)
            b["hdr_end"] = br.pos
            b["stored"] = raw[br.pos >> 3:(br.pos >> 3) + ln]
            br.pos += 8 * ln
        else:
            if btype == 1:
                ll = [8] * 144 + [9] * 112 + [7] * 24 + [8] * 8
                dl = [5] * 30
            elif btype == 2:
                hlit, hdist, hclen = br.bits(5) + 257, br.bits(5) + 1, br.bits(4) + 4
                cl = [0] * 19
                for i in range(hclen):
                    cl[_CL_ORDER[i]] = br.bits(3)
                clt = _huff(cl)
                lens = []
                while len(lens) < hlit + hdist:
                    s = _sym(br, clt)
                    if s < 16:
                        lens.append(s)
                    elif s == 16:
                        lens += [lens[-1]] * (3 + br.bits(2))
                    elif s == 17:
                        lens += [0] * (3 + br.bits(3))
                    else:
                        lens += [0] * (11 + br.bits(7))
                ll, dl = lens[:hlit] + [0] * (288 - hlit), lens[hlit:] + [0] * (30 - hdist)
            else:
                raise Fail("bad deflate block type")
            b["hdr_end"] = br.pos
            b["ll"], b["dl"] = ll, dl
            lit, dist = _huff(ll), _huff(dl)
            toks = []
            while True:
                s = _sym(br, lit)
                if s < 256:
                    toks.append(("L", s))
                elif s == 256:
                    break
                else:
                    le = br.bits(_LEN_EXTRA[s - 257])
                    d = _sym(br, dist)
                    de = br.bits(_DIST_EXTRA[d])
                    toks.append(("M", s, le, d, de))
            b["tokens"] = toks
        b["end"] = br.pos
        blocks.append(b)
        if final:
            return blocks, br.pos


def _match_len_dist(t):
    s, le, d, de = t[1:]
    return _LEN_BASE[s - 257] + le, _DIST_BASE[d] + de


def _enc_match(length, dist):
    s = 257 + max(i for i, b in enumerate(_LEN_BASE) if b <= length)
    if length == 258:
        s = 285
    d = max(i for i, b in enumerate(_DIST_BASE) if b <= dist)
    return ("M", s, length - _LEN_BASE[s - 257], d, dist - _DIST_BASE[d])


def _tok_bits(t, lc, dc):
    if t[0] == "L":
        return lc[t[1]][1] if t[1] in lc else None
    s, le, d, de = t[1:]
    if s not in lc or d not in dc:
        return None
    return lc[s][1] + _LEN_EXTRA[s - 257] + dc[d][1] + _DIST_EXTRA[d]


def _retokenize(new, p, end, lc, dc):
    """Cheapest token run for new[p:end] using only codes this block has."""
    out = []
    while p < end:
        best, best_cost = None, None
        lt = ("L", new[p])
        if _tok_bits(lt, lc, dc) is not None:
            best, best_cost = lt, _tok_bits(lt, lc, dc)
        best_len = 1
        lo = max(0, p - 32768)
        for src in range(p - 1, lo - 1, -1):
            if new[src] != new[p]:
                continue
            n = 0
            while n < 258 and p + n < end and new[src + n] == new[p + n]:
                n += 1
            if n >= 3:
                for ln in (n,) if n == end - p else (n, 3):
                    t = _enc_match(ln, p - src)
                    c = _tok_bits(t, lc, dc)
                    if c is not None and (best is None or c / ln < best_cost / best_len):
                        best, best_cost, best_len = t, c, ln
        if best is None:
            return None
        out.append(best)
        p += best_len if best[0] == "M" else 1
    return out


def splice_deflate(raw, new):
    blocks, _ = parse_deflate(raw)
    br = BitReader(raw)
    w = BitWriter(b"", 0)
    pos = 0
    for b in blocks:
        br.pos = b["start"]                      # block header copied bit for bit
        n = b["hdr_end"] - b["start"]
        while n:
            k = min(n, 32)
            w.put(br.bits(k), k)
            n -= k
        if b["type"] == 0:
            ln = len(b["stored"])
            for byte in new[pos:pos + ln]:
                w.put(byte, 8)
            pos += ln
            continue
        lc, dc = _codes(b["ll"]), _codes(b["dl"])
        toks = []
        i = 0
        bpos = pos
        ts = b["tokens"]
        while i < len(ts):
            t = ts[i]
            ln = 1 if t[0] == "L" else _match_len_dist(t)[0]
            ok = True
            if t[0] == "L":
                ok = new[bpos] == t[1]
            else:
                _, dist = _match_len_dist(t)
                ok = all(new[bpos + k] == new[bpos - dist + k] for k in range(ln))
            if ok:
                toks.append(t)
                bpos += ln
                i += 1
                continue
            # bad run: extend over following bad tokens, then re-tokenize that span
            run_end = bpos + ln
            j = i + 1
            while j < len(ts):
                t2 = ts[j]
                l2 = 1 if t2[0] == "L" else _match_len_dist(t2)[0]
                if t2[0] == "L":
                    good = new[run_end] == t2[1]
                else:
                    d2 = _match_len_dist(t2)[1]
                    good = all(new[run_end + k] == new[run_end - d2 + k] for k in range(l2))
                if good:
                    break
                run_end += l2
                j += 1
            rt = _retokenize(new, bpos, run_end, lc, dc)
            if rt is None:
                return None
            toks += rt
            bpos = run_end
            i = j
        for t in toks + [("L", 256)]:
            if t[0] == "L":
                c, l = lc[t[1]]
                w.put(int(format(c, "0%db" % l)[::-1], 2), l)
            else:
                s, le, d, de = t[1:]
                c, l = lc[s]
                w.put(int(format(c, "0%db" % l)[::-1], 2), l)
                w.put(le, _LEN_EXTRA[s - 257])
                c, l = dc[d]
                w.put(int(format(c, "0%db" % l)[::-1], 2), l)
                w.put(de, _DIST_EXTRA[d])
        pos = bpos
    if pos != len(new):
        return None
    return bytes(w.out)


def deflate_splice_exact(old_raw, new, raw_len):
    r = splice_deflate(old_raw, new)
    if r is None:
        return None
    out = r
    if len(out) == raw_len:
        return out if zlib.decompress(out, -15) == new else None
    if len(out) > raw_len:
        return None
    start, end = last_block_start(out)
    plan = _pad_plan(end, raw_len)
    if plan is None:
        return None
    w = BitWriter(out, end)
    w.out[start >> 3] &= ~(1 << (start & 7)) & 0xFF
    for i, op in enumerate(plan):
        final = 1 if i == len(plan) - 1 else 0
        w.put(final, 1)
        if op == "F":
            w.put(1, 2)
            w.put(0, 7)
        else:
            w.put(0, 2)
            w.align()
            w.put(0x0000, 16)
            w.put(0xFFFF, 16)
    res = bytes(w.out)
    if len(res) == raw_len and zlib.decompress(res, -15) == new:
        return res
    return None


def encode_frame_like(old_enc, data):
    mode = old_enc[0:1]
    if mode == b"N":
        new = b"N" + data
    elif mode == b"Z":
        zh = old_enc[1:3]
        if zh[1] & 0x20:
            raise Fail("zlib preset dictionary not supported")
        max_wb = min(15, (zh[0] >> 4) + 8)
        raw_len = len(old_enc) - 1 - 2 - 4
        raw = deflate_exact(data, raw_len, max_wb)
        if raw is None:
            raw = deflate_splice_exact(old_enc[3:-4], data, raw_len)
        if raw is None:
            raise Fail("could not re-compress the fog frame to its original size")
        new = b"Z" + zh + raw + struct.pack(">I", zlib.adler32(data) & 0xFFFFFFFF)
    else:
        raise Fail("unsupported frame mode %r" % mode)
    if len(new) != len(old_enc) or decode_frame(new) != data:
        raise Fail("re-encoded frame check failed")
    return new


def patch_span(blob, new_content):
    base, hend, frames = blte_frames(blob)
    out = bytearray(blob)
    pos, cpos, changed = hend, 0, 0
    for f in frames:
        old = decode_frame(f["enc"])
        seg = new_content[cpos:cpos + len(old)]
        if seg != old:
            enc = encode_frame_like(f["enc"], seg)
            out[pos:pos + len(enc)] = enc
            if f["md5_at"] is not None:
                out[f["md5_at"]:f["md5_at"] + 16] = hashlib.md5(enc).digest()
            changed += 1
        pos += len(f["enc"])
        cpos += len(old)
    if cpos != len(new_content):
        raise Fail("content size mismatch")
    out = bytes(out)
    if len(out) != len(blob) or blte_decode(out) != new_content:
        raise Fail("patched data check failed")
    return out, changed, len(frames)


# --------------------------------------------------------------------------- encoding lookup

def encoding_ekey_for(client, ckey):
    key = read_build_key(client)
    cfg = read_build_config(client, key)
    enc_ekey = bytes.fromhex(cfg["encoding"][1])
    _, _, blob = read_span(client, enc_ekey)
    enc = blte_decode(blob)
    if enc[0:2] != b"EN":
        raise Fail("ENCODING file has a bad signature")
    ck_size, ek_size = enc[3], enc[4]
    cpage_kb = struct.unpack_from(">H", enc, 5)[0]
    cpage_count = struct.unpack_from(">I", enc, 9)[0]
    espec_size = struct.unpack_from(">I", enc, 18)[0]
    table = 22 + espec_size
    pages = table + cpage_count * (ck_size + 16)
    psize = cpage_kb * 1024
    page = None
    for i in range(cpage_count):
        first = enc[table + i * (ck_size + 16):table + i * (ck_size + 16) + ck_size]
        if first <= ckey:
            page = i
        else:
            break
    if page is None:
        raise Fail("content key not in ENCODING")
    p = pages + page * psize
    end = p + psize
    while p < end:
        n = enc[p]
        if n == 0:
            break
        ck = enc[p + 6:p + 6 + ck_size]
        if ck == ckey:
            return enc[p + 6 + ck_size:p + 6 + ck_size + ek_size], key
        p += 6 + ck_size + n * ek_size
    raise Fail("content key %s not in ENCODING (is this the 8.3.7 35662 client?)" % ckey.hex())


# ---- Bob Jenkins lookup3 (CASC .idx and data header checksums)

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
    """Bob Jenkins lookup3 hashlittle2 (byte-wise path, same result as aligned paths)."""
    length = len(data)
    a = b = c = (0xDEADBEEF + length + pc) & _M32
    c = (c + pb) & _M32
    k = data
    i = 0
    while length > 12:
        a = (a + int.from_bytes(k[i:i + 4], "little")) & _M32
        b = (b + int.from_bytes(k[i + 4:i + 8], "little")) & _M32
        c = (c + int.from_bytes(k[i + 8:i + 12], "little")) & _M32
        a, b, c = _mix(a, b, c)
        length -= 12
        i += 12
    if length == 0:
        return c, b
    tail = k[i:i + length] + bytes(12 - length)
    a = (a + int.from_bytes(tail[0:4], "little")) & _M32
    b = (b + int.from_bytes(tail[4:8], "little")) & _M32
    c = (c + int.from_bytes(tail[8:12], "little")) & _M32
    a, b, c = _final(a, b, c)
    return c, b


def hashlittle(data, initval=0):
    return hashlittle2(data, initval, 0)[0]


_OFFS_TABLE = [0x049396B8, 0x72A82A9B, 0xEE626CCA, 0x9917754F, 0x15DE40B1, 0xF5A8A9B6, 0x421EAC7E, 0xA9D55C9A,
               0x317FD40C, 0x04FAF80D, 0x3D6BE971, 0x52933CFD, 0x27F64B7D, 0xC6F5C11B, 0xD5757E3A, 0x6C388745]


def span_header_checks(hdr30, offset):
    """(jenkins, checksum) the 30-byte data.NNN header should carry (CascLib VerifyHeaderSpan)."""
    jen = hashlittle(hdr30[0:0x16], 0x3D6BE971).to_bytes(4, "little")
    v = (offset + 30) & 0xFFFFFFFF
    enc_off = (_OFFS_TABLE[v & 0xF] ^ v).to_bytes(4, "little")
    hh = bytearray(4)
    part = hdr30[0:0x16] + jen
    for i in range(0x1A):
        hh[i & 3] ^= part[i]
    chk = bytes(hh[(0x1A + j) & 3] ^ enc_off[(0x1A + j) & 3] for j in range(4))
    return jen, chk


def cmd_check(client):
    """Read-only: do this client's .idx and data headers use the checksums we know how to write?"""
    import random
    files = idx_files(client)
    ok_hdr = ok_blk = 0
    samples = []
    for b, p in sorted(files.items()):
        data = open(p, "rb").read()
        hsize, hhash = struct.unpack_from("<II", data, 0)
        ok_hdr += hashlittle(data[8:8 + hsize], 0) == hhash
        seg_bits = data[8 + 7]
        pos = ((8 + hsize) + 15) & ~15
        bsz, bhash = struct.unpack_from("<II", data, pos)
        pos += 8
        pc = pb = 0
        for i in range(bsz // 18):
            pc, pb = hashlittle2(data[pos + 18 * i:pos + 18 * i + 18], pc, pb)
        ok_blk += pc == bhash
        ents = [data[pos + 18 * i:pos + 18 * i + 18] for i in range(bsz // 18)]
        print("  %s: %d entries, header hash %s, entries hash %s, file %d bytes" % (
            os.path.basename(p), len(ents), "ok" if hashlittle(data[8:8 + hsize], 0) == hhash else "MISMATCH",
            "ok" if pc == bhash else "MISMATCH", len(data)))
        random.seed(b)
        samples += [(e, seg_bits) for e in random.sample(ents, min(15, len(ents)))]
    print("idx: %d/%d header hashes ok, %d/%d entry-block hashes ok" % (ok_hdr, len(files), ok_blk, len(files)))
    good = {"key": 0, "size": 0, "jenkins": 0, "checksum": 0, "blte": 0, "ekey=md5(hdr)": 0}
    for e, seg_bits in samples:
        so = int.from_bytes(e[9:14], "big")
        arc, off, size = so >> seg_bits, so & ((1 << seg_bits) - 1), struct.unpack_from("<I", e, 14)[0]
        with open(data_path(client, arc), "rb") as f:
            f.seek(off)
            blob = f.read(min(size, 1 << 20))
        h = blob[0:30]
        good["key"] += h[0:16][::-1][:9] == e[:9]
        good["size"] += struct.unpack_from("<I", h, 16)[0] == size
        jen, chk = span_header_checks(h, off)
        good["jenkins"] += h[0x16:0x1A] == jen
        good["checksum"] += h[0x1A:0x1E] == chk
        good["blte"] += blob[30:34] == b"BLTE"
        hs = struct.unpack_from(">I", blob, 34)[0]
        ek = h[0:16][::-1]
        if hs:
            good["ekey=md5(hdr)"] += hashlib.md5(blob[30:30 + hs]).digest() == ek
        elif len(blob) == size:
            good["ekey=md5(hdr)"] += hashlib.md5(blob[30:]).digest() == ek
    print("data headers (%d samples): %s" % (len(samples), good))
    d = cpath(client, "Data", "data")
    nums = sorted(int(f[5:]) for f in os.listdir(d) if f.lower().startswith("data.") and f[5:].isdigit())
    print("data files: %s .. %s, last %s is %d bytes; shmem: %s" % (
        nums[0], nums[-1], nums[-1], os.path.getsize(data_path(client, nums[-1])),
        [f for f in os.listdir(d) if "shmem" in f.lower()]))


# --------------------------------------------------------------------------- diagnostics

def enc_lookup_all(enc, ckey):
    ck_size, ek_size = enc[3], enc[4]
    cpage_kb = struct.unpack_from(">H", enc, 5)[0]
    cpage_count = struct.unpack_from(">I", enc, 9)[0]
    espec_size = struct.unpack_from(">I", enc, 18)[0]
    table = 22 + espec_size
    pages = table + cpage_count * (ck_size + 16)
    psize = cpage_kb * 1024
    for i in range(cpage_count):
        p = pages + i * psize
        end = p + psize
        while p < end:
            n = enc[p]
            if n == 0:
                break
            if enc[p + 6:p + 6 + ck_size] == ckey:
                return [enc[p + 6 + ck_size + k * ek_size:p + 6 + ck_size + (k + 1) * ek_size] for k in range(n)]
            p += 6 + ck_size + n * ek_size
    return []


def idx_all_hits(client, ekey):
    d = cpath(client, "Data", "data")
    hits = []
    for fn in sorted(os.listdir(d)):
        if not fn.lower().endswith(".idx"):
            continue
        with open(os.path.join(d, fn), "rb") as f:
            data = f.read()
        try:
            hsize = struct.unpack_from("<I", data, 0)[0]
            seg_bits = data[8 + 7]
            pos = ((8 + hsize) + 15) & ~15
            bsz = struct.unpack_from("<I", data, pos)[0]
            pos += 8
        except (struct.error, IndexError):
            hits.append((fn, "unreadable"))
            continue
        end = min(len(data), pos + bsz)
        while pos + 18 <= end:
            if data[pos:pos + 9] == ekey[:9]:
                so = int.from_bytes(data[pos + 9:pos + 14], "big")
                hits.append((fn, "data.%03d @ %d size %d" % (so >> seg_bits, so & ((1 << seg_bits) - 1),
                                                              struct.unpack_from("<I", data, pos + 14)[0])))
            pos += 18
    return hits


def root_fdids_for(root, ckey):
    """8.x root (TSFM or legacy blocks): fdids whose ckey matches, plus fdid->ckeys map for them."""
    pos = 0
    named = True
    if root[0:4] == b"TSFM":
        pos = 12
    found = {}
    blocks = []
    while pos + 12 <= len(root):
        n, cflags, lflags = struct.unpack_from("<III", root, pos)
        pos += 12
        deltas = struct.unpack_from("<%di" % n, root, pos)
        pos += 4 * n
        fd = -1
        ids = []
        for dl in deltas:
            fd += dl + 1
            ids.append(fd)
        ck = [root[pos + 16 * i:pos + 16 * i + 16] for i in range(n)]
        pos += 16 * n
        if not (root[0:4] == b"TSFM" and cflags & 0x10000000):
            pos += 8 * n
        blocks.append((cflags, lflags, ids, ck))
    want = set()
    for cflags, lflags, ids, ck in blocks:
        for i, c in zip(ids, ck):
            if c == ckey:
                want.add(i)
    for cflags, lflags, ids, ck in blocks:
        for i, c in zip(ids, ck):
            if i in want:
                found.setdefault(i, []).append((c.hex(), hex(cflags), hex(lflags)))
    return found


def cmd_diag(client):
    print("== client folder")
    for name in sorted(os.listdir(client)):
        p = os.path.join(client, name)
        print("  %s%s" % (name, "/" if os.path.isdir(p) else "  (%d bytes)" % os.path.getsize(p)))
    print("== folders holding .idx files (depth 4)")
    for root, dirs, files in os.walk(client):
        if root[len(client):].count(os.sep) > 4:
            dirs[:] = []
            continue
        n = sum(1 for f in files if f.lower().endswith(".idx"))
        if n:
            print("  %s: %d .idx, %d data.NNN" % (root, n, sum(1 for f in files if f.lower().startswith("data."))))
    bi = cpath(client, ".build.info")
    print("== .build.info")
    if os.path.isfile(bi):
        print(open(bi, encoding="utf-8", errors="replace").read().strip())
    else:
        print("  (none)")
    print("== configs")
    cfgdir = cpath(client, "Data", "config")
    builds = []
    for root, _, files in os.walk(cfgdir):
        for fn in sorted(files):
            try:
                txt = open(os.path.join(root, fn), encoding="utf-8", errors="replace").read(200000)
            except OSError:
                continue
            kv = dict(l.split(" = ", 1) for l in txt.splitlines() if " = " in l)
            if "encoding" in kv:
                builds.append((fn, kv))
                print("  build %s: %s root=%s encoding=%s" % (fn, kv.get("build-name", "?"), kv.get("root", "?"),
                                                              kv.get("encoding", "?")))
            elif "archives" in kv:
                print("  cdn   %s: %d archives" % (fn, len(kv["archives"].split())))
            else:
                print("  other %s: %s" % (fn, txt[:60].replace("\n", " | ")))
    for fn, kv in builds:
        print("== build config %s" % fn)
        try:
            enc_ekey = bytes.fromhex(kv["encoding"].split()[1])
            _, _, blob = read_span(client, enc_ekey)
            enc = blte_decode(blob)
        except Exception as e:
            print("  encoding not readable: %s" % e)
            continue
        ekeys = enc_lookup_all(enc, WMO_CKEY)
        print("  WMO ckey %s -> ekeys %s" % (WMO_CKEY.hex(), [e.hex() for e in ekeys]))
        for e in ekeys:
            for h in idx_all_hits(client, e):
                print("    %s in %s: %s" % (e.hex()[:18], h[0], h[1]))
        try:
            rck = bytes.fromhex(kv["root"].split()[0])
            rek = enc_lookup_all(enc, rck)
            _, _, rblob = read_span(client, rek[0])
            root = blte_decode(rblob)
            found = root_fdids_for(root, WMO_CKEY)
            print("  root (%s, %d bytes): file ids with this WMO: %s" % (root[0:4], len(root), found or "NONE"))
        except Exception as e:
            print("  root not readable: %s" % e)


# --------------------------------------------------------------------------- commands

def backup_paths(client):
    d = os.path.join(client, BACKUP_DIR)
    return d, os.path.join(d, "blackrock_lower_instance.span"), os.path.join(d, "blackrock_lower_instance.json")


def locate(client):
    ekey, build_key = encoding_ekey_for(client, WMO_CKEY)
    path, offset, blob = read_span(client, ekey)
    return ekey, build_key, path, offset, blob


def cmd_status(client):
    ekey, build_key, path, offset, blob = locate(client)
    _, _, frames = blte_frames(blob)
    print("build config  %s" % build_key)
    print("encoded key   %s" % ekey.hex())
    print("stored at     %s offset %d (%d bytes, %d frame(s), modes %s)" % (
        path, offset, len(blob), len(frames), "".join(chr(f["enc"][0]) for f in frames)))
    print("current state %s" % state_of(blte_decode(blob)))
    _, sp, meta = backup_paths(client)
    print("backup        %s" % (sp if os.path.isfile(sp) else "none yet"))


def cmd_apply(client, variant):
    ekey, build_key, path, offset, blob = locate(client)
    current = blte_decode(blob)
    cur_state = state_of(current)
    bdir, sp, meta = backup_paths(client)
    if cur_state == "original":
        if not os.path.isfile(sp):
            os.makedirs(bdir, exist_ok=True)
            with open(sp, "wb") as f:
                f.write(blob)
            with open(meta, "w") as f:
                json.dump({"data_file": os.path.basename(path), "offset": offset, "size": len(blob),
                           "ekey": ekey.hex(), "build_config": build_key,
                           "md5": hashlib.md5(blob).hexdigest()}, f, indent=1)
            print("saved original bytes to %s" % sp)
        orig_blob = blob
    else:
        if not os.path.isfile(sp):
            raise Fail("stored file is '%s' and there is no backup of the original" % cur_state)
        with open(sp, "rb") as f:
            orig_blob = f.read()
        if len(orig_blob) != len(blob) or state_of(blte_decode(orig_blob)) != "original":
            raise Fail("backup does not match this storage")
    if cur_state == variant:
        print("already '%s', nothing to do" % variant)
        return
    new_content = make_variant(blte_decode(orig_blob), variant)
    new_blob, changed, total = patch_span(orig_blob, new_content)
    with open(path, "r+b") as f:
        f.seek(offset)
        f.write(new_blob)
        f.flush()
        os.fsync(f.fileno())
    _, _, check = read_span(client, ekey)
    if check != new_blob:
        raise Fail("read-back after writing does not match")
    print("wrote '%s' into %s at offset %d (%d of %d frame(s) re-encoded, same size)" % (
        variant, os.path.basename(path), offset, changed, total))
    print("state now: %s" % state_of(blte_decode(check)))


def cmd_restore(client):
    bdir, sp, meta = backup_paths(client)
    if not os.path.isfile(sp):
        raise Fail("no backup in " + bdir)
    with open(meta) as f:
        m = json.load(f)
    with open(sp, "rb") as f:
        orig = f.read()
    if hashlib.md5(orig).hexdigest() != m["md5"] or state_of(blte_decode(orig)) != "original":
        raise Fail("backup file is damaged")
    path = cpath(client, "Data", "data", m["data_file"])
    with open(path, "rb") as f:
        f.seek(m["offset"])
        cur = f.read(m["size"])
    if cur[0:30] != orig[0:30]:
        raise Fail("the stored entry header changed since the backup (client repaired or updated?); not writing")
    with open(path, "r+b") as f:
        f.seek(m["offset"])
        f.write(orig)
        f.flush()
        os.fsync(f.fileno())
    with open(path, "rb") as f:
        f.seek(m["offset"])
        ok = f.read(m["size"]) == orig
    print("restored original bytes in %s at offset %d: %s" % (m["data_file"], m["offset"], "ok" if ok else "READ-BACK FAILED"))


def main(argv):
    if len(argv) < 3 or argv[2] not in ("status", "apply", "restore", "diag", "check") or (argv[2] == "apply" and (len(argv) < 4 or argv[3] not in ("off", "swap", "probe"))):
        print(__doc__)
        return 2
    client = argv[1]
    if not os.path.isdir(cpath(client, "Data", "data")):
        print("error: %s has no Data/data folder" % client)
        return 1
    try:
        if argv[2] == "status":
            cmd_status(client)
        elif argv[2] == "diag":
            cmd_diag(client)
        elif argv[2] == "check":
            cmd_check(client)
        elif argv[2] == "apply":
            cmd_apply(client, argv[3])
        else:
            cmd_restore(client)
    except Fail as e:
        print("error: %s" % e)
        return 1
    except PermissionError as e:
        print("error: %s (close the game and the launcher first)" % e)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
