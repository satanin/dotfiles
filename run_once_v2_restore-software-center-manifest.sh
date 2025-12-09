#!/bin/bash

# Restore Enterprise Software Center manifest on corporate machines
# Version: 2.1.0 (2024-12-09)

echo "🔄 Checking for Software Center manifest to restore..."
echo "🔧 Script version: 2.1.0 (restore-software-center-manifest)"

# Use the main management script to do the restore
# Get chezmoi source directory instead of script execution directory
DOTFILES_DIR="$(chezmoi source-path 2>/dev/null || echo "$HOME/.dotfiles")"
MANAGEMENT_SCRIPT="$DOTFILES_DIR/scripts/corporate/manage-software-center.sh"

echo "🔍 Debug info:"
echo "   Dotfiles directory: $DOTFILES_DIR"
echo "   Management script: $MANAGEMENT_SCRIPT"
echo "   Management script exists: $(test -f "$MANAGEMENT_SCRIPT" && echo "✅ Yes" || echo "❌ No")"
echo "   Management script executable: $(test -x "$MANAGEMENT_SCRIPT" && echo "✅ Yes" || echo "❌ No")"

if [[ -x "$MANAGEMENT_SCRIPT" ]]; then
    # Check if we can run sudo without password first
    if sudo -n true 2>/dev/null; then
        "$MANAGEMENT_SCRIPT" restore
    else
        echo "📝 Cannot restore Software Center manifest (no sudo access)"
        echo "   This is normal during automated setup"
        echo "   Run 'sudo $MANAGEMENT_SCRIPT restore' manually later if needed"
    fi
else
    echo "📝 Software Center management script not found"
    echo "   This is normal for non-corporate machines"
    echo "   Skipping Software Center manifest restore"
fi