#!/usr/bin/env bash
#
# Battery charge for tmux's status-right, with a Nerd Font icon that follows
# the level (this replaces the battery cell of wezterm.lua's status bar).
# Prints nothing on a machine without a battery.

set -eu

# Print the Material Design battery glyph for a level and a charging state.
# The glyphs sit in plane 15 (U+F0079 full, U+F007A..U+F0082 for 10%..90%,
# U+F0084 charging); they are built as UTF-8 bytes so that this also runs on
# the bash 3.2 of macOS, which has no \U escape.
battery_icon() {
    local percent=$1 charging=$2 cp bucket

    if [[ "${charging}" == true ]]; then
        cp=$((0xF0084))
    else
        bucket=$((percent / 10 + 1))
        if ((bucket >= 10)); then
            cp=$((0xF0079))
        else
            cp=$((0xF0079 + bucket))
        fi
    fi

    # shellcheck disable=SC2059
    printf "$(printf '\\xf3\\x%x\\x%x\\x%x' \
        $((0x80 | (cp >> 12 & 0x3f))) \
        $((0x80 | (cp >> 6 & 0x3f))) \
        $((0x80 | (cp & 0x3f))))"
}

main() {
    local percent="" charging=false line dir status

    if command -v pmset >/dev/null 2>&1; then
        line="$(pmset -g batt 2>/dev/null | grep -m1 'InternalBattery' || true)"
        if [[ "${line}" =~ ([0-9]+)% ]]; then
            percent="${BASH_REMATCH[1]}"
        fi
        # "charging" and "charged" both mean AC; "discharging" has to be
        # ruled out first because it contains the word "charging".
        if [[ "${line}" != *discharging* && "${line}" == *charg* ]]; then
            charging=true
        fi
    else
        for dir in /sys/class/power_supply/BAT*; do
            [[ -r "${dir}/capacity" ]] || continue
            percent="$(<"${dir}/capacity")"
            status="$(cat "${dir}/status" 2>/dev/null || true)"
            if [[ "${status}" == Charging || "${status}" == Full ]]; then
                charging=true
            fi
            break
        done
    fi

    if [[ -z "${percent}" ]]; then
        return 0
    fi

    echo "$(battery_icon "${percent}" "${charging}") ${percent}%"
}

main
