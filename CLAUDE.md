# Dotfiles Project - Claude Configuration

## Project Overview
This is my personal dotfiles repository using chezmoi for configuration management and Bitwarden for secure secret storage.

## Project-Specific Rules

### Language
- **Spanish**: Use Spanish for this project as it's personal configuration
- **Technical terms**: Use English for technical terms but explain in Spanish

### Security Critical
- **No secrets**: Never suggest committing secrets to this repository
- **Bitwarden integration**: All secrets must go through Bitwarden templates
- **Private files**: Use `private_` prefix for sensitive files
- **Review changes**: Always explain security implications of configuration changes

### File Structure Understanding
- `dot_*`: Regular dotfiles (public configuration)
- `private_dot_*`: Private dotfiles (may contain secrets via templates)
- `run_once_*`: Setup scripts that run only once
- `*.tmpl`: Template files that use Bitwarden data
- `.chezmoiignore`: Files to exclude from git

### Chezmoi Commands Reference
```bash
chezmoi diff          # Show what would change
chezmoi apply         # Apply changes
chezmoi add ~/.file   # Add file to management
chezmoi edit ~/.file  # Edit managed file
```

### AWS Integration
- **Config only**: Only manage ~/.aws/config (public)
- **Never credentials**: ~/.aws/credentials is ignored
- **CodeArtifact**: Tokens handled by aws-login.sh script

### Key Management
- **SSH keys**: Backed up to Bitwarden with run_once scripts
- **PGP keys**: Optional, backed up when present
- **Recovery**: Keys restored from Bitwarden on new machines

## Maintenance Tasks
When suggesting improvements:
1. Check security implications first
2. Test with `chezmoi diff` before applying
3. Update documentation if file structure changes
4. Consider backup/recovery scenarios