#!/usr/bin/env bash
usage() {
  echo "set hostname based on starship naming schema"

  # shellcheck disable=1004,2016
  echo '
 _               _
| |__   ___  ___| |_ _ __   __ _ _ __ ___   ___
| |_ \ / _ \/ __| __| |_ \ / _` | |_ ` _ \ / _ \
| | | | (_) \__ \ |_| | | | (_| | | | | | |  __/
|_| |_|\___/|___/\__|_| |_|\__,_|_| |_| |_|\___|
  '
}



main_pacman() {
  return 1
}

main_apt() {
  return 1
}

main_brew() {
  sudo scutil --set ComputerName 'Millennium Falcon'
  sudo scutil --set HostName 'millennium-falcon'
  sudo scutil --set LocalHostName 'millennium-falcon'
}

main() {
  return 0
}

main_parham() {
  return 0
}
