# Lines configured by zsh-newuser-install

HISTFILE=~/.histfile
HISTSIZE=16000
SAVEHIST=16000
setopt HIST_VERIFY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY 
setopt APPEND_HISTORY
setopt COMPLETE_ALIASES

setopt AUTO_PUSHD
unsetopt beep

bindkey -e
# End of lines configured by zsh-newuser-install
#
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/hardikar/.zshrc'

setopt COMPLETE_IN_WORD

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Set up a colored prompt
autoload -U colors && colors
PROMPT="%m %{$fg[green]%}[%2d]%{$reset_color%} %(?..%{$fg[red]%})$ %{$reset_color%}"

export PATH=
path=(
    /usr/local/bin/
    /usr/bin
    /bin
    /usr/sbin
    /sbin
    /usr/texbin
    ) 

# check for custom bin directory and add to path
if [[ -d ~/bin ]]; then
    export PATH=~/bin:$PATH
    fi

# Load up shell theme
# Credits to https://github.com/chriskempson/base16
source ~/.zsh/themes/base16-chalk.dark.sh

# Load up common aliases
source ~/.zsh/aliases.sh

# Load up useful functions
source ~/.zsh/functions.sh

export EDITOR='vim'

# Useful key bindings for history
bindkey '^J' down-line-or-history
bindkey '^K' up-line-or-history

# Load local overrides
if [[ -a ~/.localrc ]]; then
    source ~/.localrc
fi
