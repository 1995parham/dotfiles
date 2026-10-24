#!/usr/bin/env bash

usage() {
    echo "rotate the Barcelona wallpapers on macOS, as noctalia does on hyprland"
    echo
    echo "fetches ~/Pictures/Barcelona (wallpapers/barcelona.sh) once, then a launchd"
    echo "agent sets a random one of them on every screen each 10 minutes."
    echo
    echo "options:"
    echo "  --off    remove the launchd agent, the current wallpaper stays"

    cat <<'EOF'

               _ _
__      ____ _| | |_ __   __ _ _ __   ___ _ __
\ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__|
 \ V  V / (_| | | | |_) | (_| | |_) |  __/ |
  \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|
                  |_|         |_|
EOF
}

root=${root:?"root must be set"}

wallpaper_label="me.1995parham.wallpaper"
wallpaper_dir="$HOME/Pictures/Barcelona"
wallpaper_off=false

pre_main() {
    while [ $# -gt 0 ]; do
        case "$1" in
        --off)
            wallpaper_off=true
            shift
            ;;
        *)
            msg "unknown option: $1" "error"
            return 1
            ;;
        esac
    done
}

wallpaper_agent() {
    echo "$HOME/Library/LaunchAgents/${wallpaper_label}.plist"
}

main_brew() {
    local agent
    agent=$(wallpaper_agent)

    if [ "$wallpaper_off" = true ]; then
        action "wallpaper" "removing the launchd agent $wallpaper_label"
        launchctl bootout "gui/$UID/$wallpaper_label" 2>/dev/null || true
        rm -f "$agent"
        return 0
    fi

    # ~110 MB of Commons originals, so they are fetched rather than kept here.
    if [[ ! -f "$wallpaper_dir/lock.jpg" ]]; then
        action "wallpaper" "fetching the Barcelona wallpapers into $wallpaper_dir"
        bash "${root}/wallpapers/barcelona.sh" "$wallpaper_dir"
    fi

    mkdir -p "$HOME/Library/LaunchAgents" "$HOME/Library/Logs"

    action "wallpaper" "installing the launchd agent $wallpaper_label"
    sed -e "s|@ROOT@|$root|g" -e "s|@HOME@|$HOME|g" \
        "$root/wallpapers/${wallpaper_label}.plist" >"$agent"

    launchctl bootout "gui/$UID/$wallpaper_label" 2>/dev/null || true
    if ! launchctl bootstrap "gui/$UID" "$agent"; then
        msg "failed to load $agent" "error"
        return 1
    fi

    ok "wallpaper" "the wallpaper changes every 10 minutes, log: ~/Library/Logs/wallpaper.log"
}

main() {
    return 0
}
