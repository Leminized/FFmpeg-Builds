#!/bin/bash

SCRIPT_REPO="https://git.savannah.gnu.org/git/libiconv.git"
SCRIPT_COMMIT="918904edaf378253f262ce19da02ec69cec94a4e"

<<<<<<< HEAD
SCRIPT_REPO2="https://github.com/coreutils/gnulib.git"
SCRIPT_COMMIT2="9a1a6385a57bd6c6493ba1d0660a960574953a9a"
=======
SCRIPT_REPO2="https://git.savannah.gnu.org/git/gnulib.git"
SCRIPT_COMMIT2="b88f01f04b38b156383ab269a58e5af58ec4cd0e"
>>>>>>> remotes/upstream/master

ffbuild_enabled() {
    return 0
}

ffbuild_dockerdl() {
    echo "retry-tool sh -c \"rm -rf iconv && git clone '$SCRIPT_REPO' iconv\" && git -C iconv checkout \"$SCRIPT_COMMIT\""
    echo "cd iconv && retry-tool sh -c \"rm -rf gnulib && git clone '$SCRIPT_REPO2' gnulib\" && git -C gnulib checkout \"$SCRIPT_COMMIT2\" && rm -rf gnulib/.git"
}

ffbuild_dockerbuild() {
    # No automake 1.18 packaged anywhere yet.
    sed -i 's/-1.18/-1.16/' Makefile.devel libcharset/Makefile.devel

    (unset CC CFLAGS GMAKE && ./autogen.sh)

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --enable-extra-encodings
        --disable-shared
        --enable-static
        --with-pic
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-iconv
}

ffbuild_unconfigure() {
    echo --disable-iconv
}
