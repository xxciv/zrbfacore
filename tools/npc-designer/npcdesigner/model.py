"""The NPC being designed, and its JSON project file."""

from __future__ import annotations

import json
import re
from dataclasses import asdict, dataclass, field
from typing import Optional

PROJECT_VERSION = 1


@dataclass
class VendorItem:
    item: int
    # Copper per purchase (one BuyCount stack). None = the item's own price.
    price: Optional[int] = None
    maxcount: int = 0      # 0 = unlimited stock
    incrtime: int = 0      # restock seconds, needed when maxcount > 0
    extended_cost: int = 0  # ItemExtendedCost id (tokens, honor, ...), 0 = gold only


@dataclass
class Spawn:
    map: int
    x: float
    y: float
    z: float
    o: float = 0.0


@dataclass
class Npc:
    target: str = "bfa"
    entry: int = 900000
    name: str = "New Vendor"
    subname: str = "General Goods"
    icon_name: str = "Buy"
    display_ids: list = field(default_factory=lambda: [0])
    minlevel: int = 60
    maxlevel: int = 60
    faction: int = 35
    scale: float = 1.0
    vendor_kind: str = "general"   # general / food / reagent / poison
    repair: bool = False
    gossip: bool = False
    equip: list = field(default_factory=lambda: [0, 0, 0])
    items: list = field(default_factory=list)
    spawns: list = field(default_factory=list)
    # WotLK has no per-vendor price column: when set, prices are written to
    # item_template.BuyPrice, which changes the item's price at every vendor.
    wotlk_global_prices: bool = False
    # Pandaria only knows npc_vendor.OverrideGoldCost with tools/pandaria/vendor-price.patch.
    pandaria_price_patch: bool = True

    def to_json(self) -> str:
        data = asdict(self)
        data["project_version"] = PROJECT_VERSION
        return json.dumps(data, indent=2)

    @classmethod
    def from_json(cls, text: str) -> "Npc":
        data = json.loads(text)
        data.pop("project_version", None)
        items = [VendorItem(**i) for i in data.pop("items", [])]
        spawns = [Spawn(**s) for s in data.pop("spawns", [])]
        known = {k: v for k, v in data.items() if k in cls.__dataclass_fields__}
        npc = cls(**known)
        npc.items = items
        npc.spawns = spawns
        return npc


def split_copper(copper: int) -> tuple:
    return copper // 10000, (copper // 100) % 100, copper % 100


def join_copper(gold: int, silver: int, copper: int) -> int:
    return gold * 10000 + silver * 100 + copper


def format_money(copper: int) -> str:
    g, s, c = split_copper(copper)
    parts = []
    if g:
        parts.append(f"{g}g")
    if s:
        parts.append(f"{s}s")
    if c or not parts:
        parts.append(f"{c}c")
    return " ".join(parts)


_MONEY = re.compile(r"^\s*(?:(\d+)\s*g)?\s*(?:(\d+)\s*s)?\s*(?:(\d+)\s*c?)?\s*$", re.I)


def parse_money(text: str) -> Optional[int]:
    """'1g 50s', '75s', '1234' (copper), '' -> None (use the item's price)."""
    text = text.strip()
    if not text or text.lower() in ("default", "-"):
        return None
    m = _MONEY.match(text)
    if not m or not any(m.groups()):
        raise ValueError(f"Can't read the price '{text}'. Use e.g. 1g 50s 25c, 75s, or plain copper.")
    g, s, c = (int(v) if v else 0 for v in m.groups())
    return join_copper(g, s, c)


_GPS_MAP = re.compile(r"Map:\s*(\d+)", re.I)
_GPS_XYZ = re.compile(
    r"X:\s*(-?[\d.]+)\s*Y:\s*(-?[\d.]+)\s*Z:\s*(-?[\d.]+)\s*Orientation:\s*(-?[\d.]+)", re.I)


def parse_gps(text: str) -> Optional[Spawn]:
    """Read a spawn point from the output of the `.gps` command (chat log or console)."""
    text = re.sub(r"\|c[0-9a-fA-F]{8}|\|H[^|]*\|h|\|h|\|r", "", text)
    m = _GPS_MAP.search(text)
    p = _GPS_XYZ.search(text)
    if not m or not p:
        return None
    return Spawn(int(m.group(1)), *(float(v) for v in p.groups()))
