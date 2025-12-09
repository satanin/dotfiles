#!/bin/bash

# Restore Enterprise Software Center manifest on corporate machines
echo "🔄 Checking for Software Center manifest to restore..."

# Use the main management script to do the restore
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANAGEMENT_SCRIPT="$SCRIPT_DIR/scripts/corporate/manage-software-center.sh"

if [[ -x "$MANAGEMENT_SCRIPT" ]]; then
    "$MANAGEMENT_SCRIPT" restore
else
    echo "📝 Software Center management script not found"
    echo "   This is normal for non-corporate machines"
    echo "   Skipping Software Center manifest restore"
    exit 0
fi