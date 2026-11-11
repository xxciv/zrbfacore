local _, AddonNamespace = ...

if GetLocale() ~= "esES" and GetLocale() ~= "esMX" then return end

local L = AddonNamespace.L

-- Spanish Translations (esES + esMX)
L["LOADED_DB"] = "Base de datos cargada."
L["READY_CATCH"] = "Listo para capturar errores."
L["CAPTURE_ACTIVE"] = "Captura de errores activa (UI predeterminada suprimida)."
L["CUSTOM_FONT_RELOAD"] = "Fuente personalizada cambiada. Recarga la UI (/reload) para aplicar."

-- UI Texts
L["TITLE"] = "BUGTABS"
L["MENU_FILE"] = "Archivo"
L["MENU_EDIT"] = "Editar"
L["MENU_OPTIONS"] = "Opciones"

L["OPTION_SAVE_HISTORY"] = "Guardar Historial"
L["OPTION_SELECT_ALL"] = "Seleccionar Todo"
L["OPTION_CLEAR_TAB"] = "Limpiar Pestaña"
L["OPTION_CLOSE_WINDOW"] = "Cerrar Ventana"

L["OPTION_ENABLE_BANNER"] = "Activar Banner"
L["OPTION_ENABLE_SOUND"] = "Activar Sonido"
L["OPTION_ENABLE_FONT"] = "Fuente Personalizada"

L["SOUND_RAID_WARNING"] = "Sonido: Aviso de Banda"
L["SOUND_DING"] = "Sonido: Ding"
L["SOUND_EXPLOSION"] = "Sonido: Explosión"
L["SOUND_LEVEL_UP"] = "Sonido: Subida de Nivel"

L["HISTORY_PREFIX"] = "[HISTORIAL %s]"
L["NO_ERRORS"] = "Sin errores para %s"
L["UNKNOWN_ADDON"] = "Desconocido"
L["MINIMAP_TOOLTIP1"] = "BugTabs"
L["MINIMAP_TOOLTIP_LCLICK"] = "|cFF00FF00Clic izquierdo|r para abrir BugTabs"
L["MINIMAP_TOOLTIP_SLCLICK"] = "|cFF00FF00Mayús + Clic izquierdo|r para limpiar errores de sesión"
L["MINIMAP_TOOLTIP_RCLICK"] = "|cFF00FF00Clic derecho|r para alternar guardado de historial"
L["MINIMAP_ERRORS_COUNT"] = "Errores actuales: |cFFFFD100%d|r"
L["COMBAT_ERRORS_PENDING"] = "Ocurrieron errores durante el combate."
L["HISTORY_ENABLED_MSG"] = "Historial: |cFF00FF00Activado|r"
L["HISTORY_DISABLED_MSG"] = "Historial: |cFFFF0000Desactivado|r"
L["SESSION_CLEARED_MSG"] = "Errores de sesión eliminados."
L["VERSION_AVAILABLE"] = "¡Nueva versión disponible (%s)!"
L["DOWNLOAD_UPDATE"] = "Descarga la actualización en CurseForge."
L["SIDEBAR_ADDONS"] = "ADDONS"
L["SEVERITY_ERROR"] = "Error"
L["SEVERITY_WARNING"] = "Advertencia"
L["ACTION_COPY"] = "Copiar todo"
L["ACTION_CLEAR"] = "Vaciar pestaña"
L["STACK_TRACE"] = "Stack trace"
L["SETTINGS_TITLE"] = "Ajustes"
L["OPTION_ENABLE_TOAST"] = "Activar toast"
L["OPTION_SHOW_MINIMAP"] = "Mostrar botón del minimapa"
L["MENU_SOUND"] = "Sonido"
L["ERRORS_COUNT"] = "%d errores"

-- Locals capture (v1.4.6)
L["OPTION_CAPTURE_LOCALS"] = "Capturar variables locales"
L["LOCALS_HEADER"] = "Variables locales"
