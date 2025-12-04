#!/bin/bash

# Setup SSH keys with proper permissions
set -e

echo "🔑 Setting up SSH keys..."

# Create .ssh directory with proper permissions
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Set proper permissions for SSH private keys
if [[ -f ~/.ssh/id_rsa ]]; then
    chmod 600 ~/.ssh/id_rsa
    echo "✅ Set permissions for id_rsa"
fi

if [[ -f ~/.ssh/id_rsa_satanin@gmail.com ]]; then
    chmod 600 ~/.ssh/id_rsa_satanin@gmail.com
    echo "✅ Set permissions for id_rsa_satanin@gmail.com"
fi

# Set proper permissions for SSH config
if [[ -f ~/.ssh/config ]]; then
    chmod 600 ~/.ssh/config
    echo "✅ Set permissions for SSH config"
fi

# Set proper permissions for known_hosts
if [[ -f ~/.ssh/known_hosts ]]; then
    chmod 644 ~/.ssh/known_hosts
    echo "✅ Set permissions for known_hosts"
fi

# Add SSH keys to ssh-agent if they exist
if command -v ssh-add &> /dev/null; then
    echo "🔐 Adding SSH keys to ssh-agent..."

    # Start ssh-agent if not running
    if ! pgrep -x ssh-agent > /dev/null; then
        eval "$(ssh-agent -s)"
    fi

    # Add keys to agent
    if [[ -f ~/.ssh/id_rsa ]]; then
        ssh-add ~/.ssh/id_rsa 2>/dev/null || echo "  ⚠️  Could not add id_rsa to ssh-agent (might be encrypted)"
    fi

    if [[ -f ~/.ssh/id_rsa_satanin@gmail.com ]]; then
        ssh-add ~/.ssh/id_rsa_satanin@gmail.com 2>/dev/null || echo "  ⚠️  Could not add id_rsa_satanin@gmail.com to ssh-agent (might be encrypted)"
    fi

    echo "✅ SSH keys added to ssh-agent"
fi

echo "🔑 SSH setup complete!"