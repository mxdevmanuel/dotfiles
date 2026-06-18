#!/usr/bin/env zsh
#
# Post-install user setup for the SERVER profile. Run as the primary user
# after the first reboot:
#   ~/.dotfiles/installation/archserveruser.zsh
#
# Trimmed counterpart to archuser.zsh: stows the shell config only — zsh + tmux
# (no desktop, greetd, AUR, fonts, or neovim config; nvim stays plugin-free as a
# basic editor). Idempotent: safe to re-run.

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

# ── dotfiles (shell only — zsh + tmux) ──────────────────────────────────────
# zsh is self-contained (autoloaded fns + git aliases live in the zsh package),
# so local (desktop cruft) and neovim (plugins) are intentionally skipped.
function disperse_dotfiles(){
	pushd $REPO
	mkdir -p ~/.config ~/.local/share
	log_success "Stow" "dispersing zsh, tmux"
	stow -R zsh tmux
	popd
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

log_success "Dotfiles" "dotfiles are about to be dispersed"
disperse_dotfiles

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

log_success "Completed" "Server user environment ready."
