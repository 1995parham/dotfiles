#!/usr/bin/env bash
#
# The date and world clocks of tmux's status-right. This is the right status
# that wezterm.lua drew in Lua, moved here because Ghostty has no status bar:
#
#    Thu 19 Nov · 28 Aba 1405    Tehran 03:11    Madrid 00:41    New York 18:41
#
# The date is Tehran's (the home zone), Gregorian and Jalali. No seconds: tmux
# runs this once per status-interval, so they would only ever be stale.

set -eu

# Nerd Font glyphs as UTF-8 bytes, to keep this file plain ASCII:
# fa_calendar (U+F073) and fa_clock_o (U+F017).
calendar=$'\xef\x81\xb3'
clock=$'\xef\x80\x97'

main() {
    local out jalali zone city

    out="${calendar}  $(TZ=Asia/Tehran date '+%a %d %b')"

    # jdate comes with jcal, which not every machine has.
    if command -v jdate >/dev/null 2>&1; then
        jalali="$(TZ=Asia/Tehran jdate '+%e %b %Y' 2>/dev/null || true)"
        if [[ -n "${jalali}" ]]; then
            out+=" · ${jalali# }"
        fi
    fi

    # Each clock is a city name and the time there. The zone abbreviation
    # is not shown: Tehran has none (date prints +0330).
    for zone in Asia/Tehran Europe/Madrid America/New_York; do
        city="${zone#*/}"
        out+="   ${clock}  ${city//_/ } $(TZ="${zone}" date '+%H:%M')"
    done

    echo "${out}"
}

main
