# Load Git completion
zstyle ':completion:*:*:git:*' script ~/dotfiles/.config/zsh-plugins/completion/git-completion.bash
fpath=(~/dotfiles/.config/zsh-plugins/completion $fpath)

autoload -Uz compinit && compinit

