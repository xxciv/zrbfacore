-- ZRProximity: distance checks for any unit on the 8.3.7 client.
--
-- The client only gives exact positions for the player and group members, not for NPCs.
-- Like range-check addons, we ask "would this item reach that unit?" with IsItemInRange,
-- using items whose use range is known. The item does not have to be in your bags; the
-- client only needs its data cached, which we request at login. That gives distance in
-- steps (3, 4, 5, 6, 8, 10, 15 ... 40 yards). CheckInteractDistance is the fallback.
local _, ns = ...

-- [yards] = itemID. Friendly-target and hostile-target items (from LibRangeCheck-2.0).
local FRIEND_ITEMS = {
    [4]  = 90175,  -- Gin-Ji Knife Set
    [5]  = 37727,  -- Ruby Acorn
    [6]  = 63427,  -- Worgsaw
    [8]  = 34368,  -- Attuned Crystal Cores
    [10] = 32321,  -- Sparrowhawk Net
    [15] = 1251,   -- Linen Bandage
    [20] = 21519,  -- Mistletoe
    [25] = 31463,  -- Zezzak's Shard
    [30] = 1180,   -- Scroll of Stamina
    [35] = 18904,  -- Zorbin's Ultra-Shrinker
    [40] = 34471,  -- Vial of the Sunwell
}
local HARM_ITEMS = {
    [3]  = 42732,  -- Everfrost Razor
    [5]  = 37727,  -- Ruby Acorn
    [6]  = 63427,  -- Worgsaw
    [8]  = 34368,  -- Attuned Crystal Cores
    [10] = 32321,  -- Sparrowhawk Net
    [15] = 33069,  -- Sturdy Rope
    [20] = 10645,  -- Gnomish Death Ray
    [25] = 24268,  -- Netherweave Net
    [30] = 835,    -- Large Rope Net
    [35] = 24269,  -- Heavy Netherweave Net
    [40] = 28767,  -- The Decapitator
}
-- CheckInteractDistance indexes: 3 = duel (~10 yd), 2 = trade (~11 yd), 4 = follow (~28 yd).
local INTERACT = { {10, 3}, {11, 2}, {28, 4} }

local function sortedSteps(items)
    local steps = {}
    for yards, item in pairs(items) do
        steps[#steps + 1] = { yards = yards, item = item }
    end
    table.sort(steps, function(a, b) return a.yards < b.yards end)
    return steps
end

local FRIEND_STEPS = sortedSteps(FRIEND_ITEMS)
local HARM_STEPS = sortedSteps(HARM_ITEMS)
ns.FRIEND_STEPS, ns.HARM_STEPS = FRIEND_STEPS, HARM_STEPS

function ns.RequestRangeItems()
    for _, list in ipairs({ FRIEND_STEPS, HARM_STEPS }) do
        for _, s in ipairs(list) do
            if C_Item and C_Item.RequestLoadItemDataByID then
                C_Item.RequestLoadItemDataByID(s.item)
            else
                GetItemInfo(s.item)
            end
        end
    end
end

-- true = within `yards`, false = farther, nil = can't tell.
-- Uses the smallest step that is at least `yards`, so a 7-yard setting checks 8 yards.
function ns.IsWithin(unit, yards)
    if yards <= 0 then return false end
    local steps = UnitCanAttack("player", unit) and HARM_STEPS or FRIEND_STEPS
    for _, s in ipairs(steps) do
        if s.yards >= yards then
            local r = IsItemInRange(s.item, unit)
            if r ~= nil then return r and true or false end
        end
    end
    for _, c in ipairs(INTERACT) do
        if c[1] >= yards then
            local ok, r = pcall(CheckInteractDistance, unit, c[2])
            if ok and r ~= nil then return r and true or false end
        end
    end
    return nil
end

-- The step a setting really checks, for the options panel ("7 yd -> checks 8 yd").
function ns.EffectiveStep(yards, hostile)
    local steps = hostile and HARM_STEPS or FRIEND_STEPS
    for _, s in ipairs(steps) do
        if s.yards >= yards then return s.yards end
    end
    return yards
end

-- /zrp range: which steps work on your target right now.
function ns.PrintRangeDebug()
    if not UnitExists("target") then
        print("|cff33ff99ZRProximity|r: target something first.")
        return
    end
    local hostile = UnitCanAttack("player", "target")
    local steps = hostile and HARM_STEPS or FRIEND_STEPS
    local parts = {}
    for _, s in ipairs(steps) do
        local r = IsItemInRange(s.item, "target")
        parts[#parts + 1] = s.yards .. "=" .. (r == nil and "?" or (r and "in" or "out"))
    end
    for _, c in ipairs(INTERACT) do
        local ok, r = pcall(CheckInteractDistance, "target", c[2])
        parts[#parts + 1] = "i" .. c[1] .. "=" .. ((not ok or r == nil) and "?" or (r and "in" or "out"))
    end
    print("|cff33ff99ZRProximity|r " .. (hostile and "hostile" or "friendly") .. " list on " ..
        (UnitName("target") or "?") .. ": " .. table.concat(parts, " "))
    print("  ? = item data not loaded yet or not usable on this unit.")
end
