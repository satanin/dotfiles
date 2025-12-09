# 🔐 Corporate Configuration with Bitwarden

## 📋 Overview

This dotfiles repository uses Bitwarden to securely store corporate information like AWS configurations, URLs, and other sensitive data. This approach keeps the repository safe to be public while maintaining functionality for corporate environments.

## 🎯 **Benefits**

✅ **Public Repository Safe** - No corporate secrets exposed in code
✅ **Centralized Configuration** - All corporate info in Bitwarden
✅ **Easy Company Changes** - Just update Bitwarden items
✅ **Multiple Organizations** - Different items for different companies
✅ **Automatic Backup** - Bitwarden handles secure storage and sync

## 📦 **Required Bitwarden Items**

You need to create these Secure Note items in your Bitwarden vault:

### 1. **"AWS Corporate Config"**
```
ECR_REGISTRY=your-account.dkr.ecr.region.amazonaws.com
ECR_PROFILE=your_ecr_profile
CODEARTIFACT_DOMAIN=your-artifacts-domain
CODEARTIFACT_DOMAIN_OWNER=your-account-id
CODEARTIFACT_PROFILE=your_codeartifact_profile
SSO_START_URL=https://your-org.awsapps.com/start
```

### 2. **"Corporate URLs"**
```
GITLAB_URL=https://gitlab.yourcompany.com
GITLAB_API_URL=https://gitlab.yourcompany.com/api/v4
CONFLUENCE_URL=https://confluence.yourcompany.com
JIRA_URL=https://jira.yourcompany.com
```

## 🚀 **Setup Process**

### **Step 1: Check Current Setup**
```bash
# Run the setup check script
./scripts/security/setup-corporate-bitwarden.sh
```

### **Step 2: Create Bitwarden Items**
1. Open Bitwarden (web app or desktop)
2. Create new **Secure Note** items with the exact names above
3. Add your corporate configuration values
4. Save the items

### **Step 3: Apply Configuration**
```bash
# Apply the templates
chezmoi apply

# Verify everything works
./scripts/aws/aws-login.sh
git config user.email
```

## 🔧 **Affected Files**

The following files use corporate information from Bitwarden:

### **AWS Configuration**
- `~/.aws/config` - AWS profiles and SSO URLs
- `~/.docker/config.json` - ECR registry authentication
- `scripts/aws/aws-login.sh` - AWS authentication script

### **Git Configuration**
- `~/.gitconfig` - Corporate Git URL rewrites
- `~/.gitconfig-work` - Work-specific Git settings

### **Development Tools**
- `~/.claude/claude.json` - Claude Code with corporate URLs
- `~/.bundle/config` - Ruby gems from corporate CodeArtifact

## 🛠️ **Customization**

### **For Different Companies**
Create separate Bitwarden items with different names:
- "AWS [Company] Config"
- "[Company] URLs"

Then update the templates to reference the new item names.

### **For Multiple Environments**
You can have different items for different environments:
- "AWS Production Config"
- "AWS Staging Config"

## ⚠️ **Troubleshooting**

### **Templates Not Rendering**
```bash
# Check Bitwarden is unlocked
bw status

# Verify items exist
bw get item "AWS Corporate Config"
bw get item "Corporate URLs"

# Re-apply templates
chezmoi apply --force
```

### **AWS Login Fails**
```bash
# Check AWS config is applied
cat ~/.aws/config

# Verify ECR registry is correct
docker login --help
```

### **Missing Corporate URLs**
```bash
# Test template rendering
chezmoi execute-template < private_dot_claude/claude.json.tmpl
```

## 🔐 **Security Notes**

- **Never commit corporate secrets** to the repository
- **Use Bitwarden's secure sharing** for team access
- **Regularly audit** Bitwarden items for accuracy
- **Keep Bitwarden CLI updated** for security patches

## 📚 **Related Documentation**

- [New Machine Setup](NUEVO-EQUIPO-SETUP.md)
- [AWS Login Script](../scripts/aws/aws-login.sh)
- [Bitwarden CLI Documentation](https://bitwarden.com/help/cli/)

---

This approach ensures your dotfiles can be safely shared publicly while maintaining all corporate functionality through secure, centralized configuration management.