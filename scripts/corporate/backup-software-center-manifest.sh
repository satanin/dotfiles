#!/bin/bash

# Backup Enterprise Software Center manifest
echo "📦 Checking for Software Center manifest to backup..."

# Use the main management script to do the backup
if [[ -x "./manage-software-center.sh" ]]; then
    ./manage-software-center.sh backup
else
    echo "❌ Management script not found. Run from dotfiles directory."
    exit 1
fi