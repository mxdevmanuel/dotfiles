HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

bindkey -v

source <(fzf --zsh)

source ~/.powerlevel10k/powerlevel10k.zsh-theme

zstyle ':completion:*' menu select

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source ~/.zcd/zsh-z.plugin.zsh

autoload -Uz compinit _nvm compdef

alias nvm="_nvm"

alias ls="eza"

if [[ ! -z $FIRSTRUN ]] && [[ ! -f /tmp/firstrun ]] then
	neofetch
	compinit
	touch /tmp/firstrun
else
	compinit -C
fi
