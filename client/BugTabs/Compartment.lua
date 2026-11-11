local _, AddonNamespace = ...
local L = AddonNamespace.L

-- Add-On Compartment (menu d'addons à côté de la minimap, Dragonflight+).
-- Déclaré via le .toc (## AddonCompartmentFunc...) : les clients sans
-- compartiment ignorent ces directives, donc sans effet en Classic.
-- Les clics reproduisent exactement le bouton minimap et le Broker.

function BugTabs_OnAddonCompartmentClick(_, buttonName)
    local UI = AddonNamespace.UI
    if not UI then return end
    if buttonName == "RightButton" then
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
        if AddonNamespace.Broker then AddonNamespace.Broker:Update() end
        print("|cFF00FF00BugTabs|r: " .. (L["SESSION_CLEARED_MSG"] or "Cleared"))
    else
        UI:Toggle()
    end
end

function BugTabs_OnAddonCompartmentEnter(_, menuButton)
    GameTooltip:SetOwner(menuButton, "ANCHOR_LEFT")
    local total, list = AddonNamespace.GetSessionCounts()
    GameTooltip:SetText(L["MINIMAP_TOOLTIP1"] or "BugTabs")
    GameTooltip:AddLine(string.format(L["MINIMAP_ERRORS_COUNT"] or "Errors: %d", total), 1, 1, 1)
    if #list > 0 then
        GameTooltip:AddLine(" ")
        for _, item in ipairs(list) do
            GameTooltip:AddDoubleLine(AddonNamespace.Truncate(item.addon, 24), tostring(item.count),
                0.9, 0.9, 0.9, 1, 1, 1)
        end
    end
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(L["MINIMAP_TOOLTIP_LCLICK"] or "Left-Click to open", 1, 1, 1)
    GameTooltip:AddLine(L["MINIMAP_TOOLTIP_SLCLICK"] or "Shift+Left-Click to clear", 1, 1, 1)
    GameTooltip:AddLine(L["MINIMAP_TOOLTIP_RCLICK"] or "Right-Click to toggle history", 1, 1, 1)
    GameTooltip:Show()
end

function BugTabs_OnAddonCompartmentLeave()
    GameTooltip:Hide()
end
