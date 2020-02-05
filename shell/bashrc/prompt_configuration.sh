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

WHITE=15
BLACK=0
ORANGE=203
PURPLE=57
GRAY=238
MAGENTA=205
BLUE=39
GREEN=50
YELLOW=227
LIME=49

RESET='\[\033[00m\]'

section_colors(){
  echo "\[\033[38;5;$1;48;5;$2m\]"
}

transparent_section(){
  echo "\[\033[38;5;$1;49m\]"
}

parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \1/'
}

docker_prompt() {
  if [ -f Dockerfile ] || [ -f docker-compose*.yml ]; then
    echo " 🐳 "
  fi
}

ruby_prompt(){
  if [ -f Gemfile ] || [ -f .ruby-version ]; then
    echo " ⛩  "
  fi
}

if [[ $USER == *"@flywire.com"* ]] && [ "$(uname)" = "Darwin" ]; then
  export PS1="$(section_colors "$WHITE" "$GRAY")╭ $(docker_prompt)$(ruby_prompt)\h $(section_colors "$WHITE" "$PURPLE") \w "${RESET}"$(section_colors "$GRAY" "$GREEN")"'$(parse_git_branch)'" ${RESET}
$(section_colors "$WHITE" "$GRAY")╰▶ ${RESET} "
else
  export PS1="$(section_colors "$WHITE" "$GRAY")╭ $(docker_prompt)$(ruby_prompt)\h $(section_colors "$WHITE" "$BLUE") \w "${RESET}"$(section_colors "$GRAY" "$GREEN")"'$(parse_git_branch)'" ${RESET}
$(section_colors "$WHITE" "$GRAY")╰▶ ${RESET} "
sudo mkdir /sys/fs/cgroup/systemd >> /dev/null 2>&1
sudo mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd >> /dev/null 2>&1
fi
