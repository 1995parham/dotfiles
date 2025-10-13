#!/usr/bin/env bash

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
        running git "cloning ${repo_name}..."
        # Unbuffer stderr and stdout for git clone progress
        if git clone --progress "${repo}" "${path}/${dir}" 2>&1 | {
            stdbuf -oL -eL cat | while IFS= read -r line; do
                # Extract percentage from git progress output
                # Git format: "Receiving objects:  50% (100/200)" or "Resolving deltas:  50% (100/200)"
                if [[ "${line}" =~ ([0-9]+)%[[:space:]]*\(([0-9]+)/([0-9]+)\) ]]; then
                    percent="${BASH_REMATCH[1]}"
                    current="${BASH_REMATCH[2]}"
                    total="${BASH_REMATCH[3]}"
                    echo -ne "\r${CLEAR_LINE}${F_INFO}[git] ${F_ACCENT}${ARROW_MARK} ${repo_name}: ${F_SUCCESS}${percent}%${F_INFO} (${current}/${total})${ALL_RESET}"
                fi
            done
            echo
        }; then
            echo -ne "\r${CLEAR_LINE}"
            action git "${repo_name} ${F_SUCCESS}󰄲${ALL_RESET}"
        else
            echo -ne "\r${CLEAR_LINE}"
            action git "${repo_name} ${F_ERROR}󱋭${ALL_RESET}"
        fi
    else
        cd "${path}/${dir}" || return

        origin_url=$(git remote get-url origin 2>/dev/null)

        if [[ "${repo}" == "${origin_url%.git}" ]]; then
            action git "${repo_name} ${F_DEBUG}${ALL_RESET}"
            running git "pulling ${repo_name}..."
            if git pull --ff-only 2>&1 | {
                stdbuf -oL -eL cat | while IFS= read -r line; do
                    # Extract percentage from git progress output
                    if [[ "${line}" =~ ([0-9]+)%[[:space:]]*\(([0-9]+)/([0-9]+)\) ]]; then
                        percent="${BASH_REMATCH[1]}"
                        current="${BASH_REMATCH[2]}"
                        total="${BASH_REMATCH[3]}"
                        echo -ne "\r${CLEAR_LINE}${F_INFO}[git] ${F_ACCENT}${ARROW_MARK} ${repo_name}: ${F_SUCCESS}${percent}%${F_INFO} (${current}/${total})${ALL_RESET}"
                    fi
                done
            }; then
                echo -ne "\r${CLEAR_LINE}"
                action git "${repo_name} ${F_SUCCESS}󰄲${ALL_RESET}"
            else
                echo -ne "\r${CLEAR_LINE}"
                action git "${repo_name} pull failed ${F_ERROR}󱋭${ALL_RESET}"
            fi
        else
            action git "${repo_name} (${repo} != ${origin_url}) ${F_ERROR}󱋭${ALL_RESET}"
        fi

        cd - &>/dev/null || return
    fi

    if [[ "$#" -ge 1 ]]; then
        url="$1"
        shift 1

        cd "${path}/${dir}" || return

        if git remote get-url origin --all 2>/dev/null | grep "$url" &>/dev/null; then
            action git "${repo_name} pushurl -> ${url} ${F_DEBUG}󰄲${ALL_RESET}"
        else
            if git remote set-url --add origin "${url}" &>/dev/null; then
                action git "${repo_name} pushurl -> ${url} ${F_SUCCESS}󰄲${ALL_RESET}"
            else
                action git "${repo_name} pushurl -> ${url} ${F_ERROR}󱋭${ALL_RESET}"
            fi
        fi

        cd - &>/dev/null || return
    fi
}
