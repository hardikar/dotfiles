# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
else # OS X `ls`
    colorflag="-G"
fi

# Filesystem aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....="cd ../../.."
alias .....="cd ../../../.."


alias ls="ls ${colorflag}"
alias l="ls -lah ${colorflag}"
alias la="ls -AF ${colorflag}"
alias ll="ls -lFh ${colorflag}"
alias lld="ls -l | grep ^d"
alias rmf="rm -rf"

alias grep='grep --color=auto'


# Git aliases
alias gcam="git commit -am"
alias gcm="git commit -m"
alias gsu="git submodule update"
alias gs="git status"
alias gl="git log"
alias gc="git checkout"
alias glog="git log --graph --decorate --all"

# Enable 256-color more by default
alias tmux="tmux -2"

