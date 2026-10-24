#!/usr/bin/env bash
# Fetch the Barcelona wallpapers from Wikimedia Commons into
# ~/Pictures/Barcelona: full-resolution originals (4200-8000 px wide), every
# one a Commons Featured or Quality image, plus CREDITS.txt with each file's
# author and license (CC BY / CC BY-SA / GFDL, which ask for attribution).
# lock.jpg is the lock screen, the rest rotate as wallpaper (dotfiles
# hyprland/noctalia/wallpaper.toml on Linux, scripts/wallpaper.sh on macOS).
#
# Usage: barcelona.sh [dest]
set -euo pipefail

dest="${1:-$HOME/Pictures/Barcelona}"
api=https://commons.wikimedia.org/w/api.php
ua="simorgh-wallpapers/1.0 (keys repo)"

# "<local name>|<Commons file title>"
files=(
    "lock|Catedral de la Santa Cruz y Santa Eulalia -- 2019 -- Barcelona, España.jpg"
    "montjuic-panorama|Barcelona view from Montjuïc hill.jpg"
    "panorama-port|Panorámica de Barcelona B08.jpg"
    "sagrada-familia|Sagrada Familia March 2015-10a.jpg"
    "bac-de-roda|15-10-28-Pont Bac de Roda Barcelona-RalfR-WMA 3105.jpg"
    "placa-espanya|Barcelona March 2015-14a.jpg"
    "palau-nacional|Palau Nacional Barcelona Pano 2013.jpg"
    "port-olimpic|14-08-05-barcelona-RalfR-036.jpg"
    "barceloneta|14-08-06-barcelona-RalfR-015.jpg"
    "placa-reial|Barcelona - Nacht - Placa Reial 004.jpg"
    "park-guell|Parc Güell Terrace.jpg"
)

mkdir -p "$dest"
credits="$dest/CREDITS.txt"
echo "Barcelona wallpapers, from Wikimedia Commons ($(date +%F))" >"$credits"

for entry in "${files[@]}"; do
    name="${entry%%|*}"
    title="File:${entry#*|}"
    # Commons rate-limits bursts with a non-JSON answer; pace and retry.
    for _ in 1 2 3 4 5; do
        sleep 3
        info="$(curl -sS -m 30 -A "$ua" -G "$api" \
            --data-urlencode action=query --data-urlencode format=json \
            --data-urlencode prop=imageinfo --data-urlencode 'iiprop=url|size|extmetadata' \
            --data-urlencode 'iiextmetadatafilter=LicenseShortName|Artist' \
            --data-urlencode "titles=$title")"
        jq -e '.query.pages[].imageinfo[0].url' <<<"$info" >/dev/null 2>&1 && break
    done
    url="$(jq -r '.query.pages[].imageinfo[0].url' <<<"$info")"
    page="$(jq -r '.query.pages[].imageinfo[0].descriptionurl' <<<"$info")"
    license="$(jq -r '.query.pages[].imageinfo[0].extmetadata.LicenseShortName.value' <<<"$info")"
    # Artist is HTML; keep the text.
    artist="$(jq -r '.query.pages[].imageinfo[0].extmetadata.Artist.value' <<<"$info" | sed -e 's/<[^>]*>//g')"
    curl -sS -m 300 -A "$ua" -o "$dest/$name.jpg" "$url"
    printf '%s.jpg: %s, %s, %s\n' "$name" "$artist" "$license" "$page" >>"$credits"
    echo "$name.jpg $(jq -r '.query.pages[].imageinfo[0] | "\(.width)x\(.height)"' <<<"$info") $(du -h "$dest/$name.jpg" | cut -f1)"
done
