#!/bin/bash

# Backup Enterprise Software Center manifest
echo "📦 Checking for Software Center manifest to backup..."

# Use the main management script to do the backup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANAGEMENT_SCRIPT="$SCRIPT_DIR/scripts/corporate/manage-software-center.sh"

if [[ -x "$MANAGEMENT_SCRIPT" ]]; then
    # Check if we can run sudo without password first
    if sudo -n true 2>/dev/null; then
        "$MANAGEMENT_SCRIPT" backup
    else
        echo "📝 Cannot backup Software Center manifest (no sudo access)"
        echo "   This is normal during automated setup"
        echo "   Run 'sudo $MANAGEMENT_SCRIPT backup' manually later if needed"
    fi
else
    echo "📝 Software Center management script not found"
    echo "   This is normal for non-corporate machines"
    echo "   Skipping Software Center manifest backup"
fi