#!/usr/bin/env bash
usage() {
    echo "A popular general-purpose scripting language that is especially suited to web development."

    # shellcheck disable=1004,2016
    echo '
       _
 _ __ | |__  _ __
| |_ \| |_ \| |_ \
| |_) | | | | |_) |
| .__/|_| |_| .__/
|_|         |_|
  '
}

main_pacman() {
    require_pacman php composer
    require_pacman php-intl php-sqlite php-gd
}

main_apt() {
    require_apt php php-cli composer
    require_apt php-mbstring php-xml php-curl
    require_apt php-intl php-sqlite3 php-gd php-zip
}

main_brew() {
    require_brew php composer
    # Homebrew's PHP includes most common extensions by default
}

main_pkg() {
    require_pkg php composer
}

main() {
    # Install LSP and development tools via Mason
    require_mason phpactor
    require_mason php-cs-fixer
    require_mason phpstan

    # Install global composer tools if composer is available
    if command -v composer &>/dev/null; then
        if yes_or_no "php" "Install global composer tools (phpunit, psalm)?"; then
            msg "Installing global composer packages" "info"
            composer global require --quiet \
                phpunit/phpunit \
                vimeo/psalm 2>/dev/null || msg "Failed to install some composer packages" "warn"
        fi
    fi

    # Show installed PHP version
    if command -v php &>/dev/null; then
        php_version=$(php -v | head -n1)
        msg "Installed: $php_version" "success"
    fi
}
