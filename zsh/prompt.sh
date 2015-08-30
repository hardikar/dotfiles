# Set up a colored prompt
autoload -U colors && colors

# Set up different prompts based on context
function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '>' && return
    echo '$' && return
}

# Source git prompt plugin
source ~/.zsh/git.sh

ZSH_THEME_GIT_PROMPT_PREFIX=" (%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_AHEAD="^"
ZSH_THEME_GIT_PROMPT_BEHIND="v"
ZSH_THEME_GIT_PROMPT_EQUAL="="

# PROMPT="%m %{$fg[green]%}[%2d]%{$reset_color%} %(?..%{$fg[red]%})$ %{$reset_color%} $(git_prompt_info)"

ZSH_THEME_HOSTNAME_PREFIX=""
ZSH_THEME_HOSTNAME_SUFFIX=""
ZSH_PROMPT_HOSTNAME="$ZSH_THEME_HOSTNAME_PREFIX%M$ZSH_THEME_HOSTNAME_SUFFIX"


ZSH_THEME_PATH_PREFIX="[%{$fg[green]%}"
ZSH_THEME_PATH_SUFFIX="%{$reset_color%}]"
ZSH_PROMPT_PATH="$ZSH_THEME_PATH_PREFIX%6d$ZSH_THEME_PATH_SUFFIX"

ZSH_THEME_RETURN_PREFIX="%(?..%{$fg[red]%})"
ZSH_THEME_RETURN_SUFFIX="%{$reset_color%}"
ZSH_RETURN="$ZSH_THEME_RETURN_PREFIX(%?)$ZSH_THEME_RETURN_SUFFIX"
 
ZSH_THEME_DATE_PREFIX="[%{$fg[cyan]%}"
ZSH_THEME_DATE_SUFFIX="%{$reset_color%}]"
ZSH_PROMPT_DATE="$ZSH_THEME_DATE_PREFIX%D{%Y-%m-%d %H:%M:%S}$ZSH_THEME_DATE_SUFFIX"


# Enable prompt evaluation
setopt PROMPT_SUBST
PROMPT='
$ZSH_PROMPT_DATE $ZSH_PROMPT_HOSTNAME $ZSH_PROMPT_PATH$(git_prompt_info) $ZSH_RETURN 
$(prompt_char) '

