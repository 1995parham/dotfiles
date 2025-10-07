<h1 align="center">1995parham's dotfiles</h1>

<p align="center">
    <img alt="GitHub" src="https://img.shields.io/github/license/1995parham/dotfiles?logo=gnu&style=for-the-badge">
    <img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/1995parham/dotfiles/install.yaml?logo=github&style=for-the-badge&label=install">
    <img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/1995parham/dotfiles/sh-lint.yaml?label=lint&logo=github&style=for-the-badge">
    <a href="https://github.com/1995parham-me/ansible-role">
        <img alt="Ansible" src="https://img.shields.io/badge/ansible-ready-black?logo=ansible&style=for-the-badge">
    </a>
    <img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/1995parham/dotfiles?style=for-the-badge">
    <img alt="GitHub Created At" src="https://img.shields.io/github/created-at/1995parham/dotfiles?style=for-the-badge&logo=github">
</p>

## Introduction

This repository contains personal `dotfiles` for configuring various development tools and shell environments.
These `dotfiles` are designed for macOS and Linux systems.

`Dotfiles` repositories facilitate the management of configurations across different systems.
This repository is available as a template for creating your own personal `dotfiles` setup.

## Installation

<p align="center">
    <img alt="Compatibility" src="https://img.shields.io/badge/works%20on-macos-white?logo=macos&style=for-the-badge">
    <img alt="Compatibility" src="https://img.shields.io/badge/works%20on-ubuntu-orange?logo=ubuntu&style=for-the-badge">
    <img alt="Compatibility" src="https://img.shields.io/badge/works%20on-arch-blue?logo=archlinux&style=for-the-badge">
</p>

You need to first install an operating system to use these `dotfiles`,
For installing [`ArchLinux`](https://archlinux.org/) from scratch with [`archinstall`](https://github.com/archlinux/archinstall/),
please check [here](./archinstall).

For macOS setup, run the following scripts:

```bash
# install brew with the default configuration.
./start.sh brew
# configure osx with Parham's preferences.
./start.sh macos
```

To install these `dotfiles` on a fresh system, run the following command:

```bash
git clone https://github.com/1995parham/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./start.sh env && ./install.sh
```

This will clone the repository into your home directory (`~/.dotfiles`), and run the `start.sh env` script to install
required tools and then run `install.sh` script to
create symbolic links between the `dotfiles` and their expected locations in your home directory.

After that, you can set `zsh` as your default terminal (you can use bash too, there is no hard requirement to use `zsh`):

```bash
sudo chsh $USER -s /bin/zsh
```

Run `start.sh font` script to install useful fonts (obviously on a desktop system):

```bash
./start.sh font
```

**Don't** forget to set the git username and email:

```bash
touch $HOME/.config/git/config
```

or run the setup script to use default values:

```bash
./start.sh git
```

Run `start.sh neovim` script to install `neovim` with [`ElieVIM`](https://github.com/1995parham/elievim) configurations:

```bash
./start.sh neovim
```

## Usage

These `dotfiles` configure various tools and applications. You can install them by running:

```bash
./start.sh <name>
```

To see all available options with descriptions, run:

```bash
./start.sh list
```
