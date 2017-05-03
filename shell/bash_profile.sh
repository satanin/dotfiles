if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

eval "$(rbenv init -)"

# autojump config
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
