"""Per-version world database layouts and the SQL export.

Column names come from each core's own loader queries and base schema:
  wotlk     TrinityCore 3.3.5 (branch 3.3.5)        world DB `world`
  pandaria  alexkulya/pandaria_5.4.8                world DB `world`
  bfa       HavenWoW/BFA-HavenCore 8.3.7            world DB `bfa_world`
Every INSERT names its columns, so columns the designer doesn't set keep the table default.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Optional

from .model import Npc, format_money

NPCFLAG_GOSSIP = 0x1
NPCFLAG_VENDOR = 0x80
NPCFLAG_REPAIR = 0x1000
VENDOR_KINDS = {
    "general": ("General goods", 0),
    "food": ("Food & drink", 0x200),
    "poison": ("Poisons", 0x400),
    "reagent": ("Reagents", 0x800),
}
UNIT_CLASS_WARRIOR = 1
CREATURE_TYPE_HUMANOID = 7


@dataclass(frozen=True)
class Target:
    key: str
    label: str
    core: str
    database: str
    max_level: int
    max_vendor_items: int
    model_columns: int          # modelid1..N in creature_template; 0 = creature_template_model table
    equip_columns: tuple        # (entry column, id column, item column pattern)
    spawn_columns: tuple        # extra creature columns -> fixed value
    wander_column: str
    movement_column: str
    vendor_type_column: bool
    price_column: bool          # npc_vendor.OverrideGoldCost exists natively


TARGETS = {
    "wotlk": Target(
        key="wotlk", label="Wrath of the Lich King 3.3.5a", core="TrinityCore 3.3.5",
        database="world", max_level=83, max_vendor_items=150, model_columns=4,
        equip_columns=("CreatureID", "ID", "ItemID{}"),
        spawn_columns=(("spawnMask", 1), ("phaseMask", 1)),
        wander_column="wander_distance", movement_column="MovementType",
        vendor_type_column=False, price_column=False),
    "pandaria": Target(
        key="pandaria", label="Mists of Pandaria 5.4.8", core="pandaria_5.4.8",
        database="world", max_level=93, max_vendor_items=150, model_columns=4,
        equip_columns=("entry", "id", "itemEntry{}"),
        spawn_columns=(("spawnMask", 1), ("phaseMask", 1)),
        wander_column="wander_distance", movement_column="movement_type",
        vendor_type_column=True, price_column=False),
    "bfa": Target(
        key="bfa", label="Battle for Azeroth 8.3.7", core="BFA-HavenCore",
        database="bfa_world", max_level=123, max_vendor_items=150, model_columns=0,
        equip_columns=("CreatureID", "ID", "ItemID{}"),
        spawn_columns=(("spawnDifficulties", "0"), ("PhaseId", 0)),
        wander_column="spawndist", movement_column="MovementType",
        vendor_type_column=True, price_column=True),
}


def sql_value(v) -> str:
    if v is None:
        return "NULL"
    if isinstance(v, bool):
        return "1" if v else "0"
    if isinstance(v, int):
        return str(v)
    if isinstance(v, float):
        return repr(round(v, 6))
    s = str(v).replace("\\", "\\\\").replace("'", "\\'").replace("\n", "\\n").replace("\r", "")
    return f"'{s}'"


def _insert(table: str, columns: list, rows: list) -> str:
    cols = ", ".join(f"`{c}`" for c in columns)
    values = ",\n".join("(" + ", ".join(sql_value(v) for v in row) + ")" for row in rows)
    return f"INSERT INTO `{table}` ({cols}) VALUES\n{values};"


def npcflag(npc: Npc) -> int:
    flags = NPCFLAG_VENDOR | VENDOR_KINDS.get(npc.vendor_kind, ("", 0))[1]
    if npc.repair:
        flags |= NPCFLAG_REPAIR
    if npc.gossip:
        flags |= NPCFLAG_GOSSIP
    return flags


def uses_vendor_prices(npc: Npc) -> bool:
    """True when this target writes each item's price into npc_vendor."""
    t = TARGETS[npc.target]
    return t.price_column or (npc.target == "pandaria" and npc.pandaria_price_patch)


def validate(npc: Npc) -> list:
    """Problems that would make the export fail or the NPC misbehave. Empty = fine."""
    t = TARGETS[npc.target]
    problems = []
    if not 1 <= npc.entry <= 16777215:
        problems.append("Entry must be between 1 and 16777215.")
    if not npc.name.strip():
        problems.append("The NPC needs a name.")
    if not [d for d in npc.display_ids if d > 0]:
        problems.append("Set at least one display ID (model), or the NPC is invisible.")
    if t.model_columns and len([d for d in npc.display_ids if d > 0]) > t.model_columns:
        problems.append(f"{t.label} supports at most {t.model_columns} display IDs.")
    if not 1 <= npc.minlevel <= npc.maxlevel <= t.max_level:
        problems.append(f"Levels must satisfy 1 <= min <= max <= {t.max_level}.")
    if len(npc.items) > t.max_vendor_items:
        problems.append(f"{t.label} shows at most {t.max_vendor_items} vendor items.")
    seen = set()
    for i in npc.items:
        if i.item <= 0:
            problems.append("Every vendor row needs an item ID.")
        key = (i.item, i.extended_cost)
        if key in seen:
            problems.append(f"Item {i.item} is listed twice with the same cost; the core drops the duplicate.")
        seen.add(key)
        if (i.maxcount > 0) != (i.incrtime > 0):
            problems.append(f"Item {i.item}: limited stock needs both a max count and a restock time.")
        if i.price is not None and i.price < 0:
            problems.append(f"Item {i.item}: price can't be negative.")
    return problems


def export_sql(npc: Npc, item_names: Optional[dict] = None) -> str:
    t = TARGETS[npc.target]
    item_names = item_names or {}
    displays = [d for d in npc.display_ids if d > 0]
    out = []
    out.append(f"-- NPC Designer export: {npc.name} (entry {npc.entry})")
    out.append(f"-- Target: {t.label} ({t.core}), world database `{t.database}`")
    out.append(f"-- Import: mysql -u root -p {t.database} < this_file.sql   then restart worldserver")
    out.append(f"-- Spawn in game at your position: .npc add {npc.entry}")
    if npc.target == "pandaria" and npc.pandaria_price_patch:
        out.append("-- Needs tools/pandaria/vendor-price.patch (npc_vendor.OverrideGoldCost) on the server.")
    if npc.target == "wotlk" and npc.wotlk_global_prices:
        out.append("-- WARNING: prices are written to item_template.BuyPrice and apply at EVERY vendor.")
    out.append("")
    out.append(f"SET @ENTRY := {npc.entry};")
    out.append("")

    # creature_template
    cols = ["entry"]
    vals = ["@ENTRY"]
    if t.model_columns:
        for n in range(t.model_columns):
            cols.append(f"modelid{n + 1}")
            vals.append(displays[n] if n < len(displays) else 0)
    cols += ["name", "subname", "IconName", "gossip_menu_id", "minlevel", "maxlevel", "faction",
             "npcflag", "scale", "unit_class", "type"]
    vals += [npc.name, npc.subname or None, npc.icon_name or None, 0, npc.minlevel, npc.maxlevel,
             npc.faction, npcflag(npc), float(npc.scale), UNIT_CLASS_WARRIOR, CREATURE_TYPE_HUMANOID]
    out.append("DELETE FROM `creature_template` WHERE `entry` = @ENTRY;")
    out.append(_insert("creature_template", cols, [vals]).replace("'@ENTRY'", "@ENTRY"))
    out.append("")

    if not t.model_columns:
        out.append("DELETE FROM `creature_template_model` WHERE `CreatureID` = @ENTRY;")
        rows = [["@ENTRY", idx, d, 1.0, 1.0] for idx, d in enumerate(displays)]
        out.append(_insert("creature_template_model",
                           ["CreatureID", "Idx", "CreatureDisplayID", "DisplayScale", "Probability"],
                           rows).replace("'@ENTRY'", "@ENTRY"))
        out.append("")

    # creature_equip_template (what the NPC holds)
    e_entry, e_id, e_item = t.equip_columns
    out.append(f"DELETE FROM `creature_equip_template` WHERE `{e_entry}` = @ENTRY;")
    equip = (list(npc.equip) + [0, 0, 0])[:3]
    if any(equip):
        out.append(_insert("creature_equip_template",
                           [e_entry, e_id] + [e_item.format(n) for n in (1, 2, 3)],
                           [["@ENTRY", 1] + equip]).replace("'@ENTRY'", "@ENTRY"))
    out.append("")

    # npc_vendor
    out.append("DELETE FROM `npc_vendor` WHERE `entry` = @ENTRY;")
    if npc.items:
        cols = ["entry", "slot", "item", "maxcount", "incrtime", "ExtendedCost"]
        prices = uses_vendor_prices(npc)
        if t.vendor_type_column:
            cols.append("type")
        if prices:
            cols.append("OverrideGoldCost")
        rows = []
        for slot, i in enumerate(npc.items):
            row = ["@ENTRY", slot, i.item, i.maxcount, i.incrtime, i.extended_cost]
            if t.vendor_type_column:
                row.append(1)
            if prices:
                row.append(-1 if i.price is None else i.price)
            rows.append(row)
        text = _insert("npc_vendor", cols, rows).replace("'@ENTRY'", "@ENTRY")
        # one comment per row so the file reads like the vendor list
        lines = text.split("\n")
        for n, i in enumerate(npc.items):
            name = " ".join(item_names.get(i.item, "").split())
            price = "item's own price" if i.price is None or not prices else format_money(i.price)
            lines[n + 1] += f" -- {name} ({price})" if name else f" -- {price}"
        out.append("\n".join(lines))
    out.append("")

    if npc.target == "wotlk" and npc.wotlk_global_prices:
        priced = [i for i in npc.items if i.price is not None]
        if priced:
            out.append("-- Global item prices (affects every vendor that sells these items)")
            for i in priced:
                out.append(f"UPDATE `item_template` SET `BuyPrice` = {i.price} WHERE `entry` = {i.item};")
            out.append("")

    if npc.spawns:
        out.append("-- Spawns: replaces every spawn of this entry, including ones made with .npc add")
        out.append("DELETE FROM `creature` WHERE `id` = @ENTRY;")
        out.append("SET @GUID := (SELECT IFNULL(MAX(`guid`), 0) + 1 FROM `creature`);")
        extra = list(t.spawn_columns)
        cols = (["guid", "id", "map"] + [c for c, _ in extra] +
                ["position_x", "position_y", "position_z", "orientation", "spawntimesecs",
                 t.wander_column, t.movement_column])
        rows = []
        for n, s in enumerate(npc.spawns):
            rows.append([f"@GUID+{n}", "@ENTRY", s.map] + [v for _, v in extra] +
                        [float(s.x), float(s.y), float(s.z), float(s.o), 120, 0.0, 0])
        text = _insert("creature", cols, rows).replace("'@ENTRY'", "@ENTRY")
        for n in range(len(npc.spawns)):
            text = text.replace(f"'@GUID+{n}'", f"@GUID+{n}")
        out.append(text)
        out.append("")

    return "\n".join(out)
