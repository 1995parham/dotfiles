# Scripts

These are applications that I use in a daily manner, so I created a nice and easy way to install them.

## Package Managers

The following operating systems and their package managers are supported:

- Archlinux:
  - [Pacman](https://archlinux.org/pacman/)
  - [Yet another Yogurt](https://github.com/Jguer/yay)
- OSx
  - [Brew](https://brew.sh)

## Applications

For each package, I mentioned its _script_ and how you can run it. Application that has their command in all lower case
means you can run them from CLI, but those have title case are the one you need to lunch them from your luncher.
`(?)` means the application did cause good experience for me on that OS.

|         Role          | Install                                           | Archlinux                                 | OSx                               |
| :-------------------: | :------------------------------------------------ | :---------------------------------------- | :-------------------------------- |
|        Anydesk        | anydesk-bin (yay)                                 | Anydesk                                   | -                                 |
|        Browser        | ./start.sh browser                                | Firefox, Firefox Developer Edition        | Firefox                           |
|       Calendar        | ./start.sh env                                    | `cal`, `jcal`                             | -                                 |
|        Camera         | guvcview (pacman)                                 | `guvcview`                                | Photo Booth                       |
| cat clone with wings  | ./start.sh env                                    | `bat`                                     | `bat`                             |
|   Container Engine    | ./start.sh docker                                 | `docker`                                  | Docker Desktop                    |
|   Container Engine    | ./start.sh podman                                 | `podman`                                  | `podman`                          |
|    Desktop Manager    | ./archinstall/sway.sh                             | `greetd`, `greetd-tuigreet`               | -                                 |
|      Dictionary       | ./start.sh def                                    | `def`                                     | `def`                             |
|   Download Manager    | ./start.sh env                                    | `aria2c`                                  | `aria2c`                          |
|    Drawing Diagram    | ./start.sh drawio                                 | `drawio`                                  | `drawio`                          |
|         Emacs         | ./start.sh emacs                                  | `emacs`                                   | `emacs` (?)                       |
|   GNU Privacy Guard   | ./start.sh env                                    | `gpg`                                     | -                                 |
|     Habit Tracker     | ./start.sh dijo                                   | `dijo`                                    | -                                 |
|  HTTP/gRPC Load Test  | ./start.sh env                                    | `k6`                                      | `k6`                              |
|     Image Editor      | ./start.sh image                                  | GNU Image Manipulation Program, `convert` | Preview                           |
|     Image Viewer      | ./start.sh sway                                   | `imv`                                     | Preview                           |
|        Luncher        | ./start.sh sway                                   | `rofi`                                    | -                                 |
|       mp3 Tags        | strawberry (pacman)                               | Strawberry                                | iTunes                            |
|     Music Player      | ./start.sh mpd                                    | `mpc`, `ncmpcpp`                          | -                                 |
|        neovim         | ./start.sh neovim                                 | `nvim`                                    | `nvim`                            |
|      Networking       | NetworkManager with `archinstall`                 | `nmtui`, `nmcli`                          | -                                 |
| Network Time Protocol | chrony (pacman)                                   | -                                         | -                                 |
|     Note Keeping      | xournalpp (pacman)                                | Xournalpp                                 | Xournalpp                         |
|     Office Suite      | libreoffice-fresh + libreoffice-fresh-fa (pacman) | LibreOffice                               | Office                            |
|    Packet Sniffer     | wireshark-qt (pacman)                             | Wireshark                                 | -                                 |
|   Password Manager    | ./start.sh gopass                                 | `gopass`                                  | `gopass`                          |
|      PDF Viewer       | ./start.sh sway                                   | `mupdf`                                   | Preview                           |
|     Power Manager     | xfce-power-manager (pacman)                       | -                                         | -                                 |
|         Skype         | skypeforlinux-preview-bin (yay)                   | Skype Preview                             | Skype                             |
|       Speedtest       | speedtest-cli (pacman)                            | -                                         | -                                 |
|      Status Bar       | polybar (pacman)                                  | iglance (brew)                            | -                                 |
|         sudo          | sudo                                              | sudo                                      | sudo (scoop)                      |
|       Syncthing       | syncthing (pacman)                                | syncthing (brew)                          | SyncTrayzor (winget)              |
|   Terminal Emulator   | alacritty + kitty (pacman)                        | alacritty (brew)                          | Windows Terminal Preview (winget) |
| Terminal Multiplexer  | tmux (pacman)                                     | tmux (brew)                               | tmux (wsl)                        |
|     Time Manager      | timew (pacman)                                    | timew (brew)                              | -                                 |
|     Video Editor      | ffmpeg (pacman)                                   | ffmpeg (brew)                             | ffmpeg (scoop)                    |
|     Video Player      | mpv (pacman)                                      | mpv (brew)                                | vlc (winget)                      |
|          vim          | vim (pacman)                                      | vim (brew)                                | vim (wsl)                         |
|       Wallpaper       | nitrogen (pacman)                                 | -                                         | -                                 |
|    Window Manager     | i3 (pacman)                                       | -                                         | -                                 |
|  Youtube Downloader   | youtube-dl (pacman)                               | youtube-dl (brew)                         | youtube-dl (scoop)                |
