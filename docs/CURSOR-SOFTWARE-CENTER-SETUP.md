# Adding Cursor Editor to Flywire Software Center

This document explains how to add Cursor editor to your Flywire Software Center manifest using the automated script.

## Quick Start

```bash
# 1. Run the automated script
~/.dotfiles/add-cursor-to-software-center.sh

# 2. Open Software Center and install Cursor
open -a "Software Center"
# or
open -a "Enterprise Software Center"
```

## What This Does

The script will:
1. 🔍 **Check** if you're on a corporate machine with Software Center
2. 📦 **Backup** your current manifest to `~/.dotfiles/private_Library/Managed Installs/manifests/`
3. ➕ **Add** 'cursor' to the managed_installs array in your manifest
4. ✅ **Apply** changes safely with proper permissions

## Manual Process (if needed)

If the automated script doesn't work, here's the manual process:

### Step 1: Check Current Manifest
```bash
# Check your current Software Center status
~/.dotfiles/manage-software-center.sh status

# Backup current manifest
~/.dotfiles/manage-software-center.sh backup
```

### Step 2: Edit Manifest Manually
```bash
# View current manifest (requires sudo)
sudo cat /Library/Managed\ Installs/manifests/SelfServeManifest

# Edit the manifest
sudo nano /Library/Managed\ Installs/manifests/SelfServeManifest
```

Add `cursor` to the `managed_installs` array. The file should look like:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>managed_installs</key>
    <array>
        <string>cursor</string>
        <!-- other applications -->
    </array>
</dict>
</plist>
```

### Step 3: Apply Changes
```bash
# Set proper permissions
sudo chown root:admin /Library/Managed\ Installs/manifests/SelfServeManifest
sudo chmod 644 /Library/Managed\ Installs/manifests/SelfServeManifest
```

## After Adding Cursor

### Open Software Center
1. Open **Software Center** or **Enterprise Software Center**
2. Look for **Cursor** in the available applications list
3. Click **Install** next to Cursor

### If Cursor Doesn't Appear
Try these alternatives in the manifest:
- `cursor-editor`
- `CursorEditor`
- `cursor-ide`
- `Cursor Editor`

Contact your IT team to confirm the exact package name used in your organization.

### Refresh Software Center
If you don't see Cursor immediately:
- Press `⌘+R` to refresh Software Center
- Wait a few minutes for the manifest to sync
- Quit and reopen Software Center

## Conflict Management

### Homebrew Integration
The Brewfile has been updated to:
- ✅ **Comment out** `cursor` cask to prevent Homebrew conflicts
- ✅ **Add note** that Cursor should come from Software Center
- ✅ **Update conflict checker** to detect Cursor conflicts

### Check for Conflicts
```bash
# Check if Cursor is installed via both sources
~/.dotfiles/check-brew-conflicts.sh check

# List all installed applications
~/.dotfiles/check-brew-conflicts.sh list
```

## Troubleshooting

### Permission Denied
```bash
# Make sure you have admin privileges
sudo -v

# Check if script is executable
chmod +x ~/.dotfiles/add-cursor-to-software-center.sh
```

### Manifest Not Found
```bash
# Check if you're on a corporate machine
~/.dotfiles/manage-software-center.sh check

# Look for Software Center app
ls -la /Applications/ | grep -i software
```

### Cursor Still Not Available
1. **Check with IT**: Verify Cursor is available in your organization's catalog
2. **Try alternative names**: Use the manual process with different package names
3. **Check logs**: Look at Software Center logs for errors
4. **Restore backup**: Use `~/.dotfiles/manage-software-center.sh restore` if needed

### Backup and Recovery
```bash
# Check backup status
~/.dotfiles/manage-software-center.sh status

# Restore from backup if something goes wrong
~/.dotfiles/manage-software-center.sh restore
```

## Files Modified

This setup modifies/creates these files:
- ✅ `~/.dotfiles/add-cursor-to-software-center.sh` - Main installation script
- ✅ `~/.dotfiles/Brewfile` - Updated to prevent conflicts
- ✅ `~/.dotfiles/check-brew-conflicts.sh` - Updated to detect Cursor
- ✅ `~/.dotfiles/private_Library/Managed Installs/manifests/SelfServeManifest` - Backup
- ⚠️  `/Library/Managed Installs/manifests/SelfServeManifest` - System manifest (modified)

## Security Notes

- ✅ **Always backed up** before making changes
- ✅ **Proper permissions** maintained on system files
- ✅ **No secrets committed** to git repository
- ✅ **Sudo required** only for system manifest access

---

## Need Help?

- **Check status**: `~/.dotfiles/manage-software-center.sh status`
- **View logs**: Check Console.app for "munki" or "Software Center" messages
- **Contact IT**: If Cursor package name is different in your organization
- **Restore**: Use the backup if anything goes wrong