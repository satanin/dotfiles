brew 'ack'
brew 'zsh'
brew 'zsh-completion'
brew 'the_silver_searcher'
brew 'autojump'
brew 'htop'
brew 'bash-completion'
brew 'tree'

if [[ $USER == *"@flywire.com"* ]] && [ "$(uname)" == "Darwin" ]; then
  brew 'aws-okta'
  brew 'awscli'
  brew 'openconnect'
  brew 'gpg'
fi

brew 'ctags'
brew 'global'

brew 'rbenv'
brew 'ruby-build'
brew 'git'
brew 'tmux'

brew 'vim'
brew 'fzf'
brew 'bitwarden'
brew 'telegram-desktop'

brew 'mas'
mas 'Pixelmator', id: 407963104
mas 'CPULed', id: 448189857
mas 'Slack', id: 803453959
mas 'DaisyDisk', id: 411643860
mas 'Keka', id: 470158793

cask 'transmit4'

if ! [[ $USER == *"@flywire.com"* ]] && [ "$(uname)" == "Darwin" ]; then
  cask 'dropbox'
  cask 'transmission'
fi

