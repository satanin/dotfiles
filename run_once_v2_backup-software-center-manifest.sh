#!/bin/bash

# Backup Enterprise Software Center manifest
# Version: 2.1.0 (2024-12-09)

echo "📦 Checking for Software Center manifest to backup..."
echo "🔧 Script version: 2.1.0 (backup-software-center-manifest)"

# Use the main management script to do the backup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANAGEMENT_SCRIPT="$SCRIPT_DIR/scripts/corporate/manage-software-center.sh"

echo "🔍 Debug info:"
echo "   Script directory: $SCRIPT_DIR"
echo "   Management script: $MANAGEMENT_SCRIPT"
echo "   Management script exists: $(test -f "$MANAGEMENT_SCRIPT" && echo "✅ Yes" || echo "❌ No")"
echo "   Management script executable: $(test -x "$MANAGEMENT_SCRIPT" && echo "✅ Yes" || echo "❌ No")"

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