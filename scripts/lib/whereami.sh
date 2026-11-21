#!/usr/bin/env bash

# Sometimes we lose ourselves to success, gaining approval, meeting the expectations of others.
# Sometimes the lost part of ourselves is faith, hope, a dream.
# It is so easy to lose a piece of ourselves and it can happen in a thousand different ways.

# whereami prints the current public IP along with country/ISP info and a
# cleanness score (100 = clean) scraped from Scamalytics.
# Returns 0 when a live source responded, 1 when only stale cache was available,
# 2 when no source and no cache could produce any output.
whereami() {
    local ip_country_url="http://ip-api.com/json/?fields=status,query,country,isp,proxy,hosting"
    local fallback_ip_country_url="http://ifconfig.io/all.json"
    local iran_access_ip_url="https://ipmyp.ir/"
    local cache_file="/tmp/whereami.sh"
    local timestamp_file="/tmp/whereami.timestamp"
    local ip name label score

    ip="$(curl -sL "$ip_country_url" --max-time 10 2>/dev/null | jq -j '"\(.query) - \(.country) (\(.isp))\(if .proxy then " [VPN]" else "" end)\(if .hosting then " [Hosting]" else "" end)"' 2>/dev/null)" || ip=""
    if [ -n "$ip" ]; then
        score="$(_whereami_clean_score "$ip")"
        ip="${ip}${score:+ [$score]}"
        _whereami_update_cache "$ip" "$cache_file" "$timestamp_file"
        _whereami_show_result "$ip" "$timestamp_file"
        return 0
    fi

    ip="$(curl -sL "$fallback_ip_country_url" --max-time 10 2>/dev/null | jq -j '"Fallback: \(.ip) - \(.country_code)"' 2>/dev/null)" || ip=""
    if [ -n "$ip" ]; then
        score="$(_whereami_clean_score "$ip")"
        ip="${ip}${score:+ [$score]}"
        _whereami_update_cache "$ip" "$cache_file" "$timestamp_file"
        _whereami_show_result "$ip" "$timestamp_file"
        return 0
    fi

    ip="$(curl -sL "$iran_access_ip_url" --max-time 10 2>/dev/null | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -1)" || ip=""
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

# _whereami_clean_score prints "clean N/100" for the first IPv4 address found in
# its argument, or nothing when the score cannot be fetched. N is 100 minus the
# Scamalytics fraud score (100 = clean). Results are cached per IP for 6 hours so
# frequent callers (the tmux status bar) do not hammer Scamalytics.
_whereami_clean_score() {
    local addr fraud cache ttl=21600
    addr="$(grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' <<<"$1" | head -1)"
    [ -n "$addr" ] || return 0

    cache="/tmp/whereami.score.${addr}"
    if [ -f "$cache" ] && [ $(($(date +%s) - $(date -r "$cache" +%s))) -lt $ttl ]; then
        cat "$cache"
        return 0
    fi

    fraud="$(curl -sL --max-time 8 -A "Mozilla/5.0" "https://scamalytics.com/ip/${addr}" 2>/dev/null |
        grep -oE 'Fraud Score: *[0-9]+' | head -1 | grep -oE '[0-9]+$')" || fraud=""
    if [ -z "$fraud" ]; then
        # Serve a stale score rather than nothing when the lookup fails.
        [ -f "$cache" ] && cat "$cache"
        return 0
    fi

    echo "clean $((100 - fraud))/100" | tee "$cache"
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

    if [ "${diff}" -lt 60 ]; then
        echo "now"
    elif [ "${diff}" -lt 3600 ]; then
        echo "$((diff / 60))m ago"
    elif [ "${diff}" -lt 86400 ]; then
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
