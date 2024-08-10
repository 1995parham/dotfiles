#!/bin/bash

# https://stackoverflow.com/questions/3822621/how-to-exit-if-a-command-failed
# set -eu
set -o pipefail

# Sometimes we lose ourselves to success, gaining approval, meeting the expectations of others.
# Sometimes the lost part of ourselves is faith, hope, a dream.
# It is so easy to lose a piece of ourselves and it can happen in a thousand different ways.

ip="$(curl -sL https://ipconfig.io/json --max-time 10 | jq -j '"\(.ip) - \(.country) (\(.asn_org))"' 2>/dev/null)"
if [ -n "$ip" ]; then
    echo "$ip" | tee /tmp/whereami.sh
else
    if [ -f /tmp/whereami.sh ]; then
        cat /tmp/whereami.sh
    else
        echo "💩"
    fi
fi
