#!/usr/bin/env bash

usage() {
    echo -n -e "ansible is a radically simple IT automation platform that makes your applications and systems easier to deploy and maintain."

    # shellcheck disable=1004,2016
    echo '
                 _ _     _
  __ _ _ __  ___(_) |__ | | ___
 / _| | |_ \/ __| | |_ \| |/ _ \
| (_| | | | \__ \ | |_) | |  __/
 \__,_|_| |_|___/_|_.__/|_|\___|
  '
}

main_pacman() {
    require_pacman ansible ansible-lint cowsay
}

main_brew() {
    require_brew ansible ansible-lint cowsay
}

main() {
    require_mason 'ansible-language-server'
    require_pip 'ansible-vault'
}
