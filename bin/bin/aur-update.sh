#!/usr/bin/env bash
# aur-update.sh — Bump the AUR packages you maintain to their latest upstream release.
#
# For every package repo under $AUR_DIR (default: ~/Documents/Git/aur) this script:
#   1. reads the current pkgver from the PKGBUILD,
#   2. resolves the upstream GitHub repo (from url= or the github.com source URL),
#   3. asks GitHub for the latest *stable* release tag,
#   4. and for outdated packages: bumps pkgver, resets pkgrel=1, recomputes the
#      checksum arrays with updpkgsums, regenerates .SRCINFO, commits, and pushes.
#
# Usage:
#   aur-update.sh [options] [aur-dir]
#
# Options:
#   -n, --dry-run   Only report what is outdated; make no edits, commits, or pushes.
#   -y, --yes       Do not prompt before pushing (push every updated package).
#   -h, --help      Show this help.
#
# Notes:
#   * VCS packages (-git, or pkgver like r123.abcdef) are skipped — makepkg versions
#     those from the checkout, not from a release.
#   * The latest-release query excludes pre-releases, so packages intentionally pinned
#     to a pre-release/engineering-candidate channel (e.g. okd-client-bin) will read as
#     current rather than being switched to a different channel.
#
# Requires: gh (authenticated), vercmp, updpkgsums, makepkg, git, jq.

set -euo pipefail

# ---------------------------------------------------------------------------- #
# Colors
# ---------------------------------------------------------------------------- #
if [[ -t 1 ]]; then
    C_RESET=$'\e[0m' C_BOLD=$'\e[1m' C_DIM=$'\e[2m'
    C_GREEN=$'\e[32m' C_RED=$'\e[31m' C_YELLOW=$'\e[33m' C_BLUE=$'\e[34m' C_CYAN=$'\e[36m'
else
    C_RESET='' C_BOLD='' C_DIM='' C_GREEN='' C_RED='' C_YELLOW='' C_BLUE='' C_CYAN=''
fi

info() { printf '%s==>%s %s\n' "$C_BLUE$C_BOLD" "$C_RESET" "$*"; }
ok() { printf '  %s✓%s %s\n' "$C_GREEN" "$C_RESET" "$*"; }
skip() { printf '  %s-%s %s\n' "$C_DIM" "$C_RESET" "$*"; }
warn() { printf '  %s!%s %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2; }
err() { printf '%serror:%s %s\n' "$C_RED$C_BOLD" "$C_RESET" "$*" >&2; }

usage() {
    sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'
    exit "${1:-0}"
}

# ---------------------------------------------------------------------------- #
# Args
# ---------------------------------------------------------------------------- #
dry_run=0
assume_yes=0
aur_dir=${AUR_DIR:-"$HOME/Documents/Git/aur"}

while [[ $# -gt 0 ]]; do
    case "$1" in
    -n | --dry-run) dry_run=1 ;;
    -y | --yes) assume_yes=1 ;;
    -h | --help) usage 0 ;;
    -*)
        err "unknown option: $1"
        usage 1
        ;;
    *) aur_dir=$1 ;;
    esac
    shift
done

# ---------------------------------------------------------------------------- #
# Preflight
# ---------------------------------------------------------------------------- #
for cmd in gh vercmp updpkgsums makepkg git jq; do
    command -v "$cmd" >/dev/null 2>&1 || {
        err "required command not found: $cmd"
        exit 1
    }
done

if ! gh auth status >/dev/null 2>&1; then
    err "gh is not authenticated — run 'gh auth login' first"
    exit 1
fi

[[ -d $aur_dir ]] || {
    err "AUR directory not found: $aur_dir"
    exit 1
}

# ---------------------------------------------------------------------------- #
# Helpers
# ---------------------------------------------------------------------------- #

# Read selected variables from a PKGBUILD in an isolated subshell.
# Prints: pkgname\npkgver\nurl\nsource[*]
read_pkgbuild() {
    (
        set +euo pipefail
        # shellcheck disable=SC1090
        source "$1" >/dev/null 2>&1
        printf '%s\n' "${pkgname:-}" "${pkgver:-}" "${url:-}" "${source[*]:-}"
    )
}

# Extract owner/repo from the first github.com URL among the given strings.
github_slug() {
    local s
    for s in "$@"; do
        if [[ $s =~ github\.com[/:]([^/]+)/([^/ ]+) ]]; then
            local owner=${BASH_REMATCH[1]} repo=${BASH_REMATCH[2]}
            printf '%s/%s\n' "$owner" "${repo%.git}"
            return 0
        fi
    done
    return 1
}

# Latest stable release tag for a repo; falls back to the highest semver tag.
latest_tag() {
    local slug=$1 tag
    if tag=$(gh api "repos/$slug/releases/latest" --jq '.tag_name' 2>/dev/null) && [[ -n $tag ]]; then
        printf '%s\n' "$tag"
        return 0
    fi
    # No published releases — pick the highest tag by vercmp.
    local best='' t
    while IFS= read -r t; do
        [[ -n $t ]] || continue
        if [[ -z $best ]] || [[ $(vercmp "${t#v}" "${best#v}") -gt 0 ]]; then
            best=$t
        fi
    done < <(gh api "repos/$slug/tags?per_page=100" --jq '.[].name' 2>/dev/null || true)
    [[ -n $best ]] && printf '%s\n' "$best"
}

# Turn an upstream tag into a valid pkgver: drop leading v, '-' -> '_'.
tag_to_pkgver() {
    local v=$1
    [[ $v =~ ^v[0-9] ]] && v=${v#v}
    printf '%s\n' "${v//-/_}"
}

# Replace `pkgver=...` / `pkgrel=...` lines, preserving an existing quote style.
set_pkgbuild_var() {
    local file=$1 key=$2 val=$3
    if grep -qE "^${key}=\"" "$file"; then
        sed -i -E "s|^${key}=\"[^\"]*\"|${key}=\"${val}\"|" "$file"
    else
        sed -i -E "s|^${key}=.*|${key}=${val}|" "$file"
    fi
}

# ---------------------------------------------------------------------------- #
# Main
# ---------------------------------------------------------------------------- #
declare -a updated=() current=() skipped=() failed=()

info "Scanning ${C_BOLD}${aur_dir}${C_RESET}"
[[ $dry_run -eq 1 ]] && warn "dry-run: no changes will be made"
echo

for dir in "$aur_dir"/*/; do
    pkgbuild="$dir/PKGBUILD"
    [[ -f $pkgbuild ]] || continue
    name=$(basename "$dir")

    mapfile -t fields < <(read_pkgbuild "$pkgbuild")
    pkgname=${fields[0]:-$name}
    pkgver=${fields[1]:-}
    url=${fields[2]:-}
    sources=${fields[3]:-}

    # Skip VCS packages.
    if [[ $pkgname == *-git ]] || [[ $pkgver =~ ^r[0-9]+\. ]]; then
        skip "$pkgname — VCS package (versioned from checkout)"
        skipped+=("$pkgname")
        continue
    fi

    if [[ -z $pkgver ]]; then
        warn "$pkgname — could not read pkgver"
        failed+=("$pkgname")
        continue
    fi

    if ! slug=$(github_slug "$url" "$sources"); then
        warn "$pkgname — no github.com source found; skipping"
        skipped+=("$pkgname")
        continue
    fi

    tag=$(latest_tag "$slug" || true)
    if [[ -z $tag ]]; then
        warn "$pkgname — no upstream release/tag found for $slug"
        failed+=("$pkgname")
        continue
    fi

    new_pkgver=$(tag_to_pkgver "$tag")

    if [[ $(vercmp "$new_pkgver" "$pkgver") -le 0 ]]; then
        ok "$pkgname ${C_DIM}${pkgver}${C_RESET} — current"
        current+=("$pkgname")
        continue
    fi

    info "$pkgname ${C_YELLOW}${pkgver} → ${new_pkgver}${C_RESET} (${slug})"

    if [[ $dry_run -eq 1 ]]; then
        updated+=("$pkgname $pkgver -> $new_pkgver (not applied)")
        continue
    fi

    (
        cd "$dir" || exit 1
        set_pkgbuild_var PKGBUILD pkgver "$new_pkgver"
        set_pkgbuild_var PKGBUILD pkgrel 1

        echo "  recomputing checksums…"
        if ! updpkgsums >/dev/null 2>&1; then
            git checkout -- PKGBUILD
            err "$pkgname — updpkgsums failed (artifact missing or renamed?); reverted"
            exit 3
        fi

        makepkg --printsrcinfo >.SRCINFO

        git add -A
        git commit -q -m "upgpkg: $pkgname $new_pkgver-1" || {
            err "$pkgname — nothing to commit / commit failed"
            exit 3
        }
    ) || {
        failed+=("$pkgname")
        continue
    }

    # Push (with confirmation unless --yes).
    do_push=1
    if [[ $assume_yes -eq 0 ]]; then
        printf '  %spush %s %s to AUR? [y/N]%s ' "$C_CYAN" "$pkgname" "$new_pkgver" "$C_RESET"
        read -r reply </dev/tty || reply=''
        [[ $reply =~ ^[Yy] ]] || do_push=0
    fi

    if [[ $do_push -eq 1 ]]; then
        if git -C "$dir" push >/dev/null 2>&1; then
            ok "$pkgname pushed ($new_pkgver-1)"
            updated+=("$pkgname $pkgver -> $new_pkgver (pushed)")
        else
            err "$pkgname — git push failed (commit is local)"
            failed+=("$pkgname")
        fi
    else
        skip "$pkgname committed locally, push skipped"
        updated+=("$pkgname $pkgver -> $new_pkgver (committed, not pushed)")
    fi
done

# ---------------------------------------------------------------------------- #
# Summary
# ---------------------------------------------------------------------------- #
echo
info "Summary"
printf '  %sup to date:%s %d   %supdated:%s %d   %sskipped:%s %d   %sfailed:%s %d\n' \
    "$C_GREEN" "$C_RESET" "${#current[@]}" \
    "$C_YELLOW" "$C_RESET" "${#updated[@]}" \
    "$C_DIM" "$C_RESET" "${#skipped[@]}" \
    "$C_RED" "$C_RESET" "${#failed[@]}"

if [[ ${#updated[@]} -gt 0 ]]; then
    echo
    printf '%sUpdated:%s\n' "$C_BOLD" "$C_RESET"
    printf '  • %s\n' "${updated[@]}"
fi

if [[ ${#failed[@]} -gt 0 ]]; then
    echo
    printf '%sFailed:%s\n' "$C_RED$C_BOLD" "$C_RESET"
    printf '  • %s\n' "${failed[@]}"
    exit 1
fi
