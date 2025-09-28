#!/usr/bin/env bash

# Base color palette - RGB values for better color consistency
export F_CYAN="\033[38;2;0;255;255m"
export F_GREEN="\033[38;2;127;230;127m"
export F_RED="\033[38;2;255;127;127m"
export F_ORANGE="\033[38;2;255;165;0m"
export F_YELLOW="\033[38;2;255;255;25m"
export F_GRAY="\033[38;2;90;90;90m"
export F_BLUE="\033[38;2;0;191;255m"
export F_PURPLE="\033[38;2;128;128;255m"
export F_PINK="\033[38;2;255;128;255m"
export F_WHITE="\033[38;2;255;255;255m"
export F_BLACK="\033[38;2;0;0;0m"

# Bright variants for emphasis
export F_BRIGHT_GREEN="\033[38;2;0;255;0m"
export F_BRIGHT_RED="\033[38;2;255;0;0m"
export F_BRIGHT_YELLOW="\033[38;2;255;255;0m"
export F_BRIGHT_BLUE="\033[38;2;0;128;255m"
export F_BRIGHT_CYAN="\033[38;2;0;255;255m"

# Semantic colors for different purposes
export F_SUCCESS="${F_BRIGHT_GREEN}"
export F_ERROR="${F_BRIGHT_RED}"
export F_WARNING="${F_BRIGHT_YELLOW}"
export F_INFO="${F_BRIGHT_BLUE}"
export F_NOTICE="${F_ORANGE}"
export F_DEBUG="${F_GRAY}"
export F_HIGHLIGHT="${F_BRIGHT_CYAN}"
export F_ACCENT="${F_PURPLE}"

# Text formatting
export BOLD_ON="\033[1m"
export BOLD_OFF="\033[0m"
export ITALIC_ON="\033[3m"
export ITALIC_OFF="\033[23m"
export UNDERLINE_ON="\033[4m"
export UNDERLINE_OFF="\033[24m"
export DIM_ON="\033[2m"
export DIM_OFF="\033[22m"

# Background colors
export BG_RED="\033[48;2;255;127;127m"
export BG_GREEN="\033[48;2;127;230;127m"
export BG_YELLOW="\033[48;2;255;255;25m"
export BG_BLUE="\033[48;2;0;191;255m"
export BG_GRAY="\033[48;2;90;90;90m"

# Reset and special formatting
export F_RESET="\033[39m"
export ALL_RESET="\033[0m"
export CLEAR_LINE="\033[2K"

# Utility function for colored text
function colorize() {
    local color=$1
    local text=$2
    echo -e "${color}${text}${ALL_RESET}"
}

# Enhanced progress indicators
export SPINNER_CHARS="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
export PROGRESS_FULL="█"
export PROGRESS_EMPTY="░"
export CHECK_MARK="✓"
export CROSS_MARK="✗"
export WARNING_MARK="⚠"
export INFO_MARK="ⓘ"
export ARROW_MARK="⇒"
export BULLET_MARK="•"

function yes_or_no() {
    yes_to_all=${yes_to_all:-0}
    if [[ "${yes_to_all}" == 1 ]]; then
        return 0
    fi

    local module=$1
    shift

    while true; do
        read -r -p "$(echo -e "${F_HIGHLIGHT}[${module}] ${F_NOTICE}$*${F_RESET} [${F_SUCCESS}y${F_RESET}/${F_ERROR}n${F_RESET}]: ")" yn
        case ${yn} in
        [Yy]*) return 0 ;;
        [Nn]*)
            echo -e "${F_WARNING}Aborted${F_RESET}"
            return 1
            ;;
        *) ;;
        esac
    done
}

function message() {
    local module=$1
    local message=${2:-""}
    local severity=${3:-"info"}

    local severity_prefix=""
    local module_color="${F_INFO}"
    local message_color="${F_RESET}"

    case ${severity} in
    info)
        module_color="${F_INFO}"
        message_color="${F_RESET}"
        ;;
    error)
        severity_prefix="${F_ERROR}${BOLD_ON} (${CROSS_MARK} error) ${ALL_RESET}"
        module_color="${F_ERROR}"
        message_color="${F_ERROR}"
        ;;
    notice)
        severity_prefix="${F_NOTICE}${BOLD_ON} (${INFO_MARK} notice) ${ALL_RESET}"
        module_color="${F_NOTICE}"
        message_color="${F_NOTICE}"
        ;;
    warn)
        severity_prefix="${F_WARNING}${BOLD_ON} (${WARNING_MARK} warn) ${ALL_RESET}"
        module_color="${F_WARNING}"
        message_color="${F_WARNING}"
        ;;
    success)
        severity_prefix="${F_SUCCESS}${BOLD_ON} (${CHECK_MARK} success) ${ALL_RESET}"
        module_color="${F_SUCCESS}"
        message_color="${F_SUCCESS}"
        ;;
    debug)
        severity_prefix="${F_DEBUG}${DIM_ON} (🐛 debug) ${ALL_RESET}"
        module_color="${F_DEBUG}"
        message_color="${F_DEBUG}"
        ;;
    *)
        module_color="${F_INFO}"
        message_color="${F_RESET}"
        ;;
    esac

    echo -e "${severity_prefix}${module_color}[${module}] ${message_color}${message}${ALL_RESET}"
}

function running() {
    local module=$1
    shift

    echo -e "${F_HIGHLIGHT}[${module}] ${F_ACCENT}${ARROW_MARK} $*${ALL_RESET}"
}

function action() {
    local module=$1
    shift

    echo -e "${F_WARNING}[${module}] ${F_ACCENT}${ARROW_MARK} $*${ALL_RESET}"
}

function ok() {
    local module=$1
    shift

    echo -e "${F_SUCCESS}[${module}] ${F_ACCENT}${ARROW_MARK} $*${ALL_RESET}"
}

# Additional utility functions for better UX
function progress_bar() {
    local current=$1
    local total=$2
    local width=${3:-50}
    local prefix=${4:-"Progress"}

    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))

    echo -e "\r${F_INFO}${prefix}: ${F_SUCCESS}"
    printf "%*s" ${filled} | tr ' ' "${PROGRESS_FULL}"
    echo -e "${F_GRAY}"
    printf "%*s" ${empty} | tr ' ' "${PROGRESS_EMPTY}"
    printf "${F_INFO} %d%% (%d/%d)${ALL_RESET}" "${percentage}" "${current}" "${total}"
}

function spinner() {
    local message=${1:-"Processing..."}
    local pid=$2
    local delay=0.1
    local i=0

    while [ -d "/proc/$pid" ]; do
        local char=${SPINNER_CHARS:$((i % ${#SPINNER_CHARS})):1}
        echo -e "\r${F_HIGHLIGHT}${char} ${message}${ALL_RESET}"
        sleep $delay
        ((i++))
    done
    echo -e "\r${CLEAR_LINE}"
}

function section_header() {
    local title=$1
    local width=${2:-60}
    local char=${3:-"="}

    echo
    echo -e "${F_ACCENT}${BOLD_ON}"
    printf "%*s\n" "$width" "" | tr ' ' "$char"
    printf " %s \n" "$title"
    printf "%*s\n" "$width" "" | tr ' ' "$char"
    echo -e "${ALL_RESET}"
}

function list_item() {
    local item=$1
    local status=${2:-""}
    local indent=${3:-0}

    local prefix=""
    for ((i = 0; i < indent; i++)); do
        prefix="  $prefix"
    done

    case $status in
    "success" | "done" | "✓")
        echo -e "${prefix}${F_SUCCESS}${CHECK_MARK} ${item}${ALL_RESET}"
        ;;
    "error" | "failed" | "✗")
        echo -e "${prefix}${F_ERROR}${CROSS_MARK} ${item}${ALL_RESET}"
        ;;
    "warning" | "warn" | "⚠")
        echo -e "${prefix}${F_WARNING}${WARNING_MARK} ${item}${ALL_RESET}"
        ;;
    "info" | "ⓘ")
        echo -e "${prefix}${F_INFO}${INFO_MARK} ${item}${ALL_RESET}"
        ;;
    *)
        echo -e "${prefix}${F_ACCENT}${BULLET_MARK} ${item}${ALL_RESET}"
        ;;
    esac
}
