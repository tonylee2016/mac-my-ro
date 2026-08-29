# Wine Corresponding Source

`mac-my-ro.app` distributes Wine and vkd3d under the GNU LGPL 2.1 or
later. The application code, product packaging, certificate operations,
and release process are separate and are not part of this build recipe.

## Source

The Wine runtime is based on CodeWeavers' published CrossOver 26.3.0
FOSS source archive:

```text
crossover-sources-26.3.0.tar.gz
SHA-256 ac99c8ca4b3848f3e81784135f023df266b61c2345726ea55a50b3e030dd6872
```

Official download:

<https://media.codeweavers.com/pub/crossover/source/crossover-sources-26.3.0.tar.gz>

The three project modifications are in [`patches/`](patches). Their exact
hashes are recorded in [`SOURCE-SHA256SUMS`](SOURCE-SHA256SUMS).

### What the shipped build actually contains

Be precise about this, because it is the corresponding-source claim.

Of the Wine modules in `mac-my-ro.app`, exactly **two files** are built
from source by this project:

```text
lib/wine/i386-windows/ntdll.dll
lib/wine/x86_64-windows/ntdll.dll
```

They are built from the archive above with
`crossover-26.3-unix-ntload-driver.patch` applied, then Authenticode
signed and timestamped. Every other Wine module in the application is
CodeWeavers' own binary from their published CrossOver build of this same
source archive, redistributed under the LGPL, with their proprietary
non-LGPL programs removed.

`wine-11.0-winhttp-number64.patch` is published here for completeness and
is **not applied to the shipped runtime**. The shipped `winhttp.dll` is
CodeWeavers' unmodified build.

`scripts/build-wine-runtime.zsh` applies it, so a runtime built
with it is *not* byte-identical to the shipped one. Use it to rebuild and
replace the Wine libraries, which is what the LGPL requires; it is not a
reproduction of the release.

## Minimal rebuild

Requirements on macOS:

- Xcode Command Line Tools
- GNU make, bison, mingw-w64, and pkg-config
- x86_64 builds of FreeType, GnuTLS, and GMP in one directory
- headers for those libraries (Homebrew headers may be used)

The dependency libraries are unmodified third-party libraries. Their
corresponding source is included in the same CodeWeavers FOSS archive.

Run:

```sh
./scripts/build-wine-runtime.zsh \
  /path/to/crossover-sources-26.3.0.tar.gz \
  /path/to/x86_64-dependency-dylibs
```

The output is written to `.wine-build/stage`. The script only extracts,
patches, configures, builds, and installs the LGPL Wine runtime. It does
not build the mac-my-ro application, sign binaries, import certificates,
or package a release.

The shipped Wine libraries are dynamically loaded and may be replaced
with compatible modified builds. That replaceability is the LGPL
requirement this build satisfies; the application that loads them is a
separate work under its own licence.
