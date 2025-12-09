#!/bin/bash

# Setup Bitwarden integration for chezmoi
# Version: 2.1.0 (2024-12-09)

echo "Setting up Bitwarden integration..."
echo "🔧 Script version: 2.1.0 (setup-bitwarden)"

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
    echo "3. Verify these required items exist in your vault:"
    echo "   - GitLab Personal Token - Main (required)"
    echo "   - Claude API Key (required)"
    echo "   - SSH Key - id_rsa (required)"
    echo "   - SSH Key - satanin@gmail.com (required)"
    echo ""
    echo "   Optional items (will show warnings if missing):"
    echo "   - GitLab Personal Token - Secondary"
    echo "   - Confluence Personal Token"
    echo "   - Jira Personal Token"
    echo ""
    echo "4. Templates will use Bitwarden data automatically once unlocked"
    exit 1
fi

# Verify Bitwarden items (some required, some optional)
required_items=(
    "GitLab Personal Token - Main"
    "Claude API Key"
    "SSH Key - id_rsa"
    "SSH Key - satanin@gmail.com"
)

optional_items=(
    "GitLab Personal Token - Secondary"
    "Confluence Personal Token"
    "Jira Personal Token"
    "OpenAI API Key"
    "SSH Config"
    "SSH Known Hosts"
)

echo "Verifying Bitwarden items..."

# Check required items (must exist)
missing_required=()
for item in "${required_items[@]}"; do
    if ! bw get item "$item" &> /dev/null; then
        echo "❌ Missing required item: $item"
        missing_required+=("$item")
    else
        echo "✅ Found required: $item"
    fi
done

# Check optional items (nice to have)
for item in "${optional_items[@]}"; do
    if ! bw get item "$item" &> /dev/null; then
        echo "⚠️  Optional item missing: $item"
    else
        echo "✅ Found optional: $item"
    fi
done

# Exit only if required items are missing
if [ ${#missing_required[@]} -gt 0 ]; then
    echo ""
    echo "❌ Setup cannot continue. Missing required items:"
    for item in "${missing_required[@]}"; do
        echo "   • $item"
    done
    echo ""
    echo "Please add these items to Bitwarden and try again."
    exit 1
fi

echo ""
echo "✅ Bitwarden is ready!"
echo "You can now use chezmoi templates with your secrets."