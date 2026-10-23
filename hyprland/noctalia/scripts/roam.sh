#!/usr/bin/env bash
# The roaming sing-box tunnel (keys hosts/simorgh/roam, sing-box-roam.service)
# for the noctalia stdout plugin, in JSON mode:
#   working   the German flag, with the exit it picked and its latency on hover
#   broken    a red cross: the service runs but nothing gets through it
#   stopped   hidden, so a tunnel turned off on purpose does not nag
# "Working" is a real request through the tunnel's mixed inbound, not the
# service state: a running sing-box with every exit dead looks active.
set -uo pipefail

unit=sing-box-roam.service
mixed=127.0.0.1:2080
api=http://127.0.0.1:9099
probe=https://www.gstatic.com/generate_204

# the shell profile exports a proxy; curl would honour it over -x
unset all_proxy ALL_PROXY http_proxy https_proxy HTTP_PROXY HTTPS_PROXY

if ! systemctl is-active --quiet "$unit"; then
    jq -nc '{visible: false}'
    exit 0
fi

exit_name="$(curl -s -m 3 "$api/proxies/auto" | jq -r '.now // "?"')"

if ms="$(curl -s -o /dev/null -m 8 -x "socks5h://$mixed" -w '%{time_total}' "$probe")"; then
    jq -nc --arg exit "$exit_name" --arg ms "$(awk -v t="$ms" 'BEGIN { printf "%d ms", t * 1000 }')" '{
        text: "🇩🇪",
        tips: [["Tunnel:", "up"], ["Exit:", $exit], ["Probe:", $ms]]
    }'
else
    jq -nc --arg exit "$exit_name" '{
        glyph: "x",
        glyphColor: "error",
        text: "DE",
        textColor: "error",
        tips: [["Tunnel:", "running, but nothing gets through"], ["Exit:", $exit]]
    }'
fi
