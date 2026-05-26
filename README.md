# Dotfiles

My personal dotfiles, managed with GNU Stow on Arch Linux.

## Stack

| Role | Tool |
|---|---|
| Window manager | Hyprland |
| Bar | Waybar |
| Desktop dashboard | Quickshell |
| App launcher | Walker |
| Terminal | Foot |
| Shell | Zsh |
| Multiplexer | Tmux |
| Editor | Neovim |
| File manager | Vifm |
| Notifications | Swaync |
| Email client | Neomutt |
| PDF viewer | Zathura |
| Music | cmus |
| Lock / idle | Hyprlock + Hypridle |

## Desktop Dashboard

A Quickshell-based desktop dashboard rendered on the bottom layer. Widgets pull live data via Python scripts backed by a venv:

- **Calendar** — monthly calendar with current day highlighted
- **Email** — unread Gmail messages (filtered by domain)
- **Today** — Google Calendar events for the day
- **Tasks** — open tasks from Tududi
- **Jira** — in-progress and selected-for-development issues assigned to me
- **World Clocks** — multiple timezone clocks
- **Forex** — live USD → MXN rate via frankfurter.dev
- **Servers** — quick status check on personal servers

Secrets (API tokens, email, Jira domain) are managed via `pass`.

On multi-monitor setups the dashboard shows only on the monitor assigned to workspace 10. On a single monitor it shows on whatever is connected.

## Installation

Two scripts help reinstall Arch from scratch with my preferences:

Boot into a clean Arch ISO, install git, then:

```zsh
git clone https://github.com/mxdevmanuel/dotfiles.git
cd dotfiles/installation && zsh archbase.zsh
```

Follow the prompts. After chroot:

```zsh
cd ~/dotfiles/installation && zsh archroot.zsh
```

At this point you have a running Arch install. To spread dotfiles, configure git, Neovim, Zsh, install user systemd services, the Python venv, GTK theme and fonts:

```zsh
su <username>
cd ~/.dotfiles/installation && zsh archuser.zsh
```

The scripts handle the usual boilerplate: LANG, hosts, useradd, EFI, ucode, systemd-boot, GPT, btrfs, systemd-networkd, reflector, pipewire, doas, etc. They're a helper, not a full automated installer.

## Fonts and GTK theme

```zsh
git submodule init        # download fonts
zsh .gtk/install.zsh      # download and apply GTK theme
```

## Recommendations

### Git hooks

```zsh
git config --local core.hooksPath git/githooks
```

### Backups

btrfs is my preferred filesystem for `/`, `/home` and `/shared` for snapshot capabilities and SSD performance. I snapshot `/home` to `/shared` daily when the system is idle.

To use the backup setup: edit `system/backup/btrfs-backup.sh` and set `$BCKPFOLDER`, copy the script to `/usr/bin`, copy the `.service` and `.timer` to `/etc/systemd/system`, then:

```
# systemctl enable --now btrfs-backup.timer
```

> `/shared` is usually an HDD for big files, dual-boot sharing, and backups.

### Keyboard

I use 60% programmable mechanical keyboards as daily drivers but that's not always possible on a laptop, so I use [keyd](https://github.com/rvaiya/keyd) to remap the built-in keyboard. Config lives in `system/keyd/`. Key changes:

- `Caps` → hold: `Ctrl`, tap: `Esc`
- `L_Alt` ↔ `L_Super` swapped
- `R_Alt` → hold: second layer, tap: Menu

**Second layer:**

| key | mapping | key | mapping |
|---|---|---|---|
| h | left | z | kp1 |
| j | down | x | kp2 |
| k | up | c | kp3 |
| l | right | a | kp4 |
| esc | numlock | s | kp5 |
| leftmeta | kpdot | d | kp6 |
| space | kpenter | q | kp7 |
| 1 | kpplus | w | kp8 |
| 2 | kpminus | e | kp9 |
| 3 | kpasterisk | leftalt | kp0 |
| 4 | kpequal | | |

```
# systemctl enable --now keyd.service
```

## Packages

Full package list: `installation/hyprlandconf.pkgs`

### AUR / non-repo

- quickshell
- walker
- keyd
- nq
- cava
- mpv-mpris
- kmscon-patched-git, libtsm-patched-git
- xxd-standalone
- ripmime
- imapfilter
- [mail-query](https://github.com/mxdevmanuel/mail-query)
