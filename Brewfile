brew 'ack'
brew 'the_silver_searcher'
brew 'autojump'
brew 'htop'

brew 'bash-completion'

if [[ $USER == *"@flywire.com"* ]] && [ "$(uname)" = "Darwin" ]; then
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

brew 'mas'
mas 'Telegram', id: 747648890
mas 'Whatsapp', id: 1147396723
mas 'Pixelmator', id: 407963104
mas 'CPULed', id: 448189857
mas 'Slack', id: 803453959
mas 'Bitwarden', id: 1352778147
mas 'DaisyDisk', id: 411643860
mas 'Keka', id: 470158793

cask 'transmit4'

if ! [[ $USER == *"@flywire.com"* ]] && [ "$(uname)" = "Darwin" ]; then
  cask 'dropbox'
  cask 'transmission'
fi

