-- ZRProximity (BFA 8.3.7 client addon)
-- Keeps Blizzard's nameplates on but invisible, and fades a plate in only when:
--   * it is your target or under the mouse,
--   * the unit is fighting you,
--   * the unit is within the distance set for its type (hostile / neutral / friendly),
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

-- (A "look at it" reveal was tried in 1.0-1.5 and removed: on 8.3.7 nameplates are restricted
-- regions, so GetCenter on a plate, its UnitFrame, healthBar or name fails with "Can't measure
-- restricted regions" and an addon can't tell which plate is in the middle of the screen.)
local function Wanted(unit, st, now)
    if not db.enabled then return 1 end
    if UnitNameplateShowsWidgetsOnly and UnitNameplateShowsWidgetsOnly(unit) then return 1 end
    if db.showTarget and UnitIsUnit(unit, "target") then return 1 end
    if db.showMouseover and UnitIsUnit(unit, "mouseover") then return 1 end
    if db.showCombat and UnitThreatSituation("player", unit) ~= nil then return 1 end
    if ns.IsWithin(unit, RangeFor(UnitKind(unit))) then return 1 end
    return 0
end

-- ---------------------------------------------------------------------------
-- Plate bookkeeping
-- ---------------------------------------------------------------------------
-- Plate names. On 8.3.7 Blizzard's CompactUnitFrame_UpdateName hides a plate's name unless
-- UnitShouldDisplayName says so, and that follows the same "NPC Names" / floating-name CVars
-- as the names above heads. With those off (hideFloatingNames) the plates showed only a bare
-- health bar, and with them on the game drew floating names for every unit too far away to
-- have a plate. So the CVars stay off and we put the name back on the plates ourselves. This
-- runs whenever the addon is on, even with hideFloatingNames unticked, because the game's
-- NPC Names option may be on "None" anyway.
local nameStats = { hooked = 0, shown = 0 }
local function PlateName(frame)
    if not db or not db.enabled then return end
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
    nameStats.shown = nameStats.shown + 1
end
ns.PlateName = PlateName
if CompactUnitFrame_UpdateName then
    hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
        nameStats.hooked = nameStats.hooked + 1
        PlateName(frame)
    end)
end

-- /zrp names: what each plate's name looks like right now (for when names go missing).
function ns.NameDebug()
    Print(("name hook %s, called %d times, names put back %d times. Hide names above heads: %s."):format(
        CompactUnitFrame_UpdateName and "installed" or "MISSING", nameStats.hooked, nameStats.shown,
        db.hideFloatingNames and "on" or "off"))
    local n = 0
    for unit, st in pairs(plates) do
        if n >= 6 then break end
        n = n + 1
        local f, name = st.frame, st.frame.name
        if not name then
            Print(("%s %s: plate has no name field (%s)."):format(unit, UnitName(unit) or "?",
                tostring(f:GetName())))
        else
            local font, size = name:GetFont()
            Print(("%s %s: shown %s, visible %s, text '%s', alpha %.2f, plate alpha %.2f, size %s, unit %s."):format(
                unit, UnitName(unit) or "?", tostring(name:IsShown()), tostring(name:IsVisible()),
                tostring(name:GetText()), name:GetAlpha(), f:GetAlpha(), tostring(size), tostring(f.unit)))
        end
    end
    if n == 0 then Print("no plates tracked right now; stand near some units.") end
end

local function AddPlate(unit)
    if UnitIsUnit(unit, "player") then return end -- personal resource display: leave alone
    -- Returns nil for plates Blizzard forbids to addons (friendly plates in instances).
    local plate = C_NamePlate.GetNamePlateForUnit(unit)
    if not plate or not plate.UnitFrame then return end
    local st = { plate = plate, frame = plate.UnitFrame, cur = 0, want = 0 }
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
        for unit, st in pairs(plates) do
            st.want = Wanted(unit, st, now)
            -- Also catches names hidden by Blizzard code that doesn't go through the hook.
            if st.want > 0 then PlateName(st.frame) end
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
        for _, k in ipairs({ "stare", "stareRadius", "stareDelay", "stareLinger", "stareRange" }) do
            db[k] = nil -- the removed "look at" settings
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
    elseif msg == "names" then
        ns.NameDebug()
    elseif msg == "status" then
        local n = 0
        for _ in pairs(plates) do n = n + 1 end
        Print(("%s, %d plates tracked. Hostile %d yd, neutral %d yd, friendly %d yd."):format(
            db.enabled and "on" or "off", n, db.hostileRange, db.neutralRange, db.friendlyRange))
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
        Print("/zrp on | off | status | range | names | reset")
    end
end
