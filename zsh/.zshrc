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

source <(fzf --zsh)

source ~/.powerlevel10k/powerlevel10k.zsh-theme

zstyle ':completion:*' menu select

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source ~/.zcd/zsh-z.plugin.zsh

alias ls="eza"

alias k=kubectl

autoload -Uz compinit

if [[ ! -z $FIRSTRUN ]] && [[ ! -f /tmp/firstrun ]] then
	neofetch
	compinit
	touch /tmp/firstrun
else
	compinit -C
fi

export KUBECONFIG=~/.kube/config

source <(kubectl completion zsh)

compdef _kubectl k

alias gst='git status'

source ~/.zsh-nvm/zsh-nvm-lazy-load.plugin.zsh

