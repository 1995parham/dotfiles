#!/usr/bin/env bash

usage() {
    echo -n 'have temporary directories at your home'
    echo '
 _
| |_ _ __ ___  _ __
| __| |_ | _ \| |_ \
| |_| | | | | | |_) |
 \__|_| |_| |_| .__/
              |_|
  '
}

main_pacman() {
    configfile user-tmpfiles.d '' 'tmpfiles'
    configsystemd 'tmpfiles' systemd-tmpfiles-clean.timer.d

    systemctl --user enable --now systemd-tmpfiles-setup.service
    systemctl --user enable --now systemd-tmpfiles-clean.timer

    systemd-tmpfiles --user --create
}

main_brew() {
    copycat "tmpfiles" tmpfiles/me.1995parham.cleanup.plist "$HOME/Library/LaunchAgents/" 0
    copycat "tmpfiles" tmpfiles/cleanup.sh "/usr/local/bin/cleanup.sh" 1

    sudo chmod +x /usr/local/bin/cleanup.sh

    launchctl enable "gui/$UID/me.1995parham.cleanup"
    if ! launchctl print "gui/$UID/me.1995parham.cleanup" >/dev/null 2>&1; then
        launchctl bootstrap "gui/$UID" "$HOME/Library/LaunchAgents/me.1995parham.cleanup.plist"
    fi
    launchctl print "gui/$UID/me.1995parham.cleanup"
}

main() {
    return 0
}
