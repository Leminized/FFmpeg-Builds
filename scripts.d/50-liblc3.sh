# 文件名: scripts.d/50-liblc3.sh

#!/bin/bash

SCRIPT_REPO="https://github.com/google/liblc3.git"
SCRIPT_COMMIT="502396f6426364f985b85dc0720fb6d76295b9c7"

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
    # liblc3 uses Meson
    local myconf=(
        --prefix "$FFBUILD_PREFIX"
        --buildtype release
        --default-library static
        -Dtests=false
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --cross-file "$FFBUILD_CROSS_FILE"
        )
    else
        echo "Unknown target"
        return -1
    fi

    meson setup build "${myconf[@]}"
    meson compile -C build -j$(nproc)
    meson install -C build
}


ffbuild_configure() {
    echo --enable-liblc3
}

ffbuild_unconfigure() {
    echo --disable-liblc3
}