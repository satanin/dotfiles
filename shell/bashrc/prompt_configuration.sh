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

WHITE_BLACK='\[\033[38;5;15;48;5;0m\]'
WHITE_BLUE='\[\033[38;5;15;48;5;27m\]'
BLACK_BLUE='\[\033[38;5;0;48;5;27m\]'
RESET='\[\033[00m\]'
BLUE_YELLOW='\[\033[38;5;27;48;5;226m\]'
BLACK_YELLOW='\[\033[38;5;0;48;5;226m\]'
YELLOW_TRANSPARENT='\[\033[38;5;226;49m\]'
WHITE_ORANGE='\[\033[38;5;15;48;5;208m\]'

parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \1/'
}

export PS1="${WHITE_BLACK}╭ "'\h '"${BLACK_BLUE}▶${RESET}${WHITE_BLUE}"'\w '"${RESET}${BLUE_YELLOW}▶${RESET}${BLACK_YELLOW}"'$(parse_git_branch)'" ${YELLOW_TRANSPARENT}▶${RESET}
${WHITE_BLACK}╰▶ ${RESET} "
