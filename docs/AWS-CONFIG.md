# AWS Configuration Management

## 🔒 **Seguridad implementada**

El archivo `~/.aws/config` **contiene información corporativa específica** y por tanto:

- ✅ **Está en `.chezmoiignore`** - Nunca se commitea al repositorio
- ✅ **Se genera localmente** - Solo existe en tu máquina
- ✅ **Usa datos de Bitwarden** - La información corporativa está en tu vault privado

## 📁 **Cómo funciona**

### **En tu máquina local:**
- El archivo `~/.aws/config` existe y contiene URLs corporativos, Account IDs, etc.
- Es funcional y se puede usar normalmente con AWS CLI

### **En el repositorio público:**
- ❌ **NO existe** `~/.aws/config`
- ✅ **Sí existe** el script de regeneración (sin secretos)
- ✅ **Sí existen** templates que leen de Bitwarden (sin secretos)

## 🔄 **Setup en nuevo equipo**

### **1. Clonar dotfiles**
```bash
chezmoi init https://github.com/satanin/dotfiles.git
```

### **2. Configurar Bitwarden**
```bash
# Instalar CLI
brew install bitwarden-cli

# Login y desbloquear
bw login
export BW_SESSION=$(bw unlock --raw)
```

### **3. Generar AWS config**
```bash
# Opción A: Usar script manual (recomendado)
./scripts/aws/regenerate-aws-config.sh

# Opción B: Usar chezmoi (experimental)
# (Los templates de chezmoi están configurados pero pueden tener problemas con CLI)
```

## 🛠 **Actualizar configuración**

Si cambias algo en Bitwarden:

```bash
# Regenerar archivo con nuevos valores
./scripts/aws/regenerate-aws-config.sh
```

## 🔍 **Verificar que funciona**

```bash
# Verificar configuración
aws configure list-profiles

# Probar login
aws sso login --profile sso_platform_sta_dev
```

## ⚠️ **Importante**

- **NUNCA commites** `~/.aws/config` (está protegido por .chezmoiignore)
- **NUNCA copies** Account IDs o URLs corporativos al repositorio
- **SIEMPRE usa** Bitwarden para almacenar información corporativa
- **Regenera** el archivo cuando cambies de empresa o actualices configuración

## 🔧 **Troubleshooting**

### Si el archivo no se genera:
1. Verifica que Bitwarden CLI funciona: `bw status`
2. Verifica que los items existen: `bw get item "AWS Corporate Config"`
3. Regenera manualmente: `./scripts/aws/regenerate-aws-config.sh`

### Si ves valores vacíos:
1. Desbloquea Bitwarden: `export BW_SESSION=$(bw unlock --raw)`
2. Verifica formato en Bitwarden (debe ser clave=valor)
3. Contacta soporte si el CLI de Bitwarden falla