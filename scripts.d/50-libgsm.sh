# 文件名: scripts.d/50-libgsm.sh

#!/bin/bash

SCRIPT_REPO="https://github.com/tim-lebedkov/libgsm.git"
SCRIPT_COMMIT="58453435ded28532494a0815354519918a55639f"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerdl() {
    echo "git clone --filter=blob:none '$SCRIPT_REPO' . && git checkout '$SCRIPT_COMMIT'"
}

ffbuild_dockerbuild() {
    # libgsm uses a simple Makefile, requiring manual intervention
    sed -i 's|/usr/local|$(DESTDIR)/usr/local|' Makefile
    sed -i 's|CFLAGS =|CFLAGS +=|' Makefile

    make -j$(nproc) \
        CC="$CC" \
        DESTDIR="$FFBUILD_PREFIX" \
        PREFIX="" \
        install

    # It installs to /usr/local, so we move it to the correct prefix
    mv "$FFBUILD_PREFIX/usr/local/"* "$FFBUILD_PREFIX/"
    rm -rf "$FFBUILD_PREFIX/usr"
}

ffbuild_configure() {
    echo --enable-libgsm
}

ffbuild_unconfigure() {
    echo --disable-libgsm
}