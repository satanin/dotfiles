#!/bin/bash

# Enterprise Software Center Manifest Management
# Version: 2.1.0 (2024-12-09)
set -e

MANIFEST_PATH="/Library/Managed Installs/manifests/SelfServeManifest"
BACKUP_PATH="$HOME/.dotfiles/private_Library/Managed Installs/manifests/SelfServeManifest"

usage() {
    echo "Usage: $0 {backup|restore|status|check}"
    echo ""
    echo "Commands:"
    echo "  backup   - Backup current Software Center manifest (requires sudo)"
    echo "  restore  - Restore Software Center manifest from backup (requires sudo)"
    echo "  status   - Show status of manifest and backup"
    echo "  check    - Check if this is a corporate machine"
    exit 1
}

# Check if this is a corporate machine
is_corporate_machine() {
    [[ -f "/Library/Managed Installs/ManagedInstallReport.plist" ]] || \
    [[ -d "/Applications/Software Center.app" ]] || \
    [[ -d "/Applications/Enterprise Software Center.app" ]] || \
    [[ -d "/Applications/Managed Software Center.app" ]] || \
    [[ -d "/Library/Managed Installs" ]] || \
    [[ -f "/usr/local/munki/managedsoftwareupdate" ]]
}

check_corporate() {
    echo "🔍 Checking machine type..."

    if is_corporate_machine; then
        echo "✅ This is a corporate machine"

        echo ""
        echo "Corporate indicators found:"
        [[ -f "/Library/Managed Installs/ManagedInstallReport.plist" ]] && echo "  ✅ Managed Install Report exists"
        [[ -d "/Applications/Software Center.app" ]] && echo "  ✅ Software Center app installed"
        [[ -d "/Applications/Enterprise Software Center.app" ]] && echo "  ✅ Enterprise Software Center app installed"
        [[ -d "/Applications/Managed Software Center.app" ]] && echo "  ✅ Managed Software Center app installed"
        [[ -d "/Library/Managed Installs" ]] && echo "  ✅ Managed Installs directory exists"
        [[ -f "/usr/local/munki/managedsoftwareupdate" ]] && echo "  ✅ Munki software update tool found"
    else
        echo "❌ This is not a corporate machine or Enterprise Software Center is not installed"
    fi
}

show_status() {
    echo "📊 Software Center Manifest Status"
    echo "=================================="

    # Check machine type
    if is_corporate_machine; then
        echo "🏢 Machine type: Corporate"
    else
        echo "🏠 Machine type: Personal (Software Center management disabled)"
        return 0
    fi

    echo ""

    # Check system manifest
    if [[ -f "$MANIFEST_PATH" ]]; then
        SYSTEM_SIZE=$(stat -f%z "$MANIFEST_PATH")
        SYSTEM_DATE=$(stat -f%m "$MANIFEST_PATH" | xargs date -r)
        echo "📋 System manifest: ✅ Found ($SYSTEM_SIZE bytes, modified: $SYSTEM_DATE)"

        # Try to show brief content if readable
        if sudo -n test -r "$MANIFEST_PATH" 2>/dev/null; then
            echo "   Content preview available with sudo"
        fi
    else
        echo "📋 System manifest: ❌ Not found"
    fi

    # Check backup
    if [[ -f "$BACKUP_PATH" ]]; then
        BACKUP_SIZE=$(stat -f%z "$BACKUP_PATH")
        BACKUP_DATE=$(stat -f%m "$BACKUP_PATH" | xargs date -r)
        echo "💾 Backup manifest: ✅ Found ($BACKUP_SIZE bytes, modified: $BACKUP_DATE)"
    else
        echo "💾 Backup manifest: ❌ Not found"
    fi

    # Show managed installs directory
    if [[ -d "/Library/Managed Installs/manifests" ]]; then
        MANIFEST_COUNT=$(ls -1 "/Library/Managed Installs/manifests" | wc -l | xargs)
        echo "📁 Total manifests: $MANIFEST_COUNT files"
    fi
}

backup_manifest() {
    echo "📦 Backing up Software Center manifest..."
    echo "🔧 Management script version: 2.1.0"

    if ! is_corporate_machine; then
        echo "❌ Not a corporate machine, skipping backup"
        return 1
    fi

    if [[ ! -f "$MANIFEST_PATH" ]]; then
        echo "❌ No manifest found to backup"
        return 1
    fi

    # Create backup directory
    mkdir -p "$(dirname "$BACKUP_PATH")"

    echo "🔐 This operation requires administrator privileges..."
    sudo cp "$MANIFEST_PATH" "$BACKUP_PATH"
    sudo chown $(whoami):staff "$BACKUP_PATH"

    echo "✅ Backup completed successfully"

    # Show summary
    if [[ -f "$BACKUP_PATH" ]]; then
        echo "📊 Backup summary:"
        echo "   Size: $(stat -f%z "$BACKUP_PATH") bytes"
        echo "   Location: $BACKUP_PATH"
    fi
}

restore_manifest() {
    echo "🔄 Restoring Software Center manifest..."
    echo "🔧 Management script version: 2.1.0"

    if ! is_corporate_machine; then
        echo "❌ Not a corporate machine, skipping restore"
        return 1
    fi

    if [[ ! -f "$BACKUP_PATH" ]]; then
        echo "❌ No backup found to restore"
        return 1
    fi

    if [[ ! -d "/Library/Managed Installs/manifests" ]]; then
        echo "❌ Managed Installs directory not found"
        return 1
    fi

    # Create backup of current file if it exists
    if [[ -f "$MANIFEST_PATH" ]]; then
        echo "📋 Creating backup of current manifest..."
        sudo cp "$MANIFEST_PATH" "$MANIFEST_PATH.pre-restore.$(date +%Y%m%d-%H%M%S)"
    fi

    echo "🔐 This operation requires administrator privileges..."
    sudo cp "$BACKUP_PATH" "$MANIFEST_PATH"
    sudo chown root:admin "$MANIFEST_PATH"
    sudo chmod 644 "$MANIFEST_PATH"

    echo "✅ Restore completed successfully"
    echo ""
    echo "💡 Open Software Center to see restored applications"
}

# Main script logic
case "${1:-}" in
    backup)
        backup_manifest
        ;;
    restore)
        restore_manifest
        ;;
    status)
        show_status
        ;;
    check)
        check_corporate
        ;;
    *)
        usage
        ;;
esac