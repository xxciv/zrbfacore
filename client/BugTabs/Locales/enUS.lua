local _, AddonNamespace = ...

AddonNamespace.L = AddonNamespace.L or {}
local L = AddonNamespace.L

-- English (Default fallback)
L["LOADED_DB"] = "Loaded DB."
L["READY_CATCH"] = "Ready to catch errors."
L["CAPTURE_ACTIVE"] = "Error capture active (Default UI suppressed)."
L["CUSTOM_FONT_RELOAD"] = "Custom Code Font setting changed. Reload UI to apply."

-- UI Texts
L["TITLE"] = "BUGTABS"
L["MENU_FILE"] = "File"
L["MENU_EDIT"] = "Edit"
L["MENU_OPTIONS"] = "Options"

L["OPTION_SAVE_HISTORY"] = "Save History"
L["OPTION_SELECT_ALL"] = "Select All"
L["OPTION_CLEAR_TAB"] = "Clear Tab"
L["OPTION_CLOSE_WINDOW"] = "Close Window"

L["OPTION_ENABLE_BANNER"] = "Enable Banner"
L["OPTION_ENABLE_SOUND"] = "Enable Sound"
L["OPTION_ENABLE_FONT"] = "Use Custom Font"

L["SOUND_RAID_WARNING"] = "Sound: Raid Warning"
L["SOUND_DING"] = "Sound: Ding"
L["SOUND_EXPLOSION"] = "Sound: Explosion"
L["SOUND_LEVEL_UP"] = "Sound: Level Up"

L["HISTORY_PREFIX"] = "[HISTORY %s]"
L["NO_ERRORS"] = "No errors for %s"
L["UNKNOWN_ADDON"] = "Unknown"
L["MINIMAP_TOOLTIP1"] = "BugTabs"
L["MINIMAP_TOOLTIP_LCLICK"] = "|cFF00FF00Left-Click|r to open BugTabs"
L["MINIMAP_TOOLTIP_SLCLICK"] = "|cFF00FF00Shift + Left-Click|r to clear session errors"
L["MINIMAP_TOOLTIP_RCLICK"] = "|cFF00FF00Right-Click|r to toggle History saving"
L["MINIMAP_ERRORS_COUNT"] = "Current Errors: |cFFFFD100%d|r"
L["COMBAT_ERRORS_PENDING"] = "Errors occurred during combat."
L["HISTORY_ENABLED_MSG"] = "History saving: |cFF00FF00Enabled|r"
L["HISTORY_DISABLED_MSG"] = "History saving: |cFFFF0000Disabled|r"
L["SESSION_CLEARED_MSG"] = "Session errors cleared."
L["VERSION_AVAILABLE"] = "A new version is available (%s)!"
L["DOWNLOAD_UPDATE"] = "Download the update on CurseForge."
L["SIDEBAR_ADDONS"] = "ADDONS"
L["SEVERITY_ERROR"] = "Error"
L["SEVERITY_WARNING"] = "Warning"
L["ACTION_COPY"] = "Copy all"
L["ACTION_CLEAR"] = "Clear tab"
L["STACK_TRACE"] = "Stack trace"
L["SETTINGS_TITLE"] = "Settings"
L["OPTION_ENABLE_TOAST"] = "Enable toast"
L["OPTION_SHOW_MINIMAP"] = "Show minimap button"
L["MENU_SOUND"] = "Sound"
L["ERRORS_COUNT"] = "%d errors"

-- Locals capture (v1.4.6)
L["OPTION_CAPTURE_LOCALS"] = "Capture local variables"
L["LOCALS_HEADER"] = "Local variables"
