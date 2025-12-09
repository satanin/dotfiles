#!/bin/bash

# Backup iTerm2 preferences to chezmoi
set -e

echo "📱 Backing up iTerm2 preferences..."

# Check if iTerm2 is installed
if ! command -v iTerm >/dev/null 2>&1 && ! ls /Applications/ | grep -i iterm >/dev/null 2>&1; then
    echo "⚠️  iTerm2 not found on this machine"
    echo "   This is normal for new setups - iTerm2 will be installed via Brewfile"
    echo "   Skipping iTerm2 preferences backup (nothing to backup)"
    exit 0
fi

# Create directory for iTerm preferences
mkdir -p ~/.dotfiles/private_Library/Preferences

# Copy the main preference file
if [[ -f ~/Library/Preferences/com.googlecode.iterm2.plist ]]; then
    cp ~/Library/Preferences/com.googlecode.iterm2.plist ~/.dotfiles/private_Library/Preferences/
    echo "✅ Backed up iTerm2 main preferences"
else
    echo "⚠️  iTerm2 preferences not found at ~/Library/Preferences/com.googlecode.iterm2.plist"
    echo "   Start iTerm2 and configure it, then run this script again."
    exit 1
fi

# Also backup the private preferences if they exist
if [[ -f ~/Library/Preferences/com.googlecode.iterm2.private.plist ]]; then
    cp ~/Library/Preferences/com.googlecode.iterm2.private.plist ~/.dotfiles/private_Library/Preferences/
    echo "✅ Backed up iTerm2 private preferences"
fi

echo ""
echo "🎉 iTerm2 preferences backed up successfully!"
echo ""
echo "📝 What was backed up:"
echo "   • Main preferences: com.googlecode.iterm2.plist"
echo "   • Private preferences: com.googlecode.iterm2.private.plist (if exists)"
echo ""
echo "💡 These files will be:"
echo "   • Restored automatically when chezmoi applies"
echo "   • Kept in sync across all your machines"
echo "   • Preserved during macOS upgrades"