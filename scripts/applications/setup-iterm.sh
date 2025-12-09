#!/bin/bash

# Setup iTerm2 preferences and configuration
set -e

echo "🖥️  Setting up iTerm2..."

# Check if iTerm2 is installed
if ! ls /Applications/ | grep -qi iterm; then
    echo "ℹ️  iTerm2 not installed yet. It will be installed via Homebrew."
    echo "   Run 'brew bundle install' first, then run this script again."
    exit 0
fi

echo "✅ iTerm2 is installed"

# Restore preferences if they exist in chezmoi
if [[ -f ~/.dotfiles/private_Library/Preferences/com.googlecode.iterm2.plist ]]; then
    echo "📥 Restoring iTerm2 main preferences..."
    cp ~/.dotfiles/private_Library/Preferences/com.googlecode.iterm2.plist ~/Library/Preferences/
    echo "✅ Main preferences restored"
fi

if [[ -f ~/.dotfiles/private_Library/Preferences/com.googlecode.iterm2.private.plist ]]; then
    echo "📥 Restoring iTerm2 private preferences..."
    cp ~/.dotfiles/private_Library/Preferences/com.googlecode.iterm2.private.plist ~/Library/Preferences/
    echo "✅ Private preferences restored"
fi

# Kill iTerm if it's running so it picks up the new preferences
if pgrep -f iTerm2 >/dev/null; then
    echo "🔄 Restarting iTerm2 to apply new preferences..."
    osascript -e 'tell application "iTerm2" to quit'
    sleep 2
    echo "   You can now restart iTerm2 to see your restored preferences"
else
    echo "💡 Start iTerm2 to see your preferences"
fi

echo ""
echo "🎉 iTerm2 setup completed!"
echo ""
echo "✅ What was configured:"
echo "   • iTerm2 preferences restored from backup"
echo "   • All your themes, profiles, and settings preserved"
echo "   • Ready to use with your custom configuration"