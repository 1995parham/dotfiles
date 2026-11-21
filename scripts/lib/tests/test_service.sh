#!/usr/bin/env bash

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=main.sh
source "${root}/../main.sh"

# the commands that reach the service manager are replaced: each prints what it was asked to
# do, so a test compares the command line and no service is touched.
# shellcheck disable=SC2032,SC2033
sudo() { echo "sudo $*"; }
# shellcheck disable=SC2032
systemctl() { echo "systemctl $*"; }
# shellcheck disable=SC2032
launchctl() { echo "launchctl $*"; }
sleep() { :; }

test_service_enable_system() {
    assert_equals "$(service_enable docker.service systemctl)" \
        "sudo systemctl enable --now docker.service"
}

test_service_enable_user() {
    assert_equals "$(service_enable --user mpd.service systemctl)" \
        "systemctl --user enable --now mpd.service"
}

test_service_enable_no_start() {
    assert_equals "$(service_enable --no-start docker.service systemctl)" \
        "sudo systemctl enable docker.service"
}

test_service_enable_user_no_start() {
    assert_equals "$(service_enable --user --no-start swayidle.service systemctl)" \
        "systemctl --user enable swayidle.service"
}

test_service_enable_options_in_any_order() {
    assert_equals "$(service_enable --no-start --user swayidle.service systemctl)" \
        "systemctl --user enable swayidle.service"
}

test_service_enable_unknown_option() {
    assert_retval service_enable --global docker.service systemctl 1 &>/dev/null
}

test_service_enable_unknown_manager() {
    assert_retval service_enable docker.service unknown 1
}

test_service_start_system() {
    assert_equals "$(service_start docker.service systemctl)" "systemctl start docker.service"
}

test_service_start_user() {
    assert_equals "$(service_start --user mpd.service systemctl)" "systemctl --user start mpd.service"
}

test_service_stop_user() {
    assert_equals "$(service_stop --user mpd.service systemctl)" "systemctl --user stop mpd.service"
}

test_service_restart_system() {
    assert_equals "$(service_restart docker.service systemctl)" "systemctl restart docker.service"
}

test_service_restart_user() {
    assert_equals "$(service_restart --user mpd.service systemctl)" "systemctl --user restart mpd.service"
}

test_service_launchctl_system() {
    assert_equals "$(service_start com.example.daemon launchctl)" \
        "sudo launchctl kickstart -k system/com.example.daemon"
}

test_service_launchctl_user() {
    assert_equals "$(service_start --user com.example.agent launchctl)" \
        "launchctl kickstart -k gui/${UID}/com.example.agent"
}

test_service_launchctl_enable_user() {
    assert_equals "$(service_enable --user com.example.agent launchctl)" \
        "launchctl enable gui/${UID}/com.example.agent
launchctl kickstart gui/${UID}/com.example.agent"
}

test_service_launchctl_enable_no_start() {
    assert_equals "$(service_enable --no-start com.example.daemon launchctl)" \
        "sudo launchctl enable system/com.example.daemon"
}

# shellcheck source=unit.sh
source "${root}/../unit.sh"
