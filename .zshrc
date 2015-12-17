# Lines configured by zsh-newuser-install

HISTFILE=~/.history
HISTSIZE=16000
SAVEHIST=16000
setopt APPEND_HISTORY         # Append history file
setopt INC_APPEND_HISTORY     # Append as you type, instead of end of session 
setopt HIST_VERIFY
setopt EXTENDED_HISTORY       # Save date & exec time
setopt SHARE_HISTORY          # Share history with all open shells
setopt HIST_IGNORE_DUPS       # Ignore duplicate commands if one after the other
setopt HIST_EXPIRE_DUPS_FIRST
setopt COMPLETE_ALIASES 

setopt AUTO_PUSHD
setopt NO_BEEP
setopt AUTO_CD  # foo is cd foo if foo is a directory
unsetopt flowcontrol # ^S doesn't block input

setopt AUTO_MENU

autoload -U select-word-style
select-word-style bash


# The following lines were added by compinstall
zstyle :compinstall filename '/Users/hardikar/.zshrc'

setopt COMPLETE_IN_WORD

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Enable vi-mode
function zle-line-init zle-keymap-select {
    export _VI_MODE=$KEYMAP
    zle reset-prompt
}
zle -N zle-keymap-select
zle -N zle-line-init

export KEYTIMEOUT=1
bindkey -v


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

# Load up shell theme
# Credits to https://github.com/chriskempson/base16
source ~/.zsh/themes/base16-chalk.dark.sh

# Load up common aliases
source ~/.zsh/aliases.sh

# Load up useful functions
source ~/.zsh/functions.sh

# Load up prompt settings
source ~/.zsh/prompt.sh

export EDITOR='vim'

# Useful key bindings
# Vim-like CTRL movement keys
# bindkey '^J' down-line-or-history
# bindkey '^K' up-line-or-history
# bindkey '^H' backward-char
# bindkey '^L' forward-char

bindkey '^U' undo

# useful emacs bindings in vi-mode
bindkey -M vicmd -M viins '^R' history-incremental-search-backward
bindkey -M vicmd -M viins '^S' history-incremental-search-forward
bindkey -M vicmd -M viins '^A' beginning-of-line
bindkey -M vicmd -M viins '^E' end-of-line
bindkey -M vicmd -M viins '^W' backward-kill-word

bindkey -M vicmd 'H' beginning-of-line
bindkey -M vicmd 'L' end-of-line

# Sane backspace in insert-mode
bindkey -M viins "^?" backward-delete-char
# This used to delete the last couple of lines since the timeout on <esc> is low
bindkey -M vicmd -M viins "^[i" vi-cmd-mode

# ctrl + f/b/w move at word level
# bindkey '^f' forward-word
# bindkey '^W' backward-word
# bindkey '^B' backward-word

# # Alt + f/w/b delete at word level
# bindkey '^[f' kill-word
# bindkey '^[w' backward-kill-word
# bindkey '^[b' backward-kill-word

# ZSH highlighting plugin
# git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
if [[ $ZSH_VERSION > 4.3 ]]; then
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Load local overrides
if [[ -a ~/.local/.zshrc ]]; then
    source ~/.local/.zshrc
fi
