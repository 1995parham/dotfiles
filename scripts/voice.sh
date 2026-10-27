#!/usr/bin/env bash
usage() {
    echo "offline dictation (whisper on the npu) and read-aloud (piper), with hyprland bindings"

    # shellcheck disable=1004,2016
    echo '
            _
__   _____ (_) ___ ___
\ \ / / _ \| |/ __/ _ \
 \ V / (_) | | (_|  __/
  \_/ \___/|_|\___\___|
  '
}

root=${root:?"root must be set"}

export dependencies=("python")

main_pacman() {
    # wtype types the transcript into the focused window, wl-clipboard reads
    # the selection, pipewire records and plays
    require_pacman wtype wl-clipboard pipewire libnotify

    # whisper runs on the intel npu (core ultra) when it has a driver and the
    # user may open /dev/accel/accel0 (group render, from the next login)
    if lspci 2>/dev/null | grep -q -i "neural\|npu"; then
        require_pacman intel-npu-driver
        sudo usermod -aG render "$USER"
    fi
}

main_xbps() {
    return 1
}

main_apt() {
    return 1
}

main_pkg() {
    return 1
}

main_brew() {
    return 1
}

main() {
    # editable, so a change in voice/voice.py is live without a reinstall
    action "voice" "pipx install --editable voice/"
    pipx install --force --editable "$root/voice"

    # whisper large-v3-turbo (openvino int8) and the piper voices, ~1 GB from
    # huggingface, once
    voice fetch

    msg "Super+T dictates (again to stop), Super+Shift+T reads the selection aloud, Super+I asks the local model"
}
