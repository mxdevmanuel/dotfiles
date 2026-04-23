# P10k instant prompt — must be near the top, before any output
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -n "$SSH_CONNECTION" && -z "$TMUX" ]]; then
	tmux attach || tmux new-session
	exit
fi

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
	export PATH="$HOME/.local/bin:$PATH"
fi

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

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
# zsh-nvm lazy loading (NVM_LAZY_LOAD works for lukechilds/zsh-nvm)
export NVM_LAZY_LOAD=true
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

source ${ZDOTDIR:-$HOME}/.local/share/zsh/aliases/git

if command -v kubectl &>/dev/null; then
	export KUBECONFIG=~/.kube/config
	# Cache kubectl completions — regenerate only when kubectl binary changes
	_kubectl_completion=~/.cache/kubectl_completion.zsh
	if [[ ! -f $_kubectl_completion || /usr/bin/kubectl -nt $_kubectl_completion ]]; then
		kubectl completion zsh >| $_kubectl_completion
	fi
	source $_kubectl_completion
	compdef _kubectl k
fi

alias diffancy='git diff | diff-so-fancy'

# Google Cloud SDK — PATH only at startup, completions loaded on first gcloud call
if [ -f '/home/manuel/.google-cloud-sdk/path.zsh.inc' ]; then
	source '/home/manuel/.google-cloud-sdk/path.zsh.inc'
fi
if [ -f '/home/manuel/.google-cloud-sdk/completion.zsh.inc' ]; then
	gcloud() {
		unfunction gcloud
		source '/home/manuel/.google-cloud-sdk/completion.zsh.inc'
		gcloud "$@"
	}
fi
