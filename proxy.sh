#!/usr/bin/env bash
# https://about.gitlab.com/blog/2021/01/27/we-need-to-talk-no-proxy/

# by default it checkes for 127.0.0.1:2081 to find a proxy
# but you can also manually pass the proxy url.

proxy_start() {
    if [ $# -gt 1 ]; then
        return 1
    elif [ $# -eq 1 ]; then
        url="$1"
    else
        url="http://127.0.0.1:2081"

        if [[ -n $(command -v ss) ]]; then
            if ! (ss -tunl | grep :2081 &>/dev/null); then
                return 0
            fi
        elif [[ -n $(command -v netstat) ]]; then
            if ! (netstat -an | grep LISTEN | grep 2081 &>/dev/null); then
                return 0
            fi
        fi
    fi

    echo -e "\033[38;5;46m[proxy] \033[38;5;202msetup proxy based on http proxy on $url\033[39m"
    echo -e "\033[38;5;46m[proxy] \033[38;5;202mpress enter to continue or anything else to disable it\033[39m"
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

    echo -e "\033[38;5;46m[proxy] \033[38;5;202mall proxy script configurations are removed\033[39m"
}
