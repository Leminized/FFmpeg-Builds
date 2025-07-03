# 文件名: scripts.d/50-libvo-amrwbenc.sh

#!/bin/bash

SCRIPT_REPO="https://github.com/mstorsjo/vo-amrwbenc.git"
SCRIPT_COMMIT="884dd247dbeb6b2bd2cd3291c4872de95700291f"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerdl() {
    echo "git clone --filter=blob:none '$SCRIPT_REPO' . && git checkout '$SCRIPT_COMMIT'"
}

ffbuild_dockerbuild() {
    # This library does not have an autogen.sh script.
    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --with-pic
        --host="$FFBUILD_TOOLCHAIN"
    )

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-libvo-amrwbenc
}

ffbuild_unconfigure() {
    echo --disable-libvo-amrwbenc
}