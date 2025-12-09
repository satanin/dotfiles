#!/bin/bash

# Check for potential conflicts between Homebrew and Enterprise Software Center
set -e

echo "🔍 Checking for Homebrew vs Software Center conflicts..."

# Check if this is a corporate machine
is_corporate_machine() {
    [[ -f "/Library/Managed Installs/ManagedInstallReport.plist" ]] || \
    [[ -d "/Applications/Software Center.app" ]] || \
    [[ -d "/Applications/Enterprise Software Center.app" ]] || \
    [[ -d "/Applications/Managed Software Center.app" ]] || \
    [[ -d "/Library/Managed Installs" ]] || \
    [[ -f "/usr/local/munki/managedsoftwareupdate" ]]
}

# Get list of applications that might conflict
get_potential_conflicts() {
    local conflicts=(
        # Browsers
        "google-chrome:Google Chrome"
        "firefox:Firefox"
        "microsoft-edge:Microsoft Edge"

        # Development
        "visual-studio-code:Visual Studio Code"
        "cursor:Cursor"
        "docker:Docker"
        "postman:Postman"

        # Communication
        "slack:Slack"
        "zoom:Zoom"
        "microsoft-teams:Microsoft Teams"

        # Productivity
        "1password:1Password"
        "notion:Notion"

        # System Tools
        "cleanmymac:CleanMyMac"
        "malwarebytes-for-mac:Malwarebytes"
    )

    printf '%s\n' "${conflicts[@]}"
}

# Check if an application is installed via Software Center
is_managed_by_software_center() {
    local app_name="$1"

    # Check in Applications folder with Software Center metadata
    if [[ -d "/Applications/$app_name.app" ]]; then
        # Check if it has managed install metadata
        if sudo find "/Applications/$app_name.app" -name "*munki*" -o -name "*managed*" 2>/dev/null | head -1 | grep -q .; then
            return 0
        fi

        # Check if it's listed in managed install reports
        if sudo find "/Library/Managed Installs" -name "*.plist" -exec grep -l "$app_name" {} \; 2>/dev/null | head -1 | grep -q .; then
            return 0
        fi
    fi

    return 1
}

# Main conflict check
check_conflicts() {
    if ! is_corporate_machine; then
        echo "ℹ️  Personal machine detected - no Software Center conflicts possible"
        return 0
    fi

    echo "🏢 Corporate machine detected - checking for conflicts..."
    echo ""

    local found_conflicts=false
    local conflicts_file="/tmp/brew-conflicts.txt"
    > "$conflicts_file"

    echo "🔍 Scanning for potential conflicts..."

    while IFS=':' read -r brew_name app_name; do
        echo "  Checking $app_name..."

        if is_managed_by_software_center "$app_name"; then
            echo "⚠️  CONFLICT: $app_name is managed by Software Center"
            echo "   Homebrew package: $brew_name"
            echo "   Recommendation: Remove from Brewfile or uninstall from Software Center"
            echo "$brew_name:$app_name" >> "$conflicts_file"
            found_conflicts=true
        else
            echo "✅ $app_name - No conflict detected"
        fi
    done < <(get_potential_conflicts)

    echo ""

    if [[ "$found_conflicts" == "true" ]]; then
        echo "⚠️  CONFLICTS DETECTED!"
        echo ""
        echo "📋 Summary of conflicts:"
        while IFS=':' read -r brew_name app_name; do
            echo "  • $app_name (brew: $brew_name)"
        done < "$conflicts_file"

        echo ""
        echo "🔧 Recommended actions:"
        echo "  1. Check Enterprise Software Center for these applications"
        echo "  2. Remove conflicting cask entries from Brewfile"
        echo "  3. Or uninstall from Software Center if you prefer Homebrew"
        echo "  4. Run this check again after making changes"

        return 1
    else
        echo "✅ No conflicts detected!"
        echo "   Safe to proceed with 'brew bundle install'"
        return 0
    fi
}

# Show currently installed applications
show_installed_apps() {
    echo "📱 Currently installed applications:"
    echo ""

    if [[ -d "/Applications" ]]; then
        find /Applications -name "*.app" -maxdepth 1 | sort | while read app; do
            local app_name=$(basename "$app" .app)
            local managed_status=""

            if is_corporate_machine && is_managed_by_software_center "$app_name"; then
                managed_status=" (Software Center)"
            fi

            echo "  • $app_name$managed_status"
        done
    fi
}

# Usage function
usage() {
    echo "Usage: $0 [check|list|help]"
    echo ""
    echo "Commands:"
    echo "  check  - Check for conflicts (default)"
    echo "  list   - List all installed applications"
    echo "  help   - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Check for conflicts"
    echo "  $0 check        # Same as above"
    echo "  $0 list         # List installed apps"
}

# Main execution
case "${1:-check}" in
    check)
        check_conflicts
        ;;
    list)
        show_installed_apps
        ;;
    help|--help|-h)
        usage
        ;;
    *)
        echo "❌ Unknown command: $1"
        echo ""
        usage
        exit 1
        ;;
esac