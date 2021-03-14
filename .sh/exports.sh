# export other environment variables
export PAGER='less'
export MANPAGER='less'
export EDITOR='vim'

# PATH="/usr/texbin"
# PATH="/sbin:$PATH"
# PATH="/usr/sbin:$PATH"
# PATH="/bin:$PATH"
# PATH="/usr/bin:$PATH"
# PATH="/usr/local/bin:$PATH"

export PATH

# check for custom bin directory and add to path
if [[ -d $HOME/bin ]]; then
	export PATH=~/bin:$PATH
fi
