###########################################
# execute bashrc if exists
###########################################
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

###########################################
# initialize rbenv
###########################################
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

###########################################
# autojump config
###########################################
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
