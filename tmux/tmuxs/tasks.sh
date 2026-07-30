#!/usr/bin/env bash
#
# Summarize open org tasks that are scheduled for today or overdue.
#
# Bound to `prefix + T` in keybindings.conf and opened in a tmux popup.
# Started life as a Claude Code SessionStart hook (keys/claude/hooks/
# tasks-review.sh) that nagged at the start of every session; it is
# on-demand now.
#
# Open task   = "- [ ]" (todo) or "- [/]" (in progress).
# Scheduled   = Obsidian Tasks plugin "⏳ YYYY-MM-DD" (the vault consolidated
#               on ⏳; 📅/🛫 are not used). Created "➕" dates are ignored.
# Due/overdue = scheduled date <= today.
#
# Pass --all to list every due task instead of the first few per project.

set -euo pipefail

# a global variable that points to tmuxs root directory.
tmuxs_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# main.sh probes $root to decide whether to pull in the linker helpers, which
# this script has no use for. declare it so `set -u` does not trip over it.
root="${root:-}"

# shellcheck source=SCRIPTDIR/../../scripts/lib/main.sh
source "$tmuxs_root/../../scripts/lib/main.sh"

org_dir="${ORG_DIR:-$HOME/org}"
tasks_dir="$org_dir/Tasks"

# how many tasks to list per project before collapsing into a "+N more" line.
per_project=5
if [ "${1:-}" == "--all" ]; then
    per_project=0
fi

# the popup dies as soon as this script exits, so short output has to wait
# for a keypress; long output is paged by less instead.
hold() {
    echo
    read -r -n 1 -s -p "$(echo -e "${F_GRAY}press any key to close${ALL_RESET}")"
    echo
}

if [ ! -d "$tasks_dir" ]; then
    message 'tasks' "no org vault at $tasks_dir" 'error'
    hold
    exit 0
fi

today="$(date +%F)"

# every open task with a ⏳ date on or before today, as
# "date <TAB> age-in-days <TAB> project <TAB> section <TAB> text".
records="$(
    awk -v today="$today" '
    # days since the epoch for a civil date, so ages survive month and
    # year boundaries without shelling out to date(1) (BSD/GNU differ).
    function days(y, m, d,   yy, era, yoe, doy, doe) {
      yy = y - (m <= 2)
      era = int((yy >= 0 ? yy : yy - 399) / 400)
      yoe = yy - era * 400
      doy = int((153 * (m + (m > 2 ? -3 : 9)) + 2) / 5) + d - 1
      doe = yoe * 365 + int(yoe / 4) - int(yoe / 100) + doy
      return era * 146097 + doe - 719468
    }
    function to_days(s,   p) { split(s, p, "-"); return days(p[1] + 0, p[2] + 0, p[3] + 0) }

    FNR == 1 {
      project = FILENAME
      sub(/.*\//, "", project)
      sub(/\.md$/, "", project)
      section = ""
    }

    /^##+ / { section = $0; sub(/^##+ +/, "", section); next }

    /^[[:space:]]*- \[[ \/]\]/ {
      if (!match($0, /⏳ [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/)) next
      date = substr($0, RSTART, RLENGTH)
      gsub(/[^0-9-]/, "", date)
      if (date > today) next

      text = $0
      sub(/^[[:space:]]*- \[[ \/]\][[:space:]]*/, "", text)
      # drop the Tasks plugin metadata tail (dates, priorities, recurrence).
      if (match(text, /(➕|🛫|⏳|📅|✅|❌|🔁|🔺|⏫|🔼|🔽|⏬|🆔|⛔|🏁)/))
        text = substr(text, 1, RSTART - 1)
      gsub(/\[\[|\]\]/, "", text)     # unwrap wiki links
      gsub(/\\\*/, "*", text)         # unescape markdown stars
      sub(/[[:space:]]+$/, "", text)

      printf "%s\t%d\t%s\t%s\t%s\n", date, to_days(today) - to_days(date), project, section, text
    }
  ' "$tasks_dir"/*.md 2>/dev/null | sort -t"$(printf '\t')" -k1,1
)"

# open tasks regardless of schedule, for context in the header.
open_total="$(grep -hc '^[[:space:]]*- \[[ /]\]' "$tasks_dir"/*.md 2>/dev/null |
    awk '{ n += $1 } END { print n + 0 }')"

out=""
emit() { out+="$(printf '%b' "$1")"$'\n'; }

# task descriptions run long; keep every entry on a single line so the popup
# stays scannable. bash substring expansion counts characters, not bytes, so
# this stays safe for the Persian entries in Personal.md.
cols="$(tput cols 2>/dev/null || echo 80)"
ellipsize() {
    local text="$1" width="$2"
    [ "$width" -lt 24 ] && width=24
    if [ "${#text}" -gt "$width" ]; then
        printf '%s…' "${text:0:$((width - 1))}"
    else
        printf '%s' "$text"
    fi
}

emit "${BOLD_ON}${F_CYAN}  ORG TASKS${ALL_RESET}${F_GRAY}  ·  $(date '+%a %d %b %Y')${ALL_RESET}"
emit ""

if [ -z "$records" ]; then
    emit "  ${F_SUCCESS}nothing due${ALL_RESET}${F_GRAY} — ${open_total} open task(s), all scheduled ahead${ALL_RESET}"
    printf '%s' "$out"
    hold
    exit 0
fi

overdue="$(printf '%s\n' "$records" | awk -F'\t' '$2 > 0' | wc -l | tr -d ' ')"
due_today="$(printf '%s\n' "$records" | awk -F'\t' '$2 == 0' | wc -l | tr -d ' ')"
collapsed=0

emit "  ${F_ERROR}${overdue} overdue${ALL_RESET}${F_GRAY}  ·  ${ALL_RESET}${F_WARNING}${due_today} due today${ALL_RESET}${F_GRAY}  ·  ${open_total} open in total${ALL_RESET}"
emit ""

# projects ordered by how much is piling up in each.
projects="$(printf '%s\n' "$records" | cut -f3 | sort | uniq -c | sort -rn |
    sed 's/^ *[0-9]* //')"

while IFS= read -r project; do
    [ -n "$project" ] || continue

    count="$(printf '%s\n' "$records" | awk -F'\t' -v p="$project" '$3 == p' | wc -l | tr -d ' ')"
    emit "  ${BOLD_ON}${F_INFO}${project}${ALL_RESET}${F_GRAY}  ${count}${ALL_RESET}"

    shown=0
    while IFS=$'\t' read -r date age _ section text; do
        [ -n "$date" ] || continue
        if [ "$per_project" -gt 0 ] && [ "$shown" -ge "$per_project" ]; then
            emit "    ${F_GRAY}+ $((count - shown)) more${ALL_RESET}"
            collapsed=1
            break
        fi

        if [ "$age" -gt 0 ]; then
            marker="${F_ERROR}${date}  ${age}d${ALL_RESET}"
        else
            marker="${F_WARNING}${date} today${ALL_RESET}"
        fi

        # emit() renders escapes so the colour variables work, so any backslash
        # left in the markdown has to survive that pass literally.
        text="${text//\\/\\\\}"

        # 4 indent + "YYYY-MM-DD" + separators + age, then the "· section" tail.
        budget=$((cols - 24))
        [ -n "$section" ] && budget=$((budget - ${#section} - 3))

        line="    ${marker}  $(ellipsize "$text" "$budget")"
        [ -n "$section" ] && line+="${F_GRAY}  · ${section}${ALL_RESET}"
        emit "$line"

        shown=$((shown + 1))
    done < <(printf '%s\n' "$records" | awk -F'\t' -v p="$project" '$3 == p')

    emit ""
done <<<"$projects"

if [ "$collapsed" -eq 1 ]; then
    emit "${F_GRAY}  prefix + M-t lists every due task${ALL_RESET}"
fi

# page only when the summary cannot fit on screen; less holds it open itself.
if [ "$(printf '%s' "$out" | wc -l | tr -d ' ')" -gt "$(tput lines 2>/dev/null || echo 24)" ]; then
    printf '%s' "$out" | less -R
else
    printf '%s' "$out"
    hold
fi
