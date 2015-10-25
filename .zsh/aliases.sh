# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
else # OS X `ls`
    colorflag="-G"
fi

################################################################################
# Filesystem aliases
################################################################################
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

################################################################################
# Tmux aliases
################################################################################
# Enable 256-color more by default
alias tm="tmux -2"
alias tma="tmux -2 --attach"
alias tmux="tmux -2"


################################################################################
# Other aliases
################################################################################

# Process control aliases
alias jobs='jobs -l'

alias ldate="date +%Y-%m-%d-%H-%M"

