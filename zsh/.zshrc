if [[ -n "$SSH_CONNECTION" && -z "$TMUX" ]]; then
	tmux attach || tmux new-session
	exit
fi

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

setopt appendhistory
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

bindkey -v

# Antidote: bootstrap on first run, then load plugins from ~/.zsh_plugins.txt
ANTIDOTE_HOME=${ZDOTDIR:-$HOME}/.antidote
if [[ ! -d $ANTIDOTE_HOME ]]; then
	git clone --depth=1 https://github.com/mattmc3/antidote.git $ANTIDOTE_HOME
fi
zstyle ':antidote:bundle' use-friendly-names 'yes'
# zsh-nvm prefers lazy loading
zstyle ':omz:plugins:nvm' lazy yes
source $ANTIDOTE_HOME/antidote.zsh
antidote load

source <(fzf --zsh)

command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

zstyle ':completion:*' menu select

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias ls="eza"

alias k=kubectl
alias kseal="kubeseal --controller-name sealed-secrets --controller-namespace kube-system --format yaml"

autoload -Uz compinit

if [[ ! -z $FIRSTRUN ]] && [[ ! -f /tmp/firstrun ]] then
	neofetch
	compinit
	touch /tmp/firstrun
else
	compinit -C
fi

if command -v kubectl &>/dev/null;
then
	export KUBECONFIG=~/.kube/config
	source <(kubectl completion zsh)
	compdef _kubectl k
fi


alias gst='git status'
alias diffancy='git diff | diff-so-fancy'
