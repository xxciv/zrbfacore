# Client-data extractors (Linux x86-64)

Prebuilt `mapextractor`, `vmap4extractor`, `vmap4assembler` and `mmaps_generator` for
BFA-HavenCore, so the machine that holds the 8.3.7 client can extract data without building the
server. Copy the result to the server VM afterwards ([guide, step 6](../docs/bfa-havencore-debian13.md#6-client-data)).

| | |
|---|---|
| Source | [HavenWoW/BFA-HavenCore](https://github.com/HavenWoW/BFA-HavenCore) `9174dff97077` (2026-10-05) with [`tools/bfa/bfa-linux-fixes.patch`](../tools/bfa/bfa-linux-fixes.patch) |
| Built with | [`tools/bfa/build_extractors.sh`](../tools/bfa/build_extractors.sh): GCC 14.2, Boost 1.83, Release, stripped |
| Needs at run time | x86-64 Linux with glibc 2.38 or newer and zlib (Debian 13, Ubuntu 24.04, Fedora 39 and newer) |
| Checked on | Debian 13 and Fedora 44: all four start and report their usage; `mapextractor` stops at "Error opening casc storage" when run outside a client folder |

Boost, libstdc++ and libgcc are linked in, so nothing else needs installing. Check the files
after downloading with `sha256sum -c SHA256SUMS`.

The extractors are part of BFA-HavenCore and licensed GPL-3.0 like the core; the source is the
upstream commit above plus the patch in this repo. Rebuild them after a core update that touches
`src/tools` or the client data formats:

```sh
cd <BFA-HavenCore checkout> && git apply <zrbfacore>/tools/bfa/bfa-linux-fixes.patch
<zrbfacore>/tools/bfa/build_extractors.sh . <zrbfacore>/extractors/linux-x86_64
```
