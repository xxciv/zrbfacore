local _, AddonNamespace = ...
local L = AddonNamespace.L

AddonNamespace.Broker = {}
local Broker = AddonNamespace.Broker

local ICON = "Interface\\Icons\\INV_Misc_Head_Dragon_01"
local dataObj  -- l'objet LDB, créé une seule fois dans Init

-- Étiquette "BugTabs: N" — N en rouge (Theme.error) si erreurs, gris atténué (Theme.textDim) sinon.
local function LabelText(total)
    local Theme = AddonNamespace.Theme
    local hex = Theme:Hex((total > 0) and Theme.error or Theme.textDim)
    return "BugTabs: |cff" .. hex .. total .. "|r"
end

function Broker:Init()
    if dataObj then return end
    local LDB = LibStub and LibStub("LibDataBroker-1.1", true)
    if not LDB then return end

    dataObj = LDB:NewDataObject("BugTabs", {
        type  = "data source",
        label = "BugTabs",
        icon  = ICON,
        text  = LabelText(0),

        OnClick = function(_, button)
            local UI = AddonNamespace.UI
            if not UI then return end
            if button == "RightButton" then
                BugTabsDB.settings.saveHistory = not BugTabsDB.settings.saveHistory
                if BugTabsDB.settings.saveHistory then
                    print("|cFF00FF00BugTabs|r: " .. (L["HISTORY_ENABLED_MSG"] or "History on"))
                else
                    print("|cFF00FF00BugTabs|r: " .. (L["HISTORY_DISABLED_MSG"] or "History off"))
                end
            elseif IsShiftKeyDown() then
                AddonNamespace.sessionErrors = {}
                UI:UpdateUI()
                if AddonNamespace.MainFrame and AddonNamespace.MainFrame:IsShown() then
                    UI:ShowTab(L["UNKNOWN_ADDON"])
                end
                Broker:Update()
                print("|cFF00FF00BugTabs|r: " .. (L["SESSION_CLEARED_MSG"] or "Cleared"))
            else
                UI:Toggle()
            end
        end,

        OnTooltipShow = function(tt)
            local total, list = AddonNamespace.GetSessionCounts()
            tt:AddLine(L["MINIMAP_TOOLTIP1"] or "BugTabs")
            tt:AddLine(string.format(L["MINIMAP_ERRORS_COUNT"] or "Errors: %d", total), 1, 1, 1)
            if #list > 0 then
                tt:AddLine(" ")
                for _, item in ipairs(list) do
                    tt:AddDoubleLine(AddonNamespace.Truncate(item.addon, 24), tostring(item.count),
                        0.9, 0.9, 0.9, 1, 1, 1)
                end
            end
            tt:AddLine(" ")
            tt:AddLine(L["MINIMAP_TOOLTIP_LCLICK"] or "Left-Click to open", 1, 1, 1)
            tt:AddLine(L["MINIMAP_TOOLTIP_SLCLICK"] or "Shift+Left-Click to clear", 1, 1, 1)
            tt:AddLine(L["MINIMAP_TOOLTIP_RCLICK"] or "Right-Click to toggle history", 1, 1, 1)
        end,
    })
end

-- Rafraîchit l'étiquette depuis les compteurs courants.
function Broker:Update()
    if not dataObj then return end
    local total = AddonNamespace.GetSessionCounts()
    dataObj.text = LabelText(total)
end
