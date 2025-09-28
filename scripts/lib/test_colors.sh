#!/usr/bin/env bash

# Test script to showcase the enhanced colorization

# Source the message library
# shellcheck source=message.sh
source "$(dirname "${BASH_SOURCE[0]}")/message.sh"

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
echo -e "${F_SUCCESS}Success Green${ALL_RESET}    ${F_ERROR}Error Red${ALL_RESET}      ${F_WARNING}Warning Yellow${ALL_RESET}"
echo -e "${F_INFO}Info Blue${ALL_RESET}        ${F_NOTICE}Notice Orange${ALL_RESET}   ${F_DEBUG}Debug Gray${ALL_RESET}"
echo -e "${F_HIGHLIGHT}Highlight Cyan${ALL_RESET}  ${F_ACCENT}Accent Purple${ALL_RESET}"

echo

# Test formatted text
section_header "Text Formatting"
echo -e "${BOLD_ON}Bold Text${BOLD_OFF}        ${ITALIC_ON}Italic Text${ITALIC_OFF}      ${UNDERLINE_ON}Underlined Text${UNDERLINE_OFF}"
echo -e "${DIM_ON}Dimmed Text${DIM_OFF}      ${F_SUCCESS}${BOLD_ON}Bold Success${ALL_RESET}   ${BG_BLUE}${F_WHITE}Background Color${ALL_RESET}"

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
colorize "${F_SUCCESS}" "✨ Color scheme enhancement complete!"
