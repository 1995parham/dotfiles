#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : couple.sh
#
# [] Creation Date : 01-04-2020
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

function in_relationship() {
  local since=$(date -d "13 feb 2020 20:30:00" "+%s")
  local now=$(date -d "now" "+%s")

  local minute=$((60))
  local hour=$(($minute * 60))
  local day=$(($hour * 24))

  local diff=$(( $now - $since ))

  local days=$(( $diff / $day ))
  diff=$(( $diff - $days * $day ))
  local hours=$(( $diff / $hour ))
  diff=$(( $diff - $hours * $hour ))
  local minutes=$(( $diff / $minute ))

  echo $days days $hours hours $minutes minutes
}

function to_birthday() {
  local to=$(date -d "19 oct" "+%s")
  local now=$(date -d "now" "+%s")

  local minute=$((60))
  local hour=$(($minute * 60))
  local day=$(($hour * 24))

  local diff=$(( $to - $now ))

  local days=$(( $diff / $day ))
  diff=$(( $diff - $days * $day ))
  local hours=$(( $diff / $hour ))
  diff=$(( $diff - $hours * $hour ))
  local minutes=$(( $diff / $minute ))

  echo $days days $hours hours $minutes minutes
}

function main() {
        echo "We are in relatioship for:"
        in_relationship

        echo

        echo "To Raha birthday:"
        to_birthday
}

main
