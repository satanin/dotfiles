#!/bin/bash

# iTerm2 Preferences Management Script
# Handles backup, restore, and sync of iTerm2 preferences

set -e

ITERM_PREFS_DIR="$HOME/.dotfiles/private_Library/Preferences"
SYSTEM_PREFS_DIR="$HOME/Library/Preferences"

usage() {
    echo "Usage: $0 {backup|restore|sync|status}"
    echo ""
    echo "Commands:"
    echo "  backup   - Backup current iTerm2 preferences to chezmoi"
    echo "  restore  - Restore iTerm2 preferences from chezmoi backup"
    echo "  sync     - Sync preferences (backup current, then restore if newer backup exists)"
    echo "  status   - Check status of preferences and backups"
    exit 1
}

backup_preferences() {
    echo "📱 Backing up iTerm2 preferences..."

    # Create directory if it doesn't exist
    mkdir -p "$ITERM_PREFS_DIR"

    # Backup main preferences
    if [[ -f "$SYSTEM_PREFS_DIR/com.googlecode.iterm2.plist" ]]; then
        cp "$SYSTEM_PREFS_DIR/com.googlecode.iterm2.plist" "$ITERM_PREFS_DIR/"
        echo "✅ Main preferences backed up"
    else
        echo "⚠️  No iTerm2 main preferences found"
    fi

    # Backup private preferences
    if [[ -f "$SYSTEM_PREFS_DIR/com.googlecode.iterm2.private.plist" ]]; then
        cp "$SYSTEM_PREFS_DIR/com.googlecode.iterm2.private.plist" "$ITERM_PREFS_DIR/"
        echo "✅ Private preferences backed up"
    fi

    echo "🎉 Backup completed!"
}

restore_preferences() {
    echo "📥 Restoring iTerm2 preferences..."

    # Restore main preferences
    if [[ -f "$ITERM_PREFS_DIR/com.googlecode.iterm2.plist" ]]; then
        cp "$ITERM_PREFS_DIR/com.googlecode.iterm2.plist" "$SYSTEM_PREFS_DIR/"
        echo "✅ Main preferences restored"
    else
        echo "⚠️  No backup found for main preferences"
    fi

    # Restore private preferences
    if [[ -f "$ITERM_PREFS_DIR/com.googlecode.iterm2.private.plist" ]]; then
        cp "$ITERM_PREFS_DIR/com.googlecode.iterm2.private.plist" "$SYSTEM_PREFS_DIR/"
        echo "✅ Private preferences restored"
    fi

    # Restart iTerm if running
    if pgrep -f iTerm2 >/dev/null; then
        echo "🔄 iTerm2 is running. Restart iTerm2 to apply changes."
    fi

    echo "🎉 Restore completed!"
}

check_status() {
    echo "📊 iTerm2 Preferences Status"
    echo "=========================="

    # Check if iTerm2 is installed
    if ls /Applications/ | grep -qi iterm; then
        echo "✅ iTerm2: Installed"
    else
        echo "❌ iTerm2: Not installed"
    fi

    # Check system preferences
    echo ""
    echo "System preferences:"
    if [[ -f "$SYSTEM_PREFS_DIR/com.googlecode.iterm2.plist" ]]; then
        SYSTEM_SIZE=$(stat -f%z "$SYSTEM_PREFS_DIR/com.googlecode.iterm2.plist")
        SYSTEM_DATE=$(stat -f%m "$SYSTEM_PREFS_DIR/com.googlecode.iterm2.plist" | xargs date -r)
        echo "  ✅ Main: $SYSTEM_SIZE bytes (modified: $SYSTEM_DATE)"
    else
        echo "  ❌ Main: Not found"
    fi

    if [[ -f "$SYSTEM_PREFS_DIR/com.googlecode.iterm2.private.plist" ]]; then
        PRIVATE_SIZE=$(stat -f%z "$SYSTEM_PREFS_DIR/com.googlecode.iterm2.private.plist")
        PRIVATE_DATE=$(stat -f%m "$SYSTEM_PREFS_DIR/com.googlecode.iterm2.private.plist" | xargs date -r)
        echo "  ✅ Private: $PRIVATE_SIZE bytes (modified: $PRIVATE_DATE)"
    else
        echo "  ❌ Private: Not found"
    fi

    # Check backup preferences
    echo ""
    echo "Backup preferences:"
    if [[ -f "$ITERM_PREFS_DIR/com.googlecode.iterm2.plist" ]]; then
        BACKUP_SIZE=$(stat -f%z "$ITERM_PREFS_DIR/com.googlecode.iterm2.plist")
        BACKUP_DATE=$(stat -f%m "$ITERM_PREFS_DIR/com.googlecode.iterm2.plist" | xargs date -r)
        echo "  ✅ Main backup: $BACKUP_SIZE bytes (modified: $BACKUP_DATE)"
    else
        echo "  ❌ Main backup: Not found"
    fi

    if [[ -f "$ITERM_PREFS_DIR/com.googlecode.iterm2.private.plist" ]]; then
        BACKUP_PRIVATE_SIZE=$(stat -f%z "$ITERM_PREFS_DIR/com.googlecode.iterm2.private.plist")
        BACKUP_PRIVATE_DATE=$(stat -f%m "$ITERM_PREFS_DIR/com.googlecode.iterm2.private.plist" | xargs date -r)
        echo "  ✅ Private backup: $BACKUP_PRIVATE_SIZE bytes (modified: $BACKUP_PRIVATE_DATE)"
    else
        echo "  ❌ Private backup: Not found"
    fi
}

sync_preferences() {
    echo "🔄 Syncing iTerm2 preferences..."
    backup_preferences
    echo ""
    restore_preferences
}

# Main script logic
case "${1:-}" in
    backup)
        backup_preferences
        ;;
    restore)
        restore_preferences
        ;;
    sync)
        sync_preferences
        ;;
    status)
        check_status
        ;;
    *)
        usage
        ;;
esac