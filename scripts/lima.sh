#!/usr/bin/env bash

usage() {
    echo "Lima - Linux virtual machines on macOS, with an Arch Linux ARM VM"
    echo "The VM template and its scripts are in lima/, read lima/CLAUDE.md"

    # shellcheck disable=1004,2016
    echo '
 _ _
| (_)_ __ ___   __ _
| | | |_ ` _ \ / _` |
| | | | | | | | (_| |
|_|_|_| |_| |_|\__,_|
  '
}

root=${root:?"root must be set"}

main_brew() {
    local formulas=() formula
    while read -r formula; do
        formulas+=("$formula")
    done < <(grep -vE '^\s*(#|$)' "$root/lima/requirements.txt")
    require_brew "${formulas[@]}"
}

main() {
    if ! yes_or_no 'lima' 'Create the Arch Linux ARM VM, upgrade it, and install the dotfiles in it?'; then
        msg 'Skipping the Arch Linux ARM VM, run lima/scripts/up.sh later' 'notice'
        return 0
    fi

    "$root/lima/scripts/up.sh"
}
