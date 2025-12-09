#!/bin/bash

# Setup Corporate Bitwarden Items Script
# Creates the necessary Bitwarden secure notes for corporate information

set -e

echo "🔐 Setting up Corporate Bitwarden Items..."
echo ""
echo "This script will guide you through creating the necessary Bitwarden items"
echo "for your corporate configuration."
echo ""

# Check if Bitwarden CLI is available and logged in
if ! command -v bw &> /dev/null; then
    echo "❌ Bitwarden CLI not found. Please install it first:"
    echo "   brew install bitwarden-cli"
    exit 1
fi

# Check if logged in
if ! bw status | grep -q "unlocked\|locked"; then
    echo "❌ Please login to Bitwarden first:"
    echo "   bw login"
    exit 1
fi

# Check if unlocked
if bw status | grep -q "locked"; then
    echo "🔓 Unlocking Bitwarden vault..."
    export BW_SESSION=$(bw unlock --raw)
fi

echo "✅ Bitwarden CLI ready"
echo ""

echo "📋 Required Bitwarden Items:"
echo ""
echo "1. 'AWS Corporate Config' (Secure Note)"
echo "   Should contain:"
echo "   ECR_REGISTRY=your-account.dkr.ecr.region.amazonaws.com"
echo "   ECR_PROFILE=your_ecr_profile"
echo "   CODEARTIFACT_DOMAIN=your-domain"
echo "   CODEARTIFACT_DOMAIN_OWNER=your-account-id"
echo "   CODEARTIFACT_PROFILE=your_codeartifact_profile"
echo "   SSO_START_URL=https://your-org.awsapps.com/start"
echo ""
echo "2. 'Corporate URLs' (Secure Note)"
echo "   Should contain:"
echo "   GITLAB_URL=https://gitlab.yourcompany.com"
echo "   GITLAB_API_URL=https://gitlab.yourcompany.com/api/v4"
echo "   CONFLUENCE_URL=https://confluence.yourcompany.com"
echo "   JIRA_URL=https://jira.yourcompany.com"
echo ""

# Function to check if item exists
check_item() {
    local name="$1"
    if bw get item "$name" &>/dev/null; then
        echo "   ✅ '$name' exists"
        return 0
    else
        echo "   ❌ '$name' not found"
        return 1
    fi
}

echo "📝 Checking existing items..."
check_item "AWS Corporate Config"
check_item "Corporate URLs"
echo ""

echo "💡 To create these items:"
echo "   1. Open Bitwarden (web/app)"
echo "   2. Create new 'Secure Note' items with the names above"
echo "   3. Add the configuration values in the notes field"
echo "   4. Save the items"
echo ""
echo "🔄 After creating the items:"
echo "   1. Run: chezmoi apply"
echo "   2. Test: ./scripts/aws/aws-login.sh"
echo ""
echo "🔐 Security benefit:"
echo "   Your repository is now safe to be public - no corporate secrets exposed!"