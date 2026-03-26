#!/usr/bin/env bash

usage() {
    echo -n "Extremely fast tool to remove duplicates and other lint from your filesystem."
    # shellcheck disable=2016
    echo '
                 _ _       _
 _ __ _ __ ___ | (_)_ __ | |_
| |__| |_ ` _ \| | | |_ \| __|
| |  | | | | | | | | | | | |_
|_|  |_| |_| |_|_|_|_| |_|\__|
	'
}

main_brew() {
    require_brew rmlint
}

main_pacman() {
    require_aur rmlint
}

main_apt() {
    require_apt rmlint
}

main() {
    return 0
}
