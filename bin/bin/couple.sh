#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : couple.sh
#
# [] Creation Date : 01-04-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

since-() {
	local since
	since=$(date -d "$1" "+%s")
	local now
	now=$(date -d "now" "+%s")

	local minute=$((60))
	local hour=$((minute * 60))
	local day=$((hour * 24))

	local diff=$((now - since))

	local days=$((diff / day))
	diff=$((diff - days * day))
	local hours=$((diff / hour))
	diff=$((diff - hours * hour))
	local minutes=$((diff / minute))

	echo "$days days $hours hours $minutes minutes"
}

in_relationship() {
	since- "13 feb 2020 22:26:00"
	echo "How long we were together?"
}

to_birthday() {
	local minute=$((60))
	local hour=$((minute * 60))
	local day=$((hour * 24))

	local this_year
	this_year=$(date "+%Y")
	local next_year=$((this_year + 1))

	local to
	to=$(date -d "12 oct $this_year 19:20:00" "+%s")
	local now
	now=$(date -d "now" "+%s")

	local diff=$((to - now))

	if [ $diff -lt 0 ]; then
		to=$(date -d "12 oct $next_year 19:20:00" "+%s")
		diff=$((to - now))
	fi

	local days=$((diff / day))
	diff=$((diff - days * day))
	local hours=$((diff / hour))
	diff=$((diff - hours * hour))
	local minutes=$((diff / minute))

	echo -e "$days days $hours hours $minutes minutes\nHow much left until to her birthday?"
}

since_first_family_meeting() {
	since- "18 nov 2022 15:30:00"
	echo "How much since our first family meeting?"
}

since_first_family_dinner() {
	since- "31 mar 2023 19:00:00"
	echo "How much since our first family dinner?"
}

main() {
	in_relationship

	echo

	to_birthday

	echo

	since_first_family_meeting

	echo

	since_first_family_dinner
}

if [ $# -ne 1 ]; then
	main
else
	case $1 in
	'birthday')
		to_birthday
		;;
	'relationship')
		in_relationship
		;;
	'first_family_meeting')
		since_first_family_meeting
		;;
	esac
fi
