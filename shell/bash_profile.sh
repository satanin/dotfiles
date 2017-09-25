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
    # Add git completion to aliases
   __git_complete ga _git_add
   __git_complete gs _git_status
   __git_complete gb _git_branch
   __git_complete gco _git_checkout
   __git_complete gm _git_merge
   __git_complete ggpull _git_pull
   __git_complete ggpush _git_push
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
# autojump config for mac and linux
###########################################
if [ "${USER}" == "raulgarciaruiz" ]; then
  [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
else
  . /usr/share/autojump/autojump.sh
fi
