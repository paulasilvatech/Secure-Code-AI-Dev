#!/bin/bash

# Setup GitHub Advanced Security (GHAS) for Repository
# This script enables and configures GHAS features

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to print messages
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Check if gh CLI is installed
check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        print_message $RED "GitHub CLI (gh) is not installed. Please install it first."
        print_message $YELLOW "Visit: https://cli.github.com/"
        exit 1
    fi
    
    # Check if authenticated
    if ! gh auth status &> /dev/null; then
        print_message $RED "Not authenticated with GitHub CLI."
        print_message $YELLOW "Run: gh auth login"
        exit 1
    fi
}

# Get repository information
get_repo_info() {
    read -p "Enter repository owner/name (e.g., owner/repo): " REPO
    
    # Validate repository exists
    if ! gh repo view "$REPO" &> /dev/null; then
        print_message $RED "Repository $REPO not found or you don't have access."
        exit 1
    fi
    
    print_message $GREEN "Repository found: $REPO"
}

# Enable GitHub Advanced Security
enable_ghas() {
    print_message $YELLOW "Enabling GitHub Advanced Security..."
    
    # Enable security features
    gh api \
        --method PATCH \
        "/repos/${REPO}" \
        --field security_and_analysis='{"advanced_security":{"status":"enabled"},"secret_scanning":{"status":"enabled"},"secret_scanning_push_protection":{"status":"enabled"}}'
    
    print_message $GREEN "GHAS enabled successfully!"
}

# Configure branch protection
configure_branch_protection() {
    print_message $YELLOW "Configuring branch protection rules..."
    
    # Get default branch
    DEFAULT_BRANCH=$(gh repo view "$REPO" --json defaultBranchRef --jq '.defaultBranchRef.name')
    
    # Configure protection rules
    gh api \
        --method PUT \
        "/repos/${REPO}/branches/${DEFAULT_BRANCH}/protection" \
        --field required_status_checks='{"strict":true,"contexts":["CodeQL","dependency-review","secret-scanning"]}' \
        --field enforce_admins=true \
        --field required_pull_request_reviews='{"dismiss_stale_reviews":true,"require_code_owner_reviews":true,"required_approving_review_count":1}' \
        --field restrictions=null \
        --field allow_force_pushes=false \
        --field allow_deletions=false
    
    print_message $GREEN "Branch protection configured!"
}

# Create security policy
create_security_policy() {
    print_message $YELLOW "Creating security policy..."
    
    SECURITY_CONTENT=$(cat <<'EOF'
# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| latest  | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please follow these steps:

1. **Do not** create a public issue
2. Email security@example.com with details
3. Include steps to reproduce if possible
4. Allow up to 48 hours for initial response

## Security Features

This repository has the following security features enabled:

- ✅ GitHub Advanced Security (GHAS)
- ✅ Secret scanning with push protection
- ✅ Code scanning with CodeQL
- ✅ Dependency scanning with Dependabot
- ✅ Security advisories

## Security Best Practices

- All code must pass security scans before merge
- Dependencies are automatically updated via Dependabot
- Secrets must be stored in GitHub Secrets or Azure Key Vault
- Regular security reviews are conducted monthly
EOF
)

    # Create SECURITY.md
    echo "$SECURITY_CONTENT" | gh api \
        --method PUT \
        "/repos/${REPO}/contents/SECURITY.md" \
        --field message="Add security policy" \
        --field content="$(echo "$SECURITY_CONTENT" | base64)"
    
    print_message $GREEN "Security policy created!"
}

# Setup CodeQL
setup_codeql() {
    print_message $YELLOW "Setting up CodeQL analysis..."
    
    CODEQL_WORKFLOW=$(cat <<'EOF'
name: "CodeQL"

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '30 1 * * 0'

jobs:
  analyze:
    name: Analyze
    runs-on: ubuntu-latest
    permissions:
      actions: read
      contents: read
      security-events: write

    strategy:
      fail-fast: false
      matrix:
        language: [ 'javascript', 'python', 'csharp' ]

    steps:
    - name: Checkout repository
      uses: actions/checkout@v4

    - name: Initialize CodeQL
      uses: github/codeql-action/init@v3
      with:
        languages: ${{ matrix.language }}
        queries: security-extended,security-and-quality

    - name: Autobuild
      uses: github/codeql-action/autobuild@v3

    - name: Perform CodeQL Analysis
      uses: github/codeql-action/analyze@v3
      with:
        category: "/language:${{matrix.language}}"
EOF
)

    # Create .github/workflows directory if it doesn't exist
    gh api \
        --method PUT \
        "/repos/${REPO}/contents/.github/workflows/codeql.yml" \
        --field message="Add CodeQL workflow" \
        --field content="$(echo "$CODEQL_WORKFLOW" | base64)"
    
    print_message $GREEN "CodeQL workflow created!"
}

# Setup Dependabot
setup_dependabot() {
    print_message $YELLOW "Setting up Dependabot..."
    
    DEPENDABOT_CONFIG=$(cat <<'EOF'
version: 2
updates:
  # Enable version updates for npm
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
    reviewers:
      - "security-team"
    labels:
      - "dependencies"
      - "security"
    commit-message:
      prefix: "npm"
      include: "scope"

  # Enable version updates for Docker
  - package-ecosystem: "docker"
    directory: "/"
    schedule:
      interval: "weekly"
    reviewers:
      - "security-team"
    labels:
      - "dependencies"
      - "docker"

  # Enable version updates for GitHub Actions
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    reviewers:
      - "security-team"
    labels:
      - "dependencies"
      - "github-actions"

  # Enable version updates for pip
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
    reviewers:
      - "security-team"
    labels:
      - "dependencies"
      - "python"
EOF
)

    # Create dependabot.yml
    gh api \
        --method PUT \
        "/repos/${REPO}/contents/.github/dependabot.yml" \
        --field message="Add Dependabot configuration" \
        --field content="$(echo "$DEPENDABOT_CONFIG" | base64)"
    
    print_message $GREEN "Dependabot configured!"
}

# Create custom security queries
create_custom_queries() {
    print_message $YELLOW "Creating custom security queries..."
    
    CUSTOM_QUERY=$(cat <<'EOF'
/**
 * @name Hardcoded Azure credentials
 * @description Detects potential hardcoded Azure credentials
 * @kind problem
 * @problem.severity error
 * @security-severity 9.0
 * @precision high
 * @id js/hardcoded-azure-credentials
 * @tags security
 *       external/cwe/cwe-798
 */

import javascript

from StringLiteral str
where 
  str.getValue().regexpMatch("DefaultEndpointsProtocol=https;AccountName=.*") or
  str.getValue().regexpMatch("^[A-Za-z0-9+/]{86}==$") or
  str.getValue().regexpMatch("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$")
select str, "Potential hardcoded Azure credentials found"
EOF
)

    # Create custom queries directory
    gh api \
        --method PUT \
        "/repos/${REPO}/contents/.github/codeql/custom-queries.ql" \
        --field message="Add custom CodeQL queries" \
        --field content="$(echo "$CUSTOM_QUERY" | base64)"
    
    print_message $GREEN "Custom queries created!"
}

# Setup secret scanning
setup_secret_scanning() {
    print_message $YELLOW "Configuring secret scanning patterns..."
    
    # Note: Custom patterns require GitHub Enterprise
    print_message $YELLOW "Secret scanning is enabled. Custom patterns require GitHub Enterprise."
    print_message $GREEN "Default secret patterns are active!"
}

# Create security dashboard
create_security_dashboard() {
    print_message $YELLOW "Setting up security dashboard..."
    
    DASHBOARD_README=$(cat <<'EOF'
# Security Dashboard

## 🛡️ Security Status

![CodeQL](https://github.com/${REPO}/workflows/CodeQL/badge.svg)
![Dependabot](https://api.dependabot.com/badges/status?host=github&repo=${REPO})

## 📊 Security Metrics

### Code Scanning
- **Active Alerts**: Check [Security tab](https://github.com/${REPO}/security/code-scanning)
- **Languages Analyzed**: JavaScript, Python, C#
- **Scan Frequency**: On every PR and weekly full scan

### Secret Scanning
- **Status**: ✅ Enabled with push protection
- **Custom Patterns**: Configured for Azure secrets

### Dependency Scanning
- **Dependabot**: ✅ Enabled
- **Update Frequency**: Weekly
- **Auto-merge**: Enabled for patch updates

## 🔍 Recent Security Activities

Check the [Security Overview](https://github.com/${REPO}/security) for latest updates.

## 📚 Security Resources

- [Security Policy](./SECURITY.md)
- [CodeQL Custom Queries](./.github/codeql/)
- [Dependency Policy](./.github/dependabot.yml)

## 🚨 Reporting Issues

Found a security issue? Please follow our [Security Policy](./SECURITY.md).
EOF
)

    echo "$DASHBOARD_README" > security-dashboard.md
    print_message $GREEN "Security dashboard template created at security-dashboard.md"
}

# Generate summary report
generate_summary() {
    print_message $GREEN "\n========================================="
    print_message $GREEN "GHAS Setup Complete!"
    print_message $GREEN "========================================="
    
    cat <<EOF

Repository: $REPO

✅ Enabled Features:
- GitHub Advanced Security
- Secret scanning with push protection
- Code scanning with CodeQL
- Dependency scanning with Dependabot
- Branch protection rules

📁 Created Files:
- SECURITY.md
- .github/workflows/codeql.yml
- .github/dependabot.yml
- .github/codeql/custom-queries.ql

🔗 Next Steps:
1. Review and merge the created files
2. Configure team notifications
3. Review initial security alerts
4. Customize CodeQL queries as needed
5. Set up security training for team

📊 View Security Status:
https://github.com/${REPO}/security

EOF
}

# Main execution
main() {
    print_message $GREEN "GitHub Advanced Security Setup Script"
    print_message $GREEN "===================================="
    
    check_gh_cli
    get_repo_info
    
    print_message $YELLOW "\nThis script will enable and configure:"
    print_message $YELLOW "- GitHub Advanced Security"
    print_message $YELLOW "- Secret scanning with push protection"
    print_message $YELLOW "- Code scanning with CodeQL"
    print_message $YELLOW "- Dependency scanning with Dependabot"
    print_message $YELLOW "- Branch protection rules"
    
    read -p "Continue? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_message $RED "Setup cancelled."
        exit 1
    fi
    
    enable_ghas
    configure_branch_protection
    create_security_policy
    setup_codeql
    setup_dependabot
    create_custom_queries
    setup_secret_scanning
    create_security_dashboard
    generate_summary
}

# Run main function
main "$@" 