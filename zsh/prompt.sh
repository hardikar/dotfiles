# Set up a colored prompt
autoload -U colors && colors
PROMPT="%m %{$fg[green]%}[%2d]%{$reset_color%} %(?..%{$fg[red]%})$ %{$reset_color%}"


