#!/usr/bin/env bash
# Set a random picture of a directory as the wallpaper of every screen, the
# macOS side of noctalia's wallpaper automation (hyprland/noctalia/wallpaper.toml).
# launchd runs it every 10 minutes (wallpapers/me.1995parham.wallpaper.plist).
# lock.jpg is left out: on Linux it is the lock screen only.
#
# NSWorkspace from JXA rather than System Events, which needs an Automation
# grant that a launchd agent cannot ask for. It sets the current Space of each
# screen; the other Spaces follow on the next tick spent on them.
#
# Usage: rotate.sh [dir]
set -euo pipefail

dir="${1:-$HOME/Pictures/Barcelona}"

pictures=()
while IFS= read -r -d '' picture; do
    pictures+=("$picture")
done < <(find "$dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.heic' \) ! -name 'lock.jpg' -print0)

if [ "${#pictures[@]}" -eq 0 ]; then
    echo "no pictures in $dir, run wallpapers/barcelona.sh" >&2
    exit 1
fi

picture="${pictures[RANDOM % ${#pictures[@]}]}"

osascript -l JavaScript - "$picture" <<'EOF'
ObjC.import("AppKit");
function run(argv) {
    const url = $.NSURL.fileURLWithPath(argv[0]);
    const workspace = $.NSWorkspace.sharedWorkspace;
    const screens = $.NSScreen.screens;
    for (let i = 0; i < screens.count; i++) {
        const options = $({ NSWorkspaceDesktopImageScalingKey: $.NSImageScaleProportionallyUpOrDown, NSWorkspaceDesktopImageAllowClippingKey: true });
        workspace.setDesktopImageURLForScreenOptionsError(url, screens.objectAtIndex(i), options, null);
    }
}
EOF
echo "$(date '+%F %T') $picture"
