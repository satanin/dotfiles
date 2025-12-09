#!/bin/bash

# Backup SSH and PGP keys to Bitwarden automatically
set -e

echo "🔐 Checking for SSH and PGP keys to backup to Bitwarden..."

# Check if there are any keys to backup first
ssh_keys_exist=false
pgp_keys_exist=false

# Check for SSH keys
if [[ -f ~/.ssh/id_rsa ]] || [[ -f ~/.ssh/id_rsa_satanin@gmail.com ]] || [[ -f ~/.ssh/config ]] || [[ -f ~/.ssh/known_hosts ]]; then
    ssh_keys_exist=true
fi

# Check for PGP keys
if command -v gpg &> /dev/null; then
    secret_keys=$(gpg --list-secret-keys --keyid-format LONG 2>/dev/null | grep sec || echo "")
    if [[ -n "$secret_keys" ]]; then
        pgp_keys_exist=true
    fi
fi

# If no keys found, skip the backup
if [[ "$ssh_keys_exist" == false ]] && [[ "$pgp_keys_exist" == false ]]; then
    echo "📝 No SSH or PGP keys found on this machine"
    echo "   This is normal for new setups - keys will be restored from Bitwarden when available"
    echo "   Skipping key backup (nothing to backup)"
    exit 0
fi

echo "🔐 Found keys to backup, proceeding with Bitwarden backup..."

# Check if Bitwarden CLI is available and logged in
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
    echo "🔓 Bitwarden is locked. Please unlock it:"
    export BW_SESSION=$(bw unlock --raw)
fi

# Function to create or update Bitwarden item
create_or_update_bw_item() {
    local name="$1"
    local content="$2"
    local notes="$3"

    echo "  📝 Processing: $name"

    # Check if item already exists
    existing_id=$(bw list items --search "$name" | jq -r '.[0].id // empty')

    if [[ -n "$existing_id" ]]; then
        echo "    ⚠️  Item '$name' already exists in Bitwarden (ID: $existing_id)"
        echo "    📝 Updating existing item..."

        # Get existing item and update it
        existing_item=$(bw get item "$existing_id")
        updated_item=$(echo "$existing_item" | jq --arg content "$content" --arg notes "$notes" '.notes = $notes')
        echo "$updated_item" | bw encode | bw edit item "$existing_id" > /dev/null
        echo "    ✅ Updated successfully"
    else
        # Create new secure note
        bw create item '{
            "type": 2,
            "name": "'"$name"'",
            "notes": "'"$notes"'",
            "secureNote": {
                "type": 0
            }
        }' > /dev/null
        echo "    ✅ Created successfully"
    fi
}

# Backup SSH keys
echo "🔑 Backing up SSH keys..."

# SSH Private Keys
if [[ -f ~/.ssh/id_rsa ]]; then
    content=$(cat ~/.ssh/id_rsa)
    create_or_update_bw_item "SSH Key - id_rsa" "$content" "$content"
fi

if [[ -f ~/.ssh/id_rsa_satanin@gmail.com ]]; then
    content=$(cat ~/.ssh/id_rsa_satanin@gmail.com)
    create_or_update_bw_item "SSH Key - satanin@gmail.com" "$content" "$content"
fi

# SSH Config
if [[ -f ~/.ssh/config ]]; then
    content=$(cat ~/.ssh/config)
    create_or_update_bw_item "SSH Config" "$content" "$content"
fi

# Known hosts (optional - some prefer to rebuild this)
if [[ -f ~/.ssh/known_hosts ]]; then
    content=$(cat ~/.ssh/known_hosts)
    create_or_update_bw_item "SSH Known Hosts" "$content" "$content"
fi

# Backup PGP keys if they exist
echo "🔐 Checking for PGP keys..."

# Check if GPG is available
if command -v gpg &> /dev/null; then
    # Get list of secret keys
    secret_keys=$(gpg --list-secret-keys --keyid-format LONG 2>/dev/null | grep sec || echo "")

    if [[ -n "$secret_keys" ]]; then
        echo "  📋 Found PGP secret keys, backing them up..."

        # Export all private keys
        private_keys=$(gpg --armor --export-secret-keys 2>/dev/null)
        if [[ -n "$private_keys" ]]; then
            create_or_update_bw_item "PGP Private Keys" "$private_keys" "$private_keys"
        fi

        # Export public keys
        public_keys=$(gpg --armor --export 2>/dev/null)
        if [[ -n "$public_keys" ]]; then
            create_or_update_bw_item "PGP Public Keys" "$public_keys" "$public_keys"
        fi

        # Export trust database
        trust_db=$(gpg --export-ownertrust 2>/dev/null)
        if [[ -n "$trust_db" ]]; then
            create_or_update_bw_item "PGP Trust Database" "$trust_db" "$trust_db"
        fi
    else
        echo "  📝 No PGP secret keys found"
    fi
else
    echo "  📝 GPG not found, skipping PGP backup"
fi

echo ""
echo "🎉 Key backup completed successfully!"
echo ""
echo "📌 Available Bitwarden items have been created/updated as needed"
echo "   Keys will be automatically restored on other machines when you run chezmoi apply"