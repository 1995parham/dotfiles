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
        if git clone "${repo}" "${path}/${dir}" &>/dev/null; then
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
            if git remote prune origin &>/dev/null && git pull --ff-only &>/dev/null; then
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
