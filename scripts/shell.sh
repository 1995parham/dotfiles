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

# three tools: shellcheck finds the bugs, shfmt formats (4 spaces, see .editorconfig), and
# shellharden corrects the quoting that the first one only reports. ci runs shellcheck and shfmt
# on this repository. neovim installs bash-language-server by itself (mason-packages.lua).

main_pacman() {
    require_pacman shfmt shellcheck shellharden
}

main_brew() {
    require_brew shfmt shellcheck shellharden
}

main_apt() {
    require_apt shfmt shellcheck
}
