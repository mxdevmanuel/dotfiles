#!/usr/bin/env zsh
#
# Post-install user setup. Run as the primary user after the first reboot:
#   ~/.dotfiles/installation/archuser.zsh
#
# Configures the Hyprland desktop: stows dotfiles, bootstraps shell/editor
# tooling, installs the AUR launcher stack + optional apps/package groups,
# enables the audio stack, and sets up greetd + bluetooth (via doas).
# Idempotent: safe to re-run.

BASE=${0:h}
source ${BASE}/utils.zsh

REPO=$HOME/.dotfiles

# ── git ─────────────────────────────────────────────────────────────────────
function git_config(){
	vared -p "Git's user 'real' name: " -c guser
	git config --global user.name $guser

	vared -p "Git's user email: " -c gemail
	git config --global user.email $gemail

	git config --global diff.tool nvimdiff
	git config --global merge.tool nvimdiff
	git config --global alias.root 'rev-parse --show-toplevel'
}

# ── dotfiles ────────────────────────────────────────────────────────────────
# Hyprland-only desktop. foot (terminal) config lives inside the hyprland
# package, so no separate terminal package is stowed.
function disperse_dotfiles(){
	pushd $REPO
	mkdir -p ~/.config/systemd ~/.gnupg ~/.local/bin ~/.local/share/fonts
	log_success "Stow" "dispersing local, neovim, tmux, zsh, hyprland"
	stow -R local neovim tmux zsh hyprland
	popd
}

# ── user services (no root needed) ──────────────────────────────────────────
function enable_user_services(){
	log_success "User services" "enabling pipewire audio stack"
	systemctl --user enable pipewire.socket pipewire-pulse.socket wireplumber.service
	# hyprpolkitagent is enabled on demand from hyprland.conf (exec-once).
}

# ── AUR (yay + launcher stack) ──────────────────────────────────────────────
# yay/makepkg must run as a non-root user, so this lives in the user stage.
# Builds use sudo internally, which is symlinked to doas (set in archroot).
function bootstrap_aur(){
	if [[ -f /etc/makepkg.conf ]] && ! grep -q "^PACMAN_AUTH=(doas)" /etc/makepkg.conf
	then
		log_success "makepkg" "configuring doas as PACMAN_AUTH (doas)"
		doas sed -i 's/^#\?\s*PACMAN_AUTH\s*=.*/PACMAN_AUTH=(doas)/' /etc/makepkg.conf
	fi

	if ! command -v yay &>/dev/null
	then
		log_success "AUR" "bootstrapping yay-bin"
		local tmp=$(mktemp -d)
		git clone --depth=1 https://aur.archlinux.org/yay-bin.git $tmp/yay-bin
		pushd $tmp/yay-bin
		makepkg -si --noconfirm
		popd
		rm -rf $tmp
	else
		log_success "AUR" "yay already installed"
	fi

	if [[ -s $BASE/aur.pkgs ]]
	then
		log_success "AUR" "installing packages from aur.pkgs"
		yay -S --needed --noconfirm $(grep -vE '^\s*#|^\s*$' $BASE/aur.pkgs)
	fi
}

# ── optional AUR apps (prompted) ────────────────────────────────────────────
function install_optional_aur(){
	local list=$BASE/optional-aur.pkgs
	[[ -s $list ]] || return 0

	unset reply
	vared -p "Install optional AUR apps (edge, slack-wayland)? (y/N): " -c reply
	if [[ "$reply" == "y" ]]
	then
		yay -S --needed --noconfirm $(grep -vE '^\s*#|^\s*$' $list)
	fi
}

# ── optional repo package groups (prompted, doas pacman) ────────────────────
function install_pkg_groups(){
	local groupsdir=$BASE/groups
	[[ -d $groupsdir ]] || return 0

	for f in $groupsdir/*.pkgs(N)
	do
		local name=${f:t:r}
		unset reply
		vared -p "Install optional group '${name}'? (y/N): " -c reply
		if [[ "$reply" == "y" ]]
		then
			log_success "Group" "installing $name (doas)"
			doas pacman -S --needed --noconfirm $(grep -vE '^\s*#|^\s*$' $f)
		fi
	done
}

# ── greetd (login manager, needs root via doas) ─────────────────────────────
function setup_greetd(){
	local cfg=$REPO/system/greetd/config.toml
	if [[ ! -f $cfg ]]
	then
		log_error "greetd config not found at $cfg"
		return 1
	fi

	# Skip if archroot already installed identical configs and enabled it.
	local pam=$REPO/system/greetd/greetd
	if systemctl is-enabled greetd.service &>/dev/null && \
	   cmp -s $cfg /etc/greetd/config.toml && \
	   ([[ ! -f $pam ]] || cmp -s $pam /etc/pam.d/greetd)
	then
		log_success "greetd" "already configured, skipping"
		return 0
	fi

	log_success "greetd" "installing config and enabling service (doas)"
	doas mkdir -p /etc/greetd
	doas cp $cfg /etc/greetd/config.toml
	if [[ -f $pam ]]
	then
		log_success "greetd" "installing PAM config (doas)"
		doas cp $pam /etc/pam.d/greetd
	fi
	doas systemctl enable greetd.service
}

# ── system services (need root via doas) ────────────────────────────────────
function enable_system_services(){
	if systemctl is-enabled bluetooth.service &>/dev/null
	then
		log_success "bluetooth" "already enabled, skipping"
	else
		log_success "bluetooth" "enabling bluetooth.service (doas)"
		doas systemctl enable bluetooth.service
	fi

	if [[ -f /etc/bluetooth/main.conf ]]
	then
		log_success "bluetooth" "configuring reconnect attempts and auto-enable in main.conf (doas)"
		doas sed -i 's/^#\s*ReconnectAttempts\s*=.*/ReconnectAttempts=7/' /etc/bluetooth/main.conf
		doas sed -i 's/^#\s*ReconnectIntervals\s*=.*/ReconnectIntervals=1,2,4,8,16,32,64/' /etc/bluetooth/main.conf
		doas sed -i 's/^#\s*AutoEnable\s*=.*/AutoEnable=true/' /etc/bluetooth/main.conf
	fi
}

# ── main ────────────────────────────────────────────────────────────────────
installation_dir=$REPO/installation
if [[ "$(pwd)" != "$installation_dir" ]]
then
	pushd $installation_dir
fi

vared -p "Wish to configure git now: (Y/n) " -c cgitconfig
if [[ "${cgitconfig}" != "n" ]]
then
	git_config
fi

log_success "Fonts" "initializing submodules (SF Mono, SF Display)"
git -C $REPO submodule update --init

log_success "Dotfiles" "dotfiles are about to be dispersed"
disperse_dotfiles

log_success "Fonts" "rebuilding font cache"
fc-cache -f

log_success "Antidote" "cloning antidote zsh plugin manager"
ANTIDOTE_HOME=$HOME/.antidote
if [[ ! -d $ANTIDOTE_HOME ]]
then
	git clone --depth=1 https://github.com/mattmc3/antidote.git $ANTIDOTE_HOME
fi

log_success "Antidote" "pre-bundling plugins from ~/.zsh_plugins.txt"
zsh -c "source $ANTIDOTE_HOME/antidote.zsh && antidote bundle < $HOME/.zsh_plugins.txt > $HOME/.zsh_plugins.zsh"

log_success "Shell tools" "installing tpm + nvm (shells_update.sh)"
export PATH=$PATH:$HOME/.local/bin
bash $REPO/local/.local/bin/shells_update.sh

# Neovim uses the built-in vim.pack manager: plugins listed in init.lua are
# fetched on the first (headless) startup, then we quit.
log_success "Nvim" "installing plugins via vim.pack"
nvim --headless "+qa"

bootstrap_aur
install_optional_aur
install_pkg_groups
enable_user_services
setup_greetd
enable_system_services

log_success "Completed" "Reboot to land in greetd -> Hyprland. Remember to grab your SSH key."
