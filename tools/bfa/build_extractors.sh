#!/usr/bin/env bash
# Build only the four client-data extractors (mapextractor, vmap4extractor, vmap4assembler,
# mmaps_generator) from a BFA-HavenCore checkout, without the servers.
#
# Boost, libstdc++ and libgcc are linked statically and the result is stripped, so the
# binaries only need glibc 2.38+ and zlib at run time and can be copied to any current
# x86-64 distribution (the ones in extractors/linux-x86_64 were made this way).
#
# Usage:
#   ./build_extractors.sh <source-dir> <output-dir>
#
# <source-dir> must have bfa-linux-fixes.patch applied (the script checks). The build goes
# to <source-dir>/build-extractors and takes about a minute on 4 cores.
set -euo pipefail

SRC=$(realpath "${1:?usage: build_extractors.sh <source-dir> <output-dir>}")
OUT=${2:?usage: build_extractors.sh <source-dir> <output-dir>}
PATCH="$(dirname "$(realpath "$0")")/bfa-linux-fixes.patch"
BUILD="$SRC/build-extractors"

if ! git -C "$SRC" apply --check -R "$PATCH" 2>/dev/null; then
    echo "error: $PATCH is not applied to $SRC (cd $SRC && git apply $PATCH)" >&2
    exit 1
fi

cmake -S "$SRC" -B "$BUILD" -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DSERVERS=0 -DTOOLS=1 -DSCRIPTS=none \
    -DBoost_USE_STATIC_LIBS=ON \
    -DCMAKE_EXE_LINKER_FLAGS="-static-libstdc++ -static-libgcc"
cmake --build "$BUILD" -j"$(nproc)"

mkdir -p "$OUT"
for tool in map_extractor/mapextractor vmap4_extractor/vmap4extractor \
            vmap4_assembler/vmap4assembler mmaps_generator/mmaps_generator; do
    install -m 755 -s "$BUILD/src/tools/$tool" "$OUT/"
done
(cd "$OUT" && sha256sum mapextractor vmap4extractor vmap4assembler mmaps_generator > SHA256SUMS)
echo "extractors written to $OUT:"
ls -l "$OUT"
