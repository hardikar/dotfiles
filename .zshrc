export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1024000
export SAVEHIST=$HISTSIZE

setopt APPEND_HISTORY         # Append history file
setopt INC_APPEND_HISTORY     # Append as you type, instead of end of session 
setopt HIST_VERIFY
setopt SHARE_HISTORY          # Share history with all open shells
setopt HIST_IGNORE_ALL_DUPS   # Ignore duplicate commands
setopt HIST_EXPIRE_DUPS_FIRST

setopt AUTO_PUSHD
unsetopt FLOWCONTROL          # ^S doesn't block input

setopt COMPLETE_ALIASES
setopt AUTO_MENU
setopt MENU_COMPLETE
setopt COMPLETE_IN_WORD

# set up a colored prompt
autoload -U colors && colors

# stop backward-kill-word on a directory separator
autoload -U select-word-style
select-word-style bash

# enable completion
autoload -Uz compinit
zstyle ':completion:*' menu interactive select
# use up default colors
zstyle ':completion:*' list-colors ''
compinit

# edit the command in a full-out editor
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

INCLUDES=(
	$HOME/.sh/aliases.sh
	$HOME/.sh/functions.sh
	$HOME/.sh/git-prompt.sh
)

for file in ${INCLUDES}; do
    if [[ -f ${file} ]]; then
        source ${file}
    fi
done

export PATH=
path=(
	/usr/local/bin
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
if [[ -d ~/scripts ]]; then
	export PATH=~/scripts:$PATH
fi

# export other environment variables
export PAGER='less'
export MANPAGER='less'
export EDITOR='vim'

# setting editor to vim, set's the line-editor mode to vim also
# so, reset it back to emacs till I get a hang of it
bindkey -e

setopt PROMPT_SUBST           # Enable prompt evaluation

ZSH_PROMPT_DATE='%{$fg[blue]%}%D{%H:%M:%S}%{$reset_color%}'
ZSH_PROMPT_HOST='%{$fg[green]%}%d%{$reset_color%}'
ZSH_PROMPT_GIT='%{$fg[yellow]%}$(__git_ps1 ":(%s)")%{$reset_color%}'

PROMPT="
[${ZSH_PROMPT_HOST}${ZSH_PROMPT_GIT}] [${ZSH_PROMPT_DATE}] %M
%(!.#.$) "

# Load local overrides
if [[ -f ~/.local/.zshrc ]]; then
	source ~/.local/.zshrc
fi

# ZSH highlighting plugin (must be last)
# git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
if [[ $ZSH_VERSION > 4.3 ]]; then
	source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

