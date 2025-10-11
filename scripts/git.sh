#!/usr/bin/env bash

usage() {
    echo -n 'git configuration useful on systems with ssh keys used by @1995parham/@elaheh-dastan'
    echo '
       _ _
  __ _(_) |_
 / _` | | __|
| (_| | | |_
 \__, |_|\__|
 |___/
  '
}

main_pre() {
    msg 'git-filter-repo is a versatile tool for rewriting git history (filter-branch replacement)'
    msg 'pre-commit is a framework for managing and maintaining multi-language pre-commit hooks'
}

main_pacman() {
    require_pacman pre-commit git-filter-repo
}

main_brew() {
    require_brew pre-commit git-filter-repo
}

main_apt() {
    require_apt git-filter-repo
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
