# zrbfacore

Notes and tools for running [BFA-HavenCore](https://github.com/HavenWoW/BFA-HavenCore), a World of
Warcraft: Battle for Azeroth 8.3.7 (build 35662) server emulator, on Debian 13.

- [`docs/bfa-havencore-debian13.md`](docs/bfa-havencore-debian13.md): building the core natively on
  Debian 13 with GCC 14 and MySQL 8.4, importing the databases, extracting client data, configuring
  and starting `bnetserver` and `worldserver`, and connecting a client.
- [`dumps/`](dumps): the auth, characters, world and hotfixes databases from upstream's "Databases"
  release, xz-compressed and split into parts under GitHub's file size limit.
- [`extractors/linux-x86_64`](extractors/README.md): prebuilt client-data extractors that run on any
  current x86-64 Linux, so data can be extracted on the machine with the client and copied to the server VM.
- [`tools/bfa/bfa-linux-fixes.patch`](tools/bfa/bfa-linux-fixes.patch): the source fixes GCC 14 needs
  (upstream is built with MSVC), plus a CMake fix for building the extractors on their own.
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

Status: verified end to end on a Debian 13 VM (build, databases, client data, login and entering the
world from another machine), 2026-10-09.

The layout follows our Pandaria 5.4.8 build, [zrpandaria548](https://github.com/xxciv/zrpandaria548).
