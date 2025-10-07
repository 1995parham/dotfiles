#!/usr/bin/env bash

usage() {
    echo -n 'git configuration useful on systems with ssh keys used by @1995parham/@elahe-dastan'
    echo '
       _ _
  __ _(_) |_
 / _` | | __|
| (_| | | |_
 \__, |_|\__|
 |___/
  '
}

main_pacman() {
    require_pacman pre-commit
}

main_brew() {
    return 0
}

main_apt() {
    return 0
}

main_xbps() {
    return 0
}

main_pkg() {
    msg 'android does not have specific user, so we are forced to consider it as me'
    configfile "git" "" "git/parham"
}

main_parham() {
    configfile "git" "" "git/parham"
}

main_elahe() {
    configfile "git" "" "git/elahe"
}

main_raha() {
    main_elahe
}

main_elahe-dastan() {
    main_elahe
}
