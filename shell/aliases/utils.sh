parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ →\ \1/'
}

git_changes(){
  if [[ $(git status 2> /dev/null | tail -n1) == "no changes added to commit (use \"git add\" and/or \"git commit -a\")" ]]; then
    echo "[!]"
  fi
}

psmongod(){
  if [[ $(ps aux |grep "[m]ongod" |grep -o "[m]ongod ") == "mongod " ]]; then
    echo "[ mongo ]"
  fi
}

psredis(){
  if [[ $(ps aux |grep "[rR]edis" |grep -o "[rR]edis-server ") == "redis-server " ]]; then
    echo "[ redis ]"
  fi
}

pspg(){
 if [[ $(ps aux |grep "[pP]ostgres -D" |grep -o "[pP]ostgres ") == "postgres " ]]; then
   echo "[ postgres ]"
 fi
}