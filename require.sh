#!/usr/bin/env bash

ip_country_url="https://api.ipquery.io/?format=json"
# ip_country_url="https://api.ipapi.is"

# check being in the specific country
function require_country() {
    country=${1:?"country is required"}
    current_country="$(curl -m 10 -s "$ip_country_url" | jq '.location.country' || echo -n 'Iran')"
    if [[ "${current_country}" != "${country}" ]]; then
        message "country" "󰈻 please be in ${country} instead of ${current_country}" "error"
        return 1
    fi

    return 0
}

# check not being in the specific country
function not_require_country() {
    country=${1:?"country is required"}
    current_country="$(curl -m 10 -s "$ip_country_url" | jq '.location.country' || echo -n 'Iran')"
    if [[ "${current_country}" == "${country}" ]]; then
        message "country" "󰈻 please be in another country instead of ${country}" "error"
        return 1
    fi

    return 0
}

# connectivity check for the given host using icmp.
function require_host() {
    host=${1:?"host is required"}
    ping -q -c 1 "${host}" || (message "host" "󰈂 please make sure you have access to ${host}" 'error' && return 1)
}

# remove packages using pacman
function not_require_pacman() {
    declare -a to_remove_pkg
    to_remove_pkg=()

    for pkg in "$@"; do
        running "not require" " pacman ${pkg}"
        if [[ "$(pacman -Qq "${pkg}" 2>/dev/null)" = "${pkg}" ]]; then
            to_remove_pkg+=("${pkg}")
        fi
    done

    if [[ ${#to_remove_pkg[@]} -ne 0 ]]; then
        action "not require" " pacman uninstall ${to_remove_pkg[*]}"
        sudo pacman -Rsu "${to_remove_pkg[@]}"
    fi
}

# install packages using pkg
function require_pkg() {
    declare -a to_install_pkg
    to_install_pkg=()

    for pkg in "$@"; do
        running "require" " pkg ${pkg}"
        if ! pkg list-installed | grep "${pkg}" &>/dev/null; then
            to_install_pkg+=("${pkg}")
        fi
    done

    if [[ ${#to_install_pkg[@]} -ne 0 ]]; then
        action "require" " pkg install ${to_install_pkg[*]}"
        pkg install -y "${to_install_pkg[@]}"
    fi
}

# install packages using brew
function require_brew() {
    declare -a to_install_pkg
    to_install_pkg=()

    for pkg in "$@"; do
        running "require" " brew ${pkg}"
        if ! brew list --versions "${pkg}" &>/dev/null; then
            to_install_pkg+=("${pkg}")
        fi
    done

    if [[ ${#to_install_pkg[@]} -ne 0 ]]; then
        action "require" " brew install ${to_install_pkg[*]}"
        brew install --formula "${to_install_pkg[@]}"
    fi
}

# install packages using brew fetch-HEAD
function require_brew_head() {
    for pkg in "$@"; do
        running "require" " brew head ${pkg}"
        if ! brew list --versions "${pkg}" &>/dev/null; then
            action "require" " brew install --fetch ${pkg}"
            brew install --HEAD "${pkg}"
        else
            action "require" " brew upgrade --fetch-HEAD ${pkg}"
            brew upgrade --fetch-HEAD "${pkg}"
        fi
    done
}

# install packages using brew cask
function require_brew_cask() {
    for pkg in "$@"; do
        running "require" " brew cask ${pkg}"
        if ! brew list --cask --versions "${pkg}" &>/dev/null; then
            action "require" " brew install --cask ${pkg}"
            brew install --cask "${pkg}"
        fi
    done
}

# install packages using snap
function require_snap() {
    action "require" " snap install $* (snap ignore installed package itself)"
    sudo snap install "$@"
}

# install packages using apt
function require_apt() {
    declare -a to_install_pkg
    to_install_pkg=()

    for pkg in "$@"; do
        running "require" " apt ${pkg}"
        if ! dpkg -s "${pkg}" &>/dev/null; then
            to_install_pkg+=("${pkg}")
        fi
    done

    if [[ ${#to_install_pkg[@]} -ne 0 ]]; then
        action "require" " apt install ${to_install_pkg[*]}"
        sudo apt -qy install "${to_install_pkg[@]}"
    fi
}

# install packages using pacman
function require_pacman() {
    declare -a to_install_pkg
    to_install_pkg=()

    for pkg in "$@"; do
        running "require" " pacman ${pkg}"
        if ! pacman -Qi "${pkg}" &>/dev/null; then
            to_install_pkg+=("${pkg}")
        fi
    done

    if [[ ${#to_install_pkg[@]} -ne 0 ]]; then
        action "require" " pacman -Sy ${to_install_pkg[*]}"
        sudo pacman -Sy --noconfirm "${to_install_pkg[@]}"
    fi
}

# install packages using xbps
function require_xbps() {
    declare -a to_install_pkg
    to_install_pkg=()

    for pkg in "$@"; do
        running "require" " xbps ${pkg}"
        if ! xbps-query "${pkg}" &>/dev/null; then
            to_install_pkg+=("${pkg}")
        fi
    done

    if [[ ${#to_install_pkg[@]} -ne 0 ]]; then
        action "require" " xbps-install -Sy ${to_install_pkg[*]}"
        sudo xbps-install -Sy "${to_install_pkg[@]}"
    fi
}

# install packages from AUR using yay
function require_aur() {
    if [[ -z "$(command -v yay)" ]]; then
        message "require" "yay command does not exist, so there is no support for aur, use 'allow_no_aur' to bypass aur" "error"

        if [[ "${allow_no_aur:-false}" = true ]]; then
            return 0
        else
            return 1
        fi
    fi

    for pkg in "$@"; do
        running "require" " arch users repository ${pkg}"
        if (! pacman -Q "${pkg}" &>/dev/null); then
            action "require" " yay -Sy ${pkg}"
            yay -Sy --sudoloop --noconfirm "${pkg}"
        elif [[ "${pkg}" =~ .*-git ]]; then
            if sudo -l; then
                action "require" " yay -Sy ${pkg} to upgrade -git package"
                yay -Sy --sudoloop --noconfirm "${pkg}" || true
            fi
        fi
    done
}

# install tools for neovim using manson
function require_mason() {
    for pkg in "$@"; do
        action "require" " neovim + mason ${pkg}"
        nvim "+MasonInstall ${pkg}" --headless +qall 2>/dev/null
    done
}

# install go package
function require_go() {
    pkg=${1:?"package is required"}
    version=${2:-"latest"}
    action "require" " go ${pkg} @ ${version}"
    go install "${pkg}@${version}" 2>/dev/null
}

function require_pip() {
    for pkg in "$@"; do
        # do not upgrade when user request a specific version.
        not_specific_version=true
        if [[ "${pkg}" == *@* ]]; then
            not_specific_version=false
        fi
        # remove version specification and remaining
        # spaces.
        name=${pkg%%@*}
        name=$(echo "${name}" | xargs)

        running "require" " python ${name} (${pkg})"
        if ${not_specific_version} && (pipx list | grep "${pkg}" &>/dev/null); then
            action "require" " pipx upgrade ${name} (${pkg})"
            pipx upgrade "${pkg}"
        else
            if ${not_specific_version}; then
                action "require" " pipx install ${name} (${pkg})"
                pipx install --include-deps "${pkg}"
            else
                action "require" " pipx install by force ${name} (${pkg})"
                pipx install --include-deps --force "${pkg}"
            fi
        fi
    done
}

function require_npm() {
    for pkg in "$@"; do
        action "require" "󰎙 node ${pkg}"
        if ! (node -g list "${pkg}" &>/dev/null); then
            sudo npm install -g "${pkg}"
        fi
    done
}

# check and add the given hostname, address pair into /etc/hosts.
function require_hosts_record() {
    local address
    local name
    address=${1:?"address is required"}
    name=${2:?"name is required"}

    message 'hosts' "add mapping from $name to $address"

    if [[ ! -f /etc/hosts ]]; then
        printf "# Static table lookup for hostnames.\n# See hosts(5) for details." | sudo tee /etc/hosts
    fi

    # find existing instances in the host file and save the line numbers
    local host_entry
    host_entry=$(printf "%s\t%s" "${address}" "${name}")

    message 'hosts' "the host entry is $host_entry"

    local matches_in_hosts

    if ! matches_in_hosts="$(grep -n -e '\s'"$name" /etc/hosts | cut -f1 -d:)"; then
        message "hosts" "adding new hosts entry"
        echo "$host_entry" | sudo tee -a /etc/hosts >/dev/null
    else
        if [ -n "$matches_in_hosts" ]; then
            message "hosts" "updating existing hosts entry"

            # iterate over the line numbers on which matches were found
            while read -r line_number; do
                # replace the text of each line with the desired host entry
                sudo sed -i '' "${line_number}s/.*/${host_entry}/" /etc/hosts
            done <<<"$matches_in_hosts"
        else
            message "hosts" "adding new hosts entry"
            echo "$host_entry" | sudo tee -a /etc/hosts >/dev/null
        fi
    fi
}

function clone() {
    local repo
    local path
    local dir

    repo=${1:?"clone requires repository"}
    path=${2:-"."}
    dir=${3:-""}

    if [[ $# -le 3 ]]; then
        shift $#
    else
        shift 3
    fi

    if [[ ! -d "${path}" ]]; then
        mkdir -p "${path}"
    fi

    repo_name="$(rg -o '\w([:/]\w+[^?]+)' -r '$1' <<<"${repo}")"
    repo_name=${repo_name:1}

    if [[ "${dir}" = "" ]]; then
        dir="$(basename "${repo_name}")"
    fi

    if [[ ! -d "${path}/${dir}" ]]; then
        if git clone "${repo}" "${path}/${dir}" &>/dev/null; then
            action git "${repo_name} ${F_GREEN}󰄲${F_RESET}"
        else
            action git "${repo_name} ${F_RED}󱋭${F_RESET}"
        fi
    else
        cd "${path}/${dir}" || return

        origin_url=$(git remote get-url origin 2>/dev/null)

        if [[ "${repo}" == "${origin_url%.git}" ]]; then
            action git "${repo_name} ${F_GRAY}${F_RESET}"
        else
            action git "${repo_name} (${repo} != ${origin_url}) ${F_RED}󱋭${F_RESET}"
        fi

        cd - &>/dev/null || return
    fi

    if [[ "$#" -ge 1 ]]; then
        url="$1"
        shift 1

        cd "${path}/${dir}" || return

        if git remote get-url origin --all 2>/dev/null | grep "$url" &>/dev/null; then
            action git "${repo_name} pushurl -> ${url} ${F_GRAY}󰄲${F_RESET}"
        else
            if git remote set-url --add origin "${url}" &>/dev/null; then
                action git "${repo_name} pushurl -> ${url} ${F_GREEN}󰄲${F_RESET}"
            else
                action git "${repo_name} pushurl -> ${url} ${F_RED}󱋭${F_RESET}"
            fi
        fi

        cd - &>/dev/null || return
    fi
}

function require_systemd_kernel_parameter() {
    local new_kernel_parameter=${1:?"new parameter required"}

    for configuration in /boot/loader/entries/*.conf; do
        echo
        message 'systemd-boot' "updating ${configuration}"
        echo
        message 'systemd-boot' "$(grep options "${configuration}")"

        case "${new_kernel_parameter}" in
        +*)
            _add_systemd_kernel_parameter "${configuration}" "${new_kernel_parameter:1}"
            ;;
        -*)
            _remove_systemd_kernel_parameter "${configuration}" "${new_kernel_parameter:1}"
            ;;
        *)
            _add_systemd_kernel_parameter "${configuration}" "${new_kernel_parameter}"
            ;;
        esac

        message 'systemd-boot' "$(grep options "${configuration}")"
        echo
        echo
    done
}

function _add_systemd_kernel_parameter() {
    local configuration=${1:?"systemd-boot loader configuration required"}
    local new_kernel_parameter=${2:?"new parameter required"}

    local kernel_paramters
    declare -a kernel_paramters
    IFS=' ' read -ra kernel_paramters <<<"$(grep options "${configuration}")"

    local output
    output=$(echo -n "current kernel_paramters: |")
    output="${output}"$(printf "%s|" "${kernel_paramters[@]}")
    message 'systemd-boot' "${output}"

    for kernel_parameter in "${kernel_paramters[@]}"; do
        if [[ "${kernel_parameter}" == "${new_kernel_parameter}" ]]; then
            message "systemd-boot" "kernel_parameter ${new_kernel_parameter} already exists"
            return 0
        fi
    done
    kernel_paramters+=("${new_kernel_parameter}")

    sudo sed -i -e "s|^options.*$|${kernel_paramters[*]}|" "${configuration}"
}

function _remove_systemd_kernel_parameter() {
    local configuration=${1:?"systemd-boot loader configuration required"}
    local new_kernel_parameter=${2:?"new parameter required"}

    local kernel_paramters
    declare -a kernel_paramters
    IFS=' ' read -ra kernel_paramters <<<"$(grep options "${configuration}")"

    local output
    output=$(echo -n "current kernel_paramters: |")
    output="${output}"$(printf "%s|" "${kernel_paramters[@]}")
    message 'systemd-boot' "${output}"

    local found=0
    for index in "${!kernel_paramters[@]}"; do
        if [[ "${kernel_paramters[${index}]}" == "${new_kernel_parameter}" ]]; then
            unset "kernel_paramters[${index}]"
            found=1
        fi
    done

    if [[ "${found}" -eq 1 ]]; then
        sudo sed -i -e "s|^options.*$|${kernel_paramters[*]}|" "${configuration}"
    fi
}
