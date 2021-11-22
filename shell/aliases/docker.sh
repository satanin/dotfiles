  ###############################################################################
  # docker environment aliases
  ###############################################################################

alias stop_containers='docker ps | awk '{if (NR!=1) {print $1}}' | xargs docker stop'
alias remove_images='docker images | grep none | awk '{ print $3}' | xargs docker image rm'