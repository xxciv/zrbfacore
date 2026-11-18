-- ZRProximity (BFA 8.3.7 client addon)
-- Keeps Blizzard's nameplates on but invisible, and fades a plate in only when:
--   * it is your target or under the mouse,
--   * the unit is fighting you,
--   * the unit is within the distance set for its type (hostile / neutral / friendly),
--   * you look at it: its plate stays in the middle of the screen for a moment.
-- Visibility is done with SetAlpha on each plate's UnitFrame, which addons may do in combat.
local ADDON, ns = ...

local DEFAULTS = {
    enabled = true,
    hostileRange = 10,      -- yards, aggressive (red) units
    neutralRange = 5,       -- yards, neutral (yellow) units
    friendlyRange = 4,      -- yards, friendly units (NPCs and players)
    showTarget = true,
    showMouseover = true,
    showCombat = true,      -- enemies that have you on their threat list
    stare = true,
    stareRadius = 80,       -- UI units each side of the screen's middle (the look column)
    stareDelay = 0.5,       -- seconds the plate must stay there
    stareLinger = 2.0,      -- seconds it stays visible after you look away
    stareRange = 20,        -- yards: only units this close can be revealed by looking at them
    fadeTime = 0.25,
    hideFriendlyInInstances = true, -- Blizzard blocks addons from friendly plates in dungeons/raids
    hideFloatingNames = true,       -- the names above heads (one global setting, not per unit)
    clickThrough = false,           -- make nameplates click-through (out of combat only)
}
ns.DEFAULTS = DEFAULTS

-- Floating unit-name CVars switched off by hideFloatingNames; originals are kept in the DB.
local NAME_CVARS = {
    "UnitNameNPC", "UnitNameHostleNPC", "UnitNameInteractiveNPC", "UnitNameFriendlySpecialNPCName",
    "UnitNameNonCombatCreatureName", "UnitNameFriendlyPlayerName", "UnitNameEnemyPlayerName",
    "UnitNameFriendlyPetName", "UnitNameEnemyPetName", "UnitNameFriendlyGuardianName",
    "UnitNameEnemyGuardianName", "UnitNameFriendlyTotemName", "UnitNameEnemyTotemName",
}

local db
local plates = {}        -- [unit token] = state
local pendingCVars = false
local TICK = 0.1
local sinceTick = 0

local function Print(msg)
    print("|cff33ff99ZRProximity|r: " .. msg)
end
ns.Print = Print

-- ---------------------------------------------------------------------------
-- CVars (nameplates on, floating names off, click-through, instance friendlies)
-- ---------------------------------------------------------------------------
local function SetCVarSafe(name, value)
    if GetCVar(name) ~= nil and GetCVar(name) ~= tostring(value) then
        pcall(SetCVar, name, value)
    end
end

local function InRestrictedInstance()
    local inInstance, instanceType = IsInInstance()
    return inInstance and (instanceType == "party" or instanceType == "raid")
end

function ns.ApplyCVars()
    if InCombatLockdown() then
        pendingCVars = true
        return
    end
    pendingCVars = false
    if not db.enabled then
        ns.RestoreNameCVars()
        return
    end
    SetCVarSafe("nameplateShowAll", 1)
    SetCVarSafe("nameplateShowEnemies", 1)
    SetCVarSafe("nameplateShowEnemyMinions", 1)
    local friends = (db.hideFriendlyInInstances and InRestrictedInstance()) and 0 or 1
    SetCVarSafe("nameplateShowFriends", friends)
    SetCVarSafe("nameplateShowFriendlyNPCs", friends)

    if db.hideFloatingNames then
        db.savedCVars = db.savedCVars or {}
        for _, name in ipairs(NAME_CVARS) do
            local v = GetCVar(name)
            if v ~= nil then
                if db.savedCVars[name] == nil then db.savedCVars[name] = v end
                SetCVarSafe(name, 0)
            end
        end
    else
        ns.RestoreNameCVars()
    end

    if C_NamePlate.SetNamePlateEnemyClickThrough then
        C_NamePlate.SetNamePlateEnemyClickThrough(db.clickThrough and true or false)
        C_NamePlate.SetNamePlateFriendlyClickThrough(db.clickThrough and true or false)
    end
end

function ns.RestoreNameCVars()
    if InCombatLockdown() then
        pendingCVars = true
        return
    end
    if db.savedCVars then
        for name, v in pairs(db.savedCVars) do
            SetCVarSafe(name, v)
        end
        db.savedCVars = nil
    end
end

-- ---------------------------------------------------------------------------
-- Deciding what to show
-- ---------------------------------------------------------------------------
local function UnitKind(unit)
    local reaction = UnitReaction(unit, "player") or 4
    if UnitCanAttack("player", unit) and (reaction <= 3 or UnitIsEnemy("player", unit)) then
        return "hostile"
    elseif reaction >= 5 or UnitIsFriend("player", unit) then
        return "friendly"
    end
    return "neutral"
end
ns.UnitKind = UnitKind

local function RangeFor(kind)
    if kind == "hostile" then return db.hostileRange
    elseif kind == "neutral" then return db.neutralRange end
    return db.friendlyRange
end

-- Where the plate sits relative to the screen centre, in UIParent units (dx right, dy up).
-- nil if it can't be measured.
local function ScreenOffset(plate)
    local ok, x, y = pcall(plate.GetCenter, plate)
    if not ok or not x then return nil end
    local s = plate:GetEffectiveScale() / UIParent:GetEffectiveScale()
    return x * s - UIParent:GetWidth() / 2, y * s - UIParent:GetHeight() / 2
end

-- The "look" area is a column up the middle of the screen, not a circle on the centre.
-- With the third-person camera your own character sits in the centre, so a unit you face
-- has its plate ABOVE the centre: a few yards away it is roughly 90-130 UI units up, and
-- the farther away it is the closer it gets to the horizon. What tells you are facing it
-- is the sideways offset, so the column is stareRadius wide on each side, starts a little
-- below the centre and reaches 40% of the screen height above it.
local function LookScore(dx, dy)
    if math.abs(dx) > db.stareRadius then return nil end
    if dy < -db.stareRadius or dy > UIParent:GetHeight() * 0.4 then return nil end
    return math.abs(dx) + math.abs(dy) * 0.2
end

local function Wanted(unit, st, now)
    if not db.enabled then return 1 end
    if UnitNameplateShowsWidgetsOnly and UnitNameplateShowsWidgetsOnly(unit) then return 1 end
    if db.showTarget and UnitIsUnit(unit, "target") then return 1 end
    if db.showMouseover and UnitIsUnit(unit, "mouseover") then return 1 end
    if db.showCombat and UnitThreatSituation("player", unit) ~= nil then return 1 end
    if st.lingerUntil > now then return 1 end
    if ns.IsWithin(unit, RangeFor(UnitKind(unit))) then return 1 end
    return 0
end

-- Only one plate can be "looked at": the one nearest the middle of the look column whose
-- unit is within stareRange. Far-away plates bunch up around the horizon, so without the
-- range limit they all popped up at once.
local function UpdateStare(now, elapsed)
    local best, bestScore
    if db.stare then
        for unit, st in pairs(plates) do
            local dx, dy = ScreenOffset(st.plate)
            local score = dx and LookScore(dx, dy)
            if score and (not bestScore or score < bestScore) and ns.IsWithin(unit, db.stareRange) then
                best, bestScore = st, score
            end
        end
    end
    for _, st in pairs(plates) do
        if st == best then
            st.stareTime = st.stareTime + elapsed
            if st.stareTime >= db.stareDelay then
                st.lingerUntil = now + db.stareLinger
            end
        else
            st.stareTime = 0
        end
    end
end

-- ---------------------------------------------------------------------------
-- Plate bookkeeping
-- ---------------------------------------------------------------------------
-- Plate names. On 8.3.7 Blizzard's CompactUnitFrame_UpdateName hides a plate's name unless
-- UnitShouldDisplayName says so, and that follows the same "NPC Names" / floating-name CVars
-- as the names above heads. With those off (hideFloatingNames) the plates showed only a bare
-- health bar, and with them on the game drew floating names for every unit too far away to
-- have a plate. So the CVars stay off and we put the name back on the plates ourselves.
local function PlateName(frame)
    if not db or not db.enabled or not db.hideFloatingNames then return end
    if not frame or (frame.IsForbidden and frame:IsForbidden()) then return end
    local unit, name = frame.unit, frame.name
    if not name or type(unit) ~= "string" or not unit:match("^nameplate%d") then return end
    if UnitIsUnit(unit, "player") or name:IsShown() then return end
    name:SetText(GetUnitName(unit, true))
    if UnitIsTapDenied(unit) then
        name:SetVertexColor(0.5, 0.5, 0.5)
    else
        name:SetVertexColor(UnitSelectionColor(unit, true))
    end
    name:Show()
end
ns.PlateName = PlateName
if CompactUnitFrame_UpdateName then
    hooksecurefunc("CompactUnitFrame_UpdateName", PlateName)
end

local function AddPlate(unit)
    if UnitIsUnit(unit, "player") then return end -- personal resource display: leave alone
    -- Returns nil for plates Blizzard forbids to addons (friendly plates in instances).
    local plate = C_NamePlate.GetNamePlateForUnit(unit)
    if not plate or not plate.UnitFrame then return end
    local st = { plate = plate, frame = plate.UnitFrame, cur = 0, want = 0, stareTime = 0, lingerUntil = 0 }
    plates[unit] = st
    st.want = Wanted(unit, st, GetTime())
    st.cur = db.enabled and st.want or 1
    st.frame:SetAlpha(st.cur)
    PlateName(st.frame)
end

local function RemovePlate(unit)
    local st = plates[unit]
    if st and st.frame then st.frame:SetAlpha(1) end
    plates[unit] = nil
end

function ns.RefreshAll()
    local now = GetTime()
    for unit, st in pairs(plates) do
        st.want = Wanted(unit, st, now)
        if not db.enabled then
            st.cur = 1
            st.frame:SetAlpha(1)
        end
        PlateName(st.frame)
    end
end

local driver = CreateFrame("Frame")
driver:SetScript("OnUpdate", function(_, elapsed)
    if not db then return end
    local now = GetTime()
    sinceTick = sinceTick + elapsed
    local tick = sinceTick >= TICK
    if tick then
        UpdateStare(now, sinceTick)
        for unit, st in pairs(plates) do
            st.want = Wanted(unit, st, now)
        end
        sinceTick = 0
    end
    if not db.enabled then return end
    local step = (db.fadeTime > 0) and (elapsed / db.fadeTime) or 1
    for _, st in pairs(plates) do
        if st.cur < st.want then
            st.cur = math.min(st.want, st.cur + step)
        elseif st.cur > st.want then
            st.cur = math.max(st.want, st.cur - step)
        end
        -- Re-applied every frame in case Blizzard's own nameplate code resets it.
        if st.frame:GetAlpha() ~= st.cur then st.frame:SetAlpha(st.cur) end
    end
end)

-- ---------------------------------------------------------------------------
-- Events
-- ---------------------------------------------------------------------------
driver:RegisterEvent("ADDON_LOADED")
driver:RegisterEvent("PLAYER_LOGIN")
driver:RegisterEvent("PLAYER_ENTERING_WORLD")
driver:RegisterEvent("NAME_PLATE_UNIT_ADDED")
driver:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
driver:RegisterEvent("PLAYER_TARGET_CHANGED")
driver:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
driver:RegisterEvent("PLAYER_REGEN_ENABLED")
driver:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON then
        ZRProximityDB = ZRProximityDB or {}
        db = ZRProximityDB
        for k, v in pairs(DEFAULTS) do
            if db[k] == nil then db[k] = v end
        end
        ns.db = db
    elseif event == "PLAYER_LOGIN" then
        ns.RequestRangeItems()
        if ns.CreateOptions then ns.CreateOptions() end
    elseif event == "PLAYER_ENTERING_WORLD" then
        ns.ApplyCVars()
    elseif event == "NAME_PLATE_UNIT_ADDED" then
        AddPlate(arg1)
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        RemovePlate(arg1)
    elseif event == "PLAYER_TARGET_CHANGED" or event == "UPDATE_MOUSEOVER_UNIT" then
        ns.RefreshAll()
    elseif event == "PLAYER_REGEN_ENABLED" then
        if pendingCVars then ns.ApplyCVars() end
    end
end)

-- ---------------------------------------------------------------------------
-- Slash commands
-- ---------------------------------------------------------------------------
-- /zrp look: shows the look column for 10 seconds and prints where each plate sits.
local guide
function ns.LookDebug()
    if not guide then
        guide = CreateFrame("Frame", nil, UIParent)
        guide:SetFrameStrata("BACKGROUND")
        local t = guide:CreateTexture(nil, "BACKGROUND")
        t:SetAllPoints()
        t:SetColorTexture(0.2, 1, 0.6, 0.12)
    end
    local h = UIParent:GetHeight()
    guide:ClearAllPoints()
    guide:SetPoint("BOTTOM", UIParent, "CENTER", 0, -db.stareRadius)
    guide:SetSize(db.stareRadius * 2, db.stareRadius + h * 0.4)
    guide:Show()
    C_Timer.After(10, function() guide:Hide() end)
    local n = 0
    for unit, st in pairs(plates) do
        local dx, dy = ScreenOffset(st.plate)
        if dx and math.abs(dx) < 400 then
            n = n + 1
            Print(("%s: %+d across, %+d up, in look area %s, within %d yd %s."):format(
                UnitName(unit) or unit, math.floor(dx + 0.5), math.floor(dy + 0.5), LookScore(dx, dy) and "yes" or "no",
                db.stareRange, tostring(ns.IsWithin(unit, db.stareRange))))
        end
    end
    Print(("look area shown for 10 s; %d plates near the middle."):format(n))
end

SLASH_ZRPROXIMITY1 = "/zrp"
SLASH_ZRPROXIMITY2 = "/zrproximity"
SlashCmdList.ZRPROXIMITY = function(msg)
    msg = (msg or ""):lower():match("^%s*(.-)%s*$")
    if msg == "on" or msg == "off" then
        db.enabled = (msg == "on")
        ns.ApplyCVars()
        ns.RefreshAll()
        Print(db.enabled and "on." or "off: every nameplate shows normally.")
    elseif msg == "range" then
        ns.PrintRangeDebug()
    elseif msg == "look" then
        ns.LookDebug()
    elseif msg == "status" then
        local n = 0
        for _ in pairs(plates) do n = n + 1 end
        Print(("%s, %d plates tracked. Hostile %d yd, neutral %d yd, friendly %d yd. Stare %s."):format(
            db.enabled and "on" or "off", n, db.hostileRange, db.neutralRange, db.friendlyRange,
            db.stare and "on" or "off"))
        if UnitExists("target") then
            Print(("Target %s is %s; within its %d yd: %s."):format(UnitName("target") or "?",
                UnitKind("target"), RangeFor(UnitKind("target")),
                tostring(ns.IsWithin("target", RangeFor(UnitKind("target"))))))
        end
    elseif msg == "reset" then
        for k, v in pairs(DEFAULTS) do db[k] = v end
        ns.ApplyCVars()
        ns.RefreshAll()
        if ns.RefreshOptions then ns.RefreshOptions() end
        Print("settings reset to defaults.")
    else
        if ns.OpenOptions then ns.OpenOptions() end
        Print("/zrp on | off | status | range | look | reset")
    end
end
