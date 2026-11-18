#!/usr/bin/env bash
#
# The date and world clocks of tmux's status-right. This is the right status
# that wezterm.lua drew in Lua, moved here because Ghostty has no status bar:
#
#    Thu 19 Nov · 28 Aba 1405    03:11 +0330    15:41 PST    18:41 EST
#
# The date is Tehran's (the home zone), Gregorian and Jalali. No seconds: tmux
# runs this once per status-interval, so they would only ever be stale.

set -eu

# Nerd Font glyphs as UTF-8 bytes, to keep this file plain ASCII:
# fa_calendar (U+F073) and fa_clock_o (U+F017).
calendar=$'\xef\x81\xb3'
clock=$'\xef\x80\x97'

main() {
    local out jalali zone

    out="${calendar}  $(TZ=Asia/Tehran date '+%a %d %b')"

    # jdate comes with jcal, which not every machine has.
    if command -v jdate >/dev/null 2>&1; then
        jalali="$(TZ=Asia/Tehran jdate '+%e %b %Y' 2>/dev/null || true)"
        if [[ -n "${jalali}" ]]; then
            out+=" · ${jalali# }"
        fi
    fi

    for zone in Asia/Tehran America/Los_Angeles America/New_York; do
        out+="   ${clock}  $(TZ="${zone}" date '+%H:%M %Z')"
    done

    echo "${out}"
}

main
