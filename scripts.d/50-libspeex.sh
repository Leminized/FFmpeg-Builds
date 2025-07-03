# 文件名: scripts.d/50-libspeex.sh

#!/bin/bash

SCRIPT_REPO="https://gitlab.xiph.org/xiph/speex.git"
SCRIPT_COMMIT="7708702956294713e284451a3ea3bae598835821"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    ./autogen.sh

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --with-pic
        --host="$FFBUILD_TOOLCHAIN"
        --disable-examples
    )

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-libspeex
}

ffbuild_unconfigure() {
    echo --disable-libspeex
}