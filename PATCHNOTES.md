# Patch notes

Newest first. Each entry says what changed, the exact values and files it touches, and what you need
to do to pick it up (rebuild, restart, run SQL).

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
  Simplified: the archery target follows you instead of riding on you as a vehicle.
- **Status:** untested in game.

#### Starving and Angry Hounds, and the dog food buckets
- **Found:** the buckets of dog food did nothing and the Angry Hounds weren't chained.
- **Changed:** Starving Hounds (58876) are C++ now, Hungry Dog still capped at 4 seconds. Click a Bucket
  of Meaty Dog Food (65379), then throw it (out of combat) next to a Vigilant Watchman: he is pinned
  down and every hound within 20 yards turns on him, then sits down to eat. Angry Hounds (58674) are
  chained to their stakes and only attack when you come within 5 yards; they give up beyond 8.
- **Status:** untested in game.

#### Houndmaster Braun
- **Found** (reported by Four): melee, Death Blossom and Bloody Mess only; an easy fight.
- **Changed:** Piercing Throw every 7 to 9 seconds, Death Blossom as a leap that spins where it lands,
  one Obedient Hound called at 90, 80, 70 and 60%, Bloody Rage at 50%. At 15% his own hounds turn on
  him: he stops fighting, is eaten, and dies 12 to 15 seconds later with the kill credited to you. The
  hounds then run to his exit and kill the guards there.
- **Status:** untested in game.

#### Armsmaster Harlan
- **Found** (reported by Four): melee and Dragon's Reach only.
- **Changed:** Call for Help every 20 to 25 seconds (two Scarlet Defenders in Heavy Armor run in along
  the balconies; break the armor and they are Unarmored), Heroic Leap to the middle of the room
  followed by Blades of Light spinning round it (every second, damage to everyone within 8 yards), and
  Berserker Rage at 50%. Simplified: Blades of Light doesn't pick players up.
- **Status:** untested in game.

#### Flameweaver Koegler meleed too much
- **Found** (reported by Four): far too much melee for a caster, and Quickened Mind (113682) didn't make
  his casts instant. Its cast-time cut is a spell modifier, which only reaches player spell families.
- **Changed:** he casts back to back: Pyroblast, Fireball Volley every 13.5 seconds, and Book Burner on
  a book case (it burns and hurts anyone in front of him). Quickened Mind now gives him three instant
  casts. Every 30 seconds he teleports to the middle and channels Greater Dragon's Breath for 10
  seconds, a cone that sweeps round the room.
- **Status:** untested in game.

#### The Hooded Crusader never came for the codex
- **Changed:** the crusader outside the library stays hidden until Koegler dies, then walks in and asks
  for the codex.
- **Status:** untested in game.

#### Smaller things
- **Changed:** 22 yells and emotes for Braun, Harlan, Koegler, Lindon, the archery target and the
  crusader (none existed). Scarlet Treasurers drop a pile of Gold Coins. The Scarlet Cannons get their
  Cannoneers, who fire Cannon Blast at players in the courtyard.
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
```

## 2026-10-19

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
