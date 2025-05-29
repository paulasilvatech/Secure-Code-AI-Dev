#!/bin/bash

# Pre-commit Security Hooks Setup
# Install and configure security-focused pre-commit hooks

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Check if in git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    print_message $RED "Not in a git repository!"
    exit 1
fi

print_message $GREEN "Setting up security pre-commit hooks..."

# Install pre-commit if not installed
if ! command -v pre-commit &> /dev/null; then
    print_message $YELLOW "Installing pre-commit..."
    pip install pre-commit || {
        print_message $RED "Failed to install pre-commit. Please install Python/pip first."
        exit 1
    }
fi

# Create .pre-commit-config.yaml
cat > .pre-commit-config.yaml <<'EOF'
# Security-focused pre-commit hooks
repos:
  # Security - Secret Detection
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']
        exclude: package.lock.json

  # Security - Gitleaks
  - repo: https://github.com/zricethezav/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks

  # Security - Safety (Python dependencies)
  - repo: https://github.com/Lucas-C/pre-commit-hooks-safety
    rev: v1.3.2
    hooks:
      - id: python-safety-dependencies-check

  # Security - Bandit (Python)
  - repo: https://github.com/PyCQA/bandit
    rev: 1.7.5
    hooks:
      - id: bandit
        args: ['-c', '.bandit']

  # Security - npm audit
  - repo: local
    hooks:
      - id: npm-audit
        name: npm audit
        entry: bash -c 'if [ -f package.json ]; then npm audit --audit-level=moderate; fi'
        language: system
        pass_filenames: false

  # Security - Dockerfile
  - repo: https://github.com/hadolint/hadolint
    rev: v2.12.0
    hooks:
      - id: hadolint-docker
        args: ['--ignore', 'DL3008', '--ignore', 'DL3009']

  # YAML/JSON validation
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: check-yaml
        args: ['--safe']
      - id: check-json
      - id: check-xml
      - id: check-toml

  # Terraform security
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.83.5
    hooks:
      - id: terraform_tfsec
      - id: terraform_checkov

  # General security checks
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: detect-private-key
      - id: check-added-large-files
        args: ['--maxkb=1000']
      - id: check-case-conflict
      - id: check-merge-conflict
EOF

# Create .gitleaks.toml configuration
cat > .gitleaks.toml <<'EOF'
title = "gitleaks config"

[allowlist]
description = "Allowlisted files"
paths = [
    '''^\.?gitleaks\.toml$''',
    '''(.*?)(jpg|gif|png|doc|pdf|bin|svg|socket)$''',
    '''(go.mod|go.sum)$'''
]

[[rules]]
description = "AWS Access Key"
regex = '''(A3T[A-Z0-9]|AKIA|AGPA|AIDA|AROA|AIPA|ANPA|ANVA|ASIA)[A-Z0-9]{16}'''
tags = ["key", "AWS"]

[[rules]]
description = "AWS Secret Key"
regex = '''(?i)aws(.{0,20})?(?-i)['\"][0-9a-zA-Z\/+]{40}['\"]'''
tags = ["key", "AWS"]

[[rules]]
description = "Azure Storage Account Key"
regex = '''DefaultEndpointsProtocol=https;AccountName=[^;]+;AccountKey=[A-Za-z0-9+/=]{88};'''
tags = ["key", "Azure"]

[[rules]]
description = "GitHub Token"
regex = '''ghp_[0-9a-zA-Z]{36}'''
tags = ["key", "GitHub"]

[[rules]]
description = "Generic API Key"
regex = '''(?i)(api_key|apikey|api-key)(.{0,20})?['\"][0-9a-zA-Z]{16,45}['\"]'''
tags = ["key", "API"]
EOF

# Create .secrets.baseline
print_message $YELLOW "Creating secrets baseline..."
detect-secrets scan > .secrets.baseline

# Create .bandit configuration for Python projects
cat > .bandit <<'EOF'
[bandit]
exclude: /test,/tests,/venv,/.venv
tests: B201,B301,B302,B303,B304,B305,B306,B501,B502,B503,B504,B505,B506,B507,B601,B602,B603,B604,B605,B606,B607,B608,B609
EOF

# Install the pre-commit hooks
print_message $YELLOW "Installing pre-commit hooks..."
pre-commit install

# Run hooks on all files
print_message $YELLOW "Running initial security scan..."
pre-commit run --all-files || true

print_message $GREEN "✅ Pre-commit security hooks installed successfully!"
print_message $GREEN "Hooks will run automatically on every commit."
print_message $YELLOW "To run manually: pre-commit run --all-files" 