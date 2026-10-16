# Patch notes

Newest first. Each entry says what changed, the exact values and files it touches, and what you need
to do to pick it up (rebuild, restart, run SQL).

## 2026-10-16

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
- **Status:** builds here; not yet tested in game.

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
- **Status:** builds here (`LootMgr.cpp` and `Unit.cpp` compile); not yet tested in game. If a boss
  still drops only gold after this, the item is being lost after the loot is built, which would point to
  the real bug.

### To pick up the loot fixes
A new patch on its own, so the patches you already applied stay as they are. `LootMgr.h` is not in the
precompiled headers, so this should not be a full rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:tools/bfa/loot-fixes.patch | git apply
grep -c "item->groupid, player, specOnly" src/server/game/Loot/LootMgr.cpp
grep -c "AddItemIfNoneDropped" src/server/game/Entities/Unit/Unit.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
Both `grep` lines should print 1. Then restart `worldserver`. Once PR #14 is merged, `git -C ../tools-repo pull`
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
- **Status:** run here against the dump; not yet tested in game. Lords killed before the SQL ran aren't
  counted, so it needs a fresh instance.

### To pick up the Wailing Caverns fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_16_05_wailing_caverns_naralex_event.sql | mysql -u root -p bfa_world
```
Then restart `worldserver` and reset the instance (leave it, then Reset All Instances from your portrait
menu) before running it again.

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
