#!/bin/bash

# Regenerate AWS config from Bitwarden
# Run this script when you need to update ~/.aws/config with latest corporate settings

set -e

echo "🔧 Regenerating AWS configuration from Bitwarden..."

# Check if Bitwarden CLI is available and unlocked
if ! command -v bw &> /dev/null; then
    echo "❌ Bitwarden CLI not found. Please install: brew install bitwarden-cli"
    exit 1
fi

# Check if session is available
if [ -z "$BW_SESSION" ] && ! bw status | grep -q '"status":"unlocked"'; then
    echo "🔓 Please unlock Bitwarden first:"
    echo "  bw login"
    echo "  export BW_SESSION=\$(bw unlock --raw)"
    exit 1
fi

# Create .aws directory if it doesn't exist
mkdir -p ~/.aws

# Get AWS configuration from Bitwarden
AWS_CONFIG=$(bw get item "5d221153-c9e6-4407-8cb6-b3ae01192955" ${BW_SESSION:+--session "$BW_SESSION"} | jq -r '.notes')

# Parse configuration values (handling quoted values)
ECR_REGISTRY=$(echo "$AWS_CONFIG" | grep 'ECR_REGISTRY=' | cut -d'=' -f2- | sed 's/^"//;s/"$//')
ECR_PROFILE=$(echo "$AWS_CONFIG" | grep 'ECR_PROFILE=' | cut -d'=' -f2- | sed 's/^"//;s/"$//')
CODEARTIFACT_DOMAIN=$(echo "$AWS_CONFIG" | grep 'CODEARTIFACT_DOMAIN=' | cut -d'=' -f2- | sed 's/^"//;s/"$//')
CODEARTIFACT_DOMAIN_OWNER=$(echo "$AWS_CONFIG" | grep 'CODEARTIFACT_DOMAIN_OWNER=' | cut -d'=' -f2- | sed 's/^"//;s/"$//')
CODEARTIFACT_PROFILE=$(echo "$AWS_CONFIG" | grep 'CODEARTIFACT_PROFILE=' | cut -d'=' -f2- | sed 's/^"//;s/"$//')
SSO_START_URL=$(echo "$AWS_CONFIG" | grep 'SSO_START_URL=' | cut -d'=' -f2- | sed 's/^"//;s/"$//')

echo "🔍 Parsed values:"
echo "  ECR_REGISTRY: $ECR_REGISTRY"
echo "  ECR_PROFILE: $ECR_PROFILE"
echo "  SSO_START_URL: $SSO_START_URL"

# Generate AWS config
cat > ~/.aws/config << EOF
[default]
sso_start_url  = $SSO_START_URL
sso_region     = us-east-1
output         = json

########################
# CORPORATE ORGANIZATION #
########################

# Parse AWS Account IDs from Bitwarden (these should also be in Bitwarden)
# For now using placeholder - TODO: move these to Bitwarden as well
DEV_ACCOUNT_ID="PLACEHOLDER_DEV_ACCOUNT"
PROD_ACCOUNT_ID="PLACEHOLDER_PROD_ACCOUNT"
AI_ACCOUNT_ID="PLACEHOLDER_AI_ACCOUNT"

[profile $ECR_PROFILE]
sso_start_url  = $SSO_START_URL
sso_region     = us-east-1
sso_account_id = $DEV_ACCOUNT_ID
sso_role_name  = Developer
region         = us-east-1
cli_pager      =

[profile $CODEARTIFACT_PROFILE]
sso_start_url  = $SSO_START_URL
sso_region     = us-east-1
sso_account_id = $PROD_ACCOUNT_ID
sso_role_name  = AdminReadOnly
region         = us-east-1
cli_pager      =

[profile ${CODEARTIFACT_PROFILE}_sudo]
sso_start_url  = $SSO_START_URL
sso_region     = us-east-1
sso_account_id = $PROD_ACCOUNT_ID
sso_role_name  = DeveloperSudo
region         = us-east-1
cli_pager      =

[profile ai_codegen]
sso_session = ai_codegen
sso_account_id = $AI_ACCOUNT_ID
sso_role_name = CodeGeneration
region = us-east-1
output = json

[sso-session ai_codegen]
sso_start_url = $SSO_START_URL
sso_region = us-east-1
sso_registration_scopes = sso:account:access
EOF

echo "✅ AWS config regenerated at ~/.aws/config"
echo "🔒 Note: This file contains corporate information and is ignored by git"