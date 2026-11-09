# Building BFA-HavenCore on Debian 13

Core: <https://github.com/HavenWoW/BFA-HavenCore> (GPL-3.0, Battle for Azeroth 8.3.7 build 35662,
a TrinityCore derivative).

This guide builds the core natively on a fresh Debian 13 (trixie) VM, imports its four databases,
prepares client data and starts the servers. Upstream documents Windows with Visual Studio 2022, plus an
experimental Docker build on Ubuntu 24.04 with GCC 13 that leaves the map extractors switched off.
Debian 13 ships GCC 14, CMake 3.31 and no MySQL, so a few steps differ. The layout follows our
[Pandaria 5.4.8 guide](https://github.com/xxciv/zrpandaria548/blob/main/docs/pandaria-debian13.md).

**What was verified, and how.** Every step up to the databases was reproduced with the toolchain
versions Debian 13 ships (GCC 14.2, Boost 1.83, CMake 3.31.6) against MySQL 8.4.11. The build ran on
an Ubuntu 24.04 host with those exact versions, because Debian's package mirrors weren't reachable from
the build machine. The core, the scripts and all four extractors compile with the fixes in step 3; the
dumps in this repo import cleanly; `worldserver` applies all 261 `sql/updates` files without an error
and then stops at the missing client data; `bnetserver` starts fully and serves the realm. Extracting
client data and logging in with a client need an 8.3.7 client and were not run (see
[step 11](#11-status)).

## 0. VM sizing

| | Minimum | Comfortable |
|---|---|---|
| CPU | 4 cores | 8 cores |
| RAM | 8 GB | 16 GB |
| Disk | 60 GB | 100 GB (source + build + databases + extracted client data) |

The full compile took 39 minutes on 4 cores with 16 GB RAM (`-j4`). The default `RelWithDebInfo`
build keeps debug information for crash backtraces, so it is big: the build directory reaches about
20 GB and `worldserver` alone is 2.1 GB. The client itself doesn't need to be on the VM: extraction
(step 6) runs on the machine that has it, which needs room for the client (about 60 GB) plus the
extracted data, and several hours for the movement maps.

## 1. Build tools and libraries

```sh
sudo apt update
sudo apt install -y git cmake ninja-build g++ tmux unzip xz-utils gnupg wget \
  libssl-dev libbz2-dev libreadline-dev libncurses-dev zlib1g-dev \
  libboost-dev libboost-filesystem-dev libboost-program-options-dev \
  libboost-regex-dev libboost-locale-dev
```

The project needs CMake 3.27 or newer (Debian 13 has 3.31.6), Boost 1.74 or newer (1.83),
OpenSSL 3 (3.5) and GCC 11 or newer (14.2). Those four Boost components are the ones the build asks for.

## 2. MySQL 8.4 LTS (not MariaDB)

Upstream requires MySQL 8.0 or newer and recommends 8.4. Debian 13 only packages MariaDB, so install
MySQL 8.4 LTS from Oracle's APT repository, the same way as for Pandaria. Don't install MariaDB packages
alongside it. Only MySQL was tested with this core.

1. Download the repository setup package `mysql-apt-config_*_all.deb` (0.8.36 or newer) from
   <https://dev.mysql.com/downloads/repo/apt/>.
2. Install it and select **mysql-8.4-lts** when asked:
   ```sh
   sudo dpkg -i mysql-apt-config_*_all.deb
   sudo apt update
   sudo apt install -y mysql-server libmysqlclient-dev
   ```
3. Server settings: a packet size big enough for the dumps, and the core's own expectation of a
   non-strict SQL mode (the same settings as upstream's Docker setup and our Pandaria server):
   ```sh
   sudo tee /etc/mysql/mysql.conf.d/bfa.cnf <<'EOF'
   [mysqld]
   sql_mode             = NO_ENGINE_SUBSTITUTION
   max_allowed_packet   = 1G
   wait_timeout         = 28800
   character-set-server = utf8mb4
   collation-server     = utf8mb4_unicode_ci
   EOF
   sudo systemctl restart mysql
   ```
4. A database user for the server, allowed on the four `bfa_*` databases. Oracle's installer asks for
   a MySQL root password; log in with it (`-p` prompts for it):
   ```sh
   mysql -u root -p -e "CREATE USER 'bfa'@'localhost' IDENTIFIED BY 'choose-a-password';
     GRANT ALL PRIVILEGES ON \`bfa\\_%\`.* TO 'bfa'@'localhost';"
   ```
   The updater in step 7 creates and alters tables, so the user needs full rights on those databases.

## 3. Source and fixes

```sh
mkdir -p ~/bfa && cd ~/bfa
git clone https://github.com/HavenWoW/BFA-HavenCore.git source
git clone -b main https://github.com/xxciv/zrbfacore.git tools-repo
cd source
git apply ../tools-repo/tools/bfa/bfa-linux-fixes.patch
git apply ../tools-repo/tools/bfa/profession-skill-sync.patch
git apply ../tools-repo/tools/bfa/deadmines-fixes.patch
git apply ../tools-repo/tools/bfa/dungeon-scale.patch
git apply ../tools-repo/tools/bfa/ragefire-fixes.patch
git apply ../tools-repo/tools/bfa/shadowfang-fixes.patch
git apply ../tools-repo/tools/bfa/player-search.patch
git apply ../tools-repo/tools/bfa/stealth-pull.patch
git apply ../tools-repo/tools/bfa/random-target.patch
git apply ../tools-repo/tools/bfa/transmog-collection.patch
git apply ../tools-repo/tools/bfa/loot-fixes.patch
git apply ../tools-repo/tools/bfa/scenario-debug.patch
git apply ../tools-repo/tools/bfa/wailing-caverns-fixes.patch
git apply ../tools-repo/tools/bfa/dungeon-scale-xp.patch
git apply ../tools-repo/tools/bfa/dungeon-boss-loot.patch
git apply ../tools-repo/tools/bfa/blackfathom-layouts.patch
git apply ../tools-repo/tools/bfa/dungeon-spell-fixes.patch
git apply ../tools-repo/tools/bfa/dungeon-scale-quest-xp.patch
git apply ../tools-repo/tools/bfa/spell-corrections.patch
git apply ../tools-repo/tools/bfa/open-lock-crash.patch
git apply ../tools-repo/tools/bfa/scarlet-halls.patch
git apply ../tools-repo/tools/bfa/scarlet-monastery.patch
git apply ../tools-repo/tools/bfa/battle-pet-slots.patch
git apply ../tools-repo/tools/bfa/battle-pet-journal.patch
git apply ../tools-repo/tools/bfa/battle-pet-player-flags.patch
git apply ../tools-repo/tools/bfa/battle-pet-level-achievements.patch
git apply ../tools-repo/tools/bfa/core-branding.patch
git apply ../tools-repo/tools/bfa/battle-pet-achievements.patch
git apply ../tools-repo/tools/bfa/battle-pet-trainers.patch
git apply ../tools-repo/tools/bfa/transmog-apply.patch
git apply ../tools-repo/tools/bfa/holiday-schedule.patch
git apply ../tools-repo/tools/bfa/darkmoon-faire-gossip.patch
git apply ../tools-repo/tools/bfa/darkmoon-race.patch
git apply ../tools-repo/tools/bfa/goober-quest-credit.patch
git apply ../tools-repo/tools/bfa/skinning-tiers.patch
git apply ../tools-repo/tools/bfa/gathering-tier-locks.patch
```

Upstream is built with MSVC, which accepts two things GCC 14 doesn't, and its CMake can't build the
extractors without the servers. The patch fixes exactly those, in four files:

| File | Fix |
|---|---|
| `dep/CascLib/src/common/Sockets.cpp` | keep `getaddrinfo`'s result as `int`: comparing it, as unsigned, with `case EAI_AGAIN:` (-3) is a narrowing error. This only breaks the extractors (`TOOLS=1`), which upstream's Docker build turns off. |
| `dep/CMakeLists.txt` | build `argon2` and `short_alloc` whenever `src/common` is built: `common` links both, but they were only added with the servers, so a tools-only build (`-DSERVERS=0 -DTOOLS=1`) failed |
| `src/server/scripts/BrokenIsles/boss_levantus.cpp` | include `CellImpl.h`, which defines `Cell::VisitAllObjects` |
| `src/server/scripts/Draenor/GrimrailDepot/grimrail_depot.cpp` | the same include |

Without the two script fixes everything compiles, but linking `worldserver` fails with
`undefined reference to Cell::VisitAllObjects<Trinity::UnitListSearcher<Trinity::AnyFriendlyUnitInObjectRangeCheck>>`.
MSVC finds a copy of that template elsewhere; GCC needs the definition in the file that uses it.

`profession-skill-sync.patch` is a gameplay fix, not a build fix. Since BFA every profession has a skill
per expansion (Classic Herbalism, Outland Herbalism, ...) under the profession's own skill (Herbalism).
Gathering and crafting raise the expansion skill, but the client checks herb and ore nodes against the
profession skill, which upstream only updates when a skill is set directly (training, `.setskill`). So
Herbalism stayed where it was trained while Classic Herbalism rose, and nodes stayed orange and then
refused ("Requires Herbalism 50" at Classic Herbalism 59). The patch updates the profession skill on
every skill-up too, in `Player::UpdateSkillPro` (`Player.cpp`). Verified in game: Herbalism now rises
with Classic Herbalism. The profession skill follows the highest of its expansion skills, not the one
that changed last: upstream copied whichever expansion skill was set last, so learning Cataclysm
Skinning (1/75) dropped Skinning to 1 and the server refused to skin anything (skinning is checked
against the profession skill too; fix verified in game). A character from before the patch catches up at its next skill-up,
or at once with `.setskill 182 <value> 300` (186 for Mining, 393 for Skinning), using the value of
its highest expansion skill. A lower expansion skill never lowers the profession skill: Classic
Inscription and Classic Engineering recipes raise the profession skill itself, so learning Cataclysm
Inscription at 1 would otherwise have reset Inscription to 1.

`skinning-tiers.patch` skins each beast with its own expansion's skill, as on retail 8.3.7, and skinning
it raises that skill. Upstream checked every beast against the profession skill (393) at 5 skill per
level and always raised Classic Skinning, so beasts above level 60 (400 and more for Cataclysm) could
never be skinned, and the expansion skills never moved. What each expansion needs now:

| Expansion | Skill (ID) | Beasts it covers | Skill needed by beast level |
|---|---|---|---|
| Classic | Classic Skinning (2564), max 300 | `HealthScalingExpansion` 0 and level 1-60 | unchanged: 1-10 any, 15: 50, 20: 100, 30: 150, 40: 200, 50: 250, 60: 300 (`(level-10)*10` below 100 skill, `level*5` from 100) |
| Outland | Outland Skinning (2563), max 75 | expansion 1, or level 61-70 | 58: 1, 60: 9, 62: 17, 64: 25, 66: 33, 68: 41, 70: 50 |
| Northrend | Northrend Skinning (2562), max 75 | expansion 2, or level 71-80 | 68: 1, 70: 9, 72: 17, 74: 25, 76: 33, 78: 41, 80: 50 |
| Cataclysm | Cataclysm Skinning (2561), max 75 | expansion 3, or level 81-85 | 80: 1, 81: 10, 82: 20, 83: 30, 84: 40, 85: 50 |
| Pandaria | Pandaria Skinning (2560), max 75 | expansion 4, or level 86-90 | 85: 1, 86: 10, 87: 20, 88: 30, 89: 40, 90: 50 |
| Draenor | Draenor Skinning (2559), max 100 | expansion 5, or level 91-100 | 90: 1, 92: 15, 94: 30, 96: 45, 98: 60, 100: 75 |
| Legion | Legion Skinning (2558), max 100 | expansion 6, or level 101-110 | 98: 1, 100: 13, 102: 25, 104: 38, 106: 50, 108: 62, 110: 75 |
| Kul Tiran | Kul Tiran Skinning (2557), max 150 | expansion 7, or level 111 and up | 110: 1, 112: 25, 114: 50, 116: 75, 118: 100, 120: 125 |

"Expansion N" is the creature's `creature_template.HealthScalingExpansion`. Many templates leave it at 0
whatever their level, so a 0 above level 60 picks the expansion by `minlevel` instead (the level ranges
in the third column). Outside those levels, a beast below its expansion's first level needs 1, and one above its
last level needs the same as the last level. For every expansion except Classic the requirement rises
evenly from 1 at the first level to the skill's max minus 25 at the last. The max is read from your
character, so the Draenor, Legion and Kul Tiran columns assume maxes of 100, 100 and 150; if your
character shows a different max, the top of the range is that max minus 25. Learning the
expansion's skill from a trainer is enough to start: with it at 1 you can skin that expansion's
lowest beasts.

The new code is in `src/server/game/Spells/SkinningTiers.h`, used by `Spell::CheckCast` (the check)
and `Spell::EffectSkinning` (the skill-up). Beasts skinned with Herbalism, Mining or Engineering are
unchanged.

Herb and ore nodes get the same treatment from `gathering-tier-locks.patch` and two SQL fixes. In the
8.3.7 `Lock.db2` almost every node from Outland to Legion uses the plain Herbalism or Mining lock with
the old 1-600 skill (Lichbloom 425, Twilight Jasmine 525, Golden Lotus 550), which the client checks
against the profession skill. That skill can't go above 300, so those nodes could never be gathered,
and gathering only raised Classic Herbalism and Mining. The same file has Blizzard's own lock for each
expansion's herbs (2856 Outland to 2861 Legion) and ore (2864 to 2869): the expansion's lock type, whose
gather spell the trainer teaches with the expansion skill, plus a plain Herbalism or Mining slot, both
with no skill number. Kul Tiran nodes, Cinderbloom, Rich Elementium and Blackrock already use them.
The world fix points 93 node templates at them, and the hotfix fix caps the two Classic ore locks that
asked for 305 and 310 at 300:

```sh
mysql -u root -p bfa_hotfixes < ~/bfa/tools-repo/sql/fixes/hotfixes/2026_11_08_00_gathering_tier_locks.sql
mysql -u root -p bfa_world < ~/bfa/tools-repo/sql/fixes/world/2026_11_08_00_gathering_tier_locks.sql
```

Then restart `worldserver` and delete the client's `Cache` folder (it keeps the old node data). The
patch does two things in the core:

- `Spell::CanOpenLock` (`Spell.cpp`) never opens a lock through its plain Herbalism or Mining slot when
  the lock also has an Outland to Kul Tiran slot, so Classic Herbalism or Mining alone can't gather
  expansion nodes; the client then says "Requires Northrend Herbalism" (or whichever expansion). The
  client uses the expansion's gather spell when you know it.
- `AuraEffect::HandleAuraTrackResources` (`SpellAuraEffects.cpp`): the client tracks an expansion node
  by its expansion lock type, so Find Herbs and Find Minerals now also mark Herbalism 32-39 and Mining
  40-47 (upstream marked only 2 and 3, and no expansion node showed on the minimap).

A node's expansion comes from where it spawns, and it needs only that expansion's skill learned. Each
gathering node also gets a difficulty, which sets its colour and how often it gives a skill-up: its old
skill scaled over the expansion's old range to 1 up to the expansion skill's max minus 25. The main
nodes' difficulty:

| Expansion | Herbs (difficulty) | Ore (difficulty) |
|---|---|---|
| Classic | unchanged | unchanged; Small/Large Obsidian Chunk and Arcanite Lode 300 (were 305 and 310) |
| Outland (Outland Herbalism/Mining) | Felweed, Dreaming Glory (most nodes), Terocone, Netherbloom, Nightmare Vine, Mana Thistle, Blindweed 1; Dreaming Glory (old 315) 10; Ragveil 17; Flame Cap 23; Ancient Lichen 27; Netherdust Bush 33 | Fel Iron, Adamantite, Rich Adamantite, Khorium, Nethercite 1; Ancient Gem Vein 50 |
| Northrend | Goldclover 1, Firethorn 5, Tiger Lily 13, Talandra's Rose 18, Adder's Tongue 25, Frozen Herb 25-32, Lichbloom 37, Icethorn 42, Frost Lotus 50 | Cobalt 1, Rich Cobalt 13, Saronite 25, Rich Saronite 37, Titanium and Pure Saronite 50 |
| Cataclysm | Cinderbloom (already per expansion, no requirement), Stormvine and Azshara's Veil 1, Heartblossom 25, Whiptail 37, Twilight Jasmine 50 | Obsidium 1, Rich Obsidium 13, Elementium 25, Pyrite and Rich Pyrite 50; Rich Elementium already per expansion, no requirement |
| Pandaria | Green Tea Leaf, Silkweed, Rain Poppy, Fool's Cap 1; Golden Lotus 25; Snow Lily and Sha-Touched Herb 37 | Ghost Iron, Kyparite, Trillium and their rich nodes 1 |
| Draenor | Frostweed, Fireweed, Gorgrond Flytrap, Starflower, Nagrand Arrowbloom, Talador Orchid 1 | True Iron, Rich True Iron, Rich Blackrock, Smoldering True Iron 1; Blackrock already per expansion, no requirement |
| Legion | Aethril, Dreamleaf, Foxflower, Fjarnskaggl, Starlight Rose, Felwort, Fel-Encrusted Herb 1 | Leystone, Felslate and their rich nodes and seams 1 |
| Kul Tiran | unchanged (already per expansion) | unchanged (already per expansion) |

Every one of these needs only its expansion's skill learned. Quest objects that also open without the
skill (by kneeling, or with a quest item) are left alone. The world fix lists every node, its old skill
and its new difficulty.

To learn the expansion skills you need a trainer that teaches them, and on this database none taught
Outland, Northrend, Pandaria, Draenor or Legion for any profession (only some taught Cataclysm). A third
world fix makes every trainer of a profession teach its Outland to Legion skills next to the Classic one
(10 copper each, needs the profession). Kul Tiran stays with the Kul Tiras and Zandalar trainers, and
fishing trainers already teach every expansion. It also points the herbalism trainers in Outland,
Northrend, both Dalarans and a few Classic towns at the herbalism list (they used a list that doesn't
exist, so they taught nothing), and Grix "Ironfists" Barlow at his own Kul Tiran blacksmithing list:

```sh
mysql -u root -p bfa_world < ~/bfa/tools-repo/sql/fixes/world/2026_11_09_00_profession_tier_trainers.sql
```

Then restart `worldserver`. The trainers only teach the skill itself: this database has no trainer
recipes for the Outland to Legion crafting skills, so those recipes come from recipe items only.

`deadmines-fixes.patch` collects the fixes for The Deadmines (map 36):

- Seven trash scripts in `boss_vanessa_vancleef.cpp` (Ogre Henchman, Defias Shadowguard, Defias
  Enforcer, Defias Envoker, Goblin Overseer, Defias Blood Wizard, and Oaf Lackey, which also runs
  Helix's Lumbering Oaf) never called `UpdateVictim()`. They went into combat but never picked a
  target, so they stood still and took hits. The patch adds the call. It also lets the Oaf's
  Enrage and the Overseer's Threatening fire at low health (both flags started out already used).
- The boss doors (Glubtok, Helix, Foe Reaper, and the Iron Clad Door once Ripsnarl is dead) now
  open again when they are re-created. Boss kills are saved, but upstream only opened a door at
  the moment its boss died, so after a `worldserver` restart, or once an empty area had unloaded,
  the doors were shut again behind dead bosses.
- Foe Reaper 5000 wakes up even when a Defias Reaper is killed in one hit. Each reaper is meant
  to stop at 10% health and energize him. The health check subtracted the hit from the reaper's
  health as an unsigned number, so a hit bigger than the remaining health wrapped around and
  killed the reaper outright, and Foe Reaper stayed asleep. He now wakes once every Defias Reaper
  and Defias Watcher in the room is disabled, instead of after any four of the six, which could
  start the fight with two reapers still attacking.
  He can't be hit before he wakes, so a stray hit can't pull him early and reset the reapers, and a
  burnt-out reaper or watcher drops out of combat instead of keeping players in it.
  Once awake he waits up to 5 minutes to be pulled (attack him or walk into his aggro range), so a
  solo player can recover first and a stealthed player doesn't make him reset on the spot. If nobody
  pulls him, he powers down and the four Defias Reapers come back.
- Foe Reaper 5000 chases his target the whole fight. He used to pick a target only during his
  abilities and stand still in between. Overdrive now lasts 10 seconds, during which he stops
  attacking and wanders the room spinning, as on retail. It used to never end. After Harvest he
  returns to his normal speed instead of crawling at 2 yards per second for the rest of the fight.
- Helix Gearbreaker no longer melees from the Lumbering Oaf's back (he swings every 0.5 s, on top
  of the Oaf's own hits). The Oaf lets a grabbed player go if its charge doesn't happen, instead of
  carrying them until the next grab. The Oaf only gets this script with
  `2026_10_11_01_deadmines_lumbering_oaf_helix.sql` below. After a wipe Helix walks home before
  he mounts a new Oaf, instead of mounting one halfway and never finishing his reset.
- Admiral Ripsnarl summons Vapors every 3.5 seconds only while he is hidden in the fog, then every
  12 seconds. Before, once the fog rolled in at 75% he summoned one every 3.5 seconds for the rest of
  the fight. He also comes back out of the fog once per vanish: when both his timer and the
  four-vapor count brought him back, his Swipe ran twice as often from then on.
- The Mine Bunnies' Drunken Haze keeps its 10-second snare and slow but no longer sets the player's
  drunk level to 100, which lasted about 15 minutes with no debuff shown. The script only takes
  effect with `2026_10_12_00_deadmines_mine_bunny_drunken_haze.sql` below.
- One fix is core-wide, in `CreatureAI.cpp`: a creature with no target left now resets even when
  its combat has already ended. When the last player died, combat ended but the creature stayed
  "engaged" next to the corpse. A boss then kept its encounter running, which greys out Release
  Spirit ("A member of your group is in combat") and keeps the boss pulling anyone who comes back.
  Upstream TrinityCore resets here too. HavenCore had narrowed it to creatures far from their spawn.

`dungeon-scale.patch` scales 5-man dungeon creatures to the number of players inside, so one player can
clear a dungeon built for five. Solo, trash has 30% of its health and deals 30% of its damage, bosses
35% (the final boss 40% health), rising in a straight line to stock values at 5 players. No single hit
from a scaled creature takes more than 35% of your max health. It is ZRPandaria's DungeonScale, ported
without its honor rewards; set it up with "Solo dungeons" in step 9. Core files touched:
`ScriptMgr.h` / `ScriptMgr.cpp` (a new `AllCreatureScript` hook type: creature added, removed, level
set), `Creature.cpp` (calls the three hooks), `solocraft.cpp` (the scaling script, added at the end of
the file so the patch creates no new files), `custom_script_loader.cpp` (registers it) and
`worldserver.conf.dist` (the `DungeonScale.*` settings). `ScriptMgr.h` is in the precompiled headers,
so applying it rebuilds nearly everything.

`ragefire-fixes.patch` collects the fixes for Ragefire Chasm (map 389). For No Man Left Behind and No
Orc Left Behind, only the prisoners behind the Suspicious Rock and in the Inconspicuous Crate could be
rescued, plus the three caged beside Lava Guard Gordoth if their cage could be clicked. The others
couldn't be selected at all, so the quest could stop short of 5. Every SI:7 Ranger and Kor'kron Scout
that isn't hidden behind the rock or the crate can now be rescued by talking to it, and a caged one
opens its cage on the way out. It only takes effect with
`2026_10_15_00_ragefire_rescue_prisoners.sql` below.

`shadowfang-fixes.patch` collects the fixes for Shadowfang Keep (map 33). The keep has an Alliance
version of its allies (Packleader Ivar Bloodfang and his worgen) and a Horde version (Deathstalker
Commander Belmont and the Forsaken), with one copy for every stage of the run, and the database spawns
all of them at once. The instance script now shows only the copies for the team in the instance and the
bosses already killed, and keeps the rest out of sight. Baron Silverlaine and Commander Springvale were
never saved as killed, which this also fixes. It only takes effect with
`2026_10_15_01_shadowfang_faction_troops.sql` below.

`player-search.patch` fixes `WorldObject::SelectNearestPlayer` and `SelectNearestPlayers` in `Object.cpp`.
They searched only the part of the map grid that holds creatures and objects, so they never found a
player; about 170 scripts use them. It now searches the player part, as upstream TrinityCore does.

`stealth-pull.patch` builds on the `CreatureAI::UpdateVictim` change in `deadmines-fixes.patch`, so apply it
after that one. A mob can't see a stealthed player behind it, so after an opener from stealth (with
Subterfuge, stealth lasts 3 more seconds) it had no target it could attack and evaded at once. It now
waits while a living player who has threat on it is only hidden from it. Vanish wipes that threat, so
vanishing still resets the fight.

`random-target.patch` fixes `UnitAI::DoCastRandom`, which scripts use to cast at a random player. It
passed its aura filter where `SelectTarget` expects "include the tank", so the player a boss was fighting
was never picked. Solo, that means those spells were never cast.

`loot-fixes.patch` fixes loot tables that point to a shared reference table (world drops, most
green items, many boss and chest tables). `LootTemplate::Process` handed the referenced table on without
the looter, and `Loot::AddItem` throws away an item with no looter, so nothing from a reference ever
dropped. About 2,740 creature loot tables use one. The same patch makes every dungeon and raid boss drop
at least one item: when the normal rolls leave a boss with only gold (or only cloth and junk), one item
from its own table is added, picked by drop chance. It also lets a corpse be skinned once you've
taken everything you can see: an item hidden from you (a quest item for a quest you don't have) used to
keep the corpse from ever counting as looted.

`dungeon-boss-loot.patch` widens "boss" for that guarantee. The world database only lists some dungeons'
bosses (`instance_encounters`; Blackfathom Deeps and Ragefire Chasm have none), so a creature also
counts when the dungeon's scenario has an objective to kill it once ("Lady Anacondra defeated", and
optional bosses such as Kresh).

`blackfathom-layouts.patch` gives Blackfathom Deeps both of its layouts. The world database spawns the
classic one (Lady Sarevess, Gelihast, Twilight Lord Kelris...), while the client's Adventure Guide and
dungeon objectives describe the 6.0.2 redesign (Domina, Thruk, Twilight Lord Bathiel...). With
`sql/fixes/world/2026_10_17_03_blackfathom_redesign_layout.sql` both are spawned, and the instance shows
one: `Blackfathom.Layout` in `worldserver.conf` picks it for new instances (1, the redesign, by default),
and the Blackfathom Chronicler just inside the entrance switches it until the first boss of the run dies.
Either way, the bosses count for the dungeon's objectives.

`dungeon-spell-fixes.patch` makes two kinds of creature spells work that did nothing. Spells aimed with a
cone by entry (target 110) never picked a target, because the core's selection for them was commented
out; they now pick the caster's enemies in a cone, or what the spell's conditions name. And spells
whose dummy effect names the spell to cast (Piercing Rain, Foul Tempest and others in Blackfathom Deeps)
get `spell_gen_dummy_cast_base_points`, through
`sql/fixes/world/2026_10_18_01_blackfathom_redesign_spells.sql`.

`scenario-debug.patch` adds a GM command, `.debug scenario`. Dungeons in this client run a scenario:
the objective list on the right of the screen (Wailing Caverns has "Muyoh escorted", for one). Its steps
and criteria live in the client's db2 files, not the world database. Typed inside a dungeon, the command
lists each step, its criteria, what each one waits for (criteria type and the creature, event or spell
id) and the group's progress, so a missing credit can be traced. It changes nothing in game.

`scarlet-halls.patch` ports the Pandaria 5.4.8 Scarlet Halls scripts: the instance script (boss states,
doors, the Hooded Crusader who comes for the codex), Commander Lindon's archery hall, the kennel
hounds and buckets of dog food, and the three bosses. It needs
`sql/fixes/world/2026_10_23_05_scarlet_halls_rework.sql`, which brings in the spawns the dungeon was
missing and binds the scripts.

`scarlet-monastery.patch` does the same for Scarlet Monastery: the graveyard trash (Piles of Corpses,
Zombified Corpses, Centurions, Flamethrowers and their clickable Fuel Tanks), the Zealots, Thalnos,
Korloff, and Durand with Whitemane. It also adds the quest credit for the Blades of the Anointed, and
replaces the classic Headless Horseman script (map 189, which this client no longer has) with the
Monastery graveyard version: during Hallow's End the Pumpkin Shrine there summons him. It needs
`sql/fixes/world/2026_10_24_03_scarlet_monastery_rework.sql`, which swaps in the Pandaria spawns,
`2026_10_24_04_scarlet_monastery_fuel_tank_burning_man.sql`, `2026_10_24_05_headless_horseman.sql` and
`2026_10_24_06_scarlet_fuel_tank_encounters.sql`.

`wailing-caverns-fixes.patch` makes Muyoh's escort send the scenario event (582) behind the "Muyoh
escorted" objective when she reaches Naralex. The rest of the Wailing Caverns fixes are SQL, under
`sql/fixes/world` (see PATCHNOTES.md).

`transmog-collection.patch` makes transmog appearances collectable at all: upstream refuses every
item that has no row in `ItemSearchName.db2`, and with this client's data that is every item. It also
changes when appearances are learned. Stock 8.3.7 rules only
learn an appearance once the item is soulbound (so a Bind on Equip item has to be equipped first) and
only for armor and weapons the current character can wear at its current level. With the patch, an
appearance is learned as soon as the item reaches your bags or bank, from any source, for every armor
and weapon type. Items already in your bags and bank are learned at the next login. Appearances are
account wide, so an alt of the right class can use what another character picked up. Each part can be
switched back to stock with the `Transmog.*` settings (step 9, "Transmog collection"). Core files
touched: `CollectionMgr.cpp`, `Player.cpp` (`MoveItemToInventory`, for mail, trade, guild bank and
buyback), `World.h` / `World.cpp` (the three settings), `cs_debug.cpp` (`.debug transmog <item> [learn]`, which
says why an item isn't collected) and `worldserver.conf.dist`. `World.h` is in the
precompiled headers, so applying it rebuilds nearly everything.

`transmog-apply.patch` goes with it. Applying a transmog refused the whole request without a word when
one chosen appearance came from an item the character couldn't use, including one above the character's
level, which `transmog-collection.patch` now lets you collect. The check now follows the same
`Transmog.*` settings, and every refusal prints `Transmogrify refused: <reason>` in chat. It only touches
`TransmogrificationHandler.cpp` and needs `transmog-collection.patch` applied first.

If `git apply` reports that a patch doesn't apply, upstream has changed one of those files. Check
whether it already contains the fix before applying the rest by hand.

## 4. Configure and compile

```sh
cd ~/bfa/source
cmake -S . -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_INSTALL_PREFIX=$HOME/bfa/server \
  -DSCRIPTS=static -DTOOLS=0
cmake --build build -j"$(nproc)"
cmake --build build --target install
```

Run the compile inside `tmux` so it survives a dropped SSH session. If the machine runs out of memory,
use fewer jobs (`-j2`). In-source builds are blocked, hence the separate `build` folder.

`-DTOOLS=0` leaves out the client-data extractors: they run on the machine that has the client, and
this repo ships them prebuilt (step 6). Set `-DTOOLS=1` to build them on the VM as well.

Afterwards `~/bfa/server/bin` holds `worldserver`, `bnetserver` and the TLS certificate `bnetserver`
uses (`bnetserver.cert.pem`, `bnetserver.key.pem`). `~/bfa/server/etc` holds the two `.conf.dist` templates.

To save about 2 GB of disk you can `strip ~/bfa/server/bin/worldserver`, at the cost of readable crash
backtraces. `-DCMAKE_BUILD_TYPE=Release` builds without debug information from the start.

## 5. Databases

Upstream's repo ships no base dumps (`sql/base/` is gitignored); they are published as "Databases"
releases on its GitHub releases page, as Mega downloads. This repo carries a copy in
[`dumps/`](../dumps), xz-compressed and split into parts under GitHub's file size limit, so the
`tools-repo` clone from step 3 already has them. `tools/bfa/install_databases.sh` finds each of the
four dumps (auth, characters, world, hotfixes) by name and imports it:

```sh
export MYSQL_PWD='your-mysql-root-password'
MYSQL_ARGS="-u root" ~/bfa/tools-repo/tools/bfa/install_databases.sh ~/bfa/tools-repo/dumps
unset MYSQL_PWD
```

The installer reads plain `.sql`, compressed dumps (`.sql.gz`, `.sql.xz`, `.sql.zst`, `.zip`, `.7z`)
and split ones (`name.part-aa`, `name.part-ab`, ... or `name.001`, `name.002`, ...), so a newer
upstream release can be used the same way: put its four dumps in a folder and pass that folder.

It creates `bfa_auth`, `bfa_characters`, `bfa_world` and `bfa_hotfixes` (the names in the
`.conf.dist` files), refuses to touch any of them that already holds tables, and prints the table and
row counts at the end. With this repo's dumps the import takes about two minutes and ends with:

```
bfa_auth: 32 tables
bfa_characters: 146 tables
bfa_world: 246 tables
bfa_hotfixes: 378 tables
creatures: 467547, gameobjects: 171503, realms: 1
```

It does **not** apply `sql/updates`: `worldserver` does that itself on first
start (step 7) and records each file in the database's `updates` table, so the import can't drift out
of step with what the updater thinks is applied.

## 6. Client data

The server needs `dbc`, `gt`, `cameras`, `maps`, `vmaps` and (optionally) `mmaps` extracted from an
**8.3.7 (35662)** client. Extraction runs wherever the client is, not on the server VM: this repo
ships the four extractors prebuilt in [`extractors/linux-x86_64`](../extractors), and they run on any
current x86-64 Linux (glibc 2.38 or newer, for example Fedora 39+, Debian 13, Ubuntu 24.04) with
nothing else installed. On the machine with the client:

```sh
git clone https://github.com/xxciv/zrbfacore.git ~/zrbfacore
X=~/zrbfacore/extractors/linux-x86_64
(cd "$X" && sha256sum -c SHA256SUMS)

cd ~/wow-837-client                                # the folder with Data/ and _retail_/
"$X"/mapextractor                                  # dbc/ gt/ cameras/ maps/
"$X"/vmap4extractor                                # Buildings/
mkdir -p vmaps && "$X"/vmap4assembler Buildings vmaps
mkdir -p mmaps && "$X"/mmaps_generator --threads "$(nproc)"   # several hours
```

If `mapextractor` stops with `Error opening casc storage '<client>/Data': FILE_NOT_FOUND`, the client
has no `.build.info` next to `Data/` (common in repacked clients). Recreate it from the client's own
`Data/config` files, then run the extractors again:

```sh
~/zrbfacore/tools/bfa/make_build_info.sh ~/wow-837-client
```

It also stops if the client isn't build 35662, and lists the build it found instead.

`mmaps` are optional but creatures path badly without them. `Buildings/` is only an intermediate
step for `vmaps` and can be deleted afterwards. Copy the results to the VM's `DataDir` (created by
step 7's script; create it by hand if you copy first):

```sh
ssh you@192.168.x.x mkdir -p bfa/server/data
rsync -a --info=progress2 dbc gt cameras maps vmaps mmaps you@192.168.x.x:bfa/server/data/
```

To build the extractors yourself instead, apply the patch to a BFA-HavenCore checkout and run
`tools/bfa/build_extractors.sh <checkout> <output-dir>`; it builds only the tools (about a minute on
4 cores) and links them the same portable way. A Windows build of the upstream tools works too.

## 7. Configuration and first start

`tools/bfa/configure.sh` writes both `.conf` files from the templates. The shipped templates are made
for Windows (`DataDir = ".\ClientData"`; on Linux a backslash is part of a file name, not a separator)
and log in as `root`/`admin`. The script sets the database logins, absolute `DataDir` and `LogsDir`,
and `SourceDirectory` plus `MySQLExecutable`, which the updater needs to apply `sql/updates`:

```sh
DB_USER=bfa DB_PASS='choose-a-password' REALM_ADDRESS=192.168.x.x \
  ~/bfa/tools-repo/tools/bfa/configure.sh ~/bfa/server ~/bfa/source
```

`REALM_ADDRESS` is the VM's LAN address; leave it out if clients only connect from the VM itself. The
script keeps existing `.conf` files unless you pass `FORCE=1`.

Run it as the user that will run the servers, not with `sudo`. The `.conf` files hold the database
password, so the script makes them readable by their owner only; written by root, they make
`worldserver` start only under `sudo` and look empty in an editor started without it. If that already
happened, `sudo chown -R $USER: ~/bfa/server` hands everything back. The resulting files are
`~/bfa/server/etc/worldserver.conf` and `bnetserver.conf`; everything else in them stays at upstream's
defaults.

One upstream default to know about: `DisableWaterBreath = 1` means any account with GM level 1 or
higher never runs out of breath, and gets no breath bar under water. To test with normal breath on a GM
account, set it to 4 (nobody is exempt) and restart:
`sed -i 's/^DisableWaterBreath *= *[0-9]*/DisableWaterBreath = 4/' ~/bfa/server/etc/worldserver.conf`.

Start `worldserver` once on its own, in `tmux`, and let it bring the databases up to date:

```sh
cd ~/bfa/server/bin
./worldserver
```

It applies every file under `sql/updates/{auth,characters,world,hotfixes}` that the dumps don't record
as applied (`Updates.EnableDatabases = 15`), then loads the world. The dumps in this repo record none,
so the first start applies all of them: 2 auth, 255 world and 3 hotfixes files, and the characters
file, in about 20 seconds, all without an error. Later starts only apply files that are new since. With
client data in place the start ends with `World initialized`; without it, it stops right after the
updates with `Map file '.../maps/0000_43_31.map' does not exist!`.

Each update logs `mysql: [Warning] Using a password on the command line interface can be insecure.`
as an error. That is harmless: the updater passes the password to the `mysql` client on its command
line.

**If it exits right after a line like `Database Auth is empty, auto populating it...`** with no error
on screen, read `~/bfa/server/logs/Errors.log`. The console doesn't always print the last error before
the process exits; the log file does. "Base file ... is missing" means that database is still empty
(step 5 was skipped or failed); "Applying of file ... failed" names an update that didn't apply.

## 8. Realm address, ports and the first account

The realm list in `bfa_auth.realmlist` ships with `127.0.0.1`. For clients on other machines, set the
VM's LAN address:

```sh
mysql -u root -p -e "UPDATE bfa_auth.realmlist SET address = '192.168.x.x', localAddress = '192.168.x.x' WHERE id = 1;"
```

`worldserver` reads this row only when it starts, while `bnetserver` re-reads it every few seconds. If
`worldserver` is still running from step 7, stop it (`server shutdown 1` at its console) and start it
again after the change. Otherwise login and character select use the new address, but Enter World
still sends the client to `127.0.0.1` and fails with "World server is down". `localSubnetMask` only
matters when `address` and `localAddress` differ.

Start both servers, each in its own `tmux` window:

```sh
cd ~/bfa/server/bin
./bnetserver
./worldserver
```

This core logs in through Battle.net accounts. At the `worldserver` console, create one; the name
must look like an e-mail address:

```
bnetaccount create me@example.com mypassword
account set gmlevel 1#1 3 -1
```

`bnetaccount create` also creates the linked game account and prints its name (`1#1` for the first
one); that is the name `account set gmlevel` takes. The plain `account create` from older cores
doesn't exist here.

Open these TCP ports if the VM has a firewall:

| Port | Server | Use |
|---|---|---|
| 1119 | bnetserver | Battle.net login |
| 8081 | bnetserver | login REST (the client's login page) |
| 8085 | worldserver | realm and character select |
| 8086 | worldserver | entering the world; without it the client says "World server is down" after character select |

To keep `worldserver` running after a crash or a `.server restart`, start it from a loop, still inside
`tmux` so the console stays usable:

```sh
cd ~/bfa/server/bin
while true; do ./worldserver; echo "worldserver exited ($?), restarting in 10s (Ctrl-C to stop)"; sleep 10; done
```

## 9. Client

An 8.3.7 (35662) client only talks to a private server through a launcher that redirects its login.
TrinityCore-based 8.3.7 servers are commonly used with the Arctium game launcher. It's an executable
from a third party, so scan it before running it. Repacked clients often ship an executable that is
already patched (for example `WoW Circle.exe`); that one logs in and enters the world on this core
without any launcher. Point the client at the server in
`_retail_/WTF/Config.wtf`:

```
SET portal "192.168.x.x"
```

### More than 2 primary professions

To let characters learn up to 4 primary professions, set `MaxPrimaryTradeSkill = 4` in
`~/bfa/server/etc/worldserver.conf` and restart `worldserver`. Each player also needs the
[ZRProfessions](../client/ZRProfessions/README.md) addon: the client greys out **Train** once 2 professions
are known, whatever the server allows, and its Professions tab only shows 2. The addon re-enables
**Train** and adds a `/profs` panel listing every primary profession (verified in game 2026-10-10).

### Solo dungeons (DungeonScale)

`dungeon-scale.patch` (step 3) installs its settings into `~/bfa/server/etc/worldserver.conf.dist`. Copy
them into `worldserver.conf` once, and turn Solocraft off, since it buffs players on top of mobs that are
already scaled down:

```sh
grep -q '^DungeonScale.Enable' ~/bfa/server/etc/worldserver.conf || sed -n '/^# DUNGEON SCALE$/,$p' ~/bfa/server/etc/worldserver.conf.dist >> ~/bfa/server/etc/worldserver.conf
sed -i 's/^\(Solocraft\.Enable *= *\)1/\10/' ~/bfa/server/etc/worldserver.conf
```

Then restart `worldserver`. Its log shows `[DungeonScale] Loaded config: ENABLED`. Inside a dungeon,
`.dungeonscale info` shows the multipliers in use and `.dungeonscale creature` shows them for the
selected creature. The settings are explained in the block itself. A dungeon of its own can be made
easier or harder with lines like `DungeonScale.Map.36.Damage = 0.25` (36 is The Deadmines), then
`.reload config`.

`dungeon-scale-xp.patch` adds two XP settings. `DungeonScale.XP.StopAfterCompletion` (on unless set to
0) stops kill XP inside a scaled dungeon once you have that dungeon's achievement for the mode you are in
("The Deadmines" for Normal), even while you are still in its level range.
`DungeonScale.XP.Enable = 0` stops kill XP inside every scaled instance, for testing. Quests still give
XP either way (`dungeon-scale-quest-xp.patch`; before it, both settings stopped quest XP too). Neither key needs to be
in `worldserver.conf`; add a line only to change one, then `.reload config`. `.dungeonscale info` says
whether you get XP there, and which achievements count as completing the dungeon.

### Transmog collection

`transmog-collection.patch` (step 3) is on without any settings. To see or change them, copy its block
from `worldserver.conf.dist` into `worldserver.conf` once:

```sh
grep -q '^Transmog.CollectOnPickup' ~/bfa/server/etc/worldserver.conf || sed -n '/^# TRANSMOG COLLECTION$/,/^####/p' ~/bfa/server/etc/worldserver.conf.dist >> ~/bfa/server/etc/worldserver.conf
```

Set a value to 0 for stock 8.3.7 behavior, then `.reload config` or restart `worldserver`.

### Pet battles

Learn Battle Pet Training from a Battle Pet Trainer (for example in Stormwind or Orgrimmar) to open
the first battle slot. The battle pet patches in step 3 fix the slot unlock, journal summons (pets
appear as themselves instead of Murkimus the Gladiator) and releasing pets.

The core never swaps critters for battle pets at runtime, so out of the box only the battle pets
spawned directly in the world DB exist, and many zones have none of the species a pet tracker addon
lists for them. Run this once after the world DB is installed and updated (after the first
`worldserver` start), then restart `worldserver`:

```sh
mysql -u root -p bfa_world < ~/bfa/tools-repo/sql/fixes/world/2026_11_01_50_wild_battle_pet_spawns.sql
```

It turns critter spawns into their battle pet version per `battlepet_wild_zone_pool`, up to each
zone's cap (about 5,900 spawns in 86 zones), and records every change in
`zr_wild_battlepet_conversion` so it can be undone (see the file's header). Running it again changes
nothing.

Pet tamers (Julia Stevens, Marcus Jensen and the other trainers with a team in
`battlepet_npc_team_member`) offer **Let's do battle!** in their dialog while you have their "defeat
<tamer> in a pet battle" quest. Winning completes that objective. Without the quest the option does
not appear, as on retail.

Most tamers have their team standing next to them, often several pets on one spot. This makes those
pets wander within 2 yards of their spawn instead (run once, then restart `worldserver`):

```sh
mysql -u root -p bfa_world < ~/bfa/tools-repo/sql/fixes/world/2026_11_02_51_pet_tamer_display_pets_wander.sql
```

Wild pet levels follow the zone (the range a pet tracker map shows), except for 30 wild pet types
whose template forced level 5 or allowed up to 25 (for example every Elwynn Fawn was level 5). This
sets them to follow their zone too (run once, then restart `worldserver`):

```sh
mysql -u root -p bfa_world < ~/bfa/tools-repo/sql/fixes/world/2026_11_04_50_wild_battle_pet_zone_levels.sql
```

Darkmoon Island had no Crows to battle (only 2 critter crows). This adds the island's crow flocks
with 10 battle Crows and removes a capturable copy of the drop-only Darkmoon Rabbit:

```sh
mysql -u root -p bfa_world < ~/bfa/tools-repo/sql/fixes/world/2026_11_07_50_darkmoon_island_wild_pets.sql
```

Display pets next to vendors and tamers (for example Lhara's on Darkmoon Island) show up as wild
battle pets, because `battlepet_info` lists every species by creature entry. This keeps only
capturable species as wild battle pets:

```sh
mysql -u root -p bfa_world < ~/bfa/tools-repo/sql/fixes/world/2026_11_07_51_battle_pets_only_capturable_are_wild.sql
```
#### Legion and BFA pet tamers

Pet tamers start a battle from a "Let's do battle!" gossip option while you have their quest
(`battle-pet-trainers.patch`). The world DB had no team for the 23 Legion and BFA tamers and no spawn
for 7 of them. Run these once (one line at a time), then restart `worldserver`:

```sh
mysql -u root -p bfa_world < ~/bfa/tools-repo/sql/fixes/world/2026_11_02_60_legion_bfa_tamer_teams.sql
```
```sh
mysql -u root -p bfa_world < ~/bfa/tools-repo/sql/fixes/world/2026_11_02_61_legion_bfa_tamer_spawns.sql
```

The first adds 69 team pets (level 25; rare for BFA, epic or legendary for the Legion ones). The
second spawns Captain Hermes, Fizzie Sparkwhistle, Kwint, Korval Darkbeard, Crysa, Environeer Bert and
Algalon, and gives the five that had none the gossip flag. The Shipwrecked Captive (98489) still has
no spawn. Their world quests follow the normal rotation; to test one now, use
`.quest add <quest id>` (Kwint is 52430), then right-click the tamer. If the client shows the talk
cursor but nothing opens, you are probably more than about 5 yards away (easy underwater).

## 10. Updating

```sh
cd ~/bfa/source
git checkout -- .  # undo the patches before pulling
git pull
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/bfa-linux-fixes.patch
git apply ../tools-repo/tools/bfa/profession-skill-sync.patch
git apply ../tools-repo/tools/bfa/deadmines-fixes.patch
git apply ../tools-repo/tools/bfa/dungeon-scale.patch
git apply ../tools-repo/tools/bfa/ragefire-fixes.patch
git apply ../tools-repo/tools/bfa/shadowfang-fixes.patch
git apply ../tools-repo/tools/bfa/player-search.patch
git apply ../tools-repo/tools/bfa/stealth-pull.patch
git apply ../tools-repo/tools/bfa/random-target.patch
git apply ../tools-repo/tools/bfa/transmog-collection.patch
git apply ../tools-repo/tools/bfa/loot-fixes.patch
git apply ../tools-repo/tools/bfa/scenario-debug.patch
git apply ../tools-repo/tools/bfa/wailing-caverns-fixes.patch
git apply ../tools-repo/tools/bfa/dungeon-scale-xp.patch
git apply ../tools-repo/tools/bfa/dungeon-boss-loot.patch
git apply ../tools-repo/tools/bfa/blackfathom-layouts.patch
git apply ../tools-repo/tools/bfa/dungeon-spell-fixes.patch
git apply ../tools-repo/tools/bfa/dungeon-scale-quest-xp.patch
git apply ../tools-repo/tools/bfa/spell-corrections.patch
git apply ../tools-repo/tools/bfa/open-lock-crash.patch
git apply ../tools-repo/tools/bfa/scarlet-halls.patch
git apply ../tools-repo/tools/bfa/scarlet-monastery.patch
git apply ../tools-repo/tools/bfa/battle-pet-slots.patch
git apply ../tools-repo/tools/bfa/battle-pet-journal.patch
git apply ../tools-repo/tools/bfa/battle-pet-player-flags.patch
git apply ../tools-repo/tools/bfa/battle-pet-level-achievements.patch
git apply ../tools-repo/tools/bfa/core-branding.patch
git apply ../tools-repo/tools/bfa/battle-pet-achievements.patch
git apply ../tools-repo/tools/bfa/battle-pet-trainers.patch
git apply ../tools-repo/tools/bfa/transmog-apply.patch
git apply ../tools-repo/tools/bfa/holiday-schedule.patch
git apply ../tools-repo/tools/bfa/darkmoon-faire-gossip.patch
git apply ../tools-repo/tools/bfa/darkmoon-race.patch
git apply ../tools-repo/tools/bfa/goober-quest-credit.patch
git apply ../tools-repo/tools/bfa/skinning-tiers.patch
git apply ../tools-repo/tools/bfa/gathering-tier-locks.patch
cmake --build build -j"$(nproc)" && cmake --build build --target install
```

When an update adds a source file (`scarlet-halls.patch` adds `scarlet_halls.cpp`, `scarlet-monastery.patch` adds four), run `cmake build`
once before building: CMake only finds new files when it configures, and the link fails with an
`undefined reference` otherwise. It keeps the settings you configured with.

`git checkout -- .` throws away every change to upstream's files, so keep your own edits somewhere else.
`git apply -R` would only work if the patch hadn't changed since it was applied, and the pull may have
changed it.

Restart `worldserver`; it applies the new `sql/updates` files itself.

This repo also carries fixes for wrong world data, under `sql/fixes/world`. They are written against
the database as it is after `worldserver` has applied upstream's `sql/updates` (step 7), not against
the raw dump, and `worldserver` doesn't apply them itself. Run each one yourself (it is safe to run
twice) and restart `worldserver`, which reads most world tables only at startup:

```sh
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_10_00_bandage_trainers.sql
```

| File | Fixes |
|---|---|
| `2026_10_10_00_bandage_trainers.sql` | Alliance bandage trainers such as Byancie in Dolanaar offering the Engineering apprentice spell (verified in game 2026-10-10) |
| `2026_10_10_01_fishing_trainers.sql` | Fishing trainers such as Astaia in Darnassus teaching Fishing without the skill, so it shows as known but can't be used (verified in game 2026-10-10) |
| `2026_10_11_00_deadmines_mine_bunny_damage.sql` | The two Mine Bunnies in The Deadmines hitting for about 1,700 at level 15 (raid-boss damage modifier) |
| `2026_10_11_01_deadmines_lumbering_oaf_helix.sql` | Helix's Lumbering Oaf running the trash Oaf Lackey AI, so it never grabs or charges (its script was on an unrelated Kalimdor Oaf, which now gets its own AI back), and Helix's melee lowered from 57.5 to 12 |
| `2026_10_11_02_deadmines_boss_texts.sql` | The Deadmines bosses (Glubtok, Helix, the Lumbering Oaf, Foe Reaper 5000, Admiral Ripsnarl) saying nothing: their yells were missing |
| `2026_10_11_03_deadmines_helix_sticky_bomb.sql` | Helix never throwing his Sticky Bombs: his Throw Bomb spell was bound to a Winter Veil quest script that cancels the cast |
| `2026_10_11_04_deadmines_boss_loot.sql` | The Deadmines bosses often dropping only gold on Normal: each item rolled on its own at 9-19%. Now each boss drops one of its usual items every kill |
| `2026_10_12_00_deadmines_mine_bunny_drunken_haze.sql` | The Mine Bunnies in The Deadmines leaving players fully drunk for about 15 minutes, with no debuff shown, after one Drunken Haze. Binds the spell script from `deadmines-fixes.patch` that keeps the 10-second snare and slow |
| `2026_10_12_01_deadmines_heroic_vanessa_event_spawns.sql` | Vanessa VanCleef's Heroic-only nightmare event spawning on Normal too: its Vanessas kept players in combat (no logout) and a ghostly Ripsnarl stood outside the ship door. Its 21 spawns become Heroic-only |
| `2026_10_15_00_ragefire_rescue_prisoners.sql` | Ragefire Chasm's No Man Left Behind / No Orc Left Behind stopping short of 5: binds `npc_rfc_prisoner` from `ragefire-fixes.patch` to the SI:7 Rangers and Kor'kron Scouts and removes their unused SmartAI |
| `2026_10_15_01_shadowfang_faction_troops.sql` | Shadowfang Keep showing both factions' allies at once (Belmont and Forsaken corpses hostile to Alliance players at the door): puts the 237 Alliance, Horde and disease-cloud spawns in spawn groups 412-432 that `shadowfang-fixes.patch` shows by team and boss progress, and stops every Forsaken lying dead and every Belmont being stealthed |
| `2026_10_15_02_shadowfang_stone_sleepers.sql` | Shadowfang Keep's Stone Sleepers on the wall walk never waking: they now wake and attack when a player comes within 15 yards |
| `2026_10_16_01_shadowfang_lesser_gargoyles.sql` | Shadowfang Keep's Lesser Gargoyles on the wall walk never attacking: they were flagged as civilians |
| `2026_10_16_02_shadowfang_godfrey_text.sql` | Typos in Lord Godfrey's aggro and death yells |
| `2026_11_03_20_holiday_emote_casts.sql` | Day of the Dead: `/dance` with Catrina gave no skeleton and no Dead Man's Party achievement (verified in game 2026-11-03). Winter Veil: `/kiss` on a Winter Reveler gave no Mistletoe (same cause, not tested yet). Both NPCs' emote spells had no target |
| `2026_11_04_00_darkmoon_faire_first_sunday.sql` | The Darkmoon Faire starting on a different weekday every month (a fixed 30-day cycle). It now opens on the first Sunday of each month for 7 days, as on retail. Needs `holiday-schedule.patch` built first, or `worldserver` crashes on start |
| `2026_11_05_00_holiday_dates_schedule.sql` | Lunar Festival, Pilgrim's Bounty and the 4th of July fireworks never running (they ended in 2020), and Noblegarden drifting away from Easter. These holidays and Love is in the Air, Children's Week and Harvest Festival now run on the dates of their holiday (the same dates the calendar shows). Needs `holiday-schedule.patch` and the hotfix file below |
| `2026_11_05_01_darkmoon_fire_juggler_torches.sql` | Darkmoon Faire Fire Jugglers throwing their torches at players and nearby NPCs: the torch spell had no condition saying it targets Fire Jugglers |
| `2026_11_05_02_darkmoon_portal_back.sql` | Darkmoon Island's Portal Back hanging the client on the loading screen: it teleported Alliance players to Elwynn and Mulgore at once |
| `2026_11_05_03_darkmoon_race_course_hidden.sql` | Darkmoon Island's strider race course (checkpoint arches, power-up crates, tripwire posts) standing on every path for everyone: despawned in spawn group 450 until the race is scripted |
| `2026_11_05_04_darkmoon_faire_npcs.sql` | Darkmoon Faire: Selina Dourman not talking (missing gossip), the paired Fire Jugglers not throwing to each other, and the Alliance/Horde citizens and children being attackable |
| `2026_11_05_05_darkmoon_race_course.sql` | Darkmoon Island strider races: brings the race course back (undoes `2026_11_05_03`) and shows it only to players in a race. Needs `darkmoon-race.patch` |
| `2026_11_05_06_darkmoon_strider_ride.sql` | "Dusty" Brandom at the Darkmoon Island arrival hill not talking, and his Darkmoon Striders not giving the free ride to the Faire |
| `2026_11_05_07_darkmoon_race_names_and_game_prize.sql` | Race course bunnies showing their names. Delete the client's Cache folder afterwards. (Its Game Prize ticket row is undone by `_08`) |
| `2026_11_05_08_darkmoon_prize_ticket_as_quest_reward.sql` | Darkmoon Game Prize hanging the client: the Darkmoon Prize Ticket is now a currency reward of the Faire game and race quests |
| `2026_11_06_00_darkmoon_faire_npc_audit.sql` | Darkmoon Faire NPC audit: missing gossip texts (Silas, Jessica Rogers, Mola, game instructions), Ziggie Sparks menu, Christoph VonFeasel gossip flag, deprecated Chronos quest removed, old Terokkar Faire spawns removed (copies kept in `zr_dmf_terokkar_*`) |
| `2026_11_06_01_darkmoon_ring_toss.sql` | Darkmoon Faire Ring Toss: rings only hit Dubenko the turtle; his duplicate SAI credit removed |
| `2026_11_06_02_darkmoon_booth_spell_focus.sql` | Darkmoon Faire Ring Toss and Shooting Gallery: spawns the booth spell focus objects the game spells require |
| `2026_11_06_03_darkmoon_tonk_commander.sql` | Darkmoon Faire Tonk Commander: tonk cannon targets, quest credit for targets and enemy tonks, enemy tonks stay passive and respawn in 10 s |
| `2026_11_06_04_darkmoon_dubenko_wanders.sql` | Darkmoon Faire Ring Toss: Dubenko (54490) wanders up to 3 yards in his pen instead of standing still |
| `2026_11_06_05_darkmoon_firebird_rings.sql` | Darkmoon Faire Firebird's Challenge: Summon Rings script name and ring areatrigger 3069 (needs darkmoon-faire-gossip.patch) |
| `2026_11_06_06_darkmoon_horde_citizens.sql` | Darkmoon Faire Horde Citizens (55348) use orc, troll, blood elf and Forsaken models instead of Stormwind humans |
| `2026_11_06_07_darkmoon_champions_aggro.sql` | Darkmoon Faire Champions Faesrol (55732) and Isimode (55733) only attack hostile players within 5 yards |
| `2026_11_06_08_darkmoon_game_targets.sql` | Darkmoon Faire: Shooting Gallery and Tonk targets spawn alive, Shoot (101872) and tonk Cannon (102292) script names (needs darkmoon-faire-gossip.patch) |
| `2026_11_06_09_darkmoon_tauren_chieftains.sql` | Darkmoon Faire Tauren Chieftains: show loops every 5 minutes, constant "Armor" spell sound removed |
| `2026_11_06_10_darkmoon_balloon_cart.sql` | Darkmoon Faire Carl Goodup carries his balloon cart and balloons (vehicle accessories), wanders 5 yards |
| `2026_11_06_11_darkmoon_tonk_cannonballs.sql` | Darkmoon Faire Tonk Commander: enemy tonks and MiniZeps fire cannonballs (needs darkmoon-faire-gossip.patch) |
| `2026_11_06_12_darkmoon_concert_sync.sql` | Darkmoon Faire Tauren Chieftains follow the FX Controller (the song), controller respawns after 30 s (replaces the `_09` loop) |
| `2026_11_06_13_darkmoon_balloon_cart_spellclick.sql` | Darkmoon Faire Carl Goodup: spellclick rows so his cart accessories load (needs `_10`) |
| `2026_11_06_14_darkmoon_gallery_names_balloons.sql` | Darkmoon Faire: no names over the Shooting Gallery targets; Carl Goodup's balloons sit on his cart (after `_13`) |
| `2026_11_06_15_darkmoon_names_rings_balloons.sql` | Darkmoon Faire: Shooting Gallery names hidden by flags, Firebird rings keep coming, Carl's balloons back on the bunny 1 yd up (after `_14`, needs the gossip patch) |
| `2026_11_06_16_darkmoon_gallery_unselectable.sql` | Darkmoon Faire: Shooting Gallery targets not selectable, so no names over them |
| `2026_11_06_17_darkmoon_quest_items.sql` | Darkmoon Faire: Salty Sea Dog fishing, Staked Skins, Darkmoon Treasure Chest (Pit Fighter) placed (Grisly Trophies come from the gossip patch) |
| `2026_11_06_18_darkmoon_island_fishing.sql` | Darkmoon Island fishing loot from Wowhead's list (Darkmoon Daggermaw and the rest; after `_17`) |
| `2026_11_06_19_darkmoon_fishing_containers.sql` | Contents for the Sealed Darkmoon Crate and the Darkwater, Big-Mouth and Jaggal Clams |
| `2026_11_06_20_darkmoon_profession_quests_skill.sql` | Darkmoon Faire profession quests need 1 skill point instead of 75 |
| `2026_11_06_21_darkmoon_concert_fireworks.sql` | Darkmoon Faire concert: Darkmoon Firework at the five moments that cast an invisible Rain of Fire |
| `2026_11_06_22_darkmoon_deathmatch_chest_exit.sql` | Darkmoon Faire Deathmatch: looting the treasure chest teleports everyone in the pit back out to Korgol |
| `2026_11_07_00_darkmoon_race_course_float.sql` | Darkmoon races: course banners, pads and posts stay at their spawn height instead of sinking under water |
| `2026_11_07_01_darkmoon_race_tripwire_wires.sql` | Darkmoon races: tripwire stakes use the new stake script (wired pairs with a visible beam; needs the race patch) |
| `2026_11_07_02_darkmoon_race_repeatables.sql` | Darkmoon races: Let's Keep Racing! and More Big Racing! can be repeated |
| `2026_11_07_03_darkmoon_race_turn_in_text.sql` | Darkmoon races: turn-in text for the five race quests |
| `2026_11_07_04_darkmoon_race_names_token_vendors.sql` | Darkmoon Faire: race arch and camp post names hidden; empty token bags off the Game Token vendors |
| `2026_11_07_05_darkmoon_token_vendors_one_pair.sql` | Darkmoon Faire: token vendors sell only the 60s pouch and the 1g 92s sack (after `_04`) |
| `2026_11_07_06_darkmoon_carousel_empty.sql` | Darkmoon Faire: carousel rides removed, the platform spins empty |
| `2026_11_07_30_darkmoon_island_rares.sql` | Darkmoon Island rares: Darkmoon Rabbit spawned (its pet always drops, no solo-lethal bite), Moonfang gets her fight and always drops one of her items, Death Metal Knight spawned in the Cauldron of Rock with his sword; all three are elites that scale with your level (verified in game 2026-11-07) |

Hotfix fixes live in `sql/fixes/hotfixes` and run against `bfa_hotfixes` the same way (`mysql -u root -p bfa_hotfixes < file`). `2026_11_04_00_darkmoon_faire_calendar.sql` puts the Darkmoon Faire back on the in-game calendar (the client's own dates end in 2020) for the Faires of November 2026 to December 2028. `2026_11_05_00_holiday_calendar_dates.sql` does the same for Lunar Festival, Love is in the Air, Noblegarden, Children's Week, Harvest Festival and Pilgrim's Bounty (2026 to 2030). `2026_11_06_00_darkmoon_balloon_cart_seat.sql` moves Carl Goodup's Balloon Cart one foot further in front of him (VehicleSeat 10236). `2026_11_08_00_gathering_tier_locks.sql` adds the per-expansion herb and ore locks (section 3, with its world fix of the same name, and `2026_11_09_00_profession_tier_trainers.sql` lets trainers teach the expansion skills).

## 11. Status

| Step | State |
|---|---|
| 1-4: toolchain, MySQL 8.4, patch, compile, install (servers with and without `TOOLS`) | verified with GCC 14.2, Boost 1.83, CMake 3.31.6, MySQL 8.4.11 |
| 5: database import | verified with the dumps in `dumps/` (about 2 minutes) |
| 7: configuration, `sql/updates` applied by `worldserver` | verified: all 261 files apply without an error, then `worldserver` stops at the missing client data |
| `bnetserver` | verified: starts, lists the realm, serves login REST on 8081 |
| 6: client data | verified: the prebuilt extractors ran on Fedora against a WoWCircle 8.3.7 repack (after `make_build_info.sh`), and the result was copied to the VM |
| 7-8: full start, realm address, account creation | verified on a Debian 13 VM: `worldserver` reaches `World initialized`, `bnetaccount create` works |
| 9: login, character select, entering the world | verified 2026-10-09 with the repack's own `WoW Circle.exe` from another machine on the LAN, no launcher |
