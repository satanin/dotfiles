# 🚀 Setup Completo en Equipo Nuevo

Guía paso a paso para configurar completamente un equipo nuevo con tus dotfiles.

## 🎯 Setup Rápido (Una Línea)

Si tu repositorio de dotfiles ya está en GitHub/GitLab público:

```bash
# ⚡ Setup automático completo
curl -fsSL https://raw.githubusercontent.com/TU-USERNAME/dotfiles/master/bootstrap.sh | bash
```

**⚠️ NOTA**: Necesitas actualizar la URL en el README.md con tu usuario real de GitHub/GitLab.

---

## 📋 Setup Manual (Paso a Paso)

### 1. **Preparación Inicial**

```bash
# Verificar que estás en macOS
uname -a

# Abrir Terminal (si no está abierto)
# Aplicaciones → Utilidades → Terminal
```

### 2. **Instalar Homebrew (si no está instalado)**

```bash
# Instalar Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Para Apple Silicon (M1/M2), añadir al PATH
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 3. **Clonar el Repositorio de Dotfiles**

```bash
# Instalar git si no está disponible
brew install git

# Clonar tu repositorio (ajusta la URL)
git clone https://github.com/TU-USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 4. **Instalar Herramientas Esenciales**

```bash
# Instalar chezmoi y bitwarden-cli
brew install chezmoi bitwarden-cli

# Inicializar chezmoi
chezmoi init --source="$HOME/.dotfiles"
```

### 5. **Instalar Paquetes de Homebrew**

```bash
# Instalar todos los paquetes del Brewfile
brew bundle install

# Verificar conflictos con Software Center
./check-brew-conflicts.sh check
```

### 6. **Configurar Bitwarden**

```bash
# Hacer login en Bitwarden
bw login

# Desbloquear la bóveda (guarda la session key)
bw unlock

# O en una línea (más conveniente)
export BW_SESSION=$(bw unlock --raw)
```

### 7. **Aplicar Configuración**

```bash
# Aplicar todos los dotfiles
chezmoi apply

# Verificar qué se aplicó
chezmoi status
```

---

## 🛠️ Setup Automático Completo

### Opción A: Script Bootstrap Existente

```bash
# Descargar y ejecutar tu bootstrap script
curl -fsSL https://raw.githubusercontent.com/TU-USERNAME/dotfiles/master/bootstrap.sh -o bootstrap.sh
chmod +x bootstrap.sh
./bootstrap.sh

# Luego completar manualmente
bw login
bw unlock
chezmoi apply
```

### Opción B: Una Línea Completa

```bash
# Todo en una línea (para copiar/pegar)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
brew install git chezmoi bitwarden-cli && \
git clone https://github.com/TU-USERNAME/dotfiles.git ~/.dotfiles && \
cd ~/.dotfiles && \
chezmoi init --source="$HOME/.dotfiles" && \
brew bundle install && \
echo "✅ Setup completo! Ahora ejecuta: bw login && bw unlock && chezmoi apply"
```

---

## 🔧 Scripts de Setup Automáticos (run_once_)

Una vez que ejecutes `chezmoi apply`, se ejecutarán automáticamente estos scripts:

### ✅ **Se Ejecutan Automáticamente:**

```bash
run_once_install-bitwarden.sh          # Instala Bitwarden CLI
run_once_install-brew.sh               # Instala paquetes Homebrew
run_once_install-claude-code.sh        # Instala Claude Code
run_once_install-oh-my-zsh.sh          # Instala Oh-My-Zsh
run_once_set-zsh-default.sh            # Configura Zsh como shell por defecto
run_once_setup-bitwarden.sh            # Verifica items de Bitwarden
run_once_setup-codeartifact.sh         # Configura AWS CodeArtifact
run_once_setup-ssh.sh                  # Configura permisos SSH
run_once_setup-pgp.sh                  # Configura claves PGP
run_once_backup-iterm-preferences.sh   # Backup de preferencias iTerm2
run_once_setup-iterm.sh                # Restaura preferencias iTerm2
run_once_backup-software-center-manifest.sh  # Backup Software Center (si aplica)
run_once_restore-software-center-manifest.sh # Restaura Software Center (si aplica)
run_once_setup-git-directories.sh      # Configura directorios de trabajo
```

---

## 🏢 Configuración Específica Corporativa

### Si es un equipo de Flywire:

```bash
# 1. Después del setup básico, añadir Cursor al Software Center
./add-cursor-to-software-center.sh

# 2. Verificar configuración AWS
./aws-login.sh

# 3. Configurar tokens de Claude
./setup-claude-tokens.sh
```

---

## ✅ Verificación del Setup

### Comprobar que todo funciona:

```bash
# 1. Verificar chezmoi
chezmoi status
chezmoi diff

# 2. Verificar Bitwarden
bw status

# 3. Verificar Software Center
./manage-software-center.sh status

# 4. Verificar conflictos
./check-brew-conflicts.sh check

# 5. Verificar shell
echo $SHELL  # Debería ser /bin/zsh

# 6. Verificar git
git config --global user.name
git config --global user.email

# 7. Verificar SSH
ssh-add -l
```

---

## 🚨 Troubleshooting Común

### Problema: Homebrew no en PATH
```bash
# Solución para Apple Silicon
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
source ~/.zprofile

# Solución para Intel
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
source ~/.zprofile
```

### Problema: Bitwarden no puede desbloquear
```bash
# Verificar login
bw login --check

# Re-login si es necesario
bw logout
bw login

# Desbloquear con session export
export BW_SESSION=$(bw unlock --raw)
```

### Problema: Permisos SSH
```bash
# Arreglar permisos manualmente
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub
chmod 644 ~/.ssh/config
```

### Problema: Templates de chezmoi fallan
```bash
# Verificar que Bitwarden esté desbloqueado
bw status

# Verificar template específico
chezmoi execute-template '{{ bitwarden "SSH Key - id_rsa" }}'

# Re-aplicar si es necesario
chezmoi apply --force
```

---

## 📋 Checklist Post-Setup

- [ ] ✅ Terminal (iTerm2) configurado con perfil personalizado
- [ ] ✅ Shell (Zsh + Oh-My-Zsh) con tema Powerlevel10k
- [ ] ✅ Git configurado con usuario y claves SSH
- [ ] ✅ AWS CLI configurado con CodeArtifact
- [ ] ✅ Claude Code instalado y configurado
- [ ] ✅ Bitwarden sincronizado con todas las claves
- [ ] ✅ Software Center con aplicaciones corporativas
- [ ] ✅ Homebrew con herramientas CLI
- [ ] ✅ Docker, VS Code, Cursor disponibles
- [ ] ✅ Tmux configurado
- [ ] ✅ Aliases y funciones personalizadas cargadas

---

## 🎉 ¡Setup Completado!

Tu equipo nuevo ahora tiene:

### 🛠️ **Herramientas CLI:**
- Todas las herramientas de desarrollo (git, tmux, awscli, etc.)
- Gestores de versiones (rbenv para Ruby)
- Utilidades de productividad (ack, ag, tree, autojump)

### 🖥️ **Aplicaciones GUI:**
- Claude Code, iTerm2 (via Homebrew)
- Cursor, VS Code, Docker (via Software Center)
- Chrome, Slack, Zoom (via Software Center)

### 🔐 **Configuración de Seguridad:**
- Claves SSH restauradas desde Bitwarden
- Claves PGP configuradas
- AWS y CodeArtifact configurados

### ⚡ **Productividad:**
- Shell personalizado con aliases
- Git configurado con tus preferencias
- Todos los dotfiles sincronizados

¡Tu entorno de desarrollo está listo para usar! 🚀