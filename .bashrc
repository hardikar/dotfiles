# source the zshrc aliases to get zsh-like environment
source $HOME/.zsh/aliases.sh

# Prompt for BASH
export PROMPT_COMMAND=__prompt_command

function __prompt_command() {
local EXIT="$?"
local PWD="$(pwd)"

local RCol='\[\e[0m\]'
local Red='\[\e[0;31m\]'
local Gre='\[\e[0;32m\]'
local BYel='\[\e[1;33m\]'
local Blu='\[\e[1;34m\]'

PROMPT="
[$Gre$PWD$RCol] [$Blu\t$RCol] \H "

if [ $EXIT != 0 ]; then
    PROMPT+="$Red($EXIT)$RCol"
else
    PROMPT+="($EXIT)"
fi

PROMPT+="
$ "
export PS1=$PROMPT
}

