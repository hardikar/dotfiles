# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# Bash completion
source /usr/local/etc/profile.d/bash_completion.sh


INCLUDES=(
    $HOME/.sh/aliases.sh
    $HOME/.sh/functions.sh
)

for file in ${INCLUDES[@]}; do
    if [[ -f ${file} ]]; then
        source ${file}
    fi
done

# BASH prompt settings
function __prompt_command() {
local EXIT="$?"

local RCol='\[\e[0m\]'
local Red='\[\e[0;31m\]'
local Gre='\[\e[0;32m\]'
local BYel='\[\e[1;33m\]'
local Blu='\[\e[1;34m\]'

PROMPT="
[$Gre\w$RCol] [$Blu\t$RCol] \H "

if [ $EXIT != 0 ]; then
    PROMPT+="$Red($EXIT)$RCol"
else
    PROMPT+="($EXIT)"
fi

PROMPT+="
$ "
export PS1=$PROMPT
}

# Prompt for BASH
PROMPT_COMMAND=__prompt_command

# CDPATH magic
export CDPATH=.:$HOME/projects:$HOME/workplace:$HOME/workspace:$HOME/hacks

