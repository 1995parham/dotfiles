#!/bin/bash

set -eu

echo '
Sometimes we lose ourselves to success, gaining approval, meeting the expectations of others.
Sometimes the lost part of ourselves is faith, hope, a dream.
It is so easy to lose a piece of ourselves and it can happen in a thousand different ways.
'

curl -sL http://ipconfig.io/json | jq '.ip, .country , .asn_org'
