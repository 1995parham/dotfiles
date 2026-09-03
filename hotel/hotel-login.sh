#!/usr/bin/env bash

# re-authenticate on a UniFi hotspot portal (RADIUS username/password) whenever the
# guest session lapses. launchd runs this every minute, see scripts/hotel.sh.
#
# the check stays on the local network on purpose: the controller's redirect listener
# (port 8882) hands out the portal url for our client and, once we follow it, either
# bounces us to the site we asked for (authorized) or serves the portal page
# (unauthorized). an internet-bound probe would be swallowed by any vpn that owns
# the default route. the Host header makes the bounce target an outside host, so an
# authorized client does not loop back onto the controller.

set -uo pipefail

service="${HOTEL_SERVICE:-Wi-Fi}"
credentials="${HOTEL_CREDENTIALS:-${XDG_CONFIG_HOME:-$HOME/.config}/hotel/credentials}"
force="${HOTEL_FORCE:-0}"

log() {
    printf '%s %s\n' "$(date '+%F %T')" "$*"
}

# read one key from the key=value credentials file
credential() {
    awk -F= -v key="$1" '$1 == key { print substr($0, length(key) + 2); exit }' "$credentials"
}

# escape a value for use inside a JSON string
json_escape() {
    printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}

# host part of a url (scheme://host[:port]/...)
url_host() {
    local rest=${1#*://}
    rest=${rest%%/*}
    printf '%s' "${rest%%:*}"
}

# follow the controller's redirect chain from $1 while it stays on the controller,
# sending the remaining arguments as curl options on the first hop only.
# sets `portal` to the last portal url seen and `status` to one of:
#   authorized   - the chain left the controller (bounced to the internet)
#   unauthorized - the controller served a page instead of redirecting away
#   unknown      - anything else
walk() {
    local url=$1 hops=0 answer code next
    shift
    local first=("$@")
    portal=""
    status="unknown"

    while [ "$hops" -lt 6 ]; do
        hops=$((hops + 1))
        if ! answer=$(curl "${curl_opts[@]}" ${first[@]+"${first[@]}"} -c "$jar" -b "$jar" -o /dev/null \
            -w '%{http_code} %{redirect_url}' "$url" 2>&1); then
            log "cannot reach $url: $answer"
            return 1
        fi
        code=${answer%% *}
        next=${answer#* }

        case "$url" in
        */guest/s/*) portal=$url ;;
        esac

        case "$code" in
        200)
            status="unauthorized"
            return 0
            ;;
        30[1237]) ;;
        *)
            log "unexpected answer $code from $url"
            return 1
            ;;
        esac

        if [ "$(url_host "$next")" != "$controller" ]; then
            status="authorized"
            return 0
        fi
        url=$next
        first=()
    done

    log "redirect loop on $controller"
    return 1
}

device=$(networksetup -listallhardwareports |
    awk -v svc="$service" '$0 == "Hardware Port: " svc { getline; print $2 }')
if [ -z "$device" ]; then
    log "cannot find the device behind '$service'"
    exit 1
fi

# not connected, nothing to do
if ! ipconfig getifaddr "$device" >/dev/null 2>&1; then
    exit 0
fi

if [ ! -r "$credentials" ]; then
    log "credentials file $credentials is missing"
    exit 1
fi

username=$(credential username)
password=$(credential password)
controller=$(url_host "$(credential controller)")
if [ -z "$username" ] || [ -z "$password" ] || [ -z "$controller" ]; then
    log "username, password or controller missing from $credentials"
    exit 1
fi

# the redirect listener fills in our ap and mac; the Host header sets the bounce target
entry="http://$controller:8882/hotspot-detect.html"
entry_opts=(-H 'Host: captive.apple.com')

# bind to the wi-fi device, otherwise a vpn's default route swallows the portal
curl_opts=(--silent --show-error --max-time 8 --interface "$device")

jar=$(mktemp)
trap 'rm -f "$jar"' EXIT

walk "$entry" "${entry_opts[@]}" || exit 1
if [ "$status" = "authorized" ] && [ "$force" != "1" ]; then
    exit 0
fi
if [ -z "$portal" ]; then
    log "the controller never pointed at a portal page (status: $status)"
    exit 1
fi

site=${portal#*/guest/s/}
site=${site%%/*}
login="${portal%%/guest/s/*}/guest/s/$site/login"

payload=$(printf '{"by":"radius","username":"%s","password":"%s"}' \
    "$(json_escape "$username")" "$(json_escape "$password")")

result=$(curl "${curl_opts[@]}" -c "$jar" -b "$jar" \
    -H 'Content-Type: text/plain;charset=UTF-8' \
    -H "Referer: $portal" \
    --data-raw "$payload" \
    -w '\n%{http_code}' "$login" 2>&1)
http=${result##*$'\n'}
body=${result%$'\n'*}

log "was $status, login as $username at $login: http $http${body:+ ($body)}"

sleep 2
walk "$entry" "${entry_opts[@]}" || exit 1
if [ "$status" = "authorized" ]; then
    log "authorized"
    exit 0
fi

log "still $status"
exit 1
