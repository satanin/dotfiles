#!/bin/bash

# Helper script to set up Claude and OpenAI API tokens in Bitwarden
set -e

echo "🤖 Claude Code Token Setup Helper"
echo "================================="
echo ""

# Check if Bitwarden CLI is available
if ! command -v bw &> /dev/null; then
    echo "❌ Bitwarden CLI not found. Please install: brew install bitwarden-cli"
    exit 1
fi

# Check if logged in to Bitwarden
if [[ "$(bw status | jq -r '.status')" == "unauthenticated" ]]; then
    echo "❌ Please login to Bitwarden first: bw login"
    exit 1
fi

# Unlock Bitwarden if locked
if [[ "$(bw status | jq -r '.status')" == "locked" ]]; then
    echo "🔓 Please unlock Bitwarden first: bw unlock"
    exit 1
fi

echo "📋 This script will help you set up API tokens in Bitwarden for Claude Code."
echo ""

# Function to create or check Bitwarden item
setup_token() {
    local name="$1"
    local description="$2"
    local instructions="$3"

    echo "🔍 Checking for '$name' in Bitwarden..."

    # Check if item already exists
    existing_id=$(bw list items --search "$name" | jq -r '.[0].id // empty')

    if [[ -n "$existing_id" ]]; then
        echo "✅ '$name' already exists in Bitwarden"
    else
        echo "❌ '$name' not found in Bitwarden"
        echo ""
        echo "📝 To create '$name':"
        echo "   Description: $description"
        echo "   Instructions: $instructions"
        echo ""
        read -p "Do you want to create this item now? (y/N): " create_item

        if [[ "$create_item" =~ ^[Yy]$ ]]; then
            echo ""
            echo "Please enter your API token:"
            read -s api_token

            if [[ -n "$api_token" ]]; then
                # Create the item
                bw create item '{
                    "type": 1,
                    "name": "'"$name"'",
                    "notes": "'"$description"'",
                    "login": {
                        "username": "'"$name"'",
                        "password": "'"$api_token"'"
                    }
                }' > /dev/null

                echo "✅ '$name' created successfully in Bitwarden!"
            else
                echo "⚠️  No token entered. Skipping creation of '$name'."
            fi
        else
            echo "⚠️  Skipping creation of '$name'. You can create it manually later."
        fi
    fi
    echo ""
}

# Set up Claude API Key
setup_token \
    "Claude API Key" \
    "Anthropic Claude API key for Claude Code" \
    "Get from: https://console.anthropic.com/settings/keys"

# Set up OpenAI API Key (optional)
setup_token \
    "OpenAI API Key" \
    "OpenAI API key for Claude Code (optional)" \
    "Get from: https://platform.openai.com/api-keys"

echo "🎉 Token setup completed!"
echo ""
echo "📌 Next steps:"
echo "   1. Run 'chezmoi apply' to update Claude configuration"
echo "   2. Launch Claude Code to verify the configuration"
echo "   3. Check that API keys are properly loaded in settings"
echo ""
echo "🔧 Configuration files managed:"
echo "   • ~/.claude/settings.json (from template)"
echo "   • ~/.claude/claude.json (private config with tokens)"