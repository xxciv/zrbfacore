# Patch notes

Newest first. Each entry says what changed, the exact values and files it touches, and what you need
to do to pick it up (rebuild, restart, run SQL).

## 2026-10-11

### The Deadmines (map 36), Normal

All of these are in PR #8. Core changes are in `tools/bfa/deadmines-fixes.patch`, and world data
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
- **Not a bug:** the rideable Prototype Reaper (49208) is Heroic-only, as on retail. The burning Reapers
  and Watchers can't be ridden.
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
