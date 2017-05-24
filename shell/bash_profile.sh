###########################################
# execute bashrc if exists
###########################################
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
###########################################
# Git completion
###########################################
if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
fi
###########################################
# Load aliases from bash_aliases if exists
###########################################
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
###########################################
# initialize rbenv
###########################################
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

###########################################
# autojump config
###########################################
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh


