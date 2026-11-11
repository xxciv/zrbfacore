local _, AddonNamespace = ...

if GetLocale() ~= "zhTW" then return end

local L = AddonNamespace.L

-- Traditional Chinese
L["LOADED_DB"] = "資料庫已載入。"
L["READY_CATCH"] = "已準備好捕捉錯誤。"
L["CAPTURE_ACTIVE"] = "錯誤捕捉已啟用（預設介面已隱藏）。"
L["CUSTOM_FONT_RELOAD"] = "自訂字型已變更。請重載介面（/reload）以套用。"

-- UI Texts
L["TITLE"] = "BUGTABS"
L["MENU_FILE"] = "檔案"
L["MENU_EDIT"] = "編輯"
L["MENU_OPTIONS"] = "選項"

L["OPTION_SAVE_HISTORY"] = "儲存歷史"
L["OPTION_SELECT_ALL"] = "全選"
L["OPTION_CLEAR_TAB"] = "清空分頁"
L["OPTION_CLOSE_WINDOW"] = "關閉視窗"

L["OPTION_ENABLE_BANNER"] = "啟用橫幅"
L["OPTION_ENABLE_SOUND"] = "啟用音效"
L["OPTION_ENABLE_FONT"] = "使用自訂字型"

L["SOUND_RAID_WARNING"] = "音效：團隊警報"
L["SOUND_DING"] = "音效：叮"
L["SOUND_EXPLOSION"] = "音效：爆炸"
L["SOUND_LEVEL_UP"] = "音效：升級"

L["HISTORY_PREFIX"] = "[歷史 %s]"
L["NO_ERRORS"] = "%s 沒有錯誤"
L["UNKNOWN_ADDON"] = "未知"
L["MINIMAP_TOOLTIP1"] = "BugTabs"
L["MINIMAP_TOOLTIP_LCLICK"] = "|cFF00FF00左鍵點擊|r 開啟 BugTabs"
L["MINIMAP_TOOLTIP_SLCLICK"] = "|cFF00FF00Shift + 左鍵點擊|r 清空本次錯誤"
L["MINIMAP_TOOLTIP_RCLICK"] = "|cFF00FF00右鍵點擊|r 切換歷史儲存"
L["MINIMAP_ERRORS_COUNT"] = "目前錯誤：|cFFFFD100%d|r"
L["COMBAT_ERRORS_PENDING"] = "戰鬥中發生了錯誤。"
L["HISTORY_ENABLED_MSG"] = "歷史儲存：|cFF00FF00已啟用|r"
L["HISTORY_DISABLED_MSG"] = "歷史儲存：|cFFFF0000已停用|r"
L["SESSION_CLEARED_MSG"] = "本次錯誤已清空。"
L["VERSION_AVAILABLE"] = "有新版本可用（%s）！"
L["DOWNLOAD_UPDATE"] = "請到 CurseForge 下載更新。"
L["SIDEBAR_ADDONS"] = "插件"
L["SEVERITY_ERROR"] = "錯誤"
L["SEVERITY_WARNING"] = "警告"
L["ACTION_COPY"] = "全部複製"
L["ACTION_CLEAR"] = "清空分頁"
L["STACK_TRACE"] = "堆疊追蹤"
L["SETTINGS_TITLE"] = "設定"
L["OPTION_ENABLE_TOAST"] = "啟用彈出提示"
L["OPTION_SHOW_MINIMAP"] = "顯示小地圖按鈕"
L["MENU_SOUND"] = "音效"
L["ERRORS_COUNT"] = "%d 個錯誤"

-- Locals capture (v1.4.6)
L["OPTION_CAPTURE_LOCALS"] = "擷取區域變數"
L["LOCALS_HEADER"] = "區域變數"
