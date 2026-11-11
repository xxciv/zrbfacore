local _, AddonNamespace = ...
local L = AddonNamespace.L

-- Expose global only for standard external commands (if needed)
_G.BugTabs = AddonNamespace

-- Constants
AddonNamespace.MAX_HISTORY = 50
AddonNamespace.FONT_PATH = "Interface\\AddOns\\BugTabs\\BugTabs.ttf"
AddonNamespace.sessionErrors = {}
AddonNamespace.sessionErrorsHash = {}

-- Helpers
function AddonNamespace.GetBackdropTemplate()
    if BackdropTemplateMixin then return "BackdropTemplate" else return nil end
end

function AddonNamespace.tContains(table, item)
    if _G.tContains then return _G.tContains(table, item) end
    for _, value in ipairs(table) do
        if value == item then return true end
    end
    return false
end

function AddonNamespace.Truncate(text, length)
    if not text then return "" end
    if #text <= length then return text end
    return string.sub(text, 1, length) .. "..."
end

-- Convertit une valeur "secrète" (tainted) en chaîne propre.
-- WoW 10.x+ marque certains valeurs issues du code protégé comme "secret",
-- ce qui provoque des erreurs avec table.concat, l'arithmétique, etc.
-- tostring() crée une nouvelle chaîne C, supprimant le flag "secret".
function AddonNamespace.SanitizeString(s)
    if s == nil then return "" end
    return tostring(s)
end

-- Capture/reporter addons that appear in stacks but are never the culprit.
local STACK_IGNORE = {
    BugTabs = true,
    ["!BugGrabber"] = true,
    BugGrabber = true,
    BugSack = true,
}

local function IsBlizzardAddon(name)
    return type(name) == "string" and name:match("^Blizzard_") ~= nil
end

local function IsBlizzardPath(text)
    return text:find("Interface[\\/]+FrameXML")
        or text:find("Interface[\\/]+GlueXML")
        or text:find("Interface[\\/]+SharedXML")
        or text:find("Blizzard_FrameXML")
end

-- Scan message or stack. Returns partyName, blizzardLabel, ignoredCapturer.
local function ScanAddonRefs(text)
    if not text or text == "" then return nil, nil, nil end
    local party, blizzard, ignored = nil, nil, nil
    for name in text:gmatch("[Ii]nterface[\\/]+[Aa]dd[Oo]ns[\\/]+([^\\/]+)") do
        if STACK_IGNORE[name] then
            ignored = ignored or name
        elseif IsBlizzardAddon(name) then
            blizzard = blizzard or "Blizzard_UI"
        else
            party = party or name
            -- keep scanning? first party is enough
            break
        end
    end
    if not blizzard and IsBlizzardPath(text) then
        blizzard = "Blizzard_UI"
    end
    return party, blizzard, ignored
end

-- Drop LEADING frames that belong to the error capturer so the displayed stack
-- starts at the real fault. Keeps capturer frames if they are the entire stack
-- (genuine BugTabs error) or if they appear deeper (called into after the fault).
function AddonNamespace.CleanStack(stack)
    stack = AddonNamespace.SanitizeString(stack)
    if stack == "" then return "" end
    local out, n = {}, 0
    local pastLeader = false
    for line in stack:gmatch("([^\r\n]+)") do
        local addon = line:match("[Ii]nterface[\\/]+[Aa]dd[Oo]ns[\\/]+([^\\/]+)")
        if not pastLeader and addon and STACK_IGNORE[addon] then
            -- skip prologue frames from the error handler itself
        else
            pastLeader = true
            n = n + 1
            out[n] = line
        end
    end
    if n == 0 then return stack end
    local result = out[1]
    for i = 2, n do
        result = result .. "\n" .. out[i]
    end
    return result
end

-- msg may be just "bad argument #1 to '?' (...)" with no path — then stack is
-- the only source of truth. Ranking: third-party (msg then stack) > Blizzard
-- (msg then stack) > capturer-only (genuine BugTabs/BugGrabber bug).
function AddonNamespace.ParseAddonName(msg, stack)
    msg = msg and AddonNamespace.SanitizeString(msg) or nil
    stack = stack and AddonNamespace.SanitizeString(stack) or nil
    local p1, b1, i1 = ScanAddonRefs(msg)
    local p2, b2, i2 = ScanAddonRefs(stack)
    return p1 or p2 or b1 or b2 or i1 or i2 or L["UNKNOWN_ADDON"]
end

-- Formate la table brute de debuglocals() pour affichage : une ligne par
-- locale "name = value", valeurs tronquées, tables résumées. Signature
-- BugTabs — pas de dépendance au formatage d'un addon tiers.
function AddonNamespace.FormatLocals(raw)
    if not raw or raw == "" then return nil end
    raw = AddonNamespace.SanitizeString(raw)
    local out, n = {}, 0
    for line in raw:gmatch("([^\r\n]+)") do
        local name, value = line:match("^%s*([%a_][%w_]*)%s*=%s*(.+)$")
        if name then
            value = AddonNamespace.SanitizeString(value)
            -- résume les tables volumineuses, tronque les valeurs longues
            if #value > 120 then value = value:sub(1, 117) .. "..." end
            n = n + 1
            out[n] = name .. " = " .. value
            if n >= 20 then out[n + 1] = "..."; break end
        end
    end
    if n == 0 then return nil end
    local result = out[1]
    for i = 2, n do result = result .. "\n" .. out[i] end
    return result
end

-- Compteurs de la session courante (historique exclu).
-- Renvoie : total (number), liste { {addon=, count=}, ... } triée par count décroissant.
function AddonNamespace.GetSessionCounts()
    local list, total = {}, 0
    for addon, errs in pairs(AddonNamespace.sessionErrors) do
        local c = 0
        for _, e in ipairs(errs) do c = c + (e.count or 1) end
        if c > 0 then
            list[#list + 1] = { addon = addon, count = c }
            total = total + c
        end
    end
    table.sort(list, function(a, b) return a.count > b.count end)
    return total, list
end
