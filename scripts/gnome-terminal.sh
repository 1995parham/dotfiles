#!/usr/bin/env bash

usage() {
    echo -n 'catppuccin mocha theme for gnome terminal'

    echo '
  __ _ _ __   ___  _ __ ___   ___
 / _` | `_ \ / _ \| `_ ` _ \ / _ \
| (_| | | | | (_) | | | | | |  __/
 \__, |_| |_|\___/|_| |_| |_|\___|
 |___/
  '
}

# catppuccin mocha palette
# https://catppuccin.com/palette
readonly BG="#1e1e2e"
readonly FG="#cdd6f4"

readonly BLACK="#45475a"
readonly RED="#f38ba8"
readonly GREEN="#a6e3a1"
readonly YELLOW="#f9e2af"
readonly BLUE="#89b4fa"
readonly PURPLE="#cba6f7"
readonly CYAN="#94e2d5"
readonly WHITE="#bac2de"

readonly BRIGHT_BLACK="#585b70"
readonly BRIGHT_RED="#f38ba8"
readonly BRIGHT_GREEN="#a6e3a1"
readonly BRIGHT_YELLOW="#f9e2af"
readonly BRIGHT_BLUE="#89b4fa"
readonly BRIGHT_PURPLE="#cba6f7"
readonly BRIGHT_CYAN="#94e2d5"
readonly BRIGHT_WHITE="#a6adc8"

readonly CURSOR_BG="#f5e0dc"
readonly CURSOR_FG="#1e1e2e"

_get_default_profile() {
    gsettings get org.gnome.Terminal.ProfilesList default 2>/dev/null | tr -d "'"
}

_get_profile_path() {
    local profile_id="$1"
    echo "/org/gnome/terminal/legacy/profiles:/:${profile_id}/"
}

main_apt() {
    require_apt dconf-cli
}

main() {
    if ! command -v dconf &>/dev/null; then
        msg "dconf is required but not found" "error"
        return 1
    fi

    if ! command -v gnome-terminal &>/dev/null; then
        msg "gnome-terminal is not installed" "error"
        return 1
    fi

    local profile_id
    profile_id=$(_get_default_profile)

    if [[ -z "$profile_id" ]]; then
        # try to get the first profile from the list
        local profile_list
        profile_list=$(gsettings get org.gnome.Terminal.ProfilesList list 2>/dev/null)
        profile_id=$(echo "$profile_list" | tr -d "[]' " | cut -d',' -f1)
    fi

    if [[ -z "$profile_id" ]]; then
        msg "no gnome-terminal profile found" "error"
        return 1
    fi

    local path
    path=$(_get_profile_path "$profile_id")

    msg "applying catppuccin mocha to profile ${profile_id}" "info"

    # profile name
    dconf write "${path}visible-name" "'Catppuccin Mocha'"

    # colors
    dconf write "${path}use-theme-colors" "false"
    dconf write "${path}foreground-color" "'${FG}'"
    dconf write "${path}background-color" "'${BG}'"

    # cursor
    dconf write "${path}cursor-colors-set" "true"
    dconf write "${path}cursor-foreground-color" "'${CURSOR_FG}'"
    dconf write "${path}cursor-background-color" "'${CURSOR_BG}'"

    # bold color
    dconf write "${path}bold-color-same-as-fg" "true"

    # palette
    dconf write "${path}palette" \
        "['${BLACK}', '${RED}', '${GREEN}', '${YELLOW}', '${BLUE}', '${PURPLE}', '${CYAN}', '${WHITE}', '${BRIGHT_BLACK}', '${BRIGHT_RED}', '${BRIGHT_GREEN}', '${BRIGHT_YELLOW}', '${BRIGHT_BLUE}', '${BRIGHT_PURPLE}', '${BRIGHT_CYAN}', '${BRIGHT_WHITE}']"

    # font
    dconf write "${path}use-system-font" "false"
    dconf write "${path}font" "'JetBrainsMono Nerd Font 14'"

    # transparency
    dconf write "${path}use-transparent-background" "false"

    # scrollback
    dconf write "${path}scrollback-unlimited" "true"

    ok "gnome-terminal" "catppuccin mocha theme applied"
}
