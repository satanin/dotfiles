#!/bin/bash

# Configure user data for chezmoi templates
# This script runs once to set up personalized configuration

set -e

echo "🔧 Configurando información personal para chezmoi..."

# Check if we're in an interactive terminal
if [ ! -t 0 ]; then
    echo "⚠️  Ejecutándose en modo no interactivo, saltando configuración personalizada"
    echo "   Puedes configurar manualmente después con: chezmoi edit ~/.config/chezmoi/chezmoi.toml"
    exit 0
fi

# Check if chezmoi config exists and has user data
CONFIG_FILE="$HOME/.config/chezmoi/chezmoi.toml"
if [ -f "$CONFIG_FILE" ]; then
    # Check if name and email are already configured (not placeholders)
    if grep -q 'name = "Your Name"' "$CONFIG_FILE" || grep -q 'name = "yourusername"' "$CONFIG_FILE"; then
        echo "📝 Configuración personalizada requerida..."
        echo ""
        echo "Por favor introduce tu información personal para configurar git y otras herramientas:"
        echo ""

        # Prompt for user information with better UX
        while [ -z "$USER_NAME" ]; do
            echo -n "👤 Nombre completo: "
            read USER_NAME
            if [ -z "$USER_NAME" ]; then
                echo "❌ El nombre no puede estar vacío"
            fi
        done

        while [ -z "$USER_EMAIL" ]; do
            echo -n "📧 Email: "
            read USER_EMAIL
            if [ -z "$USER_EMAIL" ]; then
                echo "❌ El email no puede estar vacío"
            fi
        done

        while [ -z "$GITHUB_USER" ]; do
            echo -n "🐙 Usuario de GitHub: "
            read GITHUB_USER
            if [ -z "$GITHUB_USER" ]; then
                echo "❌ El usuario de GitHub no puede estar vacío"
            fi
        done

        # Update the configuration file
        if [ -n "$USER_NAME" ] && [ -n "$USER_EMAIL" ] && [ -n "$GITHUB_USER" ]; then
            # Create a backup
            cp "$CONFIG_FILE" "$CONFIG_FILE.backup"

            # Update the values
            sed -i.tmp "s/name = \"Your Name\"/name = \"$USER_NAME\"/g" "$CONFIG_FILE"
            sed -i.tmp "s/email = \"your.email@company.com\"/email = \"$USER_EMAIL\"/g" "$CONFIG_FILE"
            sed -i.tmp "s/github_user = \"yourusername\"/github_user = \"$GITHUB_USER\"/g" "$CONFIG_FILE"

            # Clean up temporary file
            rm -f "$CONFIG_FILE.tmp"

            echo "✅ Configuración actualizada correctamente"
            echo "📄 Backup guardado en: $CONFIG_FILE.backup"
        else
            echo "❌ Información incompleta. Por favor ejecuta 'chezmoi edit ~/.config/chezmoi/chezmoi.toml' para configurar manualmente."
        fi
    else
        echo "✅ Configuración personal ya establecida"
    fi
else
    echo "⚠️  Archivo de configuración no encontrado: $CONFIG_FILE"
    echo "   Chezmoi debería haberlo creado automáticamente."
fi