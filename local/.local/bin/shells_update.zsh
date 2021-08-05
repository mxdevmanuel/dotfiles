#!/usr/bin/env zsh

# Theme
powerlevel10k=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
if [[ ! -d $powerlevel10k ]]
then
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $powerlevel10k
else
	pushd $powerlevel10k
	git pull
fi

# zsh syntax highlight
syntax=$ZSH_CUSTOM/plugins/zsh-syntax-highlighting
if [[ ! -d $syntax ]]
then
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $syntax
else
	pushd $syntax
	git pull
fi
# Tmux plugin manager
tpm=$HOME/.tmux/plugins/tpm
if [[ ! -d $tpm ]]
then
	git clone https://github.com/tmux-plugins/tpm $tpm
else
	pushd $tpm
	git pull
fi

# fzf
fzf=~/.fzf
if [[ ! -d $fzf ]]
then
	git clone --depth 1 https://github.com/junegunn/fzf.git $fzf
else
	pushd $tpm
	git pull
	$fzf/install --no-bash --no-zsh --key-bindings --completion
fi

# direnv
curl -sfL https://direnv.net/install.sh | bash
