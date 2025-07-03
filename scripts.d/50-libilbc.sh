# 文件名: scripts.d/50-libilbc.sh

#!/bin/bash

SCRIPT_REPO="https://github.com/google/libilbc.git"
SCRIPT_COMMIT="d33454223a676b91485601a4e1a03e1e2d780775"

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
    echo --enable-libilbc
}

ffbuild_unconfigure() {
    echo --disable-libilbc
}