#!/bin/bash

# Homebrew Application Manager - Safely enable/disable apps in Brewfile
set -e

BREWFILE="$HOME/.dotfiles/Brewfile"

echo "🍺 Homebrew Application Manager"

# Show usage
usage() {
    echo "Usage: $0 {list|enable|disable|check} [app-name]"
    echo ""
    echo "Commands:"
    echo "  list           - List all commented (disabled) applications"
    echo "  enable <app>   - Enable an application after checking for conflicts"
    echo "  disable <app>  - Disable (comment) an application"
    echo "  check          - Run full conflict check"
    echo ""
    echo "Examples:"
    echo "  $0 list                    # Show disabled apps"
    echo "  $0 enable google-chrome    # Enable Chrome if no conflict"
    echo "  $0 disable docker          # Disable Docker"
    echo "  $0 check                   # Check all conflicts"
    exit 1
}

# List commented applications
list_disabled() {
    echo "📋 Disabled applications in Brewfile:"
    echo ""

    if [[ ! -f "$BREWFILE" ]]; then
        echo "❌ Brewfile not found at $BREWFILE"
        return 1
    fi

    grep "^# cask" "$BREWFILE" | sed "s/^# cask '/  • /" | sed "s/'$//" | sort

    echo ""
    echo "💡 To enable an application: $0 enable <app-name>"
    echo "💡 Always check for conflicts first: $0 check"
}

# Enable an application
enable_app() {
    local app_name="$1"

    if [[ -z "$app_name" ]]; then
        echo "❌ Please specify an application name"
        echo "💡 Use '$0 list' to see available applications"
        return 1
    fi

    echo "🔓 Enabling $app_name..."

    # Check if app exists as commented line
    if ! grep -q "^# cask '$app_name'" "$BREWFILE"; then
        echo "❌ Application '$app_name' not found in disabled applications"
        echo ""
        echo "📋 Available applications:"
        list_disabled
        return 1
    fi

    # Run conflict check first
    echo "🔍 Checking for conflicts..."
    if [[ -f "$HOME/.dotfiles/check-brew-conflicts.sh" ]]; then
        cd "$HOME/.dotfiles"

        # Temporarily enable the app to test conflicts
        sed "s/^# cask '$app_name'/cask '$app_name'/" "$BREWFILE" > "$BREWFILE.tmp"

        # Test conflicts (this will check if the app is already managed)
        local conflict_result=0
        ./check-brew-conflicts.sh check > /dev/null 2>&1 || conflict_result=$?

        # Restore original file
        mv "$BREWFILE.tmp" "$BREWFILE"

        if [[ $conflict_result -ne 0 ]]; then
            echo "⚠️  CONFLICT DETECTED!"
            echo "   $app_name appears to be managed by Software Center"
            echo ""
            echo "🔧 Options:"
            echo "  1. Use the version from Software Center (recommended)"
            echo "  2. Uninstall from Software Center first, then enable in Homebrew"
            echo "  3. Keep both (not recommended - may cause issues)"
            echo ""
            read -p "Do you want to enable anyway? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "❌ Cancelled by user"
                return 1
            fi
        fi
    fi

    # Enable the application
    sed -i '' "s/^# cask '$app_name'/cask '$app_name'/" "$BREWFILE"

    if grep -q "^cask '$app_name'" "$BREWFILE"; then
        echo "✅ Enabled $app_name in Brewfile"
        echo ""
        echo "🚀 Next steps:"
        echo "   1. Run 'brew bundle install' to install the application"
        echo "   2. Or run the full setup: './run_once_install-brew.sh'"
    else
        echo "❌ Failed to enable $app_name"
        return 1
    fi
}

# Disable an application
disable_app() {
    local app_name="$1"

    if [[ -z "$app_name" ]]; then
        echo "❌ Please specify an application name"
        return 1
    fi

    echo "🔒 Disabling $app_name..."

    # Check if app exists as active line
    if ! grep -q "^cask '$app_name'" "$BREWFILE"; then
        echo "❌ Application '$app_name' not found in active applications"
        echo ""
        echo "📋 Active applications:"
        grep "^cask" "$BREWFILE" | sed "s/^cask '/  • /" | sed "s/'$//"
        return 1
    fi

    # Disable the application
    sed -i '' "s/^cask '$app_name'/# cask '$app_name'/" "$BREWFILE"

    if grep -q "^# cask '$app_name'" "$BREWFILE"; then
        echo "✅ Disabled $app_name in Brewfile"
        echo ""
        echo "💡 The application is now commented out and won't be installed"
        echo "💡 If already installed via Homebrew, you can uninstall with:"
        echo "   brew uninstall --cask $app_name"
    else
        echo "❌ Failed to disable $app_name"
        return 1
    fi
}

# Run conflict check
run_check() {
    if [[ -f "$HOME/.dotfiles/check-brew-conflicts.sh" ]]; then
        cd "$HOME/.dotfiles"
        ./check-brew-conflicts.sh check
    else
        echo "❌ Conflict checker not found"
        return 1
    fi
}

# Main execution
case "${1:-}" in
    list)
        list_disabled
        ;;
    enable)
        enable_app "$2"
        ;;
    disable)
        disable_app "$2"
        ;;
    check)
        run_check
        ;;
    help|--help|-h)
        usage
        ;;
    *)
        if [[ -n "$1" ]]; then
            echo "❌ Unknown command: $1"
            echo ""
        fi
        usage
        ;;
esac