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

## 10. Updating

```sh
cd ~/bfa/source
git apply -R ../tools-repo/tools/bfa/bfa-linux-fixes.patch    # undo the fixes before pulling
git pull
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/bfa-linux-fixes.patch
cmake --build build -j"$(nproc)" && cmake --build build --target install
```

Restart `worldserver`; it applies the new `sql/updates` files itself.

## 11. Status

| Step | State |
|---|---|
| 1-4: toolchain, MySQL 8.4, patch, compile, install (servers with and without `TOOLS`) | verified with GCC 14.2, Boost 1.83, CMake 3.31.6, MySQL 8.4.11 |
| 5: database import | verified with the dumps in `dumps/` (about 2 minutes) |
| 7: configuration, `sql/updates` applied by `worldserver` | verified: all 261 files apply without an error, then `worldserver` stops at the missing client data |
| `bnetserver` | verified: starts, lists the realm, serves login REST on 8081 |
| 6: client data | prebuilt extractors start on Debian 13 and Fedora 44; not run against a client, which this needs |
| 8-9: account creation, login with a client | not tested, needs the client data from step 6 |
