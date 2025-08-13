# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Sets it to the default path, some app like lazygit will not use an empty value
export XDG_CONFIG_HOME="$HOME/.config"

source ~/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PAGER=nvimpager
# link gmake from brew
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

function config() {
  cd "$HOME/dotfiles/.config/$1" || return
}

function vim-htag() {
  vim -u NONE -c "helptags $1" -c q
}

# Aliases
if command -v eza &>/dev/null; then
  alias ls='eza' # with -F maybe?
  alias la='eza -a'
  alias ll='eza -lhg'
  alias lla='eza -alhg'
  alias tree='eza --tree'
fi
alias mkdir='mkdir -p'
alias mkcd="mkdir \"$1\" && cd \"$1\""
alias rd='rmdir'
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias /='cd /'
alias d='dirs -v'
alias -- -='cd -'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
alias ~web='cd ~web'
alias ~api='cd ~api'
alias g='git'
# starts fzf with preview, <c-w> to open in neovim, <c-y> to copy the path to clipboard
alias sf='fzf -m --preview="bat --color=always {}" --bind "enter:become(nvim {+}),ctrl-y:execute-silent(echo {} | pbcopy)+abort"'
alias gdb='git branch --format="%(refname:short)" | fzf -m --bind "enter:execute(git branch -D {+})+abort"'
alias fsb="$HOME/dotfiles/.config/git/fsb.sh"
alias fshow="$HOME/dotfiles/.config/git/fshow.sh"
alias v='fd --hidden --type f --exclude .git | fzf --height 50% --reverse | xargs nvim'

# alias it since its not installed system-wide
alias jupynium="$HOME/github/jupyter/jupyterenv/bin/jupynium"

alias gw='./gradlew'

# open ~/.zshrc in using the default editor specified in $EDITOR
alias ec="nvim $HOME/.zshrc"
alias sc="exec zsh"

#Suffix Aliases
alias -s {yaml,yml,lua,vim,csharp,js,rb,json,c,cs,py,md,txt,kt,ex}=nvim


# Zsh History
export HISTFILESIZE=1000
export HISTSIZE=1000
export HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
# following should be turned off, if sharing history via setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
export ERL_AFLAGS="-kernel shell_history enabled"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

alias nv=nvim

# Set Ruby env path
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

# Set up Node env
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

# relocating aws config file to a different folder
#export AWS_CONFIG_FILE="$HOME/.config/aws/config"
#export AWS_SHARED_CREDENTIALS_FILE="$HOME/.config/aws/credentials"

eval "$(zoxide init --cmd cd zsh)"
source ~/.config/zsh-plugins/git-completion.zsh
source ~/.config/zsh-plugins/.fzf.zsh
source ~/.config/zsh-plugins/.take.zsh
source ~/.config/zsh-plugins/.fancy-ctrlz.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh-plugins/termfile_download.sh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
