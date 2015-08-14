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
autoload -U select-word-style
select-word-style bash
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

# Useful key bindings
# Vim-like CTRL movement keys
bindkey '^J' down-line-or-history
bindkey '^K' up-line-or-history
bindkey '^H' backward-char
bindkey '^L' forward-char

# ctrl + f/b/w move at word level
# bindkey '^f' forward-word
# bindkey '^W' backward-word
# bindkey '^B' backward-word
# 
# # Alt + f/w/b delete at word level
# bindkey '^[f' kill-word
# bindkey '^[w' backward-kill-word
# bindkey '^[b' backward-kill-word

# New zsh widget to print workspace status on ctrl+space
vcs-status(){
    \print; zle push-line; # push the current command on the buffer stack
    if [ -d .git ]; then
        git status 
    else
        ls -l
    fi
    zle accept-line;
}

zle -N vcs-status
bindkey '^ ' vcs-status

# Load local overrides
if [[ -a ~/.local_zshrc ]]; then
    source ~/.local_zshrc 
fi
