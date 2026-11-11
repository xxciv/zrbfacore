local _, AddonNamespace = ...

if GetLocale() ~= "ruRU" then return end

local L = AddonNamespace.L

-- Russian Translations
L["LOADED_DB"] = "База данных загружена."
L["READY_CATCH"] = "Готов к перехвату ошибок."
L["CAPTURE_ACTIVE"] = "Перехват ошибок активен (стандартный интерфейс отключен)."
L["CUSTOM_FONT_RELOAD"] = "Настройка пользовательского шрифта кода изменена. Перезагрузите интерфейс для применения."

-- UI Texts
L["TITLE"] = "BUGTABS"
L["MENU_FILE"] = "Файл"
L["MENU_EDIT"] = "Редактировать"
L["MENU_OPTIONS"] = "Настройки"

L["OPTION_SAVE_HISTORY"] = "Сохранить историю"
L["OPTION_SELECT_ALL"] = "Выбрать всё"
L["OPTION_CLEAR_TAB"] = "Очистить вкладку"
L["OPTION_CLOSE_WINDOW"] = "Закрыть окно"

L["OPTION_ENABLE_BANNER"] = "Включить баннер"
L["OPTION_ENABLE_SOUND"] = "Включить звук"
L["OPTION_ENABLE_FONT"] = "Использовать свой шрифт"

L["SOUND_RAID_WARNING"] = "Звук: Предупреждение для рейда"
L["SOUND_DING"] = "Звук: Дзынь"
L["SOUND_EXPLOSION"] = "Звук: Взрыв"
L["SOUND_LEVEL_UP"] = "Звук: Повышение уровня"

L["HISTORY_PREFIX"] = "[ИСТОРИЯ %s]"
L["NO_ERRORS"] = "Нет ошибок за %s"
L["UNKNOWN_ADDON"] = "Неизвестно"
L["MINIMAP_TOOLTIP1"] = "BugTabs"
L["MINIMAP_TOOLTIP_LCLICK"] = "|cFF00FF00ЛКМ|r - открыть BugTabs"
L["MINIMAP_TOOLTIP_SLCLICK"] = "|cFF00FF00Shift + ЛКМ|r - очистить ошибки сессии"
L["MINIMAP_TOOLTIP_RCLICK"] = "|cFF00FF00ПКМ|r - вкл./выкл. сохранение истории"
L["MINIMAP_ERRORS_COUNT"] = "Текущие ошибки: |cFFFFD100%d|r"
L["COMBAT_ERRORS_PENDING"] = "Во время боя возникли ошибки."
L["HISTORY_ENABLED_MSG"] = "Сохранение истории: |cFF00FF00включено|r"
L["HISTORY_DISABLED_MSG"] = "Сохранение истории: |cFFFF0000отключено|r"
L["SESSION_CLEARED_MSG"] = "Ошибки сессии очищены."
L["VERSION_AVAILABLE"] = "Доступна новая версия (%s)!"
L["DOWNLOAD_UPDATE"] = "Скачайте обновление на CurseForge."
L["SIDEBAR_ADDONS"] = "АДДОНЫ"
L["SEVERITY_ERROR"] = "Ошибка"
L["SEVERITY_WARNING"] = "Предупреждение"
L["ACTION_COPY"] = "Копировать всё"
L["ACTION_CLEAR"] = "Очистить вкладку"
L["STACK_TRACE"] = "Трассировка стека"
L["SETTINGS_TITLE"] = "Настройки"
L["OPTION_ENABLE_TOAST"] = "Включить всплывающее уведомление"
L["OPTION_SHOW_MINIMAP"] = "Показывать кнопку у миникарты"
L["MENU_SOUND"] = "Звук"
L["ERRORS_COUNT"] = "%d ошибок"

-- Locals capture (v1.4.6)
L["OPTION_CAPTURE_LOCALS"] = "Захватывать локальные переменные"
L["LOCALS_HEADER"] = "Локальные переменные"