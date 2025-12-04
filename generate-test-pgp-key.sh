#!/bin/bash

# Generate a test PGP key pair for testing the backup system
set -e

echo "🔐 Generating test PGP key pair..."

# Check if GPG is available
if ! command -v gpg &> /dev/null; then
    echo "❌ GPG not found. Please install it first: brew install gnupg"
    exit 1
fi

# Generate key batch file
cat > /tmp/gen-key-script <<EOF
%echo Generating test PGP key
Key-Type: RSA
Key-Length: 2048
Subkey-Type: RSA
Subkey-Length: 2048
Name-Real: Raul Garcia (Test Key)
Name-Comment: Test key for dotfiles backup system
Name-Email: raul.garcia@flywire.com
Expire-Date: 1y
Passphrase: test123
%pubring pubring.kbx
%secring trustdb.gpg
%commit
%echo done
EOF

echo "📝 Generating PGP key pair (this may take a moment)..."
gpg --batch --generate-key /tmp/gen-key-script

# Clean up
rm /tmp/gen-key-script

# List the generated keys
echo ""
echo "✅ PGP key pair generated successfully!"
echo ""
echo "🔑 Generated keys:"
gpg --list-secret-keys --keyid-format LONG

echo ""
echo "📌 Key details:"
KEY_ID=$(gpg --list-secret-keys --keyid-format LONG | grep sec | head -1 | awk '{print $2}' | cut -d'/' -f2)
echo "Key ID: $KEY_ID"

echo ""
echo "🔄 Ready to test backup system with:"
echo "   ./run_once_backup-keys-to-bitwarden.sh"