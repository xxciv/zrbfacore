"""python3 -m unittest discover -s tools/npc-designer/tests   (no Qt or database needed)"""

import os
import struct
import sys
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from npcdesigner import db2  # noqa: E402
from npcdesigner.model import Npc, Spawn, VendorItem, parse_gps, parse_money  # noqa: E402
from npcdesigner.targets import export_sql, validate  # noqa: E402


def sample(target, **kw):
    args = dict(target=target, name="Gil's Goods", display_ids=[3167, 3168],
                items=[VendorItem(159, 25), VendorItem(4540), VendorItem(2901, 15000, 5, 600)])
    args.update(kw)
    return Npc(**args)


class ExportTest(unittest.TestCase):
    def test_bfa_uses_model_table_and_vendor_prices(self):
        sql = export_sql(sample("bfa"))
        self.assertIn("INSERT INTO `creature_template_model`", sql)
        self.assertNotIn("modelid1", sql)
        self.assertIn("`type`, `OverrideGoldCost`", sql)
        self.assertIn("(@ENTRY, 0, 159, 0, 0, 0, 1, 25)", sql)
        self.assertIn("(@ENTRY, 1, 4540, 0, 0, 0, 1, -1)", sql)
        self.assertIn("'Gil\\'s Goods'", sql)

    def test_pandaria_price_column_follows_patch_setting(self):
        self.assertIn("OverrideGoldCost", export_sql(sample("pandaria")))
        sql = export_sql(sample("pandaria", pandaria_price_patch=False))
        self.assertNotIn("OverrideGoldCost", sql)
        self.assertIn("`modelid1`, `modelid2`, `modelid3`, `modelid4`", sql)
        self.assertIn("(@ENTRY, 1, 4540, 0, 0, 0, 1)", sql)

    def test_wotlk_has_no_type_column_and_global_prices_are_opt_in(self):
        sql = export_sql(sample("wotlk"))
        self.assertIn("(`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`) VALUES", sql)
        self.assertNotIn("item_template", sql)
        sql = export_sql(sample("wotlk", wotlk_global_prices=True))
        self.assertIn("UPDATE `item_template` SET `BuyPrice` = 25 WHERE `entry` = 159;", sql)
        self.assertNotIn("WHERE `entry` = 4540;", sql)

    def test_spawns_use_each_cores_columns(self):
        spawn = [Spawn(0, -8833.38, 628.62, 94.0, 1.06)]
        self.assertIn("`spawnDifficulties`, `PhaseId`", export_sql(sample("bfa", spawns=spawn)))
        self.assertIn("`spawndist`, `MovementType`", export_sql(sample("bfa", spawns=spawn)))
        self.assertIn("`wander_distance`, `movement_type`", export_sql(sample("pandaria", spawns=spawn)))
        self.assertIn("`wander_distance`, `MovementType`", export_sql(sample("wotlk", spawns=spawn)))
        self.assertNotIn("DELETE FROM `creature` ", export_sql(sample("bfa")))

    def test_validate(self):
        self.assertEqual(validate(sample("bfa")), [])
        npc = sample("wotlk", display_ids=[], maxlevel=90)
        npc.items.append(VendorItem(159, 30))
        npc.items.append(VendorItem(1, maxcount=3))
        text = " ".join(validate(npc))
        self.assertIn("display ID", text)
        self.assertIn("<= 83", text)
        self.assertIn("listed twice", text)
        self.assertIn("restock", text)

    def test_project_round_trip(self):
        npc = sample("pandaria", spawns=[Spawn(1, 2, 3, 4, 5)])
        again = Npc.from_json(npc.to_json())
        self.assertEqual(again, npc)


class ParseTest(unittest.TestCase):
    def test_money(self):
        self.assertEqual(parse_money("1g 50s"), 15000)
        self.assertEqual(parse_money("75s"), 7500)
        self.assertEqual(parse_money("1234"), 1234)
        self.assertIsNone(parse_money(""))
        with self.assertRaises(ValueError):
            parse_money("cheap")

    def test_gps(self):
        text = ("Map: 0 (Eastern Kingdoms) Zone: 1519 (Stormwind City) Area: 5150 (Trade District)\r\n"
                "X: |cffffffff|Hpos:|h-8833.380859|h|r Y: |cffffffff|Hpos:|h628.627991|h|r "
                "Z: |cffffffff|Hpos:|h94.006622|h|r Orientation: |cffffffff|Hpos:|h1.064651|h|r")
        s = parse_gps(text)
        self.assertEqual(s.map, 0)
        self.assertAlmostEqual(s.x, -8833.380859)
        self.assertAlmostEqual(s.o, 1.064651)
        self.assertIsNone(parse_gps("nothing here"))


def build_wdb2(rows):
    """rows: (id, name, quality, buy_count, buy_price)"""
    fields = db2.WDB2_ITEMSPARSE_FIELDS
    strings = b"\0"
    records = b""
    for ident, name, quality, count, price in rows:
        vals = [0] * fields
        vals[db2.WDB2_ID], vals[db2.WDB2_QUALITY] = ident, quality
        vals[db2.WDB2_BUYCOUNT], vals[db2.WDB2_BUYPRICE] = count, price
        vals[db2.WDB2_NAME] = len(strings)
        strings += name.encode() + b"\0"
        records += struct.pack(f"<{fields}I", *vals)
    min_id, max_id = min(r[0] for r in rows), max(r[0] for r in rows)
    n = max_id - min_id + 1
    head = b"WDB2" + struct.pack("<7I", len(rows), fields, fields * 4, len(strings), 0, 18414, 0)
    head += struct.pack("<4I", min_id, max_id, 0, 0) + b"\0" * (n * 6)
    return head + records + strings


def build_wdc3(sections):
    """sections: list of lists of (id, name, quality, buy_count, buy_price); last section gets a copy row.

    Field layout: 62 fields. Name (5) plain 32-bit string offset, BuyPrice (17) bitpacked 20 bits,
    VendorStackCount (18) common data (default 1), OverallQualityID (61) pallet indexed. Every
    other field is bitpacked 1 bit (always 0).
    """
    fields = db2.WDC3_ITEMSPARSE_FIELDS
    storage = []
    bit = 0
    pallet_vals = sorted({r[2] for s in sections for r in s})
    commons = [(r[0], r[3]) for s in sections for r in s if r[3] != 1]
    for f in range(fields):
        if f == db2.WDC3_NAME:
            bit = (bit + 7) // 8 * 8   # uncompressed fields are byte aligned
            storage.append((bit, 32, 0, db2.STORAGE_NONE, 0, 0, 0))
            bit += 32
        elif f == db2.WDC3_BUYPRICE:
            storage.append((bit, 20, 0, db2.STORAGE_BITPACKED, bit, 20, 0))
            bit += 20
        elif f == db2.WDC3_BUYCOUNT:
            storage.append((0, 0, len(commons) * 8, db2.STORAGE_COMMON, 1, 0, 0))
        elif f == db2.WDC3_QUALITY:
            storage.append((bit, 3, len(pallet_vals) * 4, db2.STORAGE_INDEXED, bit, 3, 0))
            bit += 3
        else:
            storage.append((bit, 1, 0, db2.STORAGE_BITPACKED, bit, 1, 0))
            bit += 1
    record_size = (bit + 7) // 8
    total = sum(len(s) for s in sections)
    pallet = struct.pack(f"<{len(pallet_vals)}I", *pallet_vals)
    common = b"".join(struct.pack("<II", i, v) for i, v in commons)
    storage_blob = b"".join(struct.pack("<HHIIIII", *s) for s in storage)
    field_struct = b"".join(struct.pack("<hH", 0, 0) for _ in range(fields))
    header_size = 72 + 40 * len(sections)
    data_start = header_size + len(field_struct) + len(storage_blob) + len(pallet) + len(common)

    blobs, sec_headers = [], []
    offset = data_start
    global_index = 0
    string_base = 0
    for si, rows in enumerate(sections):
        recs, strings = b"", b""
        for local, (ident, name, quality, _count, price) in enumerate(rows):
            gi = global_index + local
            field_pos = gi * record_size + storage[db2.WDC3_NAME][0] // 8
            target = total * record_size + string_base + len(strings)  # where the string lands
            value = 0
            value |= (target - field_pos) & 0xFFFFFFFF
            strings += name.encode() + b"\0"
            v = value << storage[db2.WDC3_NAME][0]
            v |= price << storage[db2.WDC3_BUYPRICE][0]
            v |= pallet_vals.index(quality) << storage[db2.WDC3_QUALITY][0]
            recs += v.to_bytes(record_size, "little")
        ids = struct.pack(f"<{len(rows)}I", *[r[0] for r in rows])
        copy = struct.pack("<II", 90000 + si, rows[0][0]) if si == len(sections) - 1 else b""
        blob = recs + strings + ids + copy
        sec_headers.append(struct.pack("<Q8I", 0, offset, len(rows), len(strings), 0, len(ids), 0, 0,
                                       1 if copy else 0))
        blobs.append(blob)
        offset += len(blob)
        global_index += len(rows)
        string_base += len(strings)
    header = struct.pack("<4s9IHH7I", b"WDC3", total, fields, record_size, string_base, 0, 0, 0, 0, 0,
                         0, 0, fields, 0, 0, len(storage_blob), len(common), len(pallet), len(sections))
    return header + b"".join(sec_headers) + field_struct + storage_blob + pallet + common + b"".join(blobs)


class Db2Test(unittest.TestCase):
    def test_wdb2(self):
        data = build_wdb2([(159, "Refreshing Spring Water", 1, 1, 25), (2901, "Mining Pick", 1, 1, 81),
                           (4540, "Tough Hunk of Bread", 1, 5, 125)])
        items = {i.id: i for i in db2.read_wdb2_itemsparse(data)}
        self.assertEqual(items[2901].name, "Mining Pick")
        self.assertEqual(items[4540].buy_count, 5)
        self.assertEqual(items[159].buy_price, 25)

    def test_wdc3(self):
        data = build_wdc3([
            [(159, "Refreshing Spring Water", 1, 1, 25), (19019, "Thunderfury", 5, 1, 0)],
            [(2589, "Linen Cloth", 0, 1, 55), (4540, "Tough Hunk of Bread", 1, 5, 125)],
        ])
        items = {i.id: i for i in db2.read_wdc3_itemsparse(data)}
        self.assertEqual(items[19019].name, "Thunderfury")
        self.assertEqual(items[19019].quality, 5)
        self.assertEqual(items[2589].name, "Linen Cloth")
        self.assertEqual(items[2589].quality, 0)
        self.assertEqual(items[4540].buy_count, 5)
        self.assertEqual(items[4540].buy_price, 125)
        self.assertEqual(items[90001].name, "Linen Cloth")   # copy table row


if __name__ == "__main__":
    unittest.main()
