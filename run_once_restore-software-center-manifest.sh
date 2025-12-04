#!/bin/bash

# Restore Enterprise Software Center manifest on corporate machines
echo "🔄 Checking for Software Center manifest to restore..."

# Use the main management script to do the restore
if [[ -x "./manage-software-center.sh" ]]; then
    ./manage-software-center.sh restore
else
    echo "❌ Management script not found. Run from dotfiles directory."
    exit 1
fi