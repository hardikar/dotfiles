#
# git.zsh copied from the oh-my-zsh and heavily modified
#
if [[ $(echo "echo" | grep -P "echo" 2>&1 >/dev/null && echo $?) == 0 ]] ; then
    alias egrep='grep -P'
fi

# get the name of the branch we are on
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null)
  if [[ -z $ref ]]; then
    git_prompt_short_sha
  else
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(parse_git_upstream)${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

parse_git_dirty () {
  gitstat=$(git status 2>/dev/null | grep '\(Untracked\|Changes\|Changed\)')

  if [[ $(echo ${gitstat} | grep -c "Changes to be committed:") > 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_STAGED"
    return
  fi

  if [[ $(echo ${gitstat} | grep -c "\(Changed but not updated:\|Changes not staged for commit:\)$") > 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_DIRTY"
    return
  fi 

  if [[ $(echo ${gitstat} | grep -v '^$' | wc -l | tr -d ' ') == 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_CLEAN"
    return
  fi
}


parse_git_upstream () {
  gitstat=$(git status 2>/dev/null)

  if [[ $(echo ${gitstat} | grep -c "have diverged") > 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_DIVERGED "
    return
  fi

  # Your branch is ahead of 'origin/master' by 1 commit.
  gitstat=$(git status 2>/dev/null | egrep 'Your branch is (?:ahead|behind|up-to-date) (?:of|to|with)? ?[^ ]+(?: by \d+? commits?)?')

  gitcommitcount=$(echo ${gitstat} | egrep -o 'by \d+ commits?' | egrep -o '\d+')

  if [[ $(echo ${gitstat} | grep -c "is ahead of") > 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_AHEAD${gitcommitcount} "
    return
  fi

  if [[ $(echo ${gitstat} | grep -c "is behind") > 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_BEHIND${gitcommitcount} "
    return
  fi 

  if [[ $(echo ${gitstat} | grep -c "is up-to-date with") > 0 ]]; then
    echo -n "$ZSH_THEME_GIT_PROMPT_EQUAL "
    return
  fi 

}

# Formats prompt string for current git commit short SHA
function git_prompt_short_sha() {
  SHA=$(git rev-parse --short HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_PREFIX$SHA$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Get the status of the working tree
git_prompt_status() {
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
  fi
  echo $STATUS
}
