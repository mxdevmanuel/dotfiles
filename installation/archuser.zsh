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
	vared -p "Disperse sway or i3 files (default=sway)?: " -c cdesktop

	if [[ -z "$cdesktop" ]]
	then
		cdesktop=sway
	fi

	stow local kitty neovim tmux zsh $cdesktop
	popd
}

installation_dir=$HOME/.dotfiles/installation
if [[ "$(pwd)" != "$installation_dir" ]]
then
	pushd $installation_dir
fi

log_success "Installing Oh-my-zsh" "This will launch a new zsh shell just  CTRL-D to continue"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

[[ -f $HOME/.zshrc ]] && rm $HOME/.zshrc

vared -p "Wish to configure git now: (Y/n)" -c cgitconfig

if [[ "${cgitconfig}" != "n" ]]
then
	git_config
fi

log_success "Downloading fonts" \
	"Installing SF Mono"
git submodule update --init

if [[ ! -d $HOME/.local/bin ]]
then
	mkdir -p $HOME/.local/bin
fi
log_success "Dotfiles" "dotfiles are about to be dispersed"
select_stow

log_success "Installing shell tools" "Installing..."
export PATH=$PATH:$HOME/.local/bin
gitbase=$(git rev-parse --show-toplevel)
localbin=${gitbase}/local/.local/bin

bash ${localbin}/update_nvm.sh
zsh ${localbin}/shells_update.zsh

log_success "Nvim" "Installing nvim plugins"
p=$(mktemp)
echo "Run :PackerInstall to install plugins" >> $p
echo "the :q to exit"
nvim $p

log_success "Python" "Creating Envs"
mkdir $HOME/Envs
pushd $HOME/Envs
python -m venv tests
source tests/bin/activate
pip install lolcat

log_success "Completed" "Now just exit two times and reboot. Remember to get a copy of your SSH key. Everything should be setup"
