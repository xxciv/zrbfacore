-- ZRChatFilter (zrbfacore)
-- The WoW Circle 8.3.7 client prints its own ".ticket CUticketGet" ticket polls and ".addon load"
-- lines into chat (guild, say, ...). Our server never receives them as chat (the server-side drop
-- in tools/bfa/client-ticket-poll.patch logged nothing), so they are shown by the client itself.
-- This hides any chat line containing that text. /zrcf shows how many lines were hidden.

local patterns = { "ticket CU", "%.addon load" }
local hidden = 0

local function filter(_, _, msg)
    if type(msg) ~= "string" then
        return false
    end
    for _, p in ipairs(patterns) do
        if msg:find(p) then
            hidden = hidden + 1
            return true
        end
    end
    return false
end

local events = {
    "CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_GUILD", "CHAT_MSG_OFFICER",
    "CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER", "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER",
    "CHAT_MSG_RAID_WARNING", "CHAT_MSG_INSTANCE_CHAT", "CHAT_MSG_INSTANCE_CHAT_LEADER",
    "CHAT_MSG_WHISPER", "CHAT_MSG_WHISPER_INFORM", "CHAT_MSG_CHANNEL", "CHAT_MSG_SYSTEM",
    "CHAT_MSG_EMOTE",
}

for _, event in ipairs(events) do
    ChatFrame_AddMessageEventFilter(event, filter)
end

SLASH_ZRCHATFILTER1 = "/zrcf"
SlashCmdList.ZRCHATFILTER = function()
    print(("|cff33ff99ZRChatFilter|r: %d client poll line(s) hidden this session."):format(hidden))
end
