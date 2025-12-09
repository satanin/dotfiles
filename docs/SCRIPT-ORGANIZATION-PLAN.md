# Plan de Organización de Scripts

## 📋 Análisis de Scripts Actuales (25 archivos .sh)

### 🗂️ **Categorización Propuesta:**

#### 📦 **1. Setup/Bootstrap (scripts/setup/)**
- `bootstrap.sh` - ✅ **NECESARIO** - Setup inicial completo
- `run_once_install-bitwarden.sh` - ✅ **NECESARIO** - Instala Bitwarden CLI
- `run_once_install-brew.sh` - ✅ **NECESARIO** - Instala paquetes Homebrew
- `run_once_install-claude-code.sh` - ✅ **NECESARIO** - Instala Claude Code
- `run_once_install-oh-my-zsh.sh` - ✅ **NECESARIO** - Instala Oh-My-Zsh
- `run_once_set-zsh-default.sh` - ✅ **NECESARIO** - Configura Zsh como default

#### 🔐 **2. Seguridad/Claves (scripts/security/)**
- `setup-keys.sh` - ✅ **NECESARIO** - Setup completo de claves
- `run_once_backup-keys-to-bitwarden.sh` - ✅ **NECESARIO** - Backup de claves
- `run_once_setup-bitwarden.sh` - ✅ **NECESARIO** - Configura Bitwarden
- `run_once_setup-ssh.sh` - ✅ **NECESARIO** - Configura SSH
- `run_once_setup-pgp.sh` - ✅ **NECESARIO** - Configura PGP
- `setup-claude-tokens.sh` - ✅ **NECESARIO** - Configura tokens Claude

#### 🏢 **3. Corporativo/Software Center (scripts/corporate/)**
- `manage-software-center.sh` - ✅ **NECESARIO** - Gestión Software Center
- `add-cursor-to-software-center.sh` - ✅ **NECESARIO** - Añade Cursor al manifest
- `run_once_backup-software-center-manifest.sh` - ✅ **NECESARIO** - Backup manifest
- `run_once_restore-software-center-manifest.sh` - ✅ **NECESARIO** - Restore manifest

#### 🍺 **4. Homebrew (scripts/homebrew/)**
- `check-brew-conflicts.sh` - ✅ **NECESARIO** - Verifica conflictos
- `brew-app-manager.sh` - ❓ **REVISAR** - Gestión avanzada Brewfile
- `generate-smart-brewfile.sh` - ❓ **REVISAR** - Genera Brewfile inteligente

#### 🖥️ **5. Aplicaciones (scripts/applications/)**
- `manage-iterm-preferences.sh` - ✅ **NECESARIO** - Gestión iTerm2
- `run_once_backup-iterm-preferences.sh` - ✅ **NECESARIO** - Backup iTerm2
- `run_once_setup-iterm.sh` - ✅ **NECESARIO** - Setup iTerm2

#### ☁️ **6. AWS/Cloud (scripts/aws/)**
- `aws-login.sh` - ✅ **NECESARIO** - Login AWS/CodeArtifact
- `run_once_setup-codeartifact.sh` - ✅ **NECESARIO** - Setup CodeArtifact

#### 🛠️ **7. Desarrollo (scripts/dev/)**
- `run_once_setup-git-directories.sh` - ✅ **NECESARIO** - Setup directorios git

---

## 🗂️ **Nueva Estructura Propuesta:**

```
~/.dotfiles/
├── scripts/
│   ├── setup/           # Scripts de instalación inicial
│   ├── security/        # Gestión de claves y seguridad
│   ├── corporate/       # Software Center y políticas corporativas
│   ├── homebrew/        # Gestión de Homebrew
│   ├── applications/    # Configuración de aplicaciones
│   ├── aws/            # AWS y servicios cloud
│   └── dev/            # Herramientas de desarrollo
├── docs/               # Documentación
├── config/             # Archivos de configuración
└── [archivos dotfiles] # dot_*, private_dot_*, run_once_*
```

---

## 🔍 **Scripts que necesitan revisión:**

### ❓ **brew-app-manager.sh**
- **Función**: Gestión avanzada de aplicaciones en Brewfile
- **Revisar**: ¿Se usa realmente? ¿Es redundante con check-brew-conflicts.sh?

### ❓ **generate-smart-brewfile.sh**
- **Función**: Genera Brewfile evitando conflictos
- **Revisar**: ¿Se usa? ¿El Brewfile actual ya es "smart"?

---

## 📋 **Acciones propuestas:**

1. ✅ **Crear estructura de carpetas**
2. ✅ **Mover scripts por categoría**
3. ✅ **Actualizar paths en documentación**
4. ❓ **Revisar scripts duplicados/innecesarios**
5. ✅ **Crear script de migración**
6. ✅ **Actualizar README.md**

---

## 🚨 **Consideraciones importantes:**

### **Scripts run_once_***
- ❗ **CUIDADO**: Chezmoi ejecuta `run_once_*` automáticamente
- ❗ **NO MOVER**: Los `run_once_*` deben quedarse en la raíz para que chezmoi los encuentre
- ✅ **ALTERNATIVA**: Crear symlinks o mover lógica a scripts/

### **Referencias en documentación**
- README.md tiene muchas referencias a scripts por path relativo
- Documentos de setup referencian scripts directamente
- Necesario actualizar todos los paths

### **Compatibilidad con setup existente**
- Scripts actuales pueden estar referenciados en otros lugares
- Crear periodo de transición con symlinks