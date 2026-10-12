"""A drawn mock-up of the in-game merchant window (no Blizzard art is used)."""

from __future__ import annotations

from PySide6.QtCore import QPointF, QRectF, Qt, Signal
from PySide6.QtGui import QColor, QFont, QLinearGradient, QPainter, QPainterPath, QPen
from PySide6.QtWidgets import QSizePolicy, QToolTip, QWidget

from .model import split_copper

QUALITY_COLORS = ["#9d9d9d", "#ffffff", "#1eff00", "#0070dd", "#a335ee", "#ff8000", "#e6cc80",
                  "#00ccff"]
COIN_COLORS = [("#ffd100", "#8a6d00"), ("#d8d8d8", "#7a7a7a"), ("#d9884a", "#7a3f12")]
PER_PAGE = 10
W, H = 360, 500


class VendorView(QWidget):
    slotClicked = Signal(int)   # index into the vendor list

    def __init__(self, parent=None):
        super().__init__(parent)
        self.setMinimumSize(W, H)
        self.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
        self.setMouseTracking(True)
        self.title = ""
        self.subtitle = ""
        self.version = ""
        self.repair = False
        self.rows = []          # dicts: name, quality, price (copper or None), stock, ext_cost, item
        self.page = 0
        self.selected = -1
        self._slot_rects = []
        self._arrows = {}

    def sizeHint(self):
        return self.minimumSize()

    def set_data(self, title, subtitle, version, repair, rows):
        self.title, self.subtitle, self.version, self.repair = title, subtitle, version, repair
        self.rows = rows
        self.page = min(self.page, max(self.pages() - 1, 0))
        self.update()

    def select(self, index):
        self.selected = index
        if index >= 0:
            self.page = index // PER_PAGE
        self.update()

    def pages(self):
        return max(1, (len(self.rows) + PER_PAGE - 1) // PER_PAGE)

    # ------------------------------------------------------------ painting

    def paintEvent(self, _event):
        p = QPainter(self)
        p.setRenderHint(QPainter.Antialiasing)
        self._frame(p)
        self._slots(p)
        self._footer(p)
        p.end()

    def _frame(self, p):
        outer = QRectF(2, 2, W - 4, H - 4)
        p.setPen(QPen(QColor("#c9a54a"), 3))
        grad = QLinearGradient(0, 0, 0, H)
        grad.setColorAt(0, QColor("#3b2a17"))
        grad.setColorAt(1, QColor("#1f160c"))
        p.setBrush(grad)
        p.drawRoundedRect(outer, 8, 8)
        # portrait
        p.setPen(QPen(QColor("#c9a54a"), 3))
        p.setBrush(QColor("#0d0a06"))
        p.drawEllipse(QRectF(10, 8, 58, 58))
        p.setPen(QColor("#c9a54a"))
        p.setFont(QFont("Sans", 20, QFont.Bold))
        p.drawText(QRectF(10, 8, 58, 58), Qt.AlignCenter, (self.title[:1] or "?").upper())
        # title bar
        p.setPen(Qt.NoPen)
        p.setBrush(QColor(0, 0, 0, 110))
        p.drawRoundedRect(QRectF(76, 10, W - 90, 24), 4, 4)
        p.setPen(QColor("#ffd100"))
        p.setFont(QFont("Sans", 10, QFont.Bold))
        p.drawText(QRectF(80, 10, W - 98, 24), Qt.AlignCenter, self.title or "Merchant")
        p.setPen(QColor("#d8c8a8"))
        p.setFont(QFont("Sans", 8))
        sub = f"<{self.subtitle}>" if self.subtitle else ""
        p.drawText(QRectF(80, 36, W - 98, 16), Qt.AlignCenter, sub)
        p.setPen(QColor("#8c7a5a"))
        p.drawText(QRectF(80, 50, W - 98, 14), Qt.AlignCenter, self.version)

    def _slots(self, p):
        self._slot_rects = []
        start = self.page * PER_PAGE
        for n in range(PER_PAGE):
            col, row = n % 2, n // 2
            r = QRectF(12 + col * 170, 74 + row * 62, 164, 56)
            idx = start + n
            self._slot_rects.append((r, idx))
            self._slot(p, r, self.rows[idx] if idx < len(self.rows) else None, idx == self.selected)

    def _slot(self, p, r, item, selected):
        icon = QRectF(r.x() + 2, r.y() + 6, 40, 40)
        plate = QRectF(r.x() + 46, r.y() + 6, r.width() - 48, 40)
        p.setPen(QPen(QColor("#5a4630"), 1))
        p.setBrush(QColor(0, 0, 0, 90))
        p.drawRoundedRect(plate, 3, 3)
        p.setBrush(QColor("#140f09"))
        p.drawRoundedRect(icon, 3, 3)
        if not item:
            return
        q = QColor(QUALITY_COLORS[item["quality"] if 0 <= item["quality"] < len(QUALITY_COLORS) else 1])
        # icon placeholder: quality border + initials
        p.setPen(QPen(q, 2))
        bg = QLinearGradient(icon.topLeft(), icon.bottomRight())
        bg.setColorAt(0, QColor("#4a3b28"))
        bg.setColorAt(1, QColor("#1b140b"))
        p.setBrush(bg)
        p.drawRoundedRect(icon.adjusted(1, 1, -1, -1), 3, 3)
        initials = "".join(w[0] for w in item["name"].split()[:2]).upper() or "#"
        p.setPen(QColor("#e8dcc0"))
        p.setFont(QFont("Sans", 11, QFont.Bold))
        p.drawText(icon, Qt.AlignCenter, initials)
        if item["stock"]:
            p.setFont(QFont("Sans", 7, QFont.Bold))
            p.setPen(QColor("#ffffff"))
            p.drawText(icon.adjusted(0, 0, -3, -1), Qt.AlignRight | Qt.AlignBottom, f"({item['stock']})")
        if selected:
            p.setPen(QPen(QColor("#ffd100"), 2))
            p.setBrush(Qt.NoBrush)
            p.drawRoundedRect(r.adjusted(0, 4, 0, -8), 4, 4)
        # name
        p.setPen(q)
        p.setFont(QFont("Sans", 8, QFont.Bold))
        fm = p.fontMetrics()
        name = fm.elidedText(item["name"] or f"Item {item['item']}", Qt.ElideRight, int(plate.width() - 6))
        p.drawText(QRectF(plate.x() + 4, plate.y() + 2, plate.width() - 6, 18), Qt.AlignLeft | Qt.AlignVCenter,
                   name)
        # price
        y = plate.y() + 22
        x = plate.x() + 4
        if item["price"] is None:
            p.setPen(QColor("#8c7a5a"))
            p.setFont(QFont("Sans", 7))
            p.drawText(QRectF(x, y, plate.width(), 14), Qt.AlignLeft | Qt.AlignVCenter, "price unknown")
        elif item["price"] == 0 and item["ext_cost"]:
            p.setPen(QColor("#e8dcc0"))
            p.setFont(QFont("Sans", 7))
            p.drawText(QRectF(x, y, plate.width(), 14), Qt.AlignLeft | Qt.AlignVCenter,
                       f"Extended cost #{item['ext_cost']}")
        else:
            self._money(p, x, y, item["price"])
            if item["ext_cost"]:
                p.setPen(QColor("#e8dcc0"))
                p.setFont(QFont("Sans", 7))
                p.drawText(QRectF(plate.right() - 30, y, 28, 14), Qt.AlignRight | Qt.AlignVCenter, "+tok")

    def _money(self, p, x, y, copper):
        g, s, c = split_copper(copper)
        parts = [(g, 0), (s, 1), (c, 2)]
        shown = [(v, k) for v, k in parts if v] or [(0, 2)]
        p.setFont(QFont("Sans", 8, QFont.Bold))
        for v, k in shown:
            txt = str(v)
            w = p.fontMetrics().horizontalAdvance(txt)
            p.setPen(QColor("#ffffff"))
            p.drawText(QPointF(x, y + 11), txt)
            x += w + 2
            face, rim = COIN_COLORS[k]
            p.setPen(QPen(QColor(rim), 1))
            p.setBrush(QColor(face))
            p.drawEllipse(QRectF(x, y + 3, 9, 9))
            x += 14

    def _footer(self, p):
        y = 74 + 5 * 62 + 4
        p.setPen(QColor("#ffd100"))
        p.setFont(QFont("Sans", 8))
        p.drawText(QRectF(0, y, W, 18), Qt.AlignCenter, f"Page {self.page + 1} of {self.pages()}")
        self._arrows = {"prev": QRectF(40, y - 2, 26, 22), "next": QRectF(W - 66, y - 2, 26, 22)}
        for key, rect in self._arrows.items():
            enabled = (self.page > 0) if key == "prev" else (self.page < self.pages() - 1)
            p.setPen(QPen(QColor("#c9a54a" if enabled else "#5a4630"), 1))
            p.setBrush(QColor("#5a1a12" if enabled else "#2a1f14"))
            p.drawEllipse(rect)
            path = QPainterPath()
            cx, cy = rect.center().x(), rect.center().y()
            d = -1 if key == "prev" else 1
            path.moveTo(cx - 4 * d, cy - 6)
            path.lineTo(cx + 5 * d, cy)
            path.lineTo(cx - 4 * d, cy + 6)
            path.closeSubpath()
            p.setBrush(QColor("#ffd100" if enabled else "#6a5a40"))
            p.setPen(Qt.NoPen)
            p.drawPath(path)
        # repair buttons
        by = y + 26
        if self.repair:
            for n, label in enumerate(("Repair", "Repair all")):
                rr = QRectF(14 + n * 46, by, 40, 30)
                p.setPen(QPen(QColor("#c9a54a"), 1))
                p.setBrush(QColor("#2a1f14"))
                p.drawRoundedRect(rr, 3, 3)
                p.setPen(QColor("#e8dcc0"))
                p.setFont(QFont("Sans", 6))
                p.drawText(rr, Qt.AlignCenter | Qt.TextWordWrap, label)
        # tabs
        for n, label in enumerate(("Merchant", "Buyback")):
            tr = QRectF(14 + n * 92, H - 30, 86, 22)
            p.setPen(QPen(QColor("#c9a54a"), 1))
            p.setBrush(QColor("#5a1a12" if n == 0 else "#2a1f14"))
            p.drawRoundedRect(tr, 4, 4)
            p.setPen(QColor("#ffd100" if n == 0 else "#a89878"))
            p.setFont(QFont("Sans", 8, QFont.Bold))
            p.drawText(tr, Qt.AlignCenter, label)

    # ------------------------------------------------------------ input

    def mousePressEvent(self, ev):
        pos = ev.position()
        if self._arrows.get("prev") and self._arrows["prev"].contains(pos) and self.page > 0:
            self.page -= 1
            self.update()
            return
        if self._arrows.get("next") and self._arrows["next"].contains(pos) and self.page < self.pages() - 1:
            self.page += 1
            self.update()
            return
        for rect, idx in self._slot_rects:
            if rect.contains(pos) and idx < len(self.rows):
                self.selected = idx
                self.slotClicked.emit(idx)
                self.update()
                return

    def mouseMoveEvent(self, ev):
        pos = ev.position()
        for rect, idx in self._slot_rects:
            if rect.contains(pos) and idx < len(self.rows):
                r = self.rows[idx]
                QToolTip.showText(ev.globalPosition().toPoint(),
                                  f"{r['name'] or 'Unknown item'}\nItem ID {r['item']}", self)
                return
        QToolTip.hideText()
