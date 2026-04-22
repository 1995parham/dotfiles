#!/usr/bin/env bash
# https://about.gitlab.com/blog/2021/01/27/we-need-to-talk-no-proxy/

# by default it checkes for 127.0.0.1:2081 to find a proxy
# but you can also manually pass the proxy url.

source="$0"
if [[ -n "${BASH_SOURCE[0]}" ]]; then
    source="${BASH_SOURCE[0]}"
fi

if ! source "$(dirname "$source")/message.sh" 2>/dev/null; then
    if [ -n "$DOTFILES_ROOT" ]; then
        # shellcheck source=message.sh
        source "$DOTFILES_ROOT/scripts/lib/message.sh"
    fi
fi

if ! source "$(dirname "$source")/whereami.sh" 2>/dev/null; then
    if [ -n "$DOTFILES_ROOT" ]; then
        # shellcheck source=whereami.sh
        source "$DOTFILES_ROOT/scripts/lib/whereami.sh"
    fi
fi

# When this file is sourced (e.g. by start.sh), automatically override sudo
# to preserve environment if proxy env vars are already set.
# This handles the case where proxy_start was run in an interactive shell
# and start.sh is a new process that inherits the env vars but not functions.
if [ -n "${http_proxy:-}" ] || [ -n "${https_proxy:-}" ]; then
    sudo() { command sudo -E "$@"; }
fi

proxy_start() {
    if [ $# -gt 1 ]; then
        return 1
    elif [ $# -eq 1 ]; then
        url="$1"
        # validate URL format (must be http://, https://, or socks[4|4a|5|5h]:// followed by host)
        if ! [[ "$url" =~ ^(https?|socks(4a?|5h?)?)://[a-zA-Z0-9]([a-zA-Z0-9.-]*[a-zA-Z0-9])?(:[0-9]+)?(/.*)?$ ]]; then
            echo -e "${F_ERROR}[proxy] ${F_NOTICE}invalid URL format: $url${ALL_RESET}"
            echo -e "${F_ERROR}[proxy] ${F_NOTICE}URL must start with http://, https://, or socks[4|4a|5|5h]://${ALL_RESET}"
            echo -e "${F_ERROR}[proxy] ${F_NOTICE}supported protocols:${ALL_RESET}"
            echo -e "${F_ERROR}[proxy] ${F_NOTICE}  http://     HTTP proxy${ALL_RESET}"
            echo -e "${F_ERROR}[proxy] ${F_NOTICE}  https://    HTTP proxy over TLS${ALL_RESET}"
            echo -e "${F_ERROR}[proxy] ${F_NOTICE}  socks4://   SOCKS4 (no DNS, no auth)${ALL_RESET}"
            echo -e "${F_ERROR}[proxy] ${F_NOTICE}  socks4a://  SOCKS4a (proxy resolves DNS)${ALL_RESET}"
            echo -e "${F_ERROR}[proxy] ${F_NOTICE}  socks5://   SOCKS5 (client resolves DNS locally, then sends IP)${ALL_RESET}"
            echo -e "${F_ERROR}[proxy] ${F_NOTICE}  socks5h://  SOCKS5 (proxy resolves DNS remotely, prevents DNS leaks)${ALL_RESET}"
            return 1
        fi
    else
        url="http://127.0.0.1:2081"

        if command -v ss >/dev/null 2>&1; then
            if ! (ss -tunl | grep :2081 &>/dev/null); then
                return 0
            fi
        elif command -v netstat >/dev/null 2>&1; then
            if ! (netstat -an | grep LISTEN | grep 2081 &>/dev/null); then
                return 0
            fi
        fi
    fi

    echo -e "${F_SUCCESS}[proxy] ${F_NOTICE}setup proxy on $url${ALL_RESET}"
    echo -e "${F_SUCCESS}[proxy] ${F_NOTICE}press enter to continue or anything else to disable it${ALL_RESET}"
    read -r accept

    if [[ "${accept}" != "" ]]; then
        return 0
    fi

    echo
    echo -e "${F_SUCCESS}[proxy] ${F_NOTICE}before:${ALL_RESET} $(whereami)"

    export http_proxy="$url"
    export https_proxy="$url"
    export all_proxy="$url"
    # Use a function instead of an alias so it works in scripts
    # (aliases don't expand in non-interactive shells).
    sudo() { command sudo -E "$@"; }

    # On Arch Linux, pass proxy env vars to yay's sudo calls
    if command -v yay >/dev/null 2>&1; then
        alias yay='yay --sudoflags "-E"'
    fi

    echo
    if ! result="$(whereami)"; then
        echo -e "${F_ERROR}[proxy] ${F_NOTICE}after:${ALL_RESET} $result"
        proxy_stop
    else
        echo -e "${F_SUCCESS}[proxy] ${F_NOTICE}after:${ALL_RESET} $result"
    fi
    echo
}

proxy_stop() {
    unset {http,https,all}_proxy || true
    unset -f sudo 2>/dev/null || true
    unalias yay 2>/dev/null || true

    echo -e "${F_SUCCESS}[proxy] ${F_NOTICE}all proxy script configurations are removed${ALL_RESET}"
}
