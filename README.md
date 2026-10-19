# zrbfacore

Notes and tools for running [BFA-HavenCore](https://github.com/HavenWoW/BFA-HavenCore), a World of
Warcraft: Battle for Azeroth 8.3.7 (build 35662) server emulator, on Debian 13.

- [`PATCHNOTES.md`](PATCHNOTES.md): what each fix changed, with exact values and files, newest first.
- [`docs/bfa-havencore-debian13.md`](docs/bfa-havencore-debian13.md): building the core natively on
  Debian 13 with GCC 14 and MySQL 8.4, importing the databases, extracting client data, configuring
  and starting `bnetserver` and `worldserver`, and connecting a client.
- [`dumps/`](dumps): the auth, characters, world and hotfixes databases from upstream's "Databases"
  release, xz-compressed and split into parts under GitHub's file size limit.
- [`extractors/linux-x86_64`](extractors/README.md): prebuilt client-data extractors that run on any
  current x86-64 Linux, so data can be extracted on the machine with the client and copied to the server VM.
- [`tools/bfa/bfa-linux-fixes.patch`](tools/bfa/bfa-linux-fixes.patch): the source fixes GCC 14 needs
  (upstream is built with MSVC), plus a CMake fix for building the extractors on their own.
- [`tools/bfa/profession-skill-sync.patch`](tools/bfa/profession-skill-sync.patch): raises a profession's
  parent skill along with its expansion tier, so gathering nodes check the right skill.
- [`tools/bfa/deadmines-fixes.patch`](tools/bfa/deadmines-fixes.patch): The Deadmines fixes (trash AI,
  boss doors, Foe Reaper, Helix, Ripsnarl, Mine Bunny), plus a core fix so bosses reset after a wipe.
- [`sql/fixes/world`](sql/fixes/world): world database fixes, run in file-name order; the guide's step 10
  table says what each one does.
- [`tools/bfa/ragefire-fixes.patch`](tools/bfa/ragefire-fixes.patch): Ragefire Chasm fixes (rescuing
  the prisoners for No Man Left Behind / No Orc Left Behind).
- [`tools/bfa/shadowfang-fixes.patch`](tools/bfa/shadowfang-fixes.patch): Shadowfang Keep fixes (only
  your own faction's allies are shown, and they move forward as bosses die; Silverlaine and Springvale
  are saved as killed).
- [`tools/bfa/player-search.patch`](tools/bfa/player-search.patch): core fix so scripts that look for the
  nearest player (bosses, SmartAI "closest player" targets) actually find one.
- [`tools/bfa/stealth-pull.patch`](tools/bfa/stealth-pull.patch): core fix so a mob or boss pulled from
  stealth waits for you to reappear instead of evading.
- [`tools/bfa/random-target.patch`](tools/bfa/random-target.patch): core fix so bosses that cast at a
  random player (Lord Walden's mixtures, for one) can pick the player they are fighting.
- [`tools/bfa/transmog-collection.patch`](tools/bfa/transmog-collection.patch): learns transmog
  appearances as soon as items reach your bags, for every armor and weapon type (`Transmog.*` settings).
- [`tools/bfa/loot-fixes.patch`](tools/bfa/loot-fixes.patch): core fixes so items from shared
  loot tables (world drops, most greens) drop at all, every dungeon boss drops at least one item, and
  corpses can be skinned when they still hold a quest item you can't see.
- [`tools/bfa/scenario-debug.patch`](tools/bfa/scenario-debug.patch): adds the GM command
  `.debug scenario`, which lists the dungeon's scenario objectives, what each one waits for, and progress.
- [`tools/bfa/wailing-caverns-fixes.patch`](tools/bfa/wailing-caverns-fixes.patch): Wailing Caverns
  script fixes (Muyoh's escort credits the "Muyoh escorted" objective).
- [`tools/bfa/dungeon-scale-xp.patch`](tools/bfa/dungeon-scale-xp.patch): DungeonScale XP settings: no XP
  in a dungeon you've already completed in that mode, and an XP off switch for testing.
- [`tools/bfa/dungeon-boss-loot.patch`](tools/bfa/dungeon-boss-loot.patch): every boss a dungeon's
  objectives name gets the boss loot guarantee, not only the ones the world database lists.
- [`tools/bfa/blackfathom-layouts.patch`](tools/bfa/blackfathom-layouts.patch): Blackfathom Deeps in
  both layouts, the classic one and the redesign the Adventure Guide shows, picked per run by the
  Blackfathom Chronicler at the entrance (`Blackfathom.Layout` for the default). Needs
  `sql/fixes/world/2026_10_17_03_blackfathom_redesign_layout.sql`.
- [`tools/bfa/dungeon-spell-fixes.patch`](tools/bfa/dungeon-spell-fixes.patch): creature spells that did
  nothing: cone-by-entry targets (110) now select targets, and a generic script casts the spell a dummy
  effect names. Needs `sql/fixes/world/2026_10_18_01_blackfathom_redesign_spells.sql` for the
  Blackfathom Deeps spells.
- [`tools/bfa/dungeon-scale-quest-xp.patch`](tools/bfa/dungeon-scale-quest-xp.patch): the DungeonScale
  XP settings stop only kill XP; quests inside the dungeon still give XP.
- [`tools/bfa/dungeon-scale.patch`](tools/bfa/dungeon-scale.patch): scales 5-man dungeon mobs to the
  number of players inside, so one player can clear a dungeon (guide step 9, "Solo dungeons").
- [`tools/bfa/build_extractors.sh`](tools/bfa/build_extractors.sh): builds just the extractors, portably.
- [`tools/bfa/make_build_info.sh`](tools/bfa/make_build_info.sh): recreates a missing `.build.info` in
  a repacked 8.3.7 client so the extractors can open it.
- [`tools/bfa/install_databases.sh`](tools/bfa/install_databases.sh): imports the auth, characters,
  world and hotfixes dumps, plain, compressed or split.
- [`tools/bfa/configure.sh`](tools/bfa/configure.sh): writes `worldserver.conf` and `bnetserver.conf`
  for a Linux install.
- [`client/ZRProfessions`](client/ZRProfessions/README.md): a client addon that lets trainers teach up to 4
  primary professions (the 8.3.7 client UI stops at 2 even when the server allows more) and lists them all
  with `/profs`.
- [`tools/npc-designer`](tools/npc-designer/README.md): a desktop app for designing vendor NPCs (items,
  prices, model, faction) with a merchant window preview, exporting SQL for BFA, Pandaria 5.4.8 or WotLK 3.3.5.

Status: verified end to end on a Debian 13 VM (build, databases, client data, login and entering the
world from another machine), 2026-10-09.

The layout follows our Pandaria 5.4.8 build, [zrpandaria548](https://github.com/xxciv/zrpandaria548).
