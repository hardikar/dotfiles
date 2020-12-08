#! /usr/bin/env bash
host_os=$(uname -s)

################################################################################
# Filesystem aliases
################################################################################
case $host_os in
    Darwin|FreeBSD)
        colorflag="-G"
        ;;
    Linux)
        colorflag="--color"
        ;;
esac

alias ls="ls -F ${colorflag}"
alias la="ls -AF ${colorflag}"
alias ll="ls -lhF ${colorflag}"
alias lla="ls -AlhF ${colorflag}"
alias cd="pushd"

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
alias gsh="git show"
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

alias ldate="date +%Y-%m-%d_%H-%M"

# Because I always forget this :(
alias cl="clear"
alias cls="clear"

