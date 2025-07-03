# 文件名: scripts.d/50-libcodec2.sh

#!/bin/bash

SCRIPT_REPO="https://github.com/drowe67/codec2.git"
SCRIPT_COMMIT="e63788a876a31c5195325e01669e4871e352d19e"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    # Codec2 uses CMake
    mkdir build && cd build

    cmake .. \
        -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" \
        -DBUILD_SHARED_LIBS=OFF \
        -DUNITTEST=OFF \
        -DEXAMPLES=OFF

    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-libcodec2
}

ffbuild_unconfigure() {
    echo --disable-libcodec2
}