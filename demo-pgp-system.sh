#!/bin/bash

# Demo script to show how PGP key management works
set -e

echo "🔐 PGP Key Management System Demo"
echo "================================="
echo ""

# Check GPG installation
if ! command -v gpg &> /dev/null; then
    echo "❌ GPG not found. Installing..."
    brew install gnupg
else
    echo "✅ GPG is installed ($(gpg --version | head -1 | awk '{print $3}'))"
fi

echo ""
echo "🎯 System Capabilities:"
echo ""
echo "📋 When you have PGP keys, the system will automatically:"
echo "   1. 🔍 Detect all your PGP secret and public keys"
echo "   2. 💾 Export them securely to Bitwarden items:"
echo "      • 'PGP Private Keys' - All your private keys"
echo "      • 'PGP Public Keys' - All your public keys"
echo "      • 'PGP Trust Database' - Your web of trust"
echo "   3. 📋 Create chezmoi templates for automatic recovery"
echo "   4. 🔧 Configure GPG with optimal security settings"
echo ""

echo "🔄 Recovery Process on New Machine:"
echo "   1. Run: chezmoi apply"
echo "   2. Keys automatically imported from Bitwarden"
echo "   3. Trust database restored"
echo "   4. GPG configured with optimal settings"
echo "   5. Proper permissions set (700 for .gnupg)"
echo ""

echo "📁 File Structure Created:"
echo "   ~/.gnupg/"
echo "   ├── private_key.asc.tmpl     # Private keys from Bitwarden"
echo "   ├── public_keys.asc.tmpl     # Public keys from Bitwarden"
echo "   ├── trust_db.txt.tmpl        # Trust DB from Bitwarden"
echo "   └── gpg.conf.tmpl             # Optimized GPG config"
echo ""

# Check current PGP status
echo "📊 Current PGP Status:"
secret_keys=$(gpg --list-secret-keys 2>/dev/null | grep -c "sec" || echo "0")
public_keys=$(gpg --list-keys 2>/dev/null | grep -c "pub" || echo "0")
echo "   Secret keys: $secret_keys"
echo "   Public keys: $public_keys"

if [[ "$secret_keys" == "0" ]]; then
    echo ""
    echo "💡 To test the system with real keys:"
    echo "   1. Generate or import your PGP keys"
    echo "   2. Run: ./setup-keys.sh"
    echo "   3. Keys will be backed up to Bitwarden automatically"
    echo ""
    echo "🔒 Security Features:"
    echo "   • Keys never stored in git repository"
    echo "   • Encrypted storage in Bitwarden vault"
    echo "   • Automatic cleanup of temporary files"
    echo "   • Proper file permissions enforced"
    echo "   • Ultimate trust configured for your keys"
else
    echo ""
    echo "✅ You have PGP keys! Run './setup-keys.sh' to back them up."
fi

echo ""
echo "🎉 System is ready for PGP key management!"