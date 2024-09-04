#!/usr/bin/env bash
usage() {
    echo "A popular general-purpose scripting language that is especially suited to web development."

    # shellcheck disable=1004,2016
    echo '
       _
 _ __ | |__  _ __
| |_ \| |_ \| |_ \
| |_) | | | | |_) |
| .__/|_| |_| .__/
|_|         |_|
  '
}

pre_main() {
    return 0
}

main_pacman() {
    return 1
}

main_apt() {
    return 1
}

main_brew() {
    require_brew php
}

main() {
    require_mason phpactor
    require_mason php-cs-fixer
    require_mason phpstan
}

main_parham() {
    return 0
}
