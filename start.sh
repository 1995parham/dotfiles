#!/usr/bin/env bash

# https://stackoverflow.com/questions/3822621/how-to-exit-if-a-command-failed
set -eu
set -o pipefail

# a global variable that points to dotfiles root directory.
# it used also in scripts/.
root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
main_root="${root}"
# shellcheck source=main.sh
source "${root}/scripts/lib/main.sh"

# start.sh
program_name=$0

trap '_end' INT

_end() {
    echo "see you in a better tomorrow [you signal start.sh execution]"
    exit
}

_usage() {
    echo ""
    echo "usage: ${program_name} [-y] [-h] script [script options]"
    echo "  -h   display help"
    echo "  -d   as dependency (internal usage)"
    echo "  -y   yes to all"
    echo ""
    echo " ${program_name} new for creating a new script"
    echo " ${program_name} list for see available scripts"
    echo ""
}

_parse_options() {
    # These are used globally in the script
    show_help=false
    yes_to_all=0
    as_dependency=false

    while getopts 'dhy' argv; do
        case ${argv} in
        h)
            show_help=true
            ;;
        d)
            as_dependency=true
            ;;
        y)
            yes_to_all=1
            ;;
        *)
            _usage
            ;;
        esac
    done
}

_resolve_script_name() {
    local script=$1

    case ${script} in
    "list")
        echo "lib/list"
        ;;
    "new")
        echo "lib/new"
        ;;
    "update")
        echo "lib/update"
        ;;
    *)
        echo "${script}"
        ;;
    esac
}

_resolve_script_paths() {
    local script=$1
    local paths=()
    local host
    host="${HOSTNAME%%.*}"

    # General script in scripts/
    if [[ -f "${main_root}/scripts/${script}.sh" ]]; then
        paths+=("${main_root}/scripts/${script}.sh:${main_root}")
    fi

    # Host-specific script in hosts/{hostname}/scripts/
    if [[ -f "${main_root}/hosts/${host}/scripts/${script}.sh" ]]; then
        paths+=("${main_root}/hosts/${host}/scripts/${script}.sh:${main_root}/hosts/${host}")
    fi

    # Fallback: old structure {hostname}/scripts/
    if [[ -f "${main_root}/${host}/scripts/${script}.sh" ]]; then
        paths+=("${main_root}/${host}/scripts/${script}.sh:${main_root}/${host}")
    fi

    echo "${paths[@]}"
}

_execute_scripts() {
    local script=$1
    shift
    local script_args=("${@:-}")

    local script_paths
    read -ra script_paths <<<"$(_resolve_script_paths "${script}")"

    if [[ ${#script_paths[@]} -eq 0 ]]; then
        message "pre" "404 script not found" "notice"
        local host="${HOSTNAME%%.*}"
        message "pre" "404 script not found for ${host}" "notice"
        _usage
        return 1
    fi

    for script_path_entry in "${script_paths[@]}"; do
        IFS=':' read -r script_file script_root <<<"${script_path_entry}"

        if [[ "${script_file}" == *"/hosts/"* ]] || [[ "${script_file}" == *"/${HOSTNAME%%.*}/"* ]]; then
            local host="${HOSTNAME%%.*}"
            message "pre" "run script for specific host: ${host}" "notice"
        fi

        # Set root for this script execution
        root="${script_root}"

        # shellcheck disable=1090
        if ! source "${script_file}" 2>/dev/null; then
            message "pre" "failed to source ${script_file}" "error"
            return 1
        fi

        _run "${script_args[@]}"
    done
}

_main() {
    # Parse command-line options
    _parse_options "$@"

    # Shift past the parsed options
    shift $((OPTIND - 1))

    if [[ ${as_dependency} = false ]]; then
        # shellcheck source=header.sh
        source "${root}/scripts/lib/header.sh"
    fi

    # handles root user
    if [[ ${EUID} -eq 0 ]]; then
        message "pre" "it must run without the root permissions with a regular user." "error"
        return 1
    fi

    # Get script name
    local script
    if [[ "${1:+defined}" = "defined" ]]; then
        script=$1
        shift
    else
        _usage
        script="list"
    fi

    # Resolve script name (handle list/new/update)
    script=$(_resolve_script_name "${script}")

    # Execute all matching scripts (general + host-specific)
    _execute_scripts "${script}" "$@"
}

_run() {
    start=$(date +%s)
    if [[ "${show_help}" = true ]]; then
        # prints the start.sh and the script helps
        _usage
        echo
        usage
    else
        # run the script
        msg() { message "${script}" "$@"; }
        msg "$(usage)"

        # handle dependencies by executing the start.sh
        # for each of them separately
        if [[ "$(declare -p dependencies 2>/dev/null)" =~ "declare -a" ]]; then
            _dependencies "${dependencies[@]}"
        fi

        run "$@"

        # handle additional packages by executing the start.sh
        # for each of them separately
        if [[ "$(declare -p additionals 2>/dev/null)" =~ "declare -a" ]]; then
            _additionals "${additionals[@]}"
        fi
    fi

    echo
    took=$(($(date +%s) - start))
    printf "done. it took %d seconds.\n" "${took}"
}

_additionals() {
    declare -a additionals
    additionals=("$@")

    if [[ "${#additionals[@]}" -eq 0 ]]; then
        return
    fi

    output=$(echo -n "additionals: |")
    output="${output}"$(printf "%s|" "${additionals[@]}")
    msg "${output}"

    for additional in "${additionals[@]}"; do
        read -ra additional <<<"${additional}"

        if yes_or_no "${script}" "do you want to install ${additional[0]} as an additional package?"; then
            local options="-d"
            if [[ "${yes_to_all}" = 1 ]]; then
                options="${options}y"
            fi

            "${main_root}/start.sh" "${options}" "${additional[@]}"
        fi
    done
}

_dependencies() {
    declare -a dependencies
    dependencies=("$@")

    if [[ "${#dependencies[@]}" -eq 0 ]]; then
        return
    fi

    output=$(echo -n "dependencies: |")
    output="${output}"$(printf "%s|" "${dependencies[@]}")
    msg "${output}"

    if yes_or_no "${script}" "do you want to install dependencies?"; then
        local options="-d"
        if [[ "${yes_to_all}" = 1 ]]; then
            options="${options}y"
        fi

        for dependency in "${dependencies[@]}"; do
            read -ra dependency <<<"${dependency}"
            "${main_root}/start.sh" "${options}" "${dependency[@]}"
        done
    fi
}

run() {
    if declare -f pre_main >/dev/null; then
        section_header "Pre Main"
        pre_main "$@"
    fi

    section_header "Install"
    install

    if declare -f main >/dev/null; then
        section_header "Main"
        main "$@"
    fi

    if declare -f "main_${USER}" >/dev/null; then
        section_header " Attention on deck ${USER}"
        "main_${USER}" "$@"
    fi
}

install() {
    if [[ "${OSTYPE}" == "darwin"* ]]; then
        msg " darwin, using brew"

        if declare -f main_brew >/dev/null; then
            main_brew
        else
            msg "main_brew not found, there is nothing to do" "error"
            exit
        fi

        return
    fi

    if [[ "${OSTYPE}" == "linux-android" ]]; then
        msg " android (termux), using pkg"

        if declare -f main_pkg >/dev/null; then
            main_pkg
        else
            msg "main_pkg not found, there is nothing to do" "error"
            exit
        fi

        return
    fi

    if [[ -n "$(command -v apt)" ]]; then
        msg " linux with apt installed, using apt"

        if declare -f main_apt >/dev/null; then
            main_apt
        else
            msg "main_apt not found, there is nothing to do" "error"
            exit
        fi

        return
    fi

    if [[ -n "$(command -v pacman)" ]]; then
        msg " linux with pacman installed, using pacman/yay"

        if declare -f main_pacman >/dev/null; then
            main_pacman
        else
            msg "main_pacman not found, there is nothing to do" "error"
            exit
        fi

        return
    fi

    if [[ -n "$(command -v xbps-install)" ]]; then
        msg " linux with xbps installed, using xbps"

        if declare -f main_xbps >/dev/null; then
            main_xbps
        else
            msg "main_xbps not found, there is nothing to do" "error"
            exit
        fi

        return
    fi
}

_main "$@"
