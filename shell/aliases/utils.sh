parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ →\ \1/'
}

git_changes(){
  if [[ $(git status 2> /dev/null | tail -n1) == "no changes added to commit (use \"git add\" and/or \"git commit -a\")" ]]; then
    echo "[!]"
  fi
}
