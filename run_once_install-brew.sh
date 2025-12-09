#!/bin/bash

# Install Homebrew and packages with conflict checking
# Version: 2.1.0 (2024-12-09)
set -e

echo "🍺 Setting up Homebrew..."
echo "🔧 Script version: 2.1.0 (install-brew)"

# Debug info
echo "🔍 Debug info:"
echo "   Operating system: $(uname)"
echo "   Homebrew available: $(command -v brew &> /dev/null && echo "✅ Yes" || echo "❌ No")"
DOTFILES_DIR="$(chezmoi source-path 2>/dev/null || echo "$HOME/.dotfiles")"
echo "   Dotfiles directory: $DOTFILES_DIR"
echo "   Brewfile exists: $(test -f "$DOTFILES_DIR/Brewfile" && echo "✅ Yes" || echo "❌ No")"

# Install Homebrew if not present on macOS
if [ "$(uname)" = "Darwin" ] && ! which brew > /dev/null 2>&1; then
  echo '📥 Installing Homebrew...'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo '✅ Homebrew already installed'
fi

# Make sure we have the latest Homebrew
if which brew > /dev/null 2>&1; then
  echo '🔄 Updating Homebrew...'
  brew update
fi

# Check for conflicts before installing
if [[ -f "$DOTFILES_DIR/check-brew-conflicts.sh" ]]; then
  echo ""
  echo "🔍 Checking for Software Center conflicts..."

  if cd "$DOTFILES_DIR" && ./check-brew-conflicts.sh check; then
    echo "✅ No conflicts detected, proceeding with installation"
  else
    echo ""
    echo "⚠️  Conflicts detected! Please resolve them first:"
    echo "   1. Review the conflicts listed above"
    echo "   2. Edit Brewfile to remove conflicting applications"
    echo "   3. Or uninstall conflicting apps from Software Center"
    echo "   4. Run this script again"
    echo ""
    echo "💡 You can also run './check-brew-conflicts.sh list' to see all installed apps"
    exit 1
  fi
else
  echo "⚠️  Conflict checker not found, proceeding anyway..."
fi

# Install packages from Brewfile
echo ""
echo "📦 Installing packages from Brewfile..."
cd "$DOTFILES_DIR" && brew bundle install

echo ""
echo "🎉 Homebrew setup completed!"
echo ""
echo "💡 If you added new applications later, run:"
echo "   ./check-brew-conflicts.sh check"