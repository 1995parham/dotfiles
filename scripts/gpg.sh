#!/usr/bin/env bash
usage() {
    echo "The GNU Privacy Guard"

    # shellcheck disable=1004,2016
    echo '

  __ _ _ __   __ _
 / _` | |_ \ / _` |
| (_| | |_) | (_| |
 \__, | .__/ \__, |
 |___/|_|    |___/
  '
}

root=${root:?"root must be set"}

# keep a passphrase cached for 14h, so a long unattended job (e.g. a timed
# aws-vault run from an agent with no tty for pinentry) outlives one unlock.
cache_ttl() {
    grep -q "^default-cache-ttl" "$HOME/.gnupg/gpg-agent.conf" 2>/dev/null ||
        (printf "default-cache-ttl 50400\nmax-cache-ttl 50400\n" >>"$HOME/.gnupg/gpg-agent.conf")
}

main_pacman() {
    require_pacman gnupg rng-tools
    mkdir -p "$HOME/.gnupg"

    if yes_or_no "gpg" "do you have graphical user interface?"; then
        pinentry_program="/usr/bin/pinentry-gnome3"
    else
        pinentry_program="/usr/bin/pinentry-tty"
    fi

    grep -i "pinentry-program $pinentry_program" "$HOME/.gnupg/gpg-agent.conf" &>/dev/null ||
        (printf "pinentry-program %s\n" "$pinentry_program" >>"$HOME/.gnupg/gpg-agent.conf")
    cache_ttl
}

main_apt() {
    require_apt gnupg2 git rng-tools
}

main_brew() {
    require_brew pinentry-mac gpg

    # gpg itself creates ~/.gnupg lazily, so on a fresh mac the append below
    # fails to open the file and takes the whole run down under `set -e`.
    mkdir -p "$HOME/.gnupg"
    chmod 0700 "$HOME/.gnupg"

    pinentry_program="$(brew --prefix)/bin/pinentry-mac"

    grep -i "pinentry-program $pinentry_program" "$HOME/.gnupg/gpg-agent.conf" &>/dev/null ||
        (printf "pinentry-program %s\n" "$pinentry_program" >>"$HOME/.gnupg/gpg-agent.conf")
    cache_ttl

    # pinentry-mac reads this GPG Suite domain for its keychain settings, but
    # brew's standalone build ships without GPG Suite, so the domain does not
    # exist and reading it errors with
    #   Error: Domain 'org.gpgtools.common' not found.
    # writing the preference creates the domain and settles the question.
    defaults write org.gpgtools.common DisableKeychain -bool YES

    # exits 1 when no agent is running, which is not a failure here.
    pkill gpg-agent || true
}

main() {
    return 0
}

main_parham() {
    return 0
}
