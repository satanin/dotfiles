###########################
# VAGRANT
###########################
export PT_VM_MEMORY=4096

###########################
# RBENV
###########################
export PATH=$HOME/.rbenv/shims:$PATH

###########################
# EDITOR
###########################
if [ "${USER}" == "raulgarciaruiz" ]; then
  export EDITOR='subl'
else
  export EDITOR='vim'
fi