local _, AddonNamespace = ...

if GetLocale() ~= "deDE" then return end

local L = AddonNamespace.L

-- German Translations
L["LOADED_DB"] = "Datenbank geladen."
L["READY_CATCH"] = "Bereit, Fehler abzufangen."
L["CAPTURE_ACTIVE"] = "Fehlererfassung aktiv (Standard-UI unterdrückt)."
L["CUSTOM_FONT_RELOAD"] = "Benutzerdefinierte Schrift geändert. UI neu laden (/reload) zum Anwenden."

-- UI Texts
L["TITLE"] = "BUGTABS"
L["MENU_FILE"] = "Datei"
L["MENU_EDIT"] = "Bearbeiten"
L["MENU_OPTIONS"] = "Optionen"

L["OPTION_SAVE_HISTORY"] = "Verlauf speichern"
L["OPTION_SELECT_ALL"] = "Alles auswählen"
L["OPTION_CLEAR_TAB"] = "Tab leeren"
L["OPTION_CLOSE_WINDOW"] = "Fenster schließen"

L["OPTION_ENABLE_BANNER"] = "Banner aktivieren"
L["OPTION_ENABLE_SOUND"] = "Sound aktivieren"
L["OPTION_ENABLE_FONT"] = "Benutzerschrift nutzen"

L["SOUND_RAID_WARNING"] = "Sound: Raid-Warnung"
L["SOUND_DING"] = "Sound: Ding"
L["SOUND_EXPLOSION"] = "Sound: Explosion"
L["SOUND_LEVEL_UP"] = "Sound: Levelaufstieg"

L["HISTORY_PREFIX"] = "[VERLAUF %s]"
L["NO_ERRORS"] = "Keine Fehler für %s"
L["UNKNOWN_ADDON"] = "Unbekannt"
L["MINIMAP_TOOLTIP1"] = "BugTabs"
L["MINIMAP_TOOLTIP_LCLICK"] = "|cFF00FF00Linksklick|r zum Öffnen von BugTabs"
L["MINIMAP_TOOLTIP_SLCLICK"] = "|cFF00FF00Umschalt + Linksklick|r um Sitzungsfehler zu leeren"
L["MINIMAP_TOOLTIP_RCLICK"] = "|cFF00FF00Rechtsklick|r um Verlaufsspeicherung umschalten"
L["MINIMAP_ERRORS_COUNT"] = "Aktuelle Fehler: |cFFFFD100%d|r"
L["COMBAT_ERRORS_PENDING"] = "Fehler sind während des Kampfes aufgetreten."
L["HISTORY_ENABLED_MSG"] = "Verlauf: |cFF00FF00Aktiviert|r"
L["HISTORY_DISABLED_MSG"] = "Verlauf: |cFFFF0000Deaktiviert|r"
L["SESSION_CLEARED_MSG"] = "Sitzungsfehler geleert."
L["VERSION_AVAILABLE"] = "Eine neue Version ist verfügbar (%s)!"
L["DOWNLOAD_UPDATE"] = "Lade das Update auf CurseForge herunter."
L["SIDEBAR_ADDONS"] = "ADDONS"
L["SEVERITY_ERROR"] = "Fehler"
L["SEVERITY_WARNING"] = "Warnung"
L["ACTION_COPY"] = "Alles kopieren"
L["ACTION_CLEAR"] = "Tab leeren"
L["STACK_TRACE"] = "Stacktrace"
L["SETTINGS_TITLE"] = "Einstellungen"
L["OPTION_ENABLE_TOAST"] = "Toast aktivieren"
L["OPTION_SHOW_MINIMAP"] = "Minikarten-Button anzeigen"
L["MENU_SOUND"] = "Ton"
L["ERRORS_COUNT"] = "%d Fehler"

-- Locals capture (v1.4.6)
L["OPTION_CAPTURE_LOCALS"] = "Lokale Variablen erfassen"
L["LOCALS_HEADER"] = "Lokale Variablen"
