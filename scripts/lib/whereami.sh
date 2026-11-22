#!/usr/bin/env bash

# Sometimes we lose ourselves to success, gaining approval, meeting the expectations of others.
# Sometimes the lost part of ourselves is faith, hope, a dream.
# It is so easy to lose a piece of ourselves and it can happen in a thousand different ways.

# whereami prints the current public IP along with country/ISP info and a
# cleanness score (100 = clean) scraped from Scamalytics.
# With -v/--verbose it also prints the country each geo-IP service reports.
# Returns 0 when a live source responded, 1 when only stale cache was available,
# 2 when no source and no cache could produce any output.
whereami() {
    local verbose=0 rc=0
    case "${1:-}" in
    -v | --verbose) verbose=1 ;;
    esac

    _whereami_summary || rc=$?
    if [ "$verbose" = 1 ]; then
        _whereami_verbose
    fi
    return "$rc"
}

# _whereami_verbose queries several geo-IP services in parallel and prints the
# country code each one reports, so mismatches between providers stand out.
_whereami_verbose() {
    local dir name
    dir="$(mktemp -d)" || return 0

    # Each probe prints a bare country code; anything else is shown as "-".
    _whereami_probe "$dir" ip-api "http://ip-api.com/json/?fields=countryCode" '.countryCode'
    _whereami_probe "$dir" ipinfo "https://ipinfo.io/json" '.country'
    _whereami_probe "$dir" ipwho.is "https://ipwho.is/" '.country_code'
    _whereami_probe "$dir" geojs "https://get.geojs.io/v1/ip/country.json" '.country'
    _whereami_probe "$dir" country.is "https://api.country.is" '.country'
    _whereami_probe "$dir" ifconfig.io "https://ifconfig.io/country_code" ''
    _whereami_probe "$dir" cloudflare "https://www.cloudflare.com/cdn-cgi/trace" 'loc'
    _whereami_probe "$dir" chatgpt.com "https://chatgpt.com/cdn-cgi/trace" 'loc'
    _whereami_probe "$dir" claude.ai "https://claude.ai/cdn-cgi/trace" 'loc'
    _whereami_probe "$dir" netflix "https://api.fast.com/netflix/speedtest/v2?https=true&token=YXNkZmFzZGxmbnNkYWZoYXNkZmhrYWxm&urlCount=1" '.client.location.country'
    wait

    for name in ip-api ipinfo ipwho.is geojs country.is ifconfig.io cloudflare chatgpt.com claude.ai netflix; do
        printf '  %-12s %s\n' "$name" "$(cat "$dir/$name" 2>/dev/null || echo -)"
    done
    rm -rf "$dir"
}

# _whereami_probe <dir> <name> <url> <selector> fetches one service in the
# background and writes its country code to <dir>/<name>. <selector> is a jq
# path for JSON replies, a key for Cloudflare "key=value" traces (no leading
# dot), or empty for plain-text replies.
_whereami_probe() {
    local dir="$1" name="$2" url="$3" sel="$4"
    (
        local out
        case "$sel" in
        '') out="$(curl -sL --max-time 8 "$url" 2>/dev/null)" ;;
        .*) out="$(curl -sL --max-time 8 "$url" 2>/dev/null | jq -r "$sel // empty" 2>/dev/null)" ;;
        *) out="$(curl -sL --max-time 8 "$url" 2>/dev/null | sed -n "s/^${sel}=//p")" ;;
        esac
        # Only accept a two-letter code (rejects challenge pages and errors).
        if [[ "$out" =~ ^[A-Za-z]{2}$ ]]; then
            echo "$out" | tr "[:lower:]" "[:upper:]" >"$dir/$name"
        fi
    ) &
}

_whereami_summary() {
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
    if [ -f "$cache" ] && [ $(($(date +%s) - $(date -r "$cache" +%s))) -lt "$ttl" ]; then
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
