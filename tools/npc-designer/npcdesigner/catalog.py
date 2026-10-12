"""Where item names and prices come from: client tables, the world database, or a CSV."""

from __future__ import annotations

import csv
from pathlib import Path
from typing import Dict, List, Optional

from .db2 import ItemInfo, find_itemsparse, load_items
from .targets import TARGETS


class Catalog:
    def __init__(self):
        self.items: Dict[int, ItemInfo] = {}
        self.source = "none"

    def __len__(self):
        return len(self.items)

    def get(self, item_id: int) -> Optional[ItemInfo]:
        return self.items.get(item_id)

    def search(self, text: str, limit: int = 200) -> List[ItemInfo]:
        text = text.strip()
        if not text:
            return []
        if text.isdigit():
            hit = self.items.get(int(text))
            return [hit] if hit else []
        needle = text.lower()
        out = [i for i in self.items.values() if needle in i.name.lower()]
        out.sort(key=lambda i: (not i.name.lower().startswith(needle), len(i.name), i.id))
        return out[:limit]

    # --- sources

    def load_db2(self, folder: str) -> str:
        path = find_itemsparse(Path(folder))
        if not path:
            raise FileNotFoundError(f"No ItemSparse.db2 / Item-sparse.db2 under {folder}")
        self.items = load_items(path)
        self.source = str(path)
        return self.source

    def load_csv(self, path: str) -> str:
        """CSV with a header row: ID, Name, and optionally Quality, BuyPrice, BuyCount."""
        items = {}
        with open(path, newline="", encoding="utf-8") as fh:
            for row in csv.DictReader(fh):
                low = {k.strip().lower(): v for k, v in row.items() if k}
                ident = low.get("id") or low.get("entry")
                name = low.get("name") or low.get("display_lang") or low.get("display") or ""
                if not ident or not ident.strip().isdigit():
                    continue
                items[int(ident)] = ItemInfo(
                    int(ident), name,
                    _int(low.get("quality") or low.get("overallqualityid"), 1),
                    _int(low.get("buyprice"), 0),
                    max(_int(low.get("buycount") or low.get("vendorstackcount"), 1), 1))
        self.items = items
        self.source = path
        return path

    def load_mysql(self, conn: "WorldDb", target: str) -> str:
        if target != "wotlk":
            raise ValueError("Only the WotLK world DB has item names (item_template). "
                             "For Pandaria and BFA load the server's dbc folder.")
        self.items = conn.wotlk_items()
        self.source = f"{conn.database} on {conn.host}"
        return self.source


def _int(v, default):
    try:
        return int(str(v).strip())
    except (TypeError, ValueError):
        return default


class WorldDb:
    """Optional connection to the world database (needs PyMySQL)."""

    def __init__(self, host: str, port: int, user: str, password: str, database: str):
        import pymysql  # imported here so the designer runs without it
        self.host, self.database = host, database
        self.conn = pymysql.connect(host=host, port=port, user=user, password=password,
                                    database=database, charset="utf8mb4", connect_timeout=5)

    def query(self, sql: str, args=()):
        with self.conn.cursor() as cur:
            cur.execute(sql, args)
            return cur.fetchall()

    def wotlk_items(self) -> Dict[int, ItemInfo]:
        rows = self.query("SELECT entry, name, Quality, BuyPrice, BuyCount FROM item_template")
        return {r[0]: ItemInfo(r[0], r[1], r[2], r[3], max(r[4], 1)) for r in rows}

    def next_free_entry(self, start: int = 900000) -> int:
        row = self.query("SELECT MAX(entry) FROM creature_template WHERE entry >= %s", (start,))
        return max(start, (row[0][0] or start - 1) + 1)

    def entry_name(self, entry: int) -> Optional[str]:
        rows = self.query("SELECT name FROM creature_template WHERE entry = %s", (entry,))
        return rows[0][0] if rows else None

    def display_ids(self, target: str, entry: int) -> List[int]:
        """The models an existing creature uses, to copy its look."""
        if TARGETS[target].model_columns:
            rows = self.query("SELECT modelid1, modelid2, modelid3, modelid4 FROM creature_template "
                              "WHERE entry = %s", (entry,))
            return [d for d in (rows[0] if rows else ()) if d]
        rows = self.query("SELECT CreatureDisplayID FROM creature_template_model WHERE CreatureID = %s "
                          "ORDER BY Idx", (entry,))
        return [r[0] for r in rows]

    def close(self):
        self.conn.close()
