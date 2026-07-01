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
    require_pacman fish eza
}

main_brew() {
    require_brew fish eza
}

main() {
    msg 'add fish as a shell into /etc/shells'
    grep "fish" /etc/shells || which fish | sudo tee -a /etc/shells

    configfile "fish" "config.fish"
    configfile "fish/conf.d" "greeting.fish"
    configfile "fish/conf.d" "dircolors.fish"
}
