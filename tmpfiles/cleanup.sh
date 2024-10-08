#!/usr/bin/env bash

stable_folders=(
    "$HOME/Downloads"
    "$HOME/Downloads/Telegram Desktop"
    "$HOME/Downloads/xandikos"
    "$HOME/Downloads/handy"
)

for folder in "${stable_folders[@]}"; do
    mkdir -p "$folder" || true
done

while read -r folder; do
    # shellcheck disable=2076
    if [[ ! " ${stable_folders[*]} " =~ " ${folder} " ]]; then
        echo "removing $folder..."
        rm -rf "$folder"
    fi
done < <(find "$HOME/Downloads" -maxdepth 1 -mtime +12h)

while read -r file; do
    echo "removing $file..."
    # shellcheck disable=2076
    rm -rf "$file"
done < <(find "$HOME/Downloads/Telegram Desktop" -mindepth 1 -mtime +15m)
