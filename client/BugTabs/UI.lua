local AddonName, AddonNamespace = ...
local L = AddonNamespace.L
local Theme = AddonNamespace.Theme
local Components = AddonNamespace.Components

AddonNamespace.UI = {}
local UI = AddonNamespace.UI

-- Sévérité dérivée du message (Events.lua inchangé) : warning si bucket LUA_WARNING
-- ou message préfixé [WARNING / BLOCKED / FORBIDDEN, sinon erreur.
local function Severity(addonName, msg)
    msg = msg or ""
    if addonName == "LUA_WARNING" or msg:find("^%[WARNING") or msg:find("BLOCKED") or msg:find("FORBIDDEN") then
        return "warning"
    end
    return "error"
end
local function SevColor(sev) return sev == "warning" and Theme.warning or Theme.error end

-- ============================================================
-- Sidebar (liste d'addons) — helpers
-- ============================================================
local CLEAR = { 0, 0, 0, 0 }
local BADGE_H = 16

-- Valeur numérique d'une mesure de FontString (les valeurs "secrètes" passent par tostring).
local function Num(v) return tonumber(tostring(v or 0)) or 0 end

-- Pastille compteur : fond teinté par la sévérité, texte de la même couleur.
local function SetBadge(badge, txt, text, sev)
    local sc = SevColor(sev)
    txt:SetText(text); txt:SetTextColor(sc[1], sc[2], sc[3])
    badge:SetPanelColor(Theme:Alpha(sc, 0.16), CLEAR)
    badge:SetWidth(math.max(BADGE_H + 6, Num(txt:GetStringWidth()) + 12))
end

local function GetSideRow(f, i)
    if not f.tabs[i] then
        local row = Components:CreatePanel(f.Sidebar, { fill = CLEAR, border = CLEAR, slice = 8 })
        row:SetHeight(f.ROW_H - 3); row:EnableMouse(true)
        row.bar = row:CreateTexture(nil, "OVERLAY"); row.bar:SetTexture("Interface\\Buttons\\WHITE8x8")
        row.bar:SetPoint("TOPLEFT", 0, -5); row.bar:SetPoint("BOTTOMLEFT", 0, 5); row.bar:SetWidth(2)
        row.bar:SetVertexColor(Theme.accent[1], Theme.accent[2], Theme.accent[3])
        row.badge = Components:CreatePanel(row, { fill = CLEAR, border = CLEAR, slice = 8 })
        row.badge:SetHeight(BADGE_H); row.badge:SetPoint("RIGHT", -5, 0)
        row.cnt = row.badge:CreateFontString(nil, "OVERLAY"); Theme:Apply(row.cnt, "semibold", 9)
        row.cnt:SetPoint("CENTER", 0, 0)
        -- Nom tronqué à la largeur disponible (ellipse native), nom complet en infobulle.
        row.name = row:CreateFontString(nil, "OVERLAY"); Theme:Apply(row.name, "regular", 11)
        row.name:SetPoint("LEFT", 10, 0); row.name:SetPoint("RIGHT", row.badge, "LEFT", -6, 0)
        row.name:SetJustifyH("LEFT"); row.name:SetWordWrap(false)
        row:SetScript("OnEnter", function(self)
            if f.currentTab ~= self.addon then
                self:SetPanelColor(Theme.panelAlt, CLEAR)
                self.name:SetTextColor(Theme.text[1], Theme.text[2], Theme.text[3])
            end
            if self.addon and self.name.IsTruncated and self.name:IsTruncated() then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetText(self.addon, 1, 1, 1); GameTooltip:Show()
            end
        end)
        row:SetScript("OnLeave", function(self)
            UI:StyleSideRow(self, f.currentTab == self.addon); GameTooltip:Hide()
        end)
        row:SetScript("OnMouseUp", function(self) if self.addon then UI:ShowTab(self.addon) end end)
        f.tabs[i] = row
    end
    return f.tabs[i]
end

-- Actif : voile accent + liseré gauche, nom en clair. Inactif : nom atténué.
function UI:StyleSideRow(row, active)
    row.bar:SetShown(active)
    if active then
        row:SetPanelColor(Theme.accentDim, CLEAR)
        row.name:SetTextColor(Theme.text[1], Theme.text[2], Theme.text[3])
    else
        row:SetPanelColor(CLEAR, CLEAR)
        row.name:SetTextColor(Theme.textDim[1], Theme.textDim[2], Theme.textDim[3])
    end
end

local function AddonStats(addon)
    local count, worst = 0, "warning"
    for _, e in ipairs(AddonNamespace.sessionErrors[addon] or {}) do
        count = count + (e.count or 1)
        if Severity(addon, e.message) == "error" then worst = "error" end
    end
    if BugTabsDB.settings.saveHistory and BugTabsDB.history[addon] then
        for _, e in ipairs(BugTabsDB.history[addon]) do count = count + (e.count or 1) end
    end
    return count, worst
end

-- ============================================================
-- Panneau erreurs — carte recyclée
-- ============================================================
local HEAD_H  = 24 -- ligne d'en-tête d'une carte
local BODY_X  = 18 -- retrait du corps (message complet, bloc code) sous le chevron
local STACK_HEX  = { loc = Theme:Hex(Theme.accent), func = Theme:Hex(Theme.text), other = Theme:Hex(Theme.textDim) }
local LOCALS_HEX = { name = Theme:Hex(Theme.text), value = Theme:Hex(Theme.locals) }

local function SetCardHover(c, on)
    if c.entry then c:SetPanelColor(on and Theme.panelHover or Theme.panelAlt, CLEAR) end
end

-- Libellé de section du bloc code ("Pile d'appels", "Variables locales").
local function CodeLabel(parent, text)
    local fs = parent:CreateFontString(nil, "OVERLAY"); Theme:Apply(fs, "semibold", 9)
    fs:SetText(text); fs:SetTextColor(Theme.label[1], Theme.label[2], Theme.label[3])
    return fs
end

local function CodeText(parent)
    local fs = parent:CreateFontString(nil, "OVERLAY"); Theme:Apply(fs, "regular", 11)
    fs:SetJustifyH("LEFT"); fs:SetWordWrap(true)
    return fs
end

local function GetCard(f, i)
    local c = f.ErrContent.cards[i]
    if not c then
        c = Components:CreatePanel(f.ErrContent, { fill = Theme.panelAlt, border = CLEAR })
        c.sevbar = c:CreateTexture(nil, "OVERLAY"); c.sevbar:SetTexture("Interface\\Buttons\\WHITE8x8")
        c.sevbar:SetPoint("TOPLEFT", 0, 0); c.sevbar:SetPoint("BOTTOMLEFT", 0, 0); c.sevbar:SetWidth(3)
        c.line = CreateFrame("Button", nil, c); c.line:SetPoint("TOPLEFT"); c.line:SetPoint("TOPRIGHT"); c.line:SetHeight(HEAD_H)
        c.line:SetScript("OnEnter", function() SetCardHover(c, true) end)
        c.line:SetScript("OnLeave", function() SetCardHover(c, false) end)
        c.car = c.line:CreateFontString(nil, "OVERLAY"); Theme:Apply(c.car, "semibold", 10); c.car:SetPoint("LEFT", 8, 0)
        c.ts  = c.line:CreateFontString(nil, "OVERLAY"); Theme:Apply(c.ts, "regular", 10); c.ts:SetPoint("LEFT", c.car, "RIGHT", 6, 0)
        c.ts:SetTextColor(Theme.textDim[1], Theme.textDim[2], Theme.textDim[3])
        c.copy = CreateFrame("Button", nil, c.line); c.copy:SetSize(16, 16); c.copy:SetPoint("RIGHT", -6, 0)
        c.copytex = c.copy:CreateTexture(nil, "ARTWORK"); c.copytex:SetAllPoints()
        c.copytex:SetTexture("Interface\\Buttons\\UI-GuildButton-PublicNote-Up"); c.copytex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        c.copytex:SetDesaturated(true); c.copytex:SetVertexColor(0.5, 0.5, 0.56)
        c.copy:SetScript("OnEnter", function()
            SetCardHover(c, true)
            c.copytex:SetVertexColor(Theme.accent[1], Theme.accent[2], Theme.accent[3])
            GameTooltip:SetOwner(c.copy, "ANCHOR_TOP"); GameTooltip:SetText(L["ACTION_COPY"] or "Copy", 1, 1, 1); GameTooltip:Show()
        end)
        c.copy:SetScript("OnLeave", function()
            SetCardHover(c, c.line:IsMouseOver()); c.copytex:SetVertexColor(0.5, 0.5, 0.56); GameTooltip:Hide()
        end)
        c.badge = Components:CreatePanel(c.line, { fill = CLEAR, border = CLEAR, slice = 8 })
        c.badge:SetHeight(BADGE_H); c.badge:SetPoint("RIGHT", c.copy, "LEFT", -6, 0)
        c.badgeTxt = c.badge:CreateFontString(nil, "OVERLAY"); Theme:Apply(c.badgeTxt, "semibold", 9)
        c.badgeTxt:SetPoint("CENTER", 0, 0)
        c.msg = c.line:CreateFontString(nil, "OVERLAY"); Theme:Apply(c.msg, "regular", 11)
        c.msg:SetPoint("LEFT", c.ts, "RIGHT", 8, 0); c.msg:SetPoint("RIGHT", c.copy, "LEFT", -6, 0)
        c.msg:SetJustifyH("LEFT"); c.msg:SetWordWrap(false)
        -- Corps déplié : message complet, puis bloc code (pile + variables locales).
        c.full = CodeText(c); c.full:Hide()
        c.code = Components:CreatePanel(c, { fill = Theme.codeBg, border = Theme.border, slice = 8 }); c.code:Hide()
        c.stackLbl = CodeLabel(c.code, L["STACK_TRACE"]); c.stack = CodeText(c.code)
        c.locLbl = CodeLabel(c.code, L["LOCALS_HEADER"]); c.loc = CodeText(c.code)
        f.ErrContent.cards[i] = c
    end
    return c
end

-- Place le corps d'une carte et renvoie sa hauteur. Largeurs explicites : la
-- hauteur des FontStrings est mesurée tout de suite, avant toute passe de layout.
local function LayoutCard(c)
    if not c.expanded then
        c.msg:Show(); c.full:Hide(); c.code:Hide()
        return HEAD_H
    end
    local w = (c.cw or 300) - BODY_X - 8
    c.msg:Hide()
    c.full:ClearAllPoints(); c.full:SetPoint("TOPLEFT", c, "TOPLEFT", BODY_X, -HEAD_H); c.full:SetWidth(w - 2)
    c.full:Show()
    local h = HEAD_H + Num(c.full:GetStringHeight())
    local hasStack, hasLoc = c.hasStack, c.hasLoc
    if not (hasStack or hasLoc) then c.code:Hide(); return h + 10 end

    local inner, y = w - 20, 8
    local function block(lbl, fs, show)
        lbl:SetShown(show); fs:SetShown(show)
        if not show then return end
        lbl:ClearAllPoints(); lbl:SetPoint("TOPLEFT", c.code, "TOPLEFT", 10, -y)
        y = y + Num(lbl:GetStringHeight()) + 4
        fs:ClearAllPoints(); fs:SetPoint("TOPLEFT", c.code, "TOPLEFT", 10, -y); fs:SetWidth(inner)
        y = y + Num(fs:GetStringHeight()) + 10
    end
    block(c.stackLbl, c.stack, hasStack)
    block(c.locLbl, c.loc, hasLoc)
    c.code:ClearAllPoints(); c.code:SetPoint("TOPLEFT", c, "TOPLEFT", BODY_X, -(h + 8))
    c.code:SetSize(w, y); c.code:Show()
    return h + 8 + y + 8
end

function UI:RelayoutCards(f)
    local y = 0
    for _, c in ipairs(f.ErrContent.cards) do
        if c:IsShown() then
            c:ClearAllPoints(); c:SetPoint("TOPLEFT", 0, -y)
            local h = LayoutCard(c)
            c:SetHeight(h); y = y + h + 3
        end
    end
    f.ErrContent:SetHeight(math.max(y, 10))
end

-- ============================================================
-- Popup de copie (editbox sélectionnable + scroll)
-- ============================================================
function UI:ShowCopyPopup(text)
    local p = AddonNamespace.CopyPopup
    if not p then
        p = Components:CreatePanel(UIParent, { fill = Theme.bg, border = Theme.accent })
        p:SetSize(580, 360); p:SetPoint("CENTER"); p:SetFrameStrata("FULLSCREEN_DIALOG")
        p:EnableMouse(true); p:SetMovable(true); p:RegisterForDrag("LeftButton")
        p:SetScript("OnDragStart", p.StartMoving); p:SetScript("OnDragStop", p.StopMovingOrSizing)

        local ti = p:CreateFontString(nil, "OVERLAY"); Theme:Apply(ti, "semibold", 13)
        ti:SetPoint("TOPLEFT", 12, -11); ti:SetText(L["ACTION_COPY"] or "Copy all")
        ti:SetTextColor(Theme.accent[1], Theme.accent[2], Theme.accent[3])
        local hint = p:CreateFontString(nil, "OVERLAY"); Theme:Apply(hint, "regular", 10)
        hint:SetPoint("TOPRIGHT", -36, -14); hint:SetText("Ctrl+C")
        hint:SetTextColor(Theme.textDim[1], Theme.textDim[2], Theme.textDim[3])
        local cx = CreateFrame("Button", nil, p, "UIPanelCloseButton")
        cx:SetPoint("TOPRIGHT", 0, 0); cx:SetScript("OnClick", function() p:Hide() end)

        local sf = CreateFrame("ScrollFrame", "BugTabsCopyScroll", p, "UIPanelScrollFrameTemplate")
        sf:SetPoint("TOPLEFT", 10, -36); sf:SetPoint("BOTTOMRIGHT", -28, 10)
        local eb = CreateFrame("EditBox", nil, sf); eb:SetMultiLine(true); eb:SetAutoFocus(true)
        eb:SetFontObject("ChatFontNormal"); eb:SetWidth(528)
        eb:SetScript("OnEscapePressed", function(self) self:ClearFocus(); p:Hide() end)
        sf:SetScrollChild(eb)
        p.eb = eb
        p:Hide(); AddonNamespace.CopyPopup = p
    end
    p.eb:SetText(text or "")
    p:Show(); p.eb:SetFocus(); p.eb:HighlightText()
end

-- ============================================================
-- Construction des panneaux
-- ============================================================
function UI:BuildSidebar(f)
    local side = Components:CreatePanel(f, { fill = Theme.panel, border = Theme.border })
    side:SetPoint("TOPLEFT", 6, -38)
    side:SetPoint("BOTTOMLEFT", 6, 28)
    side:SetWidth(150)
    f.Sidebar = side

    local lbl = side:CreateFontString(nil, "OVERLAY"); Theme:Apply(lbl, "regular", 9)
    lbl:SetPoint("TOPLEFT", 8, -7); lbl:SetText(L["SIDEBAR_ADDONS"] or "ADDONS")
    lbl:SetTextColor(Theme.label[1], Theme.label[2], Theme.label[3])

    local scroll = CreateFrame("ScrollFrame", "BugTabsSideScroll", side, "FauxScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 5, -22); scroll:SetPoint("BOTTOMRIGHT", -5, 5)
    f.SideScroll = scroll
    f.ROW_H = 26
    scroll:SetScript("OnVerticalScroll", function(self, off)
        FauxScrollFrame_OnVerticalScroll(self, off, f.ROW_H, function() UI:UpdateUI() end)
    end)
end

function UI:BuildErrorPanel(f)
    local panel = Components:CreatePanel(f, { fill = Theme.panel, border = Theme.border })
    panel:SetPoint("TOPLEFT", f.Sidebar, "TOPRIGHT", 6, 0)
    panel:SetPoint("BOTTOMRIGHT", -6, 28)
    f.Panel = panel

    local head = panel:CreateFontString(nil, "OVERLAY"); Theme:Apply(head, "semibold", 12)
    head:SetPoint("TOPLEFT", 10, -8); f.PanelHead = head
    head:SetTextColor(Theme.text[1], Theme.text[2], Theme.text[3])

    local function actionBtn(tex, tip, onclick)
        local b = CreateFrame("Button", nil, panel)
        b:SetSize(17, 17)
        local t = b:CreateTexture(nil, "ARTWORK"); t:SetAllPoints(); t:SetTexture(tex); t:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        t:SetDesaturated(true); t:SetVertexColor(0.6, 0.6, 0.66)
        b:SetScript("OnEnter", function()
            t:SetVertexColor(Theme.accent[1], Theme.accent[2], Theme.accent[3])
            GameTooltip:SetOwner(b, "ANCHOR_TOP"); GameTooltip:SetText(tip, 1, 1, 1); GameTooltip:Show()
        end)
        b:SetScript("OnLeave", function() t:SetVertexColor(0.6, 0.6, 0.66); GameTooltip:Hide() end)
        b:SetScript("OnClick", onclick)
        return b
    end

    local clearB = actionBtn("Interface\\Buttons\\UI-GroupLoot-Pass-Up", L["ACTION_CLEAR"] or "Clear tab", function()
        if f.currentTab then
            AddonNamespace.sessionErrors[f.currentTab] = nil
            AddonNamespace.sessionErrorsHash[f.currentTab] = nil
            if BugTabsDB.settings.saveHistory then BugTabsDB.history[f.currentTab] = nil end
            UI:ShowTab(f.currentTab)
            if AddonNamespace.Broker then AddonNamespace.Broker:Update() end
        end
    end)
    clearB:SetPoint("TOPRIGHT", -8, -7)

    local copyB = actionBtn("Interface\\Buttons\\UI-GuildButton-PublicNote-Up", L["ACTION_COPY"] or "Copy all", function()
        UI:ShowCopyPopup(f.copyText or "")
    end)
    copyB:SetPoint("TOPRIGHT", clearB, "TOPLEFT", -4, 0)

    local scroll = CreateFrame("ScrollFrame", "BugTabsErrScroll", panel, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 8, -30); scroll:SetPoint("BOTTOMRIGHT", -26, 8)
    local content = CreateFrame("Frame", nil, scroll); content:SetSize(10, 10)
    scroll:SetScrollChild(content)
    f.ErrScroll, f.ErrContent = scroll, content
    content.cards = {}
end

-- ============================================================
-- Fenêtre principale
-- ============================================================
function UI:CreateUI()
    if AddonNamespace.MainFrame then return end
    local s = BugTabsDB.settings

    local f = CreateFrame("Frame", "BugTabsFrame", UIParent)
    f:SetSize(s.windowWidth or 600, s.windowHeight or 480)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:SetMovable(true); f:EnableMouse(true)
    f:SetResizable(true)
    if f.SetResizeBounds then f:SetResizeBounds(480, 360) elseif f.SetMinResize then f:SetMinResize(480, 360) end
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        s.windowWidth, s.windowHeight = math.floor(self:GetWidth()), math.floor(self:GetHeight())
    end)
    f:Hide()

    local bg = Components:CreatePanel(f, { fill = Theme.bg, border = Theme.accent })
    bg:SetAllPoints(f); bg:SetFrameLevel(math.max(0, f:GetFrameLevel() - 1))

    local titleBar = Components:CreatePanel(f, { fill = Theme.accentDim, border = {0,0,0,0} })
    titleBar:SetHeight(32); titleBar:SetPoint("TOPLEFT", 2, -2); titleBar:SetPoint("TOPRIGHT", -2, -2)
    local title = titleBar:CreateFontString(nil, "OVERLAY"); Theme:Apply(title, "semibold", 15)
    title:SetPoint("LEFT", 12, 0); title:SetText("BugTabs")
    title:SetTextColor(Theme.accent[1], Theme.accent[2], Theme.accent[3])
    f.Title = title

    local closeX = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeX:SetPoint("TOPRIGHT", 0, 0); closeX:SetScript("OnClick", function() f:Hide() end)

    local gear = CreateFrame("Button", nil, f)
    gear:SetSize(17, 17); gear:SetPoint("RIGHT", closeX, "LEFT", 0, 0)
    local gico = gear:CreateTexture(nil, "ARTWORK"); gico:SetAllPoints(gear)
    gico:SetTexture("Interface\\Icons\\Trade_Engineering"); gico:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    gico:SetDesaturated(true); gico:SetVertexColor(0.62, 0.62, 0.68)
    gear:SetScript("OnEnter", function()
        gico:SetVertexColor(Theme.accent[1], Theme.accent[2], Theme.accent[3])
        GameTooltip:SetOwner(gear, "ANCHOR_TOP"); GameTooltip:SetText(L["SETTINGS_TITLE"] or "Settings", 1, 1, 1); GameTooltip:Show()
    end)
    gear:SetScript("OnLeave", function() gico:SetVertexColor(0.62, 0.62, 0.68); GameTooltip:Hide() end)
    gear:SetScript("OnClick", function() UI:ToggleSettings() end)

    UI:BuildSidebar(f)
    UI:BuildErrorPanel(f)

    local grip = CreateFrame("Button", nil, f)
    grip:SetSize(16, 16); grip:SetPoint("BOTTOMRIGHT", -3, 3)
    local gt = grip:CreateTexture(nil, "OVERLAY"); gt:SetAllPoints()
    gt:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetScript("OnMouseDown", function() f:StartSizing("BOTTOMRIGHT") end)
    grip:SetScript("OnMouseUp", function()
        f:StopMovingOrSizing()
        s.windowWidth, s.windowHeight = math.floor(f:GetWidth()), math.floor(f:GetHeight())
        UI:ShowTab(f.currentTab or L["UNKNOWN_ADDON"])
    end)

    f.Version = f:CreateFontString(nil, "OVERLAY"); Theme:Apply(f.Version, "regular", 9)
    -- Compatible GetAddOnMetadata : TBC uses global, Retail uses C_AddOns namespace
    local _GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
    local version = (_GetAddOnMetadata and _GetAddOnMetadata(AddonName, "Version")) or ""
    f.Version:SetPoint("BOTTOMLEFT", 8, 6); f.Version:SetText(version ~= "" and ("v" .. version) or "")
    f.Version:SetTextColor(Theme.label[1], Theme.label[2], Theme.label[3])

    f.tabs = {}; f.currentTab = nil
    AddonNamespace.MainFrame = f
end

-- ============================================================
-- Mises à jour
-- ============================================================
function UI:UpdateUI()
    local f = AddonNamespace.MainFrame
    if not f then return end

    local list = {}
    for name in pairs(AddonNamespace.sessionErrors) do list[#list + 1] = name end
    if BugTabsDB.settings.saveHistory and BugTabsDB.history then
        for name in pairs(BugTabsDB.history) do
            if not AddonNamespace.tContains(list, name) then list[#list + 1] = name end
        end
    end
    table.sort(list)
    f.addonList = list

    local total = #list
    local shown = math.max(1, math.floor((f.Sidebar:GetHeight() - 27) / f.ROW_H))
    FauxScrollFrame_Update(f.SideScroll, total, shown, f.ROW_H)
    local offset = FauxScrollFrame_GetOffset(f.SideScroll)

    for _, r in ipairs(f.tabs) do r:Hide() end
    for i = 1, shown do
        local addon = list[i + offset]
        if addon then
            local row = GetSideRow(f, i)
            local cnt, worst = AddonStats(addon)
            row.addon = addon
            row.name:SetText(addon)
            SetBadge(row.badge, row.cnt, cnt, worst)
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", f.Sidebar, "TOPLEFT", 5, -22 - (i - 1) * f.ROW_H)
            row:SetPoint("RIGHT", f.Sidebar, "RIGHT", -5, 0)
            UI:StyleSideRow(row, f.currentTab == addon)
            row:Show()
        end
    end
end

function UI:ShowTab(addonName)
    if not AddonNamespace.MainFrame then UI:CreateUI() end
    local f = AddonNamespace.MainFrame
    f:Show(); f.currentTab = addonName

    local entries, copyLines = {}, {}
    if BugTabsDB.settings.saveHistory and BugTabsDB.history[addonName] then
        for _, e in ipairs(BugTabsDB.history[addonName]) do entries[#entries + 1] = { e = e, hist = true } end
    end
    for _, e in ipairs(AddonNamespace.sessionErrors[addonName] or {}) do entries[#entries + 1] = { e = e, hist = false } end

    f.PanelHead:SetText((addonName or "?") .. "  |cff5b5b66" .. string.format(L["ERRORS_COUNT"] or "%d errors", #entries) .. "|r")

    for _, c in ipairs(f.ErrContent.cards) do c:Hide() end
    local W = f.ErrScroll:GetWidth()

    if #entries == 0 then
        local c = GetCard(f, 1); c:SetWidth(W); c:ClearAllPoints(); c:SetPoint("TOPLEFT", 0, 0)
        c.entry = false; c:SetAlpha(1)
        c:SetPanelColor(CLEAR, CLEAR); c.sevbar:Hide(); c.copy:Hide(); c.badge:Hide(); c.car:SetText(""); c.ts:SetText("")
        c.msg:SetPoint("RIGHT", c.copy, "LEFT", -6, 0)
        c.msg:SetText(string.format(L["NO_ERRORS"], addonName))
        c.msg:SetTextColor(Theme.textDim[1], Theme.textDim[2], Theme.textDim[3])
        c.line:SetScript("OnClick", nil)
        c.expanded = false; c:SetHeight(LayoutCard(c)); c:Show()
        f.copyText = ""; f.ErrContent:SetHeight(HEAD_H + 2)
        UI:UpdateUI()
        if AddonNamespace.MinimapIcon then AddonNamespace.MinimapIcon:SetVertexColor(1, 1, 1) end
        return
    end

    for i, item in ipairs(entries) do
        local e = item.e
        local sev = Severity(addonName, e.message)
        local sc = SevColor(sev)
        local c = GetCard(f, i)
        c.entry, c.cw = true, W
        c:SetWidth(W); c:SetPanelColor(Theme.panelAlt, CLEAR)
        -- Entrées d'historique (sessions précédentes) estompées.
        c:SetAlpha(item.hist and 0.7 or 1)
        c.sevbar:Show(); c.sevbar:SetVertexColor(sc[1], sc[2], sc[3])
        c.car:SetText("+"); c.car:SetTextColor(sc[1], sc[2], sc[3])
        c.ts:SetText(item.hist and string.format(L["HISTORY_PREFIX"], e.timestamp) or e.timestamp)
        if e.count and e.count > 1 then
            SetBadge(c.badge, c.badgeTxt, "x" .. e.count, sev); c.badge:Show()
            c.msg:SetPoint("RIGHT", c.badge, "LEFT", -6, 0)
        else
            c.badge:Hide(); c.msg:SetPoint("RIGHT", c.copy, "LEFT", -6, 0)
        end
        c.msg:SetText(e.message); c.msg:SetTextColor(Theme.text[1], Theme.text[2], Theme.text[3])
        c.full:SetText(e.message); c.full:SetTextColor(Theme.text[1], Theme.text[2], Theme.text[3])
        c.hasStack = e.stack ~= nil and e.stack ~= ""
        c.hasLoc = e.locals ~= nil and e.locals ~= ""
        c.stack:SetText(c.hasStack and AddonNamespace.StackFormat.Render(e.stack, addonName, STACK_HEX) or "")
        c.loc:SetText(c.hasLoc and AddonNamespace.StackFormat.RenderLocals(e.locals, LOCALS_HEX) or "")
        c.copy:Show()
        local fulltext = e.timestamp .. " " .. e.message
            .. (e.stack and ("\n" .. e.stack) or "")
            .. (e.locals and ("\n\n" .. L["LOCALS_HEADER"] .. "\n" .. e.locals) or "")
        c.copy:SetScript("OnClick", function() UI:ShowCopyPopup(fulltext) end)
        c.expanded = false
        c.line:SetScript("OnClick", function()
            c.expanded = not c.expanded
            c.car:SetText(c.expanded and "-" or "+")
            UI:RelayoutCards(f)
        end)
        c:Show()
        copyLines[#copyLines + 1] = fulltext
    end
    local copyText = ""
    for i, line in ipairs(copyLines) do
        if i == 1 then
            copyText = line
        else
            copyText = copyText .. "\n" .. line
        end
    end
    f.copyText = copyText
    UI:RelayoutCards(f)
    UI:UpdateUI()
    if AddonNamespace.MinimapIcon then AddonNamespace.MinimapIcon:SetVertexColor(1, 1, 1) end
end

function UI:Toggle()
    if not AddonNamespace.MainFrame then UI:CreateUI() end
    local f = AddonNamespace.MainFrame
    if f:IsShown() then
        f:Hide()
    else
        f:Show()
        local first = (f.addonList and f.addonList[1]) or next(AddonNamespace.sessionErrors)
        UI:ShowTab(first or L["UNKNOWN_ADDON"])
    end
end

-- ============================================================
-- Réglages (engrenage)
-- ============================================================
function UI:ToggleSettings()
    local f = AddonNamespace.MainFrame
    if f.Settings and f.Settings:IsShown() then f.Settings:Hide(); return end
    if not f.Settings then
        local m = Components:CreatePanel(f, { fill = Theme.panel, border = Theme.accent })
        m:SetSize(190, 184); m:SetPoint("TOPRIGHT", -6, -36); m:SetFrameStrata("FULLSCREEN_DIALOG")
        local function chk(yoff, label, get, set)
            local cb = CreateFrame("CheckButton", nil, m, "UICheckButtonTemplate")
            cb:SetSize(20, 20); cb:SetPoint("TOPLEFT", 8, yoff); cb:SetChecked(get())
            cb:SetScript("OnClick", function(self) set(self:GetChecked() and true or false) end)
            local t = cb:CreateFontString(nil, "OVERLAY"); Theme:Apply(t, "regular", 11)
            t:SetPoint("LEFT", cb, "RIGHT", 2, 0); t:SetText(label)
            t:SetTextColor(Theme.text[1], Theme.text[2], Theme.text[3])
        end
        chk(-8,  L["OPTION_SAVE_HISTORY"],  function() return BugTabsDB.settings.saveHistory end,  function(v) BugTabsDB.settings.saveHistory = v end)
        chk(-30, L["OPTION_ENABLE_BANNER"], function() return BugTabsDB.settings.showBanner end,   function(v) BugTabsDB.settings.showBanner = v end)
        chk(-52, L["OPTION_ENABLE_TOAST"],  function() return BugTabsDB.settings.showToast end,    function(v) BugTabsDB.settings.showToast = v end)
        chk(-74, L["OPTION_ENABLE_SOUND"],  function() return BugTabsDB.settings.playSound end,    function(v) BugTabsDB.settings.playSound = v end)
        chk(-96, L["OPTION_ENABLE_FONT"],   function() return BugTabsDB.settings.useCustomFont end, function(v)
            BugTabsDB.settings.useCustomFont = v
            print("|cff00e6ffBugTabs|r: " .. (L["CUSTOM_FONT_RELOAD"] or ""))
        end)
        chk(-118, L["OPTION_CAPTURE_LOCALS"], function() return BugTabsDB.settings.captureLocals end, function(v)
            BugTabsDB.settings.captureLocals = v
        end)
        chk(-140, L["OPTION_SHOW_MINIMAP"], function() return BugTabsDB.settings.showMinimap end, function(v)
            BugTabsDB.settings.showMinimap = v
            if AddonNamespace.MinimapButton then AddonNamespace.MinimapButton:SetShown(v) end
        end)
        f.Settings = m
    end
    f.Settings:Show()
end

-- ============================================================
-- Notifications : toast + bannière
-- ============================================================
function UI:ShowToast(addonName, severity)
    local t = AddonNamespace.Toast
    if not t then
        t = Components:CreatePanel(UIParent, { fill = Theme.panel, border = Theme.error })
        t:SetSize(240, 40); t:SetPoint("BOTTOMRIGHT", -20, 120); t:SetFrameStrata("FULLSCREEN_DIALOG"); t:EnableMouse(true)
        t.txt = t:CreateFontString(nil, "OVERLAY"); Theme:Apply(t.txt, "regular", 11)
        t.txt:SetPoint("LEFT", 12, 0); t.txt:SetPoint("RIGHT", -10, 0); t.txt:SetJustifyH("LEFT")
        t.txt:SetTextColor(Theme.text[1], Theme.text[2], Theme.text[3])
        t:SetScript("OnMouseUp", function(self) UI:ShowTab(self.addon or L["UNKNOWN_ADDON"]); self:Hide() end)
        t:SetScript("OnUpdate", function(self, el)
            if not self.endT then return end
            if GetTime() > self.endT then
                local a = self:GetAlpha() - el * 2
                if a <= 0 then self:Hide(); self:SetAlpha(1) else self:SetAlpha(a) end
            end
        end)
        t:Hide(); AddonNamespace.Toast = t
    end
    local sc = SevColor(severity or "error"); t:SetPanelColor(Theme.panel, sc)
    t.addon = addonName
    t.txt:SetText("|cff00e6ffBugTabs|r  " .. (addonName or L["UNKNOWN_ADDON"]))
    t:SetAlpha(1); t.endT = GetTime() + 4; t:Show()
end

function UI:ShowBanner(addonName)
    local sev = Severity(addonName, "")
    if BugTabsDB.settings.showToast then UI:ShowToast(addonName, sev) end
    if not BugTabsDB.settings.showBanner then return end
    local b = AddonNamespace.Banner
    if not b then
        b = Components:CreatePanel(UIParent, { fill = Theme.panel, border = Theme.error })
        b:SetSize(420, 30); b:SetPoint("TOP", 0, -40); b:SetFrameStrata("FULLSCREEN_DIALOG"); b:EnableMouse(true)
        b.txt = b:CreateFontString(nil, "OVERLAY"); Theme:Apply(b.txt, "semibold", 12); b.txt:SetPoint("CENTER")
        b.txt:SetTextColor(Theme.text[1], Theme.text[2], Theme.text[3])
        b:SetScript("OnMouseUp", function(self) UI:ShowTab(self.addon or L["UNKNOWN_ADDON"]); self:Hide() end)
        b:SetScript("OnUpdate", function(self, el)
            if not self.endT then return end
            if GetTime() > self.endT then
                local a = self:GetAlpha() - el * 2
                if a <= 0 then self:Hide(); self:SetAlpha(1) else self:SetAlpha(a) end
            end
        end)
        b:Hide(); AddonNamespace.Banner = b
    end
    b.addon = addonName
    b:SetPanelColor(Theme.panel, SevColor(sev))
    b.txt:SetText("|cffe05555BugTabs|r  " .. (addonName or L["UNKNOWN_ADDON"]))
    b:SetAlpha(1); b.endT = GetTime() + 4; b:Show()
end

-- ============================================================
-- Bouton minimap (porté de l'ancienne UI, logique inchangée)
-- ============================================================
function UI:CreateMinimapButton()
    if AddonNamespace.MinimapButton then return end

    local btn = CreateFrame("Button", "BugTabsMinimapButton", Minimap)
    btn:SetSize(32, 32)
    btn:SetFrameLevel(9)
    btn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    local bg = btn:CreateTexture(nil, "BACKGROUND")
    bg:SetSize(25, 25)
    bg:SetPoint("CENTER")
    bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    bg:SetVertexColor(0, 0, 0, 0.6)

    local ico = btn:CreateTexture("BugTabsMinimapButtonIcon", "ARTWORK")
    ico:SetTexture("Interface\\Icons\\INV_Misc_Head_Dragon_01")
    ico:SetSize(18, 18)
    ico:SetPoint("CENTER")
    AddonNamespace.MinimapIcon = ico

    local border = btn:CreateTexture(nil, "OVERLAY")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    border:SetSize(52, 52)
    border:SetPoint("TOPLEFT")

    btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    btn:SetScript("OnClick", function(self, button)
        if button == "RightButton" then
            BugTabsDB.settings.saveHistory = not BugTabsDB.settings.saveHistory
            if BugTabsDB.settings.saveHistory then
                print("|cFF00FF00BugTabs|r: " .. (L["HISTORY_ENABLED_MSG"] or "History on"))
            else
                print("|cFF00FF00BugTabs|r: " .. (L["HISTORY_DISABLED_MSG"] or "History off"))
            end
        elseif button == "LeftButton" then
            if IsShiftKeyDown() then
                AddonNamespace.sessionErrors = {}
                UI:UpdateUI()
                if AddonNamespace.MainFrame and AddonNamespace.MainFrame:IsShown() then
                    UI:ShowTab(L["UNKNOWN_ADDON"])
                end
                if AddonNamespace.Broker then AddonNamespace.Broker:Update() end
                print("|cFF00FF00BugTabs|r: " .. (L["SESSION_CLEARED_MSG"] or "Cleared"))
            else
                UI:Toggle()
            end
        end
    end)

    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText(L["MINIMAP_TOOLTIP1"] or "BugTabs")

        local count = 0
        if AddonNamespace.sessionErrors then
            for _, errs in pairs(AddonNamespace.sessionErrors) do
                for _, err in ipairs(errs) do
                    count = count + (err.count or 1)
                end
            end
        end

        GameTooltip:AddLine(string.format(L["MINIMAP_ERRORS_COUNT"] or "Current Errors: %d", count), 1, 1, 1)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(L["MINIMAP_TOOLTIP_LCLICK"] or "Left-Click to open", 1, 1, 1)
        GameTooltip:AddLine(L["MINIMAP_TOOLTIP_SLCLICK"] or "Shift+Left-Click to clear", 1, 1, 1)
        GameTooltip:AddLine(L["MINIMAP_TOOLTIP_RCLICK"] or "Right-Click to toggle history", 1, 1, 1)
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", GameTooltip_Hide)

    btn:SetMovable(true)
    btn:RegisterForDrag("LeftButton")
    btn:SetScript("OnDragStart", function(self)
        self:LockHighlight()
        self:SetScript("OnUpdate", function(self)
            local xpos, ypos = GetCursorPosition()
            local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()
            xpos = xmin - xpos / UIParent:GetScale() + 70
            ypos = ypos / UIParent:GetScale() - ymin - 70
            BugTabsDB.minimapPos = math.deg(math.atan2(ypos, xpos))
            UI:UpdateMinimapButton()
        end)
    end)
    btn:SetScript("OnDragStop", function(self)
        self:UnlockHighlight()
        self:SetScript("OnUpdate", nil)
    end)

    AddonNamespace.MinimapButton = btn
    UI:UpdateMinimapButton()
    btn:SetShown(BugTabsDB.settings.showMinimap)
end

function UI:UpdateMinimapButton()
    if not AddonNamespace.MinimapButton then return end
    local angle = BugTabsDB.minimapPos or 45
    local radius = 80
    AddonNamespace.MinimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (radius * math.cos(math.rad(angle))),
        (radius * math.sin(math.rad(angle))) - 52)
end

-- ============================================================
-- Slash commands (porté de l'ancienne UI, inchangé)
-- ============================================================
SLASH_BUGTABS1 = "/bugtabs"
SLASH_BUGTABS2 = "/bt"
SlashCmdList["BUGTABS"] = function(msg)
    local cmd, arg = msg:match("^(%S*)%s*(.*)$")
    if cmd == "test" then
        if arg == "spam" then
            AddonNamespace.Events:StoreError("Instant_A", "Error 1 (A)")
            AddonNamespace.Events:StoreError("Instant_B", "Error 1 (B)")
            AddonNamespace.Events:StoreError("Instant_C", "Error 1 (C)")
            AddonNamespace.Events:StoreError("Instant_A", "Error 2 (A)")
            AddonNamespace.Events:StoreError("Instant_A", "Error 3 (A)")
            print("|cFF00FF00BugTabs|r: Spam test complete.")
            UI:Toggle()
        elseif arg == "all" then
            local errors = {
                { name = "FakeAddon_A", msg = "Interface\\AddOns\\FakeAddon_A\\Core.lua:10: attempt to index nil" },
                { name = "FakeAddon_B", msg = "Interface\\AddOns\\FakeAddon_B\\UI.lua:55: unexpected symbol near 'end'" },
                { name = "FakeAddon_C", msg = "Interface\\AddOns\\FakeAddon_C\\DB.lua:3: attempt to call global 'NonExistentFunc'" }
            }
            print("|cFF00FF00BugTabs|r: Simulating errors from 3 addons...")
            local ticker = CreateFrame("Frame")
            ticker.timer = 0
            ticker.idx = 1
            ticker:SetScript("OnUpdate", function(self, elapsed)
                self.timer = self.timer + elapsed
                if self.timer >= 1.5 then
                    self.timer = 0
                    if errors[self.idx] then
                        AddonNamespace.Events:StoreError(errors[self.idx].name, errors[self.idx].msg)
                        self.idx = self.idx + 1
                    else
                        self:SetScript("OnUpdate", nil)
                    end
                end
            end)
        else
            AddonNamespace.Events:StoreError("BugTabs_Test",
                "Interface\\AddOns\\BugTabs\\Test.lua:1: This is a test error from BugTabs!")
            print("|cFF00FF00BugTabs|r: Test error triggered. Use '/bt test all' for multiple.")
        end
    else
        UI:Toggle()
    end
end
