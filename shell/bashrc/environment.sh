if [[ $USER == *"@flywire.com"* ]] && [ "$(uname)" = "Darwin" ]; then
  ###########################
  # VAGRANT
  ###########################
  export PT_VM_MEMORY=4096
fi

###########################
# RBENV
###########################
export PATH=$HOME/.rbenv/shims:$PATH

###########################
# EDITOR
###########################
export EDITOR='vim'

###########################################
# Docker CLI
###########################################
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1