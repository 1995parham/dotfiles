#!/usr/bin/env bash

usage() {
    echo -n -e "The user-friendly command line shell"

    # shellcheck disable=1004,2016
    echo '
  __ _     _
 / _(_)___| |__
| |_| / __| |_ \
|  _| \__ \ | | |
|_| |_|___/_| |_|

  '
}

main_pacman() {
    require_pacman fish
}

main_brew() {
    require_brew fish
}

main() {
    if [ ! -f ~/.config/fish/conf.d/omf.fish ]; then
        curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
    fi

    grep "fish" /etc/shells || which fish | sudo tee -a /etc/shells

    configfile "fish" "config.fish"
}

main_elahe() {
    configfile "fish/conf.d" "smapp.fish"
}
