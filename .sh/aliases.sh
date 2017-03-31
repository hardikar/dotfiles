#! /usr/bin/env bash
host_os=$(uname -s)

################################################################################
# Filesystem aliases
################################################################################
alias ..='cd ..'
alias ...='cd ../..'
alias ....="cd ../../.."
alias .....="cd ../../../.."

case $host_os in
    Darwin|FreeBSD)
        colorflag="-G"
        ;;
    Linux)
        colorflag="--color"
        ;;
esac

alias ls="ls ${colorflag}"
alias l="ls -lah ${colorflag}"
alias la="ls -AF ${colorflag}"
alias ll="ls -lFh ${colorflag}"
alias lld="ls -l | grep ^d"
alias rmf="rm -rf"

alias grep='grep --color=auto'

################################################################################
# Git aliases
################################################################################
alias gc="git commit"
alias gcm="git commit -m"
alias gcam="git commit -am"

alias ga="git add"
alias grm="git rm"
alias gd="git diff"
alias gdc="git diff --cached"

alias gco="git checkout"
alias gs="git status"
alias gr="git reset"
alias grh="git reset --hard"

alias gsu="git submodule update"
alias gl="git log"
alias glog="git log --graph --decorate"

alias gpl="git pull --ff-only"
alias gpu="git push"

################################################################################
# Tmux aliases
################################################################################
# Enable 256-color more by default
alias tma="tmux -2 --attach"
alias tmux="tmux -2"


################################################################################
# Other aliases
################################################################################

# Process control aliases
alias jobs='jobs -l'

alias ldate="date +%Y-%m-%d-%H-%M"

# Because I always forget this :(
alias cl="clear"
alias cls="clear"

