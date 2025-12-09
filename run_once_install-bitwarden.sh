#!/bin/bash

# Install Bitwarden CLI automatically
set -e

echo "🔐 Installing Bitwarden CLI..."

# Check if Bitwarden CLI is already installed
if command -v bw &> /dev/null; then
    current_version=$(bw --version)
    echo "✅ Bitwarden CLI already installed (version: $current_version)"
else
    echo "📦 Installing Bitwarden CLI via Homebrew..."

    # Check if Homebrew is available
    if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew not found. Please install Homebrew first or install Bitwarden CLI manually."
        echo "   Manual installation: https://bitwarden.com/help/cli/"
        exit 1
    fi

    # Install Bitwarden CLI
    brew install bitwarden-cli

    # Verify installation
    if command -v bw &> /dev/null; then
        installed_version=$(bw --version)
        echo "✅ Bitwarden CLI installed successfully (version: $installed_version)"
    else
        echo "❌ Failed to install Bitwarden CLI"
        exit 1
    fi
fi

echo ""
echo "🎉 Bitwarden CLI setup completed!"
echo ""
echo "📌 Next steps:"
echo "   1. Login to Bitwarden: bw login"
echo "   2. Unlock your vault: bw unlock"
echo "   3. Bitwarden templates will be used automatically"