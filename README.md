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

### Step 1: Install chezmoi and initialize dotfiles
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/satanin/dotfiles.git
```

### Step 2: Install Bitwarden CLI
```bash
brew install bitwarden-cli
```

### Step 3: Login to Bitwarden
```bash
bw login
```

### Step 4: Unlock Bitwarden and set session
```bash
export BW_SESSION=$(bw unlock --raw)
```

### Step 5: Apply configuration
This will install all packages and setup everything:
```bash
chezmoi apply
```

## Alternative: Manual Setup

If you prefer more control over the process:

### Step 1: Install chezmoi
```bash
sh -c "$(curl -fsLS get.chezmoi.io)"
```

### Step 2: Initialize dotfiles
```bash
chezmoi init https://github.com/satanin/dotfiles.git
```

### Step 3: Install Bitwarden CLI
```bash
brew install bitwarden-cli
```

### Step 4: Setup Bitwarden
```bash
bw login
```

### Step 5: Unlock Bitwarden and set session
```bash
export BW_SESSION=$(bw unlock --raw)
```

### Step 6: Apply configuration
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
dotfiles/
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

Check what would change:
```bash
chezmoi diff
```

Apply changes:
```bash
chezmoi apply
```

Edit a template:
```bash
chezmoi edit ~/.gitconfig
```

Add new file to management:
```bash
chezmoi add ~/.newfile
```

### Key Management

Backup new keys:
```bash
./run_once_backup-keys-to-bitwarden.sh
```

Full key setup (backup + apply):
```bash
./setup-keys.sh
```

### Claude Code Setup

Set up Claude API tokens in Bitwarden:
```bash
./setup-claude-tokens.sh
```

Install Claude Code and configure:
```bash
./run_once_install-claude-code.sh
```

### AWS CodeArtifact Setup

Set up CodeArtifact for Ruby gems:
```bash
./run_once_setup-codeartifact.sh
```

Authenticate and get tokens (expires every 12h):
```bash
./aws-login.sh
```

### iTerm2 Preferences Management

Backup current iTerm2 preferences:
```bash
./run_once_backup-iterm-preferences.sh
```

Restore iTerm2 preferences (done automatically):
```bash
./run_once_setup-iterm.sh
```

Check backup status:
```bash
./manage-iterm-preferences.sh status
```

Manual backup:
```bash
./manage-iterm-preferences.sh backup
```

Manual restore:
```bash
./manage-iterm-preferences.sh restore
```

Sync preferences:
```bash
./manage-iterm-preferences.sh sync
```

### Enterprise Software Center Management

Backup Software Center manifest (corporate machines only):
```bash
./run_once_backup-software-center-manifest.sh
```

Restore manifest on new corporate machine (automatic):
```bash
./run_once_restore-software-center-manifest.sh
```

Check manifest status:
```bash
./manage-software-center.sh status
```

Verify corporate machine:
```bash
./manage-software-center.sh check
```

Manual backup (requires sudo):
```bash
./manage-software-center.sh backup
```

Manual restore (requires sudo):
```bash
./manage-software-center.sh restore
```

### Homebrew Conflict Prevention

Check for conflicts with Software Center before installing:
```bash
./check-brew-conflicts.sh check
```

List all installed applications:
```bash
./check-brew-conflicts.sh list
```

Show disabled applications:
```bash
./brew-app-manager.sh list
```

Enable application after conflict check:
```bash
./brew-app-manager.sh enable chrome
```

Disable application:
```bash
./brew-app-manager.sh disable docker
```

Run conflict check:
```bash
./brew-app-manager.sh check
```

Generate smart Brewfile (advanced):
```bash
./generate-smart-brewfile.sh
```

## Troubleshooting

### Bitwarden Issues

Check Bitwarden status:
```bash
bw status
```

Unlock if locked:
```bash
bw unlock
```

Re-login if needed:
```bash
bw logout && bw login
```

### Chezmoi Issues

Reset chezmoi state:
```bash
chezmoi init --force
```

Debug template rendering:
```bash
chezmoi execute-template '{{ bitwarden "item-name" }}'
```

## Customization

1. **Personal Information**: Update `~/.config/chezmoi/chezmoi.toml`
2. **Software Packages**: Edit `Brewfile`
3. **Shell Configuration**: Modify `dot_zshrc`
4. **Git Settings**: Edit `dot_gitconfig.tmpl`

## Contributing

1. Make changes to source files in your chezmoi directory
2. Test with `chezmoi diff`
3. Apply with `chezmoi apply`
4. Commit and push changes

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.