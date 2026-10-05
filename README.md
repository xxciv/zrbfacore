# zrbfacore

Notes and tools for running [BFA-HavenCore](https://github.com/HavenWoW/BFA-HavenCore), a World of
Warcraft: Battle for Azeroth 8.3.7 (build 35662) server emulator, on Debian 13.

- [`docs/bfa-havencore-debian13.md`](docs/bfa-havencore-debian13.md): building the core natively on
  Debian 13 with GCC 14 and MySQL 8.4, importing the databases, extracting client data, configuring
  and starting `bnetserver` and `worldserver`, and connecting a client.
- [`tools/bfa/bfa-linux-fixes.patch`](tools/bfa/bfa-linux-fixes.patch): the source fixes GCC 14 needs
  (upstream is built with MSVC).
- [`tools/bfa/install_databases.sh`](tools/bfa/install_databases.sh): imports the auth, characters,
  world and hotfixes dumps, plain, compressed or split.
- [`tools/bfa/configure.sh`](tools/bfa/configure.sh): writes `worldserver.conf` and `bnetserver.conf`
  for a Linux install.

The layout follows our Pandaria 5.4.8 build, [zrpandaria548](https://github.com/xxciv/zrpandaria548).
