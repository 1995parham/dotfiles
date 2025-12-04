#!/usr/bin/env bash
usage() {
    echo "RaspberryPI is like koochooloo"

    # shellcheck disable=1004,2016
    echo '
          ┌──────────────────────────────────────┐
          │    ┌──────────────┐                  │
          │    │   Broadcom   │                  │
          │    │   BCM2711    │                  │
          │    └──────────────┘                  │
          │    ┌──────────────┐                  │
GPIO  ┌───┤    │ LPDDR4 RAM   │                  │
Header│###│    └──────────────┘                  │
40-pin│###│                                      │
          │  ┌─────────┐ ┌─────────┐             │
          │  │CSI Cam  │ │DSI Disp │             │
          │  └─────────┘ └─────────┘             │
          │                                      │
          │ ┌─────┐ ┌─────┐                      │
          │ │mHDMI│ │mHDMI│   ┌───────┐ ┌──────┐ │
          │ │  0  │ │  1  │   │ USB3  │ │ USB3 │ │
          │ └─────┘ └─────┘   └───────┘ └──────┘ │
          │     ┌─────┐    ┌───────┐ ┌──────┐    │
          │     │ USB │    │ USB2  │ │ USB2 │    │
          │     │  C  │    └───────┘ └──────┘    │
          │     └─────┘        ┌──────────┐      │
          │                   ┌┤ Ethernet │      │
          │   ┌──────────┐    │└──────────┘      │
          │   │  WiFi/BT │    │                  │
          │   └──────────┘    │                  │
          └───────────────────┴──────────────────┘
  '
}

pre_main() {
    return 0
}

main_pacman() {
    return 1
}

main_apt() {
    return 1
}

main_brew() {
    require_brew_cask raspberry-pi-imager
}

main() {
    return 0
}

main_parham() {
    return 0
}
