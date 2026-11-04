#!/usr/bin/env bash

usage() {
    echo "available scripts with their description"

    # shellcheck disable=1004,2016
    echo '
 _ _     _
| (_)___| |_
| | / __| __|
| | \__ \ |_
|_|_|___/\__|
  '
}

root=${root:?"root must be set"}

main_pacman() {
    return 0
}

main_apt() {
    return 0
}

main_brew() {
    return 0
}

main_xbps() {
    return 0
}

main_pkg() {
    return 0
}

main() {
    echo
    echo

    local script
    for script in $(fd -e .sh -d 1 . "${root}/scripts" -x basename | sed -e "s/.sh$//" | sort); do
        # shellcheck disable=1090
        description=$(source "${root}/scripts/${script}.sh" && usage | sed -n 1p)
        msg "${script}: ${description}"
    done

    echo
    echo

    local host
    host="$(_host_short)"

    # same places _resolve_script_paths in start.sh looks: hosts/<host>/ then
    # the legacy <host>/ layout. root is the owning directory, as at run time.
    local host_root
    for host_root in "${root}/hosts/${host}" "${root}/${host}"; do
        if [[ ! -d "${host_root}/scripts" ]]; then
            continue
        fi

        local script
        for script in $(fd -e .sh -d 1 . "${host_root}/scripts" -x basename | sed -e "s/.sh$//" | sort); do
            # shellcheck disable=1090
            description=$(root="${host_root}" && source "${host_root}/scripts/${script}.sh" && usage | sed -n 1p)
            msg "${script}: ${description}"
        done

        echo
        echo
    done
}
