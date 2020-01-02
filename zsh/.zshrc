# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/manuel/.oh-my-zsh"
export EDITOR=vim
export VISUAL=vim

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="agnoster"
ZSH_THEME='powerlevel10k/powerlevel10k'
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# TMUX plugin settings
ZSH_TMUX_AUTOSTART="true"
ZSH_TMUX_AUTOCONNECT="false"
ZSH_TMUX_FIXTERM="false"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git ssh-agent tmux vi-mode k docker z
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
alias open="xdg-open"
alias ssh="TERM=xterm-256color ssh"

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ $TERM == xterm-termite ]]; then
  . /etc/profile.d/vte.sh 
  __vte_osc7
fi

[ ! -f /tmp/firstrun ] && clear && neofetch && touch /tmp/firstrun

if [[ $TERM == rxvt ]];
then
	export TERM=rxvt-unicode
fi

if [[ ! -z "${TMUX}" ]]
then
	export TERM=tmux-256color
fi

CD(){
	cd $@
}

vimf(){
        if [ -z "$1" ]
        then
                FILE=$(rg --files | fzf)
        else
                FILE=$(rg --files --hidden | fzf)
        fi

        if [ ! -z "$FILE" ]
        then
                vim "$FILE"
        fi
}

alias vimh="vimf ."

load-nvm() {
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

alias nvm="load-nvm && nvm"
alias npm="load-nvm ; npm"
alias node="load-nvm ; node"

diffancy(){
 git diff $@ --color | diff-so-fancy | less
}

# Some tmux-related shell aliases

# Attaches tmux to the last session; creates a new session if none exists.
alias t='tmux attach || tmux new-session'

alias packs="pacman -Q | wc -l"

export DEFAULT_USER="manuel"
export VIRTUAL_ENV_DISABLE_PROMPT="Y"
prompt_context(){}

autoload -Uz compinit
compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
