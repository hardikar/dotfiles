# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# color scheme
#source $HOME/.zsh/themes/base16-solarized.dark.sh


INCLUDES=(
    $HOME/.sh/aliases.sh
    $HOME/.sh/functions.sh
    $HOME/.sh/git-prompt.sh
    $HOME/.sh/git-completion.bash
)

for file in ${INCLUDES[@]}; do
    if [[ -f ${file} ]]; then
        source ${file}
    fi
done

# BASH prompt settings
function __prompt_command() {
local RCol='\[\e[0m\]'
local Red='\[\e[0;31m\]'
local Gre='\[\e[0;32m\]'
local BYel='\[\e[1;33m\]'
local Blu='\[\e[1;34m\]'

PROMPT="
[$Gre\w$RCol"

PROMPT+="$BYel$(__git_ps1 ':(%s)')$RCol"
PROMPT+="]"

PROMPT+=" [$Blu\t$RCol] \H "
PROMPT+="
\\$ "
export PS1=$PROMPT
export GIT_PS1_SHOWDIRTYSTATE=1
}

# Prompt for BASH
PROMPT_COMMAND=__prompt_command

# Path magic
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/texbin

# check for custom bin directory and add to path
if [[ -d ~/bin ]]; then
    export PATH=~/bin:$PATH
fi
if [[ -d ~/scripts ]]; then
    export PATH=~/scripts:$PATH
fi

# export other environment variables
export PAGER='less'
export MANPAGER='less'
export EDITOR='vim'

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Load local overrides
if [[ -f ~/.local/.bashrc ]]; then
    source ~/.local/.bashrc
fi
