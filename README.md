# Personal Dotfiles

Modern dotfiles management with [chezmoi](https://chezmoi.io) and [Bitwarden](https://bitwarden.com) for secure secret management.

## Features

- 🔐 **Secure secret management** with Bitwarden integration
- 🔑 **Automatic SSH/PGP key backup and recovery**
- 📦 **Automated software installation** via Homebrew
- 🏢 **Corporate software sync** with Enterprise Software Center manifest backup
- 🛠️ **Complete development environment** (Oh-My-Zsh, Powerlevel10k, etc.)
- 🖥️ **Terminal preferences** with iTerm2 configuration backup
- 🤖 **Claude Code integration** with API key management
- 🚀 **One-command setup** for new machines

## Quick Setup (New Machine)

```bash
# 1. Download and run bootstrap script
curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles/master/bootstrap.sh | bash

# 2. Login to Bitwarden and apply configuration
bw login
bw unlock
chezmoi apply
```

## Manual Setup

### Prerequisites
- macOS
- Homebrew (will be installed automatically)

### Installation

1. **Clone this repository:**
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Install dependencies:**
   ```bash
   # Install essential tools
   brew install chezmoi bitwarden-cli

   # Install all packages
   brew bundle install
   ```

3. **Initialize chezmoi:**
   ```bash
   chezmoi init --source="~/.dotfiles"
   ```

4. **Setup Bitwarden:**
   ```bash
   bw login
   bw unlock
   ```

5. **Apply configuration:**
   ```bash
   chezmoi apply
   ```

## Key Management

### Backup Current Keys to Bitwarden
```bash
./setup-keys.sh
```

This automatically:
- Detects SSH and PGP keys
- Creates secure Bitwarden entries
- Sets up templates for recovery
- Configures proper permissions

### Manual Key Backup
```bash
./run_once_backup-keys-to-bitwarden.sh
```

## File Structure

```
~/.dotfiles/
├── bootstrap.sh                           # New machine setup script
├── setup-keys.sh                          # Complete key management
├── Brewfile                               # Homebrew packages
├──
├── # Shell Configuration
├── dot_zshrc                              # Main zsh configuration
├── dot_zsh_aliases                        # Shell aliases
├── dot_zsh_functions                      # Custom functions
├──
├── # Git Configuration
├── dot_gitconfig.tmpl                     # Git config (templated)
├── dot_gitignore                          # Global gitignore
├──
├── # SSH Keys (Bitwarden Templates)
├── private_dot_ssh/
│   ├── private_id_rsa.tmpl               # Main SSH key
│   ├── private_id_rsa_satanin@gmail.com.tmpl  # Personal SSH key
│   ├── config.tmpl                       # SSH configuration
│   └── known_hosts.tmpl                  # Known hosts
├──
├── # PGP Keys (Bitwarden Templates)
├── private_dot_gnupg/
│   ├── private_key.asc.tmpl              # PGP private keys
│   ├── public_keys.asc.tmpl              # PGP public keys
│   ├── trust_db.txt.tmpl                 # Trust database
│   └── gpg.conf.tmpl                     # GPG configuration
├──
├── # Setup Scripts
├── run_once_install-bitwarden.sh         # Install Bitwarden CLI
├── run_once_install-brew.sh              # Install Homebrew packages
├── run_once_install-claude-code.sh       # Install Claude Code
├── run_once_install-oh-my-zsh.sh         # Install Oh-My-Zsh
├── run_once_setup-bitwarden.sh           # Verify Bitwarden items
├── run_once_setup-codeartifact.sh        # Configure AWS CodeArtifact
├── run_once_setup-ssh.sh                 # Configure SSH permissions
├── run_once_setup-pgp.sh                 # Configure PGP keys
├── run_once_set-zsh-default.sh           # Set Zsh as default shell
├── run_once_backup-iterm-preferences.sh  # Backup iTerm2 preferences
├── run_once_setup-iterm.sh               # Restore iTerm2 preferences
├── run_once_backup-software-center-manifest.sh # Backup Software Center manifest
├── run_once_restore-software-center-manifest.sh # Restore Software Center manifest
├──
├── # Management Tools
├── manage-iterm-preferences.sh           # Advanced iTerm2 preference management
├── manage-software-center.sh             # Enterprise Software Center management
├── check-brew-conflicts.sh               # Homebrew vs Software Center conflict checker
├── brew-app-manager.sh                   # Safe Brewfile application management
├── generate-smart-brewfile.sh            # Generate conflict-aware Brewfile
├──
├── # AWS & Development Tools
├── aws-login.sh                          # AWS ECR/CodeArtifact authentication
└── setup-claude-tokens.sh                # Claude API token setup
```

## Bitwarden Items

The following items are automatically created/managed in Bitwarden:

### Tokens
- `GitLab Personal Token - Main`
- `GitLab Personal Token - Secondary`
- `Confluence Personal Token`
- `Jira Personal Token`
- `Claude API Key`
- `OpenAI API Key`

### SSH Keys
- `SSH Key - id_rsa`
- `SSH Key - satanin@gmail.com`
- `SSH Config`
- `SSH Known Hosts`

### PGP Keys (if present)
- `PGP Private Keys`
- `PGP Public Keys`
- `PGP Trust Database`

## Security Features

- ✅ **Never commits secrets** to git repository
- ✅ **Encrypted storage** in Bitwarden
- ✅ **Automatic cleanup** of temporary key files
- ✅ **Proper file permissions** (600 for private keys)
- ✅ **Separate public/private** file handling

## Usage

### Daily Commands
```bash
# Check what would change
chezmoi diff

# Apply changes
chezmoi apply

# Edit a template
chezmoi edit ~/.gitconfig

# Add new file to management
chezmoi add ~/.newfile
```

### Key Management
```bash
# Backup new keys
./run_once_backup-keys-to-bitwarden.sh

# Full key setup (backup + apply)
./setup-keys.sh
```

### Claude Code Setup
```bash
# Set up Claude API tokens in Bitwarden
./setup-claude-tokens.sh

# Install Claude Code and configure
./run_once_install-claude-code.sh
```

### AWS CodeArtifact Setup
```bash
# Set up CodeArtifact for Ruby gems
./run_once_setup-codeartifact.sh

# Authenticate and get tokens (expires every 12h)
./aws-login.sh
```

### iTerm2 Preferences Management
```bash
# Backup current iTerm2 preferences
./run_once_backup-iterm-preferences.sh

# Restore iTerm2 preferences (done automatically)
./run_once_setup-iterm.sh

# Advanced preference management
./manage-iterm-preferences.sh status   # Check backup status
./manage-iterm-preferences.sh backup   # Manual backup
./manage-iterm-preferences.sh restore  # Manual restore
./manage-iterm-preferences.sh sync     # Sync preferences
```

### Enterprise Software Center Management
```bash
# Backup Software Center manifest (corporate machines only)
./run_once_backup-software-center-manifest.sh

# Restore manifest on new corporate machine (automatic)
./run_once_restore-software-center-manifest.sh

# Advanced Software Center management
./manage-software-center.sh status     # Check manifest status
./manage-software-center.sh check      # Verify corporate machine
./manage-software-center.sh backup     # Manual backup (requires sudo)
./manage-software-center.sh restore    # Manual restore (requires sudo)
```

### Homebrew Conflict Prevention
```bash
# Check for conflicts with Software Center before installing
./check-brew-conflicts.sh check        # Check for conflicts
./check-brew-conflicts.sh list         # List all installed applications

# Manage Brewfile applications safely
./brew-app-manager.sh list             # Show disabled applications
./brew-app-manager.sh enable chrome    # Enable application after conflict check
./brew-app-manager.sh disable docker   # Disable application
./brew-app-manager.sh check            # Run conflict check

# Generate smart Brewfile (advanced)
./generate-smart-brewfile.sh           # Generate conflict-aware Brewfile
```

## Troubleshooting

### Bitwarden Issues
```bash
# Check Bitwarden status
bw status

# Unlock if locked
bw unlock

# Re-login if needed
bw logout && bw login
```

### Chezmoi Issues
```bash
# Reset chezmoi state
chezmoi init --force

# Debug template rendering
chezmoi execute-template '{{ bitwarden "item-name" }}'
```

## Customization

1. **Personal Information**: Update `~/.config/chezmoi/chezmoi.toml`
2. **Software Packages**: Edit `Brewfile`
3. **Shell Configuration**: Modify `dot_zshrc`
4. **Git Settings**: Edit `dot_gitconfig.tmpl`

## Contributing

1. Make changes to source files in `~/.dotfiles`
2. Test with `chezmoi diff`
3. Apply with `chezmoi apply`
4. Commit and push changes

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.