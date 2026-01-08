#!/bin/bash

# https://stackoverflow.com/questions/3822621/how-to-exit-if-a-command-failed
# set -eu
set -o pipefail

# Sometimes we lose ourselves to success, gaining approval, meeting the expectations of others.
# Sometimes the lost part of ourselves is faith, hope, a dream.
# It is so easy to lose a piece of ourselves and it can happen in a thousand different ways.

ip_country_url="http://ip-api.com/json/?fields=status,query,country,isp,proxy,hosting"

fallback_ip_country_url="http://ifconfig.io/all.json"

cache_file="/tmp/whereami.sh"
timestamp_file="/tmp/whereami.timestamp"

relative_time() {
    local timestamp="$1"
    local now
    now=$(date +%s)
    local diff=$((now - timestamp))

    if [ $diff -lt 60 ]; then
        echo "now"
    elif [ $diff -lt 3600 ]; then
        echo "$((diff / 60))m ago"
    elif [ $diff -lt 86400 ]; then
        echo "$((diff / 3600))h ago"
    else
        echo "$((diff / 86400))d ago"
    fi
}

show_result() {
    local ip="$1"
    if [ -f "$timestamp_file" ]; then
        local timestamp
        timestamp=$(cat "$timestamp_file")
        echo "$ip @ $(relative_time "$timestamp")"
    else
        echo "$ip"
    fi
}

update_cache() {
    local ip="$1"
    echo "$ip" >"$cache_file"
    date +%s >"$timestamp_file"
}

ip="$(curl -sL "$ip_country_url" --max-time 10 | jq -j '"\(.query) - \(.country) (\(.isp))\(if .proxy then " [VPN]" else "" end)\(if .hosting then " [Hosting]" else "" end)"' 2>/dev/null)"
if [ -n "$ip" ]; then
    update_cache "$ip"
    show_result "$ip"
else
    ip="$(curl -sL "$fallback_ip_country_url" --max-time 10 | jq -j '"Fallback: \(.ip) - \(.country_code)"' 2>/dev/null)"
    if [ -n "$ip" ]; then
        update_cache "$ip"
        show_result "$ip"
    else
        if [ -f "$cache_file" ]; then
            show_result "$(cat "$cache_file")"
        else
            echo "💩"
        fi
    fi
fi
