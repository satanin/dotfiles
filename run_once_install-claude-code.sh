#!/bin/bash

# Install and configure Claude Code
set -e

echo "🤖 Installing and configuring Claude Code..."

# Check if Claude Code is already installed
if command -v claude-code &> /dev/null; then
    current_version=$(claude-code --version 2>/dev/null || echo "unknown")
    echo "✅ Claude Code already installed (version: $current_version)"
else
    echo "📦 Installing Claude Code via Homebrew..."

    # Check if Homebrew is available
    if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew not found. Please install Homebrew first."
        exit 1
    fi

    # Install Claude Code
    brew install --cask claude-code

    # Verify installation
    if command -v claude-code &> /dev/null; then
        installed_version=$(claude-code --version 2>/dev/null || echo "installed")
        echo "✅ Claude Code installed successfully (version: $installed_version)"
    else
        echo "❌ Failed to install Claude Code"
        exit 1
    fi
fi

# Create Claude configuration directory if it doesn't exist
echo "📂 Setting up Claude configuration directory..."
mkdir -p ~/.claude

# Set up platform files if they don't exist
echo "⚙️ Configuring Claude platform settings..."

# Create basic platform structure if needed
if [[ ! -d ~/.claude/platform ]]; then
    mkdir -p ~/.claude/platform
    echo "📁 Created ~/.claude/platform directory"
fi

# Create commands directory if it doesn't exist
if [[ ! -d ~/.claude/commands ]]; then
    mkdir -p ~/.claude/commands
    echo "📁 Created ~/.claude/commands directory"
fi

# Set proper permissions for Claude directory
chmod 755 ~/.claude
chmod -R 755 ~/.claude/platform 2>/dev/null || true
chmod -R 755 ~/.claude/commands 2>/dev/null || true

echo ""
echo "🎉 Claude Code setup completed!"
echo ""
echo "📌 Next steps:"
echo "   1. Configure API keys in Bitwarden:"
echo "      • 'Claude API Key' - Your Anthropic API key"
echo "      • 'OpenAI API Key' - Your OpenAI API key (optional)"
echo "   2. Configuration templates will be applied automatically"
echo "   3. Launch Claude Code and verify settings"
echo ""
echo "🔄 Configuration files will be managed by chezmoi templates"