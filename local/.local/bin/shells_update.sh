#!/usr/bin/env bash

# NVM
function _update_nvm(){
        local releasedata=$(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/nvm-sh/nvm/releases/latest)
        local releasename=$(echo -n $releasedata | jq ".name" )

         if [[ -d $HOME/.nvm ]]
         then
                [ `alias | grep nvm | wc -l` != 0 ] && unalias nvm

                [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
                
                nvm_version=$(nvm --version)
                nvm_latest=$(echo $releasename | sed 's/[^0-9.]*//g')

                if [[ "$nvm_version" == "$nvm_latest" ]]
                then
                        echo "NVM is up to date"
                        return 0
                fi
         fi

         curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${releasename}/install.sh" | bash
}

_update_nvm

# Direnv
function _update_direnv(){
        local releasedata=$(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/direnv/direnv/releases/latest)
        local releasename=$(echo -n $releasedata | jq ".name" )

	local direnvbin=$HOME/.local/bin/direnv
         if [[ -x $direnvbin ]]
         then
                direnv_version=$($direnvbin --version)
                direnv_latest=$(echo $releasename | sed 's/[^0-9.]*//g')

                if [[ "$direnv_version" == "$direnv_latest" ]]
                then
                        echo "Direnv is up to date"
                        return 0
                fi
         fi

	curl -sfL https://direnv.net/install.sh | bash
}

_update_direnv

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
syntax=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
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
fzf=$HOME/.fzf
if [[ ! -d $fzf ]]
then
	git clone --depth 1 https://github.com/junegunn/fzf.git $fzf
else
	pushd $tpm
	git pull
	$fzf/install --no-bash --no-zsh --key-bindings --completion
fi

