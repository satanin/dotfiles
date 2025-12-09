#!/bin/bash

# Script de migración para organizar los scripts en carpetas
set -e

DOTFILES_DIR="$HOME/.dotfiles"
echo "🗂️  Organizando scripts en carpetas..."

cd "$DOTFILES_DIR"

# =====================================
# 1. SETUP/BOOTSTRAP SCRIPTS
# =====================================
echo "📦 Moviendo scripts de setup..."
mv bootstrap.sh scripts/setup/ 2>/dev/null || echo "  ⚠️  bootstrap.sh ya está en su lugar"

# Nota: run_once_ scripts deben quedarse en la raíz para chezmoi
# Pero creamos enlaces simbólicos para organización
echo "🔗 Creando enlaces para scripts run_once_ de setup..."
for script in run_once_install-bitwarden.sh run_once_install-brew.sh run_once_install-claude-code.sh run_once_install-oh-my-zsh.sh run_once_set-zsh-default.sh; do
    if [[ -f "$script" ]]; then
        cp "$script" "scripts/setup/${script#run_once_}"
        echo "  ✅ Copiado $script -> scripts/setup/"
    fi
done

# =====================================
# 2. SECURITY/KEYS SCRIPTS
# =====================================
echo "🔐 Moviendo scripts de seguridad..."
for script in setup-keys.sh run_once_backup-keys-to-bitwarden.sh run_once_setup-bitwarden.sh run_once_setup-ssh.sh run_once_setup-pgp.sh setup-claude-tokens.sh; do
    if [[ -f "$script" && "$script" != run_once_* ]]; then
        mv "$script" scripts/security/ 2>/dev/null && echo "  ✅ Movido $script"
    elif [[ -f "$script" ]]; then
        cp "$script" "scripts/security/${script#run_once_}"
        echo "  ✅ Copiado $script -> scripts/security/"
    fi
done

# =====================================
# 3. CORPORATE/SOFTWARE CENTER SCRIPTS
# =====================================
echo "🏢 Moviendo scripts corporativos..."
for script in manage-software-center.sh add-cursor-to-software-center.sh run_once_backup-software-center-manifest.sh run_once_restore-software-center-manifest.sh; do
    if [[ -f "$script" && "$script" != run_once_* ]]; then
        mv "$script" scripts/corporate/ 2>/dev/null && echo "  ✅ Movido $script"
    elif [[ -f "$script" ]]; then
        cp "$script" "scripts/corporate/${script#run_once_}"
        echo "  ✅ Copiado $script -> scripts/corporate/"
    fi
done

# =====================================
# 4. HOMEBREW SCRIPTS
# =====================================
echo "🍺 Moviendo scripts de Homebrew..."
for script in check-brew-conflicts.sh brew-app-manager.sh generate-smart-brewfile.sh; do
    if [[ -f "$script" ]]; then
        mv "$script" scripts/homebrew/ 2>/dev/null && echo "  ✅ Movido $script"
    fi
done

# =====================================
# 5. APPLICATIONS SCRIPTS
# =====================================
echo "🖥️  Moviendo scripts de aplicaciones..."
for script in manage-iterm-preferences.sh run_once_backup-iterm-preferences.sh run_once_setup-iterm.sh; do
    if [[ -f "$script" && "$script" != run_once_* ]]; then
        mv "$script" scripts/applications/ 2>/dev/null && echo "  ✅ Movido $script"
    elif [[ -f "$script" ]]; then
        cp "$script" "scripts/applications/${script#run_once_}"
        echo "  ✅ Copiado $script -> scripts/applications/"
    fi
done

# =====================================
# 6. AWS SCRIPTS
# =====================================
echo "☁️  Moviendo scripts de AWS..."
for script in aws-login.sh run_once_setup-codeartifact.sh; do
    if [[ -f "$script" && "$script" != run_once_* ]]; then
        mv "$script" scripts/aws/ 2>/dev/null && echo "  ✅ Movido $script"
    elif [[ -f "$script" ]]; then
        cp "$script" "scripts/aws/${script#run_once_}"
        echo "  ✅ Copiado $script -> scripts/aws/"
    fi
done

# =====================================
# 7. DEV SCRIPTS
# =====================================
echo "🛠️  Moviendo scripts de desarrollo..."
for script in run_once_setup-git-directories.sh; do
    if [[ -f "$script" ]]; then
        cp "$script" "scripts/dev/${script#run_once_}"
        echo "  ✅ Copiado $script -> scripts/dev/"
    fi
done

# =====================================
# 8. DOCUMENTACIÓN
# =====================================
echo "📚 Organizando documentación..."
for doc in CURSOR-SOFTWARE-CENTER-SETUP.md NUEVO-EQUIPO-SETUP.md SCRIPT-ORGANIZATION-PLAN.md SYSTEM-OVERVIEW.md; do
    if [[ -f "$doc" ]]; then
        mv "$doc" docs/ 2>/dev/null && echo "  ✅ Movido $doc"
    fi
done

# =====================================
# 9. CONFIGURACIONES
# =====================================
echo "⚙️  Organizando configuraciones..."
if [[ -f "iterm_profile.json" ]]; then
    mv iterm_profile.json config/ 2>/dev/null && echo "  ✅ Movido iterm_profile.json"
fi

# =====================================
# 10. CREAR SYMLINKS DE COMPATIBILIDAD
# =====================================
echo "🔗 Creando enlaces de compatibilidad..."

# Enlaces para scripts principales que pueden ser referenciados
create_symlink() {
    local target="$1"
    local link_name="$2"

    if [[ -f "$target" && ! -f "$link_name" ]]; then
        ln -sf "$target" "$link_name"
        echo "  🔗 $link_name -> $target"
    fi
}

# Enlaces más importantes
create_symlink "scripts/setup/bootstrap.sh" "bootstrap.sh"
create_symlink "scripts/security/setup-keys.sh" "setup-keys.sh"
create_symlink "scripts/corporate/manage-software-center.sh" "manage-software-center.sh"
create_symlink "scripts/homebrew/check-brew-conflicts.sh" "check-brew-conflicts.sh"
create_symlink "scripts/aws/aws-login.sh" "aws-login.sh"

# =====================================
# 11. HACER SCRIPTS EJECUTABLES
# =====================================
echo "🔧 Configurando permisos..."
find scripts/ -name "*.sh" -exec chmod +x {} \;

# =====================================
# 12. CREAR ÍNDICE DE SCRIPTS
# =====================================
echo "📋 Creando índice de scripts..."
cat > scripts/README.md << 'EOF'
# 🗂️ Scripts Organizados

## 📦 Setup (`scripts/setup/`)
- `bootstrap.sh` - Setup inicial completo para equipo nuevo
- `install-bitwarden.sh` - Instala Bitwarden CLI
- `install-brew.sh` - Instala paquetes Homebrew
- `install-claude-code.sh` - Instala Claude Code
- `install-oh-my-zsh.sh` - Instala Oh-My-Zsh
- `set-zsh-default.sh` - Configura Zsh como shell por defecto

## 🔐 Seguridad (`scripts/security/`)
- `setup-keys.sh` - Setup completo de claves SSH/PGP
- `backup-keys-to-bitwarden.sh` - Backup de claves a Bitwarden
- `setup-bitwarden.sh` - Configura items de Bitwarden
- `setup-ssh.sh` - Configura claves y permisos SSH
- `setup-pgp.sh` - Configura claves PGP
- `setup-claude-tokens.sh` - Configura tokens de API Claude

## 🏢 Corporativo (`scripts/corporate/`)
- `manage-software-center.sh` - Gestión Enterprise Software Center
- `add-cursor-to-software-center.sh` - Añade Cursor al manifest
- `backup-software-center-manifest.sh` - Backup del manifest
- `restore-software-center-manifest.sh` - Restore del manifest

## 🍺 Homebrew (`scripts/homebrew/`)
- `check-brew-conflicts.sh` - Verifica conflictos con Software Center
- `brew-app-manager.sh` - Gestión avanzada de aplicaciones
- `generate-smart-brewfile.sh` - Genera Brewfile inteligente

## 🖥️ Aplicaciones (`scripts/applications/`)
- `manage-iterm-preferences.sh` - Gestión completa iTerm2
- `backup-iterm-preferences.sh` - Backup preferencias iTerm2
- `setup-iterm.sh` - Restaura configuración iTerm2

## ☁️ AWS (`scripts/aws/`)
- `aws-login.sh` - Login AWS ECR/CodeArtifact
- `setup-codeartifact.sh` - Configura AWS CodeArtifact

## 🛠️ Desarrollo (`scripts/dev/`)
- `setup-git-directories.sh` - Configura directorios de trabajo

## 🔗 Enlaces de Compatibilidad

Para mantener compatibilidad con documentación existente, estos scripts principales están disponibles en la raíz via symlinks:
- `bootstrap.sh` -> `scripts/setup/bootstrap.sh`
- `setup-keys.sh` -> `scripts/security/setup-keys.sh`
- `manage-software-center.sh` -> `scripts/corporate/manage-software-center.sh`
- `check-brew-conflicts.sh` -> `scripts/homebrew/check-brew-conflicts.sh`
- `aws-login.sh` -> `scripts/aws/aws-login.sh`

## 📋 Scripts run_once_

Los scripts `run_once_*` permanecen en la raíz del repositorio porque chezmoi los ejecuta automáticamente desde ahí. Los archivos en `scripts/` son copias para referencia y organización.
EOF

echo ""
echo "✅ Migración completada!"
echo ""
echo "📊 Resumen:"
echo "   📁 scripts/setup/        - Scripts de instalación inicial"
echo "   📁 scripts/security/     - Gestión de claves y seguridad"
echo "   📁 scripts/corporate/    - Software Center corporativo"
echo "   📁 scripts/homebrew/     - Gestión Homebrew"
echo "   📁 scripts/applications/ - Configuración aplicaciones"
echo "   📁 scripts/aws/          - AWS y cloud"
echo "   📁 scripts/dev/          - Herramientas desarrollo"
echo "   📁 docs/                 - Documentación"
echo "   📁 config/               - Configuraciones"
echo ""
echo "🔗 Enlaces de compatibilidad creados para scripts principales"
echo "📋 Ver scripts/README.md para el índice completo"
echo ""
echo "⚠️  IMPORTANTE: Los scripts run_once_* siguen en la raíz para chezmoi"