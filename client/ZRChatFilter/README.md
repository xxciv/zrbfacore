# ZRChatFilter

The WoW Circle 8.3.7 client prints its own `.ticket CUticketGet` ticket polls and `.addon load` lines
into chat (guild, say, ...), for example right after you queue for the Dungeon Finder. The server never
receives them as chat (the drop in `tools/bfa/client-ticket-poll.patch` logs nothing for them), so only
a client addon can hide them.

ZRChatFilter registers a chat message filter that hides every chat line containing `ticket CU` or
`.addon load`. `/zrcf` prints how many lines it hid this session.

Install: copy this folder to `Interface/AddOns/` in the client folder and enable it in the AddOns list.
