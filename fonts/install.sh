#!/bin/bash

# set source and target directories
powerline_fonts_dir=$( cd "$( dirname "$0" )" && pwd )

find_command="find \"$powerline_fonts_dir\" \( -name '*.[o,t]tf' -or -name '*.pcf.gz' \) -type f -print0"

if [[ $(uname) == 'Darwin' ]]; then
  font_dir="$HOME/Library/Fonts"
else
  font_dir="$HOME/.local/share/fonts"
  mkdir -p $font_dir
  sudo apt-get install fonts-roboto
fi

# copy all fonts to user fonts directory
echo "Copying fonts..."
eval $find_command | xargs -0 -I % cp "%" "$font_dir/"
eval $find_command | xargs -0 -I % basename "%"

# reset font cache on Linux
if command -v fc-cache @>/dev/null ; then
    echo "Resetting font cache, this may take a moment..."
    fc-cache -f $font_dir
fi
