#!/bin/bash

# Add Cursor Editor to Flywire Software Center Manifest
set -e

MANIFEST_PATH="/Library/Managed Installs/manifests/SelfServeManifest"
BACKUP_PATH="$HOME/.dotfiles/private_Library/Managed Installs/manifests/SelfServeManifest"
TEMP_MANIFEST="/tmp/SelfServeManifest.tmp"

echo "🖥️  Adding Cursor Editor to Software Center Manifest"
echo "=================================================="

# Check if this is a corporate machine
if ! [[ -f "/Library/Managed Installs/ManagedInstallReport.plist" ]] && \
   ! [[ -d "/Applications/Software Center.app" ]] && \
   ! [[ -d "/Applications/Enterprise Software Center.app" ]]; then
    echo "❌ This doesn't appear to be a corporate machine with Software Center"
    exit 1
fi

# Check if manifest exists
if [[ ! -f "$MANIFEST_PATH" ]]; then
    echo "❌ Software Center manifest not found at $MANIFEST_PATH"
    exit 1
fi

echo "📋 Current manifest found"

# Create backup first
echo "📦 Creating backup..."
mkdir -p "$(dirname "$BACKUP_PATH")"
sudo cp "$MANIFEST_PATH" "$BACKUP_PATH"
sudo chown $(whoami):staff "$BACKUP_PATH"
echo "✅ Backup created at: $BACKUP_PATH"

# Read current manifest
echo "📖 Reading current manifest..."
sudo cp "$MANIFEST_PATH" "$TEMP_MANIFEST"
sudo chown $(whoami):staff "$TEMP_MANIFEST"

# Show current content
echo ""
echo "📄 Current manifest content:"
echo "============================"
cat "$TEMP_MANIFEST"
echo ""

# Check if Cursor is already in the manifest
if grep -q "cursor" "$TEMP_MANIFEST" 2>/dev/null; then
    echo "ℹ️  Cursor appears to already be in the manifest"
    read -p "Do you want to continue anyway? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "❌ Aborted"
        rm -f "$TEMP_MANIFEST"
        exit 0
    fi
fi

# Parse current manifest and add Cursor
echo "✏️  Adding Cursor to manifest..."

# Create a Python script to safely modify the plist
cat > /tmp/add_cursor.py << 'EOF'
#!/usr/bin/env python3
import plistlib
import sys

def add_cursor_to_manifest(manifest_path):
    try:
        # Read the plist file
        with open(manifest_path, 'rb') as f:
            manifest = plistlib.load(f)

        # Ensure managed_installs array exists
        if 'managed_installs' not in manifest:
            manifest['managed_installs'] = []

        # Check if Cursor is already in the list
        managed_installs = manifest['managed_installs']

        # Common names for Cursor in Software Center
        cursor_names = ['cursor', 'Cursor', 'cursor-editor', 'CursorEditor']

        # Check if any variant of Cursor is already installed
        cursor_exists = any(item for item in managed_installs if any(cursor_name in str(item) for cursor_name in cursor_names))

        if not cursor_exists:
            # Add Cursor to managed installs
            # Try the most common name first
            managed_installs.append('cursor')
            print(f"✅ Added 'cursor' to managed_installs")
        else:
            print("ℹ️  Cursor already exists in manifest")

        # Write back to file
        with open(manifest_path, 'wb') as f:
            plistlib.dump(manifest, f)

        print(f"📝 Updated manifest saved to {manifest_path}")
        return True

    except Exception as e:
        print(f"❌ Error processing manifest: {e}")
        return False

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 add_cursor.py <manifest_path>")
        sys.exit(1)

    manifest_path = sys.argv[1]
    success = add_cursor_to_manifest(manifest_path)
    sys.exit(0 if success else 1)
EOF

# Run the Python script to modify the manifest
python3 /tmp/add_cursor.py "$TEMP_MANIFEST"

# Show the updated content
echo ""
echo "📄 Updated manifest content:"
echo "============================"
cat "$TEMP_MANIFEST"
echo ""

# Ask for confirmation
read -p "👆 Does this look correct? Apply changes? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "❌ Changes not applied"
    rm -f "$TEMP_MANIFEST"
    rm -f /tmp/add_cursor.py
    exit 0
fi

# Apply changes
echo "🔐 Applying changes (requires sudo)..."
sudo cp "$TEMP_MANIFEST" "$MANIFEST_PATH"
sudo chown root:admin "$MANIFEST_PATH"
sudo chmod 644 "$MANIFEST_PATH"

# Cleanup
rm -f "$TEMP_MANIFEST"
rm -f /tmp/add_cursor.py

echo "✅ Cursor has been added to the Software Center manifest!"
echo ""
echo "📱 Next steps:"
echo "1. Open Software Center application"
echo "2. Look for 'Cursor' in the available applications"
echo "3. Install Cursor through Software Center"
echo ""
echo "💡 If Cursor doesn't appear, try:"
echo "   - Refreshing Software Center (⌘+R)"
echo "   - Checking with IT about the exact package name"
echo "   - Looking for variations like 'cursor-editor' or 'CursorEditor'"