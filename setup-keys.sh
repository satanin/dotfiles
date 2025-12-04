#!/bin/bash

# Master script for setting up SSH and PGP keys with Bitwarden + chezmoi
set -e

echo "🚀 Setting up SSH and PGP keys with Bitwarden integration..."
echo ""

# Step 1: Backup existing keys to Bitwarden
echo "Step 1: Backing up existing keys to Bitwarden..."
if [[ -f "./run_once_backup-keys-to-bitwarden.sh" ]]; then
    ./run_once_backup-keys-to-bitwarden.sh
    echo "✅ Backup completed"
else
    echo "❌ Backup script not found"
    exit 1
fi

echo ""

# Step 2: Apply chezmoi configuration
echo "Step 2: Applying chezmoi templates..."
if command -v chezmoi &> /dev/null; then
    chezmoi apply
    echo "✅ chezmoi configuration applied"
else
    echo "❌ chezmoi not found. Please install it first."
    exit 1
fi

echo ""

# Step 3: Verify setup
echo "Step 3: Verifying setup..."

# Check SSH
echo "🔑 SSH Keys:"
if [[ -f ~/.ssh/id_rsa ]]; then
    echo "  ✅ id_rsa ($(stat -f%Sp ~/.ssh/id_rsa))"
else
    echo "  ❌ id_rsa missing"
fi

if [[ -f ~/.ssh/id_rsa_satanin@gmail.com ]]; then
    echo "  ✅ id_rsa_satanin@gmail.com ($(stat -f%Sp ~/.ssh/id_rsa_satanin@gmail.com))"
else
    echo "  ❌ id_rsa_satanin@gmail.com missing"
fi

if [[ -f ~/.ssh/config ]]; then
    echo "  ✅ SSH config ($(stat -f%Sp ~/.ssh/config))"
else
    echo "  ❌ SSH config missing"
fi

# Check PGP
echo "🔐 PGP Keys:"
if command -v gpg &> /dev/null; then
    secret_count=$(gpg --list-secret-keys 2>/dev/null | grep -c "sec" || echo "0")
    public_count=$(gpg --list-keys 2>/dev/null | grep -c "pub" || echo "0")
    echo "  📊 Secret keys: $secret_count"
    echo "  📊 Public keys: $public_count"
else
    echo "  📝 GPG not installed"
fi

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📌 What was done:"
echo "   • SSH and PGP keys backed up to Bitwarden"
echo "   • Templates configured for automatic recovery"
echo "   • Proper permissions set on key files"
echo "   • Keys added to ssh-agent (if possible)"
echo ""
echo "🔄 On a new machine, simply run 'chezmoi apply' after login to Bitwarden!"