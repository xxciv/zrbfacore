local i = 0

function SortedTooltip_Schedule(func)
    local tooltipDelay = Sorted_GetSetting("tooltipDelay")
    if tooltipDelay == 0 then
        func()
        return
    end
    i = i + 1
    local id = i
    C_Timer.After(tooltipDelay, function()
        if i == id then
            func()
        end
    end)
end

function SortedTooltip_Cancel()
    GameTooltip:Hide()
    BattlePetTooltip:Hide()
    i = i + 1
end