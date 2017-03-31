
# Extract archives - use: extract <file>
# Credits to http://dotfiles.org/~pseup/.bashrc
function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2) tar xjf $1 ;;
            *.tar.xz) tar xf $1 ;;
            *.tar.gz) tar xzf $1 ;;
            *.bz2) bunzip2 $1 ;;
            *.rar) rar x $1 ;;
            *.gz) gunzip $1 ;;
            *.tar) tar xf $1 ;;
            *.tbz2) tar xjf $1 ;;
            *.tgz) tar xzf $1 ;;
            *.zip) unzip $1 ;;
            *.Z) uncompress $1 ;;
            *.7z) 7z x $1 ;;
            *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
alias x="extract"

# Quick notes
function note(){
    if [[ $* == 'this' ]]; then
        ns
    else
        vim -c "Note $*"
    fi
}
alias notes="ls ~/notes"

function ns(){
    vim -c NotesStash
}

# Use robots.thoughtbot.com's readability engine to convert webpages to markdown
function rdd() {
    if ! [ "$1" ]; then
        echo "Usage: rdd <url>"
        return 1
    fi
    curl --data "read=1&u=$1" "http://heckyesmarkdown.com/go/"
}

function gpr() {
  case "$#" in
    1)
      remote=origin
      pr="$1"
      ;;
    2)
      remote="$1"
      pr="$2"
      ;;
  esac

  git fetch ${remote} pull/"$pr"/head:"pr-$pr"
}
