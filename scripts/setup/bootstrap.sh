#!/bin/bash

# Bootstrap script for setting up dotfiles from scratch on a new machine
set -e

echo "🚀 Bootstrapping dotfiles setup..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script is designed for macOS only"
    exit 1
fi

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ "$(uname -m)" == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew already installed"
fi

# Install essential tools first
echo "🔧 Installing essential tools..."
brew install git
brew install chezmoi
brew install bitwarden-cli

# Clone dotfiles if not already present
DOTFILES_DIR="$HOME/.dotfiles"
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "📂 Cloning dotfiles repository..."

    # Prompt for repository URL
    echo "Please enter your dotfiles repository URL:"
    echo "(example: https://github.com/username/dotfiles.git)"
    read -p "Repository URL: " repo_url

    if [[ -z "$repo_url" ]]; then
        echo "❌ No repository URL provided"
        exit 1
    fi

    git clone "$repo_url" "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
else
    echo "✅ Dotfiles directory already exists"
    cd "$DOTFILES_DIR"
fi

# Initialize chezmoi with the dotfiles directory
echo "⚙️ Initializing chezmoi..."
chezmoi init --source="$DOTFILES_DIR"

# Install remaining packages from Brewfile
if [[ -f "Brewfile" ]]; then
    echo "📦 Installing packages from Brewfile..."
    brew bundle install
else
    echo "⚠️  No Brewfile found, skipping package installation"
fi

echo ""
echo "🎉 Bootstrap completed successfully!"
echo ""
echo "📌 Next steps:"
echo "   1. Login to Bitwarden: bw login"
echo "   2. Unlock your vault: bw unlock"
echo "   3. Apply dotfiles: chezmoi apply"
echo ""
echo "🔄 Run this command to complete the setup:"
echo "   bw login && bw unlock && chezmoi apply"