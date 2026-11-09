#!/usr/bin/env bash
# Fetch the Barcelona wallpapers from Wikimedia Commons into
# ~/Pictures/Barcelona: Barcelona, the towns next to it (Badalona, Sant Cugat
# del Vallès) and the Costa Brava (Lloret de Mar, Tossa de Mar, ...), all in
# the one directory, plus CREDITS.txt with each file's author and license
# (CC0 / CC BY / CC BY-SA / GFDL, most of which ask for attribution).
# The pictures are the 3840 px wide (4K) renditions: Commons answers 429 for
# ten minutes after a dozen full-size originals, and asks for its standard
# sizes (https://w.wiki/GHai) instead.
# lock.jpg is the lock screen, the rest rotate as wallpaper (dotfiles
# hyprland/noctalia/wallpaper.toml on Linux, scripts/wallpaper.sh on macOS).
#
# It is safe to run again: pictures that are already there are skipped. On a
# terminal it then offers to download more: it asks for a place, searches
# Commons for large landscape photos with that place in the title (Featured
# and Quality images first), shows the candidates (with a preview in the
# terminal when chafa is installed) and downloads the chosen ones next to the
# others.
#
# Usage: barcelona.sh [options] [dest]
#   -m, --more PLACE   search Commons for more pictures of PLACE, repeatable
#   -n, --count N      how many pictures to offer for each place (default 5)
#       --no-ask       never prompt: fetch the set (and every --more) and exit
#   -h, --help         show this help
#
# Bash 3.2 compatible, as macOS runs it too.
set -euo pipefail

api=https://commons.wikimedia.org/w/api.php
ua="simorgh-wallpapers/1.0 (keys repo)"

# the rendition to fetch, one of the standard sizes of Commons
width=3840

# what a search result has to be to count as a wallpaper: as wide as the
# rendition, and landscape without being a strip
min_ratio=1.3
max_ratio=2.4

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
    "badalona-rambla|Badalona - La Rambla.jpg"
    "badalona-pont-del-petroli|Albada al Pont del Petroli, Badalona (51246354307).jpg"
    "badalona-albada|Albada a Badalona (52304552783).jpg"
    "sant-cugat-claustre|Sant Cugat. Reial Monestir. Claustre 3.jpg"
    "lloret-platja|Lloret de Mar - Panorama of main beach.jpg"
    "lloret-cami-de-ronda|Lloret de Mar - Coastal 'Camí de Ronda' Footpath at Dona Marinera Monument 1966 - Panorama of Lloret de Mar Beach & Costa Brava Mediterranean Sea Coast 08.jpg"
    "tossa-castell|WLM - 2020 - Castillo de Tosa de Mar.jpg"
    "tossa-albada|!MQ DSF9592-EnhancedAnd2more fused 1.jpg"
    "tossa-badia|Tossa de Mar (43942275335).jpg"
    "tossa-vila-vella|Costa Brava - Tossa de Mar - La Vila Vella - Carni del Far - Panorama View from Església vella de Sant Vicenç on Tossa de Mar, Platja Gran, Town walls, Torre d'en Joanàs & Mediterranean Sea 03.jpg"
    "cadaques-riba|Cadaqués BW 2019-10-08 11-08-02.jpg"
    "cadaques-casa-blaua|Cadaqués (54115075440).jpg"
    "cadaques-badia|Cadaqués 732.jpg"
)

# offered by number when asking for a place; any other name works as well
places=(
    "Barcelona"
    "Badalona"
    "Sant Cugat del Vallès"
    "Sitges"
    "Costa Brava"
    "Lloret de Mar"
    "Tossa de Mar"
    "Blanes"
    "Calella de Palafrugell"
    "Begur"
    "Cadaqués"
)

usage() {
    sed -n '2,26s/^# \{0,1\}//p' "$0"
}

dest=""
count=5
ask=true
more=()
while [ $# -gt 0 ]; do
    case "$1" in
    -m | --more)
        more+=("${2:?"$1 needs a place"}")
        shift 2
        ;;
    -n | --count)
        count="${2:?"$1 needs a number"}"
        shift 2
        ;;
    --no-ask)
        ask=false
        shift
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    -*)
        echo "unknown option: $1" >&2
        exit 1
        ;;
    *)
        dest="$1"
        shift
        ;;
    esac
done

case "$count" in
'' | *[!0-9]*)
    echo "--count needs a number, not '$count'" >&2
    exit 1
    ;;
esac

dest="${dest:-$HOME/Pictures/Barcelona}"
credits="$dest/CREDITS.txt"
[ -t 0 ] || ask=false

for tool in curl jq; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "$tool is required" >&2
        exit 1
    fi
done

mkdir -p "$dest"
if [ ! -f "$credits" ]; then
    echo "Barcelona wallpapers, from Wikimedia Commons ($(date +%F))" >"$credits"
fi

# One row per picture, tab separated:
# pageid width height url page license artist title
# width and height are those of the original, url is the rendition.
# Artist is HTML; keep the text.
# shellcheck disable=SC2016
rows='
    [.query.pages // {} | .[] | select(.imageinfo)] | sort_by(.index // 0) | .[]
    | .imageinfo[0] as $i
    | [
        .pageid, $i.width, $i.height, ($i.thumburl // $i.url), $i.descriptionurl,
        ($i.extmetadata.LicenseShortName.value // "unknown license"),
        ($i.extmetadata.Artist.value // "unknown author"),
        (.title | sub("^File:"; ""))
    ]
    | map(tostring | gsub("<[^>]*>"; "") | gsub("\\s+"; " "))
    | join("\t")
'

# commons <name=value>...: one query to the Commons API, printed as JSON.
# Commons rate-limits bursts with a non-JSON answer; pace and retry.
commons() {
    local args=() pair answer try
    for pair in "$@"; do
        args+=(--data-urlencode "$pair")
    done
    for try in 1 2 3 4 5 6; do
        sleep "$((try * try))"
        answer="$(curl -sS -m 40 -A "$ua" -G "$api" \
            --data-urlencode action=query --data-urlencode format=json \
            --data-urlencode prop=imageinfo --data-urlencode 'iiprop=url|size|extmetadata' \
            --data-urlencode "iiurlwidth=$width" \
            --data-urlencode 'iiextmetadatafilter=LicenseShortName|Artist' \
            "${args[@]}" || true)"
        if jq -e '.batchcomplete != null or .query != null' <<<"$answer" >/dev/null 2>&1; then
            printf '%s\n' "$answer"
            return 0
        fi
    done
    echo "no answer from Commons, try again in a few minutes" >&2
    return 1
}

# download <name> <row>: fetch the rendition as <name>.jpg and credit it.
download() {
    local name="$1" row="$2" code
    local _id _width _height url page license artist _title
    IFS=$'\t' read -r _id _width _height url page license artist _title <<<"$row"

    sleep 1
    code="$(curl -sS -m 300 -A "$ua" -o "$dest/$name.jpg.part" -w '%{http_code}' "$url" || true)"
    if [ "$code" != 200 ]; then
        rm -f "$dest/$name.jpg.part"
        if [ "$code" = 429 ]; then
            echo "$name.jpg: Commons is rate limiting, run this again in ten minutes" >&2
        else
            echo "$name.jpg: download failed (${code:-no answer})" >&2
        fi
        return 1
    fi
    mv "$dest/$name.jpg.part" "$dest/$name.jpg"
    printf '%s.jpg: %s, %s, %s\n' "$name" "$artist" "$license" "$page" >>"$credits"
    echo "$name.jpg $(du -h "$dest/$name.jpg" | cut -f1)"
}

# The set above, minus what is already there.
fetch_set() {
    local entry name title row failed=0
    for entry in "${files[@]}"; do
        name="${entry%%|*}"
        title="File:${entry#*|}"
        [ -s "$dest/$name.jpg" ] && continue
        if ! row="$(commons "titles=$title" | jq -r "$rows")"; then
            echo "$name.jpg: skipped, run this again to fetch it" >&2
            failed=1
            continue
        fi
        if [ -z "$row" ]; then
            echo "$name.jpg: '$title' is not on Commons any more" >&2
            failed=1
            continue
        fi
        download "$name" "$row" || failed=1
    done
    return "$failed"
}

# slug <place>: "Sant Cugat del Vallès" -> "sant-cugat-del-valles"
slug() {
    local ascii
    ascii="$(printf '%s' "$1" | iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null)" || ascii="$1"
    printf '%s' "$ascii" | LC_ALL=C tr '[:upper:]' '[:lower:]' |
        LC_ALL=C sed -e 's/[^a-z0-9]\{1,\}/-/g' -e 's/^-//' -e 's/-$//'
}

# search <query>: rows of the pictures that would do as a wallpaper.
# filew takes > but not >=.
search() {
    commons generator=search gsrnamespace=6 gsrlimit=50 \
        "gsrsearch=$1 filemime:image/jpeg filew:>$((width - 1))" |
        jq -r "$rows" |
        awk -F'\t' -v min="$min_ratio" -v max="$max_ratio" \
            '$3 > 0 && $2 / $3 >= min && $2 / $3 <= max'
}

# preview <row>: draw the picture in the terminal, from its 330 px rendition.
preview() {
    local url
    [ "$ask" = true ] && command -v chafa >/dev/null 2>&1 || return 0
    IFS=$'\t' read -r _ _ _ url _ <<<"$1"
    curl -sS -m 30 -A "$ua" "${url/\/${width}px-//330px-}" 2>/dev/null |
        chafa --size 64x18 - 2>/dev/null || true
}

# fetch_more <place>: offer up to $count new pictures of a place.
fetch_more() {
    local place="$1" prefix row id page title w h answer keep n i
    local found=() seen=" " assessed='haswbstatement:P6731=Q63348049|P6731=Q63348069'
    prefix="$(slug "$place")"

    echo "searching Commons for $place..."
    # Featured (Q63348049) and Quality (Q63348069) images first, by title and
    # then by description, which is what finds a region like the Costa Brava;
    # then anything with the place in its title.
    while IFS= read -r row; do
        [ -n "$row" ] || continue
        [ "${#found[@]}" -lt "$count" ] || break
        IFS=$'\t' read -r id w h _ page _ _ title <<<"$row"
        case "$seen" in *" $id "*) continue ;; esac
        seen="$seen$id "
        # already here, from the set or from an earlier search
        grep -qF -- ", $page" "$credits" && continue
        found+=("$row")
        printf '%3d) %s  (%sx%s)\n     %s\n' "${#found[@]}" "$title" "$w" "$h" "$page"
        preview "$row"
    done < <(
        search "intitle:\"$place\" $assessed" || true
        search "\"$place\" $assessed" || true
        search "intitle:\"$place\"" || true
    )

    if [ "${#found[@]}" -eq 0 ]; then
        echo "nothing new for $place"
        return 0
    fi

    keep=" "
    if [ "$ask" = true ]; then
        read -r -p "download which? [all], numbers (1 3), or n for none: " answer || answer=n
        case "$answer" in
        n | N | no | none) return 0 ;;
        '' | a | all | y | Y | yes) keep="" ;;
        *) keep=" $(tr ',' ' ' <<<"$answer") " ;;
        esac
    else
        keep=""
    fi

    i=0
    for row in "${found[@]}"; do
        i=$((i + 1))
        if [ -n "$keep" ]; then
            case "$keep" in *" $i "*) ;; *) continue ;; esac
        fi
        IFS=$'\t' read -r id _ <<<"$row"
        n="$prefix-$id"
        download "$n" "$row" || true
    done
}

# ask_place: print the place the user picked, nothing to finish.
ask_place() {
    local i=0 place answer
    {
        echo
        echo "download more wallpapers? pick a place, type any other, or press enter to finish"
        for place in "${places[@]}"; do
            i=$((i + 1))
            echo "  $i) $place"
        done
    } >&2
    read -r -p "place: " answer || answer=""
    case "$answer" in
    '' | n | N | no | q) return 0 ;;
    *[!0-9]*) echo "$answer" ;;
    *)
        if [ "$answer" -ge 1 ] && [ "$answer" -le "${#places[@]}" ]; then
            echo "${places[$((answer - 1))]}"
        else
            echo "there is no place $answer" >&2
        fi
        ;;
    esac
}

status=0
fetch_set || status=1

if [ "${#more[@]}" -gt 0 ]; then
    for place in "${more[@]}"; do
        fetch_more "$place"
    done
elif [ "$ask" = true ]; then
    while true; do
        place="$(ask_place)"
        [ -n "$place" ] || break
        fetch_more "$place"
    done
fi

echo "$(find "$dest" -maxdepth 1 -type f -name '*.jpg' | wc -l | tr -d ' ') pictures in $dest"
exit "$status"
