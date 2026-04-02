#!/usr/bin/env bash

usage() {
    echo -n -e "crosstool-ng for cross compiling"
    echo ""
    echo "note: for simpler cross-compilation, consider:"
    echo "  - pre-built toolchains (gcc-arm-none-eabi, gcc-aarch64-linux-gnu)"
    echo "  - zig cc (cross-compiles C/C++ out of the box)"
    echo "  - buildroot/yocto (builds toolchains internally)"
    echo "ct-ng is best when you need fine-grained control over the toolchain"

    # shellcheck disable=1004,2016
    echo '
      _
  ___| |_      _ __   __ _
 / __| __|____| |_ \ / _` |
| (__| ||_____| | | | (_| |
 \___|\__|    |_| |_|\__, |
                     |___/

 '
}

main_pacman() {
    require_pacman help2man
}

main() {
    clone "https://github.com/crosstool-ng/crosstool-ng" "$HOME/.cache"

    cd "$HOME/.cache/crosstool-ng" || return 1
    ./bootstrap
    ./configure --prefix="/usr/local"
    make
    sudo make install
    cd - || return 1

    msg "the workspace for using crosstool"
    mkdir -p "$HOME/Documents/crosstool" || true
}
