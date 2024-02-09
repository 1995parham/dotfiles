#!/usr/bin/env bash
usage() {
  echo "The X Window System is a windowing system for bitmap displays, common on Unix-like operating systems."

  # shellcheck disable=1004,2016
  echo '
      _ _
__  _/ / |
\ \/ / | |
 >  <| | |
/_/\_\_|_|
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
  return 1
}

main() {
  return 0
}

main_parham() {
  return 0
}
