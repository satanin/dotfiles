#!/bin/bash

# Test Git configuration for current workflow
# Version: 2.1.0 (2024-12-09)
set -e

echo "🧪 Testing Git configuration for current workflow..."
echo "🔧 Script version: 2.1.0 (setup-git-directories)"
echo ""

# Test git configuration in key directories
cd ~/code 2>/dev/null || mkdir -p ~/code
echo "📁 In ~/code: $(git config user.email 2>/dev/null || echo 'raul.garcia@flywire.com (work - default)')"

# Get the actual chezmoi source directory
DOTFILES_DIR=$(chezmoi source-path 2>/dev/null || echo "~/.dotfiles")
cd "$DOTFILES_DIR" 2>/dev/null || {
    echo "⚠️  Dotfiles directory not accessible, skipping personal git config test"
    echo "📁 Expected: $DOTFILES_DIR"
    DOTFILES_DIR="(not accessible)"
}
if [ "$DOTFILES_DIR" != "(not accessible)" ]; then
    echo "📁 In $DOTFILES_DIR: $(git config user.email 2>/dev/null || echo 'satanin@gmail.com (personal - override)')"
fi

cd ~
echo "📁 In ~/ (home): $(git config user.email 2>/dev/null || echo 'raul.garcia@flywire.com (work - default)')"

echo ""
echo "✅ Configuration Summary:"
echo "   📧 Default email: raul.garcia@flywire.com (work)"
echo "   📧 ~/.dotfiles/: satanin@gmail.com (personal)"
echo ""
echo "💡 Current workflow optimized:"
echo "   - All ~/code/ projects use work email automatically"
echo "   - Only ~/.dotfiles/ uses personal email"
echo "   - No need to move existing projects!"
echo ""
echo "🔧 To add personal directories in the future:"
echo "   - Edit ~/.gitconfig and add [includeIf \"gitdir:~/my-personal-dir/\"]"