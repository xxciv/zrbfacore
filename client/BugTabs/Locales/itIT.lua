local _, AddonNamespace = ...

if GetLocale() ~= "itIT" then return end

local L = AddonNamespace.L

-- Italian Translations
L["LOADED_DB"] = "Database caricato."
L["READY_CATCH"] = "Pronto a catturare gli errori."
L["CAPTURE_ACTIVE"] = "Cattura degli errori attiva (UI predefinita soppressa)."
L["CUSTOM_FONT_RELOAD"] = "Font personalizzato modificato. Ricarica la UI (/reload) per applicare."

-- UI Texts
L["TITLE"] = "BUGTABS"
L["MENU_FILE"] = "File"
L["MENU_EDIT"] = "Modifica"
L["MENU_OPTIONS"] = "Opzioni"

L["OPTION_SAVE_HISTORY"] = "Salva Cronologia"
L["OPTION_SELECT_ALL"] = "Seleziona Tutto"
L["OPTION_CLEAR_TAB"] = "Svuota Tab"
L["OPTION_CLOSE_WINDOW"] = "Chiudi Finestra"

L["OPTION_ENABLE_BANNER"] = "Attiva Banner"
L["OPTION_ENABLE_SOUND"] = "Attiva Suono"
L["OPTION_ENABLE_FONT"] = "Font Personalizzato"

L["SOUND_RAID_WARNING"] = "Suono: Avviso Raid"
L["SOUND_DING"] = "Suono: Ding"
L["SOUND_EXPLOSION"] = "Suono: Esplosione"
L["SOUND_LEVEL_UP"] = "Suono: Salita di Livello"

L["HISTORY_PREFIX"] = "[CRONOLOGIA %s]"
L["NO_ERRORS"] = "Nessun errore per %s"
L["UNKNOWN_ADDON"] = "Sconosciuto"
L["MINIMAP_TOOLTIP1"] = "BugTabs"
L["MINIMAP_TOOLTIP_LCLICK"] = "|cFF00FF00Clic sinistro|r per aprire BugTabs"
L["MINIMAP_TOOLTIP_SLCLICK"] = "|cFF00FF00Maiusc + Clic sinistro|r per svuotare gli errori di sessione"
L["MINIMAP_TOOLTIP_RCLICK"] = "|cFF00FF00Clic destro|r per attivare/disattivare il salvataggio della cronologia"
L["MINIMAP_ERRORS_COUNT"] = "Errori attuali: |cFFFFD100%d|r"
L["COMBAT_ERRORS_PENDING"] = "Si sono verificati errori durante il combattimento."
L["HISTORY_ENABLED_MSG"] = "Cronologia: |cFF00FF00Attivata|r"
L["HISTORY_DISABLED_MSG"] = "Cronologia: |cFFFF0000Disattivata|r"
L["SESSION_CLEARED_MSG"] = "Errori di sessione cancellati."
L["VERSION_AVAILABLE"] = "È disponibile una nuova versione (%s)!"
L["DOWNLOAD_UPDATE"] = "Scarica l'aggiornamento su CurseForge."
L["SIDEBAR_ADDONS"] = "ADDONS"
L["SEVERITY_ERROR"] = "Errore"
L["SEVERITY_WARNING"] = "Avviso"
L["ACTION_COPY"] = "Copia tutto"
L["ACTION_CLEAR"] = "Svuota scheda"
L["STACK_TRACE"] = "Stack trace"
L["SETTINGS_TITLE"] = "Impostazioni"
L["OPTION_ENABLE_TOAST"] = "Attiva toast"
L["OPTION_SHOW_MINIMAP"] = "Mostra pulsante minimappa"
L["MENU_SOUND"] = "Suono"
L["ERRORS_COUNT"] = "%d errori"

-- Locals capture (v1.4.6)
L["OPTION_CAPTURE_LOCALS"] = "Cattura variabili locali"
L["LOCALS_HEADER"] = "Variabili locali"
