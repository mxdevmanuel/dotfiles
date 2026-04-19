#!/usr/bin/env zsh
BASE=${0:h}

source ${BASE}/utils.zsh

function git_config(){
	vared -p "Git's user 'real' name" -c guser
	git config --global user.name $guser

	vared -p "Git's user email" -c gemail
	git config --global user.email $gemail

	git config --global diff.tool nvimdiff
	git config --global merge.tool nvimdiff

	git config --global alias.root 'rev-parse --show-toplevel'
}

function select_stow(){
	pushd $(git rev-parse --show-toplevel)
	log_success "Dispersing dotfiles" \
		"Will disperse basic dotfiles (local,kitty,neovim,tmux,zsh) you can disperse other ones later with 'stow target'"
	vared -p "Disperse desktop: sway, i3, or hyprland (default=sway)?: " -c cdesktop

	if [[ -z "$cdesktop" ]]
	then
		cdesktop=sway
	fi

	mkdir -p ~/.config/systemd ~/.gnupg ~/.local/bin ~/.local/share

	# Hyprland uses foot (config lives in hyprland/); other desktops use kitty.
	local term_pkg=kitty
	if [[ "$cdesktop" == "hyprland" ]]
	then
		term_pkg=
	fi

	stow local neovim tmux zsh $term_pkg $cdesktop
	popd
}

installation_dir=$HOME/.dotfiles/installation
if [[ "$(pwd)" != "$installation_dir" ]]
then
	pushd $installation_dir
fi

vared -p "Wish to configure git now: (Y/n)" -c cgitconfig

if [[ "${cgitconfig}" != "n" ]]
then
	git_config
fi

log_success "Downloading fonts" "Initializing submodules (SF Mono, SF Display)"
git submodule update --init

log_success "Dotfiles" "dotfiles are about to be dispersed"
select_stow

log_success "Antidote" "Cloning antidote zsh plugin manager"
ANTIDOTE_HOME=$HOME/.antidote
if [[ ! -d $ANTIDOTE_HOME ]]
then
	git clone --depth=1 https://github.com/mattmc3/antidote.git $ANTIDOTE_HOME
fi

log_success "Antidote" "Pre-bundling plugins from ~/.zsh_plugins.txt"
zsh -c "source $ANTIDOTE_HOME/antidote.zsh && antidote bundle < $HOME/.zsh_plugins.txt > $HOME/.zsh_plugins.zsh"

log_success "Installing shell tools" "tmux plugins, etc."
export PATH=$PATH:$HOME/.local/bin
gitbase=$(git rev-parse --show-toplevel)
localbin=${gitbase}/local/.local/bin

bash ${localbin}/shells_update.sh

log_success "Nvim" "Installing nvim plugins"
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

log_success "Python" "Creating Envs"
mkdir -p $HOME/Envs
pushd $HOME/Envs
python -m venv tests
source tests/bin/activate
pip install lolcat
popd

log_success "Completed" "Now just exit and reboot. Remember to get a copy of your SSH key. Everything should be setup"
