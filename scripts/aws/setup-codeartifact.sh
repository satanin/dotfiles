#!/bin/bash

# Setup AWS CodeArtifact for Ruby gem access
set -e

echo "📚 Setting up AWS CodeArtifact configuration..."

# Check if AWS CLI is available
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI not found. Installing via Homebrew..."
    brew install awscli
else
    echo "✅ AWS CLI is available"
fi

# Check if aws-login.sh is available
if [[ ! -f "./aws-login.sh" ]]; then
    echo "❌ aws-login.sh script not found in current directory"
    echo "   Please make sure you're running this from your dotfiles directory"
    exit 1
fi

echo "📋 AWS CodeArtifact Setup Information:"
echo ""
echo "🔧 Configuration:"
echo "   Domain: [Configured via Bitwarden]"
echo "   Domain Owner: [Configured via Bitwarden]"
echo "   Region: us-east-1"
echo ""
echo "📝 How to use:"
echo "   1. Run './aws-login.sh' to authenticate and get tokens"
echo "   2. The script will:"
echo "      • Login to AWS SSO"
echo "      • Authenticate with ECR for Docker"
echo "      • Generate CodeArtifact token for Ruby gems"
echo "      • Export environment variables"
echo ""
echo "⏰ Token Management:"
echo "   • CodeArtifact tokens expire every 12 hours"
echo "   • Re-run './aws-login.sh' when tokens expire"
echo "   • Tokens are automatically sourced in new terminal sessions"
echo ""

# Create a symlink to aws-login.sh in home directory if it doesn't exist
if [[ ! -f ~/aws-login.sh ]]; then
    ln -s "$(pwd)/aws-login.sh" ~/aws-login.sh
    echo "✅ Created symlink: ~/aws-login.sh -> $(pwd)/aws-login.sh"
fi

# Add sourcing of CodeArtifact env to shell profiles if not already there
CODEARTIFACT_SOURCE="
if [[ -f ~/.codeartifact_env ]]; then
    source ~/.codeartifact_env
fi"

# Check if already in .zshrc
if ! grep -q "codeartifact_env" ~/.zshrc 2>/dev/null; then
    echo "" >> ~/.zshrc
    echo "$CODEARTIFACT_SOURCE" >> ~/.zshrc
    echo "✅ Added CodeArtifact env sourcing to ~/.zshrc"
else
    echo "✅ CodeArtifact env sourcing already configured in ~/.zshrc"
fi

echo ""
echo "🎉 CodeArtifact setup completed!"
echo ""
echo "🚀 Next steps:"
echo "   1. Run './aws-login.sh' to authenticate"
echo "   2. Test Ruby gem installation from private repositories"
echo "   3. Tokens will be automatically available in new terminal sessions"