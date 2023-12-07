#!/bin/bash

# https://stackoverflow.com/questions/3822621/how-to-exit-if-a-command-failed
set -eu
set -o pipefail

# Sometimes we lose ourselves to success, gaining approval, meeting the expectations of others.
# Sometimes the lost part of ourselves is faith, hope, a dream.
# It is so easy to lose a piece of ourselves and it can happen in a thousand different ways.

curl -sL http://ipconfig.io/json |
	jq -j '"\(.ip) - \(.country) (\(.asn_org))"' 2>/dev/null |
	tee /tmp/whereami.sh

if [ "${PIPESTATUS[0]}" != "0" ]; then
	cat /tmp/whereami.sh
fi
