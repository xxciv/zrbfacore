# Patch notes

Newest first. Each entry says what changed, the exact values and files it touches, and what you need
to do to pick it up (rebuild, restart, run SQL).

## 2026-11-04/05 (Holidays: calendar and schedules)

On branch `claude/project-thread-lzgnii`, not merged yet.

### Darkmoon Faire: NPC audit (gossip, flags, quests, vendors)

From Four, 2026-11-06 ("review every quest giver and merchant, make sure they're flags are
correct, interactable, and have quests that lead to something. ensure their gossips lead
somewhere, locales are enUS", "check items too for merchants/vendors"). Checked all 62 creatures on
Darkmoon Island with a gossip, quest or vendor flag, and the Faire's event spawns elsewhere. World
SQL `sql/fixes/world/2026_11_06_00_darkmoon_faire_npc_audit.sql`, updated
`tools/bfa/darkmoon-faire-gossip.patch` (now also `DarkmoonIsland.cpp` and `DarkmoonTonk.cpp`).
Rebuild, run the SQL, restart.

- **Found:**
  - Jessica Rogers (Ring Toss), Rinling (Shooting Gallery) and Finlay Coolshot (Tonk Challenge)
    sent npc_text ids that don't exist (54485/54486, 23002/23003, 54605/54606, and 54603 for "no
    token"), so their pages showed placeholder text.
  - Gossip menus 8849 (Silas Darkmoon), 13012 (Jessica), 13018 (Mola) and the "how to play" menus
    13013/13065/13066 had options but no text row.
  - Maxima and Mola had no "How do I play?" option.
  - Ziggie Sparks (Firebird's Challenge) had gossip menu 0, so her "Ready to fly!" menu and its
    SAI never showed.
  - Christoph VonFeasel (pet tamer, quest 36471) had no gossip flag, so "Let's do battle!" could
    not show.
  - Chronos offered "DEPRECATED: Putting the Carnies Back Together Again" (29512).
  - The old Outland Faire (26 creatures, 120 gameobjects in Terokkar Forest) still spawned with the
    Faire event.
  - Vendors: every Faire vendor's list is a superset of the Pandaria 5.4.8 list (the heirloom
    vendor uses the newer heirloom items). Prize vendors (tickets) have no gold-priced items. Whether
    each item exists in this build's Item.db2 can only be seen in the worldserver's DB error log.
  - Every quest giver's quests have an ender, and all texts are English. Quests whose objective has
    no source yet: Test Your Strength 29433 (Grisly Trophy 71096 drops nowhere), Spoilin' for Salty
    Sea Dogs 29513 (no fishing loot for 73269), Tan My Hide 29519 (Staked Skin 209276 not spawned),
    Master Pit Fighter 29761 (74034 only from an unspawned object), Firebird's Challenge 36481
    (untested).
- **Changed:**
  - The three game hosts use their real texts (18284/18286, 7397/18353, 18290/18352). "No token" is
    now a whisper. "Alright." is now "I understand.", and the Shooting Gallery options match the
    database ("How does the Shooting Gallery work?", "Let's shoot!").
  - Maxima ("How do I use the cannon?", text 7790) and Mola ("How do I play Whack-a-Gnoll?", text
    18350) get an instructions page.
  - The missing gossip_menu rows are added (texts from the Pandaria DB).
  - Ziggie uses menu 16970. Her instructions menu 16972 gets npc_text 24704 (a guess from the text
    ids).
  - Christoph gets the gossip flag. Chronos no longer offers 29512.
  - The Terokkar spawns are removed; copies are kept in `zr_dmf_terokkar_creature` and
    `zr_dmf_terokkar_gameobject`.
- **Status:** untested in game.

### Darkmoon Faire: Whack-a-Gnoll barrels and score bar

From Four, 2026-11-05 ("still not fast enough. Not accurately incrementing the count on the artwork
either. Can get 26/30 - just not enough spawning"). Updated `tools/bfa/darkmoon-faire-gossip.patch`
(`DarkmoonWhackGnoll.cpp`). Rebuild, restart.

- **Found:** a barrel only took a new gnoll once its "ok to hit" aura (101996) ran out, so whacked
  barrels stayed blocked and most spawn ticks found no free barrel. The score bar (alternate power)
  was set once at the start and then only moved by the credit spell's energize, so it drifted from
  the quest count.
- **Changed:** a barrel is free as soon as no gnoll, doll or boss is alive in it (2 yd). Gnoll every
  1 s, boss every 7 s (doll stays 5 s). The score bar is set to It's Hammer Time's count at the
  start, after every whack, and once a second while you play.
- **Found (second test, "you mention a boss, but i have yet to see one. 28/30", and a video):** the
  summon spells left every unwhacked gnoll standing, so all 9 barrels filled and the 1 s gnoll
  timer took each freed barrel before the bonus gnoll (54549) or the baby (54466) found one.
  Whacked gnolls left a grey corpse in the barrel, and swinging at the corpse scored again.
- **Changed:** gnolls, babies and bonus gnolls are summoned straight from the barrel and leave
  after 4 s. A bonus gnoll or baby that finds no free barrel tries again after 0.5 s instead of
  waiting for its next turn. Dead gnolls no longer count as targets, and a whacked gnoll is
  removed after 0.5 s.
- **Status:** confirmed in game by Four (2026-11-05, "That worked perfectly!").

### Darkmoon Faire: Whack-a-Gnoll pace and reset

From Four, 2026-11-05 ("You can only realistically get 15/30 at the current rate", "You can not
succeed the first time, and the quest remains along with the count you had. This should fail").
Updated `tools/bfa/darkmoon-faire-gossip.patch` (`DarkmoonWhackGnoll.cpp`). Rebuild, restart.

- **Found:** the game spawns a gnoll every 3 s, a doll every 6 s and a boss gnoll every 10 s, so the
  one-minute game holds about 20 gnolls and 6 bosses at best. Points carried over to the next
  game, but the quest is "score 30 points in a minute".
- **Changed:** gnoll every 1.5 s, doll every 5 s, boss every 9 s. When a game ends with It's Hammer
  Time (29463) still incomplete, its count goes back to 0.
- **Status:** untested in game.

### Darkmoon Faire: Game Prize hang, Let's Keep Racing

From Four, 2026-11-05 ("Opening the Darkmoon Game Prize hangs, the box is greyed out", "Let's keep
racing - nothing happens. Crossing the start line doesn't start the race"). World SQL
`sql/fixes/world/2026_11_05_08_darkmoon_prize_ticket_as_quest_reward.sql`, updated
`tools/bfa/darkmoon-race.patch`.

- **Found:**
  - The ticket row from `2026_11_05_07` (currency 515 as loot of item 93724) hangs the client: this
    core can't hand a currency out of an item's loot window.
  - Malle also gives Let's Keep Racing! (33756), a repeatable run of the Real Race course
    (blue, green, red). The race script didn't know the quest.
- **Changed:**
  - SQL removes the currency loot row and gives 1 Darkmoon Prize Ticket (currency 515) as
    `RewardCurrencyID1` on every quest that rewards the Game Prize (29434, 29436, 29438, 29455,
    29463, 36481, 37819, 37910, 37911), as in the Pandaria 5.4.8 DB. The Game Prize keeps its
    old rare contents and is still often empty.
  - `darkmoon-race.patch`: Let's Keep Racing! uses Malle's start banner and the Real Race posts
    (no achievements, those are for The Real Race).
- **Status:** untested in game.

### Darkmoon Faire: course names, empty Game Prize

From Four, 2026-11-05 ("Malle's race worked, but I can still see the doodad's names", "the reward,
Darkmoon Game Prize, has been empty twice"). World SQL
`sql/fixes/world/2026_11_05_07_darkmoon_race_names_and_game_prize.sql`. Run the SQL, restart, delete
the client's Cache folder.

- **Found:**
  - The course bunnies have visible models (checkpoint banners, tripwire stakes, pads) and no
    name-hiding flags, so racers saw "Powerup Bunny Checkpoint" and the like over the course.
  - Darkmoon Game Prize 93724 has 14 loot rows, all independent chances of 0.5% to 8.6% (about
    29% in total), so it opened empty most of the time. The Darkmoon Prize Ticket that retail
    always puts in it (currency 515; 1 per game daily in the Pandaria 5.4.8 DB) was missing.
- **Changed:**
  - 14 course entries (75718, 75044, 74153, 74157, 74678, 74800, 74872, 75063, 74536,
    74260-74263, 74420): `type_flags` |= 0x40100000 (no name, no nameplate), `unit_flags` |=
    0x02000000 (not selectable).
  - `item_loot_template` (93724, -515, chance 100, count 1): one Darkmoon Prize Ticket in every
    prize. A negative `Item` is a currency in this core's loot loader.
- **Status:** untested in game.

### Darkmoon Faire: Dusty's strider ride at the arrival hill

From Four, 2026-11-05 ("the mechastrider mount handler at the entrance isn't interactable", "Dusty
Brandom doesn't interact"). World SQL `sql/fixes/world/2026_11_05_06_darkmoon_strider_ride.sql`.
Run the SQL, restart.

- **Found:** "Dusty" Brandom (68492, Tallstrider Handler) and two Darkmoon Striders (68491) stand
  where you arrive on the island. On retail the striders give anyone a free ride down the Darkmoon
  Path to the Faire. Here Dusty had `npcflag` 0 (no gossip) and an SAI line that talks with no
  text; the striders had no spellclick. (Earlier notes in this PR wrongly tied Dusty to the races.)
- **Changed** (values from the Pandaria 5.4.8 DB): Dusty `npcflag` 1, `gossip_menu_id` 15306 (menu
  and npc_text 21955 already in the DB), `unit_flags` 768, SAI removed. Striders `npcflag`
  16777216 (spellclick), `unit_flags` 33536, `npc_spellclick_spells` (68491, 134931, 3, 0):
  clicking one mounts you on a Darkmoon Strider (spell 134931).
- **Status:** untested in game.

### Darkmoon Faire: the strider races

From Four, 2026-11-05 ("let's start on the strider race"). Core patch `tools/bfa/darkmoon-race.patch`
(after `darkmoon-faire-gossip.patch`), world SQL `sql/fixes/world/2026_11_05_05_darkmoon_race_course.sql`.
Rebuild, run the SQL, restart.

- **Found:**
  - Malle Earnhard (74056: Welcome to the Darkmoon Races 37819, The Real Race 37910) and Patti
    Earnhard (90473: More Big Racing! 37868, The Real Big Race 37911) give the race quests, but
    nothing on the server runs a race. Retail does it with server-side spells and area triggers
    that aren't in the client files, and this database has no rows for them.
  - The client files do have the pieces: the objective credit entries (start 74536, posts
    73984/73988/74030/74031, end 74004, passed 74299), the Racing Strider mount (179750), the
    course bunnies' visual spells, Invis to Non-Racers (179303) / On a Trial (149669), and the
    achievement spells (criteria "cast spell" 179420-179617, e.g. Darkmoon Racer Roadhog 9761).
  - The Real Race posts aren't spawned. Their map coordinates come from the wiki's route guide
    (blue 26.3,66.9; green 29.5,46.1; red 43.5,50.1). Fitting its 16 checkpoint coordinates to our
    checkpoint banners matched all of them within 2 yards, which gives blue (-4152.4, 6779.6),
    green (-3894.5, 6720.1), red (-3944.1, 6459.7). The Big Race posts are the Marker Pointer
    spawns: purple 74263, green 74261, red 74262.
- **Changed:**
  - `darkmoon-race.patch` adds a player script to `DarkmoonIsland.cpp`. With a race quest in
    your log, running through the start banner (Malle's for the Real Race, Patti's for the Big
    Race) uses a Darkmoon Game Token, mounts you on the Racing Strider and starts the race. Touch
    the posts in order (a marker shows the next one), then ride back through the banner.
  - The bell tolls every 5 seconds. Your toll count is shown at each post and at the finish, and
    decides the achievements: Real Race within 25/20/15/11 tolls, Big Race within 40/35/30/25/20,
    plus Darkmoon Race Enthusiast for the first race. The toll length isn't in the client data;
    5 seconds is a guess from the achievement limits and is easy to change (`RACE_TOLL_MS`).
  - On the course: checkpoint banners give +100% speed for 3 seconds and 7 seconds of water
    walking (once each per race), dash and loot pads +100% speed for 4 seconds, jump and rocket
    pads throw you forward, blink pads move you 20 yards ahead, rotating pads pick one of
    those. Running between two tripwire stakes (within 14 yards of each other) takes your mount
    speed away for 2 seconds.
  - The race is canceled (objectives reset, token not refunded) if you die, get off the strider,
    leave the island, log out or take longer than 10 minutes.
  - SQL: removes spawn group 450 from `2026_11_05_03`, so the course spawns again, and gives the
    course bunnies (checkpoints, tripwire stakes, powerup pads) Invis to Non-Racers 179303 plus
    their powerup visual. Only racers (and GMs) see them.
  - The Racing Strider's buttons, from Four's OverrideSpellData.db2 (bar 569), are scripted as
    `spell_darkmoon_racer_button`: **Jump To Banner** (179748) leaps to the nearest checkpoint
    banner ahead of you within 100 yards and keeps you safe from tripwires for 4 seconds;
    **Lasso Powerup** (316043) uses the nearest powerup pad within 25 yards at once; **Jump To
    Racer** (179804) leaps to the nearest other racer ahead. Cooldowns are the client's.
- **Not done:** the Rocketeer, Powermonger and Wanderluster racers (toys) aren't supported, only
  the Racing Strider.
- **Status:** untested in game.

### Darkmoon Faire: Selina, jugglers, Maxima, citizens

From Four, 2026-11-05. Core patch `tools/bfa/darkmoon-faire-gossip.patch` (after
`holiday-schedule.patch`), world SQL `sql/fixes/world/2026_11_05_04_darkmoon_faire_npcs.sql`.
Rebuild, run the SQL, restart.

- **Found** (reported by Four):
  - "Selina Dourman, has a quest, cannot interact": her C++ script `npc_selina_dourman` sends
    npc_text 23004-23006, which don't exist, and her template's gossip menu 8776 has no
    `gossip_menu` row. Her real menu 13075 (guide, purchases, prize tickets, cards, attractions)
    is already in the database.
  - "Fire jugglers at the entrance, not juggling": 8 jugglers in pairs (55220/55221 at the entrance,
    55222/55223, 55225/55226, 55341/55342) cast Juggle Torches (196717) at their partner by
    sniffed spawn guid (2099, 2104, 2142, 2145, 2187, 2189, 2212, 2219). Those guids don't exist
    here, so the spell had no target.
  - "Maxima Blastenheimer has French locale text" and "Unable to turn in game tokens": the
    `npc_canon_maxima` script has French text ("Je souhaite devenir un homme canon !") and only
    offers the launch while the daily Humanoid Cannonball (29436) is in progress. Mola
    (Whack-a-Gnoll, 29463) and Teleportologist Fozlebub (cannon teleport, 30 silver) had the same
    problem. Fozlebub also took the 30 silver without checking you had it.
  - "Horde Children / Citizen are hostile/attackable": Alliance Citizen 55347 and Horde Citizen
    55348 had `unit_flags` 512, so the other faction could attack them.
- **Changed:**
  - `darkmoon-faire-gossip.patch` (`DarkmoonCanon.cpp`, `DarkmoonWhackGnoll.cpp`): English
    options "Launch me! (Darkmoon Game Token)", "Ready to play! (Darkmoon Game Token)" and
    "Teleport me to the cannon." with a 30 silver confirm; English whispers when you have no
    token; the options show for everyone (the quests still count). Fozlebub checks your money.
  - Selina 10445: `ScriptName` '', `gossip_menu_id` 13075, `unit_flags` 768.
  - Juggler SAI `target_param1` set to the partner's spawn on this server: 55220->1400016,
    55221->1400017, 55222->1400081, 55223->1400086, 55225->1400313, 55226->1400349,
    55341->1400114, 55342->1400294.
  - Citizens 55347, 55348: `unit_flags` 768 (adds IMMUNE_TO_PC, as in the Pandaria 5.4.8 DB).
- **Not changed:** the carousel (its mounts aren't seated on the moving carousel, which needs core
  transport work) and the rollercoaster (none at the retail Faire as far as we know; asked Four).
- **Status:** untested in game.

### Darkmoon Faire: missing from the calendar, and on the wrong days

From Four, 2026-11-04. Core patch `tools/bfa/holiday-schedule.patch` (after all other patches),
world SQL `sql/fixes/world/2026_11_04_00_darkmoon_faire_first_sunday.sql`, hotfix SQL
`sql/fixes/hotfixes/2026_11_04_00_darkmoon_faire_calendar.sql`.

- **Found** (reported by Four: "I don't really see it on the calendar"):
  - The server sends no holidays to the calendar. The client draws them from its own Holidays.db2.
    In the 8.3.7 client (Four's file), the Darkmoon Faire, holiday 479, only has 18 dates, from
    July 2019 to December 2020. So nothing showed in 2026. The hotfix database had no row 479.
  - On the server, the Faire is game event 3. Upstream's `2026_08_16_01_fix_game_events.sql` gave it
    a start of 2026-09-06 10:01, every 30 days (`occurence` 43200), 7 days long. Months aren't 30
    days long, so the start day slid away from the retail first Sunday of the month by about 5 days
    a year. The core's `game_event` only supports fixed periods.
- **Changed:**
  - `holiday-schedule.patch` changes `src/server/game/Events/GameEventMgr.cpp`, in
    `CheckOneGameEvent`, `NextCheck`, `StopEvent` and `LoadFromDB`. A `game_event` row with
    `occurence` 0 is now a monthly event: it starts on the first Sunday of every month, at the time
    of day of its `start_time`, and runs for `length` minutes. Before, `occurence` 0 divided by zero.
    No row used it.
    - `.event start 3` runs the event for its length from now.
    - `.event stop 3` stops the current month's run until it would have ended.
    - At startup the log says "game event id (3) runs monthly from the first Sunday at 00:00".
  - `game_event` 3: `start_time` 2026-09-06 10:01 -> 2026-11-01 00:00, `occurence` 43200 -> 0,
    `length` 10080 (7 days, unchanged), `end_time` 2030-12-31 17:00 -> 2037-12-31 23:59.
    Event 23 (Darkmoon Faire Building) has no spawns or scripts, so it is unchanged.
  - Hotfix: `holidays` row 479 is the client's own row (name, description, textures, durations 48 h
    + 168 h, calendar flags 0/3) with 26 new dates. Each date is the Friday 00:00 before a first
    Sunday, from the Faire of 2026-11-01 to the Faire of 2028-12-03. `hotfix_data` row: Id 9000479,
    table hash 1972272076 (Holidays.db2), record 479. The calendar shows each Faire from Sunday 00:00
    for 7 days. Holidays.db2 holds at most 26 dates, so the calendar needs new dates again for 2029.
    The server schedule doesn't.
- **Status:** compiled (GameEventMgr.cpp), not tested in game yet.

### Darkmoon Island: the strider race course visible to everyone

From Four's visit, 2026-11-05 (screenshots of "Powerup Bunny Checkpoint" arches and "Powerup Bunny -
Trap - Tripwire - NOT MECHANICAL" posts all over the paths, with GM mode off). SQL only:
`sql/fixes/world/2026_11_05_03_darkmoon_race_course_hidden.sql`.

- **Found:** the course of the island's strider race is spawned, 290 creatures. That's the
  checkpoints, power-up crates, tripwires, marker arrows and start bunnies, with visible models
  and no trigger flag. On retail only racers see them. The race itself has no scripts here.
  "Dusty" Brandom (68492) has no gossip and npcflag 0.
- **Changed:** every map 974 spawn of 74153, 74157, 74678, 74800, 74872, 75063, 75044, 75718,
  74260-74263, 74420 and 74536 goes into new spawn group 450, "Darkmoon Island - strider race
  course", with flag 0x04 (manual spawn). The core keeps those spawns despawned until a script
  turns the group on. The rows are selected from the live `creature` table, so no guid list is
  hard-coded.
- **Next:** the race itself (Four, 2026-11-05: "yes after").
- **Status:** not tested in game yet.

### Darkmoon Island: Portal Back hung the client on the loading screen

From Four's visit, 2026-11-05. SQL only: `sql/fixes/world/2026_11_05_02_darkmoon_portal_back.sql`.

- **Found** (reported by Four: taking the portal back out left the client stuck on the loading screen):
  - Portal Back (gameobject 216667, 2 spawns on Darkmoon Island) is a spellcaster gameobject. Its
    own spell, 101260 To the Staging Area!, already sends Horde to Mulgore and Alliance to Elwynn
    (`spell_darkmoon_staging_area_teleport`).
  - It also had SmartAI that, on the same click, cast 101260 again and 103582 (Mulgore, map 1). So
    an Alliance player got teleports to Elwynn and to Mulgore at the same time.
- **Changed:** both `smart_scripts` rows of 216667 (source type 1, ids 0 and 1) are deleted, and
  `gameobject_template` 216667 `AIName` 'SmartGameObjectAI' -> ''.
- **Status:** not tested in game yet.

### Darkmoon Faire: Fire Jugglers throwing torches at players and NPCs

From Four's visit to the Elwynn Faire camp, 2026-11-05. SQL only:
`sql/fixes/world/2026_11_05_01_darkmoon_fire_juggler_torches.sql`.

- **Found** (reported by Four: the torches home in on the nearest NPC or player, some at Four,
  others at the Greeter):
  - Fire Jugglers carry aura 102905 (template addon of 55089, 55093, 55225 and 55397). Every 0.7
    seconds it casts Juggle Torch, 102882. That's a dummy spell whose torch flies to a "nearby unit
    of an entry" (target 38) within 20 yards. Which entry is meant to come from `conditions`, and
    the dump has none for 102882. So the core took any nearby unit: players, the Greeter, the Fire
    Eater.
  - Read from the client's SpellEffect.db2.
- **Changed:** 13 `conditions` rows (source type 13, group 1, entry 102882, condition 31 type 3).
  The torch may now only target a Fire Juggler: 55089, 55093, 55220-55226, 55341, 55342, 55397,
  55398. The jugglers stand in pairs about 18 yards apart, so the torches stay with the jugglers.
- **Status:** not tested in game yet.

### Holidays that move every year: missing from the calendar, and two never ran

From Four, 2026-11-05 ("please do them all"). Same core patch (`holiday-schedule.patch`, which was
first written for the Faire alone), world SQL `sql/fixes/world/2026_11_05_00_holiday_dates_schedule.sql`,
hotfix SQL `sql/fixes/hotfixes/2026_11_05_00_holiday_calendar_dates.sql`.

- **Found:**
  - In the client's Holidays.db2, six holidays have dates only up to 2020 (Lunar Festival up to 2024),
    so none of them shows on the 2026 calendar: Lunar Festival 327, Love is in the Air 423,
    Noblegarden 181, Children's Week 201, Harvest Festival 321, Pilgrim's Bounty 404. Hallow's End,
    Winter Veil, Midsummer, Brewfest, Pirates' Day, Day of the Dead and the 4th of July fireworks use
    "any year" dates and were already fine.
  - On the server, upstream's `2026_08_16_01_fix_game_events.sql` never updated game events 7
    (Lunar Festival), 26 (Pilgrim's Bounty) or 72 (Fireworks Spectacular). They still ended in 2020,
    so they never ran. The others repeat every 365 days (Noblegarden 364), so Easter-based
    Noblegarden drifts by weeks.
- **Changed:**
  - `holiday-schedule.patch`: `occurence` 1 means "start on each date of the event's holiday in
    Holidays.db2". It reads the dates from the server's own copy, hotfixes included, so the server
    runs on the dates the calendar shows. An "any year" date repeats every year. Each run lasts
    `length`. At startup the log says "game event id (N) runs on the dates of holiday H". An event
    with `occurence` 1 and no holiday logs an error and never starts.
  - Hotfix rows 327, 423, 181, 201, 321 and 404 are the client's own rows, with five dates each
    (2026 to 2030, 10:00). 2030 is the last year a Holidays.db2 date can hold. `hotfix_data` ids
    are 9000000 + holiday id. The rules:
    - Lunar Festival: 2 days before the lunar new year (2026-02-15, 2027-02-04, 2028-01-24,
      2029-02-11, 2030-02-01).
    - Love is in the Air: the first Monday on or after 7 February.
    - Noblegarden: Easter Monday (as in every client date from 2015 to 2020).
    - Children's Week: the Monday between 28 April and 4 May.
    - Harvest Festival: the second Tuesday of September.
    - Pilgrim's Bounty: the Monday of Thanksgiving week (as in every client date from 2015 to 2020).
    The Lunar Festival, Love is in the Air, Children's Week and Harvest Festival rules are close fits
    to the client's 2015-2020 dates. Retail moved those around from year to year.
  - `game_event` 7, 8, 9, 10, 11, 26 and 72: `occurence` -> 1, `start_time` -> 2026-01-01 00:00
    (only used by `.event start`), `end_time` -> 2037-12-31 23:59. `length` is unchanged. Fireworks
    (72, holiday 62, "any year" 4 July 10:00) now runs every year again.
- **Not done:**
  - Timewalking (holidays 559, 562, 587, 643). The server's events 100-103 are switched off
    (they end in 2020 or start and end in 2030), and Timewalking dungeons need their own work.
  - Brew of the Month (34-45) and the Kalu'ak Fishing Derby (63, 64) also ended in 2020.
  - The fixed-date holidays still repeat every 365 days, so they slip one day per leap year
    (first in 2028).
- **Status:** compiled (GameEventMgr.cpp), not tested in game yet.

## 2026-11-04 (pet battles)

### Pet battles: some wild pets ignore their zone's level range

- **Found** (asked by Four): Pet Tracker's map says Elwynn Forest pets are level 1-2. Are they all?
- **Cause:** `WildBattlePetMgr::EnableWildBattle` rolls a wild pet's level between
  max(`battlepet_info.minlevel`, zone min) and max(`battlepet_info.maxlevel`, zone max). The zone
  range comes from the client's AreaTable. Almost every wild pet template is 1-1, so the zone
  decides. 30 wild pet templates were 5-5 or 1-25 instead:
  - 5-5: Fawn 61165 (every Elwynn and Teldrassil fawn was level 5, zone 1-2), Snow Cub 61689,
    Infected Fawn 61827, Shimmershell Snail 62246.
  - 1-25 (could roll from the zone minimum up to 25): Tiny Harvester 61160, Little Black Ram 61459,
    Tiny Twister 61703, Blighthawk 61826, Ruby Sapling 62020, Ravager Hatchling 62051, Creepy Crawly
    62116, Venomspitter Hatchling 62191, Silithid Hatchling 62258, Minfernal 62317, Diemetradon
    Hatchling 62375, Nether Faerie Dragon 62395, Qiraji Guardling 62526, Flayer Youngling 62555,
    Fjord Worg Pup 62669, Stunted Shardhorn 62816, Imperial Eagle Chick 62819, Wildhammer Gryphon
    Hatchling 62900, Stowaway Rat 62921, Shore Crawler 63097, Gilnean Raven 63098, Harpy Youngling
    68804, Arcane Eye 68819, Infinite Whelpling 68820, Anodized Robo Cub 68839, Cogblade Raptor 68841.
- **Changed:** new `sql/fixes/world/2026_11_04_50_wild_battle_pet_zone_levels.sql` sets `minlevel`
  and `maxlevel` to 1 for those 30 `battlepet_info` rows, so they follow their zone like every other
  wild pet. The old values are listed in the file's header. Tamer team pets and companion entries
  are not touched. No core change.
- **Status:** run on Four's live DB and confirmed in game by Four on 2026-11-04.

#### To pick it up
SQL only, then a restart (levels are rolled when a pet spawns).
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-cwgt5u
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_04_50_wild_battle_pet_zone_levels.sql | mysql -u root -p bfa_world
```
The last line prints `30 wild pet templates set to 1-1`. Then restart `worldserver`.

## 2026-11-04 (World fixes)

### World: Battlescar fliers fight each other in mid-air; Fort Triumph laborers slide and get blasted

- **Found** (Four, after SQL 31): some wind riders and gryphons fight each other in mid-air without
  riders on their backs. At Fort Triumph, a sleeping laborer slides around on the scaffolding and the
  other laborers keep getting thrown around next to the effect bunny.
- **Cause:**
  - Desolation Wind Rider 37974 (faction 29) and Triumph War Gryphon 37978 (faction 894) are hostile
    to each other, so they attack where their new flight routes cross. The riders die in those
    fights, and the mount flies on empty until it respawns.
  - The 12 Peasant Laborers 39129 and 3 Mizzy's Apprentices 39124 at Fort Triumph, and the 11
    Desolation Guards 38070, wander 3 yards (MovementType 1). MaNGOS Three has all of them standing
    still. The laborer script naps (actionlist 3912900: Sleep 6431 for 30 s), so a sleeping laborer
    slides along the boards.
  - The blasting is bunny 35845's Legion knockback 206750 (its id 3 timer row). The laborer script
    only expects knockback 177984. See SQL 37.
- **Changed:** `sql/fixes/world/2026_11_04_32_battlescar_fort_workers_and_air_fights.sql`:
  - `unit_flags |= 0x200` (IMMUNE_TO_NPC) on 37971, 37974, 37977 and 37978, so the mounts and their
    riders ignore other NPCs. Players can still fight them.
  - MovementType 0, spawndist 0 on the 26 spawns listed in the file.
- **Status:** confirmed in game by Four (2026-11-04): fliers keep their riders, no more sliding.
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
```

```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_04_32_battlescar_fort_workers_and_air_fights.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### World: Battlescar fliers hang still in the sky and the patrols stand still

- **Found** while looking into the Battlescar with Four (see
  `/mnt/project-files/world-fixes/battlescar.md` in the project for the whole picture).
- **Cause:** our Battlescar spawns are the same spawns as the MaNGOS Three Cataclysm DB (same guids,
  same positions), but our dump lost the waypoint paths of 27 of them, which were left at
  MovementType 0. The wind riders' and gryphons' riders were spawned on their own in mid-air
  (z 110-145) with random movement instead of riding their mounts.
- **Changed:** `sql/fixes/world/2026_11_04_31_battlescar_fliers_and_patrols.sql`:
  - New paths 485500001-485500027 (from MaNGOS Three `creature_movement`), with creature_addon
    `path_id` and MovementType 2:
    - 6 Desolation Wind Riders 37974 (269007, 269009, 269011, 269013, 269015, 269017) and
      6 Triumph War Gryphons 37978 (269019, 270158, 270332, 270334, 270343, 270347): flight
      routes of 33-54 points, run speed.
    - 3 Desolation Raiders 37922 (269585, 270589, 270667), 2 Triumph Vanguards 37923 (269077,
      270905), 5 Sapper Specialists 37925 (270711, 270780, 270827, 270850, 270851) and 5 Barrens
      Operatives 37924 (269147, 269148, 269149, 270197, 270336): walking patrols of 4-8 points.
  - `vehicle_template_accessory`: Desolation Sky Render 37971 rides seat 0 of the Wind Rider
    37974, and Wildhammer Mercenary 37977 rides seat 0 of the War Gryphon 37978. The gryphon's
    script already expects a rider ("Passenger Boarded").
  - The 12 loose mid-air riders are deleted (37971: 269008, 269010, 269012, 269014, 269016,
    269018; 37977: 269020, 270159, 270333, 270335, 270344, 270348). The stray Mercenary 200478
    in the Eastern Kingdoms is left alone.
- **Not fixed (no data):** the flag capture (events 23033/23034 do nothing, here and in MaNGOS
  Three), the gryphon Hook Shot (no caster), and the sapper suicide runs into Fort Triumph (their
  trigger spawns 92564-92569 and paths 3792500-3792505 are missing).
- **Status:** patrols confirmed in game by Four (2026-11-04). Fliers flew with riders, but mid-air fights killed riders; fixed in SQL 32 (confirmed).
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
```

```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_04_31_battlescar_fliers_and_patrols.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### World: Claim the Battlescar never completes ("Scout out the flag marker")

- **Found** while looking into the Battlescar with Four (Southern Barrens, between Fort Triumph and
  Desolation Hold).
- **Cause:** Claim the Battlescar (Alliance 25081, objective 259939) and Claim the Battle Scar
  (Horde 24618, objective 266351) have an area objective (type 10, ObjectID -1) next to "kill 10".
  Nothing completes it: there is no `areatrigger_involvedrelation` row and no script. The core only
  sets a type-10 objective from `Player::AreaExploredOrEventHappens`, so both quests stay
  incomplete forever. (The 4.3.4 quest in the MaNGOS Three DB was kill-only; the scouting step came
  later and was never wired up.)
- **Changed:** `sql/fixes/world/2026_11_04_30_claim_the_battlescar_scout_flag.sql`: a per-spawn
  script on the invisible bunny that stands on the flagpole (35845, guid 269123, -3244.4 -2002.5):
  SMART_EVENT_OOC_LOS (non-hostile, 15 yards, 1 s cooldown) -> SMART_ACTION_CALL_AREAEXPLOREDOREVENTHAPPENS
  for 25081 (id 0) and 24618 (id 1), target the player. A player without the quest gets nothing.
  Because a per-spawn script replaces the entry script, this one bunny also stops running 35845's
  Legion timer rows (the zap at the closest player).
- **Status:** confirmed in game by Four (2026-11-04).
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
```

```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_04_30_claim_the_battlescar_scout_flag.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

## 2026-11-03 (World fixes, second batch)

### World: invisible effect bunny zaps nearby players and keeps them in combat

- **Found** (reported by Four, Southern Barrens near the Sapper Specialists): a lightning-like
  effect hits you and you stay in combat with "Dave's Industrial Light and Magic Bunny
  (Small)(Sessile)" (35845, spawn 269123).
- **Cause:** 35845 is a generic invisible effect bunny with 144 spawns (Broken Isles 33, Draenor 44,
  Mount Hyjal 17, Southern Barrens 9 and more). Its entry script mixes rows from unrelated uses, and
  three Legion rows run on a timer (event 60, in and out of combat) on every spawn: id 3 casts
  206750 (damage + knockback around the bunny) every 3-8 s, id 5 sends data to Azuregos 104902 (a
  Broken Isles NPC), id 8 casts 199886 on the closest player within 100 yards every 2-3 s.
- **Changed:** `sql/fixes/world/2026_11_03_37_bunny_35845_legion_rows_map_only.sql`: SMART_EVENT
  conditions (source 22, groups 4, 6 and 9, CONDITION_MAPID 22 on the bunny itself) so ids 3, 5 and
  8 only run on map 1220 (Broken Isles). The data-triggered rows are untouched.
- **Status:** back on (2026-11-04). The Battlescar investigation showed the same rows misfiring at
  Fort Triumph: bunny 269877 zaps players and knocks the scaffolding laborers around with 206750.
  Neither the Battlescar nor Fort Triumph scripts use these spells. Confirmed in game by Four
  (2026-11-04): lightning and explosions gone.
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
```

```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_03_37_bunny_35845_legion_rows_map_only.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### World: Stonetalon oil pumps wander and the Krom'gar balloon sinks into the lake

- **Found** (reported by Four, Mirkfallon Lake): the Oil Pumps walk around, and the Krom'gar Hot Air
  Balloon sits half under water.
- **Cause:** Oil Pump 41475 (11 spawns, the targets of Schemin' That Sabotage 25878) had
  MovementType 1 with spawndist 3. The balloon 41418 (guid 272501, spawned at z 148.2) has
  InhabitType 3 (ground + water), so it falls into the lake. The Pandaria DB has the pumps still
  with InhabitType 7 and the balloon at InhabitType 4 (air). The pumps' size is their normal model
  (scale 1 in both DBs).
- **Changed:** `sql/fixes/world/2026_11_03_36_stonetalon_oil_pumps_balloon.sql`: 41475 spawns
  MovementType 1 -> 0 and spawndist 3 -> 0, template InhabitType 3 -> 7; 41418 template InhabitType
  3 -> 4.
- **Not changed:** the big fire Four saw at 1497.8, 1006.2: no creature or gameobject is spawned
  within 50 yards in the DB, so it is part of the client's map art (inferred).
- **Status:** confirmed in game by Four on 2026-11-04.
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
```

```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_03_36_stonetalon_oil_pumps_balloon.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### World: Sapper Specialist never uses Sapper Charge

- **Found** (reported by Four while testing the per-spawn script entry below): the Sapper Specialist
  (37925, Southern Barrens) throws dynamite but never blows himself up at 10% HP.
- **Cause:** Sapper Charge (82867) hits a spot at an enemy (implicit target 53,
  TARGET_DEST_TARGET_ENEMY) and then kills the caster. The SmartAI rows cast it on target_type 1
  (self), which is not an enemy, so every cast failed. The entry also mixed two script versions:
  ids 0 and 1 existed twice, so the aggro link to id 1 could land on the wrong row.
- **Changed:** `sql/fixes/world/2026_11_03_35_sapper_specialist_sapper_charge.sql`: old-version rows
  deleted (id 0 'Cast Throw' timer, id 1 'Cast Sapper Charge at 10% HP'); id 16 'Cast Sapper Charge
  at 10% HP' target_type 1 -> 2 (victim). Row 29 (the scripted run that blows up next to the Triumph
  defenders) is unchanged. Spawns 270777, 270847 and 270852 get a fresh copy of the entry script
  (from `2026_11_03_34`).
- **Status:** confirmed in game by Four on 2026-11-04.
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
```

```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_03_35_sapper_specialist_sapper_charge.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### World: zone entry quests hidden unless you picked up a breadcrumb (67 quests)

- **Found** (Four asked for a sweep after Rerouted!, 2026-11-03): the same lock as Officer Jankie's
  Rerouted! (14384) exists in many zones.
- **Cause:** the core turns `quest_template_addon.PrevQuestID` and every quest whose `NextQuestID`
  points at a quest into hard requirements (`ObjectMgr::LoadQuests` -> `prevQuests`;
  `Player::SatisfyQuestPreviousQuest` needs one of them rewarded). For 67 zone entry quests every
  such requirement is a breadcrumb: a Hero's Call / Warchief's Command board quest, or a talk-only
  quest (no objectives) that starts outside the zone. Arriving without one hid the first quest.
  Upstream already fixed Westfall (26209) this way; Desolace (14384, 14184) is in
  `2026_11_03_30`. Quests where one of the requirements is a real or in-zone step (28 found, for
  example In Defense of Far Watch 871 after Conscript of the Horde 840) are left alone.
- **Changed:** `sql/fixes/world/2026_11_03_33_zone_entry_quests_no_breadcrumb.sql`: on 65 quests
  `PrevQuestID` -> 0 where it named one of its breadcrumbs, and `NextQuestID` -> 0 on 115
  breadcrumbs that pointed at them. Each quest and its breadcrumbs are listed in the file. Examples:
  The Forsaken 9329 (Ghostlands), Alien Predators 9634 (Bloodmyst), Hellscream's Vigil 11585 and
  Enlistment Day 11672 (Borean Tundra), The Last Wave of Survivors 13518 (Darkshore), Signs of
  Change 25210/25447 (Feralas), The Lost Pilot 26854 (Loch Modan), The Maelstrom 27203 (Deepholm),
  The Road to Kun-Lai 31254/31255. The breadcrumbs stay available and still turn in at the same NPC.
- **Status:** confirmed in game by Four on 2026-11-03 (The Lost Pilot, The Last Wave of Survivors,
  The Stolen Keg, Northfold Manor and Signs of Change all offered without a breadcrumb).
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
```

```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_03_33_zone_entry_quests_no_breadcrumb.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### World: 40 spawns with a cosmetic per-spawn script never ran their own script

- **Found:** follow-up to the Fel Hands rows (`2026_10_31_05`). The same importer left a second kind
  of one-row per-spawn script (comment 'OOC - CS') on 40 spawns, mostly in Stonetalon Mountains,
  Southern Barrens, Silithus, Dustwallow Marsh and Orgrimmar.
- **Cause:** each casts a cosmetic spell out of combat (dummy auras 39550, 54219, 111541, 146130,
  180695, 183940, 185340, 217193, or dummy-effect 217160 aimed at a nearby bunny). These may be real
  retail visuals, but a per-spawn script replaces the creature's own script, so these spawns never
  cast in combat, fled or said their lines, and Tortolla (41504, guid 293563) in Mount Hyjal never
  ran 'Teleport on Quest Add'.
- **Changed:** `sql/fixes/world/2026_11_03_34_cosmetic_spawn_scripts_keep_entry_script.sql`: each
  spawn's entry script is copied under its per-spawn script with `id` and `link` + 1000, next to the
  cosmetic row (id 0), so both run. It copies from the live table when applied; re-running replaces
  the copies. Spawns and entries are listed in the file (for example Lumbering Oaf 40906, Sapper
  Specialist 37925, Razormane Pathfinder 37560, Orgrimmar Grunt 3296).
- **Status:** confirmed in game by Four on 2026-11-03: the Sapper Specialist now throws dynamite.
  Its Sapper Charge was broken in the entry script itself, see the next entry.
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
```

```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_03_34_cosmetic_spawn_scripts_keep_entry_script.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

## 2026-11-03

Merged to `main` with PR #37 on 2026-11-03.

### World: Nijel's Point is packed with Defenders (some on fire) and extra Merchants

- **Found** (reported by Four): Nijel's Point in Desolace is crowded with Nijel's Point Defenders,
  several of them burning, and many copies of Nijel's Point Merchant.
- **Cause:** Nijel's Point Defender (35506, 119 spawns) and Nijel's Point Merchant (35510, 10
  spawns) are the targets of the Horde quest Rider on the Storm (14198: kill 40 Defenders and burn
  15 Merchants while riding the firestorm). Like the Astranaar siege, they have no phase, so every
  player sees the raid crowd in the town. 11 Defenders also keep the sniffed fire visual (aura
  42726). The two entries were also listed as quest givers for 14198, which really starts at the
  Ancient Vortex Runestone (gameobject 195445).
- **Changed:** `sql/fixes/world/2026_11_03_32_nijels_point_raid_phase.sql`:
  - All 35506 and 35510 spawns: `PhaseId` 0 -> 303 (a normal Phase.db2 phase used nowhere else).
  - `phase_area` (608, 303) plus a condition (type 26, quest state 47, quest 14198, mask 10):
    phase 303 shows only while Rider on the Storm is in progress or complete.
  - `creature_addon.auras` '42726' -> '' on guids 309531, 309912, 310167, 310400, 310426, 310485,
    310542, 310635, 310659, 310677 and 310741.
  - `creature_queststarter` rows (35506, 14198) and (35510, 14198) deleted.
  - The town's own guards (8151 x18, 51839 x8), its named NPCs and the vortex bunnies are untouched.
- **Status:** confirmed in game by Four on 2026-11-03 (Alliance view: raid crowd gone).
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_03_32_nijels_point_raid_phase.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### World: Rerouted! (Desolace) gives no mount to ride

- **Found** (reported by Four): after taking Rerouted! from Officer Jankie, there is no mount.
- **Cause:** nothing is scripted. Jankie (36410), Jankie's Mount (36416/36419), Furien (35286) and
  Furien's Mount (35287) have no SmartAI rows, spellclick or waypoint path in this DB (or the Pandaria
  one), and none of the mounts is set up as a vehicle. The only retail trace is spell 68693, which
  summons 36419 next to Jankie (`spell_target_position` 171.4, 1793.5, 86.2).
- **Changed:** `sql/fixes/world/2026_11_03_31_desolace_entry_flights.sql`, a stand-in for the flight:
  - Jankie 36410 SAI id 0: on accepting 14384, teleport the player to Corporal Melkins at Nijel's
    Point (map 1, 129.0, 1235.5, 163.6).
  - Furien 35286 SAI id 0 (Horde): on accepting My Time Has Passed (14184), teleport to Cerelia at
    Furien's Post (map 1, -427.6, 2229.9, 89.5).
- **Status:** Alliance side (Jankie teleport) confirmed in game by Four on 2026-11-03. Furien's side
  not tested (Horde only).
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_03_31_desolace_entry_flights.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### World: no quest from Officer Jankie (or Furien) at the Desolace entrance

- **Found** (reported by Four): Officer Jankie (36410) at Tethris Aran shows no quest marker.
- **Cause:** her quest Rerouted! (14384), which flies you to Nijel's Point and starts Alliance
  Desolace, could only be taken after a breadcrumb. It had `quest_template_addon.PrevQuestID` = 25938
  (Help for Desolace), and the breadcrumbs Help for Desolace (25938) and Hero's Call: Desolace!
  (28531) have `NextQuestID` = 14384, which the core also turns into a requirement on 14384
  (`ObjectMgr::LoadQuests` adds them to its `prevQuests`). Arriving without a breadcrumb gave nothing.
  The Horde side has the same lock: Furien's My Time Has Passed (14184) had `PrevQuestID` 28548 and
  Warchief's Command: Desolace! (28548) has `NextQuestID` 14184.
- **Changed:** `sql/fixes/world/2026_11_03_30_desolace_entry_quests_no_breadcrumb.sql`:
  `PrevQuestID` 25938 -> 0 on 14384 and 28548 -> 0 on 14184; `NextQuestID` 14384 -> 0 on 25938 and
  28531, 14184 -> 0 on 28548. The breadcrumbs still turn in at Jankie and Furien.
- **Status:** confirmed in game by Four on 2026-11-03 (Rerouted! offered by Jankie without a
  breadcrumb). Furien's side not tested (Horde only).
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_03_30_desolace_entry_quests_no_breadcrumb.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

## 2026-11-03 (Holidays)

Merged to `main` with PR #35 on 2026-11-03.

### Day of the Dead: dancing with Catrina gave no skeleton and no Dead Man's Party

From Four, 2026-11-03. SQL only: `sql/fixes/world/2026_11_03_20_holiday_emote_casts.sql`.

- **Found** (reported by Four): `/dance` with Catrina (34383) during Day of the Dead did nothing, so
  achievement 3456 Dead Man's Party never came.
  - The achievement has one criterion (10918, type 69 "be spell target") for spell 65386 Honor the
    Dead, the skeleton transform. The core credits it when that spell hits the player.
  - Catrina's SmartAI row (event 22 receive emote, emote 34 dance, action 11 cast 65386) has
    `target_type` 0 (none). SmartAI finds no target for that, so she never cast the spell.
  - A scan of every receive-emote cast row in the dump found one more with the same mistake: Winter
    Reveler (15760, Winter Veil), who should cast Mistletoe (26218) on a player who `/kiss`es him.
- **Changed:** `target_type` 0 -> 7 (the player who did the emote) on both rows:
  `smart_scripts` 34383/0/0/0 and 15760/0/0/0.
- **Status:** Catrina confirmed in game by Four on 2026-11-03 (skeleton transform and Dead Man's
  Party awarded). Winter Reveler not tested yet: Winter Veil starts 2026-12-15 on this server.
## 2026-11-03 (Transmog apply)

Merged to `main` with PR #34 on 2026-11-03. Core change in the new `tools/bfa/transmog-apply.patch`,
applied after all the other patches. It needs `transmog-collection.patch`.

### Apply at the transmogrifier did nothing
- **Found** (reported by Four): Apply at the transmogrifier stopped doing anything. Every check in
  `WorldSession::HandleTransmogrifyItems` (`TransmogrificationHandler.cpp`) ends the request with a
  debug log line only, and one refused slot cancels the whole request, so a refusal looks like nothing
  happening. One check, `Player::CanUseItem(itemTemplate)` on the item the appearance comes from,
  refuses the very appearances `transmog-collection.patch` lets you collect: items above your level
  (`Transmog.CollectIgnoreLevel`) and items your class, race or faction can't use
  (`Transmog.CollectAnyClass`). The client offers every collected appearance, so picking one of those
  breaks Apply for every slot.
- **Changed:** `TransmogrificationHandler.cpp`, `HandleTransmogrifyItems`:
  - With `Transmog.CollectAnyClass` 1 the `CanUseItem` check is skipped. With it 0 and
    `Transmog.CollectIgnoreLevel` 1, it skips only the required level (`CanUseItem(itemTemplate, true)`).
    With both 0 it is the stock check. `Item::CanTransmogrifyItemWithItem` is unchanged, so the
    appearance still has to match the item's armor type, weapon type and slot.
  - Every refusal now also prints `Transmogrify refused: <reason>` in chat: transmogrifier out of reach,
    bad slot, nothing equipped, unknown or uncollected appearance, an item you can't use (with its
    `InventoryResult`), an appearance that doesn't fit the item, illusion problems, or not enough money.
  - No SQL, no new settings.
- **Status:** confirmed in game by Four on 2026-11-03: Apply works again.

### To pick up the transmog apply fix
Everything is on `main` now. If you applied the patch from the PR branch, the file on `main` is the same,
so nothing needs rebuilding; just pull:
```
git -C ~/bfa/tools-repo checkout main
git -C ~/bfa/tools-repo pull
```

Without it applied yet, add the new patch. Only one file changes, so the build is short. There's no SQL:
```
cd ~/bfa/source
git -C ../tools-repo checkout main
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/transmog-apply.patch
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
Then type `server shutdown 1` in the worldserver console and start it again with
`cd ~/bfa/server/bin && ./worldserver`.

## 2026-11-03 (Razorfen Downs)

Merged to `main` with PR #26 on 2026-11-03.

### Razorfen Downs: Koristrasza dropped to the ground wherever she was put

From Four's run, 2026-11-03. SQL only: `sql/fixes/world/2026_11_03_03_razorfen_downs_koristrasza_flying.sql`.

- **Found** (reported by Four, while moving her off a vine with `.npc move`): Koristrasza (44843)
  plays a flying animation, but her template only allowed ground and water (InhabitType 3). So the
  server dropped her to the floor below wherever she was placed.
- **Changed:** InhabitType 4 (air), so she hovers where she is placed. Her spawn is moved to the spot
  Four picked in game: 2369.33, 1020.62, 69.84.
- **Status:** confirmed in game by Four on 2026-11-03.

### Razorfen Downs: Blackthorn's Summon Skeletons summoned nothing

From Four's run, 2026-11-03. SQL only: `sql/fixes/world/2026_11_03_02_razorfen_downs_blackthorn_skeletons.sql`.

- **Found** (reported by Four): Death Speaker Blackthorn cast Summon Skeletons, but no skeletons
  came. His script casts 150601, which only puts a dummy aura on him. The server-side script that
  should then summon is missing. The spell that actually summons is 150603 (Summon Skeletons: a
  Splinterbone Warrior, 74902, at the caster).
- **Changed:**
  - He casts 150603 three times, from 70% health and then every 20-35 seconds as before.
  - The warriors get the scaling row for the dungeon's difficulty.
- **Status:** confirmed in game by Four on 2026-11-03 ("much more fun and challenging").

### Razorfen Downs: Amnennar never appeared after Blackthorn died

From Four's run, 2026-11-03. SQL only: `sql/fixes/world/2026_11_03_01_razorfen_downs_amnennar_summon.sql`.

- **Found** (Four's `.debug scenario`): the first two steps completed. The three lieutenants were
  done, and Blackthorn's step was at state 3, so `razorfen-downs.patch` works. But Amnennar never
  appeared.
  - Blackthorn's death row says a line and links to the row that summons Amnennar. That summon row
    only runs through the link.
  - None of the Warlords bosses has any creature_text, so SmartAI drops every "say" row at startup.
    That took the start of the chain with it, so the summon never ran.
  - Mushlump's death row (clearing his plague triggers) and Mordresh's (opening a GO) had the same
    shape.
- **Changed:**
  - Blackthorn's summon row is now its own death event, and the say row is deleted.
  - Mushlump's and Mordresh's death rows are fixed the same way.
- **Status:** confirmed in game by Four on 2026-11-03: Blackthorn summoned Amnennar, and his corpse
  was lootable.

### Razorfen Downs: Koristrasza kept flying past

From Four's run, 2026-11-03. SQL only: `sql/fixes/world/2026_11_03_00_razorfen_downs_koristrasza.sql`.

- **Found** (reported by Four): Koristrasza (44843, guid 325205), a friendly blue dragon from the
  Cataclysm quest line, kept showing up on the trail. She is parked high above the dungeon.
  `2026_10_31_01` gave her the Pandaria database's waypoint path, which is a one-way flight from her
  perch down to the trail. Run as a loop, it made her dive through the dungeon over and over.
- **Changed:** her path (129000018) is removed and she stays on her perch.
- **Status:** confirmed in game by Four on 2026-11-03: she stays put. She clips into a vine there; Four
  may move her with `.npc move` in their own database.

### Razorfen Downs: Lady Falther'ess still only meleed (and Ragglesnout never cast)

From Four's first run, 2026-10-31. SQL only: `sql/fixes/world/2026_10_31_04_razorfen_downs_rare_guid_scripts.sql`.

- **Found** (reported by Four after `2026_10_31_02`, which had loaded fine):
  - Her spawn (guid 373575) and Ragglesnout's (373574) each had a per-spawn SmartAI row. It cast
    Fel Hands (207101) out of combat, a Legion dummy aura that does nothing.
  - A per-spawn script replaces the creature's own script entirely, so neither rare ever ran its
    combat rows.
  - Ragglesnout's own script also mixed two versions together.
- **Changed:**
  - Both per-spawn rows are deleted.
  - Ragglesnout's second Shadow Word: Pain, Heal and Dominate Mind (ids 10-12) are deleted. He keeps
    his bolt, Shadow Word: Pain, Heal and Dominate Mind once each.
- **Not changed:** 40 more spawns elsewhere have the same Fel Hands row. 30 of them hide their
  creature's own script: 14 in Kalimdor, 8 in the Eastern Kingdoms, 6 in Gnomeregan, 1 in Blackrock
  Depths.
- **Status:** confirmed in game by Four on 2026-11-03.

### Razorfen Downs: the idol room was a pile-up, and Withered Touch hit far too hard

From Four's first run, 2026-10-31. SQL only: `sql/fixes/world/2026_10_31_03_razorfen_downs_idol_room.sql`.

- **Found** (reported by Four):
  - **Pile-up:** the room by Plaguemaw held 32 mobs, 12 of them Withered Battle Boars. 15 of them were
    the Extinguishing the Idol event's waves saved as static spawns. They sit exactly on the three
    Idol Room Spawners, in the event's pattern of a boar or two, a Geomancer and a Quilguard. The
    Pandaria database has the same rows; the classic (AzerothCore) database has none.
  - **Withered Touch:** the spell (11442) is a damage over time that scales very high here. Every
    Withered Quilguard had it twice: an aura that procs it on melee hits (11441), and a cast every
    17-19 seconds. Plaguemaw had the same pair (aura 12947 plus the cast). Classic Quilguards and
    Plaguemaw had neither.
  - **Double casting:** Death's Head Geomancers and Withered Spearhides had two script versions
    mixed together, so they cast their spells twice as often.
- **Changed:**
  - The 15 leftover wave spawns are deleted. The room keeps its own mobs: 2 standing and 2
    patrolling Battle Boars, 2 Spearhides (one patrolling), 2 Withered Warriors, a Geomancer, a
    Battle Boar Horror, and Plaguemaw. The three spawners stay for the quest event.
  - Withered Touch is removed from every Quilguard and from Plaguemaw, both the aura and the cast.
    Quilguards keep Enrage at 30%, and Plaguemaw keeps Putrid Stench.
  - The duplicate Geomancer and Spearhide rows are deleted.
- **Status:** confirmed in game by Four on 2026-11-03.

### Razorfen Downs: Lady Falther'ess only meleed and rarely dropped an item

From Four's first run, 2026-10-31. SQL only: `sql/fixes/world/2026_10_31_02_razorfen_downs_falther_ess.sql`.

- **Found** (reported by Four: melee only, money only):
  - Lady Falther'ess (14686) is set to use SmartAI but had no script rows.
  - Her two items (23177, 23178) each rolled on their own at 20%, so 64% of kills dropped no item.
  - One of the three Idol Room Spawners (guid 325229) was given random wandering by `2026_10_31_01`.
    These are the invisible markers the Extinguishing the Idol event spawns its waves from.
- **Changed:**
  - She gets the classic combat set from the AzerothCore database: Ribbon of Souls (22743, damage
    around her), Banshee Curse (17105) on a random player, and Banshee Shriek (16838, silence and
    damage within 8 yards). Her classic disguise and Scourge Invasion start are left out.
  - Her items share one group with the Pandaria chances (43% / 56%), so one always drops.
  - That spawner no longer wanders.
- **Status:** confirmed in game by Four on 2026-11-03.

### Razorfen Downs: pre-run check

Before Four's first run. New `tools/bfa/razorfen-downs.patch` (build needed) and
`sql/fixes/world/2026_10_31_01_razorfen_downs.sql`.

#### None of the scenario bosses was spawned
- **Found** (Four's `.debug scenario` on entering): scenario 647 has three steps. "Blackthorn's
  Lieutenants" wants kills of Aarux (74412), Mordresh Fire Eye (74347) and Mushlump (74435); then
  "Death Speaker Blackthorn" (74875); then Amnennar the Coldbringer (74434). Achievement 636 is a
  kill of 74434 too. The BFA spawns are the Pandaria 5.4.8 set with the classic bosses (Tuten'kash
  7355, Mordresh 7357, Glutton 8567, Amnennar 7358), so none of these could be killed and the
  scenario was stuck on its first step.
- **Changed:** four classic boss spots now hold the new bosses:
  - Aarux replaces Tuten'kash (guid 325253), moved to 2511, 857, 47.68, the point his own script
    lands him on.
  - Mordresh 74347 replaces Mordresh 7357 on the same spot (325055).
  - Mushlump replaces Glutton (325058).
  - Blackthorn replaces Amnennar on his throne (324995). Blackthorn's script summons Amnennar 74434
    where he dies.
  - The classic bosses' auras and emote on those spots are removed, and the five get scaling rows
    for the dungeon's difficulty (1). Before, they only had rows for difficulty 0.
- **Not changed:** the gong event still works as before and summons the classic Tuten'kash, who gives
  no scenario credit. Plaguemaw the Rotting, Ragglesnout and Lady Falther'ess stay as optional
  classic bosses.

#### Blackthorn's step could never complete
- **Found:** the step's criteria (24957) waits for scenario event 38474. Nothing in this core sends
  it: spells with a send-event effect don't reach the scenario here, and SmartAI has no action for it.
- **Changed:** `razorfen-downs.patch` (`instance_razorfen_downs.cpp`, `razorfen_downs.h`): the
  instance script sends event 38474 when Blackthorn dies.

#### Boss scripts
- **Found:**
  - Aarux was friendly (faction 35). His script started him flying and unattackable until a dummy
    spell from other NPCs hit him, and nothing in this database casts that spell.
  - Mushlump and Blackthorn each had two script versions mixed together.
  - Amnennar's summon despawned after 10 minutes even if he was alive, so a wipe could lose him for
    good.
- **Changed:**
  - Aarux is hostile (faction 14) and keeps only Plagued Bite and Web Strand.
  - Mushlump keeps one set: Smack Down, Tummy Ache and Putrid Funk.
  - Blackthorn's duplicate death row is deleted.
  - Amnennar now despawns 10 minutes after he dies, not 10 minutes after he appears.

#### Dungeon encounters
- **Found:** `instance_encounters` had no rows for map 129.
- **Changed:** added the client's DungeonEncounter rows: 1662 Aarux, 1663 Mordresh, 1664 Mushlump,
  1665 Blackthorn and 1666 Amnennar (last boss of dungeon finder entry 20).

#### Nothing patrolled
- **Found:** no waypoint paths on map 129 apart from Belnistrasz's, and only the roaches wandered.
- **Changed:** 19 paths from the Pandaria database and 4 from the AzerothCore database. AzerothCore's
  wandering is added for 10 spawns, capped at 5 yards. Spawns are matched by entry and position.
  New path ids are 129000002 and up.

#### Left as is
- The idol room around Plaguemaw (32 mobs, 12 of them Withered Battle Boars) matches the Pandaria
  database spawn for spawn; classic had 15 there. Four chose to keep it.

**Status:** confirmed in game by Four on 2026-11-03: all five bosses are spawned, the three
lieutenants and Blackthorn's step (from `razorfen-downs.patch`) completed, Amnennar gave scenario
credit, and achievement 636 "Razorfen Downs" unlocked. Amnennar's summon needed `2026_11_03_01`.

## 2026-11-02 (pet battles, tamers and achievements)

Merged to `main` with PR #31 on 2026-11-02. The two patches go on top of
`battle-pet-level-achievements.patch`, achievements first.

### Pet tamers: display pets stacked on top of each other

- **Found** (reported by Four): Julia Stevens' pets Fangs (64334) and Slither (64335) stand on the
  exact same spot (-9874.57, 98.49, Goldshire).
- **Cause:** most pet tamers have their team spawned next to them as static creatures
  (MovementType 0). For 40 tamers, two or three of those pets share one position (104 spawns).
- **Changed:** new `sql/fixes/world/2026_11_02_51_pet_tamer_display_pets_wander.sql`: the 149 static
  team pet spawns within 30 yards of the 53 pet tamers that have a "win a pet battle against
  <tamer>" quest now wander within 2 yards of their spawn (MovementType 1, spawndist 2). Pets were
  matched by the `battlepet_info` creature of each species in the tamer's
  `battlepet_npc_team_member` rows. Only spawns that are still static are changed; undo line in the
  file header.
- **Status:** confirmed in game by Four on 2026-11-02 (Fangs and Slither spread out at Julia).

### Pet battles: tamers (Julia Stevens and others) cannot be battled

- **Found** (reported by Four): Julia Stevens (64330, Goldshire) offers nothing to start a battle.
  Beating the wild pets near her does not count for her quest.
- **Cause:** the core has the tamers' teams (`battlepet_npc_team_member`, 1,509 NPC entries; Julia
  has species 872 and 873 at level 2) and a trainer battle type (`PVE_BATTLE_PET_TRAINER`), but
  nothing ever starts a battle against a tamer: `GetPetBattleTrainerTeam` is never called, no gossip
  option exists, and the quest credit for winning was commented out in `PetBattle::Finish`. The quest
  objective type that tamer quests use (11, `QUEST_OBJECTIVE_WINPETBATTLEAGAINSTNPC`, 201 objectives
  in the DB, for example quests 31316 and 31693 for Julia) was also missing from
  `Player::IsQuestObjectiveComplete`, so even a credited objective could never complete the quest.
- **Changed:** new `tools/bfa/battle-pet-trainers.patch`:
  - `GossipDef.h`: new gossip option type `GOSSIP_OPTION_PET_BATTLE` (30) and option index 9001.
  - `Player::PrepareGossipMenu`: adds **Let's do battle!** when the player has Battle Pet Training
    (spell 119467), the NPC has a team in `battlepet_npc_team_member`, and an incomplete quest in the
    log has a type 11 objective for this NPC that is not done yet (as on retail, no quest = no
    battle).
  - `Player::OnGossipSelect`: the option closes the dialog and calls the new
    `WorldSession::StartPetBattleWithTrainer` (`BattlePetHandler.cpp`). It builds up to 3 tamer pets
    from the team rows (level `minlevel`..`maxlevel`, quality `minquality`, a breed from
    `breadsMask`, abilities `Ability1..3`, falling back to the species' own ability for an empty
    one) and starts a PvE battle of type `PVE_BATTLE_PET_TRAINER` with the player's slotted pets. The
    player stays in place, the tamer turns to face them, and the pets fight in between. Capturing is
    already blocked for this type.
  - `SendPetBattleInitialUpdate`: for tamer battles the tamer's entry and display are sent and the
    tamer is no longer sent as the "wild pet" GUID.
  - `PetBattle::Finish`: a win against a tamer calls the new `Player::PetBattleTrainerCredit`, which
    sets every matching type 11 objective in the quest log and completes the quest when it can.
  - `Player::IsQuestObjectiveComplete`: type 11 is a flag objective (done when set).
  - `HandleGossipSelectOptionOpcode` (`NPCHandler.cpp`): accepts quest givers too. Julia's template
    has only the quest giver flag (npcflag 2), so picking any gossip option on her was ignored. The
    option is still checked against the menu that was sent.
  - The battle client draws its own copy of the tamer on the opponent's spot, so the real NPC
    stood next to it (two Julias, reported by Four). `StartPetBattleWithTrainer` now hides the
    real tamer (`SetVisible(false)`) and `PetBattle::Finish` shows it again for every ending (win,
    loss, forfeit). The real tamer is hidden for everyone during the fight. The first version looked
    the tamer up with `ObjectAccessor::FindUnit`, which in this core never finds creatures, so Julia
    stayed hidden until a `worldserver` restart (reported by Four); it now uses
    `ObjectAccessor::GetCreature` on the player's map. If you log out in the middle of a tamer
    battle, the tamer stays hidden until the next restart.
  - `BattlePetDataStore`: new `FindPetBattleTrainerTeam` (read only; the old getter inserts into the
    map on a miss).
  - Also fixed in `PetBattle::Finish`: the end-of-battle rewards ran once per pet in the winning team,
    not once per battle. With 2 or 3 pets slotted, a captured pet was added to the journal 2 or 3
    times, and "Learning the Ropes" (credit 65355) counted 2 or 3 times. They now run once, and the
    "Learning the Ropes" credit needs a win.
  - No SQL. 86 tamers have both a team and a type 11 quest. The 23 Legion/BFA tamers got their
    teams with PR #32 (entry below).
- **Status:** confirmed in game by Four on 2026-11-02 (Julia Stevens battle and quest credit; a
  capture with several pets slotted adds 1 copy; the tamer is hidden during the fight and back right
  after it).

### Pet battles: win, capture and journal achievements never progress

- **Found** while fixing the slot unlocks: more pet battle criteria types were listed as "Not
  implemented yet" in `CriteriaHandler::UpdateCriteria`.
- **Cause:** criteria types 96 (`ADD_BATTLE_PET_JOURNAL`, a specific pet in the journal), 157
  (`CAPTURE_PET_IN_BATTLE`), 158 (`BATTLE_PET_WIN`), 161 (`CAPTURE_BATTLE_PET_CREDIT`) and 162
  (`LEVEL_BATTLE_PET_CREDIT`) did nothing, so achievements that count battle wins, captures or
  specific pets never moved. The win call also passed "is PvP" as the counted value, which is 0 for
  every PvE battle.
- **Changed:** new `tools/bfa/battle-pet-achievements.patch`:
  - `CriteriaHandler.cpp`: 157, 158 and 161 add 1 per capture or win and complete at the criteria's
    amount. 162 counts a pet reaching the criteria's level in battle. 96 completes when a pet of the
    criteria's creature is added, and at login if you already own one.
  - `PetBattle.cpp`: a win now counts 1; a capture also sends type 161.
  - No SQL.
  - Fix after Four's test (2026-11-02): the PvP-only win achievements check "is this a PvP battle"
    (criteria modifier 90) against the first criteria value, which the patch had turned into "1 win".
    So every PvE win passed it, and Four got No Time To Heal (6620, win 5 PvP battles in a row) from
    wild battles. Modifier 90 now reads the second value ("is PvP", 1 or 0), so asset 1 = PvP only
    (Pet Brawler 6595-6599, No Time To Heal) and asset 0 = PvE only. New
    `sql/fixes/characters/2026_11_02_00_remove_pve_pvp_pet_achievement.sql` removes 6620 and the
    progress on criteria 21525 and 22225 (worldserver stopped). Cat Fight (6594, criteria 19724) has
    no modifier and counts every win.
  - Fix after Four's test (2026-11-02): wins counted on the server (Cat Fight criteria 19724 at 7 in
    `character_achievement_progress`) but the achievement window never showed progress. Two packet
    bugs, both fixed as in TrinityCore 8.3.7: `SMSG_CRITERIA_UPDATE` (`AchievementPackets.cpp`,
    `CriteriaUpdate::Write`) lacked the final RafAcceptanceID bit, so the packet was a byte short; and
    account-wide achievements (all pet battle ones) need `SMSG_ACCOUNT_CRITERIA_UPDATE` with the
    criteria-progress layout, which the core sent only for "collect battle pets" and with the
    character layout. `PlayerAchievementMgr::SendCriteriaUpdate` now sends the account packet for every
    account-wide criteria, and `SendAllData` also sends `SMSG_ALL_ACCOUNT_CRITERIA` at login (new
    packet classes `AccountCriteriaUpdate` and `AllAccountCriteria`).
- **Note:** wins and captures from before the patch were never recorded, so those counters start at
  0. Journal criteria (96) are rechecked at every login.
- **Status:** confirmed in game by Four on 2026-11-02 (win counter shows and updates live, PvP-only
  achievements no longer earned from PvE).

#### To pick up both patches
Two new patches on top of the others, the build and a restart. The patches you already applied are
unchanged.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-cwgt5u
git -C ../tools-repo show FETCH_HEAD:tools/bfa/battle-pet-achievements.patch | git apply && echo "pet achievements patch applied"
git -C ../tools-repo show FETCH_HEAD:tools/bfa/battle-pet-trainers.patch | git apply && echo "pet tamers patch applied"
grep -c "GOSSIP_OPTION_PET_BATTLE" src/server/game/Entities/Player/Player.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 2. Then restart `worldserver`.
## 2026-11-02 (pet battles, tamer teams)

### Pet battles: Legion and BFA pet tamers have no team

Merged to `main` with PR #32 on 2026-11-02. The guide's "Pet battles" section now lists both SQL files.

- **Found:** 23 Legion and BFA tamers that a quest asks you to beat in a pet battle had no rows in
  `battlepet_npc_team_member`, so "Let's do battle!" (from `tools/bfa/battle-pet-trainers.patch`,
  PR #31) had no team to put against you.
- **Changed:** new `sql/fixes/world/2026_11_02_60_legion_bfa_tamer_teams.sql` adds 69 rows (3 pets
  per tamer) for these tamers:
  - BFA, Kul Tiras: Captain Hermes 139489, Eddie Fixit 140315, Dilbert McClint 140461, Fizzie
    Sparkwhistle 140813, Michael Skarn 140880, Ellie Vern 141002, Leana Darkwind 141046, Kwint 141077,
    Delia Hanako 141292, Burly 141479.
  - BFA, Zandalar: Lozu 141529, Grady Prett 141799, Korval Darkbeard 141814, Keeyo 141879, Sizzik
    141945, Kusa 142054, Karaga 142096, Talia Sparkbrow 142114, Zujai 142234.
  - Legion: Crysa 115286, Environeer Bert 124617, Shipwrecked Captive 98489, Algalon the Observer 115307.
  - Species, level (all 25) and quality come from the Rematch addon's target data, which was captured
    from the real fights in game. Quality: BFA tamers rare (3), Crysa, Bert and the Shipwrecked Captive
    epic (4), Algalon legendary (5).
  - Abilities are each species' own abilities from `BattlePetSpeciesXAbility` (these tamer species
    have exactly 3, or 2 for Eddie Fixit's Rocket Chicken, Sizzik's Clubber and Bert's Corporal
    Hammer and M-37; the 3rd ability stays 0 there). Every row's `Comment` names the tamer, pet,
    quality and abilities.
  - `breadsMask` 8 (breed 3), like the existing Legion world quest tamer rows.
  - The pets' own creatures (Chum 141094 etc.) were already in `creature_template` with models.
- **Spawns:** Captain Hermes, Fizzie Sparkwhistle, Kwint, Korval Darkbeard, Crysa, Environeer Bert
  and Algalon had no spawn at all. New `sql/fixes/world/2026_11_02_61_legion_bfa_tamer_spawns.sql`
  adds one spawn each (guids 1157000001-1157000007). X/Y come from each tamer's world quest map
  marker (`quest_poi_points`), Z and facing from Four's `.gps` on the spot:
  - Captain Hermes 139489: map 1643, Drustvar, Crimson Coast (-1276.401, 4082.493, 1.894)
  - Fizzie Sparkwhistle 140813: map 1643, Drustvar, Arom's Crossing (-212.0, 3115.0, 313.669)
  - Kwint 141077: map 1643, Tiragarde Sound, on the sea floor (404.046, -1415.275, -53.367). The first
    mid-water spot (z -12.275) showed the gossip cursor but right-click did nothing; Four moved him
    down in game and the battle gossip appeared
  - Korval Darkbeard 141814: map 1642, Nazmir, The Dreadmire (2164.170, 1178.665, 1.072)
  - Crysa 115286: map 1, Northern Barrens (439.567, -3452.627, 92.388)
  - Environeer Bert 124617: map 0, Dun Morogh, Gnomeregan entrance (-5146.244, 826.715, 287.386)
  - Algalon the Observer 115307: map 571, Storm Peaks, Ulduar (9030.281, -1112.029, 1165.275)
- **Gossip:** Captain Hermes, Kwint, Crysa, Environeer Bert and Algalon had `creature_template.npcflag`
  0, so they couldn't be right-clicked and "Let's do battle!" never showed. Same file sets
  `npcflag` 0 -> 1 (gossip) for 139489, 141077, 115286, 124617, 115307.
- **Not done:** the Shipwrecked Captive 98489 has a team but no spawn (no known position).
- **Status:** Kwint confirmed in game by Four on 2026-11-02 (quest 52430 added with `.quest add`,
  "Let's do battle!" shown, battle started with his team). The other tamers are not tested in game
  yet; both SQL files loaded twice on a copy of the dump tables (MySQL 8.4) without errors. Needs
  `battle-pet-trainers.patch` (PR #31) to start the fights.

#### To pick up the tamer teams
SQL only (run the two mysql blocks one at a time), then restart `worldserver`.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-0g0n74
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_02_60_legion_bfa_tamer_teams.sql | mysql -u root -p bfa_world
```
```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_02_61_legion_bfa_tamer_spawns.sql | mysql -u root -p bfa_world
```

## 2026-11-02 (core)

### Startup banner: zrbfacore, no foreign Discord or email

Merged to `main` with PR #33 on 2026-11-02.

- **Asked** (Four): the console header should say zrbfacore in lower case ASCII art, the line
  `https://discord.gg/hTtSYh7WbQ | bfacore.reforged@gmail.com` should become "Based on HavenCore", and
  no other Discord or email contacts that aren't ours should show.
- **Where it lives:** the banner is `Trinity::Banner::Show` in `src/common/Banner.cpp`, which both
  `worldserver` and `bnetserver` print at startup. The worldserver also logs
  `BfaCore Reforged | bfacore.reforged@gmail.com` just before "ready..." (`src/server/worldserver/Main.cpp`,
  `main`). Those are the only Discord or email contacts the servers print. The databases (world dump,
  auth dump) have none.
- **Changed:** new `tools/bfa/core-branding.patch`:
  - `src/common/Banner.cpp`: the "BFA-HavenCore" art is replaced by "zrbfacore" in the same figlet font
    (Big Money-ne). The Discord/email line is replaced by `Based on HavenCore`. The line
    `World of Warcraft Emulator | Battle for Azeroth 8.3.7` stays.
  - `src/server/worldserver/Main.cpp`: `BfaCore Reforged | bfacore.reforged@gmail.com` becomes
    `zrbfacore | Based on HavenCore`.
  - Not changed: the first banner line (`BfaCore rev. <hash> ...`, from `src/common/GitRevision.cpp`),
    the default `Motd` in `worldserver.conf.dist`, and the Discord links in upstream's `README.md` and
    `pull_request_template.md` (never shown by the servers). Author credits in source comments
    (for example `WorldSocketMgr.h`) stay as they are.
- **Status:** confirmed by Four on 2026-11-02: the new banner shows on the server and works.

#### To pick up the new banner
A new patch on top of the others, the build and a restart. The patches you already applied are
unchanged.
```
cd ~/bfa/source
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/core-branding.patch && echo "branding patch applied"
grep -c "Based on HavenCore" src/common/Banner.cpp src/server/worldserver/Main.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 1 for each file. Then restart `worldserver` (and `bnetserver`, which prints the same
banner).

## 2026-11-01 (pet battles, slots)

### Pet battles: second and third battle slots never unlock

Merged to `main` with PR #30 on 2026-11-02.

- **Found** (reported by Four): the second battle pet slot stayed locked ("complete Newbie") although
  Four's pets are level 4 and 5.
- **Cause:** slots 2 and 3 open with the achievements Newbie (7433, raise a pet to level 3) and Just a
  Pup (6566, raise a pet to level 5) (`Player::GetUnlockedPetBattleSlot`). Their criteria are type 160
  (`CRITERIA_TYPE_BATTLE_PET_LEVEL_UP`). The core sends that criteria type when a pet levels in a
  battle or from a level item, but `CriteriaHandler::UpdateCriteria` listed it under "Not implemented
  yet" and did nothing, so no pet level achievement could ever complete.
- **Changed:** new `tools/bfa/battle-pet-level-achievements.patch`
  (`src/server/game/Achievements/CriteriaHandler.cpp`): type 160 completes when the level reached is at
  least the criteria's level. At every login the core rechecks all criteria with no level given; then
  it checks the levels of the pets you own, so pets that are already high enough count. Added to
  `IsCompletedCriteria` (done at 1). The existing achievement hook then sends the slot unlock. No SQL.
- **Status:** confirmed in game by Four on 2026-11-02 (Newbie and Just a Pup awarded, slots 2 and 3
  open).

#### To pick up the pet level achievements
A new patch on top of the others, the build and a restart. The patches you already applied are
unchanged.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-cwgt5u
git -C ../tools-repo show FETCH_HEAD:tools/bfa/battle-pet-level-achievements.patch | git apply && echo "pet level patch applied"
grep -c "Newbie (7433, level 3)" src/server/game/Achievements/CriteriaHandler.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 1. Then restart `worldserver` and log in: Newbie and Just a Pup should pop and both
slots open.

## 2026-11-01 (pet battles)

### Pet battles: wild battle pets missing from most zones

Merged to `main` with PR #29 on 2026-11-01.

- **Found** (reported by Four): Pet Tracker shows Forest Spiderling, Tree Python and Lizard
  Hatchling spawns in Northern Stranglethorn, but in game those were plain neutral critters
  (Lizard Hatchling 50479 at level 1, Forest Spiderling 50487 at level 90), not battle pets.
- **Cause:** `battlepet_wild_zone_pool` lists, per zone, which critter becomes which battle pet and
  how many pets the zone should have. The core's runtime swap (`Map::PopulateBattlePet`) is never
  called anywhere, so only battle pets spawned directly in `creature` ever existed. Northern
  Stranglethorn (area 33) had about 60 battle Beetles (61319) and 23 Strand Crabs (61312), but no
  Tree Python (61318), Forest Spiderling (61320) or Lizard Hatchling (61321) battle pets.
- **Changed:** new `sql/fixes/world/2026_11_01_50_wild_battle_pet_spawns.sql`. For each pool row
  whose battle pet template is a wild pet (type 14), it counts the pets already spawned in the zone
  (`creature.zoneId` or `areaId`) and converts random critter spawns of that zone into the battle
  pet until the zone's `Max` is reached or the critters run out. Critters with a per-spawn SmartAI
  script are skipped. On the dump that is about 4,700 or more spawns in 81 zones; Northern Stranglethorn
  gets 62 Tree Pythons, 54 Lizard Hatchlings, about 56 Forest Spiderlings (all its critters), 8 more Beetles, 3 Crimson Moths and a Long-tailed
  Mole. Every converted spawn is recorded in the new table `zr_wild_battlepet_conversion`, so it can
  be undone (the SQL file's header has the two lines). Running it twice converts nothing new.
  No core change.
- **Docs:** guide section 9, "Pet battles".
- **Status:** run on Four's live DB on 2026-11-01: 5,900 spawns converted in 86 zones (more than
  the dump estimate, which could not parse some templates). Confirmed in game by Four.

#### To pick up the wild battle pet spawns
SQL only, then a restart.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-cwgt5u
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_01_50_wild_battle_pet_spawns.sql | mysql -u root -p bfa_world
```
The last line prints the number of converted spawns and zones. Then restart `worldserver`.

## 2026-11-01

### World: quest items from one unique mob now always drop (508 items)

- **Asked** (Four): if a named mob is the only source of a quest item, it should drop on every kill
  while you're on the quest. Items that drop from many common mobs (hides, claws) stay random.
- **How the list was picked** from the world dump (all INSERT blocks parsed):
  - the item is a quest objective (`quest_objectives` Type 1) and the quest needs exactly 1;
  - it only comes from `creature_loot_template` (no gameobject, container, pickpocket, skinning or
    reference loot), with every row `QuestRequired` 1, `GroupId` 0, `Reference` 0;
  - every creature that drops it has at most one spawn point. Creatures with no spawn (summoned by
    events) count only when they are elite or their name is unique, so summoned generic mobs stay
    random; 7 summoned named mobs were added by hand (Anaya Dawnrunner, Captain Halyndor, Saragosa,
    Stalvan Mistmantle, Gardul Venomshiv, Jergosh the Invoker, Torturer Relyn);
  - at most 6 creatures drop it, raids are left alone (13 items, e.g. AQ20 tokens, Nightbane), and
    where several creatures drop it, rows under 10% are left alone (stray low-chance copies).
- **Changed:** `sql/fixes/world/2026_11_01_03_unique_mob_quest_drops.sql` sets
  `creature_loot_template.Chance` = 100 on 517 rows (508 items). Before: 58 rows were under 50%,
  161 between 50% and 90%, 298 at 90% or more. Each row in the file has a comment with the creature,
  its old chance and the quest. `QuestRequired` stays 1, so nothing drops without the quest.
  Examples: Goldtooth 327 (61.86%), Princess 330 (66.87%), Jammal'an the Prophet 5710 (49.89%),
  Gahz'rilla 7273 (56.45%), Dockmaster 6846 (0.44%).
- **Status:** merged 2026-11-01 without a dedicated in-game test (the Esquivel case above is the same
  change on 4 rows and was confirmed). Report any named quest mob that still misses its item.
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_01_03_unique_mob_quest_drops.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### World: Chief Esquivel rarely drops the Whispering Blue Stone

- **Found** (reported by Four): Chief Esquivel (43912, Kurzen compound cave in Northern
  Stranglethorn) often dies without dropping the quest item for The Source of the Madness.
- **Cause:** Whispering Blue Stone (item 60263, 1 needed for quest 26734) is a quest-only drop with
  low chances on the four chiefs the quest sends you to: Chief Anders 43910 26.67%, Chief Gaulus
  43911 13.86%, Chief Esquivel 43912 7.68%, Chief Miranda 43913 18.39%.
- **Changed:** `sql/fixes/world/2026_11_01_02_whispering_blue_stone_kurzen_chiefs.sql` sets
  `creature_loot_template.Chance` = 100 for item 60263 on 43910, 43911, 43912 and 43913 (QuestRequired
  stays 1, so it only drops while you're on the quest). The regular Kurzen troops (939, 941, 942, 978,
  979) keep their 1-5% chance.
- **Status:** confirmed in game by Four (2026-11-01): Chief Esquivel dropped the stone.
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_01_02_whispering_blue_stone_kurzen_chiefs.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### Core: dying never turned you into a proper ghost (battle pet code wiped player flags)

- **Found** (reported by Four): after `.die` or a creature kill and Release Spirit, you arrive at the
  graveyard as a "ghost" in a normal, living world. The Spirit Healer won't talk to you, there is no
  corpse arrow, and the character screen shows you alive. Relogging doesn't fix it. A fall death
  sometimes worked.
- **Cause:** the server did make you a ghost (`.list auras` shows Ghost 8326 and wisp 20584), but three
  battle pet functions *replace* all player flags with `PLAYER_FLAGS_PET_BATTLES_UNLOCKED` (0x400000)
  instead of adding it: `Player::_LoadPetBattles` (login), `WorldSession::SendBattlePetJournal`
  (login, teleports, every journal request) and `WorldSession::SendPetBattleSlotUpdates`. That wipes
  `PLAYER_FLAGS_GHOST` (0x10), which is what the client uses for the grey world, Spirit Healer and
  corpse arrow, and it was saved without the flag. They only run once a battle pet slot is unlocked,
  so this started after the battle pet slot fix (2026-10-25).
- **Changed:** new `tools/bfa/battle-pet-player-flags.patch` (applied after `battle-pet-journal.patch`):
  `SetPlayerFlags(PLAYER_FLAGS_PET_BATTLES_UNLOCKED)` becomes `AddPlayerFlag(...)` in
  `Player.cpp` (`_LoadPetBattles`) and `BattlePetHandler.cpp` (`SendPetBattleSlotUpdates`,
  `SendBattlePetJournal`). This also stops AFK, DND and resting flags being cleared the same way.
- **Status:** confirmed in game by Four (2026-11-01): death and release give a proper ghost again.
- **Pick up:** rebuild with the new patch and restart worldserver:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:tools/bfa/battle-pet-player-flags.patch | git apply
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```

### World: Astranaar crowded by a siege that only belongs to its quests

- **Found** (reported by Four): Astranaar is packed with soldiers, Horde Hellions and Wind Riders and
  Throwers, while the town itself looks calm (no fires).
- **Cause:** 193 spawns in Astranaar (area 415) belong to the Cataclysm siege quests but have no phase,
  so everyone sees them all the time: Hellscream's Hellion 34163 (15), Watch Wind Rider 34160 (15),
  Astranaar Skirmisher 34419 (23), Astranaar Sentinel 34494 (59), Astranaar Officer 34420 (5),
  Astranaar Thrower 34132 (12) and 34492 (9), Thrower Bunny 34501 (9), fire bunnies 34123 (34),
  Phase Q1 Generic Bunny JSB 34439 (12). The Pandaria DB has the same unphased spawns.
- **Changed:** `sql/fixes/world/2026_11_01_01_astranaar_siege_quest_phase.sql` moves those 193 spawns
  to phase 295 (in Phase.db2, normal phase, unused anywhere else in the DB) and adds `phase_area`
  (415, 295) with `conditions` (source type 26) that turn it on while any siege quest is in progress or
  complete: 13849 Astranaar's Burning!, 13853 Return Fire (Alliance), 13943 Breathing Room,
  13947 Blastranaar! (Horde). The town guards (6087, 51770), vendors and Hellscream's Watch are
  untouched. The revert line is in the file.
- **Status:** confirmed in game by Four (2026-11-01): Astranaar is calm without the quest.

#### To pick up the Astranaar siege phase
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_01_01_astranaar_siege_quest_phase.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`.

### World: Astranaar flight master Daelyshia lies dead

- **Found** (reported by Four): the Astranaar Hippogryph Master Daelyshia (4267, spawn 239983) lies
  on the ground as a corpse and can't be talked to, so Astranaar has no Alliance flight master.
- **Cause:** her BFA template was taken while she was dead in a war phase: `npcflag` 0, `unit_flags`
  0x20040300 (stunned + feign death), `unit_flags2` 0x801 (feign death), `unit_flags3` 0x2000.
- **Changed:** `sql/fixes/world/2026_11_01_00_astranaar_flight_master_daelyshia.sql` sets entry 4267 to
  `npcflag` 8193 (gossip + flight master, as in the Pandaria DB), `unit_flags` 768, `unit_flags2`
  2048, `unit_flags3` 0. Gossip menu 0 already has the "I want to travel fast" option.
- **Status:** confirmed in game by Four (2026-11-01): Daelyshia is alive and offers flights.

#### To pick up the flight master fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_01_00_astranaar_flight_master_daelyshia.sql | mysql -u root -p bfa_world
```
Then restart `worldserver` and delete the client's `Cache` folder (the client caches creature data).

## 2026-10-31

### World: 37 creature spawns ignored their own scripts (junk "Fel Hands" spawn rows)

- **Found** (Dungeon Fixes thread, while fixing Lady Falther'ess in Razorfen Downs): 44 creature
  spawns carry a per-spawn SmartAI row (`entryorguid` = -guid) that casts Fel Hands (207101, a
  Legion dummy aura with no effect) out of combat, comment `OOC - CS`.
- **Cause:** a per-spawn script replaces the creature's own entry script entirely, so these spawns
  only meleed. Examples: Warsong Demolishers (32850) never threw Flaming Balls or exploded,
  Rampaging Owlbeasts (49245) never used Shred, Northwatch Guards (38636) never shot, Gnomeregan's
  Dark Iron Land Mines (8035) never detonated, Dark Keeper Uggel (9439) never cast.
- **Changed:** `sql/fixes/world/2026_10_31_05_fel_hands_spawn_scripts.sql`:
  - Deletes the 207101 rows for 42 guids (the full list by map is in the file). Razorfen Downs
    373574/373575 are left to `2026_10_31_04` (PR #26). 5 of the guids have no spawn; their rows go too.
  - Northwatch Guard 38636 had two script versions mixed together: removes id 0 (event 0, Cast
    Shoot), id 1 (event 2, Shield Block) and id 2 (event 0, Revenge), all with link 0, which duplicate
    ids 4, 16 and 17. The linked ranged chain (ids 0-19) stays.
  - Grishna Raven 20327 and Theldren 16059 have no entry script, so they only lose the dummy row.
- **Status:** confirmed in game by Four (2026-11-01): Rampaging Owlbeasts in Hillsbrad cast Shred again.

#### To pick up the spawn script fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_31_05_fel_hands_spawn_scripts.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`.

### World: Warsong Demolisher Flamethrower one-shots players

- **Found** (reported by Four, testing the spawn script fix): a Warsong Demolisher (32850, level 23,
  Ashenvale) killed Four with Flamethrower: 764 fire on hit, then 144 fire every second.
- **Cause:** with its own script running again (entry above), row id 3 casts Flamethrower (65388)
  within 20 yards every 14-19 s. 65388 is a vehicle weapon whose damage scales with the caster's level
  by a large coefficient (about 38.6 per hit, 7.7 per tick).
- **Changed:** `sql/fixes/world/2026_10_31_06_warsong_demolisher_flamethrower.sql` deletes that one
  row (entry 32850, id 3, spell 65388). Flaming Ball (61865), the out-of-combat ball at trigger NPCs
  (61864) and the death explosion (65417) stay.
- **Follow-up (2026-11-01):** Four found the demolishers then only meleed and stood still, and Flaming
  Ball never fired. The same file now also deletes ids 0 and 1 (event 4 aggro, action 21 "stop combat
  movement" with 0), so they chase their target instead of standing rooted.
- **Follow-up 2 (2026-11-01):** after killing Four they never reset and kept swinging at the spot.
  Row id 6 (on spawn, action 117 disable evade, linked to id 7 "set aggressive") is now a plain
  "on spawn, set aggressive" (action 8, param 2, link 0) and id 7 is deleted, so they can evade and
  leash again.
- **Status:** confirmed in game by Four (2026-11-01): Demolishers no longer one-shot and leash home.

#### To pick up the Flamethrower fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_31_06_warsong_demolisher_flamethrower.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`.

### World: Spirit Healers doubled or tripled at 117 graveyards

- **Found** (reported by Four): the Nightsong graveyard near Raynewood Tower in Ashenvale
  (`world_safe_locs` 1427) has two Spirit Healers (6491) on the same spot, and Astranaar has three.
  Four asked to clear the same doubling everywhere.
- **Cause:** a block of added Spirit Healer spawns (mostly guids 371188-371416 and 375076-375097, and
  on the Broken Isles 20549126-20549205) repeats graveyards that already had one. A scan of all 876
  Spirit Healers found 117 graveyards with two or three within 25 yards of each other (height within
  10), same phase and difficulty.
- **Changed:**
  - `sql/fixes/world/2026_10_31_07_nightsong_spirit_healer_duplicate.sql` deletes spawn 371367
    (Nightsong). Spawn 129879 stays.
  - `sql/fixes/world/2026_10_31_08_spirit_healer_duplicates.sql` deletes 132 spawns (Kalimdor 53,
    Eastern Kingdoms 34, Broken Isles 40, Outland 2, Pandaria 2, Northrend 1; 371367 is in the list
    too). Astranaar keeps 40868 (239931 and 371366 go). Each graveyard keeps one healer: the sniffed
    spawn where there is one (452538, 452539, 210117416, 210118234), otherwise the lowest guid. None of
    the removed guids is in a pool, game event, formation or `creature_addon` row. The first version
    of this file (5-yard scan, 85 spawns) is a subset, so running the new one after it is fine.
- **Status:** confirmed in game by Four (2026-11-01): Astranaar and Raynewood Tower each show one Spirit Healer.

#### To pick up the Spirit Healer fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_31_07_nightsong_spirit_healer_duplicate.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_31_08_spirit_healer_duplicates.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`.

### World: Bloodlord Mandokir never leaves the Rebel Camp after his quest

Merged to `main` with PR #25 on 2026-10-31.

- **Found** (reported by Four): after turning in "Bloodlord Mandokir" (quest 26748) in the Rebel
  Camp, a friendly Bloodlord Mandokir (43989, no DB GUID, faction 35) stays there for good and
  stands in front of another NPC.
- **Cause:** the quest's reward spell 82340 summons 43989 (SummonProperties 492, infinite duration).
  The quest giver 42790 itself is despawned by `npc_bloodlord_mandokir`, but the summon has no script
  at all, so nothing ever removes it. The Horde version (quest 26334 at Grom'gol, reward spell 79783)
  summons 42799 the same way and has the same problem.
- **Changed:** `sql/fixes/world/2026_10_31_00_mandokir_reward_summon_despawn.sql` adds one
  `smart_scripts` row each for 43989 and 42799 (there were none): event 54 (just summoned), action 41
  (force despawn) after 5000 ms, target self. `AIName` stays `SmartAI`.
- **Status:** confirmed in game by Four on 2026-10-31 (new character, Mandokir vanished after the turn-in).

#### To pick up the Mandokir fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_31_00_mandokir_reward_summon_despawn.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`. The restart also removes the Mandokir already standing in the camp.

## 2026-10-30

### World: critters and wild battle pets stacked on one spot, and none of them wander

Merged to `main` with PR #24 on 2026-10-31.

- **Found** (reported by Four): in Stranglethorn a Beetle (61319, wild battle pet, guid 10647972),
  a Tree Python (49722, guid 10647911) and a Lizard Hatchling (50479, guid 10648091) stood on the
  same spot (-11459.5, -273.45, 42.9962) without moving.
- **Cause:** the BFA dump has a block of 8,460 critter and wild battle pet spawns added without sniff
  data (VerifiedBuild 0, orientation 0, respawn 120 s, MovementType 0, spawndist 0). 596 of their
  spots carry 2 to 5 creatures on exactly the same coordinates (1,275 spawns), and none of the block
  moves.
- **Changed:** `sql/fixes/world/2026_10_30_02_critter_spawns_stacked_and_still.sql`:
  - Each stacked spot becomes a pool that spawns one of its creatures at a time (`pool_template`
    5100001 to 5100596, `max_limit` 1; `pool_creature` rows for the 1,275 guids, equal chance). The
    Stranglethorn spot above is pool 5100506.
  - The 8,188 spawns of the block that can walk (InhabitType has the ground bit) get `MovementType`
    1 and `spawndist` 3.5 (was 0 and 0), the radius the core already uses for wild battle pets that
    replace critters (`WildBattlePetMgr::ReplaceCreature`). The 272 flying-only or water-only ones stay put.
  - Only critters (type 8) and the wild battle pet entries in `battlepet_spawn_relation` and
    `battlepet_wild_zone_pool` (Max above 1) are touched, so pet vendor and pet tamer displays
    (Darkmoon Faire, Booty Bay, Deepholm) are left alone. Sniffed critters outside the block are
    unchanged. Safe to run twice; the revert lines are in the file.
- **Status:** confirmed in game by Four on 2026-10-31.

#### To pick up the critter spawn fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_30_02_critter_spawns_stacked_and_still.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`.

### World: 248 creatures had no creature type (Sap failed on Bloodscalp Warriors)

Merged to `main` with PR #23 on 2026-10-30.

- **Found** (reported by Four): Sap didn't work on a Bloodscalp Warrior (587, guid 183856,
  Stranglethorn), a humanoid.
- **Cause:** in the BFA dump, 248 `creature_template` rows (mostly entries 3 to 660, plus a few later
  ones) have `type` 0 ("None") and the real creature type in the `family` column. 587 has type 0,
  family 7, where 7 is Humanoid. A creature of type 0 is not a Humanoid, Beast or Undead to the core,
  so every spell limited to a creature type fails on it: Sap, Polymorph, Hibernate, Shackle Undead,
  Banish, Turn Evil, Scare Beast and others. The tameable beasts in the list also lost their pet family.
- **Changed:** `sql/fixes/world/2026_10_30_00_creature_type_from_family.sql` sets `type` and
  `family` from the Pandaria 5.4.8 world DB, which agrees with the shifted value for all 248:
  - Humanoid (type 7): 200 creatures, including Bloodscalp Warrior 587, Hogger 448, Kobold Vermin 6,
    Defias Smuggler 95, the Westfall Bridge Workers 649-653. Family 0.
  - Undead (6): 16, including Flesh Eater 3 and Skeletal Warrior 48. Elemental (4): 3, including
    Rock Elemental 92. Mechanical (9): 3. Dragonkin (2): 1. Critter (8): 1. Giant (5): Sea Giant 90.
    Not specified (10): Magma Trap 53086. Family 0 for all.
  - Beast (1) with their family: wolves (1) 118, 213, 521, 565; spiders (3) 442, 471, 505, 539, 569,
    574, 616; boars (5) 113, 119, 330, 345, 454, 524; carrion birds (7) 154, 199, 462; family 0 for
    Kodo Beast 106 and Palomino 306.
  - Left alone: Tall Strider 105 and five Draenor creatures (75533, 75703, 75763, 76120, 77140) that
    also have type 0 with a family, because Pandaria has nothing to check them against.
  - Only rows still at type 0 change, so it is safe to run twice. The revert line is in the file.
- **Status:** confirmed in game by Four on 2026-10-30 (Sap works on Bloodscalp Warriors). The game
  client caches creature types: delete the `Cache` folder in the WoW folder after running the SQL.

### World: Bloodscalp Tusks for Hunt for Yenniku almost never dropped

Merged to `main` with PR #23 on 2026-10-30.

- **Found** while checking Bloodscalp loot for Four: Hunt for Yenniku (26298) needs 6 Bloodscalp
  Tusks (3901) from any Bloodscalp troll. All 11 Bloodscalp types have the tusk as a quest drop, but
  only Warriors 587 (36%) and Axe Throwers 694 (36.81%) drop it often. Shamans 697 have 10%, and
  Scouts 588, Hunters 595, Berserkers 597, Witch Doctors 660, Headhunters 671, Beastmasters 699,
  Mystics 701 and Scavengers 702 between 0.1% and 1.27%. The Pandaria world DB has 50% on all of them.
- **Changed:** `sql/fixes/world/2026_10_30_01_bloodscalp_tusk_drop_rate.sql` sets `Chance` 50 on those
  11 rows (`Item` 3901, `QuestRequired` 1) where it was lower. The old values are in the file.
- **Checked, no change:** the other Bloodscalp quest drops are fine: Shrunken Head 1532 for
  Headhunting (73-74% on 597, 660, 671), Bloodscalp Totem 23679 for Bloodscalp Insight (34.5% on the
  Shaman 697), and the three items for Sacred to the Bloodscalp (60270-60272, about 11% each on the
  Scavenger 702). Their normal loot (cloth, food such as Mutton Chop, potions, greens, greys) is there
  too: 123 to 302 rows per Bloodscalp.
- **Status:** confirmed in game by Four on 2026-10-30.

#### To pick up the creature type and Bloodscalp Tusk fixes
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_30_00_creature_type_from_family.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_30_01_bloodscalp_tusk_drop_rate.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`.

### Core: skinning refused after learning Cataclysm Skinning

Merged to `main` with PR #22 on 2026-10-30.

- **Found** (reported by Four): Delotha could no longer skin creatures well within her skill, such as
  a Redridge Fox (43083, level 15-16, needs 50). The DB had Skinning (393) 1/75, Cataclysm Skinning
  (2561) 1/75 and Classic Skinning (2564, the "Skinning 162/300" line) 162/300.
- **Cause:** the skinning cast check (`Spell::CheckCast`, `SPELL_EFFECT_SKINNING`) reads the profession
  skill 393. `Player::SetSkill` (upstream) and `Player::UpdateSkillPro` (our
  `profession-skill-sync.patch`) both copied whichever expansion skill changed last into it, so
  learning Cataclysm Skinning at 1 set Skinning to 1/75. Herbalism (182) and Mining (186) had the same
  flaw: learning a second expansion tier would have turned their nodes orange or refused them again.
- **Changed:** `tools/bfa/profession-skill-sync.patch` (`src/server/game/Entities/Player/Player.cpp`):
  new `SyncParentProfessionSkill` sets the profession skill to the value, max and tier of its highest
  expansion skill. `UpdateSkillPro` and the end of `SetSkill` call it instead of copying the skill
  that changed. No SQL. Compiles with GCC 13 on the full patch chain.
- **Status:** confirmed in game by Four on 2026-10-30: skinning works again.

#### To pick up the skinning fix
`profession-skill-sync.patch` changed, so swap the old version for the new one, then build and
restart. The other patches you applied are unchanged.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin main
git -C ../tools-repo show b83c110:tools/bfa/profession-skill-sync.patch | git apply -R && echo "old patch removed"
git -C ../tools-repo show origin/main:tools/bfa/profession-skill-sync.patch | git apply && echo "new patch applied"
grep -c SyncParentProfessionSkill src/server/game/Entities/Player/Player.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
Both echo lines print, and the grep prints 3. Then restart `worldserver`.

## 2026-10-26

### Pet battles: summoned pets show as Murkimus, released pets come back

Merged to `main` with PR #21 on 2026-10-31.

- **Found** (reported by Four): summoning Black Lamb, Stormwind Rat or Cat from the Pet Journal
  spawned Murkimus the Gladiator. A Black Lamb released from the journal kept showing up again.
- **Cause, Murkimus:** pets with no summon spell of their own are summoned with spell 118301
  (Summon Battle Pet), whose MiscValue is a placeholder creature, 40721 Murkimus the Gladiator
  (TrinityCore 8.3.7 notes the same). The core used that creature as is. It also never set the
  player's `SummonedBattlePetGUID`, so the summon was not tied to the journal pet at all.
- **Cause, released pets:** on login the core loaded only the first row of each species from
  `account_battlepet` and silently skipped the rest. Extra copies stayed in the DB, hidden, and
  one of them showed up again after a release and relog. Releasing the last copy of a species
  was also silently refused.
- **Changed:** new `tools/bfa/battle-pet-journal.patch`:
  - `Player.cpp` `SummonBattlePet`: sets `SummonedBattlePetGUID` and the last summoned pet before
    casting, and remembers the spawned critter. `UnsummonCurrentBattlePetIfAny` clears it.
  - `SpellEffects.cpp` `EffectSummonType`: for 118301 the creature is the journal pet's species
    `CreatureID` instead of 40721.
  - `SpellEffects.cpp` companion summon, after the creature's level and NPC flags are set from its
    template: when the critter is the journal pet, the wild battle flag is taken off again (first
    version left the Stormwind Rat battleable), the pet's own display model is used, and its health
    is set to the pet's journal max health. Wild pet templates have tiny health modifiers (Black Lamb
    60649 has `HealthModifier` 0.01), which gave 0 health, so the summon showed up dead.
  - `Player.cpp` `_LoadPetBattles`: loads every copy of a species.
  - `BattlePetHandler.cpp`: release no longer checks species flag 0x8. The core calls it
    `NOT_RELEASABLE`, but in 8.3.7 0x8 is Capturable (TrinityCore's `BattlePetSpeciesFlags`), so
    every wild pet such as the Black Lamb was refused and stayed in the DB (second version still
    brought the lamb back on every relog). Release also works on the last copy, dismisses the pet if it is out
    and clears it from a battle slot. Clicking summon on a pet whose critter is gone now summons
    it instead of doing nothing.
  - No SQL.
- **Status:** first version (2cc26f6) summoned the right creature but dead and battleable. Second
  version (bb1835b): summons confirmed in game by Four on 2026-10-26, released Black Lamb still came
  back. Third version (release flag check removed): release confirmed in game by Four on
  2026-10-26. Summons and release both done.

#### To pick up the pet journal fix
A new patch on top of the others, the build and a restart. The patches you already applied are
unchanged.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-cwgt5u
git -C ../tools-repo show FETCH_HEAD:tools/bfa/battle-pet-journal.patch | git apply
grep -c "is Capturable in 8.3.7" src/server/game/Handlers/BattlePetHandler.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 1. Then restart `worldserver` and log in again.

## 2026-10-25

### World: battle pet slots stayed locked after Battle Pet Training

Merged to `main` with PR #15 on 2026-10-25.

- **Found** (reported by Four): after paying a Battle Pet Trainer for Battle Pet Training (spell
  119467, 10 gold from `npc_trainer`), the first battle slot in the Pet Journal stayed unusable, so no
  pet could be slotted.
- **Cause:** 119467 is a passive spell whose only effect is 201 (`SPELL_EFFECT_ENABLE_BATTLE_PETS`,
  checked in Four's SpellEffect.db2/SpellMisc.db2). The core casts it when it is learned and again at
  every login, and the effect sends `SMSG_PET_BATTLE_SLOT_UPDATES` to tell the client which slots are
  open. The core wrote that packet in the wrong order: the slot list first, then the `NewSlotUnlocked`
  and `AutoSlotted` bits. The 8.3.7 client reads the two bits first (TrinityCore's 8.3.7 code,
  tag TDB837.20101, writes them first), so it misread every slot in the packet. The same packet goes
  out when the Newbie (7433) and Just a Pup (6566) achievements unlock slots 2 and 3.
- **Changed:** new `tools/bfa/battle-pet-slots.patch`
  (`src/server/game/Server/Packets/BattlePetPackets.cpp`, `SlotUpdates::Write`): the two bits and
  the flush now come before the slots. Nothing else in the packet changed. The other battle pet
  packets (journal, pet updates, set slot) already match 8.3.7, as do their opcode numbers. No SQL.
- **Status:** confirmed in game by Four on 2026-10-25.

#### To pick up the battle pet slot fix
A new patch on top of the others, the build and a restart. The patches you already applied are
unchanged.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:tools/bfa/battle-pet-slots.patch | git apply
grep -c "the two bits before the slots" src/server/game/Server/Packets/BattlePetPackets.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 1. Then restart `worldserver` and log in again.

## 2026-10-25

### Razorfen Kraul: second run (Bonetusk's Barrage and boars, Groyat's Sonic Charge, Charlga's binding)

From Four's second run, 2026-10-25. SQL only: `sql/fixes/world/2026_10_25_06_razorfen_kraul_second_run.sql`.

- **Found** (reported by Four):
  - Hunter Bonetusk's Barrage did nothing, and his boars stayed up after he died. They are elites,
    so killing them one by one is slower than racing Bonetusk. Barrage (150881) is a channel whose
    damage comes from a periodic spell (150884) fired from an aura on Bonetusk; this core casts that
    spell at Bonetusk himself, not at his channel target, so it never hits anyone.
  - Groyat's Sonic Charge (151454) only moved him. After the leap it lays 12 damaging area triggers
    (spell 151407, areatriggers 1465-1476), and none of those are in the database.
  - Charlga still cast Elemental Binding too often.
- **Changed:**
  - Bonetusk: Barrage replaced by Aimed Shot (27632) at his target every 12-16 seconds (first after
    6-9), plus Serpent Sting (31975) on a random player every 12-15 seconds (first after 3-5). His
    three boars are now three different Agam'ar, Raging (4514), plain (4511) and Rotting (4512), so
    each can be found again by entry, and all three despawn when he dies.
  - Groyat: right after Sonic Charge he casts its damage spell (151429) on his target.
  - Charlga: Elemental Binding every 25-30 seconds instead of 15-20.
  - Sonic Field: nothing new. `2026_10_25_04` already swapped it for Sonic Burst (8281).
- **Status:** confirmed in game by Four on the third run (2026-10-25): Bonetusk, Groyat and Charlga
  "all perfect".

### Razorfen Kraul: Charlga Razorflank only cast Elemental Binding

From Four's first run, 2026-10-25. SQL only: `sql/fixes/world/2026_10_25_05_razorfen_kraul_charlga.sql`.

- **Found** (reported by Four: one melee hit, then Elemental Binding for the rest of the fight; credit,
  loot, scenario and achievement fine): her SmartAI recast Elemental Binding (151583, root plus
  damage over time) every 6 seconds after the first 10. Crystalline Command (151534) only has a dummy
  effect this core doesn't script, and two rows both said an aggro line.
- **Changed:** rows 2, 3, 4 and 6 replaced. Elemental Binding on a random player every 15-20 seconds,
  Chain Bolt (8292) at her target every 6-9 seconds, Renew (8362) on herself below 50% health. Her
  speech and the death event that wakes the Spirit of Agamaggan stay. Her classic Purity (8361) is
  left out because it makes her immune to all damage.
- **Status:** confirmed better in game by Four on the second run (2026-10-25), but Binding still came
  too often; slowed to 25-30 seconds in `2026_10_25_06`, confirmed on the third run.

### Razorfen Kraul: Groyat's Sonic Field did nothing

From Four's first run, 2026-10-25. SQL only: `sql/fixes/world/2026_10_25_04_razorfen_kraul_groyat.sql`.

- **Found** (reported by Four: Sonic Charge, melee and Drain Life work, Sonic Field showed nothing;
  credit and loot fine): Sonic Field (151432) has only a dummy effect, which needs a spell script
  this core doesn't have.
- **Changed:** that row (id 2) casts Sonic Burst (8281) instead, the classic Blind Hunter's attack:
  weapon damage and a short silence within 13 yards, first after 6-8 seconds, then every 12-16.
- **Status:** Groyat's spawn, credit, loot and fight confirmed in game by Four (2026-10-25, second
  run). Sonic Charge damage added in `2026_10_25_06`; Sonic Burst and Sonic Charge confirmed on the
  third run.

### Razorfen Kraul: Agathelos the Raging healed to full mid-fight

From Four's first run, 2026-10-25. SQL only: `sql/fixes/world/2026_10_25_03_razorfen_kraul_agathelos.sql`.

- **Found** (reported by Four, who had to use `.die`): Agathelos (4422) casts Left for Dead (8555),
  which hits and then forces the target to feign death (8359). Feign death drops the player from his
  threat list, so a solo player leaves him with nobody to fight and he evades back to full health.
  No other creature uses it.
- **Changed:** the Left for Dead row (id 6) is deleted. He keeps Rushing Charge, Frenzy at 60% and
  40%, Rampage and Call for Help.
- **Status:** confirmed in game by Four on the second run (2026-10-25): the fight went well.

### Razorfen Kraul: Warlord Ramtusk only meleed

From Four's first run, 2026-10-25. SQL only: `sql/fixes/world/2026_10_25_02_razorfen_kraul_ramtusk.sql`.

- **Found** (reported by Four): Ramtusk (74462) meleed and threw a single Spirit Axe. Spirit Axe
  (151312) was his only spell, first after 8-12 seconds and then every 10-20; the rest of his script
  was speech rows with no texts and a door opener aimed at a gameobject that isn't spawned. The axe's
  odd texture is the spell's client-side visual, which the server can't change.
- **Changed:** new SmartAI. Spirit Axe at a random player every 10-14 seconds (first after 6-8), plus
  the kit of the classic Overlord Ramtusk he replaced: Battle Stance (7165) on reset, Battle Shout
  (9128), and Thunderclap (15548) when a player is within 8 yards. His axes come from
  `2026_10_25_01`.
- **Not changed:** how hard he hits; difficulty is tuned through DungeonScale.
- **Status:** confirmed good in game by Four on the second run (2026-10-25).

### Razorfen Kraul: Hunter Bonetusk only shot, and held no weapon

From Four's first run, 2026-10-25. SQL only: `sql/fixes/world/2026_10_25_01_razorfen_kraul_bonetusk.sql`.

- **Found** (reported by Four): Bonetusk (75001) only used Shoot, had no weapon in his hands, and a
  Boar Spirit next to him died at once. His SmartAI fired Shoot (150879) every 1-2 seconds at any
  range up to 20 yards, so it kept him busy whenever his other spells came up. Volley (150904) only
  has dummy effects that need a spell script this core lacks, and Stampede (150917) triggers spell
  132660, which isn't in the client's spell data. His speech rows point at texts that don't exist.
  None of the Warlords bosses had an equipment row. The Boar Spirit (6021, guid 325407) belonged
  to Aggem Thorncurse, the classic boss Bonetusk replaced.
- **Changed:**
  - New SmartAI: he chases and melees, Shoots at 5-30 yards, channels Barrage (150881, interrupting
    his current cast), uses Multi-Shot (21390) on a random player, and at 50% health three Raging
    Agam'ar (4514) charge in around his target, standing in for the broken Stampede.
  - Equipment: Bonetusk gets the Razorfen Beastmaster's dagger and bow (2184, 2551); Warlord Ramtusk
    (74462) gets the classic Overlord Ramtusk's two axes (5286).
  - The Boar Spirit spawn is deleted.
- **Status:** tested by Four on the second run (2026-10-25): Barrage did nothing (replaced in
  `2026_10_25_06`), and the boars came in but outlived him (they despawn with him since
  `2026_10_25_06`). The `2026_10_25_06` changes were confirmed on the third run.

### Razorfen Kraul: pre-run check

Before Four's first run. All SQL, in `sql/fixes/world/2026_10_25_00_razorfen_kraul.sql`; no rebuild.

#### Groyat, the Blind Hunter had no spawn
- **Found:** the scenario (654) needs five kills: Hunter Bonetusk (75001), Roogug (74948), Warlord
  Ramtusk (74462), Groyat (75247) and Charlga Razorflank (4421). The BFA spawns swap three classic
  bosses for their Warlords versions (Aggem Thorncurse, Overlord Ramtusk and a Groundshaker), but
  the classic Blind Hunter (4425) was left in Groyat's room, so the scenario could never finish.
  Groyat also had no scaling row for difficulty 1.
- **Changed:** spawn 52982 is now Groyat (75247), and he gets the scaling row.

#### Two Roogugs
- **Found:** the classic Roogug (6168, guid 325276) was still spawned besides the new one (74948).
- **Changed:** the classic spawn is deleted.

#### Dungeon encounters
- **Found:** `instance_encounters` only had 438 Roogug, pointing at the classic Roogug, so no kill
  completed a dungeon encounter or the dungeon finder entry.
- **Changed:** the client's DungeonEncounter rows for map 47: 438 Roogug (now 74948), 1656 Hunter
  Bonetusk, 1659 Warlord Ramtusk, 1660 Groyat, 1661 Charlga Razorflank (last boss of dungeon finder
  entry 16).

#### Double pets
- **Found:** Razorfen Handler (4530), Beast Trainer (4531) and Beastmaster (4532) had two SmartAI
  scripts mixed together, both summoning the pet on spawn.
- **Changed:** the second summon row (id 12) is deleted, so each brings one pet.

#### Nothing moved
- **Found:** no waypoint paths and no wandering on map 47.
- **Changed:** 5 paths from the Pandaria 5.4.8 database, 4 from the AzerothCore 3.3.5 database
  (including Agathelos the Raging), and AzerothCore's wandering for 46 spawns, capped at 5 yards.
  Matched by entry and position, or, where Cataclysm changed the creature on a spot, by the nearest
  spawn within 5 yards. New path ids 47000001 and up.

#### Not changed (yet)
- Charlga's scenario kill (criteria 34444) has an extra condition, world state expression 5497.
  Read from Four's WorldStateExpression.db2 (2026-10-25), it decodes to "1 == 1", which is always
  true, so it needs no fix. Achievement 635 "Razorfen Kraul" is a plain kill of Charlga.
- Classic leftovers that don't block anything: Death Speaker Jargba next to the new Roogug, Agathelos,
  and two Earthcaller Halmgar spawns 5 yards apart (both also in the Pandaria database).

**Status:** confirmed in game by Four over three runs (2026-10-25): Groyat's spawn, one Roogug,
every boss's credit and loot, scenario 654 at state 3 and achievement 635. Four didn't report on the
pets or the movement separately.

## 2026-10-24

### Maraudon: first test run (Noxxion, Gizlock, Vyletongue)

From Four's first run of the Wicked Grotto, 2026-10-24. All SQL, in
`sql/fixes/world/2026_10_24_07_maraudon_noxxion_gizlock_vyletongue.sql` and
`2026_10_24_08_maraudon_creeping_sludge_combat.sql` `2026_10_24_09_maraudon_celebras_redeemed.sql` `2026_10_24_10_maraudon_movement.sql` and `2026_10_24_11_maraudon_zaetars_spirit.sql`; no rebuild.

#### Noxxion couldn't be targeted
- **Found** (reported by Four): Noxxion (13282) showed as a quest giver with `.gm on`, couldn't be
  targeted, and gave no credit. His template had the "not selectable" unit flag (0x02000000) and the
  quest giver npc flag, and `creature_queststarter` listed him (and Razorlash, 12258) as starters of
  27698 "Servants of Theradras", the quest that asks you to kill them. The Pandaria 5.4.8 database has
  neither the flag nor those rows; its only giver is Zaetar's Spirit (12238).
- **Changed:** Noxxion gets the Pandaria values (npcflag 0, unit_flags 32832, no SmartAI; his fight is
  the core script `boss_noxxion`: Toxic Volley, Uppercut, and every 40 seconds he hides for 15 seconds
  while five Noxxion's Spawn attack). Razorlash loses the quest giver flag. Both bogus starter rows are
  deleted. Noxxion's Spawn (13456) gets the missing scaling row for difficulty 1.
- **Not changed:** the 3 Constrictor Vines and Barbed Lasher standing on Noxxion are spawned exactly
  like that in the Pandaria database too; trim them with `.npc delete` if they're in the way.
- **Status:** confirmed in game by Four (2026-10-24): Noxxion "checked out good".

#### Creeping Sludge left you stuck in combat
- **Found** (reported by Four, `.debug combat` showed a PvE combat ref to Creeping Sludge 324883 after
  walking past it): most Creeping Sludges (12222) carry Poison Shock (22638), which hits everyone
  within 8 yards every 2 seconds. A player it hits is put in combat with the sludge, but the sludge
  never puts the player on its own threat list, so it neither attacks nor evades and the combat never
  ends. No other Maraudon creature has a pulsing damage aura like this.
- **Changed:** `2026_10_24_08_maraudon_creeping_sludge_combat.sql` gives the sludge one SmartAI row:
  when it damages someone, it attacks them. It then fights that player, or, if it can't see them (in
  stealth), evades and drops the combat right away.
- **Status:** confirmed in game by Four (2026-10-24).

#### Celebras the Redeemed stood next to Celebras the Cursed
- **Found** (reported by Four, with a screenshot): the friendly spirit, Celebras the Redeemed (13716),
  was already standing beside the boss before the fight. The core script `celebras_the_cursed`
  summons him on the boss's corpse when it dies, but the world database also spawns him permanently
  (guid 324986; the Pandaria database has the same row).
- **Changed:** `2026_10_24_09_maraudon_celebras_redeemed.sql` deletes the static spawn. He now only
  appears when Celebras the Cursed dies, for 10 minutes.
- **Status:** confirmed in game by Four (2026-10-24).

#### Almost nothing in Maraudon moved
- **Found** (reported by Four: Primordial Behemoths used to patrol, Princess Theradras stood still,
  "much more creatures wandered or had paths"): the BFA world database has no waypoint paths and no
  wandering for any Maraudon mob except a few critters.
- **Changed:** `2026_10_24_10_maraudon_movement.sql`, matched to these spawns by entry and position:
  - 30 waypoint paths from the Pandaria 5.4.8 database (same spawn guids), including a Primordial
    Behemoth, Meshlok's second spawn, Shardlings, Larvae and Snapjaws.
  - 8 paths from the AzerothCore 3.3.5 database: Princess Theradras (a loop around her room),
    Meshlok, Spirit of Veng, a Sister of Celebras pair, a Celebrian Dryad pair, a Stolid Snapjaw, a
    Thessala Hydra and a Corruptor group, with the pairs and the group walking in formation.
  - Random wandering for 218 spawns, with the AzerothCore radius capped at 5 yards (this core's random
    movement doesn't path around walls). Water creatures (Thessala Hydra, Stolid Snapjaw, Rotgrip)
    don't wander.
  - New path ids 349000001 and up.
- **Not changed:** AzerothCore has only one patrolling Behemoth too; the rest stand. Rotgrip's
  classic path is in a different place from his BFA spawn, so he stays put.
- **Status:** confirmed in game by Four (2026-10-24): the new patrols and Rotgrip checked out.

#### Zaetar's Spirit stood beside Princess Theradras
- **Found** (reported by Four, with a screenshot): Zaetar's Spirit (12238) was already standing next to
  Princess Theradras before the fight. Her core script `boss_princess_theradras` summons him where
  she dies, but the world database also spawns him permanently there (guid 324993; the Pandaria
  database has the same row).
- **Changed:** `2026_10_24_11_maraudon_zaetars_spirit.sql` deletes the static spawn. He now appears
  when the Princess dies, for 10 minutes, to give and take the Maraudon quests.
- **Status:** confirmed in game by Four (2026-10-24).

#### Tinkerer Gizlock and Lord Vyletongue stood still and never meleed
- **Found** (reported by Four): Gizlock only used Goblin Dragon Gun, Vyletongue only an occasional
  Smoke Bomb, and neither meleed. Each had two SmartAI scripts mixed in the table: old spell timers plus
  a ranged-hunter template that stops moving and stops melee on aggro and leaves the rest to phase 1
  rows. Nothing sets phase 1, so those rows never ran.
- **Changed:** both scripts replaced with one clean set. They chase and melee, Shoot when the target
  is 5-30 yards away, and use their full kit: Gizlock says his aggro line and uses Bomb (random
  player), Goblin Dragon Gun and Flash Bomb; Vyletongue uses Multi-Shot (random player), Smoke Bomb and
  Blink.
- **Not changed:** Razorlash (Puncture and Cleave) already uses his whole kit; that's all he has.
- **Status:** confirmed in game by Four (2026-10-24): "the boss mechanics" checked out.

### Scarlet Monastery: the "Scarlet Monastery" achievement

- **Found** (reported by Four, after the encounter fix below didn't help): Four sent the client's
  Achievement, Criteria, CriteriaTree, ModifierTree and DungeonEncounter db2 files. "Scarlet Monastery"
  (637, criteria tree 3990) has a single criteria, 533: be the target of spell 132022 (Whitemane's kill
  credit, criteria type 28). Retail Whitemane casts it on everyone when she dies; the spell isn't in the
  client's spell data, so nothing here ever cast it. "Scarlet Halls" (7413) is a plain kill of Koegler
  (59150), which is why that one already worked (confirmed by Four). The encounter rows from
  2026_10_24_06 are still right (DungeonEncounter 1425 is Whitemane on map 1004) but weren't the cause.
- **Changed:** `boss_high_inquisitor_whitemane_mop` gives every player in the instance the type 28
  criteria for 132022 when she dies (`DoUpdateCriteria`), which also covers "Heroic: Scarlet
  Monastery" if it uses the same spell. In `tools/bfa/scarlet-monastery.patch`; no SQL.
- **Status:** confirmed in game by Four (2026-10-24): the achievement unlocked on Whitemane's death.

### Scarlet Monastery: second test run (Fuel Tanks, dungeon and achievement credit)

From Four's second run, 2026-10-24. C++ in `tools/bfa/scarlet-monastery.patch` (new version again),
data in `sql/fixes/world/2026_10_24_06_scarlet_fuel_tank_encounters.sql`.

#### Whitemane gave no dungeon completion and no "Scarlet Monastery" achievement
- **Found** (reported by Four): the scenario counted Whitemane (`.debug scenario` showed progress 1),
  but the achievement stayed locked. `instance_encounters` only had the classic encounters for Scarlet
  Halls and Scarlet Monastery (448 Herod, 450 Whitemane), which belong to the old maps, so killing the
  last boss on the new maps completed no dungeon encounter. The classic rows were also marked as the
  last boss of dungeon finder entries 163 and 164, and the core keeps only one last boss per entry.
- **Changed:** the SQL takes the "last boss" mark off 448 and 450 and adds the Mists encounters, as the
  Pandaria 5.4.8 database has them: 1425 High Inquisitor Whitemane (last boss of 164) and 1420
  Flameweaver Koegler (last boss of Scarlet Halls, 163).
- **Status:** didn't unlock the achievement (Four, second run); the real cause is the kill credit
  spell, see the entry above. The rows are still correct for dungeon encounter credit.

#### Fuel Tanks still couldn't be clicked
- **Found** (reported by Four): clearing the unselectable flag (2026_10_24_04) didn't make the tank
  clickable. Cause not found.
- **Changed:** the tank now also explodes when a player hits it. The SQL gives it the Monster faction
  (14) so it can be attacked, and lets anyone use its spell click (`user_type` 0), since it is no longer
  friendly. `npc_scm_fuel_tank` explodes on a click or on the first hit from a player, and ignores
  damage from creatures.
- **Status:** confirmed in game by Four (hitting the tank sets it off). Clicking it still does nothing.

### Scarlet Monastery: first test run fixes, and the Headless Horseman

From Four's first run, 2026-10-24. The C++ is in `tools/bfa/scarlet-monastery.patch` (same patch,
new version: revert the old one first), the data in
`sql/fixes/world/2026_10_24_04_scarlet_monastery_fuel_tank_burning_man.sql` and
`sql/fixes/world/2026_10_24_05_headless_horseman.sql`.

#### Fuel Tanks couldn't be clicked
- **Found** (reported by Four): the Fuel Tank template (59706) has `UNIT_FLAG_NOT_SELECTABLE`
  (0x02000000) in `unit_flags`, and an unselectable creature can't be clicked, so the spell-click row
  and script never ran.
- **Changed:** the SQL clears that flag on the template, and `npc_scm_fuel_tank` also clears it when
  the tank spawns.
- **Status:** untested in game.

#### Brother Korloff left players burning
- **Found** (reported by Four, with screenshot): after Korloff, the player kept a fire glow with no
  debuff icon until `.unaura all`. Blazing Fists and Firestorm Kick trigger Burning Man (125844, 125852),
  a hidden dummy aura with no duration that is meant for the Training Dummies (achievement). It picks
  its targets by creature entry, and with no `conditions` row the core hit everyone in range.
- **Changed:** `conditions` rows limit both spells to the Training Dummies (64446, 60197).
- **Status:** untested in game. Korloff's fight itself (melee, Flying Kick, Blazing Fists, fire trail,
  loot, dungeon credit) is confirmed by Four.

#### Whitemane never came out after Durand fell
- **Found** (reported by Four): Durand died, Whitemane stayed behind her door, passive and
  unselectable. Not reproduced here, so the exact cause isn't known. Two weak points in the script:
  Whitemane ignored Durand's call if she already counted as "in combat", and if Durand died outright
  (instead of feigning) nothing called her at all.
- **Changed:** Whitemane now only checks her own "intro started" flag. Durand looks her up by the
  instance data or, failing that, the nearest Whitemane within 150 yards, and if he really dies he
  still calls her out (she then fights alone).
- **Status:** untested in game. Thalnos (all abilities, door, scenario credit) is confirmed by Four.

#### The Headless Horseman couldn't be summoned
- **Found:** the classic Horseman script flew him over map 189's coordinates. That map is gone from
  the 8.3.7 client: the Monastery graveyard (map 1004) is the only one left. The Pumpkin Shrine (186267)
  that Hallow's End (game event 12) spawns there had no working summon.
- **Changed:** `boss_headless_horseman.cpp` is replaced by a port of the Pandaria 5.4.8 map-1004
  script:
  - **Pumpkin Shrine** (`go_pumpkin_shrine`): "Call the Headless Horseman." summons him once per
    instance. The caller recites the four rhyme lines, he rises from the soil beside the shrine, circles
    the graveyard and lands, then attacks everyone in range. A wipe despawns him and the shrine works
    again. The shrine's quest turn-ins (11135, 11220) still show.
  - **Phases:** each time his body would die it loses its head (Head of the Horseman, 23775, which
    wanders within 30 yards). While headless the body is immune, confused, regenerates 4% a second and
    whirlwinds. Beat the head to 66% (phase 1), 33% (phase 2) or 0% (phase 3) to end the phase; if the
    body heals to full first, the head comes back and the phase repeats. Cleave (42587) all fight;
    phase 2 adds Conflagration (42380) every 8 to 12 seconds; phase 3 throws pumpkins every 15 seconds
    (52236), which sprout into Pumpkin Fiends unless killed first (`spell_sprouting`, 42281).
  - **Death:** Sir Thomas (23904) appears for 60 seconds, the instance marks the Horseman done, and a
    dungeon finder group queued for "The Headless Horseman" (285) is finished.
  - The SQL binds the scripts, replaces the Horseman texts with the Pandaria set, adds level scaling
    for difficulties 1 and 2 (23682, 23775, 23694, 23904: scaled to you, up to 120), moves the dungeon
    finder arrival for 285 from map 189 coordinates to the Monastery entrance, and adds a reward row for
    levels 86 to 120.
- **Status:** untested in game.

### Scarlet Monastery (map 1004): spawns, scripts and the Blades quest

Found in Four's first run, 2026-10-24. Everything below is in `tools/bfa/scarlet-monastery.patch`
(22nd patch; adds four source files, so run `sudo cmake build` once before building) and
`sql/fixes/world/2026_10_24_03_scarlet_monastery_rework.sql`. The scripts are ported from the
Pandaria 5.4.8 project (alexkulya). None of it has been tested in game yet.

#### The graveyard had the wrong things standing in it
- **Found** (reported by Four): the graveyard had Empowering Spirits, Frenzied Spirits, Piles of
  Corpses, "level ??" Zombified Corpses, Centurions, Flamethrowers and Thalnos together. Compared with
  the Pandaria 5.4.8 database, this one had 18 permanent Empowering Spirits (59893, level 100 to 101).
  Those are Thalnos's summons and should only appear during his fight. It also had 6 Fuel Tanks (59706)
  that should only drop from dead Flamethrowers, and 30 Frenzied Spirits instead of 12. Purifiers were
  20 instead of 40 and Zealots 13 instead of 24. There were two stray Durand copies (60106 and the
  Dashing Strike stalker 60107), and Thalnos and Durand wandered (random movement, 10 yards).
- **Changed:** the SQL replaces every creature on map 1004 with the Pandaria set (167 spawns, guids
  1004000001 and up). Two spawns from this database stay because they belong to its quest chain: the
  entrance Hooded Crusader (64827, quests 31513 and 31514) and the Blade of the Anointed at the pool
  (64854). It also adds Korloff's patrol path and the two drunk Judicators in the graveyard hall.
  Gameobjects were already the same as Pandaria's and are untouched.
- **Status:** untested in game.

#### "Level ??" Zombified Corpses
- **Found:** Zombified Corpse (59771), Fallen Crusader (59884), Empowered Zombie (59930), Evicted Soul
  (59974) and Spirit of Redemption (58592) only had a `creature_template_scaling` row for difficulty 0.
  The dungeon runs as difficulty 1, so they got no scaling and rolled a random level between 31 and 90.
- **Changed:** the SQL copies their difficulty 0 rows to difficulty 1 (level 1 to 100, scaled to you).
- **Status:** untested in game.

#### Fuel Tanks glowed but did nothing
- **Found** (reported by Four): Fuel Tanks have the spell-click flag and `npc_spellclick_spells` row
  (114953), but their SmartAI had nothing to do on a click.
- **Changed:** `npc_scm_fuel_tank`: clicking it blows it up with Barrel Explosion (114952, 10 yards) and
  it despawns. New `conditions` rows make the explosion hit creatures only, never players or other
  tanks. Scarlet Flamethrowers (`npc_scarlet_flamethrower`) now drop a Fuel Tank when they die (it lasts
  5 minutes), and burn the dead with their flamethrower (115506) out of combat.
- **Status:** untested in game.

#### Graveyard trash
- **Changed:**
  - **Pile of Corpses** (`npc_pile_of_corpses`) raises a Zombified Corpse every 10 seconds (114951) until
    it is destroyed. It doesn't move or fight back, and its zombies vanish when it dies.
  - **Zombified Corpses** get faction 1962, which is hostile to players and to the Crusade. When a
    Centurion hits one, it fights back and falls 3 to 5 seconds later.
  - **Scarlet Centurions** (`npc_scarlet_centurion`) cut down zombies within 10 yards while no player is
    fighting them. Against players they Cleave (115519) every 5 to 6 seconds and use Retaliation
    (115511) once, at 20% health.
  - **Frenzied Spirits** (`npc_frenzied_spirit`) stack Frenzied Spirit (115524, more damage and size)
    every 3 to 4 seconds in combat. Pandaria stacks it every 1 to 1.5 seconds; that is slowed here for
    solo play.
  - **The entrance Hooded Crusader** warns "Destroy the Piles of Corpses to stop the Zombified
    Corpses!" (raid warning) the first time a player comes within 30 yards.
- **Status:** untested in game.

#### Scarlet Zealots
- **Changed:** `npc_scarlet_zealot` replaces their SmartAI:
  - Smite (111010) on a random player every 4 to 6 seconds.
  - Heal (111008) on the most hurt Scarlet within 40 yards every 9 to 14 seconds.
  - Resurrection (111670) on a dead Fanatic, Purifier, Zealot, Judicator or Initiate within 30 yards
    every 15 to 25 seconds. The body gets up when the cast finishes.
  - When one dies it leaves a Spirit of Redemption (58592) for 12 seconds. The spirit can't be
    attacked and keeps healing (111024) the most hurt Scarlet.
- **Status:** untested in game.

#### Thalnos the Soulrender had no fight
- **Found:** Thalnos (59789) had no script and no SmartAI rows.
- **Changed:** `boss_thalnos_the_soulrender`:
  - Spirit Gale (115289) on a random player every 7.5 to 13 seconds.
  - Raise Fallen Crusader (115139), a 5-second channel that raises a Fallen Crusader (59884) every
    second. The Crusaders cast Mind Rot (115144) every 3.5 to 4.2 seconds. First at 6.5 seconds, then
    20 seconds after each Empowering Spirits.
  - Evict Soul (115297) every 25 seconds, on someone other than the tank when there is one. The
    Evicted Soul (59974) it spawns copies its player's looks and attacks them.
  - Empowering Spirits (115147) every 40 seconds. Each spirit turns into an Empowered Zombie (59930)
    after 5 seconds unless it is killed first.
  - His yells and the two raid warnings come from the Pandaria database. All his adds despawn when he
    dies or resets.
  - New `spell_areatrigger` / `areatrigger_template` 220 rows: the pool Spirit Gale leaves (3 yards)
    puts its damage-over-time (115291) on players standing in it. The 3-yard size is a guess: neither
    database had this data.
  - The Graveyard Door (211844) opens when he dies.
- **Status:** untested in game.

#### Brother Korloff had no fight
- **Found:** Korloff (59223) had no script and no SmartAI rows.
- **Changed:** `boss_brother_korloff`:
  - Flying Kick every 25 seconds: he leaps at a player more than 5 yards away (or the tank), knocking
    them back (114488). Where he lands, Firestorm Kick (113764) burns everyone around him for 6 seconds.
  - Blazing Fists (114807), a 6-second channel of punches at the tank, every 20 seconds.
  - Rising Flame (114410), +10% damage for every 10% of health he loses.
  - Below 50% health he leaves Scorched Earth (59507, burning ground, 114464) where he walks; each
    patch lasts 30 seconds.
  - He patrols his room (Pandaria path), and the cathedral door (210564) opens when he dies.
- **Status:** untested in game.

#### Commander Durand and High Inquisitor Whitemane
- **Found:** Durand (60040) had no script. Whitemane (3977) still ran the old Cathedral script for the
  Mograine fight (`boss_high_inquisitor_whitemane`), and her lines were the old ones.
- **Changed:** `boss_commander_durand` and `boss_high_inquisitor_whitemane_mop`:
  - Durand uses Flash of Steel (115629) six times in a row on the farthest player, every 21 to 26
    seconds. He also uses Dashing Strike three times, every 24 seconds: line damage (115739) to a
    random player, then he comes out behind them.
  - When Durand "dies" the first time he only feigns it. Whitemane's door (210563) opens and she walks
    out and fights at range: Holy Smite (114848), Heal (36678) on herself, and Mass Resurrection
    (113134) every 20 seconds while dead Scarlet trash lies within 80 yards.
  - At 50% health she casts Deep Sleep (9256) on everyone near and a shield on herself. She then walks
    to Durand and raises him with Scarlet Resurrection (9232; a new `conditions` row lets it target
    Durand). From then on both fight until dead, and she heals Durand when he is lower than her.
  - A wipe resets both. When both are dead, the Hooded Crusader (64842) comes out of her room.
- **Status:** untested in game.

#### "Unto Dust Thou Shalt Return" couldn't be finished
- **Found** (reported by Four): the Blades of the Anointed said "Requires High Inquisitor Whitemane's
  corpse". That is a spell focus (gameobject 214291) Whitemane is meant to leave when she dies, with
  spell 126789, and nothing cast it. Even with it there, the Blades' spells (126787, 126843) only send
  an event (33000 / 33001) that nothing handles, so there was no quest credit.
- **Changed:** Whitemane casts 126789 as she dies. New `spell_scm_blades_of_the_anointed`
  (`spell_script_names` for both spells) gives the quest credit (64835 for quest 31514, 64840 for
  31516) when the Blades are used at her corpse. The Hooded Crusader who appears after the fight
  (64842) now also takes quest 31514 (`creature_questender`), as well as the entrance crusader.
- **Status:** untested in game. Until it is in, `.quest complete 31514` finishes the quest.

#### Instance script
- **Changed:** `instance_scarlet_monastery` was registered for the old map 189, which no longer exists
  in 8.3.7. It is now registered for map 1004. It keeps the Headless Horseman and Pumpkin Shrine data,
  and adds boss states for Thalnos, Korloff, Durand and Whitemane and the three doors.
- **Status:** builds; untested in game. The Headless Horseman script itself is still the old map 189 one
  (its flight path is in old coordinates), so summoning him at the Pumpkin Shrine is not expected to
  work yet.

## 2026-10-23

### Scarlet Halls and Scarlet Monastery: getting in and out

Found in Four's first visit.

#### The Dungeon Finder dropped you outside Scarlet Halls
- **Found** (reported by Four): queueing for Scarlet Halls put you on map 1001 at 1610.83, -323.43,
  18.67, with no ground under you. That is the old Armory entrance (map 189). `lfg_dungeon_template`
  row 163 (now Scarlet Halls, normal) was never moved to the new map. Row 164 (Scarlet Monastery,
  normal) had the right x and y but the old Cathedral height, 18.67 instead of 0.99.
- **Changed:** new `sql/fixes/world/2026_10_23_01_scarlet_entrances_exits.sql` sets 163 and heroic 473
  to 837.23, 615.755, 12.8115 (facing 4.75989). Four picked that spot with `.gps`, a few yards back
  from the Pandaria 5.4.8 value (836.666, 605.141). (Their first `.gps` gave the selected crusader's
  spot instead.) It sets 164 to 1124.64, 512.467, 0.989549
  (facing 1.5708), the Pandaria value. Heroic Scarlet Monastery (474) has no row and uses the door's
  target, which was already right.
- **Status:** the Dungeon Finder put Four inside Scarlet Halls on 2026-10-23 (old spot). The moved spot
  is untested.
- **Changed** (Four's request, 2026-10-24): new `sql/fixes/world/2026_10_24_02_scarlet_halls_arrival.sql`
  moves the arrival spot for 163, 473 and the door's `world_safe_locs` 4077 to Four's new `.gps`:
  821.987, 608.059, 13.5985, facing 0.021594 (into the hall).
- **Status:** untested in game.

#### The Scarlet Halls door outside did nothing
- **Found:** area trigger 614 (the Scarlet Halls door) points at WorldSafeLoc 4077, and that row was
  missing from `world_safe_locs`. The core skips a teleport whose target is missing, at startup.
- **Changed:** the same SQL adds `world_safe_locs` 4077: map 1001, the same spot as the Dungeon Finder
  (837.23, 615.755, 12.8115). This core reads `Facing` as radians (`ObjectMgr::LoadWorldSafeLocs`), so
  it is 4.75989.
- **Status:** loads without errors; walking through the door is untested.

#### No way out of either dungeon
- **Found** (reported by Four): once inside Scarlet Monastery you couldn't walk out. `areatrigger_teleport`
  had no exit row for either new map. The Pandaria database has them as triggers 7801 and 7802.
- **Changed:** the same SQL adds 7801 (Scarlet Halls exit, to WorldSafeLoc 3626, 2869.32, -820.82,
  160.33) and 7802 (Scarlet Monastery exit, to 3623, 2915.34, -801.58, 160.33). Both are the courtyard
  spots the old wings used.
- **Status:** the core loads 614, 7801 and 7802 without errors (Four's `Errors.log`, 2026-10-23).
  Walking through them is untested.

#### Two Hooded Crusaders on top of each other at the Scarlet Halls entrance
- **Found** (reported by Four): two quest givers stood on the same spot. One offered Rank and File
  and Just for Safekeeping, Of Course; the other showed the same quests greyed out. 64738 (guid
  13241581) gives the normal quests 31490 and 31493 (from level 26). 64764 (guid 13241582) gives the
  heroic copies 31495 and 31497 (level 90). Both spawned in normal and heroic (`spawnDifficulties` 1,2).
- **Changed:** new `sql/fixes/world/2026_10_23_02_scarlet_halls_hooded_crusaders.sql`: 64738 spawns
  only in normal (1), 64764 only in heroic (2).
- **Status:** confirmed in game by Four on 2026-10-23 (one crusader in normal).

#### Starving Hounds kept you knocked down
- **Found** (reported by Four): after the first Starving Hound (58876) pack jumped you, you lay on the
  floor and never got up; only `.combatstop` freed you. The hounds cast Hungry Dog (111582) every 12 to
  15 seconds. It is a 30-second channel that stuns its target and ends early only if the hound is
  interrupted. That's a group mechanic (someone else knocks the dog off you), and with four hounds per
  pack a solo player stayed stunned.
- **Changed:** new `sql/fixes/world/2026_10_23_03_scarlet_halls_hounds.sql` replaces the hound's SmartAI.
  Every 20 to 25 seconds in combat it runs actionlist 5887600: cast Hungry Dog on its target, then 4
  seconds later interrupt its own Hungry Dog channel, which removes the stun.
- **Status:** replaced the same day by the C++ hound in `scarlet-halls.patch` (below), which keeps the
  4-second cap. `2026_10_23_05` removes this action list again.

#### Angry Hounds showed as neutral
- **Found** (reported by Four): Angry Hound (58674) was level 1 with faction 7 (neutral creature). It
  is an elite with its own loot table, and the Pandaria 5.4.8 database has it hostile at level 30.
- **Changed:** the same SQL sets faction 14, level 29 to 90, matching the Starving Hounds next to it.
- **Status:** untested in game.

#### Codex of the Crusade almost never dropped
- **Found** (reported by Four): Flameweaver Koegler (59150) didn't drop the Codex of the Crusade for
  "Just for Safekeeping, Of Course". The normal item 87267 (quest 31493) had `Chance` 1 and
  `QuestRequired` 0. The heroic item 87268 (quest 31497) used loot mode 2, which this core never turns on.
- **Changed:** new `sql/fixes/world/2026_10_23_04_scarlet_halls_codex.sql` sets both to `Chance` 100,
  `QuestRequired` 1, `LootMode` 1: they drop every kill, only for players on the quest.
- **Status:** untested in game.

### Scarlet Halls: the events and bosses

Four called Scarlet Halls done on 2026-10-24, after five runs. The per-fix statuses below say which
parts were seen working in game.

Found in Four's first full run (2026-10-23). Most of Scarlet Halls had no working script in this core:
the instance had no instance script, the bosses ran short stubs, and the events had neither scripts nor
the creatures they need. New `tools/bfa/scarlet-halls.patch` ports the Pandaria 5.4.8 scripts
(`src/server/scripts/EasternKingdoms/ScarletHalls/`: `scarlet_halls.cpp` is new, the instance script,
the header and the three boss files are rewritten, and the script loader registers them). New
`sql/fixes/world/2026_10_23_05_scarlet_halls_rework.sql` supplies the spawns, yells and bindings.
Trash that already had working SmartAI (Myrmidons, Evangelists, Evokers, Scholars, Pupils and others)
keeps it.

#### The dungeon had no instance script
- **Found:** `instance_template` for map 1001 had no script, and the core had none to register: no
  boss states, so no doors and nothing to tell the codex crusader that Koegler died.
- **Changed:** the patch's `instance_scarlet_halls` tracks the three bosses and Lindon's gauntlet, and
  opens Lindon's gate (212160) and Braun's fire wall (210097) when they die. Herod's Door (210480)
  closes while Harlan is fought. The SQL sets the instance script.
- **Status:** untested in game.

#### Half the dungeon's creatures were missing
- **Found:** map 1001 had 84 spawns, a partial and slightly shifted set. Braun's six Obedient Hounds,
  the ten Scarlet Guardians and Sergeant Verdone at his exit, the stakes, buckets of dog food, archery
  targets, cannons and all 71 Books were missing, and so were Lindon's gate, Braun's fire wall and the
  heroes' statues in Harlan's room. The only door was the old Armory's Herod's Door (101854).
- **Changed:** the SQL replaces every map 1001 spawn except the two entrance Hooded Crusaders with the
  Pandaria set: 253 creatures (guids 1001000001+, with the 20 patrol paths) and 27 gameobjects. The
  challenge mode door and orb, the herbs and a second portal are left out.
- **Status:** the SQL runs twice without errors on a copy of this database. Untested in game.

#### Commander Lindon's archery hall had no event
- **Found** (reported by Four): Lindon (59191) and his Master Archers (59175) were neutral (faction 7)
  and just stood there to be tanked.
- **Changed:** they are hostile (14). When Lindon sees you, his archers shoot Piercing Arrow down the
  hall and he uses Shield Breaker on anyone within 18 yards. Click a Reinforced Archery Target to carry
  it as a shield: Heroic Defense, 75% less damage taken but slower and no attacking. Stepping into the
  hall (area trigger 7532) sets off a line of Exploding Shots on the floor. Within 10 yards of Lindon
  the volleys stop and the whole crew draws blades; Heroic Defense drops then, and past the hall.
  Simplified: the archery target walks just ahead of you instead of riding on you as a vehicle.
- **Found** (Four's run, 2026-10-23): the archery target trailed behind, didn't cut the arrows' damage,
  and kept following after Lindon died. Heroic Defense was never applied: its first effect makes the
  player a vehicle for the target, and cast on a player that isn't one it never landed.
- **Changed:** the target adds the aura directly, walks 2 yards in front of you (you're slowed by 65%
  while carrying it), and goes back on its stand as soon as the aura is gone. It can't be picked up
  once Lindon is dead.
- **Found** (Four's second run, 2026-10-23): Heroic Defense now works (slowed, arrows hit for less),
  but the target still walked behind you. It used the follow movement, which stops moving whenever it
  is within 3 yards of you, so once behind you it stayed there.
- **Changed:** every quarter second the target runs to the point 2.5 yards in front of you and turns
  to face the way you face.
- **Found** (Four's third run, 2026-10-23): the target now stays in front (seen in Four's video). But
  after Lindon's Shield Breaker knocked Four down, the character was invisible except for the weapons,
  floating and oversized, even back in Stormwind, until `.unaura all`. Shield Breaker (125492) fires
  two shells: 125507 knocks you down and strips Heroic Defense (meant), and 125493 transforms its
  targets into Invisible Man (64188) with no time limit. 125493 picks targets by creature entry, and
  with no conditions row the core falls back to every enemy within 13 yards, so it hit the player.
- **Changed:** new `sql/fixes/world/2026_10_23_06_scarlet_halls_shield_breaker.sql` limits 125493 to
  the Reinforced Archery Target (59163). After the knockdown the target goes back on its stand.
- **Found** (Four's fourth run, 2026-10-23): the target still trailed the player, bullseye towards
  the player. Four's source turned out to still hold the `ea91d85` version of the patch (the two
  updates before this one never reached the build), so the quarter-second positioning above was never
  tried in game.
- **Changed:** the target now moves every 0.1 seconds at 1.5 times your speed, stays in front of you
  (further ahead while you walk), and keeps its facing while it moves.
- **Found** (Four's fifth run, 2026-10-24): it now leads, but too far out and with the bullseye towards
  the player. The bullseye is on the front of the model after all (the old follow movement had turned
  the model to face the player).
- **Changed:** it faces the way you face, bullseye towards the archers, about 1 yard in front of you
  (plus a little while you walk).
- **Status:** Four got past Lindon on 2026-10-23; the volleys, the exploding floor and the melee
  switch weren't reported on. Heroic Defense confirmed by Four on 2026-10-23, leading confirmed on
  2026-10-24. The distance, facing and Shield Breaker fixes are untested. Lindon has no loot table (`lootid` 0 here and in the
  Pandaria 5.4.8 database), so he drops nothing.

#### Starving and Angry Hounds, and the dog food buckets
- **Found:** the buckets of dog food did nothing and the Angry Hounds weren't chained.
- **Changed:** Starving Hounds (58876) are C++ now, Hungry Dog still capped at 4 seconds. Click a Bucket
  of Meaty Dog Food (65379), then throw it (out of combat) next to a Vigilant Watchman: he is pinned
  down and every hound within 20 yards turns on him, then sits down to eat. Angry Hounds (58674) are
  chained to their stakes and only attack when you come within 5 yards, or when attacked.
- **Found** (Four's run, 2026-10-23): an Angry Hound attacked from stealth stayed passive, and one that
  had aggroed ran back to its stake and reset when you stepped back.
- **Changed:** an attack wakes the hound, and when you go past the end of its chain (8 yards from the
  stake) it waits at the stake still in combat instead of resetting, and comes back at you when you're
  in reach.
- **Found** (Four's second run, 2026-10-23): the hounds now fight back, but they still went back to
  the stake when you stepped away. Once a hound is in the fight its chain should be broken.
- **Changed:** when a hound is attacked or attacks you, the Leashed aura comes off and it chases you
  like any other hound. The chain-length limit is gone. A hound that resets is chained again.
- **Found** (Four's third run, 2026-10-23): the hound still showed the Chained debuff ("Chained to a
  post. Always attacks nearest enemy.") after being hit. That is a separate aura, Chained (111641),
  from `creature_template_addon`; only Leashed (103169) was being removed. Also, a hound that pulled
  itself by you walking up to it should stay chained: only an attack breaks the chain.
- **Changed:** the first damage, or a hostile spell such as a stun, removes Chained and Leashed and
  frees the hound to chase you anywhere. Until then it is chained: it attacks anyone within 5 yards
  but waits at its post, still in combat, for anyone past 8 yards. A hound that resets gets Chained
  back.
- **Status:** confirmed by Four on 2026-10-24 ("Angry Hound is fixed").

#### Houndmaster Braun
- **Found** (reported by Four): melee, Death Blossom and Bloody Mess only; an easy fight.
- **Changed:** Piercing Throw every 7 to 9 seconds, Death Blossom as a leap that spins where it lands,
  one Obedient Hound called at 90, 80, 70 and 60%, Bloody Rage at 50%. At 15% his own hounds turn on
  him: he stops fighting, is eaten, and dies 12 to 15 seconds later with the kill credited to you. The
  hounds then run to his exit and kill the guards there.
- **Status:** confirmed by Four on 2026-10-23 (yells, hounds, kill credit, the guards at the exit).

#### Armsmaster Harlan
- **Found** (reported by Four): melee and Dragon's Reach only.
- **Changed:** Call for Help every 20 to 25 seconds (two Scarlet Defenders in Heavy Armor run in along
  the balconies; break the armor and they are Unarmored), Heroic Leap to the middle of the room
  followed by Blades of Light spinning round it (every second, damage to everyone within 8 yards), and
  Berserker Rage at 50%. Simplified: Blades of Light doesn't pick players up.
- **Status:** confirmed by Four on 2026-10-23 (yells, Call for Help, bonus objective).

#### Flameweaver Koegler meleed too much
- **Found** (reported by Four): far too much melee for a caster, and Quickened Mind (113682) didn't make
  his casts instant. Its cast-time cut is a spell modifier, which only reaches player spell families.
- **Changed:** he casts back to back: Pyroblast, Fireball Volley every 13.5 seconds, and Book Burner on
  a book case (it burns and hurts anyone in front of him). Quickened Mind now gives him three instant
  casts. Every 30 seconds he teleports to the middle and channels Greater Dragon's Breath for 10
  seconds, a cone that sweeps round the room.
- **Status:** confirmed by Four on 2026-10-23: "All scripts fired off successfully".

#### The Hooded Crusader never came for the codex
- **Changed:** the crusader outside the library stays hidden until Koegler dies, then walks in and asks
  for the codex.
- **Status:** confirmed by Four on 2026-10-23 (codex dropped, quest turned in, dungeon complete).

#### Smaller things
- **Changed:** 22 yells and emotes for Braun, Harlan, Koegler, Lindon, the archery target and the
  crusader (none existed). Scarlet Treasurers drop a pile of Gold Coins. The Scarlet Cannons get their
  Cannoneers, who fire Cannon Blast at players in the courtyard.
- **Status:** yells and the Treasurer's gold untested in game.

#### The cannons only made smoke
- **Found** (Four's run, 2026-10-23): the Scarlet Cannoneers (59293) stood inside the cannons and
  could only hurt you in melee. They were summoned on the cannon's own spot. Their shell was fired by
  the cannon (58726), which is a level 1 friendly stalker, so its 15-yard Cannon Blast (111569) found
  no enemies to hit.
- **Changed:** the cannoneer fires the shell himself, at a random player within 40 yards every 3 to
  5 seconds, so it hits at his level. The shell only hits within 3 yards of where it lands and takes a
  moment to fly, so he leads a moving target by its speed and the flight time. He stands 2 yards
  behind the gun (Ready Cannon, 113933, put him out at the muzzle).
- **Found** (Four's fifth run, 2026-10-24): the shells now land and hurt ("the cannon shots work"),
  but the cannoneers stood in front of the muzzles. The stalker faces the breech end of its gun, not
  the muzzle.
- **Changed:** each cannoneer stands beside the breech (1.5 yards towards it and 1.3 yards out to the
  side, stopping short of any wall), facing the way the gun fires.
- **Status:** cannon damage confirmed by Four on 2026-10-24; the new standing spot is untested.

#### Trash dropped almost nothing
- **Found** (reported by Four, 2026-10-23/24): "some enemies only drop money", loot "not the same
  density". These are the Mists of Pandaria versions of the Scarlet mobs, and their loot tables were
  built for heroic: most rows are heroic-only (LootMode 2, a mode the core never gives creatures), and
  the normal rows add up to 29-47% for one item per kill, with no world-drop reference tables. The
  Pandaria 5.4.8 database splits them the same way. Deadmines trash, for comparison, has 90-330% plus
  reference drops, and the old Classic Scarlet Monastery mobs still in the database about 55% (not
  counting quest items) plus 25-45% of reference drops.
- **Changed:** new `sql/fixes/world/2026_10_24_01_scarlet_trash_loot.sql` adds the normal-mode loot of
  a Classic Scarlet mob of the same level to each trash mob: Scarlet Augur (4284) for the 11 Scarlet
  Halls humanoids, Scarlet Monk (4540) for the 7 Scarlet Monastery humanoids, Haunting Phantasm
  (6427) for the Frenzied Spirits. Quest-only rows are skipped and rows a mob already had are kept, so
  a Scarlet Myrmidon goes from about 34% to 49% for an item plus 26 reference tables (cloth, greens,
  recipes). Bosses and the hounds are unchanged. 1,868 rows; the file can be run again.
- **Status:** untested in game. The "You don't have permission to loot that corpse" messages are not
  explained yet.

#### Dying sent you to Westfall
- **Found** (Four's run, 2026-10-24): after dying to Braun, the spirit healer was at Sentinel Hill in
  Westfall. Neither Scarlet Halls (zone 6052) nor Scarlet Monastery (zone 6109) had a row in
  `graveyard_zone`, so the core fell back to its default Alliance graveyard.
- **Changed:** new `sql/fixes/world/2026_10_24_00_scarlet_graveyards.sql` links both zones to the
  Scarlet Monastery graveyard in Tirisfal Glades (`world_safe_locs` 1874), as the Pandaria 5.4.8
  database does.
- **Status:** untested in game.

#### To pick up these fixes
New patch on top of the others: apply it and rebuild. It adds a new source file (`scarlet_halls.cpp`),
so CMake has to re-run its configure step once (`cmake build`, which keeps your settings); without it
the link fails with `undefined reference to AddSC_scarlet_halls()`. Then the SQL, and restart
`worldserver`.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:tools/bfa/scarlet-halls.patch | git apply
sudo cmake build
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_23_01_scarlet_entrances_exits.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_23_02_scarlet_halls_hooded_crusaders.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_23_03_scarlet_halls_hounds.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_23_04_scarlet_halls_codex.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_23_05_scarlet_halls_rework.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_23_06_scarlet_halls_shield_breaker.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_24_00_scarlet_graveyards.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_24_01_scarlet_trash_loot.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_24_02_scarlet_halls_arrival.sql | mysql -u root -p bfa_world
```

## 2026-10-19

### World: Sewer Beast (Stormwind canals)

Merged to `main` with PR #15 on 2026-10-25.

#### The Sewer Beast walks the canal pathways
- **Found** (reported by Four): the Sewer Beast (3581, rare crocolisk), guid 308329, walked the canal
  walkways instead of staying under water. It has three spawns, pooled by core update
  `2026_09_09_00_world_sewer_beast.sql` so only one is up at a time; that update also set
  `MovementType` 1 and `spawndist` 25 on all three. Two of the spawn points are at walkway height:
  308329 at (-8583.18, 522.841, 92.7076) (the walkway guards next to it stand at z 92.71) and 10604700
  at (-8781.6, 488.886, 92.6396). Only 52499 (-8560.69, 486.619, 85.8912) is on the canal floor. Random
  movement in this core goes in a straight line to a random point up to `spawndist` away and up to 10
  yards higher, so even from the floor a 25 yard wander reaches the walkways.
- **Changed:** new `sql/fixes/world/2026_10_19_06_stormwind_sewer_beast.sql`, using the
  alexkulya/pandaria_5.4.8 world database as the reference (same three spawns, the two floor ones
  standing still):
  - 10604700 moves to Pandaria's position for it, (-8783.6, 487.416, 85.8914), orientation 0.528863, on
    the canal floor.
  - 308329 is removed (`creature`, `creature_addon`, `pool_creature`): no data checked has a canal floor
    position for it. The pool keeps 52499 and 10604700, one up at a time.
  - Every Sewer Beast: `MovementType` 1 -> 0, `spawndist` 25 -> 0 (standing still, as in the Pandaria
    data).
- **Status:** confirmed in game by Four on 2026-10-19.

### To pick up the Sewer Beast fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo pull
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_19_06_stormwind_sewer_beast.sql
```
Then restart worldserver.

### Gnomeregan

Merged to `main` with PR #16 on 2026-10-23. Found in a survey before the first run and in Four's run.

#### Blastmaster Emi Shortfuse couldn't be talked to; Electrocutioner 6000 yelled twice
- **Found:** Emi (7998) starts the trogg event from her gossip option "I am ready to begin." (menu
  1080, `OptionNpcFlag` 1), but her `npcflag` was 2 (questgiver) and she has no quests, so there was
  nothing to click. The Pandaria 5.4.8 world database has `npcflag` 1. Electrocutioner 6000 (6235) had
  two "On Aggro - Say Line 0" SmartAI rows (ids 0 and 3, from two script versions).
- **Changed:** new `sql/fixes/world/2026_10_19_08_gnomeregan_emi_electrocutioner.sql`:
  `creature_template` 7998 `npcflag` 2 -> 1; `smart_scripts` 6235 id 3 deleted.
- **Status:** Emi confirmed in game by Four on 2026-10-19 (her event ran to the end, Grubbis counted
  for his objective). Electrocutioner untested.

#### Way too many troggs in Emi's event
- **Found** (reported by Four): Emi's event summons every trogg wave, her explosive charges (183410),
  Grubbis and Chomper, and three red rockets at the end. The DB also had all of it spawned from the
  start at the same spots (`VerifiedBuild` 0: a sniff of the event saved as spawns), so the two tunnels
  emptied out on top of the waves.
- **Changed:** new `sql/fixes/world/2026_10_19_09_gnomeregan_emi_event_prespawns.sql` deletes creature
  guids 324522 to 324554 (30 Caverndeep Ambushers 6207, 1 Caverndeep Burrower 6206, Grubbis 7361,
  Chomper 6215) and gameobject guids 189336 to 189339 (Explosive Charge 144065) and 189340, 189341
  (red rockets 103820), with their `gameobject_addon` rows. The event still summons its own. The original
  rows are in the world dump.
- **Status:** untested in game.

#### Stuck in combat after killing an Irradiated Pillager
- **Found** (reported by Four): right after killing an Irradiated Pillager (6329), `.debug combat`
  still listed it ("[PvE] Irradiated Pillager (SpawnID 324438)") and Four stayed in combat until
  `.combatstop`. Two SmartAI rows (ids 2 and 5, two script versions) cast Radiation (9798) on death. In
  8.3.7 that puts a permanent aura (duration index 21) on every enemy within 13 yards that triggers
  Radiation (9770) damage every 3 s, cast by the dead Pillager, so each tick put the player back in
  combat with the corpse.
- **Changed:** new `sql/fixes/world/2026_10_19_10_gnomeregan_irradiated_pillager_death.sql` deletes
  `smart_scripts` 6329 ids 2 and 5. The living Pillager's own Radiation auras (9769, and 9798 on 18
  spawns, from `creature_addon` and On Reset) stay.
- **Status:** untested in game.

#### Mekgineer Thermaplugg: bombs from the Gnome Faces, one Knock Away
- **Found** (reported by Four): Thermaplugg (7800) used Knock Away very often. Walking Bombs (7915)
  appeared in the middle of the room and then under him wherever he stood, never from the Gnome Faces
  on the walls. One bomb stood below a face before the fight, and bombs kept meleeing after they had
  detonated. Kill credit and the Gnomeregan achievement worked. His SmartAI mixed two script versions:
  two rows each with ids 3 and 5, Knock Away three times (10101 twice, 11130 once), bombs summoned on
  himself and at one fixed spot, and broken links. The bomb's Detonation row linked to id 3, which
  doesn't exist, so its despawn never ran.
- **Changed:** new `sql/fixes/world/2026_10_19_11_gnomeregan_thermaplugg.sql`:
  - Thermaplugg's `smart_scripts` rewritten: Knock Away (10101) every 12 to 15 s; every 12 to 16 s
    one of six action lists (780000 to 780005, picked at random) summons a Walking Bomb (despawns
    after 60 s) in front of one of the six Gnome Face pedestals: 15 yards from the Gnome Face
    gameobject towards the centre of the six faces (-522.75, 670.10), at z -325.0. The first version
    put them 40% of the way to the faces' buttons, inside the pedestals, and Four saw none. Four's
    `.gps` in front of Gnome Face 06's pedestal (-553.38, 643.70, floor -327.27) is 1.8 yards from
    that face's spot. The yells, Pound (74720), Steam Blast (93655) and Welding Beam (52778) are as before.
  - Walking Bomb: Detonation (4043) now links to the despawn; a summoned bomb joins the fight
    against everyone in the instance (`SET_IN_COMBAT_WITH_ZONE`).
  - The bomb spawned from the start, creature guid 324517, is deleted.
  - The faces' buttons (142214 to 142219) still do nothing.
- **Status:** confirmed in game by Four on 2026-10-19 (bombs walk out in front of the faces).

#### To pick up the Gnomeregan fixes
SQL only, then restart `worldserver` (templates and SmartAI load at startup).
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_19_08_gnomeregan_emi_electrocutioner.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_19_09_gnomeregan_emi_event_prespawns.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_19_10_gnomeregan_irradiated_pillager_death.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_19_11_gnomeregan_thermaplugg.sql | mysql -u root -p bfa_world
```

### The Stockade

Merged to `main` with PR #16 on 2026-10-23.

#### Lord Overheat's Fiery Core didn't always drop
- **Found** (reported by Four): the first kill of Lord Overheat (46264) gave no Lord Overheat's Fiery
  Core (62305) for "By Fire Be Saved!" (27737); after `.respawn`, a second kill dropped it. The loot row
  only drops for players on the quest (`QuestRequired` 1), but its `Chance` was 36.5696, so roughly two
  kills in three dropped nothing for the quest.
- **Changed:** new `sql/fixes/world/2026_10_19_07_stockade_overheat_core.sql`: `creature_loot_template`
  46264 / 62305 `Chance` 36.5696 -> 100.
- **Status:** confirmed in game by Four on 2026-10-23 (the core dropped on the first kill, on an alt).
  The dungeon objectives were fine: `.debug scenario` showed Lord
  Overheat's objective at progress 2 (both kills counted), and the one-step objectives finished
  with the achievement after Hogger. What looked missing was most likely just the core quest.

#### To pick up the core fix
SQL only, then restart `worldserver` (it loads loot tables at startup).
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_19_07_stockade_overheat_core.sql | mysql -u root -p bfa_world
```

### Crash: picking open a lockbox or junkbox

Merged to `main` with PR #16 on 2026-10-23.

- **Found** (reported by Four): Pick Lock on a Battered Junkbox (16882, looted in The Stockade) crashed
  the worldserver at once, and the client was disconnected. Four's gdb backtrace: `SIGSEGV` in
  `GameObject::GetGOInfo (this=0x0)` called from `Spell::EffectOpenLock` at `SpellEffects.cpp:1936`.
  Upstream commit 9d1bf0d ("Core/CPP: Fix Mining Gain Skill") added a gathering skill-up block at the
  end of `EffectOpenLock` that reads `gameObjTarget->GetGOInfo()` without checking `gameObjTarget`.
  When the lock is on an item, `gameObjTarget` is null, so every item lock opened with a spell (rogue
  Pick Lock, and any key or spell that opens an item lock) crashes the server. Still in upstream HEAD
  (51fad1a) at the time of writing. The junkbox loot tables are fine.
- **Changed:** new `tools/bfa/open-lock-crash.patch` (`src/server/game/Spells/SpellEffects.cpp`): that
  block now runs only when the target is a gameobject (`goInfo` is null for an item). Opening chests and
  gathering nodes is unchanged.
- **Status:** confirmed in game by Four on 2026-10-19 (Battered Junkbox picks open, no crash).

#### To pick up the lockbox crash fix
A new patch on top of the others, the build and a restart.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:tools/bfa/open-lock-crash.patch | git apply
grep -c "Pick Lock on a junkbox" src/server/game/Spells/SpellEffects.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 1. Then restart `worldserver`.

### World: Stormwind (Innkeeper Allison, stray spawns, Miss Danna's tour)

Merged to `main` with PR #13 on 2026-10-19.

#### Innkeeper Allison has no inn or vendor options
- **Found** (reported by Four): Innkeeper Allison (6740) in the Trade District only offered "Make this
  inn your home" and "Let me browse your goods" while her Hallow's End quest was available. She is the
  only big-city innkeeper set up differently: `gossip_menu_id` 0 and no `ScriptName`, while Innkeeper
  Farley (295), Brianna (6727), Belm (1247), Firebrew (5111), Norman (6741) and the other city
  innkeepers use `ScriptName` `npc_innkeeper` with a real innkeeper menu. `npc_innkeeper`
  (`src/server/scripts/World/npc_innkeeper.cpp`) builds the inn, vendor and Hallow's End "Trick or
  Treat" options itself. Why the default menu 0 path left her without options wasn't pinned down; the
  fix gives her the same setup as the innkeepers that work.
- **Changed:** new `sql/fixes/world/2026_10_19_03_stormwind_innkeeper_allison.sql`:
  `creature_template` 6740 `gossip_menu_id` 0 -> 342 (the menu her own SmartAI's Trick or Treat rows
  expect, also used by Innkeeper Brianna), `ScriptName` '' -> 'npc_innkeeper'. Her SmartAI
  (/flex credit for Flexing for Nougat) is unchanged.
- **Status:** confirmed in game by Four on 2026-10-19.

#### A Prisoner on the bridge and Gil under it
- **Found** (reported by Four): a Prisoner (53527, guid 300000881) stood alone in the middle of the bridge
  between the Trade District and the Mage Quarter, and Gil (3504, guid 189600) was stuck under the bridge
  next to it.
  - The Prisoner is the only spawn of 53527 on the server, with no waypoints, formation or SmartAI: the
    guard escort it belongs to doesn't exist here.
  - Gil's spawn (`VerifiedBuild` 0, not sniffed) had no path or formation and just stood under the
    bridge. He comes back on his own walking path in the Miss Danna fix below.
- **Changed:** new `sql/fixes/world/2026_10_19_04_stormwind_stray_spawns.sql` deletes both spawns
  (`creature` and `creature_addon` guids 300000881 and 189600). The file has the rows to put back in its
  comments.
- **Status:** confirmed in game by Four on 2026-10-19.

#### Miss Danna, her school group and Gil were missing from Stormwind
- **Found** (asked by Four, who checked Wowhead and Wowpedia: she should still walk her tour): Miss
  Danna (3513) and the children Pat (3505), Andi (3507), Mikey (3508), Geoff (3509), Twain (3510),
  Steven (3511) and Jimmy (3512) had creature templates and SmartAI but no spawns, in the dump or in
  any core update. Their SmartAI here started a `waypoints` path 3513 that doesn't exist, and Miss
  Danna, Steven and Jimmy had no `creature_text`. Gil (3504) only had the stray spawn under the bridge.
- **Source:** the alexkulya/pandaria_5.4.8 world database (`sql/base/world_04_03_2023.zip`, the same
  reference the zrpandaria548 spawncompare tool uses) has the whole group: spawns, Miss Danna's path,
  the formation, her SmartAI and texts, and Gil on his own path. Everything is copied from there and
  converted to this core's columns.
- **Changed:** new `sql/fixes/world/2026_10_19_05_stormwind_miss_danna_orphans.sql`:
  - `creature`: Miss Danna guid 188983 (MovementType 2) and the seven children 188984 to 188990 in the
    Trade District at (-8838.52, 670.28); Gil guid 6183 (MovementType 2) at (-8780, 899.541).
    Respawn 300 s (Pandaria had 43200 for the group).
  - `creature_addon`: path 188983 for Miss Danna, path 6183 for Gil.
  - `waypoint_data`: path 188983, 60 points (Trade District, Cathedral Square, Stormwind Keep, the
    Valley of Heroes and back, with stops of 15 to 22 s at each sight); path 6183, 25 points (Gil's walk
    toward the Mage Quarter and back). Gil's Pandaria path called `waypoint_scripts` 102 to 116; those
    are not copied (`action` 0), his SmartAI already says his lines.
  - `creature_formations`: the seven children follow 188983. `groupAI` 514 instead of Pandaria's 2,
    because this core only moves members with the leader when `FLAG_IDLE_IN_FORMATION` (0x200) is set
    (`CreatureGroup::LeaderMoveTo`).
  - `smart_scripts`: Miss Danna (3513, ids 0 to 6) starts action lists 351300 to 351306 on reaching
    path nodes 20, 34, 35, 37, 51, 52 and 54; they make her talk and emote, make Jimmy and Steven ask
    their questions, and tell the children which way to face (children ids 0 to 2, data set 1/2/3).
    Replaced: her old rows 0 to 8, the children's ids 0 and 1 (follow Miss Danna) and action lists
    351300 to 351302. The children's emote reactions (ids 100 and up) are kept.
  - `creature_text`: Miss Danna groups 0 to 5, 7 and 8, Steven 0, Jimmy 0. Group 5 isn't in the
    Pandaria data; its text is from Wowpedia. The text for group 6 (at the Valley of Heroes) isn't known
    anywhere checked, so that one talk row is left out and she only plays the emote there.
- **Status:** confirmed in game by Four on 2026-10-19.

### To pick up the Stormwind fixes
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo pull
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_19_03_stormwind_innkeeper_allison.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_19_04_stormwind_stray_spawns.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_19_05_stormwind_miss_danna_orphans.sql
```
Then restart worldserver.

### Blackfathom Deeps (redesign): weapons, and the missing breath bar

`sql/fixes/world/2026_10_19_02_blackfathom_redesign_equipment.sql`, and a setting. Both from Four's
redesign runs. On PR #14, not merged yet.

- **Found:**
  - The Twilight's Hammer, the Blindlight murlocs, Thruk, Executioner Gore, Domina, Subjugator Kor'ul,
    Je'neu and Zeya held no weapons. Their spawns name equipment set 1 (Thruk also set 2), but
    `creature_equip_template` had no rows for them: TrinityCore's redesign sniff only added the two
    entrance Sentinels'.
  - No breath bar under water. Not a bug: upstream's `worldserver.conf` has `DisableWaterBreath = 1`, so
    every account with GM level 1 or higher has unlimited breath, everywhere.
- **Changed (SQL):** 33 `creature_equip_template` rows for 32 creatures (every redesign creature that
  has a set: 74351, 74353, 74363, 74380, 74382, 74408, 74409, 74476, 74505 sets 1 and 2, 74518, 74565,
  74720, 74721, 74980, 74983, 74984, 74988, 74989, 75011, 75012, 75058, 75285, 75286, 75640-75643,
  76036-76039, 77232), copied from TrinityCore's
  `sql/old/9.x/world/22012_2022_03_06/2022_02_16_09_world_910.sql` (sniffed on build 40120). Every
  redesign spawn's equipment set now exists. Twilight Lord Bathiel and the Twilight Tormentor have no
  set in that data and stay unarmed.
- **Changed (setting, optional):** `DisableWaterBreath = 4` in `worldserver.conf` gives GM accounts
  normal breath. The guide now mentions it.
- **Status:** the SQL ran twice against the dump. Confirmed in game by Four on 2026-10-19 (weapons shown,
  breath bar with `DisableWaterBreath = 4`).

#### To pick up the weapons and the breath setting
SQL and a config line, then a restart. No rebuild.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_19_02_blackfathom_redesign_equipment.sql | mysql -u root -p bfa_world
sed -i 's/^DisableWaterBreath *= *[0-9]*/DisableWaterBreath = 4/' ~/bfa/server/etc/worldserver.conf
grep '^DisableWaterBreath' ~/bfa/server/etc/worldserver.conf
```
The grep prints `DisableWaterBreath = 4`.

### Aku'mai's Poison Cloud (Blackfathom Deeps, classic)

New `tools/bfa/spell-corrections.patch`, applied after `dungeon-scale-quest-xp.patch`. Four's classic
run on 2026-10-19 had Aku'mai only meleeing; Four chose to fix this one spell and leave the other
classic bosses' original abilities as they are. On PR #14, not merged yet.

- **Found:** Aku'mai (4829, `boss_aku_mai`) casts Poison Cloud (3815) every 25-50 s. In the 8.3.7 client
  data its only effect applies aura 70, which this core treats as client-side (extra attacks) and
  ignores, although it has a 3 s period and 33 base points: the old cloud's nature damage. So the cloud
  did nothing. Frenzied Rage at 30% health is unaffected.
- **Changed (patch):** `SpellMgr.cpp`, `SpellMgr::LoadSpellInfoCorrections`: spell 3815 effect 0 applies
  `SPELL_AURA_PERIODIC_DAMAGE`, so enemies within 8 yards of Aku'mai take 33 nature damage every 3 s
  while it lasts (before any scaling).
- **Status:** `SpellMgr.cpp` compiles here and the patch applies on the full chain. Confirmed in game by
  Four on 2026-10-19: the cloud now damages.

#### To pick up the Poison Cloud fix
A new patch on top of the others, the build and a restart.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:tools/bfa/spell-corrections.patch | git apply
grep -c "Poison Cloud (Aku'mai" src/server/game/Spells/SpellMgr.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 1.

### Blackfathom Deeps (classic): fixes from the first classic run

`sql/fixes/world/2026_10_19_01_blackfathom_classic_fixes.sql`. Four ran the classic layout on 2026-10-19:
all bosses looted, all quests could be completed, and Lady Sarevess, Gelihast and Old Serra'kis
credited Domina, Subjugator Kor'ul and the Guardian of the Deep. On PR #14, not merged yet.

- **Found:**
  - The creatures the Fire of Aku'mai event summons were already standing in the side alcoves before
    any fire was lit: 19 spawns (guids 321248-321266: 4 Barbed Crustaceans, 3 Aku'mai Snapjaws,
    10 Murkshallow Softshells, 2 Aku'mai Servants). The Portal of Aku'mai still opened after all four
    fires and their waves, because only summoned creatures count towards it.
  - Morridune (6729) was spawned at Aku'mai's altar from the start (guid 327435) and the instance script
    summons another one when Aku'mai dies.
  - Two Blackfathom Myrmidons and two Blackfathom Sea Witches stood on one spot (within 2 yards) in the
    corridor at (-607, -31).
  - Not bugs: the Flaming Eradicator (44387), frozen in ice, gives the Horde quest The Enemy of My
    Enemy (26899, Head of Kelris), so an Alliance character sees nothing to do there. Thruk and
    Executioner Gore are credited by Lorgus Jett (12902, guid 321127 at (-456, -40, -32), past Gelihast)
    and Baron Aquanis (12876, guid 321268 at (-780, -79, -44), in the water below Kelris's ledge, by the
    Fathom Stone).
- **Changed (SQL):** deleted the 19 alcove spawns and the spawned Morridune (with their
  `creature_addon` rows); moved Sea Witch 321185 to (-607.3, -35.0, -24.9), Myrmidon 321205 to
  (-610.3, -30.7, -24.3) and Sea Witch 321204 to (-610.0, -27.5, -24.1). Myrmidon 321131 stays.
- **Status:** the SQL ran twice against the dump. Confirmed in game by Four on 2026-10-19 ("classic
  working as desired").

#### To pick up the classic fixes
SQL only, then a restart.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_19_01_blackfathom_classic_fixes.sql | mysql -u root -p bfa_world
```

### DungeonScale XP settings stop only kill XP

New `tools/bfa/dungeon-scale-quest-xp.patch`, applied after `dungeon-spell-fixes.patch`. Asked for by
Four on 2026-10-19. On PR #14, not merged yet.

- **Found:** `DungeonScale.XP.Enable = 0` and `DungeonScale.XP.StopAfterCompletion` took all XP inside
  a scaled instance, quest XP included. Four wants quests to still give XP.
- **Changed (patch):** `solocraft.cpp`, `DungeonScale_PlayerScript::OnGiveXP`: XP is only taken when
  it comes with a victim. In this core that is only kill XP (`KillRewarder`, solo or in a group); quest
  rewards, exploration, XP-granting spells and player choices pass no victim, so they still count.
  `.dungeonscale info` now says "XP: quests only, kills give none ...". The descriptions of both keys in
  `worldserver.conf.dist` say kill XP. Your `worldserver.conf` needs no change.
- **Status:** `solocraft.cpp` compiles here and the patch applies on the full chain. Confirmed in game by
  Four on 2026-10-19: quests in a dungeon give XP while kills give none.

#### To pick up the XP change
A new patch on top of the others, the build and a restart.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:tools/bfa/dungeon-scale-quest-xp.patch | git apply
grep -c "amount && victim" src/server/scripts/Custom/solocraft.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 1.

### Blackfathom Deeps (redesign): Coiled Rope shortcut, second try

`sql/fixes/world/2026_10_19_00_blackfathom_coiled_rope.sql`. On PR #14, not merged yet.

- **Found (Four's run, 2026-10-19):** the Rope Ladder Post at the bottom (224747) jumped you up to the
  Coiled Rope before anyone had used the Coiled Rope, and using the Coiled Rope changed nothing you could
  see. In TrinityCore's sniff, the second Rope Ladder Post (224628, beside the Coiled Rope) and the
  Invisible Man next to it (74997) only appear after the Coiled Rope is used;
  `2026_10_17_03` spawned both from the start. The bottom post's flag 0x10 (not selectable) doesn't stop
  the client from using it, and the core doesn't check that flag.
- **Changed (SQL):**
  - Removed the start-of-run spawns of the top post (gameobject guid 4800007) and its Invisible Man
    (creature guid 4800158), with their `spawn_group` rows. Creature guid 4800007 (Ghamoo-Ra) is untouched.
  - Coiled Rope 224627 SmartAI, now once per instance and only on use: summons Invisible Man 74997 at
    (-289.306, 82.339, -52.110) and Rope Ladder Post 224628 at (-289.270, 82.371, -52.264), clears 0x10 on
    the bottom post, removes Coiled Rope Usable (150866) from the Invisible Man 75000, and sets 0x10 on
    itself.
  - Invisible Man 74997 SmartAI: when summoned, casts Rope Ladder (150850). A `conditions` row aims its
    second effect (an aura on a nearby creature) at the Invisible Man 74998 by the bottom post. This is
    likely what draws the rope between the posts; not verified.
  - Rope Ladder Climb (150851) gets a cast condition (source type 17, condition 29): Invisible Man 74997
    within 40 yards of the player, so the bottom post does nothing until the Coiled Rope was used. The
    jump target is still the Invisible Man 75000.
- **Status:** the SQL ran twice against the dump. Confirmed in game by Four on 2026-10-19.

#### To pick up the Coiled Rope fix
SQL only, then a restart.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_19_00_blackfathom_coiled_rope.sql | mysql -u root -p bfa_world
```

## 2026-10-18

### Creature spells that did nothing, and the Coiled Rope shortcut

New `tools/bfa/dungeon-spell-fixes.patch`, applied after `blackfathom-layouts.patch`, and
`sql/fixes/world/2026_10_18_01_blackfathom_redesign_spells.sql`. Found from the client's SpellName,
SpellEffect and SpellMisc.db2, which Four sent on 2026-10-18. On PR #14, not merged yet.

- **Found:**
  - Spells aimed with target 110 (a cone that selects by creature entry) never hit anything. HavenCore
    maps 110 to line selection, and `Spell::SelectImplicitLineTargets` is commented out. 213 client spells
    use it, among them Domina's Maw of Death (149894), the Blindlight Rotmouth's Corpse Spew (150453) and
    Executioner Gore's Executioner's Strike (149943).
  - Other redesign boss spells end in a dummy effect whose base points name the spell that does the work.
    Retail casts those from its own server scripts, and HavenCore has none, so the spell stops at the
    dummy. Examples: Piercing Rain 151814 names 152884, Foul Tempest 149887 names 152799, and Restorative
    Waters 150020 names 150022, which summons the Restorative Waters. 12 such spells are cast by
    Blackfathom Deeps creatures.
  - The Coiled Rope (224627) wasn't selectable (flags 0x10; TrinityCore's sniff has 0), and nothing made
    the Rope Ladder Post (224747) usable. The post casts Rope Ladder Climb (150851), a jump to the
    nearest creature of an entry the spell's conditions name, and there were no conditions.
- **Changed (patch):**
  - `SpellInfo.cpp`: target 110 uses cone selection (`TARGET_UNIT_CONE_ENTRY_110`).
  - `Spell.cpp`: a cone that selects by entry and has no conditions takes the caster's enemies, as the
    enemy cone (104) does. Without that it would hit the caster's allies too.
  - `spell_generic.cpp`: new `spell_gen_dummy_cast_base_points`. On each dummy effect hit, the caster
    casts the spell the effect's base points name at that target (triggered).
- **Changed (SQL, `2026_10_18_01`):**
  - `spell_script_names` for the 12 spells: Foul Tempest 149887, Catch of the Day 149908 and 149910,
    Restorative Waters 150020, Darkness Calls 151159, Tearing the Void 151303 and 151304, Grip of
    Darkness 151313, Static Shock 151683, Piercing Rain 151814, Spore Cloud 152753 and Falling Debris
    152965.
  - Coiled Rope 224627: `flags` 0. Its SmartAI makes the Rope Ladder Post within 40 yards selectable
    when used, then makes itself unselectable. A `conditions` row points Rope Ladder Climb at the
    Invisible Man 75000 beside the Coiled Rope, so the post jumps you back up to it.
- **Status:** the three changed files compile here and the patch applies on the full chain; the SQL ran
  twice against the dump. Not working in game yet: on 2026-10-19 Four's run had Corpse Spew, Maw of
  Death, Foul Tempest, Piercing Rain, Restorative Waters and Tearing the Void still doing nothing.
  That build didn't have the patch (both greps printed 0). Rebuilt with the patch applied (greps 4
  and 1), Four confirmed in game on 2026-10-19 that Domina's Maw of Death (the cone fix) and Foul
  Tempest (the dummy-cast script) now work. Later the same day Four also confirmed Corpse Spew
  (Blindlight Rotmouth), Catch of the Day and Fillet of Flesh (Thruk), Restorative Waters (summons its
  adds) and Piercing Rain (Bathiel), and all of Aku'mai the Devourer's spells. Then: Ghamoo-Ra's Static
  Shock and the rest of her spells, and all of Kor'ul's and the Guardian of the Deep's spells. Every
  spell in this entry is confirmed in game as of 2026-10-19. The Coiled Rope part did not work: the
  bottom post jumped you up before the Coiled Rope was used, and using it showed nothing. See
  "Coiled Rope shortcut, second try" (2026-10-19).

#### To pick up the spell fixes
A new patch on top of the others, the SQL, the build and a restart.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:tools/bfa/dungeon-spell-fixes.patch | git apply
grep -c "spell_gen_dummy_cast_base_points" src/server/scripts/Spells/spell_generic.cpp
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_18_01_blackfathom_redesign_spells.sql | mysql -u root -p bfa_world
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 4.

### Blackfathom Deeps (redesign): fixes from the first full run

`tools/bfa/blackfathom-layouts.patch` (changed) and `sql/fixes/world/2026_10_18_00_blackfathom_redesign_fixes.sql`.
Four ran the redesign from the entrance to Twilight Lord Bathiel on 2026-10-18 and reported 28 findings.
On PR #14, not merged yet.

- **Found:**
  - After Bathiel died, the Portal of Aku'mai stayed shut, so Aku'mai the Devourer couldn't be reached.
    In HavenCore, a new instance's bosses start as TO_BE_DECIDED. `InstanceScript::SetBossState` from that
    state only records the new state and returns false. The redesign bosses have no boss scripts, so
    their first state change is DONE, and the instance script's door and spawn updates never ran. The same
    bug kept Domina and Kor'ul from appearing over Bathiel's altar, and would have kept the quest givers and
    the Spoils chest from appearing after Aku'mai. Their kills weren't saved either.
  - Twilight Disciples (74989, 75012), a Twilight Storm Mender (75011), Subjugator Kor'ul (74565) and three
    murlocs in his room (75641-75643) were friendly and level 1: placeholder templates (faction 35,
    level 1, no loot). Kor'ul couldn't be attacked.
  - A second Guardian of the Deep (75410, spawn 4800176), friendly, stood on the ledge by Thruk.
  - Executioner Gore played his yell but no text appeared. The redesign's lines use text range 1 (area),
    which only reaches players in the speaker's area id, and in Blackfathom Deeps players have no valid
    area id (worldserver logged "Area: 1575977184 (Unknown)").
  - The classic quests had no source in the redesign: no Twilight Pendants (Twilight Falls) and no
    Corrupted Brain Stems (Researching the Corruption). The Head of Kelris and the Strange Water Globe
    had no source either, and the Fathom Stone and the Pitted Iron Chest were classic-only spawns.
- **Changed (patch):** `instance_blackfathom_deeps.cpp` sets a redesign boss to NOT_STARTED before DONE
  when its state is still TO_BE_DECIDED. Its death now saves the run, opens the Portal of Aku'mai (Bathiel)
  and shows the spawns that wait for it.
- **Changed (SQL, `2026_10_18_00`):**
  - The placeholder templates copy the hostile creature of the same name. Twilight Disciples 74989 and
    75012 copy 75286 (faction 14, level 23), Storm Mender 75011 copies 74980 (level 24), Kor'ul copies
    Domina (faction 14, level 25), the Bilefins 75641/75642 copy 74721 and the murloc 75643 copies 74720.
    The copies cover level, gold, loot and pickpocket tables. The murloc 75640 gets 74720's loot table.
  - Guardian of the Deep spawn 4800176 is deleted.
  - `creature_text` range 1 becomes 0 (normal say/yell distance) for Executioner Gore 74988 and 74518,
    Sentinel Aluwyn, Zeya and the Frightened Prisoner 75428.
  - Quest items, all quest-only drops at 100%: Twilight Pendant 5879 from every redesign Twilight's
    Hammer creature (16 loot tables; Twilight Tormentor 75034 gets its own). Corrupted Brain Stem 5952
    from the Blindlight murlocs (74719, 74720, 74721, 74984, 75658). Head of Kelris 5881 from Bathiel.
    Strange Water Globe 16782 from Executioner Gore 74518, which starts Baron Aquanis, so it drops
    without a quest, as it did from Aquanis.
  - The Fathom Stone (188159) and the Pitted Iron Chest (188182) are in new spawn group 442, which shows
    in both layouts.
- **Not done yet:** the Coiled Rope shortcut, the boss spells that do nothing (Piercing Rain, Restorative
  Waters, Spore Cloud, the Rotmouth's vomit), the executions and the Ghamoo-Ra and tentacle events, and
  weapons for the Twilight's Hammer creatures (no equipment data).
- **Status:** confirmed in game by Four on 2026-10-19: the run reached and killed Aku'mai the Devourer
  (the portal opened after Bathiel), every boss counted for the objectives, and the Blackfathom Deeps
  achievement was awarded. The other changes in this entry weren't reported on separately.

#### To pick up the redesign fixes
The patch changed, so the old version comes out first (commit 1c47a4c is the last one with it), then the
new one goes in. Then the SQL, the build, and a restart. Start a new instance afterwards.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show 1c47a4c:tools/bfa/blackfathom-layouts.patch | git apply -R
git -C ../tools-repo show FETCH_HEAD:tools/bfa/blackfathom-layouts.patch | git apply
grep -c "TO_BE_DECIDED" src/server/scripts/Kalimdor/BlackfathomDeeps/instance_blackfathom_deeps.cpp
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_18_00_blackfathom_redesign_fixes.sql | mysql -u root -p bfa_world
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 2.

## 2026-10-17

### Blackfathom Deeps (redesign): Executioner Gore at the prisoners can't be fought

`sql/fixes/world/2026_10_17_04_blackfathom_gore_executioner.sql`. On PR #14, not merged yet.

- **Found:** Four fought Executioner Gore in the redesign's first prisoner room. The kill didn't count
  for the "Executioner Gore" objective and he dropped no loot. There are two Executioner Gores. 74988
  stands with the prisoners on the way in (spawns 4800069 and 4800113). His lines are "Intruders?! Move
  the prisoners!", "Come along, heroes! The water is fine." and "The intruders are still alive?! Stop
  them!". The boss the objective asks for is 74518 (spawn 4800174), near Twilight Lord Bathiel ("I was
  hoping you would make it to me."). 74988 was a hostile elite with 20% drop chances. Nothing stopped
  players from fighting him, and his kill gives no credit.
- **Changed:** creature 74988 gets `unit_flags` 0x300 (immune to players and creatures), so he can't
  be attacked. His SmartAI is replaced by one script per spawn. At the first prisoners, he says "Intruders?!
  Move the prisoners!" when a player comes within 40 yards. Six seconds later he says "Come along,
  heroes! The water is fine." and he despawns 4 seconds after that. At the second prisoners, he says
  "The intruders are still alive?! Stop them!" and despawns 5 seconds later. The old entry SmartAI rows
  are deleted.
- **Not done yet:** on retail, Gore executes prisoners in these rooms; that part isn't scripted.
- **Status:** the SQL ran twice against the dump. Not yet tested in game.

#### To pick up the Gore fix
SQL only. Run it, then restart worldserver.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_17_04_blackfathom_gore_executioner.sql | mysql -u root -p bfa_world
```

### Blackfathom Deeps: the redesigned layout, next to the classic one

New `tools/bfa/blackfathom-layouts.patch`, applied after `dungeon-boss-loot.patch`, and
`sql/fixes/world/2026_10_17_03_blackfathom_redesign_layout.sql`. Asked for by Four on 2026-10-17 after
fighting Lady Sarevess where the Adventure Guide shows Domina: keep both layouts, with an NPC at the entrance
to pick one per run. On PR #14, not merged yet.

- **Found:**
  - HavenCore spawns the classic Blackfathom Deeps: Ghamoo-Ra, Lady Sarevess, Gelihast, Lorgus Jett,
    Baron Aquanis, Twilight Lord Kelris, Old Serra'kis and Aku'mai. Its boss scripts and the quests
    Deep in the Deeps (26892) and Nightmare of the Deeps (26888) are built around them.
  - The 8.3.7 client shows the 6.0.2 redesign. The Adventure Guide lists Ghamoo-Ra, Domina, Subjugator
    Kor'ul, Thruk, Guardian of the Deep, Executioner Gore, Twilight Lord Bathiel and Aku'mai. The dungeon
    objectives come from scenario 333, which `.debug scenario` showed wants Ghamoo-Ra 74446, Thruk,
    Executioner Gore, Twilight Lord Bathiel and Aku'mai the Devourer 75155, with Domina, Kor'ul and the
    Guardian as bonus objectives. None of these was spawned, so the objectives could never complete with
    the classic bosses.
  - The database already had the redesign's creature templates, SmartAI, loot and quests (The Rise of
    Aku'mai 34672/34673), but no spawns. TrinityCore master has the redesign's spawns, sniffed from
    retail (`sql/old/11.x/world/25031_2025_05_31/2025_04_22_00_world.sql`).
- **Changed (SQL, `2026_10_17_03`):**
  - The redesign's spawns are converted from that file to this schema: 280 creatures and 74 gameobjects
    (guids 4800000-4800999), 2 patrol paths (`waypoint_data` 48001110, 48001450), and template addons for
    the redesign-only creatures. All of them are in spawn groups 433-440. 434-437 are the Alliance and
    Horde quest givers at the entrance and at Aku'mai. 438/439 are Domina and Kor'ul over Bathiel's
    altar. 440 is the Spoils of Blackfathom chest.
  - New creature 4800000, the Blackfathom Chronicler <Dungeon Layouts>, just inside the entrance (spawn
    4800999, group 441, shown in both layouts, using Lorekeeper Amberwind's model).
  - `instance_encounters` rows for the redesign bosses, using the DungeonEncounter ids from the client's
    JournalEncounter.db2: 1667 Ghamoo-Ra, 1668 Domina, 1669 Kor'ul, 1675 Thruk, 1676 Guardian of the Deep,
    1670 Executioner Gore, 1671 Bathiel, and 1672 Aku'mai the Devourer (last encounter of dungeon 10).
  - Aku'mai the Devourer had no loot (`lootid` 0) and now uses classic Aku'mai's table (4829). Also:
    weapons for the entrance quest givers, the Frightened Prisoner's gossip menu (16166), Rope Ladder
    Post 224747 not clickable, and the Spoils chest's world effect.
- **Changed (patch):**
  - `instance_blackfathom_deeps.cpp` loads both layouts and hides the one not in use. The hidden spawns go
    to a database phase no player is in, the same way as Shadowfang Keep's faction troops. Spawns in
    other spawn groups (gathering nodes) show in both. Faction quest givers show only for the team in the
    instance. The redesign's Aku'mai quest givers and chest appear after Aku'mai the Devourer dies.
  - The layout is saved with the instance. An instance saved before this patch stays classic.
  - Redesign touches: creatures sniffed as stationary (tentacles, heads, bunnies, channelers) are rooted,
    the ones sniffed in mid-air hover, and the bodies of Lady Sarevess, Gelihast and the Slain Hero
    look dead. The redesign's Portal of Aku'mai opens when Twilight Lord Bathiel dies. The redesign bosses
    run their existing SmartAI, and their deaths save the run's progress.
  - Each classic boss stands where a redesign boss does. In the classic layout, its kill counts for that
    boss's objective: Ghamoo-Ra for Ghamoo-Ra, Lorgus Jett for Thruk, Baron Aquanis for Executioner Gore,
    Kelris for Bathiel and Aku'mai for Aku'mai the Devourer. The bonus objectives map the same way:
    Sarevess for Domina, Gelihast for Kor'ul and Old Serra'kis for the Guardian. In the redesign layout,
    a redesign boss's kill credits the classic boss for the quests that ask for it (Deep in the Deeps,
    Nightmare of the Deeps).
  - Core: new `InstanceScript::GetScenarioKillCredit` (by default the creature's own entry), used for the
    scenario's kill credit in `KillRewarder.cpp` and for the boss loot guarantee in `Unit.cpp`.
  - `blackfathom_deeps.cpp`: `npc_blackfathom_chronicler`. Its gossip tells you which layout the
    instance has and switches to the other one. Switching is refused once any boss of the run is dead,
    or while you are in combat.
  - `worldserver.conf.dist`: `Blackfathom.Layout` (default 1, the redesign; 0 is classic) picks the
    layout of a new instance. A new DUNGEON LAYOUTS block at the end. The install step only updates
    `worldserver.conf.dist`, so until you add `Blackfathom.Layout = 1` to your own `worldserver.conf`, the
    server warns "Missing name Blackfathom.Layout" and uses the default.
- **Not done yet:** the redesign bosses only use the two or three abilities their SmartAI already had,
  which are the ones in the Adventure Guide. Their events aren't scripted yet: Aku'mai's heads and
  tentacles, the Deep Terror vehicles, the Coiled Rope, Gore's executions, the Guardian's eggs and
  Ghamoo-Ra's cultists. The classic quests that need classic drops (Knowledge in the Deeps, Researching
  Corruption, Twilight Falls) aren't mapped to the redesign yet. The Spoils of Blackfathom chest has no
  loot of its own.
- **Status:** compiles here; the SQL ran twice against the dump. Not yet tested in game.

#### To pick up the two Blackfathom layouts
Two patches and one SQL file. The second line applies `dungeon-boss-loot.patch` first, but only if it isn't
in your tree yet.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
grep -q "HasKillCriteria" src/server/game/Entities/Unit/Unit.cpp || git -C ../tools-repo show FETCH_HEAD:tools/bfa/dungeon-boss-loot.patch | git apply
git -C ../tools-repo show FETCH_HEAD:tools/bfa/blackfathom-layouts.patch | git apply
grep -c "GetScenarioKillCredit" src/server/game/Entities/Unit/Unit.cpp
grep -c "npc_blackfathom_chronicler" src/server/scripts/Kalimdor/BlackfathomDeeps/blackfathom_deeps.cpp
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_17_03_blackfathom_redesign_layout.sql | mysql -u root -p bfa_world
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The `grep` lines should print 1 and 3. The build recompiles every script because `InstanceScript.h`
changed. Then restart `worldserver` and reset Blackfathom Deeps (an instance saved before this stays
classic). `Blackfathom.Layout` doesn't have to be in `worldserver.conf`; without it new instances get the
redesign.

### Loot: every dungeon boss gets the boss loot guarantee

New `tools/bfa/dungeon-boss-loot.patch`, applied after `dungeon-scale-xp.patch`. Asked for by Four on
2026-10-17 ("all bosses"). On PR #14, not merged yet.

- **Found:** the "bosses always drop an item" rule from `loot-fixes.patch` only knows a boss through
  `IsDungeonBoss`, which is set from `instance_encounters`. Blackfathom Deeps and Ragefire Chasm have no
  rows there at all, so their bosses never got it. Wailing Caverns, The Deadmines and Shadowfang Keep do
  have theirs listed.
- **Changed:**
  - `Scenario.h` / `Scenario.cpp`: new `Scenario::HasKillCriteria(entry)`: true when a step of the
    scenario has a kill criteria for that creature needed once ("Lady Anacondra defeated"). Kill counts
    above 1 ("Defeat 20 ...") are left out, so trash doesn't qualify.
  - `Unit.cpp`, `Unit::Kill`: on a dungeon or raid map, a creature gets the boss loot guarantee when it is
    an `instance_encounters` credit (as before) or the instance's scenario has such a kill criteria for
    it. Everything else about the guarantee is unchanged.
  - No SQL and no setting. Use `.debug scenario` in a dungeon to see which creatures its objectives name.
- **Status:** compiles here; not yet tested in game.

#### To pick up the boss loot change
A new patch on its own:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:tools/bfa/dungeon-boss-loot.patch | git apply
grep -c "HasKillCriteria" src/server/game/Entities/Unit/Unit.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The `grep` line should print 1. Then restart `worldserver`.

### DungeonScale: XP settings

New `tools/bfa/dungeon-scale-xp.patch`, applied after `wailing-caverns-fixes.patch`. Asked for by Four on
2026-10-17: XP inside dungeons was too high, and a dungeon already completed should give none. On PR #14,
not merged yet.

- **Changed:**
  - `DungeonScale.XP.StopAfterCompletion` (default 1): inside a scaled dungeon, no XP at all (kills and
    quest turn-ins) once you have the dungeon's achievement for the mode you are in, even inside its
    level range. "The dungeon's achievement" is any achievement, not a statistic, with a criteria that
    kills a creature and is made for that map (`Achievement.InstanceID`), or that kills the final boss
    (`instance_encounters` row with `lastEncounterDungeon`). An achievement whose criteria has extra
    requirements (Heroic ones require Heroic difficulty) only counts where they hold, so a Heroic
    achievement doesn't stop XP on Normal. Built once per map and difficulty.
  - `DungeonScale.XP.Enable` (default 1): 0 gives no XP inside any scaled instance, for testing.
  - Both only apply where DungeonScale scales the map (`.dungeonscale info` says so). XP outside is
    untouched.
  - `.dungeonscale info` now says whether you get XP there, why not, and which achievements complete the
    map (`*` = only counts when its requirements hold).
  - Files: `solocraft.cpp` (DungeonScale: settings, `GetXPBlock`, `GetCompletionAchievements`, an
    `OnGiveXP` player hook, the info lines), `worldserver.conf.dist` (two keys, in the DUNGEON SCALE
    block), `Player.cpp` (`Player::GiveXP` stops when a script has taken all the XP, so no
    "You gain 0 experience" line is shown).
- **Status:** compiles here; not yet tested in game.

#### To pick up the XP settings
A new patch on its own. Neither key has to be in `worldserver.conf`: completion stopping XP is on, and XP
is on otherwise.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:tools/bfa/dungeon-scale-xp.patch | git apply
grep -c "DungeonScale.XP.StopAfterCompletion" src/server/scripts/Custom/solocraft.cpp
grep -c "a script took all of it" src/server/game/Entities/Player/Player.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The `grep` lines should print 2 and 1. Then restart `worldserver`. To switch XP off for testing, add
`DungeonScale.XP.Enable = 0` to `~/bfa/server/etc/worldserver.conf` and type `.reload config`.

### Blackfathom Deeps (map 48)

Started by Four on 2026-10-17 on the night elf rogue. On PR #14 with the Wailing Caverns fixes, not merged
yet.

#### Je'neu Sancrea was hostile to the Alliance
- **Found** (in game): Je'neu Sancrea <The Earthen Ring> (12736), at the entrance with the Alliance quest
  givers, showed a red name and attacked when talked to.
- **Cause:** his quests are open to every race (Blackfathom Deeps 26894, Nightmare of the Deeps 26888,
  Amongst the Ruins 26891, The Essence of Aku'Mai 6563), and he takes the Alliance breadcrumb
  "Adventurers Wanted: Blackfathom Deeps" (28010). But `creature_template` gives him faction 126, a
  Horde faction. No `sql/updates` file changes him.
- **Changed:** `2026_10_17_02_blackfathom_jeneu_faction.sql`: faction 126 -> 35 (friendly to everyone,
  as Zeya next to him has). Revert line in the file. Safe to run twice.
- **Status:** run here against the dump; not yet tested in game.

### To pick up the Blackfathom Deeps fixes
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_17_02_blackfathom_jeneu_faction.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`.

## 2026-10-16

### World: Lazy Peons (Durotar)

#### The Foreman's Blackjack says "Invalid target" on every Lazy Peon
- **Found** (reported by Four): every Lazy Peon (10556) in the Valley of Trials lay asleep, and the
  Foreman's Blackjack said "Invalid target" on all of them, so quest 37446 "Lazy Peons" couldn't be
  done. Lying asleep at spawn is intended (on retail the peons nap by the lumber piles until you wake
  them). The blackjack's spell, Awaken Peon (19938), only accepts a target that has the aura Peon
  Sleeping (17743): `Spell::CheckCast` in `Spell.cpp` checks it, and so does the spell condition
  (`conditions` source 17, entry 19938). Since the core's world update
  `2026_09_20_valley_of_trials_cosmetic_improvements.sql`, the peon's SmartAI adds 17743 once, on reset
  (spawn and after evading), and sets stand state 3 (asleep). The old C++ script `npc_lazy_peon`
  (removed from the peon by update `2026_08_06_00_Quest37446_Lazy_Peons_Fix.sql`) recast 17743 every
  5 minutes, because the aura runs out. After it runs out the peon keeps lying down, since the stand
  state doesn't change, but it can't be targeted. That the aura expiring is the cause is inferred from
  the old script and the error; it wasn't checked in game.
- **Changed:** new `sql/fixes/world/2026_10_16_04_durotar_lazy_peon_sleep_aura.sql`, on
  `smart_scripts` for 10556 (`source_type` 0):
  - id 1 (on reset, add aura 17743): `link` 0 -> 7.
  - id 6 (on wake, start the work action list 1055600): `link` 0 -> 8.
  - new id 7: linked from id 1, set event phase 1 (asleep).
  - new id 8: linked from id 6, set event phase 2 (working).
  - new id 9: out of combat, only in phase 1, every 30 s, add aura 17743 again.
  Waking, quest credit, the walk to the lumber pile, chopping for 60 to 180 s and going back to sleep
  (rows 0 to 6 and action list 1055600 from the core update) are unchanged.
- **Status:** confirmed in game by Four on 2026-10-16: the blackjack wakes the peons again.

### To pick up the Lazy Peon fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo pull
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_16_04_durotar_lazy_peon_sleep_aura.sql
```
Then restart worldserver.

### World: Northwatch Scout (Durotar)

#### Northwatch Scout never melees, only casts Fan of Knives
- **Found** (reported by Four): Northwatch Scout (39317) in the Valley of Trials, Durotar, only ever
  cast Fan of Knives and never auto-attacked. The dump has 23 `smart_scripts` rows for 39317 from two
  different script versions mixed together (none of the core's `sql/updates/world` files touch them).
  On aggro, the old link chain (ids 0, 1, 2) cast Shoot once, then ran action 20
  (`SMART_ACTION_AUTO_ATTACK`) with 0, which turns melee off for the rest of the fight. The newer rows
  that turn it back on and switch between Shoot and melee (ids 4 to 15, 18) all have
  `event_phase_mask` 1, and nothing sets phase 1, so they never ran. Shoot (6660) has a minimum range,
  so next to the player only Fan of Knives (id 3) still worked. Id 16 (a talk on combat) did nothing
  either, because 39317 has no `creature_text`.
- **Faction:** unchanged. The scout's faction 190 shows as neutral (yellow). That value is sniffed data
  from build 35662, and every other mob in the Valley of Trials is neutral too (Mottled Boar, Scorpid
  Worker, Vile Familiar and Sarkoth are faction 7), so neutral is expected. It only fights back when
  attacked.
- **Changed:** new `sql/fixes/world/2026_10_16_03_durotar_northwatch_scout.sql` deletes every
  `smart_scripts` row for 39317 (`source_type` 0) and inserts three:
  - id 0: on reset (spawn and after evade), cast Stealth (58506) on itself if it isn't stealthed.
  - id 1: when the target is 5 to 30 yards away, cast Shoot (6660) on it every 2.3 to 3.9 s.
  - id 2: when the target is within 8 yards, cast Fan of Knives (79584) every 15 to 22 s (was within
    10 yards).
  Melee and chasing are left to SmartAI's defaults, so it auto-attacks in melee range.
- **Status:** confirmed in game by Four on 2026-10-16.

### To pick up the Northwatch Scout fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo pull
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_16_03_durotar_northwatch_scout.sql
```
Then restart worldserver.

### Loot: reference loot tables never dropped, and bosses now always drop an item

New `tools/bfa/loot-fixes.patch`, applied after `transmog-collection.patch`. On PR #14, not merged yet.

#### Items from reference loot tables never dropped
- **Found** (in game, Wailing Caverns, on the Alliance rogue): Druids of the Fang, Lady Anacondra, Skum,
  Verdan the Everliving and Lord Pythas dropped money but no items. Trash elsewhere dropped items.
- **Cause:** a loot row with `Reference` set points to a shared table in `reference_loot_template` (world
  drops, most green items, many boss and chest tables). `LootTemplate::Process`
  (`src/server/game/Loot/LootMgr.cpp`) processed that table without passing the looter on, and
  `Loot::AddItem` throws away any item that has no looter. So nothing from a reference ever dropped,
  anywhere. 37,088 rows in 2,740 creature loot tables use a reference, plus 122 gameobject and 106 item
  loot tables. Upstream TrinityCore passes the looter.
- **Changed:** the looter (and the spec filter) are passed on to the referenced table. One line.
- **Status:** confirmed in game by Four on 2026-10-17.

#### Dungeon bosses dropped only gold
- **Found:** the four Wailing Caverns bosses above use plain rows, not references, so the fix above
  doesn't touch them. By their tables each kill drops no item 13 to 27% of the time (Skum 13%, Anacondra
  23%, Pythas 24%, Verdan 27%), so four empty kills in a row is about 1 in 500. Four's loot tables load
  (1,805,426 rows, none of the skipped ones are these bosses') and all `Rate.Drop.*` settings are 1.
  I found nothing in the core that treats a boss's loot differently from trash, so the cause is still
  unknown. Four asked for every boss to always drop loot, as on retail.
- **Changed:**
  - `LootMgr.cpp` / `LootMgr.h`: new `LootTemplate::AddItemIfNoneDropped`. It looks at the boss's own
    plain and grouped rows that the player could be shown (no references, quest items, currencies, rows
    with conditions or of the wrong loot mode). If any of them is uncommon or better, the player must have
    at least one uncommon-or-better item; otherwise any item counts. If the normal rolls gave none, one
    is added, picked by drop chance (`Chance` as the weight, 1 for equal-chanced group rows), so a rare
    item stays rare.
  - `Unit.cpp`, `Unit::Kill`: after the normal loot is filled for each looter, calls it for creatures that
    are dungeon or raid bosses (`IsDungeonBoss`: the kill credit of an `instance_encounters` row) on a
    dungeon or raid map.
  - The normal rolls are unchanged, so a boss can still drop more than one item. Bosses in the open world
    are not affected. The Deadmines boss items grouped by `2026_10_11_04_deadmines_boss_loot.sql` already
    always drop one, so nothing changes there.
  - No SQL and no config setting. To undo it, `git apply -R` the patch.
- **Status:** confirmed in game by Four on 2026-10-17: bosses drop loot.

#### Corpses holding a quest item you can't see could never be skinned
- **Found** (in game, Wailing Caverns, 2026-10-17): Deviate Ravagers (raptors) showed no skinning cursor
  after being looted, at any Skinning level.
- **Cause:** a loot item you aren't shown still sits in the corpse's loot. Every Wailing Caverns beast
  (Deviate Ravager, Guardian, Crocolisk, Python, Viper, Adder, Dreadfang, Moccasin, Venomwing) drops
  Deviate Hide (6443) 100% of the time for the quest Deviate Hides (26872); once you don't have that
  quest, the hide is hidden from you and can't be taken. The corpse only turns skinnable when its loot
  is empty, and `Loot::GetUnlootedCount` (`src/server/game/Loot/Loot.cpp`), asked without a player,
  counted every item, hidden ones included, so the corpse never emptied. The same goes for any mob with
  a quest item, a recipe you can't use or an other-faction item. Before the reference fix above fewer
  corpses held such items, but the quest hide is a plain row, so these were affected before too. The
  fix is in the core loot code, so it applies to every mob and every map, not just Wailing Caverns.
- **Changed:** in `loot-fixes.patch`, `GetUnlootedCount` without a player counts each looter's items
  by what that looter is shown (same rule as with a player: not looted, no conditions,
  `AllowedForPlayer`). If the looter is offline, their items still count, as before. This is also the
  check the Skinning spell uses ("you must loot it first").
- **Status:** Four reported Wailing Caverns good to go in game on 2026-10-17 after this update.

### To pick up the loot fixes
A new patch on its own, so the patches you already applied stay as they are. `LootMgr.h` is not in the
precompiled headers, so this should not be a full rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:tools/bfa/loot-fixes.patch | git apply
grep -c "item->groupid, player, specOnly" src/server/game/Loot/LootMgr.cpp
grep -c "AddItemIfNoneDropped" src/server/game/Entities/Unit/Unit.cpp
grep -c "FindConnectedPlayer(itemItr.first)" src/server/game/Loot/Loot.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
All three `grep` lines should print 1. Then restart `worldserver`.

If you applied the earlier version of the patch (before the skinning fix), take it out first, then
apply the new one as above:
```
git -C ../tools-repo show b21c5cc:tools/bfa/loot-fixes.patch | git apply -R
``` Once PR #14 is merged, `git -C ../tools-repo pull`
on `main` brings the file in as usual.

### Wailing Caverns (map 43)

Reported by Four on 2026-10-16 after a full run on the Alliance rogue: everything but the loot and the
final event worked. On PR #14, not merged yet.

#### Muyoh's escort never started, and Mutanus could be pulled early
- **Found** (in game): Muyoh (Disciple of Naralex, 3678) offered nothing to start the awakening of
  Naralex, and Mutanus the Devourer (3654) already stood "shadowed" in Naralex's pool, where he could be
  pulled and killed.
- **Cause:** `npc_disciple_of_naralex` (`wailing_caverns.cpp`) only adds "Let the event begin!" once
  instance data 1 to 4 (Lord Cobrahn, Lord Pythas, Lady Anacondra, Lord Serpentis) are DONE. The lords
  run SmartAI, and the world dump has no "on death, set instance data" row for any of them, so the four
  were never counted (TrinityCore has one per lord). The script's ending also waits for data 9 (Mutanus)
  to be DONE, which had no row either. Mutanus is meant to be summoned by Muyoh at the end of the ritual,
  at the same spot, but the dump also spawns him there (guid 326392).
- **Changed:** `2026_10_16_05_wailing_caverns_naralex_event.sql`:
  - `smart_scripts` id 100 for 3669, 3670, 3671, 3673 and 3654: On Just Died, Set Instance Data 1, 2, 3,
    4 and 9 to 3 (DONE).
  - Deletes the static Mutanus spawn (guid 326392), so he only appears when Muyoh summons him.
  - The revert lines, including the full Mutanus row, are at the top of the file. Safe to run twice.
- **Status:** confirmed in game by Four on 2026-10-17 that Mutanus is no longer in the pool. Lords
  killed before the SQL ran aren't counted, so it needs a fresh instance.

#### Muyoh couldn't be clicked, and Naralex had a dead "Lets Go!" dialog
- **Found** (in game, 2026-10-17, after the fix above with all four Fanglords dead): Muyoh still
  couldn't be interacted with. Naralex opened a dialog with "Lets Go!" that did nothing.
- **Cause:** Muyoh starts the event through gossip (`npc_disciple_of_naralex`, gossip menu 201), but
  `creature_template` 3678 has `npcflag` 2 (quest giver) only and she has no quests, so the client offers
  nothing to click. Naralex (3679) has `npcflag` 1 with gossip menu 3679, whose only option ("Lets Go!")
  and SmartAI gossip row ("Orgus - On Gossip - Kill Credit") belong to an unrelated NPC.
- **Changed:** `2026_10_17_00_wailing_caverns_muyoh_gossip.sql`: Muyoh `npcflag` 2 -> 3 (adds gossip),
  Naralex `npcflag` 1 -> 0. Revert lines in the file. Safe to run twice.
- **Status:** confirmed in game by Four on 2026-10-17: Muyoh offered the gossip, and the whole event ran
  through to Naralex waking, once she was moved down to the floor (next entry).

#### Muyoh started halfway down the first chamber, hovering out of reach
- **Found** (in game, 2026-10-17): with the gossip flag added, Muyoh still couldn't be talked to. She
  floated in owl form above the floor halfway down the first chamber; once Four moved her down with
  `.npc move`, she talked and the event ran. She should wait just inside the entrance.
- **Cause:** the dump spawns her (creature guid 326242) at (-84.2, 225.6, -83.8) with aura 8153 (owl form)
  in `creature_addon`. Owl form lifts her off the floor, and the server only lets you talk to an NPC
  within 5 yards (height included), even when the client shows the speech cursor. Her escort
  (`script_waypoint` 3678) starts at point 0 just inside the entrance (-120.864, 132.825, -79.2972), so
  she walked back there first anyway. The script gives her flight form itself at the end of the event.
- **Changed:** `2026_10_17_01_wailing_caverns_muyoh_spawn.sql`: moves guid 326242 to escort point 0,
  facing the entrance (orientation 3.17), and clears its `creature_addon` aura (8153 -> none). It also
  overwrites the spot `.npc move` saved. Revert lines in the file. Safe to run twice.
- **Status:** Four reported Wailing Caverns good to go in game on 2026-10-17 after this update.

#### No credit for "Muyoh escorted"
- **Found** (in game, 2026-10-17): the event finished, but the dungeon's objective "Muyoh escorted" was
  never ticked.
- **Cause:** in BFA, Wailing Caverns runs scenario 515 (`scenarios` table, map 43). Its steps and
  criteria live in the client's db2 files, not the world database, so I added a GM command to read them
  (below). Four's output: step 948 ("Disciples of Naralex", after the four Fanglords) needs criteria
  24776 "Muyoh escorted", type SEND_EVENT_SCENARIO (92) with scenario event 582, and criteria 34405
  "Mutanus the Devourer defeated" (kill 3654). `npc_disciple_of_naralex` never sends event 582, so the
  step can't complete.
- **Changed:**
  - New `tools/bfa/scenario-debug.patch` (applied after `loot-fixes.patch`) adds `.debug scenario`.
    Inside a dungeon, it lists every step of the scenario with its state, and under each step every
    criteria tree and criteria: description, criteria type and asset (creature, event or spell id), and
    the group's progress. It changes nothing in game. Files: `Scenario.h` / `Scenario.cpp` (two
    read-only accessors) and `cs_debug.cpp` (the command).
  - New `tools/bfa/wailing-caverns-fixes.patch` (applied after `scenario-debug.patch`):
    `npc_disciple_of_naralex::WaypointReached` (`wailing_caverns.cpp`) sends scenario event 582 when
    Muyoh reaches Naralex (escort point 24, where the awakening ritual starts). Mutanus is killed during
    the ritual, which then completes the step.
- **Status:** `.debug scenario` confirmed working in game by Four on 2026-10-17. Four reported Wailing
  Caverns good to go after the escort credit fix, the same day.

### To pick up the Wailing Caverns fixes
All three SQL files are safe to run again, so this runs them all. The debug command is a rebuild of
about 30 files. If you already applied `scenario-debug.patch`, skip its line:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_16_05_wailing_caverns_naralex_event.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_17_00_wailing_caverns_muyoh_gossip.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_17_01_wailing_caverns_muyoh_spawn.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:tools/bfa/scenario-debug.patch | git apply
git -C ../tools-repo show FETCH_HEAD:tools/bfa/wailing-caverns-fixes.patch | git apply
grep -c "HandleDebugScenarioCommand" src/server/scripts/Commands/cs_debug.cpp
grep -c "SCENARIO_EVENT_MUYOH_ESCORTED" src/server/scripts/Kalimdor/WailingCaverns/wailing_caverns.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
Both `grep` lines should print 2. Then restart `worldserver`. If the Fanglords were killed before the
first file ran, reset the instance (leave it, then Reset All Instances from your portrait menu) and kill
them again.

### Transmog collection

Merged to `main` with PR #12 on 2026-10-16 (reported 2026-10-15). Core changes are in the new
`tools/bfa/transmog-collection.patch`, applied after the other nine patches. It applies to a stock core
on its own too, so the order doesn't matter.

#### Appearances were not learned for items in the bags
- **Found** (reported by Four): picking items up didn't add their appearances to the collection. The
  core's collection code is TrinityCore's 8.3.7 version, unchanged, and it follows the 8.3.7 retail
  rules, which skip most of what lands in the bags while levelling:
  - `CollectionMgr::AddItemAppearance(Item*)` returns unless the item is soulbound. Bind on Equip items
    are only learned when equipped (`Player::VisualizeItem`); Bind on Pickup and quest items are learned
    on pickup.
  - `CollectionMgr::CanAddAppearance` returns false when `Player::CanUseItem` fails, which includes the
    item's required level being above yours, and when the character's class can't wear the armor type
    (`PlayerClassByArmorSubclass`) or doesn't have the weapon skill. A plate drop on a mage, or a
    level 20 blue on a level 18 character, was never learned, even though it was soulbound.
  - Items received by mail, trade, guild bank or buyback go through `Player::MoveItemToInventory`,
    which never calls the collection code, so a soulbound item received that way was never learned
    either (except later, by equipping or at login).
  Nothing was wrong with storage: appearances are saved account wide in `bfa_auth.battlenet_item_appearances`
  and loaded at login.
- **Changed:**
  - `CollectionMgr.cpp`, `AddItemAppearance(Item*)`: the soulbound check is skipped when
    `Transmog.CollectOnPickup` is 1, so any item that reaches the bags or bank is learned. Items already
    in the bags and bank are learned at the next login, because `Player::_LoadInventory` already passes
    every item through this function. Refundable vendor items and Bind on Pickup items that can still
    be traded to group members get the existing temporary appearance until the refund or trade window
    ends, as before.
  - `CollectionMgr.cpp`, `CanAddAppearance`: with `Transmog.CollectAnyClass` 1, the `CanUseItem`, weapon
    skill and armor type checks are skipped (TrinityCore did the same on its current branch in 2025).
    With it 0, `Transmog.CollectIgnoreLevel` 1 still skips the required level check
    (`CanUseItem(itemTemplate, true)`). Unchanged: only armor and weapons count, poor and common quality
    items are still not collectable (as in 8.3.7), and already known appearances are skipped.
  - `Player.cpp`, `MoveItemToInventory`: calls `AddItemAppearance` on the stored item when
    `Transmog.CollectOnPickup` is 1, for mail, trade, guild bank and buyback.
  - `World.h` / `World.cpp`: new settings `CONFIG_TRANSMOG_COLLECT_ON_PICKUP` (`Transmog.CollectOnPickup`),
    `CONFIG_TRANSMOG_COLLECT_ANY_CLASS` (`Transmog.CollectAnyClass`) and
    `CONFIG_TRANSMOG_COLLECT_IGNORE_LEVEL` (`Transmog.CollectIgnoreLevel`), all default 1, so the change
    is on without editing `worldserver.conf`. `.reload config` picks up changes.
  - `worldserver.conf.dist`: new `TRANSMOG COLLECTION` section with the three settings. Set one to 0 for
    the stock 8.3.7 behavior.
  - `CollectionMgr.cpp` / `.h`: `CanAddAppearance` now calls the new public
    `GetAppearanceRejectReason`, which runs the same checks and returns the reason an appearance is
    refused (or none). `AddItemAppearance(ItemModifiedAppearanceEntry const*)` is now public, and
    `GetKnownAppearanceCount` is new.
  - `cs_debug.cpp`: new GM command `.debug transmog <item id or link> [learn]` (debug permission). It prints
    the item's ItemModifiedAppearance, whether the server knows it and whether it was sent to the client,
    the reason it can't be collected, and how many appearances the account knows. With `learn` it adds
    the appearance without the checks, to test whether the client shows it.
  - No SQL.
- **2026-10-16, in game:** with the patch, nothing was collected up to level 23, and Cape of the
  Brotherhood (5193) and the equipped Wolfmaster Cape both still said "You haven't collected this
  appearance". Cloaks pass every class rule, so something else refuses them; the debug command was added
  to find out what.
- **Found** (2026-10-16, with `.debug transmog`): the real reason nothing was collected.
  `CanAddAppearance` refuses any item that has no row in `ItemSearchName.db2`, and every item failed it.
  Cape of the Brotherhood (5193, ItemModifiedAppearance 1985) and Wolfmaster Cape (6314, 2340) both
  answered "item missing from ItemSearchName.db2". After `.debug transmog <id> learn` the client said
  "has been added to your appearance collection" and showed both cloaks in Appearances > Back, so the
  client side and the update field work. The lookup is TrinityCore's, but it finds nothing with the
  client data extracted from this 8.3.7 client, so it blocked every appearance under any rules.
- **Changed:** `CollectionMgr.cpp`, `GetAppearanceRejectReason`: the `sItemSearchNameStore.LookupEntry`
  check is removed. The item still has to have an ItemModifiedAppearance, an item template, a
  collectable source type and pass the rest of the checks.
- **Status:** confirmed in game by Four on 2026-10-16: appearances are collected again. The appearances
  tab for armor only lists your own class's armor type, so a plate piece learned on a mage shows up on a
  plate wearer.

### To pick up the transmog collection change
Everything is on `main` now. If you applied the patch from the PR branch, `tools-repo` only needs to be on
`main`. The patch file there is the same one, so nothing needs rebuilding:
```
git -C ~/bfa/tools-repo checkout main
git -C ~/bfa/tools-repo pull
```

Coming from the Shadowfang Keep update without it, add the new patch. `World.h` is in the precompiled
headers, so this is a near full rebuild. There's no SQL:
```
cd ~/bfa/source
git -C ../tools-repo checkout main
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/transmog-collection.patch
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
grep -q '^Transmog.CollectOnPickup' ~/bfa/server/etc/worldserver.conf || sed -n '/^# TRANSMOG COLLECTION$/,/^####/p' ~/bfa/server/etc/worldserver.conf.dist >> ~/bfa/server/etc/worldserver.conf
```
Then type `server shutdown 1` in the worldserver console and start it again with
`cd ~/bfa/server/bin && ./worldserver`. Log out and back in to learn what is already in your bags and bank.

## 2026-10-15

### Shadowfang Keep (map 33)

Merged to `main` with PR #11 on 2026-10-16 (work from 2026-10-15 and 2026-10-16). Script changes are in
the new `tools/bfa/shadowfang-fixes.patch`, applied after the other five patches; three core fixes found
along the way have their own patches (below). A full Alliance run was confirmed in game by Four on
2026-10-16; the Horde side has not been played yet.

First version, tested by Four on 2026-10-15: the SQL worked (the Forsaken stood up, and the door room
held exactly the 14 spawns of groups 412 and 413), but nothing was hidden. The script hid creatures with
`PhasingHandler::AddPhase`, which for a creature spawned from the database adds the phase without
clearing its "unphased" flag (`PhaseShift::ModifyPhasesReferences` skips the flag update when
`IsDbPhaseShift` is set), so every player still saw it. The second version replaces the creature's
database phase instead (below); a small test against `PhaseShift.cpp` shows the old way stays visible
and the new way hides and shows again.

#### Both factions' allies were spawned at once
- **Found** (in game, Alliance): at the door stood Packleader Ivar Bloodfang (47006) with 6 Bloodfang
  Berserkers (47027), and next to them Deathstalker Commander Belmont (47293, guid 325993), 8 Veteran
  Forsaken Troopers (47030) and Forsaken Blightspreaders (47031, e.g. guid 325984). The Forsaken lay on
  the floor like corpses, were hostile to Alliance and could be attacked but not looted.

  The keep has an Alliance version of its allies (Ivar's worgen) and a Horde version (Belmont, High
  Warlord Cromush and the Forsaken). Each has one copy per stage of the run (at the door, after
  Ashbury, after Silverlaine, after Springvale, after Walden, outside Godfrey's room), and the Horde
  version adds 162 disease-cloud bunnies (ELM General Purpose Bunny 23837 with aura 88198) that appear
  boss by boss. HavenCore spawns every copy of both versions from the start. The Cataclysm Preservation
  Project (TrinityCore 4.3.4) shows only the right one with spawn groups 412-432 that its instance
  script switches on and off.

  The Forsaken were corpses because the 47030 and 47031 templates carry Permanent Feign Death (29266),
  and 47031 also has the feign death unit flag (`unit_flags2` 33556481). Only the dead troops outside
  Godfrey's room should be corpses, and their spawns have the aura themselves. The 47293 template has
  Stealth (58506) and the 47294 template kneels (`bytes1` 8); in both cases only one spawn should.

  Baron Silverlaine and Commander Springvale were never saved as killed: their scripts used their
  creature entries (3887, 4278) as encounter ids, which are out of range, and Springvale never called
  the engage or death handlers. Also, the team in the instance was read before it was ever set, and
  Lord Godfrey compared it against the wrong constant, so he always used his Alliance line.
- **Changed:**
  - `2026_10_15_01_shadowfang_faction_troops.sql`: 19 new spawn groups, 412-432 (no 423 or 426, see
    below), with flags 0, so they spawn exactly as before and nothing changes without the patch. The
    237 spawns are matched to the CPP groups by entry and position (all within 2.4 yards), except 14
    that CPP places elsewhere, which were placed by their guid order (HavenCore's guids run stage by
    stage) and position:
    - 421, Alliance after Ashbury: 327332-327338.
    - 425, Alliance after Springvale: 327339-327345. CPP splits this stage into 425 and 426 (the
      second spawned by an areatrigger when you go outside); HavenCore has one group of 7.
    - 424, Horde after Silverlaine: Cromush 326104. 429, Horde after Springvale: Belmont 326105.
    - HavenCore has no copy of CPP's Alliance group after Silverlaine (423), so the worgen are not
      seen between Silverlaine and Springvale.
  - The same file sets `auras` to '' on the 47030, 47031 and 47293 template addons, `bytes1` 0 on the
    47294 template addon, and 47031 `unit_flags` 512 to 768 and `unit_flags2` 33556481 to 33556480 (as
    in CPP). Revert lines are in the file.
  - `instance_shadowfang_keep.cpp`: each creature in groups 412-432 is shown only while its group is
    active for the team in the instance (the first player's) and the bosses killed so far, the same
    stages as CPP's script. The others get phase 65535, which no player is in, as their database phase
    (`PhasingHandler::InitDbPhaseShift`), so they are not seen and do not fight or talk; shown again,
    they get their own database phase back. This is checked when a creature spawns, when the first player enters, when a
    boss dies, and once when the Godfrey intro starts. CPP starts the intro with areatrigger 6431; here
    it starts when a player reaches the landing outside Godfrey's room (within 30 yards of -165, 2181,
    above z 145) after Lord Walden, which swaps Ivar or Belmont from Walden's room to Godfrey's door.
  - `instance_shadowfang_keep.cpp`: the team in the instance starts at 0 instead of an unset value.
  - `boss_baron_silverlaine.cpp`, `boss_commander_springvale.cpp`: encounter ids are now
    `DATA_BARON_SILVERLAINE_EVENT` and `DATA_COMMANDER_SPRINGVALE_EVENT`. Springvale now calls
    `_JustEngagedWith()` and `_JustDied()` like the other bosses. Silverlaine's calls to the
    instance's `SetData`, which did nothing, are removed.
  - `boss_lord_godfrey.cpp`: his aggro line checks the team against `HORDE` instead of `TEAM_HORDE`.
  - `shadowfang_keep.cpp`: the Haunted Stable Hand's teleports check the saved boss states (they
    never appeared before), and "Baron Silberlein" is now "Baron Silverlaine".
- **Status:** second version in game since 2026-10-15; Four reported "so far so good" and played on to
  Godfrey with it. Instances already open before the update keep their old boss states, so test in a fresh one.
  Full Alliance run confirmed by Four on 2026-10-16. The Horde side (Belmont and the Forsaken) has not
  been played yet.

#### Lord Walden evaded as soon as he was hit
- **Found** (in game): hitting Lord Walden put him straight into evade mode, and Lord Godfrey did the
  same.
- **Cause:** `boss_lord_walden.cpp` only started the fight if `SelectNearestPlayer(10.0f)` found a player,
  and otherwise evaded. Lord Godfrey had the same check (`boss_lord_godfrey.cpp`). Four pulled with
  Ambush from right behind, so distance wasn't it: HavenCore's `WorldObject::SelectNearestPlayer` and
  `SelectNearestPlayers` (`Object.cpp`) search with `Cell::VisitGridObjects`, which only visits
  creatures and objects, never players (upstream TrinityCore uses `VisitWorldObjects`). So the check
  never found anyone and both bosses always evaded. About 170 other scripts call these two, so Four chose
  to fix them core-wide (next entry).
- **Changed:** both bosses now start the fight on any pull; the 10-yard check is removed.
- **Status:** Lord Walden pulls and dies normally in game (Four, 2026-10-15).

#### Lord Walden never threw Frost Mixture on Normal
- **Found** (in game): Four found Walden's Normal fight "tank and spank".
- **Cause:** on Normal he has three abilities: Conjure Frost Mixture (93505), Conjure Poisonous Mixture
  (93697) and Ice Shards (93527). Conjure Mystery Toxin (Toxic Coagulant / Catalyst) is Heroic only.
  CPP's script, which follows retail, casts Frost Mixture on both difficulties. HavenCore's
  `boss_lord_walden.cpp` only cast it on Heroic, though it kept rescheduling it on Normal.
- **Changed:** Frost Mixture is cast on Normal too, at a random player within 50 yards, every 10 to 20
  seconds (HavenCore's timer, unchanged). Poisonous Mixture and Ice Shards were already used on Normal.
- **Status:** confirmed in game by Four on 2026-10-16, together with `random-target.patch`: he casts
  Conjure Poisonous Mixture, Conjure Frost Mixture and Ice Shards. (Before that core fix he still only
  meleed, because neither mixture ever found a target.)

#### Lord Godfrey only summoned ghouls
- **Found** (in game): Lord Godfrey pulled and fought, but the only ability he used was Summon Bloodthirsty
  Ghouls. On Normal he also has Cursed Bullets and Mortal Wound.
- **Cause** (`boss_lord_godfrey.cpp`):
  - Mortal Wound (93675, Heroic 93771) was cast with `DoCast(spellId)`, which picks the target from the
    spell's range. A melee-range spell has no fixed range, so it was aimed at Godfrey himself and never
    landed. It was also only tried every 25 seconds, for a debuff that stacks up to 10 times.
  - Cursed Bullets (93629, Heroic 93761) went to any random unit on his threat list at any range, cast
    instantly (triggered).
  - Pistol Barrage was scheduled on both difficulties; it is a Heroic-only ability.
- **Changed**, following CPP's script:
  - Mortal Wound is cast on his current target 3 to 4 seconds into the fight, then every 5 seconds.
  - Cursed Bullets goes to a random player within 50 yards, with its normal cast time, every 12 seconds
    (first after 15 seconds, as before).
  - Pistol Barrage is only scheduled on Heroic.
  - Summon Bloodthirsty Ghouls is unchanged.
- **Status:** confirmed in game by Four on 2026-10-16: he melees, casts Cursed Bullets and applies Mortal Wound.

#### Typos in Lord Godfrey's yells
- **Found** (in game): Four spotted typos in Lord Godfrey's (46964) lines and fixed them in the database
  on 2026-10-16.
- **Changed:** `2026_10_16_02_shadowfang_godfrey_text.sql` makes the same fix in `creature_text`:
  - group 0 (aggro): "That bitch Sylvanas sent you too,did she?No matter,your journey ends in agony." is now
    "That bitch Sylvanas sent you too, did she? No matter - your journey ends in agony."
  - group 2 (death): "I thank you for the clearn death.I would not of done the same..." is now
    "I thank you for the clean death. I would not have done the same..."
  Revert lines are in the file.
- **Status:** Four's own fix is live on their server. The file ran cleanly twice here; Four doesn't need to run it.

#### Lesser Gargoyles never attacked
- **Found** (in game): on the wall walk the Lesser Gargoyles (3869) never aggro, in or out of stealth.
- **Cause:** the world dump flags them `CREATURE_FLAG_EXTRA_CIVILIAN` (`flags_extra` 2). A civilian never
  starts a fight (`Creature::CanStartAttack`), although these are hostile (faction 16) and have loot and
  gold like other trash.
- **Changed:** `2026_10_16_01_shadowfang_lesser_gargoyles.sql` clears that one bit. Revert line is in the file.
- **Status:** confirmed in game by Four on 2026-10-16: they aggro once you leave stealth. The Stone
  Sleepers stayed asleep in the same test because `2026_10_15_02_shadowfang_stone_sleepers.sql` had not been
  run on that database yet (the Stone Sleeper still had the old unit flags, 16777215).

### Core: scripts never found the nearest player

New `tools/bfa/player-search.patch`, applied seventh, after `shadowfang-fixes.patch`. Chosen by Four on
2026-10-15 over fixing only Shadowfang Keep.

- **Found:** while looking into Walden and Godfrey (above). `WorldObject::SelectNearestPlayer` and
  `WorldObject::SelectNearestPlayers` (`src/server/game/Entities/Object/Object.cpp`) search with
  `Cell::VisitGridObjects`. That visits the grid container (game objects, creatures that aren't pets,
  area triggers and so on). Players live in the world container, so both always returned nothing.
  `SelectRandomPlayerInRange` uses `SelectNearestPlayers` and was empty too.
- **Changed:** both use `Cell::VisitWorldObjects`, as upstream TrinityCore does. Two lines.
- **Effect:** every script that looks for the nearest player, or picks players in range, now finds
  them. That is about 170 calls across dungeon, raid and world scripts, and SmartAI's closest-player
  target. Content tested before this, such as The Deadmines, may behave differently where it relied on
  this; tell me if anything changes.
- **Status:** confirmed in game by Four on 2026-10-16 through Lord Walden, who now pulls normally. Content tested before it (The Deadmines, Ragefire Chasm) not re-run yet.

### Core: mobs pulled from stealth evaded

New `tools/bfa/stealth-pull.patch`, applied eighth, after `player-search.patch`. It changes the
`CreatureAI::UpdateVictim` code that `deadmines-fixes.patch` added, so it needs that patch applied first.

- **Found** (in game, Shadowfang Keep): Four, a rogue, opened on Baron Ashbury from stealth from right
  behind. He yelled his aggro line ("Tally ho, the hunt begins"), went into evade mode (hits showed Evade), walked home
  and despawned. After he respawned, a pull out of stealth worked normally.
- **Cause:** a mob can't see a stealthed player standing behind it (`WorldObject::CanDetectStealthOf`
  only detects behind within its combat reach). With Subterfuge, stealth lasts 3 more seconds after the
  opener. While a player can't be seen, their threat entry is offline, so the mob has no target. HavenCore
  already evaded in that case while in combat, and `deadmines-fixes.patch` made it evade in every case
  (to fix Release Spirit after a wipe). So the mob evaded the moment it was pulled from stealth, and
  Ashbury despawns on evade. Same cause as Foe Reaper evading on a stealthed rogue in The Deadmines.
- **Changed:** in `src/server/game/AI/CreatureAI.cpp`, a mob with no target no longer evades while it
  is in combat and a living player who has threat on it is only hidden from it. It waits, and attacks as
  soon as it can see that player again. Vanish sets your threat to 0 in dungeons, so vanishing still
  resets the fight. A wipe still resets it too: dead players don't count.
- **Effect:** core-wide, for every mob and boss. A mob a hidden player has hit stands still until they
  show up, instead of resetting.
- **Status:** confirmed in game by Four on 2026-10-16: Baron Ashbury fights normally when pulled from stealth.

### Core: spells cast at a random player never went off

New `tools/bfa/random-target.patch`, applied ninth, after `stealth-pull.patch`.

- **Found** (in game, Shadowfang Keep): Lord Walden only meleed, even after Frost Mixture was turned on
  for Normal.
- **Cause:** `UnitAI::DoCastRandom` (`src/server/game/AI/CoreAI/UnitAI.cpp`) calls
  `SelectTarget(SELECT_TARGET_RANDOM, position, dist, true, aura)`. `SelectTarget`'s fifth parameter is
  `withTank`, not the aura, so the aura filter (almost always 0) turned into `withTank = false`. The player
  a boss is fighting was never a candidate. Solo, that leaves nobody, so the spell was never cast.
- **Changed:** `withTank` is passed as `true` and the aura goes in its own slot. One line.
- **Effect:** 57 calls use it. In content tested before: Lord Walden's Conjure Poisonous Mixture and
  Conjure Frost Mixture, and Gordoth's Ground Rupture in Ragefire Chasm. Baron Ashbury's Pain and
  Suffering skips the top-threat player on purpose, so solo it still isn't cast.
- **Status:** confirmed in game by Four on 2026-10-16 on Lord Walden. Gordoth not re-tested yet.

#### Stone Sleepers never came to life
- **Found** (in game): on the wall walk the Lesser Gargoyles (3869) attack, but the Stone Sleepers (3870)
  sit there inactive.
- **Cause:** Stone Sleepers are gargoyles that sit as stone and wake when someone walks past ("A nearby
  Gargoyle comes to life!", broadcast text 47423). Their SmartAI set every unit flag (16777215, including
  `NOT_SELECTABLE` and `IMMUNE_TO_PC`) on spawn and only cleared them on aggro, which those flags make
  impossible.
- **Changed:** `2026_10_15_02_shadowfang_stone_sleepers.sql` replaces the 3870 SmartAI. While asleep a
  Stone Sleeper is only `NOT_SELECTABLE | IMMUNE_TO_PC` (33554688). A hostile unit within 15 yards in
  line of sight wakes it: it clears those flags, emotes the line above (new `creature_text` row) and
  attacks that unit. After a reset it sleeps again. The Normal and Heroic fear casts are unchanged.
  Revert lines are in the file.
- **Status:** confirmed in game by Four on 2026-10-16: the Stone Sleepers wake and attack.

#### Overlapping Frantic Geists: checked, left as is
- **Found** (in game): many spawns overlap, for example Frantic Geists standing almost inside each other.
- **Checked:** no two spawns in the keep share a spot (the closest pairs of the same creature are 0.5 to
  1 yard apart: Plagued Rats, Maggots and Geists). Frantic Geists come in tight packs: the Cataclysm sniff
  CPP imported (`2015_09_02_06_world.sql`) has 25 of them in packs of 4 to 5, 1 to 2 yards apart.
  HavenCore has 18 in packs of 2 to 3. Not changed.

### To pick up the Shadowfang Keep changes
Everything is on `main` now. If your `tools-repo` is still on the Shadowfang branch, put it back on `main`.
The patch files there are the same, so nothing needs rebuilding:
```
git -C ~/bfa/tools-repo checkout main
git -C ~/bfa/tools-repo pull
```

Coming from the 2026-10-15 Ragefire update with none of this applied, add the four new patches in order
and run the four SQL files (each is safe to run twice):
```
cd ~/bfa/source
git -C ../tools-repo checkout main
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/shadowfang-fixes.patch
git apply ../tools-repo/tools/bfa/player-search.patch
git apply ../tools-repo/tools/bfa/stealth-pull.patch
git apply ../tools-repo/tools/bfa/random-target.patch
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_15_01_shadowfang_faction_troops.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_15_02_shadowfang_stone_sleepers.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_16_01_shadowfang_lesser_gargoyles.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_16_02_shadowfang_godfrey_text.sql
```
Then restart `worldserver` and use a fresh instance. If any `git apply` line prints an error, stop and
check it before building: a patch that didn't apply leaves that fix out silently.

### Ragefire Chasm (map 389)

Merged to `main` with PR #10 on 2026-10-15. Core changes are in the new
`tools/bfa/ragefire-fixes.patch`, applied after the other four patches.
Tested on Normal by Four on 2026-10-14: all four bosses work, and so do The Dark Shaman and A New
Enemy.

#### No Man Left Behind could not be finished
- **Found** (in game): only two SI:7 Rangers could be rescued, through the Suspicious Rock and the
  Inconspicuous Crate. Another ranger stood by the lava near Slagmaw and could not be clicked. The
  quest (30995, Alliance) needs 5 SI:7 Rangers (61788); the Horde version, No Orc Left Behind (30984),
  needs 5 Kor'kron Scouts (61680) and is set up the same way. Each faction has 8 prisoners in the
  instance (the other faction's are despawned by `instance_ragefire_chasm`):

  | Where (x, y) | SI:7 Ranger guid | Kor'kron Scout guid | Rescued by, before |
  |---|---|---|---|
  | Suspicious Rock (-311, -24) | 10642793 | 10615969 | talking to the rock |
  | Inconspicuous Crate (-89, 69) | 10642792 | 10615895 | talking to the crate |
  | Cages beside Lava Guard Gordoth (-378, 188 / -377, 185 / -376, 182) | 10642794, 10642797, 10642796 | 10615981, 10615985, 10615984 | clicking the cage (cage objects 211883-211885) |
  | By the lava near Slagmaw (-287, 135) | 10642795 | 10615970 | nothing |
  | Lying near Adarogg (-257, -49) | 10642790 | 10615942 | nothing |
  | Lying in the tunnel (-173, 2) | 10642791 | 10615916 | nothing |

  Both prisoner templates have `unit_flags` 33850176, which includes `NOT_SELECTABLE` and `STUNNED`, so
  none of them can be clicked. Their SmartAI only rescued on a spell click, and they have no
  `npc_spellclick_spells` row or spell click flag, so it never ran. The cages are door objects with a
  placeholder name ("Cage de l"); whether they can be clicked in the client isn't confirmed, and
  none were seen there in game.
- **Changed:**
  - `ragefire_chasm.cpp`: new creature script `npc_rfc_prisoner` for both prisoners. One second after
    spawning, a prisoner that is not within 3 yards of the rock or the crate becomes selectable and
    gets a gossip flag. Talking to it while on the quest rescues it; a caged one opens its cage.
  - `ragefire_chasm.cpp`: the credit and escape part of `RescuePrisoner()` is now `FreePrisoner()`,
    shared by the rock, the crate, the cages and talking to a prisoner. A freed prisoner loses its
    gossip flag and `STUNNED`, stands up, says its line, runs off and despawns. A prisoner without
    `STUNNED` can't be rescued again, so a prop or cage clicked twice can't give two credits. The
    5-credit cap moved into `GetNeededCreditEntry()`, used by every rescue.
  - `2026_10_15_00_ragefire_rescue_prisoners.sql`: 61680 and 61788 go from `AIName` 'SmartAI',
    `ScriptName` '' to `AIName` '', `ScriptName` 'npc_rfc_prisoner', and their 3 `smart_scripts` rows
    each are deleted. Revert lines are in the file.
- **Status:** confirmed in game by Four on 2026-10-15: No Man Left Behind completes. That gives 8
  rescuable prisoners for the 5 the quest needs.

### To pick up the 2026-10-15 changes
```
cd ~/bfa/source
git checkout -- .
git -C ../tools-repo checkout main
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/bfa-linux-fixes.patch
git apply ../tools-repo/tools/bfa/profession-skill-sync.patch
git apply ../tools-repo/tools/bfa/deadmines-fixes.patch
git apply ../tools-repo/tools/bfa/dungeon-scale.patch
git apply ../tools-repo/tools/bfa/ragefire-fixes.patch
cmake --build build -j"$(nproc)" && cmake --build build --target install
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_15_00_ragefire_rescue_prisoners.sql
```
Then restart `worldserver`.

## 2026-10-12

### NPC Designer, vendor module

`tools/npc-designer/`, all new (PR #9, merged).

- What: a PySide6 desktop app for designing vendor NPCs for BFA 8.3.7, Pandaria 5.4.8 and WotLK 3.3.5: name, title,
  display IDs, levels, faction, vendor type, repair, held items, items for sale with per-vendor prices, stock and
  restock, a drawn merchant-window preview, SQL export, and Apply to database (runs the export on the connected
  world DB after checking it matches the target).
- Writes: `creature_template` (npcflag 128 + repair 4096 / gossip 1 / tracking flags), `creature_template_model`
  (BFA) or `modelid1-4`, optional `creature_equip_template`, `npc_vendor` (BFA `OverrideGoldCost`, -1 = item's own
  price), optional `creature` spawns. Each table's old rows for the entry are deleted first.
- Item names/prices: BFA `dbc/enUS/ItemSparse.db2` (sparse WDC3), Pandaria `Item-sparse.db2` (WDB2), WotLK world DB.
- Status: confirmed working on BFA by Four (117,741 items loaded, export and apply). Pandaria/WotLK schema-tested only.
- To pick up: `cd ~/zrbfacore; git pull; ./tools/npc-designer/npc-designer` (needs `sudo dnf install python3-pyside6 python3-pymysql`).

### DungeonScale: dungeon mobs scale to your group

- **Found:** a pack of one Defias Enforcer and two Defias Shadowguards after Foe Reaper killed a level 17
  rogue in about 20 hits (235 to 508 each). Neither mob is out of line for the dungeon: the Enforcer
  has `DamageModifier` 15, like the ogres, Goblin Overseers and Defias Pirates. The Shadowguard has
  17.9, and the Squallshapers, Blood Wizards and Envokers have 20.8. Three elites built for a group of
  five were all hitting one player. HavenCore's Solocraft only raises the player's stats. It has no way
  to lower the damage you take.
- **Changed:** new `tools/bfa/dungeon-scale.patch`, a port of ZRPandaria's DungeonScale:
  - 5-man dungeon creatures get a share of their health and damage that depends on how many players
    are inside:

    | Rank | Health solo | Damage solo |
    |---|---|---|
    | Normal and elite trash | 30% | 30% |
    | Bosses | 35% | 35% |
    | Final boss | 40% | 35% |

    Both rise in a straight line to 100% at 5 players. For trash: 1 player 30%, 2 players 47.5%,
    3 players 65%, 4 players 82.5%, 5 players 100%.
  - A boss is any creature in `instance_encounters`. The final boss is the one with
    `lastEncounterDungeon` set: "Captain" Cookie on Normal and Vanessa VanCleef on Heroic. Adds a boss
    summons are scaled like the boss.
  - No single hit or DoT tick from a scaled creature takes more than 35% of your max health. The
    combat log still shows the uncapped number.
  - When someone joins or leaves, creatures out of combat are rescaled within a second. Creatures in
    combat keep their values until the fight ends for them.
  - Raids, scenarios and Mythic+ are not scaled unless turned on in the settings.
  - GM commands: `.dungeonscale info` and `.dungeonscale creature`.
  - Left out from the ZRPandaria version: the honor per kill.
- **Files:**
  - `ScriptMgr.h` / `ScriptMgr.cpp`: new `AllCreatureScript` hook type with `OnCreatureAddWorld`,
    `OnCreatureRemoveWorld` and `OnCreatureSelectLevel`.
  - `Creature.cpp`: `AddToWorld()`, `RemoveFromWorld()` and `UpdateLevelDependantStats()` call those
    hooks.
  - `solocraft.cpp`: the DungeonScale script, added at the end of the file so the patch creates no new
    files and `git checkout -- .` still removes it cleanly.
  - `custom_script_loader.cpp`: registers it.
  - `worldserver.conf.dist`: a new `DUNGEON SCALE` block at the end, with every setting explained.
- **Settings to change:** copy the `DungeonScale.*` block into `worldserver.conf` and set
  `Solocraft.Enable = 0`. Solocraft's +400% stats on top of 30% mobs would make dungeons trivial. The
  commands below do both.
- **Watch for:** Helix's `DamageModifier` is still 12 from `2026_10_11_01`. Scaled to 35%, he hits for
  about 21 instead of 60. If he's now too soft, his stock 57.5 scaled to 35% comes out at about 20, the
  value ZRPandaria used. The revert line is in that SQL file.
- **Status:** not tested in game yet.

### The Deadmines (map 36), Normal

Merged to `main` with PR #8 on 2026-10-12, together with the 2026-10-11 Deadmines fixes below.
Four ran the whole dungeon on 2026-10-14 with all of these in and reported it ran great; the
entries below were not checked one by one.
Still open, not fixed: a few old vanilla NPCs in the normal phase (Defias Miner 598 ×1, Defias Pirate
657 ×3 near the ship, Squallshaper 1732 ×1), and heroic Cookie can leave up to three "A Note From
Vanessa".

#### Heroic Vanessa event spawned on Normal
- **Found** (in game): a ghostly human Ripsnarl stood outside the door to the ship, and `.debug combat`
  showed the player stuck in combat with five Vanessa VanCleefs, also inside the Foe Reaper room.
  Vanessa's encounter and her nightmare event are Heroic-only, but 21 of their spawns had
  `spawnDifficulties` '1,2', so they spawned on Normal too. The nightmare Vanessas (49671) pull every
  player nearby into combat with themselves, which blocked logging out.
- **Changed:** `2026_10_12_01_deadmines_heroic_vanessa_event_spawns.sql` sets `spawnDifficulties` from
  '1,2' to '2' (Heroic only) for these spawns, the same as the event's lightning spawns already had:

  | Entry | Creature | Spawns (guid) |
  |---|---|---|
  | 49429 | Vanessa VanCleef (ship intro) | 326855 |
  | 49454 | Vanessa's Trap Bunny | 326857 |
  | 49457 | Steam Valve | 326856, 326858, 326859, 326860 |
  | 49552 | Vanessa's Rope Anchor | 326765, 326766, 326767, 326768, 326769 |
  | 49670 | Glubtok (nightmare) | 326861, 326904 |
  | 49671 | Vanessa VanCleef (nightmare) | 326862, 327028, 327095 |
  | 49674 | Helix Gearbreaker (nightmare) | 326922 |
  | 49681 | Foe Reaper 5000 (nightmare) | 327029, 327093 |
  | 49682 | Ripsnarl (nightmare) | 327094 |
  | 51624 | Vanessa Anchor Bunny JMF | 326763 |

  The two Vanessas without a spawn ID in `.debug combat` were summoned by these and go with them.
- **Status:** the cause is confirmed in game (`.debug combat` listed these Vanessas). The fix itself
  is not tested in game yet. It also probably explains the "stuck in combat" from the Foe Reaper room
  below and from the Mine Bunny.

#### Foe Reaper never woke, Defias Reapers vanished
- **Found** (in game): burnt-out Defias Reapers disappeared, the player stayed in combat, and Foe
  Reaper never powered up, so he couldn't be attacked. The Defias Watchers stayed. A burnt-out
  mech kept 15 health, and `DamageTaken` ignored all damage once it was burnt out, so poisons and
  DoTs already on it kept ticking and killed it. The Reapers are summoned with a 10-second corpse
  despawn, so their corpses vanished. The Watchers are normal spawns, so theirs stayed. A mech that
  died while still casting Energize never reached Foe Reaper. He only checked whether to wake when an
  Energize landed, so he slept for good.
- **Changed** in `boss_foe_reaper_5000.cpp`:
  - `npc_defias_watcher::DamageTaken`: a burnt-out mech now takes no damage at all.
  - `npc_defias_watcher::Energizing`: on burning out, the mech drops every periodic damage aura on it
    (`SPELL_AURA_PERIODIC_DAMAGE`, `_DAMAGE_PERCENT`, `PERIODIC_LEECH`). Energize is now cast as
    triggered, so it lands at once and can't be interrupted.
  - `boss_foe_reaper_5000AI::UpdateAI`: while he is asleep, he checks every second whether any
    hostile Reaper or Watcher is still alive within 60 yards. If none is, he wakes up, even without a
    last Energize.
- **Combat:** the combat that held you came from the heroic Vanessa event spawns (see above), not
  from the mechs.
- **Status:** confirmed in game 2026-10-12. All mechs stayed disabled and Foe Reaper powered up.

#### Foe Reaper reset right after waking on a stealthed player
- **Found** (in game, rogue in stealth): Foe Reaper powered up, said "Target destroyed", summoned four
  new Defias Reapers and went back to sleep a moment later. On waking he called `DoZoneInCombat()`,
  which puts every player in the instance into combat with him. A stealthed player he can't see is
  not a valid target, so he had nobody to attack, evaded and reset. Even without stealth, a solo
  player was pulled the instant the last mech went down, with no time to recover.
- **Changed** in `boss_foe_reaper_5000.cpp`, `boss_foe_reaper_5000AI`:
  - `EVENT_START_2` (powering up) no longer calls `DoZoneInCombat()`. He becomes attackable and
    aggressive and waits to be pulled: attack him, or walk into his aggro range. Once pulled,
    `JustEngagedWith()` still puts the whole group in combat as before.
  - New `_waitingForPull` / `_sleepTimer`, reset in `Reset()`. If nobody pulls him within 5 minutes
    (`FOE_REAPER_WAIT_FOR_PULL`), he emotes "Foe Reaper 5000 powers down." and resets: asleep and
    untouchable again, with four new Defias Reapers. The Defias Watchers stay disabled, as before.
- **Not changed:** dying or vanishing during the fight still resets him as before.
- **Status:** compiles; not tested in game yet.

#### Mine Bunny Drunken Haze
- **Found:** a Mine Bunny (48338, 48351) left you fully drunk after the fight, with no debuff and
  nothing in `.list auras`. Her SmartAI casts Drunken Haze (91032) on her target every 7 to 10
  seconds. Besides its 10-second debuff (50% slower movement, 30% slower attacks and casts), the
  spell has an Inebriate effect that sets your character's drunk level to 100. That level is
  stored on the character, not as an aura, and only drops by 1 every 9 seconds, so it lasted about
  15 minutes. `.modify drunk 0` clears it.
- **Changed:**
  - `boss_vanessa_vancleef.cpp`: new spell script `spell_dm_drunken_haze` skips the Inebriate
    effect and leaves the rest of the spell alone.
  - `2026_10_12_00_deadmines_mine_bunny_drunken_haze.sql` adds one `spell_script_names` row:
    91032 -> `spell_dm_drunken_haze`. Nothing was bound to 91032 before.
- **Not changed:** the being stuck in combat and unable to log out wasn't reproduced. With a live
  Mine Bunny still on you, that is normal combat. If it happens with nothing alive near you,
  `.combatstop` clears it.
- **Status:** not tested in game yet.

### To pick up everything from 2026-10-12
`ScriptMgr.h` changed, so this build recompiles nearly everything.
```
cd ~/bfa/source
git checkout -- .
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/bfa-linux-fixes.patch
git apply ../tools-repo/tools/bfa/profession-skill-sync.patch
git apply ../tools-repo/tools/bfa/deadmines-fixes.patch
git apply ../tools-repo/tools/bfa/dungeon-scale.patch
cmake --build build -j"$(nproc)" && cmake --build build --target install
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_12_00_deadmines_mine_bunny_drunken_haze.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_12_01_deadmines_heroic_vanessa_event_spawns.sql
grep -q '^DungeonScale.Enable' ~/bfa/server/etc/worldserver.conf || sed -n '/^# DUNGEON SCALE$/,$p' ~/bfa/server/etc/worldserver.conf.dist >> ~/bfa/server/etc/worldserver.conf
sed -i 's/^\(Solocraft\.Enable *= *\)1/\10/' ~/bfa/server/etc/worldserver.conf
```
Then restart `worldserver`. Its log shows `[DungeonScale] Loaded config: ENABLED`.

## 2026-10-11

### The Deadmines (map 36), Normal

All of these were merged to `main` with PR #8 on 2026-10-12. Core changes are in `tools/bfa/deadmines-fixes.patch`, and world data
changes are in `sql/fixes/world/2026_10_11_*.sql`. Each SQL file is safe to run twice and lists its own
revert lines. Tested at level 16-17 on a rogue with SoloCraft on.

#### Trash that never fought back
- **Found:** about 40 spawns of 7 trash types entered combat but never attacked or chased. Goblin
  Overseers also dropped you as soon as you left their room. Their scripts' `UpdateAI` never called
  `UpdateVictim()`, so line-of-sight aggro only added threat and no target was ever picked.
- **Changed** in `boss_vanessa_vancleef.cpp`. Each AI now starts `UpdateAI` with
  `if (!UpdateVictim()) return;`. This covers:

  | Creature | Entry | Spawns |
  |---|---|---|
  | Ogre Henchman | 48230 | 5 |
  | Goblin Overseer | 48279 | 11 |
  | Oaf Lackey | 48445 | 6 |
  | Defias Shadowguard | 48505 | 5 |
  | Defias Enforcer | 48502 | 6 |
  | Defias Envoker | 48418 | 3 |
  | Defias Blood Wizard | 48417 | 4 |
- **Also changed:** the Oaf Lackey's Enrage (`below`) and the Goblin Overseer's Threatening (`threat`)
  "already used" flags now reset to `false`. Both had started out as already used, so neither ability
  ever fired.
- **Status:** confirmed in game.

#### Boss doors closed again behind dead bosses
- **Found:** a door only opened at the moment its boss died. Kills are saved, but the doors are not,
  so after a `worldserver` restart, or once an empty area unloaded (5 minutes), they were shut again.
- **Changed** in `instance_deadmines.cpp`, `OnGameObjectCreate`. When a door is created, it opens if
  its boss is already DONE:

  | Door | Entry | Opens when |
  |---|---|---|
  | Factory Door | 13965 | Glubtok is dead |
  | Mast Room Door | 16400 | Helix is dead |
  | Foundry Door | 16399 | Foe Reaper 5000 is dead |
  | Iron Clad Door | 16397 | Ripsnarl is dead (it gets the "alternative active" state) |
- **Status:** not tested in game. It only shows after a restart or unload.

#### Mine Bunny damage
- **Found:** the two Mine Bunnies (48338, 48351) hit for about 1,700 at level 15. They had
  `DamageModifier` 125, a raid-boss value. Every other elite here sits between 15 and 21.
- **Changed:** `2026_10_11_00_deadmines_mine_bunny_damage.sql` sets `DamageModifier` from 125 to 15,
  the same as the ogres around them.
- **Status:** not confirmed separately in game.

#### Helix Gearbreaker and the Lumbering Oaf
- **Found:** the Oaf Helix rides (47297) ran the trash Oaf Lackey script, so it never grabbed or charged
  anyone. Helix never learned it had died. The real Oaf script was attached to 40906, an unrelated level
  28 Lumbering Oaf in Kalimdor.
- **Changed** in `2026_10_11_01_deadmines_lumbering_oaf_helix.sql`:
  - `creature_template.ScriptName` of 47297 changes from `npc_oaf_lackey` to `npc_lumbering_oaf`.
  - 40906 changes from `npc_lumbering_oaf` to empty, so it runs its own SmartAI again.
- **Found:** Helix swings every 0.5 s with `DamageModifier` 57.5. That was about 15 times the damage per
  second of the other bosses, and he also meleed from the Oaf's back on top of the Oaf's own hits.
- **Changed:**
  - In the same SQL file, Helix (47296) `DamageModifier` goes from 57.5 to 12. ZRPandaria used 20, but
    20 still killed a level 17 rogue here (100 to 200 per hit). 12 is about 60 per hit.
  - `boss_helix_gearbreaker.cpp`: Helix only melees when he is not riding the Oaf.
  - `boss_helix_gearbreaker.cpp`: if the Oaf's charge doesn't happen, it drops the player it grabbed,
    instead of carrying them until the next grab.
  - `boss_helix_gearbreaker.cpp`: the Oaf's `bunny` pointer now starts at `nullptr`.
- **Found:** Helix threw no Sticky Bombs. His Throw Bomb spell (88264) was bound in `spell_script_names`
  to `spell_throw_bomb`, a Winter Veil quest script that cancels the cast unless the caster is on a
  flying mount.
- **Changed:** `2026_10_11_03_deadmines_helix_sticky_bomb.sql` deletes that one row. Nothing else used it.
- **Found:** after a wipe, Helix climbed onto a new Oaf in `Reset()` while still walking home. That cut
  the walk short and could leave him stuck in evade mode.
- **Changed** in `boss_helix_gearbreaker.cpp`: he now mounts in `JustReachedHome()`, once he is home.
- **Status:** the Oaf fight and the Helix fight are confirmed good in game. The bombs were not confirmed
  separately.

#### Foe Reaper 5000
- **Found:** a Defias Reaper that died to one big hit never energized him, so he could stay asleep
  forever. The 10% health check subtracted the hit from the reaper's health as an unsigned number, which
  wrapped around.
- **Changed** in `boss_foe_reaper_5000.cpp`, `npc_defias_watcher::DamageTaken`. A hit at least as big as
  the remaining health now also counts.
- **Found:** he woke on the 4th Energize. The two Defias Watchers (47404) in his room energize him too,
  so killing them first woke him with two Defias Reapers (47403) still attacking.
- **Changed:** he now wakes when no living, hostile Reaper or Watcher is left within 60 yards.
- **Found:** he only picked a target during his abilities and stood still in between.
- **Changed:** `UpdateAI` calls `UpdateVictim()` every update, so he chases his top-threat target the
  whole fight. He only melees when he has a target.
- **Found:** Overdrive never ended. He kept switching to a random target every 1.5 s, at a fixed run
  speed of 4 yards per second.
- **Changed:** Overdrive now lasts 10 seconds. He stops attacking, goes passive and wanders within 15
  yards while it spins, then removes the aura and attacks again. It still comes every 45 seconds.
- **Found:** after Harvest his run speed was set to 2 yards per second for the rest of the fight.
- **Changed:** he now goes back to his normal run speed from `creature_template` and chases again.
- **Found** (in game, after the changes above): Defias Reapers came back mid-pull, and the burning
  mechs kept you in combat. He was attackable, but passive, before waking, so a stray hit or AoE pulled
  him. With the every-update target check above, he reset as soon as that combat ended, and his reset
  despawns the Reapers and summons four fresh ones. A disabled Reaper or Watcher also kept its threat
  and pulled every player in the instance into combat with itself.
- **Changed:**
  - `Reset()` now makes him non-attackable, immune to players and stunned until he wakes. The wake-up
    clears those flags before pulling the room into combat. `InitializeAI()` no longer removes them on
    spawn.
  - `npc_defias_watcher::Energizing()` now clears the mech's threat and stops its combat when it
    burns out, instead of calling `SetInCombatWithZone()`.
- **Not a bug:** the rideable Prototype Reaper (49208) is Heroic-only, as on retail.
- **Left as is:** burnt-out Reapers and Watchers show a vehicle cursor. `npc_spellclick_spells` gives
  47403 and 47404 the click spells 58961 and 90102. Whether riding them does anything on Normal hasn't
  been checked.
- **Status:** not tested in game yet.

#### Admiral Ripsnarl
- **Found:** once the fog rolled in at 75%, he summoned a Vapor every 3.5 seconds for the rest of the
  fight.
- **Changed** in `boss_admiral_ripsnarl.cpp`. Vapors now come every 3.5 seconds while he is hidden, and
  every 12 seconds once he is back. The fog itself still stays for the rest of the fight, as on retail.
- **Found:** he came back out of the fog both after 25 seconds and after 4 Vapor kills. When both
  happened, his Swipe timer was started twice and he swiped twice as often.
- **Changed:** he now comes back once per vanish. Vapors killed while he is visible no longer count
  toward bringing him back early.
- **Status:** not tested in game yet.

#### "Captain" Cookie
- Reviewed his script, the food NPCs and his spell script bindings. Nothing changed.

#### Boss yells
- **Found:** `creature_text` had no rows for the Deadmines bosses, so every `Talk()` was silent.
- **Changed:** `2026_10_11_02_deadmines_boss_texts.sql` adds the retail Cataclysm lines, with their
  sound IDs and BroadcastText IDs, numbered to match HavenCore's script group IDs:
  - Glubtok (47162): 8 lines.
  - Helix (47296): 4 lines.
  - Lumbering Oaf (47297): "OAF SMASH!!".
  - Foe Reaper 5000 (43778): 5 lines.
  - Admiral Ripsnarl (47626): 7 lines.

#### Boss loot
- **Found:** each boss item on Normal rolled on its own at 9 to 19%, so a kill often dropped only gold.
  Glubtok dropped no item about 58% of the time, and Helix about 64%. Today's changes hadn't touched loot.
  The rows matched the original dump.
- **Changed:** `2026_10_11_04_deadmines_boss_loot.sql` moves each boss's usual Normal items into loot
  group 1 with `Chance` 0. Exactly one of them now drops on every kill, picked evenly:

  | Boss | Items (old chance %) |
  |---|---|
  | Glubtok 47162 | 2169 (15), 5195 (16), 5444 (18) |
  | Helix 47296 | 5191 (9), 5199 (11), 5200 (9), 5443 (10) |
  | Foe Reaper 43778 | 1937 (13), 5187 (13), 5201 (14) |
  | Ripsnarl 47626 | 872 (15), 1156 (19), 5196 (14), 21524 (7) |
  | Cookie 47739 | 5192 (9), 5193 (15), 5197 (10), 5198 (12), 5202 (10) |

  Rare extras under 5% still roll on their own. The Cataclysm heroic items use loot mode 2, which this
  core never turns on, so they never drop. They are left as they were.

#### Core-wide: creatures reset after you die
- **Found:** when the last player died next to a boss, the boss stayed "engaged" by the corpse and never
  reset. Its encounter stayed in progress, which greyed out Release Spirit ("A member of your group is in
  combat"). It also kept pulling anyone who came back. HavenCore only reset a creature with no one left
  to fight if it had moved far from its spawn point.
- **Changed** in `src/server/game/AI/CreatureAI.cpp`, `CreatureAI::UpdateVictim()`. A creature with no
  target left now resets whether or not it is still in combat, the same as standard TrinityCore. This
  affects every creature in the game, not just Deadmines.
- **Status:** not confirmed separately in game. It needs a death next to a boss to show.

#### To pick up everything above
```
cd ~/bfa/source
git checkout -- .
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/bfa-linux-fixes.patch
git apply ../tools-repo/tools/bfa/profession-skill-sync.patch
git apply ../tools-repo/tools/bfa/deadmines-fixes.patch
cmake --build build -j"$(nproc)" && cmake --build build --target install
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_11_00_deadmines_mine_bunny_damage.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_11_01_deadmines_lumbering_oaf_helix.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_11_02_deadmines_boss_texts.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_11_03_deadmines_helix_sticky_bomb.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_11_04_deadmines_boss_loot.sql
```
Then restart `worldserver`. `git checkout -- .` discards any edits in `~/bfa/source` that didn't come
from these patches.
