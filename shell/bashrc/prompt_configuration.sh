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
WHITE_BLUE='\[\033[38;5;15;48;5;39m\]'
WHITE_ORANGE='\[\033[38;5;15;48;5;208m\]'
WHITE_GRAY='\[\033[38;5;15;48;5;238m\]'
WHITE_MAGENTA='\[\033[38;5;15;48;5;205m\]'
BLACK_BLUE='\[\033[38;5;0;48;5;39m\]'
BLACK_GREEN='\[\033[38;5;0;48;5;50m\]'
BLACK_YELLOW='\[\033[38;5;0;48;5;226m\]'
BLACK_ORANGE='\[\033[38;5;0;48;5;210m\]'
BLACK_LIME='\[\033[38;5;0;48;5;118m\]'
BLUE_YELLOW='\[\033[38;5;39;48;5;226m\]'
BLUE_GREEN='\[\033[38;5;39;48;5;50m\]'
BLUE_LIME='\[\033[38;5;27;48;5;118m\]'
GRAY_BLUE='\[\033[38;5;234;48;5;39m\]'
GRAY_ORANGE='\[\033[38;5;238;48;5;226m\]'
ORANGE_MAGENTA='\[\033[38;5;210;48;5;205m\]'
YELLOW_TRANSPARENT='\[\033[38;5;226;49m\]'
GREEN_TRANSPARENT='\[\033[38;5;50;49m\]'
LIME_TRANSPARENT='\[\033[38;5;118;49m\]'
MAGENTA_TRANSPARENT='\[\033[38;5;205;49m\]'
RESET='\[\033[00m\]'

parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \1/'
}

docker_prompt() {
  if [ -f Dockerfile ] || [ -f docker-compose*.yml ]; then
    echo "🐳 "
  fi
}

ruby_prompt(){
  if [ -f Gemfile ] || [ -f .ruby-version ]; then
    echo "🔴 "
  fi
}

if [ "${USER}" == "raulgarciaruiz" ]; then
  export PS1="${WHITE_GRAY}╭ "'$(docker_prompt)''\h '"${GRAY_BLUE}${RESET}${WHITE_BLUE}"' \w '"${RESET}${BLUE_GREEN}${RESET}${BLACK_GREEN}"'$(parse_git_branch)'" ${GREEN_TRANSPARENT}${RESET}
${WHITE_BLACK}╰▶ ${RESET} "
else
  export PS1="${WHITE_GRAY}╭ "'$(docker_prompt)''\h '"${GRAY_ORANGE}▶${RESET}${WHITE_ORANGE}"' \w '"${RESET}${ORANGE_MAGENTA}▶${RESET}${WHITE_MAGENTA}"'$(parse_git_branch)'" ${MAGENTA_TRANSPARENT}▶${RESET}
${WHITE_GRAY}╰▶ ${RESET} "
fi

