source ~/powerlevel10k/powerlevel10k.zsh-theme
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ -f ~/.dotfiles/.config/zsh-plugins/.fzf.zsh ]] && source ~/.dotfiles/.config/zsh-plugins/.fzf.zsh
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PAGER=nvimpager

function config() {
  cd "$HOME/.dotfiles/.config/$1" || return
}

function vim-htag() {
  vim -u NONE -c "helptags $1" -c q
}

## Aliases
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -al'
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

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# open ~/.zshrc in using the default editor specified in $EDITOR
alias ec="nvim $HOME/.zshrc"
alias sc="exec zsh"

export PATH="$PATH:/Users/chuanhe/Library/Python/3.9/bin"

## Setting up android project
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-19.jdk/Contents/Home
#export ANDROID_HOME="Users/chuanhe/Library/Android/sdk"
#export Path="$PATH:/$ANDROID_HOME/platform-tools"

## Add work github directory to hash
hash -d api=~/GitHub/fieldwire_api
hash -d web=~/GitHub/fieldwire_web_app
hash -d dot=~/.dotfiles
hash -d config=~/.dotfiles/.config

##Suffix Aliases
alias -s {yaml,yml,lua,vim,csharp,js,rb,json,c,cs,py,md,txt}=nvim

#plugins=(vi-mode zsh-syntax-highlighting zsh-autosuggestions colored-man-pages colorize)

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
#
# Jira autocomplete
# https://github.com/go-jira/jira export PATH="/usr/local/bin/jira:$PATH"
#eval "$(jira --completion-script-bash)"

# relocating aws config file to a different folder
#export AWS_CONFIG_FILE="$HOME/.config/aws/config"
#export AWS_SHARED_CREDENTIALS_FILE="$HOME/.config/aws/credentials"

eval "$(zoxide init --cmd cd zsh)"
source ~/.config/op/plugins.sh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
