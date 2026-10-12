"""Main window: NPC details, vendor list, merchant window preview, SQL export."""

from __future__ import annotations

import re
import shlex
import sys
from pathlib import Path

from PySide6.QtCore import QSettings, Qt, QTimer
from PySide6.QtGui import QAction, QColor, QFont, QKeySequence
from PySide6.QtWidgets import (QAbstractItemView, QApplication, QCheckBox, QComboBox, QDialog,
                               QDialogButtonBox, QDoubleSpinBox, QFileDialog, QFormLayout, QGroupBox,
                               QHBoxLayout, QHeaderView, QInputDialog, QLabel, QLineEdit, QListWidget,
                               QListWidgetItem, QMainWindow, QMessageBox, QPlainTextEdit, QPushButton,
                               QSpinBox, QSplitter, QTableWidget, QTableWidgetItem, QTabWidget,
                               QVBoxLayout, QWidget)

from .catalog import Catalog, WorldDb
from .model import Npc, Spawn, VendorItem, format_money, parse_gps, parse_money
from .targets import TARGETS, VENDOR_KINDS, export_sql, uses_vendor_prices, validate
from .vendorview import QUALITY_COLORS, VendorView

FACTIONS = [
    (35, "Friendly to everyone"),
    (12, "Stormwind (Alliance)"),
    (55, "Ironforge (Alliance)"),
    (29, "Orgrimmar (Horde)"),
    (104, "Thunder Bluff (Horde)"),
    (120, "Booty Bay (neutral goblins)"),
    (14, "Hostile monster"),
]
CURSORS = ["Buy", "Repair", "Speak", ""]
COLS = ["Item ID", "Name", "Item price", "Vendor price", "Stock", "Restock (s)", "Ext. cost"]
C_ID, C_NAME, C_DEFAULT, C_PRICE, C_STOCK, C_RESTOCK, C_EXT = range(len(COLS))

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.settings = QSettings("zrbfacore", "npc-designer")
        self.catalog = Catalog()
        self.db = None
        self.path = None
        self.dirty = False
        self._loading = False
        self.npc = Npc()

        self._build_ui()
        self._build_menu()
        self._load_npc(self.npc)
        self.resize(1400, 820)

    # ------------------------------------------------------------------ UI

    def _build_ui(self):
        split = QSplitter()
        split.addWidget(self._details_panel())
        split.addWidget(self._vendor_panel())
        preview = QWidget()
        pl = QVBoxLayout(preview)
        pl.addWidget(QLabel("<b>Merchant window preview</b>"))
        self.view = VendorView()
        self.view.slotClicked.connect(self._select_row)
        pl.addWidget(self.view, 0, Qt.AlignHCenter)
        self.problems = QLabel()
        self.problems.setWordWrap(True)
        pl.addWidget(self.problems)
        pl.addStretch(1)
        split.addWidget(preview)
        split.setSizes([380, 620, 400])
        self.setCentralWidget(split)
        self.status = self.statusBar()
        self.catalog_label = QLabel("Item data: none loaded")
        self.status.addPermanentWidget(self.catalog_label)

    def _details_panel(self):
        tabs = QTabWidget()
        w = QWidget()
        form = QFormLayout(w)

        self.target = QComboBox()
        for key, t in TARGETS.items():
            self.target.addItem(f"{t.label}  ({t.core})", key)
        self.target.currentIndexChanged.connect(self._target_changed)
        form.addRow("Target version", self.target)

        row = QHBoxLayout()
        self.entry = QSpinBox()
        self.entry.setRange(1, 16777215)
        row.addWidget(self.entry, 1)
        b = QPushButton("Next free")
        b.setToolTip("Ask the world database for the first unused entry from 900000 (needs a DB connection)")
        b.clicked.connect(self._next_free_entry)
        row.addWidget(b)
        form.addRow("Entry", row)

        self.name = QLineEdit()
        form.addRow("Name", self.name)
        self.subname = QLineEdit()
        self.subname.setPlaceholderText("shown as <Title> under the name")
        form.addRow("Title", self.subname)
        self.cursor = QComboBox()
        self.cursor.setEditable(True)
        self.cursor.addItems(CURSORS)
        form.addRow("Mouse cursor", self.cursor)

        row = QHBoxLayout()
        self.displays = QLineEdit()
        self.displays.setPlaceholderText("e.g. 3167, 3168")
        self.displays.setToolTip("Creature display IDs, comma separated. One is picked at random per spawn.\n"
                                 "Preview one in game with: .morph <id>   (undo with .demorph)")
        row.addWidget(self.displays, 1)
        b = QPushButton("Copy from NPC…")
        b.setToolTip("Use the models of an existing creature entry (needs a DB connection)")
        b.clicked.connect(self._copy_look)
        row.addWidget(b)
        form.addRow("Display IDs", row)
        self.morph_hint = QLabel()
        self.morph_hint.setStyleSheet("color: gray")
        form.addRow("", self.morph_hint)

        row = QHBoxLayout()
        self.minlevel = QSpinBox()
        self.maxlevel = QSpinBox()
        for s in (self.minlevel, self.maxlevel):
            s.setRange(1, 255)
            row.addWidget(s)
        form.addRow("Level min / max", row)

        self.faction = QComboBox()
        self.faction.setEditable(True)
        for fid, label in FACTIONS:
            self.faction.addItem(f"{fid} - {label}", fid)
        self.faction.setToolTip("FactionTemplate ID. Pick one or type a number.")
        form.addRow("Faction", self.faction)

        self.scale = QDoubleSpinBox()
        self.scale.setRange(0.1, 10)
        self.scale.setSingleStep(0.1)
        form.addRow("Scale", self.scale)

        self.kind = QComboBox()
        for key, (label, _flag) in VENDOR_KINDS.items():
            self.kind.addItem(label, key)
        self.kind.setToolTip("Food, poison and reagent vendors show up under minimap tracking")
        form.addRow("Vendor type", self.kind)
        self.repair = QCheckBox("Can repair")
        form.addRow("", self.repair)
        self.gossip = QCheckBox("Talk first (gossip menu) instead of opening the shop directly")
        form.addRow("", self.gossip)

        row = QHBoxLayout()
        self.equip = []
        for label in ("Main hand", "Off hand", "Ranged"):
            s = QSpinBox()
            s.setRange(0, 9999999)
            s.setToolTip(f"{label}: item ID the NPC holds (0 = nothing)")
            row.addWidget(s)
            self.equip.append(s)
        form.addRow("Holds items", row)

        self.price_box = QGroupBox("Prices")
        pv = QVBoxLayout(self.price_box)
        self.wotlk_global = QCheckBox("Write prices to item_template (changes the item at EVERY vendor)")
        self.pandaria_patch = QCheckBox("Server has tools/pandaria/vendor-price.patch")
        self.price_note = QLabel()
        self.price_note.setWordWrap(True)
        self.price_note.setStyleSheet("color: gray")
        pv.addWidget(self.wotlk_global)
        pv.addWidget(self.pandaria_patch)
        pv.addWidget(self.price_note)
        form.addRow(self.price_box)
        tabs.addTab(w, "NPC")
        tabs.addTab(self._spawn_panel(), "Spawns")

        for wdg in (self.name, self.subname, self.displays):
            wdg.textChanged.connect(self._changed)
        self.cursor.currentTextChanged.connect(self._changed)
        self.faction.currentTextChanged.connect(self._changed)
        for wdg in [self.entry, self.minlevel, self.maxlevel] + self.equip:
            wdg.valueChanged.connect(self._changed)
        self.scale.valueChanged.connect(self._changed)
        self.kind.currentIndexChanged.connect(self._changed)
        for wdg in (self.repair, self.gossip, self.wotlk_global, self.pandaria_patch):
            wdg.toggled.connect(self._changed)
        return tabs

    def _spawn_panel(self):
        w = QWidget()
        v = QVBoxLayout(w)
        info = QLabel("Easiest: import the SQL, restart worldserver, stand where the NPC should be and type "
                      "<code>.npc add &lt;entry&gt;</code>.<br><br>Or list spawn points here and the export "
                      "places them. Listing any spawn makes the export <b>replace every spawn of this entry</b>, "
                      "including ones made with .npc add.")
        info.setWordWrap(True)
        v.addWidget(info)
        self.spawns = QTableWidget(0, 5)
        self.spawns.setHorizontalHeaderLabels(["Map", "X", "Y", "Z", "Orientation"])
        self.spawns.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
        self.spawns.itemChanged.connect(self._changed)
        v.addWidget(self.spawns)
        row = QHBoxLayout()
        b = QPushButton("Paste .gps output…")
        b.clicked.connect(self._paste_gps)
        row.addWidget(b)
        b = QPushButton("Add empty")
        b.clicked.connect(lambda: self._add_spawn(Spawn(0, 0, 0, 0, 0)))
        row.addWidget(b)
        b = QPushButton("Remove")
        b.clicked.connect(lambda: (self.spawns.removeRow(self.spawns.currentRow()), self._changed()))
        row.addWidget(b)
        v.addLayout(row)
        return w

    def _vendor_panel(self):
        w = QWidget()
        v = QVBoxLayout(w)
        v.addWidget(QLabel("<b>Items for sale</b> (in shop order)"))
        self.table = QTableWidget(0, len(COLS))
        self.table.setHorizontalHeaderLabels(COLS)
        hh = self.table.horizontalHeader()
        hh.setSectionResizeMode(QHeaderView.ResizeToContents)
        hh.setSectionResizeMode(C_NAME, QHeaderView.Stretch)
        self.table.setSelectionBehavior(QAbstractItemView.SelectRows)
        self.table.setSelectionMode(QAbstractItemView.SingleSelection)
        self.table.itemChanged.connect(self._cell_changed)
        self.table.currentCellChanged.connect(lambda r, *_: self.view.select(r))
        self.table.horizontalHeaderItem(C_PRICE).setToolTip(
            "Blank = the item's own price. Otherwise e.g. 1g 50s, 75s, 20c or plain copper.\n"
            "The price is per purchase (one stack of the item's buy count).")
        self.table.horizontalHeaderItem(C_STOCK).setToolTip("Limited stock: how many the vendor has (0 = unlimited)")
        self.table.horizontalHeaderItem(C_RESTOCK).setToolTip("Seconds until one more comes back in stock")
        self.table.horizontalHeaderItem(C_EXT).setToolTip("ItemExtendedCost ID for token/currency costs (0 = gold only)")
        v.addWidget(self.table, 3)

        row = QHBoxLayout()
        for label, fn in (("Add by ID…", self._add_by_id), ("Remove", self._remove_row),
                          ("Move up", lambda: self._move(-1)), ("Move down", lambda: self._move(1))):
            b = QPushButton(label)
            b.clicked.connect(fn)
            row.addWidget(b)
        v.addLayout(row)

        box = QGroupBox("Find items (double-click to add)")
        bv = QVBoxLayout(box)
        self.search = QLineEdit()
        self.search.setPlaceholderText("Name or item ID. Load item data from the Items menu first.")
        self._search_timer = QTimer(singleShot=True, interval=250)
        self._search_timer.timeout.connect(self._run_search)
        self.search.textChanged.connect(lambda: self._search_timer.start())
        bv.addWidget(self.search)
        self.results = QListWidget()
        self.results.itemDoubleClicked.connect(lambda it: self._add_item(it.data(Qt.UserRole)))
        bv.addWidget(self.results)
        v.addWidget(box, 2)
        return w

    def _build_menu(self):
        m = self.menuBar().addMenu("&File")
        for label, key, fn in (("&New", QKeySequence.New, self._new), ("&Open…", QKeySequence.Open, self._open),
                               ("&Save", QKeySequence.Save, self._save),
                               ("Save &as…", QKeySequence.SaveAs, lambda: self._save(True)),
                               ("&Export SQL…", "Ctrl+E", self._export), ("&Quit", QKeySequence.Quit, self.close)):
            a = QAction(label, self)
            a.setShortcut(key)
            a.triggered.connect(fn)
            m.addAction(a)
        m = self.menuBar().addMenu("&Items")
        for label, fn in (("Load from server dbc folder (Pandaria, BFA)…", self._load_dbc),
                          ("Load from world database (WotLK)…", self._load_mysql),
                          ("Load from CSV…", self._load_csv)):
            a = QAction(label, self)
            a.triggered.connect(fn)
            m.addAction(a)
        m = self.menuBar().addMenu("&Database")
        a = QAction("Connect to world database…", self)
        a.triggered.connect(self._connect_db)
        m.addAction(a)

    # ------------------------------------------------------------------ npc <-> form

    def _load_npc(self, npc: Npc):
        self._loading = True
        self.npc = npc
        self.target.setCurrentIndex(max(self.target.findData(npc.target), 0))
        self.entry.setValue(npc.entry)
        self.name.setText(npc.name)
        self.subname.setText(npc.subname)
        self.cursor.setCurrentText(npc.icon_name)
        self.displays.setText(", ".join(str(d) for d in npc.display_ids if d))
        self.minlevel.setValue(npc.minlevel)
        self.maxlevel.setValue(npc.maxlevel)
        idx = self.faction.findData(npc.faction)
        if idx >= 0:
            self.faction.setCurrentIndex(idx)
        else:
            self.faction.setEditText(str(npc.faction))
        self.scale.setValue(npc.scale)
        self.kind.setCurrentIndex(max(self.kind.findData(npc.vendor_kind), 0))
        self.repair.setChecked(npc.repair)
        self.gossip.setChecked(npc.gossip)
        for s, v in zip(self.equip, (list(npc.equip) + [0, 0, 0])[:3]):
            s.setValue(v)
        self.wotlk_global.setChecked(npc.wotlk_global_prices)
        self.pandaria_patch.setChecked(npc.pandaria_price_patch)
        self.table.setRowCount(0)
        for item in npc.items:
            self._append_row(item)
        self.spawns.setRowCount(0)
        for s in npc.spawns:
            self._add_spawn(s, mark=False)
        self._loading = False
        self.dirty = False
        self._target_changed()
        self._refresh()

    def _read_form(self) -> Npc:
        npc = Npc()
        npc.target = self.target.currentData()
        npc.entry = self.entry.value()
        npc.name = self.name.text().strip()
        npc.subname = self.subname.text().strip()
        npc.icon_name = self.cursor.currentText().strip()
        npc.display_ids = [int(x) for x in re.findall(r"\d+", self.displays.text())]
        npc.minlevel, npc.maxlevel = self.minlevel.value(), self.maxlevel.value()
        m = re.match(r"\s*(\d+)", self.faction.currentText())
        npc.faction = int(m.group(1)) if m else 35
        npc.scale = self.scale.value()
        npc.vendor_kind = self.kind.currentData()
        npc.repair = self.repair.isChecked()
        npc.gossip = self.gossip.isChecked()
        npc.equip = [s.value() for s in self.equip]
        npc.wotlk_global_prices = self.wotlk_global.isChecked()
        npc.pandaria_price_patch = self.pandaria_patch.isChecked()
        npc.items = []
        for r in range(self.table.rowCount()):
            npc.items.append(VendorItem(
                item=_cell_int(self.table, r, C_ID),
                price=self.table.item(r, C_PRICE).data(Qt.UserRole),
                maxcount=_cell_int(self.table, r, C_STOCK),
                incrtime=_cell_int(self.table, r, C_RESTOCK),
                extended_cost=_cell_int(self.table, r, C_EXT)))
        npc.spawns = []
        for r in range(self.spawns.rowCount()):
            try:
                vals = [float(self.spawns.item(r, c).text()) for c in range(5)]
            except (AttributeError, ValueError):
                continue
            npc.spawns.append(Spawn(int(vals[0]), *vals[1:]))
        return npc

    # ------------------------------------------------------------------ vendor table

    def _append_row(self, vi: VendorItem):
        self._loading, was = True, self._loading
        r = self.table.rowCount()
        self.table.insertRow(r)
        for c in range(len(COLS)):
            self.table.setItem(r, c, QTableWidgetItem())
        for c in (C_NAME, C_DEFAULT):
            self.table.item(r, c).setFlags(Qt.ItemIsSelectable | Qt.ItemIsEnabled)
        self.table.item(r, C_ID).setText(str(vi.item))
        self._set_price(r, vi.price)
        self.table.item(r, C_STOCK).setText(str(vi.maxcount))
        self.table.item(r, C_RESTOCK).setText(str(vi.incrtime))
        self.table.item(r, C_EXT).setText(str(vi.extended_cost))
        self._fill_item_info(r)
        self._loading = was

    def _set_price(self, r, price):
        cell = self.table.item(r, C_PRICE)
        cell.setData(Qt.UserRole, price)
        cell.setText("" if price is None else format_money(price))

    def _fill_item_info(self, r):
        item_id = _cell_int(self.table, r, C_ID)
        info = self.catalog.get(item_id)
        name = self.table.item(r, C_NAME)
        default = self.table.item(r, C_DEFAULT)
        if info:
            name.setText(info.name)
            name.setForeground(QColor(QUALITY_COLORS[info.quality] if info.quality < len(QUALITY_COLORS) else "#fff"))
            name.setBackground(QColor("#1d1d1d"))
            stack = f" per {info.buy_count}" if info.buy_count > 1 else ""
            default.setText(format_money(info.buy_price) + stack)
        else:
            name.setText("" if not len(self.catalog) else "(not in item data)")
            default.setText("")

    def _cell_changed(self, cell):
        if self._loading:
            return
        r, c = cell.row(), cell.column()
        if c == C_PRICE:
            try:
                price = parse_money(cell.text())
            except ValueError as e:
                self.status.showMessage(str(e), 6000)
                price = cell.data(Qt.UserRole)
            self._loading = True
            self._set_price(r, price)
            self._loading = False
        elif c == C_ID:
            self._loading = True
            self._fill_item_info(r)
            self._loading = False
        self._changed()

    def _add_item(self, item_id: int):
        if item_id:
            self._append_row(VendorItem(item=item_id))
            self.table.setCurrentCell(self.table.rowCount() - 1, C_PRICE)
            self._changed()

    def _add_by_id(self):
        item_id, ok = QInputDialog.getInt(self, "Add item", "Item ID", 0, 1, 99999999)
        if ok:
            self._add_item(item_id)

    def _remove_row(self):
        r = self.table.currentRow()
        if r >= 0:
            self.table.removeRow(r)
            self._changed()

    def _move(self, d):
        r = self.table.currentRow()
        t = r + d
        if r < 0 or not 0 <= t < self.table.rowCount():
            return
        npc = self._read_form()
        npc.items[r], npc.items[t] = npc.items[t], npc.items[r]
        self._loading = True
        self.table.setRowCount(0)
        for item in npc.items:
            self._append_row(item)
        self._loading = False
        self.table.setCurrentCell(t, C_ID)
        self._changed()

    def _select_row(self, idx):
        self.table.setCurrentCell(idx, C_PRICE)

    def _run_search(self):
        self.results.clear()
        for info in self.catalog.search(self.search.text()):
            it = QListWidgetItem(f"{info.id}  {info.name}   ({format_money(info.buy_price)})")
            it.setData(Qt.UserRole, info.id)
            it.setForeground(QColor(QUALITY_COLORS[info.quality] if info.quality < len(QUALITY_COLORS) else "#fff"))
            it.setBackground(QColor("#1d1d1d"))
            self.results.addItem(it)
        if not len(self.catalog) and self.search.text().strip().isdigit():
            it = QListWidgetItem(f"{self.search.text().strip()}  (no item data loaded, add by ID)")
            it.setData(Qt.UserRole, int(self.search.text().strip()))
            self.results.addItem(it)

    # ------------------------------------------------------------------ spawns

    def _add_spawn(self, s: Spawn, mark=True):
        r = self.spawns.rowCount()
        self.spawns.insertRow(r)
        for c, v in enumerate((s.map, s.x, s.y, s.z, s.o)):
            self.spawns.setItem(r, c, QTableWidgetItem(str(v)))
        if mark:
            self._changed()

    def _paste_gps(self):
        dlg = QDialog(self)
        dlg.setWindowTitle("Paste .gps output")
        v = QVBoxLayout(dlg)
        v.addWidget(QLabel("Paste what .gps printed (from the worldserver console, or Logs/WoWChatLog.txt "
                           "after /chatlog). Map, X, Y, Z and Orientation are read from it."))
        text = QPlainTextEdit()
        v.addWidget(text)
        bb = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)
        bb.accepted.connect(dlg.accept)
        bb.rejected.connect(dlg.reject)
        v.addWidget(bb)
        if dlg.exec() == QDialog.Accepted:
            s = parse_gps(text.toPlainText())
            if s:
                self._add_spawn(s)
            else:
                QMessageBox.warning(self, "No position found", "Couldn't find 'Map:' and 'X: … Orientation: …'.")

    # ------------------------------------------------------------------ refresh

    def _target_changed(self):
        key = self.target.currentData()
        t = TARGETS[key]
        self.wotlk_global.setVisible(key == "wotlk")
        self.pandaria_patch.setVisible(key == "pandaria")
        notes = {
            "wotlk": "TrinityCore 3.3.5 has no per-vendor price. Leave this off to sell at each item's own "
                     "price, or turn it on to change the item's price everywhere.",
            "pandaria": "With the patch, each vendor can set its own price (npc_vendor.OverrideGoldCost). "
                        "Without it, items sell at their own price and the Vendor price column is ignored.",
            "bfa": "HavenCore supports per-vendor prices natively (npc_vendor.OverrideGoldCost).",
        }
        self.price_note.setText(notes[key])
        self.minlevel.setMaximum(t.max_level)
        self.maxlevel.setMaximum(t.max_level)
        self._changed()

    def _changed(self, *_):
        if self._loading:
            return
        self.dirty = True
        self._refresh()

    def _refresh(self):
        npc = self._read_form()
        self.npc = npc
        priced = uses_vendor_prices(npc) or (npc.target == "wotlk" and npc.wotlk_global_prices)
        self.table.horizontalHeaderItem(C_PRICE).setText("Vendor price" if priced else "Vendor price (ignored)")
        rows = []
        for vi in npc.items:
            info = self.catalog.get(vi.item)
            price = vi.price if (priced and vi.price is not None) else (info.buy_price if info else None)
            rows.append({"item": vi.item, "name": info.name if info else "", "quality": info.quality if info else 1,
                         "price": price, "stock": vi.maxcount, "ext_cost": vi.extended_cost})
        t = TARGETS[npc.target]
        self.view.set_data(npc.name, npc.subname, t.label, npc.repair, rows)
        ids = [d for d in npc.display_ids if d]
        self.morph_hint.setText(f"Preview in game: .morph {ids[0]}" if ids else "")
        problems = validate(npc)
        self.problems.setText("<span style='color:#c0392b'>" + "<br>".join(problems) + "</span>" if problems
                              else "<span style='color:#27ae60'>Ready to export.</span>")
        title = Path(self.path).name if self.path else "untitled"
        self.setWindowTitle(f"NPC Designer - {title}{' *' if self.dirty else ''}")

    # ------------------------------------------------------------------ files

    def _confirm_discard(self):
        if not self.dirty:
            return True
        return QMessageBox.question(self, "Unsaved changes", "Discard unsaved changes?") == QMessageBox.Yes

    def _new(self):
        if self._confirm_discard():
            self.path = None
            self._load_npc(Npc(target=self.target.currentData()))

    def _open(self):
        if not self._confirm_discard():
            return
        path, _ = QFileDialog.getOpenFileName(self, "Open NPC", self._dir(), "NPC designs (*.npc.json *.json)")
        if path:
            try:
                npc = Npc.from_json(Path(path).read_text())
            except (ValueError, TypeError, KeyError) as e:
                QMessageBox.critical(self, "Can't open", str(e))
                return
            self.path = path
            self._load_npc(npc)

    def _save(self, ask=False):
        path = self.path
        if ask or not path:
            default = str(Path(self._dir()) / f"{_slug(self.npc.name)}.npc.json")
            path, _ = QFileDialog.getSaveFileName(self, "Save NPC", default, "NPC designs (*.npc.json)")
            if not path:
                return False
        Path(path).write_text(self._read_form().to_json())
        self.path = path
        self.settings.setValue("dir", str(Path(path).parent))
        self.dirty = False
        self._refresh()
        self.status.showMessage(f"Saved {path}", 4000)
        return True

    def _export(self):
        npc = self._read_form()
        problems = validate(npc)
        if problems and QMessageBox.warning(
                self, "Problems found", "\n".join(problems) + "\n\nExport anyway?",
                QMessageBox.Yes | QMessageBox.No) != QMessageBox.Yes:
            return
        t = TARGETS[npc.target]
        default = str(Path(self._dir()) / f"{npc.entry}_{_slug(npc.name)}_{npc.target}.sql")
        path, _ = QFileDialog.getSaveFileName(self, "Export SQL", default, "SQL (*.sql)")
        if not path:
            return
        names = {i.item: (self.catalog.get(i.item).name if self.catalog.get(i.item) else "") for i in npc.items}
        Path(path).write_text(export_sql(npc, names))
        self.settings.setValue("dir", str(Path(path).parent))
        self._show_import_commands(path, t.database, npc.entry)

    def _show_import_commands(self, path, database, entry):
        """After an export: the commands to get it into the game, each with a Copy button."""
        dlg = QDialog(self)
        dlg.setWindowTitle("Exported")
        dlg.setMinimumWidth(620)
        v = QVBoxLayout(dlg)
        wrote = QLabel(f"Wrote {path}")
        wrote.setTextInteractionFlags(Qt.TextSelectableByMouse)
        v.addWidget(wrote)

        row = QHBoxLayout()
        row.addWidget(QLabel("Server login:"))
        target = QLineEdit(self.settings.value("ssh/target", "you@192.168.x.x"))
        target.setToolTip("user@address of the server, used in the scp line below (remembered)")
        row.addWidget(target, 1)
        v.addLayout(row)

        name = Path(path).name
        steps = [
            ("1. Copy the file to the server (on this PC):", lambda: f"scp {shlex.quote(path)} {target.text()}:"),
            ("2. Import it (on the server):", lambda: f"mysql -u root -p {database} < ~/{shlex.quote(name)}"),
            ("3. Restart worldserver, then in game where the NPC should stand:", lambda: f".npc add {entry}"),
        ]
        fields = []
        for label, make in steps:
            v.addWidget(QLabel(label))
            row = QHBoxLayout()
            field = QLineEdit(make())
            field.setReadOnly(True)
            field.setFont(QFont("Monospace"))
            row.addWidget(field, 1)
            copy = QPushButton("Copy")
            copy.clicked.connect(lambda _=False, f=field: (QApplication.clipboard().setText(f.text()),
                                                            self.status.showMessage("Copied", 2000)))
            row.addWidget(copy)
            v.addLayout(row)
            fields.append((field, make))

        def refresh():
            for field, make in fields:
                field.setText(make())
            self.settings.setValue("ssh/target", target.text())
        target.textChanged.connect(refresh)

        bb = QDialogButtonBox(QDialogButtonBox.Close)
        copy_all = bb.addButton("Copy all", QDialogButtonBox.ActionRole)
        copy_all.clicked.connect(lambda: QApplication.clipboard().setText(
            "\n".join(f.text() for f, _ in fields)))
        bb.rejected.connect(dlg.reject)
        v.addWidget(bb)
        dlg.exec()

    def _dir(self):
        return self.settings.value("dir", str(Path.home()))

    def closeEvent(self, ev):
        if self._confirm_discard():
            ev.accept()
        else:
            ev.ignore()

    # ------------------------------------------------------------------ item data / DB

    def _catalog_loaded(self):
        self.catalog_label.setText(f"Item data: {len(self.catalog)} items from {self.catalog.source}")
        self._loading = True
        for r in range(self.table.rowCount()):
            self._fill_item_info(r)
        self._loading = False
        self._run_search()
        self._refresh()

    def _load_dbc(self):
        key = f"dbc/{self.target.currentData()}"
        folder = QFileDialog.getExistingDirectory(self, "Server dbc folder (e.g. ~/bfa/server/data/dbc)",
                                                  self.settings.value(key, str(Path.home())))
        if not folder:
            return
        QApplication.setOverrideCursor(Qt.WaitCursor)
        try:
            self.catalog.load_db2(folder)
        except Exception as e:  # noqa: BLE001 - show any reader failure to the user
            QApplication.restoreOverrideCursor()
            QMessageBox.critical(self, "Can't read item data", f"{type(e).__name__}: {e}")
            return
        QApplication.restoreOverrideCursor()
        self.settings.setValue(key, folder)
        self._catalog_loaded()

    def _load_csv(self):
        path, _ = QFileDialog.getOpenFileName(self, "Item CSV (ID, Name, Quality, BuyPrice, BuyCount)",
                                              self._dir(), "CSV (*.csv)")
        if path:
            try:
                self.catalog.load_csv(path)
            except (OSError, ValueError) as e:
                QMessageBox.critical(self, "Can't read CSV", str(e))
                return
            self._catalog_loaded()

    def _load_mysql(self):
        if not self._ensure_db():
            return
        QApplication.setOverrideCursor(Qt.WaitCursor)
        try:
            self.catalog.load_mysql(self.db, self.target.currentData())
        except Exception as e:  # noqa: BLE001
            QApplication.restoreOverrideCursor()
            QMessageBox.critical(self, "Can't load items", str(e))
            return
        QApplication.restoreOverrideCursor()
        self._catalog_loaded()

    def _connect_db(self):
        dlg = QDialog(self)
        dlg.setWindowTitle("World database")
        form = QFormLayout(dlg)
        t = TARGETS[self.target.currentData()]
        host = QLineEdit(self.settings.value("db/host", "127.0.0.1"))
        port = QSpinBox()
        port.setRange(1, 65535)
        port.setValue(int(self.settings.value("db/port", 3306)))
        user = QLineEdit(self.settings.value("db/user", "root"))
        pw = QLineEdit()
        pw.setEchoMode(QLineEdit.Password)
        db = QLineEdit(self.settings.value(f"db/name/{t.key}", t.database))
        for label, wdg in (("Host", host), ("Port", port), ("User", user), ("Password", pw), ("Database", db)):
            form.addRow(label, wdg)
        bb = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)
        bb.accepted.connect(dlg.accept)
        bb.rejected.connect(dlg.reject)
        form.addRow(bb)
        if dlg.exec() != QDialog.Accepted:
            return False
        try:
            if self.db:
                self.db.close()
            self.db = WorldDb(host.text(), port.value(), user.text(), pw.text(), db.text())
        except ImportError:
            QMessageBox.critical(self, "PyMySQL missing", "Install it: sudo dnf install python3-pymysql")
            return False
        except Exception as e:  # noqa: BLE001
            self.db = None
            QMessageBox.critical(self, "Can't connect", str(e))
            return False
        for k, v in (("db/host", host.text()), ("db/port", port.value()), ("db/user", user.text()),
                     (f"db/name/{t.key}", db.text())):
            self.settings.setValue(k, v)
        self.status.showMessage(f"Connected to {db.text()} on {host.text()}", 4000)
        return True

    def _ensure_db(self):
        return bool(self.db) or self._connect_db()

    def _next_free_entry(self):
        if self._ensure_db():
            try:
                self.entry.setValue(self.db.next_free_entry())
            except Exception as e:  # noqa: BLE001
                QMessageBox.critical(self, "Query failed", str(e))

    def _copy_look(self):
        if not self._ensure_db():
            return
        entry, ok = QInputDialog.getInt(self, "Copy look", "Creature entry to copy the model from", 1, 1, 16777215)
        if not ok:
            return
        try:
            ids = self.db.display_ids(self.target.currentData(), entry)
            name = self.db.entry_name(entry)
        except Exception as e:  # noqa: BLE001
            QMessageBox.critical(self, "Query failed", str(e))
            return
        if not ids:
            QMessageBox.information(self, "Not found", f"Entry {entry} has no models in this database.")
            return
        self.displays.setText(", ".join(map(str, ids)))
        self.status.showMessage(f"Copied the look of {name} ({entry})", 5000)


def _cell_int(table, r, c):
    item = table.item(r, c)
    try:
        return int((item.text() if item else "0").strip() or 0)
    except ValueError:
        return 0


def _slug(name):
    return re.sub(r"[^a-z0-9]+", "_", name.lower()).strip("_") or "npc"


def main():
    app = QApplication(sys.argv)
    app.setApplicationName("NPC Designer")
    win = MainWindow()
    if len(sys.argv) > 1 and Path(sys.argv[1]).is_file():
        win.path = sys.argv[1]
        win._load_npc(Npc.from_json(Path(sys.argv[1]).read_text()))
    win.show()
    return app.exec()
