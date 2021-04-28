#!/bin/bash
# In The Name of God
# ========================================
# [] File Name : rename.sh
#
# [] Creation Date : 05-01-2021
#
# [] Created By : Parham Alvani <parham.alvani@gmail.com>
# =======================================

echo "structure your tv-series, at least trying to"
echo "please note that only .mp4 and .mkv are supported"

rename() {
	local name=$1   # name of the series
	local season=$2 # season of the series
	local index=$3  # base episode index
	local dry_run=${4:-"true"}

	echo "$name $season $dry_run"

	movies=$(find . -maxdepth 1 -name '*.mkv' -type f -printf %P\\n -o -name '*.mp4' -type f -printf %P\\n | sort)

	# https://unix.stackexchange.com/questions/9496/looping-through-files-with-spaces-in-the-names
	OIFS="$IFS"
	IFS=$'\n'
	episode=$index
	episode=$index
	for movie in $movies; do
		episode=$((episode + 1))

		if [[ $dry_run == true ]]; then
			echo "$movie -> Season $season/Episode $episode/$name S$(printf %02d "$season")E$(printf %02d "$episode").${movie##*.}"
		else
			mkdir -p "Season $season/Episode $episode"
			mv "$movie" "Season $season/Episode $episode/$name S$(printf %02d "$season")E$(printf %02d "$episode").${movie##*.}"
		fi
	done

	subs=$(find . -maxdepth 1 -name '*.srt' -type f -printf %P\\n | sort)

	# https://unix.stackexchange.com/questions/9496/looping-through-files-with-spaces-in-the-names
	OIFS="$IFS"
	IFS=$'\n'
	episode=$index
	for sub in $subs; do
		episode=$((episode + 1))

		if [[ $dry_run == true ]]; then
			echo "$sub -> Season $season/Episode $episode/$name S$(printf %02d "$season")E$(printf %02d "$episode").srt"
		else
			mkdir -p "Season $season/Episode $episode"
			mv "$sub" "Season $season/Episode $episode/$name S$(printf %02d "$season")E$(printf %02d "$episode").srt"
		fi
	done
	IFS="$OIFS"
}

sample=$(find . -maxdepth 1 -name '*.mkv' -type f -printf %P\\n -o -name '*.mp4' -type f -printf %P\\n | sort | head -1)

read -r -p "TV Series Name: " -i "$sample" -e name

read -r -p "TV Series Season: " season

read -r -p "Base Episode Index: " -i "1" -e index

rename "$name" "$season" $((index - 1)) true

read -r -p "are you ready ?[Y/n] " -n 1 delete_confirm
echo

if [[ $delete_confirm == "Y" ]]; then
	rename "$name" "$season" $((index - 1)) false
fi
