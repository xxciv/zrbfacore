# brd_fog_casc.py

Writes an edited Blackrock Depths root WMO (`blackrock_lower_instance.wmo`, 8.3.7 build 35662) straight into the
client's CASC storage, because the WoW Circle 8.3.7 client ignores loose files.

How it works:

1. `.build.info` (or the 35662 build config in `Data/config` if there is none) gives the ENCODING file.
2. ENCODING maps the WMO's content key `ba1f2379e67cfe1f5ecdf70469363c1c` to its encoded key.
3. The newest `Data/data/XX########.idx` for that key's bucket gives `data.NNN` and the offset.
4. The stored BLTE data is decoded, the 9 MFOG fog entries are edited, and only the frame holding them is
   re-encoded to exactly its old byte size (zlib first; if zlib can't hit the size, the original deflate blocks are
   kept and only the changed tokens are rewritten). The frame's MD5 in the BLTE header is updated.
   Index, ENCODING, root and config files are not touched.
5. The original span is saved to `<client>/zr_casc_backup/` before the first write. `restore` writes it back.

Variants: `off` sets both radii of the 9 fog spheres to 0; `swap` swaps the red and blue bytes of the fog and
underwater colours. Both must produce the exact files in the project's `blackrock-fog/` folder (MD5 checked).

Open question: the encoded key no longer matches the MD5 of the edited BLTE header. If the client checks that,
it will report a corrupt file; run `restore`.

```
py brd_fog_casc.py "C:\Users\void\Downloads\WoWCircle 8.3.7 BFA" status
py brd_fog_casc.py "C:\Users\void\Downloads\WoWCircle 8.3.7 BFA" apply off
py brd_fog_casc.py "C:\Users\void\Downloads\WoWCircle 8.3.7 BFA" apply swap
py brd_fog_casc.py "C:\Users\void\Downloads\WoWCircle 8.3.7 BFA" restore
```
Close the game first. Tested only against synthetic CASC stores (zlib levels 1-9, 16K/64K/single frames, N frames,
no .build.info): apply off/swap/off then restore gives a byte-identical data file.
