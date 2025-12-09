#!/bin/bash

# Set zsh as the default shell if it's available
if which zsh > /dev/null 2>&1; then
  # Check if zsh is already the default shell
  if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo 'Setting zsh as default shell...'
    chsh -s $(which zsh)
    echo 'Please restart your terminal for changes to take effect.'
  fi
fi