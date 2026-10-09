#!/usr/bin/env bash
# Recreate a missing .build.info in an 8.3.7 (35662) client folder.
#
# The extractors open the client through CascLib, which only accepts a folder that has a
# .build.info next to Data/. Repacked clients often ship without it ("Error opening casc
# storage '<client>/Data': FILE_NOT_FOUND"). Everything it needs is still in Data/config:
#   - Build Key: the build config whose build-name is for 35662
#   - CDN Key:   the CDN config ("archives = ..."), the one whose archive indexes are in
#                Data/indices if there are several
# plus the product (wow), version and the client's text locale (from WTF/Config.wtf, or
# LOCALE=xxXX, default enUS).
#
# Usage: ./make_build_info.sh <client-folder>      (FORCE=1 overwrites an existing file)
set -euo pipefail

CLIENT=${1:?usage: make_build_info.sh <client-folder>}
BUILD=35662
VERSION=8.3.7.$BUILD
CONFIG="$CLIENT/Data/config"
OUT="$CLIENT/.build.info"

[ -d "$CONFIG" ] || { echo "error: $CONFIG not found; pass the folder that contains Data/" >&2; exit 1; }
if [ -e "$OUT" ] && [ "${FORCE:-0}" != 1 ]; then
    echo "error: $OUT already exists (FORCE=1 overwrites it)" >&2
    exit 1
fi

mapfile -t builds < <(grep -rlE "^build-name = .*$BUILD" "$CONFIG" | sort)
if [ "${#builds[@]}" -eq 0 ]; then
    echo "error: no build config for $BUILD in $CONFIG; this is not an 8.3.7 ($BUILD) client:" >&2
    grep -rh '^build-name' "$CONFIG" | sed 's/^/  /' >&2
    exit 1
fi
[ "${#builds[@]}" -eq 1 ] || echo "note: ${#builds[@]} build configs for $BUILD, using the first" >&2
build_key=$(basename "${builds[0]}")

# Pick the CDN config with the most archive indexes present locally.
cdn_key= best=-1
while IFS= read -r f; do
    have=0
    for a in $(sed -n 's/^archives = //p' "$f"); do
        [ -e "$CLIENT/Data/indices/$a.index" ] && have=$((have + 1))
    done
    if [ "$have" -gt "$best" ]; then best=$have; cdn_key=$(basename "$f"); fi
done < <(grep -rl '^archives = ' "$CONFIG" | sort)
[ -n "$cdn_key" ] || { echo "error: no CDN config (a file with 'archives = ') in $CONFIG" >&2; exit 1; }

locale=${LOCALE:-}
if [ -z "$locale" ] && [ -f "$CLIENT/WTF/Config.wtf" ]; then
    locale=$(sed -nE 's/^SET textLocale "([a-zA-Z]{4})".*/\1/p' "$CLIENT/WTF/Config.wtf" | head -1)
fi
locale=${locale:-enUS}
tags="Windows x86_64 US? acct-US? geoip-US? $locale speech?:Windows x86_64 US? acct-US? geoip-US? $locale text?"

{
    echo "Branch!STRING:0|Active!DEC:1|Build Key!HEX:16|CDN Key!HEX:16|Install Key!HEX:16|IM Size!DEC:4|CDN Path!STRING:0|CDN Hosts!STRING:0|CDN Servers!STRING:0|Tags!STRING:0|Armadillo!STRING:0|Last Activated!STRING:0|Version!STRING:0|Product!STRING:0"
    echo "us|1|$build_key|$cdn_key|||tpr/wow|||$tags|||$VERSION|wow"
} > "$OUT.tmp"
mv "$OUT.tmp" "$OUT"
echo "wrote $OUT: build config $build_key, CDN config $cdn_key ($best archive indexes found), locale $locale"
