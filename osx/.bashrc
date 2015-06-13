# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

#Set the prompt
# login folder $
PS1='\u \[\033[01;32m\]\W \[\033[00m\] \$ '

export CLICOLOR=1
#export LSCOLORS=GxFxCxDxBxegedabagaced
export LSCOLORS=ExFxCxDxBxegedabagacad

alias ls='ls -G'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias "cd.."="cd .."

#git aliases
alias gcam="git commit -am"
alias gm="git commit -m"
alias gsu="git submodule update"
alias gs="git status"
alias gl="git log"
alias gc="git checkout"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

#Bash completetion
source /usr/local/etc/profile.d/bash_completion.sh

#backup util
# -a(archive)z(compress)h(human)v(verbose) 
alias back="rsync -ahv"
