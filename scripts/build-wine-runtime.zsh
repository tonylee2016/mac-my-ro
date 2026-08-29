#!/bin/zsh
# Minimal corresponding-source build for the LGPL Wine runtime distributed
# with mac-my-ro. This script intentionally contains no application packaging,
# game integration, certificate, signing, or release logic.

set -euo pipefail

ROOT="${0:A:h:h}"
ARCHIVE="${1:-}"
DEPS_INPUT="${2:-}"
WORK="${WINE_BUILD_DIR:-$ROOT/.wine-build}"
SRC="$WORK/src/sources/wine"
BUILD="$WORK/build"
STAGE="$WORK/stage"
DEPS="$WORK/deps/lib"
JOBS="${JOBS:-$(sysctl -n hw.logicalcpu 2>/dev/null || print 8)}"

EXPECTED_ARCHIVE="ac99c8ca4b3848f3e81784135f023df266b61c2345726ea55a50b3e030dd6872"

if [[ -z "$ARCHIVE" || -z "$DEPS_INPUT" ]]; then
    print -u2 "usage: $0 /path/to/crossover-sources-26.3.0.tar.gz /path/to/x86_64-dylibs"
    exit 2
fi
[[ -f "$ARCHIVE" ]] || { print -u2 "source archive not found: $ARCHIVE"; exit 1; }
[[ -d "$DEPS_INPUT" ]] || { print -u2 "dependency directory not found: $DEPS_INPUT"; exit 1; }

actual=$(shasum -a 256 "$ARCHIVE" | awk '{print $1}')
[[ "$actual" == "$EXPECTED_ARCHIVE" ]] || {
    print -u2 "source archive SHA-256 mismatch"
    print -u2 "expected: $EXPECTED_ARCHIVE"
    print -u2 "actual:   $actual"
    exit 1
}

for patch_file in \
    "$ROOT/patches/crossover-26.3-unix-ntload-driver.patch" \
    "$ROOT/patches/wine-11.0-winhttp-number64.patch"; do
    [[ -f "$patch_file" ]] || { print -u2 "patch not found: $patch_file"; exit 1; }
done

for dylib in libfreetype.6.dylib libgnutls.30.dylib libgmp.10.dylib; do
    [[ -f "$DEPS_INPUT/$dylib" ]] || {
        print -u2 "required x86_64 dependency not found: $DEPS_INPUT/$dylib"
        exit 1
    }
done

mkdir -p "$WORK/src" "$BUILD" "$STAGE" "$DEPS"
if [[ ! -f "$SRC/dlls/ntdll/unix/system.c" ]]; then
    tar -xzf "$ARCHIVE" -C "$WORK/src" sources/wine
fi

# Stage the required x86_64 libraries at stable absolute paths. This avoids
# relying on DYLD_LIBRARY_PATH propagation through macOS system tools.
for dylib in libfreetype.6.dylib libgnutls.30.dylib libgmp.10.dylib; do
    cp -L "$DEPS_INPUT/$dylib" "$DEPS/$dylib"
    chmod u+w "$DEPS/$dylib"
    install_name_tool -id "$DEPS/$dylib" "$DEPS/$dylib"
done

for dylib in "$DEPS"/*.dylib; do
    while IFS= read -r dependency; do
        name="${dependency:t}"
        [[ -f "$DEPS/$name" ]] || continue
        install_name_tool -change "$dependency" "$DEPS/$name" "$dylib"
    done < <(otool -L "$dylib" | awk 'NR > 1 {print $1}' | grep '^@rpath/' || true)
done

apply_patch() {
    local patch_file="$1" marker="$2" target="$3"
    if ! grep -qF -- "$marker" "$SRC/$target"; then
        patch -p1 -d "$SRC" -i "$patch_file"
    fi
}

apply_patch "$ROOT/patches/crossover-26.3-unix-ntload-driver.patch" \
    "started service" "dlls/ntdll/unix/system.c"
apply_patch "$ROOT/patches/wine-11.0-winhttp-number64.patch" \
    "WINHTTP_QUERY_FLAG_NUMBER64 with attr" "dlls/winhttp/request.c"

# Keep unrelated arm64 package prefixes out of library detection. Headers are
# architecture-independent; all linked libraries come from the staged x86_64
# directory supplied by the caller.
export PATH="/opt/homebrew/opt/bison/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
unset PKG_CONFIG_PATH PKG_CONFIG_LIBDIR
export FREETYPE_CFLAGS="-I/opt/homebrew/include/freetype2 -I/opt/homebrew/include"
export FREETYPE_LIBS="-L$DEPS -lfreetype"
export GNUTLS_CFLAGS="-I/opt/homebrew/include"
export GNUTLS_LIBS="-L$DEPS -lgnutls"
export CPPFLAGS="-I/opt/homebrew/include"
export LDFLAGS="-L$DEPS"
export DYLD_LIBRARY_PATH="$DEPS${DYLD_LIBRARY_PATH:+:$DYLD_LIBRARY_PATH}"

if [[ ! -f "$BUILD/Makefile" ]]; then
    (
        cd "$BUILD"
        "$SRC/configure" \
            --prefix="$STAGE" \
            --host=x86_64-apple-darwin \
            --enable-archs=x86_64,i386 \
            --disable-tests \
            --without-sdl --without-krb5 --without-gphoto --without-cups \
            --without-v4l2 --without-pcap --without-usb --without-gstreamer \
            --without-netapi --without-opencl --without-sane \
            CC='clang -arch x86_64' CXX='clang++ -arch x86_64'
    )
fi

make -j"$JOBS" -C "$BUILD"
make -C "$BUILD" install
print "Wine runtime built at: $STAGE"
