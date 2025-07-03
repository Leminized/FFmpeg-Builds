# 文件名: scripts.d/50-libvo-amrwbenc.sh

#!/bin/bash

SCRIPT_REPO="https://github.com/mstorsjo/vo-amrwbenc.git"
SCRIPT_COMMIT="cb526a6396f86c2e7428f731174640167c51950d"

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
    ./autogen.sh

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