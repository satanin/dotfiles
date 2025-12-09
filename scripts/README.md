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
