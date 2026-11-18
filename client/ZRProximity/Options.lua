-- ZRProximity options panel (Interface > AddOns > ZRProximity, or /zrp).
local _, ns = ...

local panel
local controls = {}

local function Changed(applyCVars)
    if applyCVars then ns.ApplyCVars() end
    ns.RefreshAll()
end

local function NewCheck(parent, key, label, tip, x, y, applyCVars)
    local name = "ZRProximityCheck_" .. key
    local cb = CreateFrame("CheckButton", name, parent, "InterfaceOptionsCheckButtonTemplate")
    cb:SetPoint("TOPLEFT", x, y)
    local text = cb.Text or _G[name .. "Text"]
    text:SetText(label)
    cb.tooltipText = tip
    cb:SetScript("OnClick", function(self)
        ns.db[key] = self:GetChecked() and true or false
        Changed(applyCVars)
    end)
    cb.Refresh = function(self) self:SetChecked(ns.db[key]) end
    controls[#controls + 1] = cb
    return cb
end

local function NewSlider(parent, key, label, minV, maxV, step, x, y, fmt)
    local name = "ZRProximitySlider_" .. key
    local s = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
    s:SetPoint("TOPLEFT", x, y)
    s:SetWidth(260)
    s:SetMinMaxValues(minV, maxV)
    s:SetValueStep(step)
    if s.SetObeyStepOnDrag then s:SetObeyStepOnDrag(true) end
    _G[name .. "Low"]:SetText(minV)
    _G[name .. "High"]:SetText(maxV)
    local text = _G[name .. "Text"]
    local function Label(v)
        text:SetText(label .. ": " .. fmt(v))
    end
    s:SetScript("OnValueChanged", function(self, v)
        v = math.floor(v / step + 0.5) * step
        ns.db[key] = v
        Label(v)
        Changed(false)
    end)
    s.Refresh = function(self)
        self:SetValue(ns.db[key])
        Label(ns.db[key])
    end
    controls[#controls + 1] = s
    return s
end

local function Yards(hostile)
    return function(v)
        local eff = ns.EffectiveStep(v, hostile)
        if v <= 0 then return "never by distance" end
        if eff ~= v then return ("%d yd (checks %d yd)"):format(v, eff) end
        return ("%d yd"):format(v)
    end
end

function ns.RefreshOptions()
    for _, c in ipairs(controls) do c:Refresh() end
end

function ns.OpenOptions()
    if not panel then return end
    InterfaceOptionsFrame_OpenToCategory(panel)
    InterfaceOptionsFrame_OpenToCategory(panel) -- twice: first call only opens the frame on 8.x
end

function ns.CreateOptions()
    if panel then return end
    panel = CreateFrame("Frame", "ZRProximityOptions", UIParent)
    panel.name = "ZRProximity"

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("ZRProximity")
    local sub = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    sub:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
    sub:SetWidth(580)
    sub:SetJustifyH("LEFT")
    sub:SetText("Nameplates stay hidden until a unit is close, targeted, under the mouse, fighting you, " ..
        "or you look at it. Distances work in steps (3, 4, 5, 6, 8, 10, 15 ... 40 yards).")

    NewCheck(panel, "enabled", "Enable ZRProximity", "Off shows every nameplate normally.", 16, -64, true)

    NewSlider(panel, "hostileRange", "Aggressive enemies", 0, 40, 1, 24, -120, Yards(true))
    NewSlider(panel, "neutralRange", "Neutral units", 0, 40, 1, 24, -170, Yards(true))
    NewSlider(panel, "friendlyRange", "Friendly units", 0, 40, 1, 24, -220, Yards(false))

    NewCheck(panel, "showTarget", "Always show my target", nil, 320, -110)
    NewCheck(panel, "showMouseover", "Show the unit under the mouse", nil, 320, -136)
    NewCheck(panel, "showCombat", "Show enemies fighting me", "Any unit that has you on its threat list.", 320, -162)

    NewCheck(panel, "stare", "Show a name when I look at it",
        "Shows a plate once it stays near the centre of the screen for the delay below.", 16, -270)
    NewSlider(panel, "stareDelay", "Look delay", 0, 3, 0.1, 24, -320, function(v) return ("%.1f s"):format(v) end)
    NewSlider(panel, "stareLinger", "Stays visible after", 0, 10, 0.5, 24, -370, function(v) return ("%.1f s"):format(v) end)
    NewSlider(panel, "stareRadius", "Look area", 20, 300, 10, 24, -420, function(v) return ("%d"):format(v) end)
    NewSlider(panel, "fadeTime", "Fade time", 0, 1, 0.05, 320, -320, function(v) return ("%.2f s"):format(v) end)

    NewCheck(panel, "hideFloatingNames", "Hide the names above heads",
        "Turns off the game's floating unit names so names only come from nameplates. " ..
        "Your old settings come back when you untick this.", 16, -470, true)
    NewCheck(panel, "hideFriendlyInInstances", "Hide friendly plates in dungeons and raids",
        "Blizzard blocks addons from friendly plates inside instances, so there it is all or nothing.", 16, -496, true)
    NewCheck(panel, "clickThrough", "Click-through nameplates",
        "Hidden plates can still be clicked. This makes all plates click-through (changes outside combat).", 16, -522, true)

    panel.refresh = ns.RefreshOptions
    panel:SetScript("OnShow", ns.RefreshOptions)
    InterfaceOptions_AddCategory(panel)
end
