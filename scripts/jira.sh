#!/bin/bash
usage() {
	echo "Jira is a proprietary issue tracking product developed by Atlassian that allows bug tracking and agile project management."

	# shellcheck disable=1004,2016
	echo '
   _ _
  (_|_)_ __ __ _
  | | | |__/ _` |
  | | | | | (_| |
 _/ |_|_|  \__,_|
|__/
  '
}

main_pacman() {
	require_aur jira-cli
}
