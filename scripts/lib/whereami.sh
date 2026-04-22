#!/usr/bin/env bash

# Sometimes we lose ourselves to success, gaining approval, meeting the expectations of others.
# Sometimes the lost part of ourselves is faith, hope, a dream.
# It is so easy to lose a piece of ourselves and it can happen in a thousand different ways.

# whereami prints the current public IP along with country/ISP info.
# Returns 0 when a live source responded, 1 when only stale cache was available,
# 2 when no source and no cache could produce any output.
whereami() {
    local ip_country_url="http://ip-api.com/json/?fields=status,query,country,isp,proxy,hosting"
    local fallback_ip_country_url="http://ifconfig.io/all.json"
    local iran_access_ip_url="https://ipnumberia.com/"
    local cache_file="/tmp/whereami.sh"
    local timestamp_file="/tmp/whereami.timestamp"
    local ip name label

    ip="$(curl -sL "$ip_country_url" --max-time 10 2>/dev/null | jq -j '"\(.query) - \(.country) (\(.isp))\(if .proxy then " [VPN]" else "" end)\(if .hosting then " [Hosting]" else "" end)"' 2>/dev/null)"
    if [ -n "$ip" ]; then
        _whereami_update_cache "$ip" "$cache_file" "$timestamp_file"
        _whereami_show_result "$ip" "$timestamp_file"
        return 0
    fi

    ip="$(curl -sL "$fallback_ip_country_url" --max-time 10 2>/dev/null | jq -j '"Fallback: \(.ip) - \(.country_code)"' 2>/dev/null)"
    if [ -n "$ip" ]; then
        _whereami_update_cache "$ip" "$cache_file" "$timestamp_file"
        _whereami_show_result "$ip" "$timestamp_file"
        return 0
    fi

    ip="$(curl -sL "$iran_access_ip_url" --max-time 10 2>/dev/null | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -1)"
    if [ -n "$ip" ]; then
        name="$(_whereami_name_ip "$ip")"
        label="${name:-fucked up}"
        _whereami_update_cache "$ip - Iran Access ($label)" "$cache_file" "$timestamp_file"
        _whereami_show_result "$ip - Iran Access ($label)" "$timestamp_file"
        return 0
    fi

    if [ -f "$cache_file" ]; then
        _whereami_show_result "$(cat "$cache_file")" "$timestamp_file"
        return 1
    fi

    echo "💩"
    return 2
}

_whereami_name_ip() {
    case "$1" in
    188.121.146.46) echo "home sweet home" ;;
    89.45.59.128) echo "topol on his way" ;;
    *) echo "" ;;
    esac
}

_whereami_relative_time() {
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

_whereami_show_result() {
    local ip="$1"
    local timestamp_file="$2"
    if [ -f "$timestamp_file" ]; then
        local timestamp
        timestamp=$(cat "$timestamp_file")
        echo "$ip @ $(_whereami_relative_time "$timestamp")"
    else
        echo "$ip"
    fi
}

_whereami_update_cache() {
    local ip="$1"
    local cache_file="$2"
    local timestamp_file="$3"
    echo "$ip" >"$cache_file"
    date +%s >"$timestamp_file"
}
