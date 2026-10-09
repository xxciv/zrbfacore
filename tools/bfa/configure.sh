#!/usr/bin/env bash
# Write worldserver.conf and bnetserver.conf for a native Linux install of BFA-HavenCore.
#
# The shipped .conf.dist files are made for Windows: relative paths with backslashes
# (".\ClientData", ".\Logs"), root/admin database logins and no SQL source directory for
# the updater. This copies each .conf.dist to .conf and sets, in both files:
#   - the database logins (DB_HOST, DB_PORT, DB_USER, DB_PASS)
#   - LogsDir (absolute, created if missing)
#   - SourceDirectory and MySQLExecutable, so the updater can apply sql/updates
# and in worldserver.conf also DataDir. bnetserver's LoginREST addresses are set to
# REALM_ADDRESS when given (needed for game clients on other machines).
#
# Usage:
#   DB_USER=bfa DB_PASS='choose-a-password' ./configure.sh <server-prefix> <source-dir>
#   (optional: DB_HOST, DB_PORT, REALM_ADDRESS=192.168.x.x, FORCE=1 to overwrite .conf files)
#
# <server-prefix> is CMAKE_INSTALL_PREFIX from the build (it has bin/ and etc/).
set -euo pipefail

PREFIX=$(realpath "${1:?usage: configure.sh <server-prefix> <source-dir>}")
SRC=$(realpath "${2:?usage: configure.sh <server-prefix> <source-dir>}")
DB_HOST=${DB_HOST:-127.0.0.1}
DB_PORT=${DB_PORT:-3306}
DB_USER=${DB_USER:?set DB_USER}
DB_PASS=${DB_PASS:?set DB_PASS}
ETC="$PREFIX/etc"
DATA="$PREFIX/data"
LOGS="$PREFIX/logs"
MYSQL_BIN=$(command -v mysql || true)

[ -f "$ETC/worldserver.conf.dist" ] || { echo "error: $ETC/worldserver.conf.dist not found (run the install step first)" >&2; exit 1; }
[ -d "$SRC/sql/updates" ] || { echo "error: $SRC/sql/updates not found; <source-dir> must be the BFA-HavenCore checkout" >&2; exit 1; }
[ -n "$MYSQL_BIN" ] || { echo "error: the mysql client is not installed; the updater needs it" >&2; exit 1; }
case "$DB_PASS$DB_USER" in *[\;\"\#\&\\]*) echo "error: DB_USER/DB_PASS must not contain ; \" # & or \\" >&2; exit 1;; esac

mkdir -p "$DATA" "$LOGS"

# set_key <file> <key> <value>: replace the "Key = ..." line, keeping the file's layout
set_key() {
    grep -qE "^$2[[:space:]]*=" "$1" || { echo "error: $2 not found in $1" >&2; exit 1; }
    sed -i -E "s#^($2[[:space:]]*=).*#\1 \"$3\"#" "$1"
}

# db_info <database>: a connection string in the core's "host;port;user;password;database" form
db_info() { printf '%s;%s;%s;%s;%s' "$DB_HOST" "$DB_PORT" "$DB_USER" "$DB_PASS" "$1"; }

for service in worldserver bnetserver; do
    conf="$ETC/$service.conf"
    if [ -f "$conf" ] && [ "${FORCE:-0}" != "1" ]; then
        echo "keeping existing $conf (FORCE=1 overwrites it)"
        continue
    fi
    cp "$ETC/$service.conf.dist" "$conf"
    set_key "$conf" LoginDatabaseInfo "$(db_info bfa_auth)"
    set_key "$conf" LogsDir "$LOGS"
    set_key "$conf" SourceDirectory "$SRC"
    set_key "$conf" MySQLExecutable "$MYSQL_BIN"
    if [ "$service" = worldserver ]; then
        set_key "$conf" WorldDatabaseInfo "$(db_info bfa_world)"
        set_key "$conf" CharacterDatabaseInfo "$(db_info bfa_characters)"
        set_key "$conf" HotfixDatabaseInfo "$(db_info bfa_hotfixes)"
        set_key "$conf" DataDir "$DATA"
    elif [ -n "${REALM_ADDRESS:-}" ]; then
        sed -i -E "s#^(LoginREST\.ExternalAddress)[[:space:]]*=.*#\1 = $REALM_ADDRESS#" "$conf"
        sed -i -E "s#^(LoginREST\.LocalAddress)[[:space:]]*=.*#\1 = $REALM_ADDRESS#" "$conf"
    fi
    chmod 600 "$conf"
    echo "wrote $conf"
done
echo "DataDir: $DATA (put dbc, gt, cameras, maps, vmaps and mmaps here)"
