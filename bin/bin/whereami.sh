#!/bin/bash

# https://stackoverflow.com/questions/3822621/how-to-exit-if-a-command-failed
# set -eu
set -o pipefail

# Sometimes we lose ourselves to success, gaining approval, meeting the expectations of others.
# Sometimes the lost part of ourselves is faith, hope, a dream.
# It is so easy to lose a piece of ourselves and it can happen in a thousand different ways.

ip_country_url="http://ip-api.com/json/?fields=status,query,country,isp,proxy,hosting"

fallback_ip_country_url="http://ifconfig.io/all.json"

ip="$(curl -sL "$ip_country_url" --max-time 10 | jq -j '"\(.query) - \(.country) (\(.isp))\(if .proxy then " [VPN]" else "" end)\(if .hosting then " [Hosting]" else "" end)"' 2>/dev/null)"
if [ -n "$ip" ]; then
    echo "$ip" | tee /tmp/whereami.sh
else
    ip="$(curl -sL "$fallback_ip_country_url" --max-time 10 | jq -j '"Fallback: \(.ip) - \(.country_code)"' 2>/dev/null)"
    if [ -n "$ip" ]; then
        echo "$ip" | tee /tmp/whereami.sh
    else
        if [ -f /tmp/whereami.sh ]; then
            cat /tmp/whereami.sh
        else
            echo "💩"
        fi
    fi
fi
