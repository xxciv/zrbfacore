local _, AddonNamespace = ...

AddonNamespace.Config = {}
local Config = AddonNamespace.Config

local defaults = {
    settings = {
        saveHistory = false,
        showBanner = true,
        playSound = true,
        soundId = 8959, -- Raid Warning
        useCustomFont = false,
        showToast = true,
        showMinimap = true,
        captureLocals = true,
        windowWidth = 600,
        windowHeight = 480
    },
    history = {}
}

function Config:InitializeDB()
    if not BugTabsDB then
        BugTabsDB = CopyTable(defaults)
    end

    -- Validate structure
    BugTabsDB.settings = BugTabsDB.settings or {}
    if BugTabsDB.settings.saveHistory == nil then BugTabsDB.settings.saveHistory = defaults.settings.saveHistory end
    if BugTabsDB.settings.showBanner == nil then BugTabsDB.settings.showBanner = defaults.settings.showBanner end
    if BugTabsDB.settings.playSound == nil then BugTabsDB.settings.playSound = defaults.settings.playSound end
    if not BugTabsDB.settings.soundId then BugTabsDB.settings.soundId = defaults.settings.soundId end
    if BugTabsDB.settings.useCustomFont == nil then BugTabsDB.settings.useCustomFont = defaults.settings.useCustomFont end
    if BugTabsDB.settings.showToast == nil then BugTabsDB.settings.showToast = defaults.settings.showToast end
    if BugTabsDB.settings.showMinimap == nil then BugTabsDB.settings.showMinimap = defaults.settings.showMinimap end
    if BugTabsDB.settings.captureLocals == nil then BugTabsDB.settings.captureLocals = defaults.settings.captureLocals end
    if not BugTabsDB.settings.windowWidth then BugTabsDB.settings.windowWidth = defaults.settings.windowWidth end
    if not BugTabsDB.settings.windowHeight then BugTabsDB.settings.windowHeight = defaults.settings.windowHeight end
    if not BugTabsDB.history then BugTabsDB.history = {} end
end
