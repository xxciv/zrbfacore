#!/usr/bin/env bash
# Create and fill the four BFA-HavenCore databases from the release dumps.
#
# The core's repo ships no base dumps (sql/base is gitignored). They are published as
# "Databases" releases on https://github.com/HavenWoW/BFA-HavenCore/releases (Mega links).
# Put the dumps in one folder (plain, compressed or split, see sql_stream below), then run:
#
#   export MYSQL_PWD='root-password'          # avoids a password prompt per file
#   MYSQL_ARGS="-u root" ./install_databases.sh /path/to/dump-folder
#
# The script finds one dump each for auth, characters, world and hotfixes (by name),
# imports it into bfa_auth / bfa_characters / bfa_world / bfa_hotfixes and prints row counts.
# It does not apply sql/updates: worldserver's own updater does that on first start, and
# records every file it applied in each database's `updates` table (see the guide, step 7).
#
# Database names default to the ones in the core's .conf.dist files; override with
# AUTH_DB, CHAR_DB, WORLD_DB, HOTFIX_DB. The script refuses to touch databases that
# already contain tables.
set -euo pipefail

DUMPS=${1:?usage: install_databases.sh /path/to/dump-folder}
AUTH_DB=${AUTH_DB:-bfa_auth}
CHAR_DB=${CHAR_DB:-bfa_characters}
WORLD_DB=${WORLD_DB:-bfa_world}
HOTFIX_DB=${HOTFIX_DB:-bfa_hotfixes}
read -r -a MYSQL_OPTS <<< "${MYSQL_ARGS:-}"
MYSQL=(mysql "${MYSQL_OPTS[@]}" --max-allowed-packet=1G)

[ -d "$DUMPS" ] || { echo "error: $DUMPS is not a folder" >&2; exit 1; }

# The dumps may be plain .sql or compressed (.sql.gz, .sql.xz, .sql.zst, .zip, .7z), and any
# of those may be split into parts (name.part-aa, name.part-ab, ... or name.001, name.002, ...)
# to stay under GitHub's 100 MB file limit.
part_re='\.(part-[a-z0-9]+|[0-9]{3})$'

# find_dump <pattern>: the one dump below DUMPS whose name contains pattern, printed as its
# logical name (without any part suffix)
find_dump() {
    local names
    mapfile -t names < <(find "$DUMPS" -type f -iname "*$1*" \
        | sed -E "s/$part_re//" \
        | grep -iE '\.(sql|sql\.gz|sql\.xz|sql\.zst|zip|7z)$' | sort -u)
    if [ "${#names[@]}" -ne 1 ]; then
        echo "error: expected exactly one $1 dump in $DUMPS, found ${#names[@]}:" >&2
        printf '  %s\n' "${names[@]}" >&2
        exit 1
    fi
    printf '%s\n' "${names[0]}"
}

# parts <logical name>: the file itself, or its parts in order
parts() {
    if [ -f "$1" ]; then
        printf '%s\0' "$1"
    else
        find "$(dirname "$1")" -maxdepth 1 -type f -print0 | grep -zE "^$(printf '%s' "$1" | sed 's/[][\.*^$/]/\\&/g')$part_re" | sort -z
    fi
}

# need <command> <package>: fail early with the Debian package to install
need() { command -v "$1" >/dev/null || { echo "error: $1 is not installed (apt install $2)" >&2; exit 1; }; }

# sql_stream <logical name>: the plain SQL on stdout
sql_stream() {
    local f=$1
    case "${f,,}" in
        *.sql)     parts "$f" | xargs -0 cat ;;
        *.sql.gz)  parts "$f" | xargs -0 cat | gzip -dc ;;
        *.sql.xz)  parts "$f" | xargs -0 cat | xz -dc ;;
        *.sql.zst) parts "$f" | xargs -0 cat | zstd -dc ;;
        *.zip|*.7z)
            # both formats need a seekable file, so join split parts first
            local whole=$f
            if [ ! -f "$f" ]; then
                whole="$tmp/$(basename "$f")"
                parts "$f" | xargs -0 cat > "$whole"
            fi
            case "${f,,}" in
                *.zip) unzip -p "$whole" '*.sql' ;;
                *)     7z x -so "$whole" '*.sql' ;;
            esac
            [ "$whole" = "$f" ] || rm -f "$whole" ;;
    esac
}

AUTH_SQL=$(find_dump auth)
CHAR_SQL=$(find_dump character)
WORLD_SQL=$(find_dump world)
HOTFIX_SQL=$(find_dump hotfix)

for f in "$AUTH_SQL" "$CHAR_SQL" "$WORLD_SQL" "$HOTFIX_SQL"; do
    [ -n "$(parts "$f" | tr -d '\0')" ] || { echo "error: no file or parts found for $f" >&2; exit 1; }
    case "${f,,}" in
        *.xz) need xz xz-utils ;; *.zst) need zstd zstd ;; *.zip) need unzip unzip ;; *.7z) need 7z 7zip ;;
    esac
done

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

for db in "$AUTH_DB" "$CHAR_DB" "$WORLD_DB" "$HOTFIX_DB"; do
    tables=$("${MYSQL[@]}" -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$db'")
    if [ "$tables" != "0" ]; then
        echo "error: database '$db' already has $tables tables; drop it or choose another name" >&2
        exit 1
    fi
done

# import <dump> <target database>
# The dumps may carry their own CREATE DATABASE / USE lines with other names; drop them so
# everything lands in the target database.
import() {
    echo ">>> $2 < ${1#"$DUMPS"/}"
    "${MYSQL[@]}" -e "CREATE DATABASE IF NOT EXISTS \`$2\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
    sql_stream "$1" | sed -E '/^CREATE DATABASE /d; /^USE `[^`]*`;/d' | "${MYSQL[@]}" "$2"
}

import "$AUTH_SQL" "$AUTH_DB"
import "$CHAR_SQL" "$CHAR_DB"
import "$HOTFIX_SQL" "$HOTFIX_DB"
import "$WORLD_SQL" "$WORLD_DB"

count() { "${MYSQL[@]}" -N -e "SELECT COUNT(*) FROM \`$1\`.\`$2\`" 2>/dev/null || echo "missing"; }
echo
for db in "$AUTH_DB" "$CHAR_DB" "$WORLD_DB" "$HOTFIX_DB"; do
    echo "$db: $("${MYSQL[@]}" -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$db'") tables"
done
echo "creatures: $(count "$WORLD_DB" creature), gameobjects: $(count "$WORLD_DB" gameobject)," \
     "realms: $(count "$AUTH_DB" realmlist)"
echo "Done. Start worldserver once to apply sql/updates (guide, step 7)."
