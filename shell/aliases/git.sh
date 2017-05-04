###############################################################################
# ALIASES
###############################################################################
# git aliases
alias ga='git add'
alias gs='git status'
alias gsh='git show'
alias gb='git branch'
alias gpull='git pull'
alias glg="git log --graph --pretty=format:'%C(magenta)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gl='glg $(git show-ref | cut -d " " -f 2 | grep -v stash$)'
alias gd='git diff'
alias gdc='git diff --cached'
alias gco='git checkout'

alias ggpull='git pull --rebase origin $(git_current_branch)'
alias ggpush='git push origin $(git_current_branch)'

###############################################################################
# HELPERS.
###############################################################################

function git_current_branch() {
  local BRANCH="$(git symbolic-ref -q HEAD)"
  local BRANCH="${BRANCH##refs/heads/}"
  local BRANCH="${BRANCH:-HEAD}"
  echo "$BRANCH"
}

parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo " ±"
}
