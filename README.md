```
     _       _    __ _ _
  __| | ___ | |_ / _(_) | ___  ___
 / _` |/ _ \| __| |_| | |/ _ \/ __|
| (_| | (_) | |_|  _| | |  __/\__ \
 \__,_|\___/ \__|_| |_|_|\___||___/

 _  ___   ___  ____                   _
/ |/ _ \ / _ \| ___| _ __   __ _ _ __| |__   __ _ _ __ ___
| | (_) | (_) |___ \| '_ \ / _` | '__| '_ \ / _` | '_ ` _ \
| |\__, |\__, |___) | |_) | (_| | |  | | | | (_| | | | | | |
|_|  /_/   /_/|____/| .__/ \__,_|_|  |_| |_|\__,_|_| |_| |_|
                    |_|
```

![GitHub](https://img.shields.io/github/license/1995parham/dotfiles?logo=gnu&style=flat-square)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/1995parham/dotfiles/Install%20dotfiles?label=install&logo=github&style=flat-square)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/1995parham/dotfiles/Shell%20Script%20Lint?label=sh-lint&logo=github&style=flat-square)

![Compatibiliy](https://img.shields.io/badge/works%20on-macos-grey?logo=macos&style=flat-square)
![Compatibiliy](https://img.shields.io/badge/works%20on-ubuntu-orange?logo=ubuntu&style=flat-square)
![Compatibiliy](https://img.shields.io/badge/works%20on-manjaro-green?logo=manjaro&style=flat-square)

## Introduction

This repository contains my personal configurations for ubuntu, manjaro (with i3 window manager), apple osx and even windows 10, which was created in Fall 2013 when I was a lonely BSc' student at the Amirkabir University of Technology.
First of all, thank you for your visiting, to find out more about how to use this configuration with neovim, oh-my-zsh, etc. please check the following sections.
Special thanks to [@elahe-dastan](https://github.com/elahe-dastan) for using this project and reporting its issues. Her unique contribution to this repository and my life is unforgettable.

## Installation (Linux, OSx)

The following command creates a basic directory structure and clones the _dotfiles_ repository:

```sh
curl -sL https://raw.githubusercontent.com/1995parham/dotfiles/main/over-the-air-installation.sh | bash
```

Install required softwares with pacman/brew.

```sh
./start.sh env
```

Install configuration files with soft-links. This script also sets the zsh as a default shell and installs plugins on neovim and vim.

```sh
./install.sh
```

Install useful fonts.

```sh
./start.sh font
```

**Don't** forget the git credential setup:

```sh
touch $HOME/.gitconfig
git config --global user.name "Parham Alvani"
git config --global user.email "parham.alvani@gmail.com"
```

Then you can install other tools with `start.sh`, here are some examples:

```sh
# install docker with proxy (see <Breaking Sanctions> section for more details)
./start.sh docker
# install golang
./start.sh go
# install python
./start.sh python
# and many many more...
```

Configuration of mentioned applications also is a part of this repository.

## Installation (Windows)

First of all you need to install `scoop` and `chocolatey` as package managers and also add the `extra` bucket for `scoop`. **Install Everything by one of these package managers**. It can also be done by `.\start.ps1 env` too.

Then you can start installing the required application by hand from the application list.
I cannot use `vim` or `neovim` on windows so I use them on WSL with Ubuntu 20.04 and use VScode on Windows.
Also it would be nice to install [pshazz](https://github.com/lukesampson/pshazz) based on [this](https://github.com/lukesampson/scoop/wiki/Theming-Powershell) article to have nice powershell.

Following script install package managers besides some useful packages:

```powershell
.\start.ps1 env
.\start.ps1 font
```

Currently I use WSL with `git.exe` because of its hanging issue and also I have to remove passphase for windows private key because there is no way to store it somewhere.

I use `Windows Terminal` as my primary terminal with the follwing configuration:

```json
{
  "profiles": {
    "defaults": {
      "fontFace": "JetBrains Mono",
      "fontSize": 12
    }
  }
}
```

check [here](https://garrytrinder.github.io/2020/12/my-wsl2-windows-terminal-setup) for more information about beautiful wsl terminal.

Also it is fun to install `powertoys` with `sudo choco install powertoys`.

## Firefox

I am using firefox as a main browser for daily basis.
Firefox is awesome and the latest version of my bookmarks are sync on it.
Firefox containers is a good way to have multiple account on the same time on a browser.

| Name     | Color  |          Gmail          |    Github     |
| :------- | :----: | :---------------------: | :-----------: |
| Main     |  None  | parham.alvani@gmail.com |  1995parham   |
| Personal |  Blue  |  1995parham@gmail.com   | parham-alvani |
| Elahe    | Yellow |  elahe.dstn@gmail.com   | elahe-dastan  |
