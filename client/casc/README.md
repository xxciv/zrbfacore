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
python3 brd_fog_casc.py "/mnt/1TB/WoWCircle 8.3.7 BFA" status
python3 brd_fog_casc.py "/mnt/1TB/WoWCircle 8.3.7 BFA" apply off
python3 brd_fog_casc.py "/mnt/1TB/WoWCircle 8.3.7 BFA" apply swap
python3 brd_fog_casc.py "/mnt/1TB/WoWCircle 8.3.7 BFA" restore
```
(On Windows use `py` and the Windows path.) Folder names are matched case-insensitively.
Close the game first. Tested only against synthetic CASC stores (zlib levels 1-9, 16K/64K/single frames, N frames,
no .build.info): apply off/swap/off then restore gives a byte-identical data file.

## zr_casc_inject.py (the one that works with WoW Circle)

The WoW Circle client checks every stored file against its key and re-downloads anything that doesn't match
(from `cdn-bfa.wowcircle.me`, or it fails with a streaming error when offline), so the in-place edit above gets
undone. `zr_casc_inject.py` leaves all original data alone and adds a correctly keyed patch instead:

1. edited WMO, new ROOT (file 108299 -> edited WMO) and new ENCODING (knows both) go into a new `data.NNN`
2. their keys are added to the bucket `.idx` files (originals backed up to `zr_casc_backup/idx/`)
3. a new build config names the new ROOT and ENCODING
4. `.fzbuildnfo` (WoW Circle's renamed `.build.info`) is pointed at the new build config

`uninject` points `.fzbuildnfo` back at the original build config. Needs offline mode: `.fzbuildnfo` present and
`cdn-bfa.wowcircle.me` blocked in `/etc/hosts`.

```
python3 zr_casc_inject.py "/mnt/1TB/WoWCircle 8.3.7 BFA" status
python3 zr_casc_inject.py "/mnt/1TB/WoWCircle 8.3.7 BFA" inject probe|off|swap
python3 zr_casc_inject.py "/mnt/1TB/WoWCircle 8.3.7 BFA" uninject
```
Tested on synthetic stores with valid idx/header checksums: CascLib reads file 108299 as the injected variant,
and as the original after `uninject`. `brd_fog_casc.py check` confirmed the idx hashes and key = MD5(BLTE header)
on Four's client.

## Extracting files (read-only)

`python3 zr_casc_inject.py "<client>" extract <out folder> brd` writes the BRD root WMO
(108299) and all 48 group files from the build the client currently uses, and prints every
liquid plane (MLIQ) in the groups with its position, height range and shown/hidden tiles.
`extract <out folder> <file ID> ...` writes any files by ID.

## Liquid variants (BRD group files)

`inject liqfix` edits the six BRD group files that carry lava (MLIQ): vertices that only touch
hidden tiles (stored at height 0.0) are lowered to the liquid's base height, so the lava itself
is unchanged. `inject liqoff` (test only) hides every liquid tile in those files. Each inject
starts again from the original build, so variants don't stack; `uninject` undoes any of them.

## Light variants

`inject lighttest` (test only) paints the default outdoor light (Light 1, LightParams
3/10/12/13) pure green in LightData.db2. `inject lightfix` adds a map-wide Light.db2 row for
Blackrock Depths (map 230, position 0,0,0) that uses LightParams 1989 (all colours black), so
the client no longer falls back to the default outdoor light (blue at night) there.

## Finding and replacing text files (login screen news etc.)

```
python3 zr_casc_inject.py "<client>" find ~/Downloads/zr_find                 # "fstorm", "live changelog"
python3 zr_casc_inject.py "<client>" find ~/Downloads/zr_find "some text" ...
```

Read-only. Goes through every stored file in disk order, decodes only the ones that start like
text (Lua, XML, TOC, ...), and lists the file IDs whose content contains one of the texts
(ignoring case). Each hit is saved as `<out>/<file ID>.txt`. With `--all` it also searches binary
files (DB2 etc., UTF-8 and UTF-16 text), skipping textures, sound and models; slower.

To replace whole files with edited copies:

```
python3 zr_casc_inject.py "<client>" inject file 1234567=~/Downloads/zr_find/1234567.txt [more ...]
```

This works like the other variants (new ROOT/ENCODING/build config, `.fzbuildnfo` switched), so
`uninject` undoes it, and every `inject` starts again from the original build: put all the files
you want replaced in one `inject file` command.

## Login screen: no Firestorm news / changelog panels

With WoW Circle's patch server blocked, the local build's AccountLogin.lua (file ID 804870) shows
two `ServerAlertTemplate` frames left over from Firestorm: `ServerAlertFrame` ("News", fed from
`SERVER_ALERT_URL` = http://bfa.fstorm.eu/news.php in GlobalStrings) and `GlueChangelogFrame`
("Live Changelog"). `login-news/AccountLogin_804870.lua` is that file with both switched to
`ServerAlert_Disable`, and an OnShow hook hides them again if the client shows them itself:

```
python3 zr_casc_inject.py "<client>" inject file 804870=login-news/AccountLogin_804870.lua
```
