-- ZRProfessions (BFA 8.3.7): lets the trainer UI teach more than 2 primary professions and lists every
-- primary profession you know (/profs), since the Professions tab only has 2 slots.
--
-- The server's limit is worldserver.conf MaxPrimaryTradeSkill. This addon only removes the client's own
-- "you already know 2" check in Blizzard_TrainerUI. Ported from the Pandaria 5.4.8 version in zrpandaria548.

-- Keep this equal to MaxPrimaryTradeSkill in worldserver.conf.
local MAX_PRIMARY_PROFESSIONS = 4

-- spell: what a trainer teaches to learn the profession (one spell per profession since 8.0, no ranks;
-- checked against trainer_spell in the BFA world DB). Casting it opens the profession window.
-- skillLine: the profession's skill line. tiers: its expansion skill lines, newest first
-- (Kul Tiran, Legion, Draenor, Pandaria, Cataclysm, Northrend, Outland, Classic; SkillType in the core's
-- SharedDefines.h). gathering: no profession window to open.
local PROFESSIONS = {
    { spell = 2259,  skillLine = 171, tiers = { 2478, 2479, 2480, 2481, 2482, 2483, 2484, 2485 } }, -- Alchemy
    { spell = 2018,  skillLine = 164, tiers = { 2437, 2454, 2472, 2473, 2474, 2475, 2476, 2477 } }, -- Blacksmithing
    { spell = 7411,  skillLine = 333, tiers = { 2486, 2487, 2488, 2489, 2491, 2492, 2493, 2494 } }, -- Enchanting
    { spell = 4036,  skillLine = 202, tiers = { 2499, 2500, 2501, 2502, 2503, 2504, 2505, 2506 } }, -- Engineering
    { spell = 45357, skillLine = 773, tiers = { 2507, 2508, 2509, 2510, 2511, 2512, 2513, 2514 } }, -- Inscription
    { spell = 25229, skillLine = 755, tiers = { 2517, 2518, 2519, 2520, 2521, 2522, 2523, 2524 } }, -- Jewelcrafting
    { spell = 2108,  skillLine = 165, tiers = { 2525, 2526, 2527, 2528, 2529, 2530, 2531, 2532 } }, -- Leatherworking
    { spell = 3908,  skillLine = 197, tiers = { 2533, 2534, 2535, 2536, 2537, 2538, 2539, 2540 } }, -- Tailoring
    { spell = 2366,  skillLine = 182, tiers = { 2549, 2550, 2551, 2552, 2553, 2554, 2555, 2556 }, gathering = true }, -- Herbalism
    { spell = 2575,  skillLine = 186, tiers = { 2565, 2566, 2567, 2568, 2569, 2570, 2571, 2572 } }, -- Mining
    { spell = 8613,  skillLine = 393, tiers = { 2557, 2558, 2559, 2560, 2561, 2562, 2563, 2564 }, gathering = true }, -- Skinning
}

-- Mining's window is opened by Smelting when the client has it as a separate spell.
local SMELTING = 2656

local function Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99ZRProfessions:|r " .. msg)
end

-- Name, current and max skill of a skill line, or nil if the client doesn't report it.
local function SkillLineInfo(skillLine)
    if C_TradeSkillUI and C_TradeSkillUI.GetTradeSkillLineInfoByID then
        local ok, name, rank, maxRank = pcall(C_TradeSkillUI.GetTradeSkillLineInfoByID, skillLine)
        if ok and name and maxRank and maxRank > 0 then
            return name, rank, maxRank
        end
    end
end

local function IsKnown(prof)
    return IsPlayerSpell(prof.spell) or SkillLineInfo(prof.skillLine) ~= nil
end

local function CountKnownPrimaries()
    local count = 0
    for _, prof in ipairs(PROFESSIONS) do
        if IsKnown(prof) then
            count = count + 1
        end
    end
    return count
end

-- The expansion tier to show for a profession: the newest one with any skill, else the newest one learned.
local function CurrentTier(prof)
    local fallback
    for _, tier in ipairs(prof.tiers) do
        local name, rank, maxRank = SkillLineInfo(tier)
        if name then
            if rank and rank > 0 then
                return name, rank, maxRank
            end
            fallback = fallback or { name, rank, maxRank }
        end
    end
    if fallback then
        return unpack(fallback)
    end
end

---------------------------------------------------------------------------------------------------
-- Trainer: re-enable "Train" for a new primary profession while under the limit
---------------------------------------------------------------------------------------------------

-- Runs after Blizzard's ClassTrainerFrame_SetServiceButton, which disables Train for any new profession
-- once GetProfessions() reports a second one (Blizzard_TrainerUI.lua, same check as on 5.4.8).
local function AfterSetServiceButton(skillButton, skillIndex, playerMoney, selected, isTradeSkill)
    if not (ClassTrainerFrame.selectedService and selected == skillIndex) then
        return
    end
    local _, _, serviceType = GetTrainerServiceInfo(skillIndex)
    local moneyCost, isProfession = GetTrainerServiceCost(skillIndex)
    if serviceType ~= "available" or not isProfession then
        return
    end
    if moneyCost and moneyCost > (playerMoney or GetMoney()) then
        return
    end
    if CountKnownPrimaries() < MAX_PRIMARY_PROFESSIONS then
        ClassTrainerTrainButton:Enable()
    end
end

-- Blizzard's confirmation popup only has text for 0 or 1 known professions.
local function PatchConfirmPopup()
    local dialog = StaticPopupDialogs["CONFIRM_PROFESSION"]
    if not dialog then
        return
    end
    local originalOnShow = dialog.OnShow
    dialog.OnShow = function(self, ...)
        if originalOnShow then
            originalOnShow(self, ...)
        end
        local _, prof2 = GetProfessions()
        if prof2 then
            local skill = GetTrainerServiceSkillLine(ClassTrainerFrame.selectedService) or "this profession"
            self.text:SetFormattedText("Learn %s? You will know %d of %d primary professions.",
                skill, CountKnownPrimaries() + 1, MAX_PRIMARY_PROFESSIONS)
        end
    end
end

local trainerHooked = false
local function HookTrainerUI()
    if trainerHooked then
        return
    end
    trainerHooked = true
    hooksecurefunc("ClassTrainerFrame_SetServiceButton", AfterSetServiceButton)
    PatchConfirmPopup()
end

---------------------------------------------------------------------------------------------------
-- /profs panel: every primary profession, click to open it
---------------------------------------------------------------------------------------------------

local ROW_HEIGHT = 40
local panel, rows = nil, {}
local refreshPending = false

-- Row tooltip: every expansion tier of the profession with its skill.
local function ShowRowTooltip(row)
    local prof = row.prof
    if not prof then
        return
    end
    GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
    GameTooltip:AddLine(row.name:GetText())
    for _, tier in ipairs(prof.tiers) do
        local name, rank, maxRank = SkillLineInfo(tier)
        if name then
            local shade = (rank and rank > 0) and 1 or 0.5
            GameTooltip:AddDoubleLine(name, (rank or 0) .. "/" .. maxRank, shade, shade, shade, shade, shade, shade)
        end
    end
    if not prof.gathering then
        GameTooltip:AddLine("Click to open.", 0.25, 0.75, 0.25)
    end
    GameTooltip:Show()
end

local function CreateRow(index)
    -- Secure button: opening a profession window is a spell cast, which addons may only do this way.
    local row = CreateFrame("Button", "ZRProfessionsRow" .. index, panel, "SecureActionButtonTemplate")
    row:SetSize(260, ROW_HEIGHT - 4)
    row:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, -34 - (index - 1) * ROW_HEIGHT)
    row:RegisterForClicks("LeftButtonUp")
    row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
    row:SetScript("OnEnter", ShowRowTooltip)
    row:SetScript("OnLeave", GameTooltip_Hide)

    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(32, 32)
    row.icon:SetPoint("LEFT", 2, 0)

    row.name = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    row.name:SetPoint("TOPLEFT", row.icon, "TOPRIGHT", 8, -2)

    row.sub = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    row.sub:SetPoint("BOTTOMLEFT", row.icon, "BOTTOMRIGHT", 8, 2)

    rows[index] = row
    return row
end

local function RefreshPanel()
    if InCombatLockdown() then
        refreshPending = true
        return
    end
    refreshPending = false

    local shown = 0
    for _, prof in ipairs(PROFESSIONS) do
        if IsKnown(prof) then
            shown = shown + 1
            local row = rows[shown] or CreateRow(shown)
            row.prof = prof
            local name, _, icon = GetSpellInfo(prof.spell)
            row.icon:SetTexture(icon)
            row.name:SetText(name or SkillLineInfo(prof.skillLine) or "?")

            local tierName, rank, maxRank = CurrentTier(prof)
            local sub = tierName and (tierName .. "  " .. (rank or 0) .. "/" .. maxRank) or ""
            if prof.gathering then
                sub = sub .. "  (gathering)"
            end
            row.sub:SetText(sub)

            if prof.gathering then
                row:SetAttribute("type", nil)
                row:SetAttribute("spell", nil)
            else
                local open = prof.spell
                if prof.skillLine == 186 and IsPlayerSpell(SMELTING) then
                    open = SMELTING
                end
                row:SetAttribute("type", "spell")
                row:SetAttribute("spell", open)
            end
            row:Show()
        end
    end
    for i = shown + 1, #rows do
        rows[i].prof = nil
        rows[i]:Hide()
    end

    if shown == 0 then
        panel.empty:Show()
    else
        panel.empty:Hide()
    end
    panel.count:SetFormattedText("%d / %d primary professions", shown, MAX_PRIMARY_PROFESSIONS)
    panel:SetHeight(64 + math.max(shown, 1) * ROW_HEIGHT)
end

local function CreatePanel()
    panel = CreateFrame("Frame", "ZRProfessionsFrame", UIParent)
    panel:SetSize(290, 100)
    panel:SetPoint("CENTER")
    panel:SetFrameStrata("DIALOG")
    panel:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 },
    })
    panel:EnableMouse(true)
    panel:SetMovable(true)
    panel:RegisterForDrag("LeftButton")
    panel:SetScript("OnDragStart", panel.StartMoving)
    panel:SetScript("OnDragStop", panel.StopMovingOrSizing)
    panel:Hide()

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -14)
    title:SetText("Primary Professions")

    local close = CreateFrame("Button", nil, panel, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -4, -4)

    panel.empty = panel:CreateFontString(nil, "ARTWORK", "GameFontDisable")
    panel.empty:SetPoint("TOP", 0, -46)
    panel.empty:SetText("No primary professions learned.")

    panel.count = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    panel.count:SetPoint("BOTTOM", 0, 14)

    panel:SetScript("OnShow", RefreshPanel)
end

local function TogglePanel()
    if InCombatLockdown() then
        Print("not available in combat.")
        return
    end
    if panel:IsShown() then
        panel:Hide()
    else
        panel:Show()
    end
end

-- "All professions" button on the spellbook's Professions tab, next to the bottom tabs.
local function AddSpellbookButton()
    if not SpellBookProfessionFrame then
        return
    end
    local button = CreateFrame("Button", "ZRProfessionsSpellbookButton", SpellBookProfessionFrame, "UIPanelButtonTemplate")
    button:SetSize(130, 22)
    button:SetPoint("TOPRIGHT", SpellBookFrame, "BOTTOMRIGHT", -8, 2)
    button:SetText("All professions")
    button:SetScript("OnClick", TogglePanel)
end

-- /profs debug: what the client reports for each primary profession, for checking the addon in game.
local function PrintDebug()
    local prof1, prof2 = GetProfessions()
    Print(format("%d of %d primary professions known; Professions tab slots: %s, %s",
        CountKnownPrimaries(), MAX_PRIMARY_PROFESSIONS,
        prof1 and GetProfessionInfo(prof1) or "-", prof2 and GetProfessionInfo(prof2) or "-"))
    for _, prof in ipairs(PROFESSIONS) do
        local name = GetSpellInfo(prof.spell) or prof.spell
        local tierName, rank, maxRank = CurrentTier(prof)
        Print(format("%s: spell %s, skill line %s, tier %s", name, IsPlayerSpell(prof.spell) and "known" or "not known",
            SkillLineInfo(prof.skillLine) and "reported" or "not reported",
            tierName and format("%s %d/%d", tierName, rank or 0, maxRank) or "none"))
    end
end

SLASH_ZRPROFESSIONS1 = "/profs"
SLASH_ZRPROFESSIONS2 = "/zrprofs"
SlashCmdList["ZRPROFESSIONS"] = function(msg)
    if strtrim(msg or ""):lower() == "debug" then
        PrintDebug()
    else
        TogglePanel()
    end
end

---------------------------------------------------------------------------------------------------
-- Events
---------------------------------------------------------------------------------------------------

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("SKILL_LINES_CHANGED")
events:RegisterEvent("LEARNED_SPELL_IN_TAB")
events:RegisterEvent("PLAYER_REGEN_DISABLED")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == "ZRProfessions" then
            CreatePanel()
            AddSpellbookButton()
            -- The trainer UI is load-on-demand; it may already be loaded if another addon pulled it in.
            if IsAddOnLoaded("Blizzard_TrainerUI") then
                HookTrainerUI()
            end
        elseif arg1 == "Blizzard_TrainerUI" then
            HookTrainerUI()
        end
    elseif event == "PLAYER_REGEN_DISABLED" then
        -- Hide before combat lockdown starts; the panel holds secure buttons and can't be hidden during it.
        if panel and panel:IsShown() then
            panel:Hide()
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        if refreshPending and panel and panel:IsShown() then
            RefreshPanel()
        end
    elseif panel and panel:IsShown() then
        RefreshPanel()
    end
end)
