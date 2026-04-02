#!/usr/bin/env bash

usage() {
    echo -n -e "queen needs spark, spark needs java"

    # shellcheck disable=1004,2016
    echo '
   _
  (_) __ ___   ____ _
  | |/ _` \ \ / / _` |
  | | (_| |\ V / (_| |
 _/ |\__,_| \_/ \__,_|
|__/
  '
}

main_apt() {
    require_apt openjdk-21-jdk

    msg "install scala because of the queen"
    echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee /etc/apt/sources.list.d/sbt.list
    curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/sbt.gpg
    sudo apt-get update
    require_apt sbt
}

main_pacman() {
    require_pacman jdk21-openjdk gradle maven
    msg "install scala because of the queen"
    require_pacman sbt
}

main_brew() {
    msg "install scala because of the queen"
    require_brew openjdk@21 sbt gradle

    if ! grep -q -F "export PATH=\"/opt/homebrew/opt/openjdk@21/bin:\$PATH\"" "$HOME/.bashrc"; then
        echo "export PATH=\"/opt/homebrew/opt/openjdk@21/bin:\$PATH\"" | tee -a "$HOME/.bashrc"
    fi

    if ! grep -q -F "export PATH=\"/opt/homebrew/opt/openjdk@21/bin:\$PATH\"" "$HOME/.zshrc"; then
        echo "export PATH=\"/opt/homebrew/opt/openjdk@21/bin:\$PATH\"" | tee -a "$HOME/.zshrc"
    fi
}

main() {
    proxy_start &&
        require_mason jdtls &&
        proxy_stop
}
