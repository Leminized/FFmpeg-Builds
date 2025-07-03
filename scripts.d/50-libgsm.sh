# 文件名: scripts.d/50-libgsm.sh

#!/bin/bash

SCRIPT_REPO="https://github.com/timothytylee/libgsm.git"
SCRIPT_COMMIT="98f1708fb5e06a0dfebd58a3b40d610823db9715"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerdl() {
    echo "git clone --filter=blob:none '$SCRIPT_REPO' . && git checkout '$SCRIPT_COMMIT'"
}

ffbuild_dockerbuild() {
    # This makefile is non-standard.
    # We build the library manually and copy the required files.
    make -j$(nproc) lib/libgsm.a

    # Manually install the files to the correct locations
    install -d "$FFBUILD_PREFIX"/lib
    install -d "$FFBUILD_PREFIX"/include
    install -m644 lib/libgsm.a "$FFBUILD_PREFIX"/lib/
    install -m644 inc/gsm.h "$FFBUILD_PREFIX"/include/
}

ffbuild_configure() {
    echo --enable-libgsm
}

ffbuild_unconfigure() {
    echo --disable-libgsm
}