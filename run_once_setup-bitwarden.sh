#!/bin/bash

# Setup Bitwarden integration for chezmoi

echo "Setting up Bitwarden integration..."

# Check if Bitwarden CLI is installed
if ! command -v bw &> /dev/null; then
    echo "Installing Bitwarden CLI..."
    brew install bitwarden-cli
fi

# Check if user is logged in
if ! bw status | grep -q '"status":"unlocked"'; then
    echo "Bitwarden setup required:"
    echo ""
    echo "1. Login to Bitwarden:"
    echo "   bw login your@email.com"
    echo ""
    echo "2. Unlock and set session:"
    echo "   export BW_SESSION=\"\$(bw unlock --raw)\""
    echo ""
    echo "3. Verify these items exist in your vault:"
    echo "   - GitLab Personal Token - Main"
    echo "   - GitLab Personal Token - Secondary"
    echo "   - Confluence Personal Token"
    echo "   - Jira Personal Token"
    echo ""
    echo "4. Templates will use Bitwarden data automatically once unlocked"
    exit 1
fi

# Verify required items exist
required_items=(
    "GitLab Personal Token - Main"
    "GitLab Personal Token - Secondary"
    "Confluence Personal Token"
    "Jira Personal Token"
    "Claude API Key"
    "OpenAI API Key"
    "SSH Key - id_rsa"
    "SSH Key - satanin@gmail.com"
    "SSH Config"
    "SSH Known Hosts"
)

echo "Verifying Bitwarden items..."
for item in "${required_items[@]}"; do
    if ! bw get item "$item" &> /dev/null; then
        echo "❌ Missing item: $item"
        exit 1
    else
        echo "✅ Found: $item"
    fi
done

echo ""
echo "✅ Bitwarden is ready!"
echo "You can now use chezmoi templates with your secrets."