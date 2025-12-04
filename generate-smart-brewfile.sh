#!/bin/bash

# Generate smart Brewfile that avoids conflicts with Enterprise Software Center
set -e

BREWFILE="$HOME/.dotfiles/Brewfile"
BREWFILE_BASE="$HOME/.dotfiles/Brewfile.base"
SOFTWARE_CENTER_APPS_FILE="$HOME/.dotfiles/.software-center-apps"

echo "🍺 Generating smart Brewfile..."

# Check if this is a corporate machine
is_corporate_machine() {
    [[ -f "/Library/Managed Installs/ManagedInstallReport.plist" ]] || \
    [[ -d "/Applications/Enterprise Software Center.app" ]] || \
    [[ -d "/Library/Managed Installs" ]] || \
    [[ -f "/usr/local/munki/managedsoftwareupdate" ]]
}

# Function to extract managed applications from all manifests
get_software_center_apps() {
    local apps_file="$1"
    > "$apps_file"  # Clear the file

    if ! is_corporate_machine; then
        echo "# No corporate applications (personal machine)" > "$apps_file"
        return 0
    fi

    echo "🔍 Scanning Software Center manifests..."

    # Check if we can read the manifests directory
    if [[ ! -d "/Library/Managed Installs/manifests" ]]; then
        echo "⚠️  Cannot access Software Center manifests"
        echo "# Cannot access manifests directory" > "$apps_file"
        return 1
    fi

    echo "# Software Center managed applications" > "$apps_file"
    echo "# Generated on $(date)" >> "$apps_file"
    echo "" >> "$apps_file"

    local found_apps=0

    # Scan all manifest files
    for manifest in /Library/Managed Installs/manifests/*; do
        [[ -f "$manifest" ]] || continue

        local manifest_name=$(basename "$manifest")
        echo "  📋 Checking $manifest_name..."

        # Try to extract managed_installs using different methods
        if command -v plutil >/dev/null 2>&1; then
            # Method 1: Use plutil to extract managed_installs
            if sudo plutil -extract "managed_installs" xml1 "$manifest" 2>/dev/null | grep -o '<string>[^<]*</string>' | sed 's/<string>//g; s/<\/string>//g' >> "$apps_file.tmp" 2>/dev/null; then
                if [[ -s "$apps_file.tmp" ]]; then
                    echo "# From $manifest_name:" >> "$apps_file"
                    cat "$apps_file.tmp" | sed 's/^/# - /' >> "$apps_file"
                    echo "" >> "$apps_file"
                    found_apps=$((found_apps + $(wc -l < "$apps_file.tmp")))
                fi
                rm -f "$apps_file.tmp"
            fi
        fi

        # Method 2: Try to read as text and extract app names (fallback)
        if sudo cat "$manifest" 2>/dev/null | grep -i "\.app\|google\|microsoft\|adobe\|slack\|zoom\|docker" | head -10 >> "$apps_file.tmp" 2>/dev/null; then
            if [[ -s "$apps_file.tmp" ]] && [[ $found_apps -eq 0 ]]; then
                echo "# Potential apps from $manifest_name (text scan):" >> "$apps_file"
                cat "$apps_file.tmp" | sed 's/^/# /' >> "$apps_file"
                echo "" >> "$apps_file"
            fi
            rm -f "$apps_file.tmp"
        fi
    done

    echo "📊 Found references to $found_apps managed applications"
    echo "# Total managed applications found: $found_apps" >> "$apps_file"
}

# Known mappings between Software Center apps and Homebrew packages
get_known_conflicts() {
    cat << 'EOF'
# Known conflicts between Software Center and Homebrew
# Format: software_center_name:homebrew_package

# Browsers
Google Chrome:google-chrome
Firefox:firefox
Microsoft Edge:microsoft-edge

# Development Tools
Docker:docker
Visual Studio Code:visual-studio-code
Postman:postman
Slack:slack
Zoom:zoom

# Productivity
Microsoft Office:microsoft-office
Adobe Creative Suite:adobe-creative-suite
Notion:notion
1Password:1password

# System Tools
CleanMyMac:cleanmymac
Malwarebytes:malwarebytes-for-mac

EOF
}

# Create base Brewfile with all packages
create_base_brewfile() {
    cat << 'EOF' > "$BREWFILE_BASE"
# Base Brewfile - All packages we want to install
# This file lists all packages without conflicts consideration

# Command line tools
brew 'ack'
brew 'zsh-completion'
brew 'the_silver_searcher'
brew 'autojump'
brew 'tree'
brew 'awscli'
brew 'openconnect'

# Development tools
brew 'rbenv'
brew 'ruby-build'
brew 'git'
brew 'tmux'

# Security and dotfiles
brew 'bitwarden'
brew 'bitwarden-cli'
brew 'chezmoi'
brew 'gnupg'

# Applications
cask 'claude-code'
cask 'iterm2'

# Optional applications (might conflict with Software Center)
cask 'google-chrome'
cask 'visual-studio-code'
cask 'docker'
cask 'slack'
cask 'postman'
cask '1password'

EOF
}

# Generate final Brewfile based on conflicts
generate_final_brewfile() {
    echo "📝 Generating final Brewfile..."

    # Create header
    cat << EOF > "$BREWFILE"
# Smart Brewfile - Generated automatically
# Avoids conflicts with Enterprise Software Center
# Generated on $(date)
#
# Machine type: $(is_corporate_machine && echo "Corporate" || echo "Personal")

EOF

    if is_corporate_machine; then
        cat << 'EOF' >> "$BREWFILE"
# Note: Some applications may be managed by Enterprise Software Center
# Check Software Center before installing duplicates

EOF
    fi

    # Copy base brewfile content, excluding known conflicts if on corporate machine
    if is_corporate_machine && [[ -f "$SOFTWARE_CENTER_APPS_FILE" ]]; then
        echo "🔍 Filtering out potential Software Center conflicts..."

        # For now, copy everything but add warnings
        cat "$BREWFILE_BASE" >> "$BREWFILE"

        echo "" >> "$BREWFILE"
        echo "# Software Center Information:" >> "$BREWFILE"
        echo "# Check the following file for managed applications:" >> "$BREWFILE"
        echo "# $SOFTWARE_CENTER_APPS_FILE" >> "$BREWFILE"

    else
        # Personal machine or no Software Center, include everything
        cat "$BREWFILE_BASE" >> "$BREWFILE"
    fi

    echo "✅ Generated $BREWFILE"
}

# Main execution
main() {
    echo "🏢 Machine type: $(is_corporate_machine && echo "Corporate" || echo "Personal")"

    # Create base Brewfile template
    create_base_brewfile

    # Get Software Center apps list
    get_software_center_apps "$SOFTWARE_CENTER_APPS_FILE"

    # Generate final Brewfile
    generate_final_brewfile

    echo ""
    echo "📋 Summary:"
    echo "  • Base Brewfile: $BREWFILE_BASE"
    echo "  • Software Center apps: $SOFTWARE_CENTER_APPS_FILE"
    echo "  • Final Brewfile: $BREWFILE"
    echo ""

    if is_corporate_machine; then
        echo "💡 Corporate machine detected:"
        echo "  • Check Enterprise Software Center before installing apps"
        echo "  • Review $SOFTWARE_CENTER_APPS_FILE for managed applications"
        echo "  • Some cask applications may already be managed by Software Center"
    else
        echo "💡 Personal machine detected:"
        echo "  • All applications will be installed via Homebrew"
        echo "  • No Software Center conflicts to consider"
    fi

    echo ""
    echo "🚀 Next steps:"
    echo "  • Review the generated Brewfile"
    echo "  • Run 'brew bundle install' to install packages"
    if is_corporate_machine; then
        echo "  • Check Software Center for any duplicate installations"
    fi
}

# Show usage if requested
if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    echo "Usage: $0 [--help]"
    echo ""
    echo "Generates a smart Brewfile that avoids conflicts with Enterprise Software Center"
    echo ""
    echo "Files generated:"
    echo "  • Brewfile.base - Template with all desired packages"
    echo "  • .software-center-apps - List of Software Center managed apps"
    echo "  • Brewfile - Final smart Brewfile"
    exit 0
fi

main "$@"