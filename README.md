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

## Table of Contents

- [Introduction](#introduction)
- [What's Included](#whats-included)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Updating](#updating)
- [Troubleshooting](#troubleshooting)

## Introduction

This repository contains personal `dotfiles` for configuring various development tools and shell environments.
These `dotfiles` are designed for macOS and Linux systems.

`Dotfiles` repositories facilitate the management of configurations across different systems.
This repository is available as a template for creating your own personal `dotfiles` setup.

## What's Included

This repository provides configurations for 65+ tools and applications, organized into the following categories:

### Shells & Terminals

- **Shells**: zsh (with oh-my-zsh), bash, fish
- **Terminal Emulators**: alacritty, kitty, wezterm, iTerm2
- **Prompt**: starship (with fallback to custom theme)
- **Multiplexer**: tmux (with tmuxp for session management)

### Editors & IDEs

- **Neovim**: Integration with [ElieVIM](https://github.com/1995parham/elievim)
- **Vim**: Classic vim configurations
- **Emacs**: Custom configurations
- **VS Code**: Settings and extensions
- **Zed**: Modern code editor setup

### Window Managers & Desktop

- **Linux**: i3, awesome, hyprland, sway (Wayland)
- **macOS**: AeroSpace (tiling window manager)
- **Display Protocols**: X11, Wayland configurations

### Development Tools

- **Version Control**: git, gh (GitHub CLI)
- **Languages**: Node.js, Python, Go, Erlang, PHP, Java, C/C++
- **Package Managers**: npm/nvm, mamba, brew
- **Build Tools**: bazel, make
- **Databases**: mongosh (MongoDB shell)

### Container & Cloud Tools

- **Containers**: docker, kind, minikube
- **Kubernetes**: k9s (terminal UI)
- **Cloud**: AWS CLI
- **DNS**: CoreDNS configurations

### System Utilities

- **Monitoring**: btop, below
- **Networking**: curl, wget, httpie
- **File Management**: custom bin scripts
- **System Config**: fontconfig, udev rules, tmpfiles
- **Boot**: dracut, plymouth

### Media & Communication

- **Media Players**: mpv, mpd, cmus
- **Browsers**: firefox, chrome configurations
- **Remote Desktop**: anydesk, jumpdesktop
- **Communication**: discord

### Productivity

- **Calendar**: khal (calendar)
- **Contacts**: khard (contacts)
- **Notes**: navi (cheatsheets)
- **Time Tracking**: wakatime
- **Screenshots**: Configuration scripts

### Additional Tools

- **Display Info**: fastfetch
- **Archive Tools**: Custom extraction scripts
- **Proxy**: Configuration helpers
- **Security**: Secrets management templates

For a complete list of available installation scripts, run `./start.sh list`.

## Prerequisites

Before installing these dotfiles, ensure you have the following:

### Required

- **Git**: Version 2.0 or higher
- **Bash**: Version 4.0 or higher (already installed on most systems)
- **A Unix-like operating system**: macOS, Ubuntu, Arch Linux, or similar

### Recommended

- **zsh**: For the full shell experience (can also use bash)
- **curl** or **wget**: For downloading additional components
- **sudo access**: Required for installing system packages

### Notes

- The installation will check for required tools (bash, zsh, tmux, vim) and notify you if any are missing
- Most tools will be installed automatically via the setup scripts
- Some configurations require desktop environment (fonts, window managers, etc.)
- **Backup your existing dotfiles** before installation, as this will create symbolic links that may overwrite existing configurations

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

**Don't** forget to configure git with your username and email. You have two options:

**Option 1**: Use the automated setup script (recommended):

```bash
./start.sh git
```

**Option 2**: Manually configure git:

```bash
# Create the config file
touch $HOME/.config/git/config

# Edit it and add your information:
# [user]
#     name = Your Name
#     email = your.email@example.com
```

Run `start.sh neovim` script to install `neovim` with [`ElieVIM`](https://github.com/1995parham/elievim) configurations:

```bash
./start.sh neovim
```

## Usage

These `dotfiles` configure various tools and applications. You can install individual components using the modular `start.sh` script:

```bash
./start.sh <name>
```

### Common Commands

Here are some popular setup commands you might want to run:

```bash
# Development environment
./start.sh neovim       # Install Neovim with ElieVIM configuration
./start.sh git          # Configure Git with user settings
./start.sh tmux         # Set up tmux multiplexer
./start.sh docker       # Configure Docker

# Language environments
./start.sh node         # Install Node.js and npm
./start.sh go           # Set up Go environment
./start.sh python       # Configure Python and pip

# Terminal tools
./start.sh alacritty    # Install Alacritty terminal
./start.sh starship     # Install Starship prompt
./start.sh font         # Install useful fonts

# System utilities
./start.sh btop         # Install btop system monitor
./start.sh k9s          # Install k9s for Kubernetes

# macOS specific
./start.sh brew         # Install Homebrew
./start.sh macos        # Apply macOS preferences
./start.sh aerospace    # Install AeroSpace window manager

# Linux specific
./start.sh i3           # Set up i3 window manager
./start.sh awesome      # Set up Awesome window manager
```

### Listing Available Options

To see all available installation scripts with descriptions:

```bash
./start.sh list
```

### Installing Multiple Tools

You can run the script multiple times to install different tools:

```bash
./start.sh neovim
./start.sh tmux
./start.sh docker
```

## Updating

To update your dotfiles to the latest version:

```bash
# Navigate to your dotfiles directory
cd ~/.dotfiles

# Pull the latest changes
git pull origin main

# Re-run the installation to update symbolic links
./install.sh

# Optionally, update specific tools
./start.sh neovim  # Update Neovim configuration
./start.sh tmux    # Update tmux configuration
```

### Updating Individual Components

Some components manage their own updates:

- **oh-my-zsh**: Updates automatically or run `omz update`
- **ElieVIM**: Update via Neovim's plugin manager
- **Homebrew** (macOS): Run `brew update && brew upgrade`

### Keeping Your Fork Updated

If you've forked this repository, sync with upstream:

```bash
# Add upstream remote (one-time setup)
git remote add upstream https://github.com/1995parham/dotfiles.git

# Fetch and merge updates
git fetch upstream
git merge upstream/main
```

## Troubleshooting

### Common Issues

**Problem**: "Permission denied" when running scripts

```bash
# Solution: Make scripts executable
chmod +x start.sh install.sh
```

**Problem**: Installation fails with "command not found"

```bash
# Solution: Install the base requirements first
./start.sh env  # Installs essential tools
```

**Problem**: Symbolic links already exist

```bash
# Solution: Backup and remove existing dotfiles
mv ~/.zshrc ~/.zshrc.backup
mv ~/.tmux.conf ~/.tmux.conf.backup
# Then re-run ./install.sh
```

**Problem**: Git configuration not working

```bash
# Solution: Ensure the config file exists and has correct format
cat ~/.config/git/config
# Should contain [user] section with name and email
```

**Problem**: Fonts not displaying correctly

```bash
# Solution: Install fonts and update font cache
./start.sh font
fc-cache -fv  # Linux
# On macOS, restart terminal after font installation
```

**Problem**: Scripts must run without root permissions

```bash
# Solution: Run as regular user, not with sudo
# The scripts will prompt for sudo when needed
./start.sh env  # Don't use: sudo ./start.sh env
```

### Getting Help

- **Check logs**: Most scripts provide detailed output
- **Script fails**: Run with `-y` flag to auto-answer prompts: `./start.sh -y env`
- **Report issues**: [GitHub Issues](https://github.com/1995parham/dotfiles/issues)
- **Contact**: parham.alvani@gmail.com

### Uninstalling

To remove dotfiles (symbolic links):

```bash
# Remove individual symlinks
rm ~/.zshrc ~/.bashrc ~/.tmux.conf ~/.vimrc

# Or identify all symlinks pointing to dotfiles
find ~ -maxdepth 1 -type l -ls | grep dotfiles
```

**Note**: This only removes symbolic links, not the installed applications.

## Contributing

While this is a personal dotfiles repository, contributions are welcome:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on a fresh system if possible
5. Submit a pull request

## License

This project is licensed under the GNU General Public License v2.0 - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with [dotfiles.lib](https://github.com/1995parham/dotfiles.lib) - Script collection for effortless dotfile management
- Inspired by the broader dotfiles community
- Uses [oh-my-zsh](https://ohmyz.sh/) for zsh configuration
- Neovim configuration powered by [ElieVIM](https://github.com/1995parham/elievim)
