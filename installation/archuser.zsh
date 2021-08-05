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
	log_success "Selecting stow targets" \
		"Use ${BOLD}Tab${ND} to select multiple. Select only i3 or sway not both, depending on the package collection selected in root step"
	local stows=$( ls --only-dirs | grep -Ev "archive|installation|system|local|zsh" | fzf --reverse -m )

	stow local zsh $(echo $stows | paste -s)
	popd
}

installation_dir=$HOME/.dotfiles/installation
if [[ "$(pwd)" != "$installation_dir" ]]
then
	pushd $installation_dir
fi

log_success "ZSH" "Installing Oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

vared -p "Wish to configure git now: (Y/n)" -c cgitconfig

if [[ "${cgitconfig}" != "n" ]]
then
	git_config
fi

log_success "Downloading fonts" \
	"Installing SF Mono"
git submodule update --init

log_success "Dotfiles" "Select dotfiles to be dispersed"
select_stow

log_success "Installing shell tools" "Installing..."
gitbase=$(git rev-parse --show-toplevel)
localbin=${gitbase}/local/.local/bin

bash ${localbin}/update_nvm.sh
zsh ${localbin}/shells_update.zsh

log_success "Nvim" "Installing nvim plugins"
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

log_success "Python" "Creating Envs"
mkdir $HOME/Envs
pushd $HOME/Envs
python -m venv tests
source tests/bin/activate
pip install lolcat

log_success "Completed" "Now just exit two times and reboot. Remember to get a copy of your SSH key. Everything should be setup"
