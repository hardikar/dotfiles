export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1024000
export SAVEHIST=$HISTSIZE

INCLUDES=(
	$HOME/.sh/aliases.sh
	$HOME/.sh/functions.sh
	$HOME/.sh/exports.sh
	$HOME/.sh/git-prompt.sh
	$HOME/.sh/hg-prompt.sh
)

for file in ${INCLUDES}; do
    if [[ -f ${file} ]]; then
        source ${file}
    fi
done

setopt APPEND_HISTORY         # Append history file
setopt INC_APPEND_HISTORY     # Append as you type, instead of end of session 
setopt HIST_VERIFY
setopt SHARE_HISTORY          # Share history with all open shells
setopt HIST_IGNORE_ALL_DUPS   # Ignore duplicate commands
setopt HIST_EXPIRE_DUPS_FIRST

setopt AUTO_PUSHD
unsetopt FLOWCONTROL          # ^S doesn't block input

setopt COMPLETE_ALIASES

# set up a colored prompt
autoload -U colors && colors

# stop backward-kill-word on a directory separator
autoload -U select-word-style
select-word-style bash

# enable completion
autoload -Uz compinit
zstyle ':completion:*' menu select
# use up default colors
zstyle ':completion:*' list-colors ''
compinit

# edit the command in a full-out editor
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# setting editor to vim, set's the line-editor mode to vim also
# so, reset it back to emacs till I get a hang of it
bindkey -e

setopt PROMPT_SUBST           # Enable prompt evaluation
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1

ZSH_PROMPT_DATE='%{$fg[blue]%}%D{%H:%M:%S}%{$reset_color%}'
ZSH_PROMPT_HOST='%{$fg[green]%}%d%{$reset_color%}'
ZSH_PROMPT_GIT='%{$fg[yellow]%}$(__git_ps1 ":(%s)")%{$reset_color%}'
ZSH_PROMPT_HG='%{$fg[yellow]%}$(__hg_ps1 ":(%s)")%{$reset_color%}'

PROMPT="
[${ZSH_PROMPT_HOST}${ZSH_PROMPT_GIT}${ZSH_PROMPT_HG}] [${ZSH_PROMPT_DATE}] %M
%(!.#.$) "

# Syntax highlighting
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Load local overrides
if [[ -f ~/.local/.zshrc ]]; then
	source ~/.local/.zshrc
fi

# ZSH highlighting plugin (must be last)
# git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
if [[ $ZSH_VERSION > 4.3 ]]; then
	source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

