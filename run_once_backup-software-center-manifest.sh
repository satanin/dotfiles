#!/bin/bash

# Backup Enterprise Software Center manifest
echo "📦 Checking for Software Center manifest to backup..."

# Use the main management script to do the backup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANAGEMENT_SCRIPT="$SCRIPT_DIR/scripts/corporate/manage-software-center.sh"

if [[ -x "$MANAGEMENT_SCRIPT" ]]; then
    "$MANAGEMENT_SCRIPT" backup
else
    echo "📝 Software Center management script not found"
    echo "   This is normal for non-corporate machines"
    echo "   Skipping Software Center manifest backup"
    exit 0
fi