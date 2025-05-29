#!/bin/bash

# Test Security Environment Setup
# Verify all tools are properly installed and configured

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Test results
PASSED=0
FAILED=0
WARNINGS=0

# Test function
test_command() {
    local command=$1
    local name=$2
    local required=${3:-true}
    
    if command -v "$command" &> /dev/null; then
        print_message $GREEN "✅ $name installed"
        ((PASSED++))
        return 0
    else
        if [ "$required" = true ]; then
            print_message $RED "❌ $name not found"
            ((FAILED++))
        else
            print_message $YELLOW "⚠️  $name not found (optional)"
            ((WARNINGS++))
        fi
        return 1
    fi
}

# Test authentication
test_auth() {
    local service=$1
    local check_command=$2
    local name=$3
    
    if eval "$check_command" &> /dev/null; then
        print_message $GREEN "✅ $name authenticated"
        ((PASSED++))
        return 0
    else
        print_message $YELLOW "⚠️  $name not authenticated"
        ((WARNINGS++))
        return 1
    fi
}

# Start testing
print_message $BLUE "🔍 Testing Security Environment Setup"
print_message $BLUE "====================================="

# Development Tools
print_message $BLUE "\n📦 Development Tools:"
test_command "git" "Git"
test_command "code" "VS Code"
test_command "node" "Node.js"
test_command "npm" "npm"
test_command "python3" "Python 3"
test_command "pip3" "pip3"
test_command "go" "Go" false

# Security Tools
print_message $BLUE "\n🔒 Security Tools:"
test_command "git-secrets" "git-secrets"
test_command "trivy" "Trivy"
test_command "hadolint" "Hadolint"
test_command "semgrep" "Semgrep"
test_command "bandit" "Bandit"
test_command "eslint" "ESLint" false
test_command "snyk" "Snyk"
test_command "gosec" "gosec" false

# Cloud Tools
print_message $BLUE "\n☁️  Cloud Tools:"
test_command "az" "Azure CLI"
test_command "gh" "GitHub CLI"
test_command "docker" "Docker"
test_command "kubectl" "kubectl"

# Test Authentication Status
print_message $BLUE "\n🔐 Authentication Status:"
test_auth "azure" "az account show" "Azure CLI"
test_auth "github" "gh auth status" "GitHub CLI"

# Test Docker
if command -v docker &> /dev/null; then
    if docker info &> /dev/null; then
        print_message $GREEN "✅ Docker daemon running"
        ((PASSED++))
    else
        print_message $YELLOW "⚠️  Docker daemon not running"
        ((WARNINGS++))
    fi
fi

# Test VS Code Extensions
print_message $BLUE "\n📝 VS Code Extensions:"
if command -v code &> /dev/null; then
    extensions=(
        "ms-vscode.azure-account"
        "github.vscode-github-actions"
        "github.copilot"
        "snyk-security.snyk-vulnerability-scanner"
        "SonarSource.sonarlint-vscode"
    )
    
    installed_extensions=$(code --list-extensions 2>/dev/null || echo "")
    
    for ext in "${extensions[@]}"; do
        if echo "$installed_extensions" | grep -q "$ext"; then
            print_message $GREEN "✅ $ext installed"
            ((PASSED++))
        else
            print_message $YELLOW "⚠️  $ext not installed"
            ((WARNINGS++))
        fi
    done
fi

# Test git-secrets configuration
print_message $BLUE "\n🔧 git-secrets Configuration:"
if command -v git-secrets &> /dev/null; then
    if git secrets --list &> /dev/null; then
        print_message $GREEN "✅ git-secrets configured"
        ((PASSED++))
    else
        print_message $YELLOW "⚠️  git-secrets not configured in this repository"
        ((WARNINGS++))
    fi
fi

# Security Scan Test
print_message $BLUE "\n🔍 Quick Security Scan Test:"

# Create a test file with potential security issue
TEST_DIR="/tmp/security-test-$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Test file with hardcoded secret
cat > test.py << 'EOF'
# Test file with security issues
password = "hardcoded_password_123"
api_key = "sk-1234567890abcdef"

def unsafe_sql(user_input):
    query = "SELECT * FROM users WHERE name = '" + user_input + "'"
    return query
EOF

# Run Bandit
if command -v bandit &> /dev/null; then
    print_message $YELLOW "Running Bandit..."
    if bandit test.py 2>&1 | grep -q "hardcoded_password"; then
        print_message $GREEN "✅ Bandit correctly detected security issues"
        ((PASSED++))
    else
        print_message $RED "❌ Bandit did not detect security issues"
        ((FAILED++))
    fi
fi

# Run Semgrep
if command -v semgrep &> /dev/null; then
    print_message $YELLOW "Running Semgrep..."
    if semgrep --config=auto test.py 2>&1 | grep -q "hardcoded"; then
        print_message $GREEN "✅ Semgrep correctly detected security issues"
        ((PASSED++))
    else
        print_message $YELLOW "⚠️  Semgrep results may vary"
        ((WARNINGS++))
    fi
fi

# Cleanup
cd - > /dev/null
rm -rf "$TEST_DIR"

# Summary
print_message $BLUE "\n📊 Test Summary:"
print_message $BLUE "==============="
print_message $GREEN "Passed: $PASSED"
print_message $YELLOW "Warnings: $WARNINGS"
print_message $RED "Failed: $FAILED"

if [ $FAILED -eq 0 ]; then
    print_message $GREEN "\n✅ Security environment is properly configured!"
    if [ $WARNINGS -gt 0 ]; then
        print_message $YELLOW "Some optional components are missing or not configured."
        print_message $YELLOW "Review the warnings above and install/configure as needed."
    fi
    exit 0
else
    print_message $RED "\n❌ Security environment has critical issues!"
    print_message $RED "Please run the setup script or install missing components manually."
    exit 1
fi 