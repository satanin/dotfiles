##########################################
# PROMPT CONFIGURATION
##########################################

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # We have color support; assume it's compliant with Ecma-48
  # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
  # a case would tend to support setf rather than setaf.)
  color_prompt=yes
    else
  color_prompt=
    fi
fi

parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \1/'
}

parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working tree clean" ]]
}

if [[ $(parse_git_dirty) == true ]]; then
  export PS1='\[\033[38;5;15;48;5;0m\]\h \[\033[38;5;0;48;5;27m\]▶\[\033[00m\]\[\033[38;5;15;48;5;27m\]\w \[\033[00m\]\[\033[38;5;27;48;5;226m\]▶\[\033[0m\]\[\033[38;5;0;48;5;226m\]$(parse_git_branch) \[\033[38;5;226;49m\]▶\[\033[0m\]
\[\033[38;5;15;48;5;0m\]▶ \[\033[0m\]'
else
  export PS1='\[\033[38;5;15;48;5;0m\]\h \[\033[38;5;0;48;5;27m\]▶\[\033[00m\]\[\033[38;5;15;48;5;27m\]\w \[\033[00m\]\[\033[38;5;27;48;5;226m\]▶\[\033[0m\]\[\033[38;5;0;48;5;226m\]$(parse_git_branch) \[\033[38;5;226;49m\]▶\[\033[0m\]
\[\033[38;5;15;48;5;0m\]▶ \[\033[0m\]'
fi

#################################################