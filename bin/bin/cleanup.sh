#!/usr/bin/env bash

stable_folders=(
	"$HOME/Downloads/Telegram Desktop"
	"$HOME/Downloads/samba"
	"$HOME/Downloads/xandikos"
	"$HOME/Downloads/copyparty"
	"$HOME/Downloads/swagger"
	"$HOME/Downloads/movies"
)

for folder in "${stable_folders[@]}"; do
	mkdir -p "$folder" || true
done

while read -r folder; do
	# shellcheck disable=2076
	if [[ ! " ${stable_folders[*]} " =~ " ${folder} " ]]; then
		rm -rf "$folder"
	fi
done < <(find "$HOME/Downloads" -maxdepth 1 -mtime +1)

while read -r file; do
	# shellcheck disable=2076
	rm -rf "$file"
done < <(find "$HOME/Downloads/Telegram Desktop" -mindepth 1 -mtime +15m)
