if [[ $USER == *"@flywire.com"* ]] && [ "$(uname)" = "Darwin" ]; then
  ########### TMUX ALIASES #############
  alias vpn='tmux new -s vpn||tmux a -t vpn'
  ######################################
fi
