#
# Git utility functions for shell prompt
#

ON_BRANCH_REGEX='On branch (.*)'
DETACHED_REGEX='HEAD detached at (.*)'
DIRTY_REGEX='Changed but not updated|Changes not staged for commit'

function git_branch() {
  local line="$(git status | head -1)"
  if [[ $line =~ ${ON_BRANCH_REGEX} ]]; then
    echo -n "${BASH_REMATCH[1]}"
  elif [[ $line =~ ${DETACHED_REGEX} ]]; then
    echo -n "${BASH_REMATCH[1]}"
  else
    echo -n "Broken"
  fi
}

function git_is_dirty() {
  local line="$(git status)"
  if [[ $line =~ $DIRTY_REGEX ]]; then
    echo "dirty"
  fi
}

function git_is_clean() {
  if [[ -z "$(git_is_dirty)" ]]; then
    echo -n "clean"
  fi
}


