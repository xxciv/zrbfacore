# ZRProfessions (client addon, BFA 8.3.7)

Lets characters learn up to 4 primary professions on the 8.3.7 client, and lists all of them with `/profs`.
Ported from the [Pandaria 5.4.8 version](https://github.com/xxciv/zrpandaria548/tree/main/client/ZRProfessions).

Status: confirmed working in game on 2026-10-10 (version 2.1). Trainers teach a 3rd profession, and the panel and
**All professions** button work.

## Why an addon is needed

The server already supports more than 2: `MaxPrimaryTradeSkill` in `worldserver.conf` sets how many
"free profession points" a character gets, and trainers check those points (`Trainer::CanTeachSpell`). The
8.3.7 client has the same check as 5.4.8 in `Blizzard_TrainerUI.lua`: if the second Professions-tab slot is
filled, it greys out **Train** for any new profession, whatever the server says. The Professions tab also
only has 2 primary slots, because the client only stores 2 profession skill lines, so a 3rd and 4th
profession never appear there.

This addon:
- Re-enables **Train** for a new primary profession while you know fewer than 4.
- Fixes the "learn this profession?" popup, which has no text for when you already know 2.
- Adds a **Primary Professions** panel (`/profs`, `/zrprofs`, or the **All professions** button under the
  Professions tab) listing every primary profession you know with its current expansion skill, for example
  "Kul Tiran Alchemy 30/175". Hover a row to see every expansion's skill. Click a crafting profession or
  Mining to open its window. Herbalism and Skinning have no window; they work on nodes and corpses as normal.

## Install

1. Server: set `MaxPrimaryTradeSkill = 4` in `~/bfa/server/etc/worldserver.conf`, then restart
   `worldserver`. Characters pick it up at their next login.
2. Each player: copy this `ZRProfessions` folder into `Interface/AddOns/` in the game folder (the one with
   `WoW Circle.exe`; create `AddOns` if it's missing), so the files are at
   `Interface/AddOns/ZRProfessions/ZRProfessions.toc` and `ZRProfessions.lua`.
3. At character select, open **AddOns** and make sure ZRProfessions is ticked.

If the server limit is not 4, change `MAX_PRIMARY_PROFESSIONS` at the top of `ZRProfessions.lua` to match.

## Changes from the 5.4.8 version

- Since 8.0 a profession has no rank spells (Apprentice to Zen Master). A trainer teaches one spell per
  profession (Alchemy is 2259), and skill is kept per expansion (Classic Alchemy up to Kul Tiran Alchemy).
  The panel shows the newest expansion you have skill in, instead of a rank name.
- The gathering tooltip fix is left out because BFA doesn't need it. On 8.3.7, nodes don't show a required
  skill level for a 3rd or 4th profession; they are only colored by difficulty.

## Good to know

- A 3rd or 4th profession is not shown on the Professions tab. Use the panel, or a macro such as
  `/cast Alchemy`. Find Herbs / Find Minerals are in the minimap tracking menu as usual.
- If you unlearn one of the 2 professions shown on the tab, a hidden one moves onto the tab after you relog
  (the server fills free tab slots when it loads your skills).
- The panel closes when you enter combat and can't be opened during it (its buttons cast spells, which the
  client locks in combat).
- `/profs debug` prints what the client reports for each profession. If the panel or the trainer misbehaves,
  that output shows why.
- Server-side limit, found in the core's code and not yet seen in game: when a character logs in, the core
  loads skills before spells, and a profession whose skill is already there doesn't use up a free point. So
  after a relog the server counts no professions as used, and the addon's count of 4 is what stops a 5th.
  A player without the addon still stops at 2, because of the client's own check.
