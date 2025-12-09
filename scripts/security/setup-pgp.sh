#!/bin/bash

# Setup PGP keys from chezmoi managed files
set -e

echo "🔐 Setting up PGP keys..."

# Create .gnupg directory with proper permissions
mkdir -p ~/.gnupg
chmod 700 ~/.gnupg

# Import private key if it exists
if [[ -f ~/.gnupg/private_key.asc ]]; then
    echo "Importing PGP private key..."
    gpg --import ~/.gnupg/private_key.asc

    # Set ultimate trust for imported key (optional)
    # Get key ID from imported key
    KEY_ID=$(gpg --list-secret-keys --keyid-format LONG | grep sec | head -1 | awk '{print $2}' | cut -d'/' -f2)
    if [[ -n "$KEY_ID" ]]; then
        echo "Setting ultimate trust for key $KEY_ID..."
        echo -e "5\ny\n" | gpg --command-fd 0 --expert --edit-key $KEY_ID trust
    fi

    # Clean up the private key file for security
    rm ~/.gnupg/private_key.asc
    echo "✅ PGP private key imported and cleaned up"
else
    echo "⚠️  No private key found at ~/.gnupg/private_key.asc"
fi

# Import public keys if they exist
if [[ -f ~/.gnupg/public_keys.asc ]]; then
    echo "Importing PGP public keys..."
    gpg --import ~/.gnupg/public_keys.asc
    rm ~/.gnupg/public_keys.asc
    echo "✅ PGP public keys imported and cleaned up"
fi

# Import trust database if it exists
if [[ -f ~/.gnupg/trust_db.txt ]]; then
    echo "Importing PGP trust database..."
    gpg --import-ownertrust ~/.gnupg/trust_db.txt
    rm ~/.gnupg/trust_db.txt
    echo "✅ PGP trust database imported and cleaned up"
fi

# Set proper permissions
chmod 600 ~/.gnupg/*
chmod 700 ~/.gnupg

echo "🔐 PGP setup complete!"