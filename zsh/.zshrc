# ZSH and Oh-my-zsh config

# Path to your oh-my-zsh installation.
export ZSH="/home/manuel/.oh-my-zsh"
export EDITOR=vim
export VISUAL=vim

# COMPLETION_WAITING_DOTS="true"

# DISABLE_UNTRACKED_FILES_DIRTY="true"

ZSH_THEME='powerlevel10k/powerlevel10k'

[[ "$TERM" == "linux" ]] || [[ ! -z "$NOTMUX"  ]] && ZSH_TMUX_AUTOSTART="false" || ZSH_TMUX_AUTOSTART="true"
ZSH_TMUX_AUTOCONNECT="false"
ZSH_TMUX_FIXTERM="true"
ZSH_TMUX_FIXTERM_WITHOUT_256COLOR="tmux"
ZSH_TMUX_FIXTERM_WITH_256COLOR="tmux-256color"

plugins=(
  git ssh-agent vi-mode tmux kubectl docker z
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Aliases
alias open="xdg-open"
alias ssh="TERM=xterm-256color ssh"
alias btctl="bluetoothctl"
alias packs="pacman -Q | wc -l"

alias nvm="load-nvm && nvm"
alias npm="load-nvm ; npm"
alias node="load-nvm ; node"

alias vimc="nvim ~/.config/nvim/init.vim"
alias vimd="env FORCE_DARK='true' nvim"
alias vimg="env GRUVBOX='true' nvim"
alias vimq="env FORCE_DARK='true' nvim-qt"

# Config variables
export DEFAULT_USER="manuel"
export VIRTUAL_ENV_DISABLE_PROMPT="Y"

# Functions
function CD(){
	cd $@
}

function load-nvm() {
	# if nvm command is present nvm is ready no need to load
	if [[ $(command -v nvm) == "nvm" ]]; then
		#echo "nvm is ready"
	else
		# unalias nvm if alias exists
		[ `alias | grep nvm | wc -l` != 0 ] && unalias nvm

		echo "loading nvm..."
		export NVM_DIR="$HOME/.nvm"
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
		[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
	fi
}

function autoload-nvm(){
        if [[ -f ./package.json ]]; then
                load-nvm
        fi
}

function diffancy(){
 git diff $@ --color | diff-so-fancy | less
}

function gi() { curl -sLw n https://www.gitignore.io/api/$@ ;}

# Init 
[ ! -f /tmp/firstrun ] && clear && neofetch && touch /tmp/firstrun

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ $TERM == xterm-termite ]]; then
  . /etc/profile.d/vte.sh 
  __vte_osc7
fi

if [[ $TERM == rxvt ]];
then
	export TERM=rxvt-unicode
fi

add-zsh-hook chpwd autoload-nvm
autoload-nvm

autoload -Uz compinit
compinit

eval "$(direnv hook zsh)"

source /home/manuel/.config/broot/launcher/bash/br

# For powerlevel10k, to customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
prompt_context(){}
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
