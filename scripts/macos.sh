#!/usr/bin/env bash
usage() {
  echo "setup macos and aqua"

  # shellcheck disable=1004,2016
  echo '

 _ __ ___   __ _  ___ ___  ___
| |_ ` _ \ / _` |/ __/ _ \/ __|
| | | | | | (_| | (_| (_) \__ \
|_| |_| |_|\__,_|\___\___/|___/
  '
}



main_pacman() {
  return 1
}

main_apt() {
  return 1
}

main_brew() {
  defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/kitty.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>'
}

main() {
  return 0
}

main_parham() {
  return 0
}
