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
the build machine. The core, the scripts and all four extractors compile with the fixes in step 3, and
`bnetserver` and `worldserver` start, read their configs, connect to MySQL 8.4 and stop where the
databases are still empty. Importing the dumps, extracting client data and logging in with a client
are covered below but were not run on the build machine (see [step 11](#11-status)).

## 0. VM sizing

| | Minimum | Comfortable |
|---|---|---|
| CPU | 4 cores | 8 cores |
| RAM | 8 GB | 16 GB |
| Disk | 80 GB | 150 GB (source + build + client copy + extracted data) |

The full compile took 39 minutes on 4 cores with 16 GB RAM (`-j4`). The default `RelWithDebInfo`
build keeps debug information for crash backtraces, so it is big: the build directory reaches about
20 GB and `worldserver` alone is 2.1 GB. The 8.3.7 client is about 60 GB, and generating movement
maps (step 6) takes several hours.

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
git clone https://github.com/xxciv/zrbfacore.git tools-repo
cd source
git apply ../tools-repo/tools/bfa/bfa-linux-fixes.patch
```

Upstream is built with MSVC, which accepts two things GCC 14 doesn't. The patch fixes exactly those,
in three files:

| File | Fix |
|---|---|
| `dep/CascLib/src/common/Sockets.cpp` | keep `getaddrinfo`'s result as `int`: comparing it, as unsigned, with `case EAI_AGAIN:` (-3) is a narrowing error. This only breaks the extractors (`TOOLS=1`), which upstream's Docker build turns off. |
| `src/server/scripts/BrokenIsles/boss_levantus.cpp` | include `CellImpl.h`, which defines `Cell::VisitAllObjects` |
| `src/server/scripts/Draenor/GrimrailDepot/grimrail_depot.cpp` | the same include |

Without the two script fixes everything compiles, but linking `worldserver` fails with
`undefined reference to Cell::VisitAllObjects<Trinity::UnitListSearcher<Trinity::AnyFriendlyUnitInObjectRangeCheck>>`.
MSVC finds a copy of that template elsewhere; GCC needs the definition in the file that uses it.

If `git apply` reports that a patch doesn't apply, upstream has changed one of those files. Check
whether it already contains the fix before applying the rest by hand.

## 4. Configure and compile

```sh
cd ~/bfa/source
cmake -S . -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_INSTALL_PREFIX=$HOME/bfa/server \
  -DSCRIPTS=static -DTOOLS=1
cmake --build build -j"$(nproc)"
cmake --build build --target install
```

Run the compile inside `tmux` so it survives a dropped SSH session. If the machine runs out of memory,
use fewer jobs (`-j2`). In-source builds are blocked, hence the separate `build` folder.

Afterwards `~/bfa/server/bin` holds `worldserver`, `bnetserver`, the extractors (`mapextractor`,
`vmap4extractor`, `vmap4assembler`, `mmaps_generator`) and the TLS certificate `bnetserver` uses
(`bnetserver.cert.pem`, `bnetserver.key.pem`). `~/bfa/server/etc` holds the two `.conf.dist` templates.

To save about 2 GB of disk you can `strip ~/bfa/server/bin/worldserver`, at the cost of readable crash
backtraces. `-DCMAKE_BUILD_TYPE=Release` builds without debug information from the start.

## 5. Databases

The repo ships no base dumps (`sql/base/` is gitignored). They are published as "Databases" releases
on upstream's GitHub releases page, as Mega downloads. Put the four dumps (auth, characters, world,
hotfixes) in one folder; `tools/bfa/install_databases.sh` finds each one by name and imports it. The
dumps can be plain `.sql`, compressed (`.sql.gz`, `.sql.xz`, `.sql.zst`, `.zip`, `.7z`) or split into
parts (`name.part-aa`, `name.part-ab`, ... or `name.001`, `name.002`, ...).

```sh
export MYSQL_PWD='your-mysql-root-password'
MYSQL_ARGS="-u root" ~/bfa/tools-repo/tools/bfa/install_databases.sh ~/bfa/dumps
unset MYSQL_PWD
```

It creates `bfa_auth`, `bfa_characters`, `bfa_world` and `bfa_hotfixes` (the names in the
`.conf.dist` files), refuses to touch any of them that already holds tables, and prints the table and
row counts at the end. It does **not** apply `sql/updates`: `worldserver` does that itself on first
start (step 7) and records each file in the database's `updates` table, so the import can't drift out
of step with what the updater thinks is applied.

## 6. Client data

The server needs `dbc`, `gt`, `cameras`, `maps`, `vmaps` and (optionally) `mmaps` extracted from an
**8.3.7 (35662)** client. Copy the client folder (the one with `Data/` and `_retail_/`) to the VM,
then run the extractors from inside it:

```sh
cd ~/wow-837-client
~/bfa/server/bin/mapextractor                      # dbc/ gt/ cameras/ maps/
~/bfa/server/bin/vmap4extractor                    # Buildings/
mkdir -p vmaps && ~/bfa/server/bin/vmap4assembler Buildings vmaps
mkdir -p mmaps && ~/bfa/server/bin/mmaps_generator --threads "$(nproc)"   # several hours
mkdir -p ~/bfa/server/data
mv dbc gt cameras maps vmaps mmaps ~/bfa/server/data/
```

`mmaps` are optional but creatures path badly without them. Extracting on a Windows machine with the
upstream build and copying the folders over works too.

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
script keeps existing `.conf` files unless you pass `FORCE=1`. The resulting files are
`~/bfa/server/etc/worldserver.conf` and `bnetserver.conf`; everything else in them stays at upstream's
defaults.

Start `worldserver` once on its own, in `tmux`, and let it bring the databases up to date:

```sh
cd ~/bfa/server/bin
./worldserver
```

It applies every file under `sql/updates/{auth,characters,world,hotfixes}` that the dumps don't record
as applied (`Updates.EnableDatabases = 15`), then loads the world. A first start takes a couple of
minutes and ends with `World initialized`.

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
from a third party, so scan it before running it. Point the client at the server in
`_retail_/WTF/Config.wtf`:

```
SET portal "192.168.x.x"
```

## 10. Updating

```sh
cd ~/bfa/source
git checkout -- dep/CascLib/src/common/Sockets.cpp src/server/scripts/BrokenIsles/boss_levantus.cpp \
  src/server/scripts/Draenor/GrimrailDepot/grimrail_depot.cpp
git pull
git apply ../tools-repo/tools/bfa/bfa-linux-fixes.patch
cmake --build build -j"$(nproc)" && cmake --build build --target install
```

Restart `worldserver`; it applies the new `sql/updates` files itself.

## 11. Status

| Step | State |
|---|---|
| 1-4: toolchain, MySQL 8.4, patch, compile, install | verified with GCC 14.2, Boost 1.83, CMake 3.31.6, MySQL 8.4.11 |
| `bnetserver`, `worldserver` start and connect to MySQL | verified; both stop at the empty databases, as expected without dumps |
| 5: database import | the installer is tested on small sample dumps; not yet run on the real dumps |
| 6: client data | extractors build and start; not run against a client |
| 7: `sql/updates` applied by `worldserver` | not yet run on the real dumps |
| 8-9: login with a client | not tested |
