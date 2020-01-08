if [[ $USER == *"@flywire.com"* ]] && [ "$(uname)" = "Darwin" ]; then
  ########### TMUX ALIASES #############
  alias flywire='tmux new -s flywire||tmux a -t flywire'
  alias vpn='tmux new -s vpn||tmux a -t vpn'
  ######################################
fi
