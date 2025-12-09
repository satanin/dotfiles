#!/bin/bash

# Install Oh My Zsh and plugins if zsh is available and oh-my-zsh is not already installed
if which zsh > /dev/null 2>&1 && ! [[ -d ~/.oh-my-zsh ]]; then
  echo 'Installing Oh My Zsh...'

  # Install Oh My Zsh
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  # Install Powerlevel10k theme
  echo 'Installing Powerlevel10k theme...'
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

  # Install zsh-syntax-highlighting plugin
  echo 'Installing zsh-syntax-highlighting...'
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  # Install zsh-autosuggestions plugin
  echo 'Installing zsh-autosuggestions...'
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

  # Install zsh-nvm plugin
  echo 'Installing zsh-nvm...'
  git clone https://github.com/lukechilds/zsh-nvm ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-nvm

  echo 'Oh My Zsh installation complete!'
fi