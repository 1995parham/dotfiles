#!/usr/bin/env bash
# waybar's custom/khal for the noctalia stdout plugin: the first event of today
# on the bar, the next 7 days in the tooltip
set -euo pipefail

command -v khal >/dev/null

"$(dirname "$0")/khal.py" |
    jq -c '{
        glyph: "calendar-event",
        text: .text,
        tips: [.tooltip | gsub("</?b>"; "") | split("\n")[] | select(. != "") | [., ""]]
    }'
