
# Dotfiles

My personal dotfiles, manage with GNU stow and used in Archlinux

# To install

I have concocted 2 scripts to ease the installation of arch, to help me reinstall if I ever need to, with _my_ personal preferences

A (Non comprehensive) list of them are:

	- EFI
	- ucode
	- systemd-boot (option to install grub)
	- btrfs w/backups (option to format as ext4)
	- systemd-networkd
	- iwd (if wireless)
	- pipewire
	- doas (instead of sudo)
	- sway (option for i3)
	- neovim

To install just boot into a clean arch iso and
	
	git clone https://github.com/mxdevmanuel/dotfiles.git && cd installation && zsh archbase.zsh

and follow the prompts and then after chroot 

	cd ; cd dotfiles/installation ; zsh archroot.zsh

up to these point you will have a running arch install with everything I need, an extra step which is stil WIP could be

	su <username> ; cd ; zsh .dotfiles/installation/archuser.zsh

this will ATM help you setup git, disperse the dotfiles you want to use, create a virtualenv for certain commands to run on and setup neovim, however I have'nt used this script yet during and installation as it is still pretty early progress and I would suggest to doit manually for the time being.


### Comments

Instead of an installer this is a helper to avoid all the repetitive commands that have to be run and boilerplating that has to be done for LANG, hosts, useradd, etc. and to avoid forgetting any important step.

I know of archinstall and maybe someday I'll redo my script with it's library but doing it this way was more fun.

# Fonts and theme

To download fonts run the following command and stow _local_
        
        git submodule init

To download and set the gtk theme

        zsh .gtk/install.zsh

# Recommendations

Run this command to use my git hooks

	git config --local core.hooksPath git/githooks

# Packages

## AUR and  non-repo software
- nq
- wob
- cava
- mpv-mpris
- kmscon-patched-git, libtsm-patched-git
- keyd
- xxd-standalone

