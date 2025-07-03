# 文件名: scripts.d/50-libxeve.sh

#!/bin/bash

SCRIPT_REPO="https://github.com/eunmg/xeve.git"
SCRIPT_COMMIT="5b5e783457a3e743a6d71b312788e995f512726d"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerdl() {
    # The default git-mini-clone can fail for some repos/commits.
    # A full(er) clone followed by a checkout is more robust.
    git clone --filter=blob:none "$SCRIPT_REPO" .
    git checkout "$SCRIPT_COMMIT"
}

ffbuild_dockerbuild() {
    # xeve uses CMake
    mkdir build && cd build

    cmake .. \
        -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" \
        -DBUILD_SHARED_LIBS=OFF \
        -DBUILD_TEST_EXE=OFF

    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-libxeve
}

ffbuild_unconfigure() {
    echo --disable-libxeve
}