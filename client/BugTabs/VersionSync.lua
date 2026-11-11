local AddonName, AddonNamespace = ...
local L = AddonNamespace.L

local VersionSync = CreateFrame("Frame")

-- Auto-generate prefix generically based on Addon Name
local PREFIX = string.upper(AddonName) .. "_VERSYNC"

-- Compatible GetAddOnMetadata : TBC uses global, Retail uses C_AddOns namespace
local _GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
local CURRENT_VERSION = (_GetAddOnMetadata and _GetAddOnMetadata(AddonName, "Version")) or "1.0.0"

-- Compatible Chat API : modern clients (Retail + recent Classic) moved
-- SendAddonMessage / RegisterAddonMessagePrefix into the C_ChatInfo namespace
-- and removed the globals ; older clients (TBC 2.5.x) still expose the globals.
local _SendAddonMessage = (C_ChatInfo and C_ChatInfo.SendAddonMessage) or SendAddonMessage
local _RegisterAddonMessagePrefix = (C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix) or RegisterAddonMessagePrefix

local updateAnnounced = false

local function ParseVersion(verStr)
    if not verStr then return { 0, 0, 0 } end
    local major, minor, patch = verStr:match("(%d+)%.(%d+)%.(%d+)")
    if not major then
        major, minor = verStr:match("(%d+)%.(%d+)")
        patch = 0
    end
    return { tonumber(major) or 0, tonumber(minor) or 0, tonumber(patch) or 0 }
end

local function IsNewerVersion(receivedVer, currentVer)
    local v1 = ParseVersion(receivedVer)
    local v2 = ParseVersion(currentVer)

    for i = 1, 3 do
        if v1[i] > v2[i] then return true end
        if v1[i] < v2[i] then return false end
    end
    return false
end

-- Cross-version group detection:
--   TBC Classic  : GetNumRaidMembers() / GetNumPartyMembers()
--   Wrath/Retail : IsInRaid() / IsInGroup()
local function IsInRaidCompat()
    if IsInRaid then return IsInRaid() end
    return (GetNumRaidMembers and GetNumRaidMembers() > 0) or false
end

local function IsInPartyCompat()
    if IsInGroup then return IsInGroup() and not IsInRaidCompat() end
    return (GetNumPartyMembers and GetNumPartyMembers() > 0) or false
end

local function BroadcastVersion()
    if IsInGuild() then
        _SendAddonMessage(PREFIX, "VERSION " .. CURRENT_VERSION, "GUILD")
    end
    if IsInRaidCompat() then
        _SendAddonMessage(PREFIX, "VERSION " .. CURRENT_VERSION, "RAID")
    elseif IsInPartyCompat() then
        _SendAddonMessage(PREFIX, "VERSION " .. CURRENT_VERSION, "PARTY")
    end
end

-- RegisterAddonMessagePrefix is required in Wrath+ and Retail to receive CHAT_MSG_ADDON.
-- In TBC Classic it's a no-op (optional), so calling it unconditionally is safe.
if _RegisterAddonMessagePrefix then
    _RegisterAddonMessagePrefix(PREFIX)
end

VersionSync:RegisterEvent("CHAT_MSG_ADDON")
VersionSync:RegisterEvent("PLAYER_ENTERING_WORLD")
-- GROUP_ROSTER_UPDATE (Wrath+/Retail) a remplacé PARTY_MEMBERS_CHANGED
-- (Vanilla/TBC) ; enregistrer un événement inconnu du client lève une
-- erreur Lua au chargement.
if not pcall(VersionSync.RegisterEvent, VersionSync, "GROUP_ROSTER_UPDATE") then
    pcall(VersionSync.RegisterEvent, VersionSync, "PARTY_MEMBERS_CHANGED")
end
VersionSync:RegisterEvent("GUILD_ROSTER_UPDATE")

VersionSync:SetScript("OnEvent", function(_, event, prefix, msg, _, sender)
    if event == "CHAT_MSG_ADDON" then
        if prefix == PREFIX and sender ~= UnitName("player") then
            local cmd, remoteVersion = msg:match("^(%S+)%s*(.*)$")
            if cmd == "VERSION" and remoteVersion then
                if not updateAnnounced and IsNewerVersion(remoteVersion, CURRENT_VERSION) then
                    updateAnnounced = true
                    print(string.format("|cFF00FFFF[%s]|r |cFF00FF00" .. L["VERSION_AVAILABLE"] .. "|r",
                        AddonName, remoteVersion))
                    print(string.format("|cFF00FFFF[%s]|r |cFFDDDDDD" .. L["DOWNLOAD_UPDATE"] .. "|r",
                        AddonName))
                end
            end
        end
    else
        -- Triggered on login, party change, or guild update
        BroadcastVersion()
    end
end)
