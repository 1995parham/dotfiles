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

proxy_start() {
    if [ $# -gt 1 ]; then
        return 1
    elif [ $# -eq 1 ]; then
        url="$1"
        # validate URL format (must be http:// or https:// followed by host)
        if ! [[ "$url" =~ ^https?://[a-zA-Z0-9]([a-zA-Z0-9.-]*[a-zA-Z0-9])?(:[0-9]+)?(/.*)?$ ]]; then
            echo -e "${F_ERROR}[proxy] ${F_NOTICE}invalid URL format: $url${ALL_RESET}"
            echo -e "${F_ERROR}[proxy] ${F_NOTICE}URL must start with http:// or https://${ALL_RESET}"
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

    echo -e "${F_SUCCESS}[proxy] ${F_NOTICE}setup proxy based on http proxy on $url${ALL_RESET}"
    echo -e "${F_SUCCESS}[proxy] ${F_NOTICE}press enter to continue or anything else to disable it${ALL_RESET}"
    read -r accept

    if [[ "${accept}" != "" ]]; then
        return 0
    fi

    echo
    curl --max-time 10 https://ipconfig.io/country || echo "💩"

    export ftp_proxy="$url"
    export http_proxy="$url"
    export https_proxy="$url"
    alias sudo='sudo -E'

    echo
    curl --max-time 10 https://ipconfig.io/country || proxy_stop
    echo
}

proxy_stop() {
    unset {http,https,ftp}_proxy || true
    unalias sudo 2>/dev/null || true

    echo -e "${F_SUCCESS}[proxy] ${F_NOTICE}all proxy script configurations are removed${ALL_RESET}"
}
