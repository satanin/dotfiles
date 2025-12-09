#!/bin/bash

# Install Homebrew and packages with conflict checking
# Version: 2.2.0 (2024-12-09)
set -e

echo "🍺 Setting up Homebrew..."
echo "🔧 Script version: 2.2.0 (v2-install-brew)"

# Debug info
echo "🔍 Debug info:"
echo "   Operating system: $(uname)"
echo "   Homebrew available: $(command -v brew &> /dev/null && echo "✅ Yes" || echo "❌ No")"
# Try multiple ways to find the dotfiles directory
DOTFILES_DIR="$(chezmoi source-path 2>/dev/null || echo "")"
if [[ -z "$DOTFILES_DIR" ]] || [[ ! -f "$DOTFILES_DIR/Brewfile" ]]; then
    echo "⚠️  chezmoi source-path failed or no Brewfile found, trying alternatives..."

    # Try common locations
    for dir in "$HOME/.local/share/chezmoi" "$HOME/.dotfiles" "$(dirname "$(realpath "$0")")"; do
        if [[ -f "$dir/Brewfile" ]]; then
            DOTFILES_DIR="$dir"
            echo "✅ Found Brewfile in: $DOTFILES_DIR"
            break
        fi
    done
fi

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
echo "🔍 Debug before brew bundle:"
echo "   Current directory: $(pwd)"
echo "   Target directory: $DOTFILES_DIR"
echo "   Directory exists: $(test -d "$DOTFILES_DIR" && echo "✅ Yes" || echo "❌ No")"
echo "   Brewfile exists: $(test -f "$DOTFILES_DIR/Brewfile" && echo "✅ Yes" || echo "❌ No")"
echo "   Brewfile path: $DOTFILES_DIR/Brewfile"

# List contents of target directory for debug
if [[ -d "$DOTFILES_DIR" ]]; then
    echo "   Directory contents:"
    ls -la "$DOTFILES_DIR/" | head -10
fi

# Final validation before running brew bundle
if [[ ! -f "$DOTFILES_DIR/Brewfile" ]]; then
    echo "❌ Error: Brewfile not found at $DOTFILES_DIR/Brewfile"
    echo "   Available files in $DOTFILES_DIR:"
    ls -la "$DOTFILES_DIR/" 2>/dev/null || echo "   Directory not accessible"
    exit 1
fi

echo "✅ Running brew bundle install from: $DOTFILES_DIR"
cd "$DOTFILES_DIR" && brew bundle install

echo ""
echo "🎉 Homebrew setup completed!"
echo ""
echo "💡 If you added new applications later, run:"
echo "   ./check-brew-conflicts.sh check"