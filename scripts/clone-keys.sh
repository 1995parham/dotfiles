#!/usr/bin/env bash

usage() {
    echo "clone github.com/parham-alvani/keys repository using encrypted token"

    # shellcheck disable=1004,2016
    echo '
      _                        _
  ___| | ___  _ __   ___      | | _____ _   _ ___
 / __| |/ _ \| |_ \ / _ \_____| |/ / _ \ | | / __|
| (__| | (_) | | | |  __/_____|   <  __/ |_| \__ \
 \___|_|\___/|_| |_|\___|     |_|\_\___|\__, |___/
                                        |___/
  '
}

root=${root:?"root must be set"}

pre_main() {
    return 0
}

main_pacman() {
    return 0
}

main_xbps() {
    return 0
}

main_apt() {
    return 0
}

main_pkg() {
    return 0
}

main_brew() {
    return 0
}

main() {
    return 0
}

encrypt_token() {
    msg "encrypting GitHub token"

    read -r -s -p "Enter your GitHub token: " TOKEN
    echo
    read -r -s -p "Enter passphrase: " PASSPHRASE
    echo

    local encrypted_token_file="${root}/secrets/github-token-keys.enc"
    mkdir -p "${root}/secrets"

    if echo -n "$TOKEN" | openssl enc -aes-256-cbc -salt -pbkdf2 -iter 600000 -out "$encrypted_token_file" -pass pass:"$PASSPHRASE"; then
        msg "token encrypted and saved to ${encrypted_token_file}" "success"
        msg "using AES-256-CBC with PBKDF2 (600000 iterations)" "info"
        msg "you can now commit this encrypted file to the repository"
    else
        msg "failed to encrypt token" "error"
        return 1
    fi
}

decrypt_and_clone() {
    local repo_url="github.com/parham-alvani/keys"
    local clone_path="$HOME/Documents/Git/parham/keys"
    local encrypted_token_file="${root}/secrets/github-token-keys.enc"

    if [ ! -f "$encrypted_token_file" ]; then
        msg "encrypted token file not found at ${encrypted_token_file}" "error"
        msg "run with --setup to encrypt your token first" "notice"
        return 1
    fi

    local token
    local passphrase

    read -r -s -p "Enter passphrase: " passphrase
    echo

    if ! token=$(openssl enc -aes-256-cbc -d -pbkdf2 -iter 600000 -in "$encrypted_token_file" -pass pass:"$passphrase" 2>/dev/null) || [ -z "$token" ]; then
        msg "failed to decrypt token. wrong passphrase?" "error"
        return 1
    fi

    mkdir -p "$(dirname "$clone_path")"

    if [ -d "$clone_path" ]; then
        msg "directory ${clone_path} already exists" "notice"
        if yes_or_no "clone-keys" "would you like to update it instead?"; then
            cd "$clone_path" || return 1
            git pull "https://${token}@${repo_url}"
            msg "repository updated successfully" "success"
        fi
    else
        msg "cloning repository..."

        if git clone "https://${token}@${repo_url}" "$clone_path"; then
            msg "repository cloned successfully to ${clone_path}" "success"
        else
            msg "failed to clone repository" "error"
            return 1
        fi
    fi

    unset token
    unset passphrase
}

main_parham() {
    if [ "${1:-x}" == "--setup" ]; then
        encrypt_token
    else
        decrypt_and_clone
    fi
}
