#!/usr/bin/env bash

usage() {
    echo "clang, cmake without prof.bakhshi :("
    echo '
  ___
 / __|
| (__
 \___|

  '
}

# clang ships clangd, clang-format and clang-tidy in one package on arch; debian splits them.
# ninja is the build backend of both cmake and meson, and bear writes the compile_commands.json
# that clangd reads for a project built with plain make.

main_pacman() {
    require_pacman clang lldb cmake ninja meson bear valgrind
}

main_brew() {
    # the command line tools of xcode already have clang, clangd and lldb. valgrind does not
    # run on apple silicon.
    require_brew clang-format cmake ninja meson bear
}

main_apt() {
    require_apt clang clangd clang-format clang-tidy lldb cmake ninja-build meson bear valgrind
}
