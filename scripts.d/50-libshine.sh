# 文件名: scripts.d/50-libshine.sh

#!/bin/bash

SCRIPT_REPO="https://github.com/toots/shine.git"
SCRIPT_COMMIT="ab5e3526b64af1a2eaa43aa6f441a7312e013519"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerdl() {
    echo "git clone --filter=blob:none '$SCRIPT_REPO' . && git checkout '$SCRIPT_COMMIT'"
}

ffbuild_dockerbuild() {
    ./bootstrap

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --with-pic
        --host="$FFBUILD_TOOLCHAIN"
        --disable-fast-install
    )

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-libshine
}

ffbuild_unconfigure() {
    echo --disable-libshine
}