# NPC Designer

A desktop app (Python + Qt) for designing custom NPCs and exporting them as SQL for the world database.
The first module is **vendors**: name, title, model, level, faction and flags, the items for sale and their
prices, with a live mock-up of the in-game merchant window. It writes one `.sql` file to import, after
which you spawn the NPC with `.npc add`.

| Target | Core | World DB | Per-vendor prices |
|---|---|---|---|
| Wrath of the Lich King 3.3.5a | TrinityCore 3.3.5 | `world` | no (optional global `item_template.BuyPrice` change) |
| Mists of Pandaria 5.4.8 | pandaria_5.4.8 | `world` | with [`vendor-price.patch`](https://github.com/xxciv/zrpandaria548/blob/main/docs/pandaria-debian13.md#14-per-vendor-item-prices-optional-for-the-npc-designer) |
| Battle for Azeroth 8.3.7 | BFA-HavenCore | `bfa_world` | yes (`npc_vendor.OverrideGoldCost`) |

Status: confirmed working on BFA by Four on 2026-10-12 (item data from a real 8.3.7 `ItemSparse.db2`,
SQL export and Apply to database). The Pandaria and WotLK exports are tested against their schemas only.

The table and column names come from each core's own loader queries and base schema. Exports were imported
into the BFA dump's schema, the pandaria_5.4.8 base schema and TrinityCore 3.3.5's current schema on MySQL 8
in strict mode, twice each (re-importing replaces the NPC instead of duplicating it). AzerothCore keeps
models in a separate table and is not a target yet.

## Install and run (Fedora)

```sh
sudo dnf install python3-pyside6 python3-pymysql
git clone https://github.com/xxciv/zrbfacore.git ~/zrbfacore     # or: git -C ~/zrbfacore pull
~/zrbfacore/tools/npc-designer/npc-designer
```

If `dnf` can't find `python3-pyside6`, use a virtual environment instead (works in bash and fish):

```sh
python3 -m venv ~/.local/npc-designer-venv
~/.local/npc-designer-venv/bin/pip install PySide6 PyMySQL
~/.local/npc-designer-venv/bin/python ~/zrbfacore/tools/npc-designer/npc-designer
```

PyMySQL is optional; it's only used for the database buttons below.

## Designing a vendor

1. **Target version** first: it decides the columns, level cap and price handling.
2. **NPC tab**: entry (custom NPCs start at 900000), name, title (shown as `<Title>`), mouse cursor,
   display IDs, levels, faction, scale, vendor type (food, poison and reagent vendors show under minimap
   tracking), repair, and the items it holds in its hands.
   - Display IDs: several are allowed, one is picked per spawn. To see one in game, type
     `.morph 3167` on your character (`.demorph` to undo). **Copy from NPC…** takes the models of an existing
     creature entry when you're connected to the database.
3. **Items for sale**: search by name or ID and double-click, or **Add by ID…**. Per row:
   - *Vendor price*: blank = the item's own price, or e.g. `1g 50s`, `75s`, `20c`, or plain copper. It is the
     price of one purchase, which is one stack of the item's buy count (shown in *Item price* as "per 5").
   - *Stock* and *Restock (s)*: limited stock; both must be set, or both 0 for unlimited.
   - *Ext. cost*: an `ItemExtendedCost` ID for token or currency costs (0 = gold only).
   - The order of the rows is the order in the shop. Clicking an item in the preview selects its row.
4. **File > Save** keeps the design as a `.npc.json` file; **File > Export SQL…** (Ctrl+E) writes the SQL.
   Problems (no model, levels out of range, the same item twice, half-set stock) are listed under the preview.

### Item names and prices

The table and preview need item data, from **Items** in the menu:

- **Pandaria and BFA: Load from server dbc folder…** Pick the `dbc` folder `mapextractor` made (the one in
  your client folder before you copied it to the server, or `~/bfa/server/data/dbc` on the server). It reads
  `ItemSparse.db2` (BFA, under `dbc/enUS/`) or `Item-sparse.db2` (Pandaria) directly.
- **WotLK: Load from world database…** The 3.3.5 client tables have no item names; `item_template` has them.
- **Load from CSV…** Any CSV with a header row and `ID`, `Name` columns, plus `Quality`, `BuyPrice`,
  `BuyCount` if you have them (an ItemSparse export from a DB2 tool works).

Without item data you can still add items by ID; they just show without names.

### Database connection (optional)

**Database > Connect to world database…** enables:

- **File > Apply to database…** (Ctrl+Shift+E): runs the export straight on the world database, no file to
  copy. It first checks the database matches the target version (and, for Pandaria prices, that the
  vendor-price column exists), and says whether the entry is new or replaces an existing NPC.
- **Next free** (first unused entry from 900000), **Copy from NPC…** and the WotLK item list.

MySQL on the server only listens on the server itself, so connect through an SSH tunnel from your PC
(works in fish too; leave it running while you use the designer):

```sh
ssh -N -L 3307:127.0.0.1:3306 you@192.168.x.x
```

Then connect to host `127.0.0.1`, port `3307`, user `root` and your MySQL root password. The password is
never saved.

## Import and spawn

With **Apply to database** the NPC is already in the database; skip to restarting worldserver. Otherwise copy
the SQL to the server, import it, restart worldserver, then spawn it in game:

```sh
scp ~/900000_gilda_copperpot_bfa.sql you@192.168.x.x:
ssh you@192.168.x.x
mysql -u root -p bfa_world < ~/900000_gilda_copperpot_bfa.sql      # Pandaria / WotLK: world
```

Restart worldserver (a new creature entry is only loaded at startup), then in game, standing where the NPC
should be:

```
.npc add 900000
```

`.npc add` saves the spawn in the `creature` table, so it's there after restarts. To change only the items of
an NPC that already exists, re-import the SQL and type `.reload npc_vendor` instead of restarting.

Spawns can also go in the export (**Spawns** tab, by map and coordinates, or by pasting `.gps` output from the
worldserver console or `Logs/WoWChatLog.txt` after `/chatlog`). If any spawn is listed, the export deletes
**every** spawn of that entry first, including ones made with `.npc add`, and places the listed ones.

What the export writes, per target: `creature_template` (vendor flag `npcflag` 128, plus repair 4096 /
gossip 1 / tracking flags), the models (`modelid1-4`, or `creature_template_model` on BFA), an optional
`creature_equip_template`, `npc_vendor` with a comment per row, and optionally `creature`. Every statement
deletes the entry's old rows first, so exporting again and re-importing updates the NPC.

## Viewing models from client data

Not built yet. It needs reading models from the client (CASC archives on BFA, MPQ on WotLK and Pandaria),
the M2 model and BLP texture formats, and creature display info to put the right textures on the right model,
then a 3D view. That is a project of its own; the in-game `.morph <display id>` is the quick way to preview a
model meanwhile. wow.export (BFA) and WoW Model Viewer (WotLK, Pandaria) can browse creature models by
display ID outside the game.

## Tests

```sh
python3 -m unittest discover -s ~/zrbfacore/tools/npc-designer/tests
```

They cover the SQL for each target, validation, price and `.gps` parsing, and the item table readers (WDB2, WDC3 and sparse WDC3).
The readers were tested on files built to the format spec, not on files from a real client yet.
