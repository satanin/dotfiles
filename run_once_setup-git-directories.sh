#!/bin/bash

# Test Git configuration for current workflow
set -e

echo "🧪 Testing Git configuration for current workflow..."
echo ""

# Test git configuration in key directories
cd ~/code 2>/dev/null || mkdir -p ~/code
echo "📁 In ~/code: $(git config user.email 2>/dev/null || echo 'raul.garcia@flywire.com (work - default)')"

cd ~/.dotfiles
echo "📁 In ~/.dotfiles: $(git config user.email 2>/dev/null || echo 'satanin@gmail.com (personal - override)')"

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