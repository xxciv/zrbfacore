local _, AddonNamespace = ...

if GetLocale() ~= "zhCN" then return end

local L = AddonNamespace.L

-- Simplified Chinese
L["LOADED_DB"] = "数据库已加载。"
L["READY_CATCH"] = "已准备好捕获错误。"
L["CAPTURE_ACTIVE"] = "错误捕获已启用（默认界面已隐藏）。"
L["CUSTOM_FONT_RELOAD"] = "自定义字体已更改。请重载界面（/reload）以生效。"

-- UI Texts
L["TITLE"] = "BUGTABS"
L["MENU_FILE"] = "文件"
L["MENU_EDIT"] = "编辑"
L["MENU_OPTIONS"] = "选项"

L["OPTION_SAVE_HISTORY"] = "保存历史"
L["OPTION_SELECT_ALL"] = "全选"
L["OPTION_CLEAR_TAB"] = "清空标签"
L["OPTION_CLOSE_WINDOW"] = "关闭窗口"

L["OPTION_ENABLE_BANNER"] = "启用横幅"
L["OPTION_ENABLE_SOUND"] = "启用音效"
L["OPTION_ENABLE_FONT"] = "使用自定义字体"

L["SOUND_RAID_WARNING"] = "音效：团队警报"
L["SOUND_DING"] = "音效：叮"
L["SOUND_EXPLOSION"] = "音效：爆炸"
L["SOUND_LEVEL_UP"] = "音效：升级"

L["HISTORY_PREFIX"] = "[历史 %s]"
L["NO_ERRORS"] = "%s 没有错误"
L["UNKNOWN_ADDON"] = "未知"
L["MINIMAP_TOOLTIP1"] = "BugTabs"
L["MINIMAP_TOOLTIP_LCLICK"] = "|cFF00FF00左键点击|r 打开 BugTabs"
L["MINIMAP_TOOLTIP_SLCLICK"] = "|cFF00FF00Shift + 左键点击|r 清空本次错误"
L["MINIMAP_TOOLTIP_RCLICK"] = "|cFF00FF00右键点击|r 切换历史保存"
L["MINIMAP_ERRORS_COUNT"] = "当前错误：|cFFFFD100%d|r"
L["COMBAT_ERRORS_PENDING"] = "战斗中发生了错误。"
L["HISTORY_ENABLED_MSG"] = "历史保存：|cFF00FF00已启用|r"
L["HISTORY_DISABLED_MSG"] = "历史保存：|cFFFF0000已禁用|r"
L["SESSION_CLEARED_MSG"] = "本次错误已清空。"
L["VERSION_AVAILABLE"] = "有新版本可用（%s）！"
L["DOWNLOAD_UPDATE"] = "请到 CurseForge 下载更新。"
L["SIDEBAR_ADDONS"] = "插件"
L["SEVERITY_ERROR"] = "错误"
L["SEVERITY_WARNING"] = "警告"
L["ACTION_COPY"] = "全部复制"
L["ACTION_CLEAR"] = "清空标签"
L["STACK_TRACE"] = "堆栈跟踪"
L["SETTINGS_TITLE"] = "设置"
L["OPTION_ENABLE_TOAST"] = "启用弹出提示"
L["OPTION_SHOW_MINIMAP"] = "显示小地图按钮"
L["MENU_SOUND"] = "音效"
L["ERRORS_COUNT"] = "%d 个错误"

-- Locals capture (v1.4.6)
L["OPTION_CAPTURE_LOCALS"] = "捕获局部变量"
L["LOCALS_HEADER"] = "局部变量"
