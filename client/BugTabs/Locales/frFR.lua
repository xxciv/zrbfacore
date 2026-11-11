local _, AddonNamespace = ...

if GetLocale() ~= "frFR" then return end

local L = AddonNamespace.L

-- French Translations
L["LOADED_DB"] = "Base de données chargée."
L["READY_CATCH"] = "Prêt à intercepter les erreurs."
L["CAPTURE_ACTIVE"] = "Interception des erreurs active (Interface par défaut masquée)."
L["CUSTOM_FONT_RELOAD"] = "Police personnalisée modifiée. Rechargez l'interface (/reload) pour appliquer."

-- UI Texts
L["TITLE"] = "BUGTABS"
L["MENU_FILE"] = "Fichier"
L["MENU_EDIT"] = "Éditer"
L["MENU_OPTIONS"] = "Options"

L["OPTION_SAVE_HISTORY"] = "Sauvegarder l'Historique"
L["OPTION_SELECT_ALL"] = "Tout Sélectionner"
L["OPTION_CLEAR_TAB"] = "Vider l'Onglet"
L["OPTION_CLOSE_WINDOW"] = "Fermer la Fenêtre"

L["OPTION_ENABLE_BANNER"] = "Activer la Bannière"
L["OPTION_ENABLE_SOUND"] = "Activer le Son"
L["OPTION_ENABLE_FONT"] = "Police Personnalisée"

L["SOUND_RAID_WARNING"] = "Son : Avertissement de Raid"
L["SOUND_DING"] = "Son : Ding"
L["SOUND_EXPLOSION"] = "Son : Explosion"
L["SOUND_LEVEL_UP"] = "Son : Niveau Supérieur"

L["HISTORY_PREFIX"] = "[HISTORIQUE %s]"
L["NO_ERRORS"] = "Aucune erreur pour %s"
L["UNKNOWN_ADDON"] = "Inconnu"
L["MINIMAP_TOOLTIP1"] = "BugTabs"
L["MINIMAP_TOOLTIP_LCLICK"] = "|cFF00FF00Clic-Gauche|r pour ouvrir BugTabs"
L["MINIMAP_TOOLTIP_SLCLICK"] = "|cFF00FF00Maj + Clic-Gauche|r pour vider les erreurs"
L["MINIMAP_TOOLTIP_RCLICK"] = "|cFF00FF00Clic-Droit|r pour basculer la sauvegarde"
L["MINIMAP_ERRORS_COUNT"] = "Erreurs actuelles : |cFFFFD100%d|r"
L["COMBAT_ERRORS_PENDING"] = "Des erreurs sont survenues pendant le combat."
L["HISTORY_ENABLED_MSG"] = "Historique : |cFF00FF00Activé|r"
L["HISTORY_DISABLED_MSG"] = "Historique : |cFFFF0000Désactivé|r"
L["SESSION_CLEARED_MSG"] = "Erreurs de la session effacées."
L["VERSION_AVAILABLE"] = "Une nouvelle version est disponible (%s) !"
L["DOWNLOAD_UPDATE"] = "Téléchargez la mise à jour sur CurseForge."
L["SIDEBAR_ADDONS"] = "ADDONS"
L["SEVERITY_ERROR"] = "Erreur"
L["SEVERITY_WARNING"] = "Avertissement"
L["ACTION_COPY"] = "Tout copier"
L["ACTION_CLEAR"] = "Vider l'onglet"
L["STACK_TRACE"] = "Stack trace"
L["SETTINGS_TITLE"] = "Réglages"
L["OPTION_ENABLE_TOAST"] = "Activer le toast"
L["OPTION_SHOW_MINIMAP"] = "Afficher le bouton minicarte"
L["MENU_SOUND"] = "Son"
L["ERRORS_COUNT"] = "%d erreurs"

-- Locals capture (v1.4.6)
L["OPTION_CAPTURE_LOCALS"] = "Capturer les variables locales"
L["LOCALS_HEADER"] = "Variables locales"
