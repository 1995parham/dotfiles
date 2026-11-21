#!/usr/bin/env bash

usage() {
    echo -n "write shell scripts with confidence using shfmt and shellcheck"
    echo '
     _          _ _
 ___| |__   ___| | |
/ __| |_ \ / _ \ | |
\__ \ | | |  __/ | |
|___/_| |_|\___|_|_|

  '
}

# two tools: shellcheck finds the bugs and shfmt formats (4 spaces, see .editorconfig). ci runs
# both on this repository, the first with its optional quote-safe-variables check, so no other
# quoting tool is needed. neovim installs bash-language-server by itself (mason-packages.lua).

main_pacman() {
    require_pacman shfmt shellcheck
}

main_brew() {
    require_brew shfmt shellcheck
}

main_apt() {
    require_apt shfmt shellcheck
}
