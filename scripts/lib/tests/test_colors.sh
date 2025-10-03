#!/usr/bin/env bash

# Test script to showcase the enhanced colorization

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=main.sh
source "${root}/../main.sh"

# Test section headers
section_header "Color Scheme Demo"

# Test different message severities
message "test" "This is an info message" "info"
message "test" "This is a success message" "success"
message "test" "This is a warning message" "warn"
message "test" "This is an error message" "error"
message "test" "This is a notice message" "notice"
message "test" "This is a debug message" "debug"

echo

# Test function variations
running "test" "Running some process..."
action "test" "Performing an action"
ok "test" "Operation completed successfully"

echo

# Test list items with different statuses
section_header "Status Lists"
list_item "Installation successful" "success"
list_item "Warning detected" "warning"
list_item "Error occurred" "error"
list_item "Information note" "info"
list_item "Regular item"

echo

# Test yes/no prompt simulation (without actually prompting)
echo -e "${F_HIGHLIGHT}[test] ${F_NOTICE}Would you like to proceed?${F_RESET} [${F_SUCCESS}y${F_RESET}/${F_ERROR}n${F_RESET}]: (demo - not interactive)"

echo

# Test color variables showcase
section_header "Available Colors"
echo -e "${F_SUCCESS}${BOLD_ON}Success Neon Green${ALL_RESET}    ${F_ERROR}${BOLD_ON}Error Bright Red${ALL_RESET}      ${F_WARNING}${BOLD_ON}Warning Orange${ALL_RESET}"
echo -e "${F_INFO}${BOLD_ON}Info Electric Blue${ALL_RESET}    ${F_NOTICE}${BOLD_ON}Notice Hot Pink${ALL_RESET}     ${F_DEBUG}${BOLD_ON}Debug Purple${ALL_RESET}"
echo -e "${F_HIGHLIGHT}${BOLD_ON}Highlight Cyan${ALL_RESET}     ${F_ACCENT}${BOLD_ON}Accent Purple${ALL_RESET}"

echo
echo -e "${BOLD_ON}${F_ACCENT}🌈 Extended Vibrant Color Palette:${ALL_RESET}"
echo -e "${F_NEON_GREEN}${BOLD_ON}Neon Green${ALL_RESET}        ${F_ELECTRIC_BLUE}${BOLD_ON}Electric Blue${ALL_RESET}     ${F_HOT_PINK}${BOLD_ON}Hot Pink${ALL_RESET}"
echo -e "${F_BRIGHT_PURPLE}${BOLD_ON}Bright Purple${ALL_RESET}     ${F_BRIGHT_ORANGE}${BOLD_ON}Bright Orange${ALL_RESET}     ${F_BRIGHT_CYAN}${BOLD_ON}Bright Cyan${ALL_RESET}"

echo

# Test formatted text
section_header "Text Formatting"
echo -e "${BOLD_ON}${F_BRIGHT_CYAN}Bold Text${ALL_RESET}        ${ITALIC_ON}${F_BRIGHT_PURPLE}Italic Text${ALL_RESET}      ${UNDERLINE_ON}${F_HOT_PINK}Underlined Text${ALL_RESET}"
echo -e "${DIM_ON}${F_GRAY}Dimmed Text${ALL_RESET}      ${F_SUCCESS}${BOLD_ON}Bold Success${ALL_RESET}   ${BG_PURPLE}${F_WHITE}${BOLD_ON} Background Color ${ALL_RESET}"

echo
echo -e "${BOLD_ON}${F_ACCENT}🎨 Background Color Showcase:${ALL_RESET}"
echo -e "${BG_RED}${F_WHITE}${BOLD_ON} Red Background ${ALL_RESET}  ${BG_GREEN}${F_BLACK}${BOLD_ON} Green Background ${ALL_RESET}  ${BG_YELLOW}${F_BLACK}${BOLD_ON} Yellow Background ${ALL_RESET}"
echo -e "${BG_BLUE}${F_WHITE}${BOLD_ON} Blue Background ${ALL_RESET} ${BG_PURPLE}${F_WHITE}${BOLD_ON} Purple Background ${ALL_RESET} ${BG_PINK}${F_BLACK}${BOLD_ON} Pink Background ${ALL_RESET}"

echo

# Test progress indicators
echo -e "${F_INFO}Progress indicators:${ALL_RESET}"
echo -e "${F_SUCCESS}${CHECK_MARK} Completed${ALL_RESET}"
echo -e "${F_ERROR}${CROSS_MARK} Failed${ALL_RESET}"
echo -e "${F_WARNING}${WARNING_MARK} Warning${ALL_RESET}"
echo -e "${F_INFO}${INFO_MARK} Information${ALL_RESET}"
echo -e "${F_ACCENT}${ARROW_MARK} Action${ALL_RESET}"
echo -e "${F_ACCENT}${BULLET_MARK} List item${ALL_RESET}"

echo
echo -e "${BOLD_ON}${F_ACCENT}🌟 Special Effects:${ALL_RESET}"
echo -e "${F_NEON_GREEN}${BOLD_ON}▲▲▲ ULTRA BRIGHT NEON GREEN ▲▲▲${ALL_RESET}"
echo -e "${F_HOT_PINK}${BOLD_ON}★★★ HOT PINK STARS ★★★${ALL_RESET}"
echo -e "${F_ELECTRIC_BLUE}${BOLD_ON}⚡⚡⚡ ELECTRIC BLUE LIGHTNING ⚡⚡⚡${ALL_RESET}"
echo -e "${F_BRIGHT_ORANGE}${BOLD_ON}🔥🔥🔥 BLAZING ORANGE FIRE 🔥🔥🔥${ALL_RESET}"

echo
colorize "${F_SUCCESS}${BOLD_ON}" "🎉✨ ULTRA VIBRANT COLOR SCHEME COMPLETE! ✨🎉"

# shellcheck source=unit.sh
source "${root}/../unit.sh"
