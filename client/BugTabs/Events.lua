local _, AddonNamespace = ...
local L = AddonNamespace.L

local inCombat = false
local pendingErrors = false

local eventFrame = CreateFrame("Frame")

-- ============================================================
-- Anti-flood maison (token bucket BugTabs)
-- Crédit rechargé en continu : errorsPerSec/2 par seconde, max
-- errorsPerSec. Sous 1 crédit on laisse tomber l'erreur (mais on
-- compte le débit quand même). Vitesse par défaut : 20 err/s.
-- ============================================================
local FLOOD_RATE = 20
local floodCredits = FLOOD_RATE
local floodLast = GetTime()

local function FloodAllows()
    local now = GetTime()
    floodCredits = math.min(FLOOD_RATE, floodCredits + (now - floodLast) * (FLOOD_RATE / 2))
    floodLast = now
    if floodCredits < 1 then return false end
    floodCredits = floodCredits - 1
    return true
end

-- Extrait l'objet erreur d'un ping BugGrabber, quel que soit le mécanisme :
-- CallbackHandler legacy -> errorObject directement ; EventRegistry (r377+,
-- mars 2026) -> tableID string, à résoudre via BugGrabber:GetErrorByID.
local function ErrorObjectFromPayload(grabber, payload)
    if type(payload) == "table" then return payload end
    if type(payload) == "string" and grabber.GetErrorByID then
        local ok, obj = pcall(grabber.GetErrorByID, grabber, payload)
        if ok then return obj end
    end
end

local function StoreGrabberError(grabber, payload)
    local errorObject = ErrorObjectFromPayload(grabber, payload)
    if errorObject and errorObject.message then
        local rawMsg = AddonNamespace.SanitizeString(errorObject.message)
        local rawStack = errorObject.stack and AddonNamespace.CleanStack(errorObject.stack) or nil
        local addonName = AddonNamespace.ParseAddonName(rawMsg, rawStack)
        local rawLocals = BugTabsDB and BugTabsDB.settings.captureLocals
            and errorObject.locals and AddonNamespace.FormatLocals(errorObject.locals) or nil
        AddonNamespace.Events:StoreError(addonName, rawMsg, rawStack, nil, rawLocals)
    end
end

local function SafeRegisterEvent(frame, eventName)
    pcall(function() frame:RegisterEvent(eventName) end)
end

SafeRegisterEvent(eventFrame, "ADDON_LOADED")
SafeRegisterEvent(eventFrame, "PLAYER_LOGIN")
SafeRegisterEvent(eventFrame, "PLAYER_REGEN_DISABLED")
SafeRegisterEvent(eventFrame, "PLAYER_REGEN_ENABLED")
SafeRegisterEvent(eventFrame, "ADDON_ACTION_BLOCKED")
SafeRegisterEvent(eventFrame, "ADDON_ACTION_FORBIDDEN")
SafeRegisterEvent(eventFrame, "MACRO_ACTION_BLOCKED")
SafeRegisterEvent(eventFrame, "MACRO_ACTION_FORBIDDEN")
SafeRegisterEvent(eventFrame, "LUA_WARNING")

eventFrame:SetScript("OnEvent", function(_, event, arg1, ...)
    if event == "ADDON_LOADED" and arg1 == "BugTabs" then
        AddonNamespace.Config:InitializeDB()
        print("|cFF00FF00BugTabs|r: " .. L["LOADED_DB"])
    elseif event == "PLAYER_LOGIN" then
        AddonNamespace.Events:InitErrorCapture()
        if AddonNamespace.UI then
            AddonNamespace.UI:CreateMinimapButton()
        end
        if AddonNamespace.Broker then
            AddonNamespace.Broker:Init()
        end
        print("|cFF00FF00BugTabs|r: " .. L["READY_CATCH"])
    elseif event == "PLAYER_REGEN_DISABLED" then
        inCombat = true
    elseif event == "PLAYER_REGEN_ENABLED" then
        inCombat = false
        if pendingErrors then
            pendingErrors = false
            if BugTabsDB.settings.playSound then PlaySound(BugTabsDB.settings.soundId or 8959) end
            if BugTabsDB.settings.showBanner and AddonNamespace.UI then
                AddonNamespace.UI:ShowBanner(L["COMBAT_ERRORS_PENDING"] or "Combat Errors")
            end
        end
    elseif event == "ADDON_ACTION_BLOCKED" or event == "ADDON_ACTION_FORBIDDEN" or event == "MACRO_ACTION_BLOCKED" or event == "MACRO_ACTION_FORBIDDEN" then
        local addonName = AddonNamespace.SanitizeString(arg1 or L["UNKNOWN_ADDON"])
        local funcName = AddonNamespace.SanitizeString(select(1, ...) or "Unknown")
        local actionType = event:match("(.+)_ACTION") or "ACTION"
        local actionResult = event:match("ACTION_(.+)") or "BLOCKED"
        local msg = string.format("%s %s: %s", actionType, actionResult, funcName)
        AddonNamespace.Events:StoreError(addonName, msg)
    elseif event == "LUA_WARNING" then
        local warningType, warningMessage = arg1, select(1, ...)
        if warningType and warningMessage then
            warningType = AddonNamespace.SanitizeString(warningType)
            warningMessage = AddonNamespace.SanitizeString(warningMessage)
            local msg = string.format("[WARNING %s] %s", warningType, warningMessage)
            AddonNamespace.Events:StoreError("LUA_WARNING", msg)
        end
    end
end)

AddonNamespace.Events = {}

-- Capture « classique » (sans BugGrabber). Le handler est posé dès le chargement
-- de ce fichier — pas à PLAYER_LOGIN — pour attraper les erreurs émises pendant
-- le chargement des addons suivants, puis ré-affirmé à PLAYER_LOGIN au cas où
-- un autre addon l'aurait remplacé entre-temps.
local origHandler
local function OnLuaError(msg)
    msg = AddonNamespace.SanitizeString(msg)
    -- debugstack from inside the handler still contains the original fault
    -- frames under the capturer; CleanStack strips BugTabs/BugGrabber noise.
    local stack = AddonNamespace.CleanStack(debugstack(2))
    local addonName = AddonNamespace.ParseAddonName(msg, stack)
    -- Locals : capturés ici (frame 2 = frame fautif vu du handler), à notre
    -- niveau, indépendamment de tout addon tiers. debuglocals(2) renvoie les
    -- locales du frame qui a levé l'erreur.
    local locals = nil
    if BugTabsDB and BugTabsDB.settings.captureLocals then
        locals = AddonNamespace.FormatLocals(debuglocals(2))
    end
    AddonNamespace.Events:StoreError(addonName, msg, stack, nil, locals)
    if origHandler and origHandler ~= _ERRORMESSAGE and origHandler ~= geterrorhandler() then
        origHandler(msg)
    end
end

local function InstallErrorHandler()
    if geterrorhandler() == OnLuaError then return end
    if not origHandler then origHandler = geterrorhandler() end
    seterrorhandler(OnLuaError)
end

if not _G.BugGrabber then
    InstallErrorHandler()
end

-- Récupère les erreurs de la session courante déjà capturées par BugGrabber
-- avant notre abonnement (notamment celles émises pendant le chargement),
-- avec leur pile, leur compteur et leur horodatage d'origine.
local function ImportBugGrabberErrors(grabber)
    if not (grabber.GetDB and grabber.GetSessionId) then return end
    local session = grabber:GetSessionId()
    for _, errorObject in ipairs(grabber:GetDB()) do
        if errorObject.session == session and errorObject.message then
            local rawMsg = AddonNamespace.SanitizeString(errorObject.message)
            local rawStack = errorObject.stack and AddonNamespace.CleanStack(errorObject.stack) or nil
            local addonName = AddonNamespace.ParseAddonName(rawMsg, rawStack)
            AddonNamespace.Events:StoreError(addonName, rawMsg, rawStack, true)
            local entry = AddonNamespace.sessionErrorsHash[addonName] and AddonNamespace.sessionErrorsHash[addonName][rawMsg]
            if entry then
                entry.count = errorObject.counter or entry.count
                local hms = errorObject.time and tostring(errorObject.time):match("%d+:%d+:%d+")
                if hms then entry.timestamp = hms end
            end
        end
    end
end

function AddonNamespace.Events:InitErrorCapture()
    -- BugGrabber (embarqué par BugSack) remplace la globale seterrorhandler par
    -- un no-op et garde le gestionnaire d'erreurs pour lui ; dans ce cas le seul
    -- moyen de recevoir les erreurs est de s'abonner à son callback.
    local usingBugGrabber = false
    if _G.BugGrabber then
        local grabber = _G.BugGrabber
        if grabber.setupCallbacks then grabber.setupCallbacks() end
        -- BugGrabber r377+ (mars 2026) : plus de RegisterCallback CallbackHandler,
        -- les erreurs arrivent via EventRegistry "BugGrabber.BugGrabbed" (payload =
        -- tableID, à résoudre via GetErrorByID). Legacy : RegisterCallback reçoit
        -- directement l'errorObject.
        local subscribed = false
        if EventRegistry then
            EventRegistry:RegisterCallback("BugGrabber.BugGrabbed", function(_, payload)
                StoreGrabberError(grabber, payload)
            end, eventFrame)
            subscribed = true
        end
        if grabber.RegisterCallback then
            ImportBugGrabberErrors(grabber)
            grabber.RegisterCallback(self, "BugGrabber_BugGrabbed", function(_, errorObject)
                StoreGrabberError(grabber, errorObject)
            end)
            subscribed = true
        end
        if subscribed then
            ImportBugGrabberErrors(grabber)
            usingBugGrabber = true
        end
    end

    if not usingBugGrabber then
        InstallErrorHandler()
    end

    if _G.ScriptErrorsFrame then
        _G.ScriptErrorsFrame:UnregisterAllEvents()
        _G.ScriptErrorsFrame:Hide()
        _G.ScriptErrorsFrame:SetScript("OnShow", function(self) self:Hide() end)
    end

    print("|cFF00FF00BugTabs|r: " .. L["CAPTURE_ACTIVE"])
end

function AddonNamespace.Events:StoreError(addonName, msg, stack, silent, locals)
    -- Anti-flood : au-delà de FLOOD_RATE err/s, on ignore (les nouvelles
    -- erreurs seulement ; les doublons incrémentent juste leur compteur).
    local isNew = not (AddonNamespace.sessionErrorsHash[addonName] and AddonNamespace.sessionErrorsHash[addonName][msg])
    if isNew and not FloodAllows() then return end
    msg = AddonNamespace.SanitizeString(msg)
    if stack then
        stack = AddonNamespace.CleanStack(stack)
    else
        stack = AddonNamespace.CleanStack(debugstack(3))
    end
    -- Re-resolve when caller passed a capturer name / empty guess but the
    -- stack points at the real culprit (e.g. bare "bad argument #1" msgs).
    local resolved = AddonNamespace.ParseAddonName(msg, stack)
    addonName = AddonNamespace.SanitizeString(addonName)
    if addonName == "" or addonName == L["UNKNOWN_ADDON"] or addonName == "BugTabs"
        or addonName == "!BugGrabber" or addonName == "BugSack" then
        addonName = resolved
    end
    if not AddonNamespace.sessionErrors[addonName] then
        AddonNamespace.sessionErrors[addonName] = {}
        AddonNamespace.sessionErrorsHash[addonName] = {}
    end

    local isSpam = false
    -- Déduplication O(1)
    local hashEntry = AddonNamespace.sessionErrorsHash[addonName][msg]
    if hashEntry then
        hashEntry.count = (hashEntry.count or 1) + 1
        hashEntry.timestamp = date("%H:%M:%S")
        isSpam = true
    else
        local entry = {
            timestamp = date("%H:%M:%S"),
            message = msg,
            count = 1,
            stack = stack,
            locals = locals
        }
        AddonNamespace.sessionErrorsHash[addonName][msg] = entry
        table.insert(AddonNamespace.sessionErrors[addonName], entry)
        if #AddonNamespace.sessionErrors[addonName] > AddonNamespace.MAX_HISTORY then
            local oldest = table.remove(AddonNamespace.sessionErrors[addonName], 1)
            if oldest then
                AddonNamespace.sessionErrorsHash[addonName][oldest.message] = nil
            end
        end

        if BugTabsDB and BugTabsDB.settings.saveHistory then
            if not BugTabsDB.history[addonName] then
                BugTabsDB.history[addonName] = {}
            end
            table.insert(BugTabsDB.history[addonName], entry)
            if #BugTabsDB.history[addonName] > AddonNamespace.MAX_HISTORY then
                table.remove(BugTabsDB.history[addonName], 1)
            end
        end
    end

    if AddonNamespace.UI and AddonNamespace.UI.UpdateUI then
        AddonNamespace.UI:UpdateUI()
    end

    if AddonNamespace.MinimapIcon then
        AddonNamespace.MinimapIcon:SetVertexColor(1, 0, 0)
    end

    if AddonNamespace.Broker then AddonNamespace.Broker:Update() end

    if AddonNamespace.MainFrame and AddonNamespace.MainFrame:IsShown() and AddonNamespace.MainFrame.currentTab == addonName then
        if AddonNamespace.UI then
            AddonNamespace.UI:ShowTab(addonName)
        end
    end

    if isSpam or silent then return end

    if inCombat then
        pendingErrors = true
        return
    end

    if BugTabsDB and BugTabsDB.settings.playSound then
        PlaySound(BugTabsDB.settings.soundId or 8959)
    end

    if BugTabsDB and BugTabsDB.settings.showBanner and AddonNamespace.UI then
        AddonNamespace.UI:ShowBanner(addonName)
    end
end
