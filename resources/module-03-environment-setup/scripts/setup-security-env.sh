#!/bin/bash

# Security Environment Setup Script
# Comprehensive installation and configuration

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

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        if [ -f /etc/debian_version ]; then
            DISTRO="debian"
        elif [ -f /etc/redhat-release ]; then
            DISTRO="redhat"
        else
            DISTRO="unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        OS="windows"
    fi
}

print_message $BLUE "🚀 Security Environment Setup Script"
print_message $BLUE "===================================="
detect_os
print_message $GREEN "Detected OS: $OS"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew (macOS)
install_homebrew() {
    if [[ "$OS" == "macos" ]] && ! command_exists brew; then
        print_message $YELLOW "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

# Install development tools
install_dev_tools() {
    print_message $YELLOW "\n📦 Installing Development Tools..."
    
    # Git
    if ! command_exists git; then
        print_message $YELLOW "Installing Git..."
        if [[ "$OS" == "macos" ]]; then
            brew install git
        elif [[ "$DISTRO" == "debian" ]]; then
            sudo apt-get update && sudo apt-get install -y git
        elif [[ "$DISTRO" == "redhat" ]]; then
            sudo yum install -y git
        fi
    else
        print_message $GREEN "✅ Git already installed"
    fi
    
    # VS Code
    if ! command_exists code; then
        print_message $YELLOW "Installing VS Code..."
        if [[ "$OS" == "macos" ]]; then
            brew install --cask visual-studio-code
        else
            print_message $RED "Please install VS Code manually from: https://code.visualstudio.com/"
        fi
    else
        print_message $GREEN "✅ VS Code already installed"
    fi
    
    # Node.js and npm
    if ! command_exists node; then
        print_message $YELLOW "Installing Node.js..."
        if [[ "$OS" == "macos" ]]; then
            brew install node
        elif [[ "$DISTRO" == "debian" ]]; then
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            sudo apt-get install -y nodejs
        fi
    else
        print_message $GREEN "✅ Node.js already installed"
    fi
    
    # Python 3 and pip
    if ! command_exists python3; then
        print_message $YELLOW "Installing Python 3..."
        if [[ "$OS" == "macos" ]]; then
            brew install python@3
        elif [[ "$DISTRO" == "debian" ]]; then
            sudo apt-get install -y python3 python3-pip
        fi
    else
        print_message $GREEN "✅ Python 3 already installed"
    fi
    
    # Go
    if ! command_exists go; then
        print_message $YELLOW "Installing Go..."
        if [[ "$OS" == "macos" ]]; then
            brew install go
        else
            print_message $YELLOW "Installing Go from official source..."
            GO_VERSION="1.21.5"
            curl -LO "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
            sudo rm -rf /usr/local/go
            sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
            rm "go${GO_VERSION}.linux-amd64.tar.gz"
            echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
            export PATH=$PATH:/usr/local/go/bin
        fi
    else
        print_message $GREEN "✅ Go already installed"
    fi
}

# Install security tools
install_security_tools() {
    print_message $YELLOW "\n🔒 Installing Security Tools..."
    
    # git-secrets
    if ! command_exists git-secrets; then
        print_message $YELLOW "Installing git-secrets..."
        if [[ "$OS" == "macos" ]]; then
            brew install git-secrets
        else
            git clone https://github.com/awslabs/git-secrets.git /tmp/git-secrets
            cd /tmp/git-secrets && sudo make install
            cd - && rm -rf /tmp/git-secrets
        fi
    else
        print_message $GREEN "✅ git-secrets already installed"
    fi
    
    # Trivy
    if ! command_exists trivy; then
        print_message $YELLOW "Installing Trivy..."
        if [[ "$OS" == "macos" ]]; then
            brew install aquasecurity/trivy/trivy
        else
            curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin
        fi
    else
        print_message $GREEN "✅ Trivy already installed"
    fi
    
    # Hadolint
    if ! command_exists hadolint; then
        print_message $YELLOW "Installing Hadolint..."
        if [[ "$OS" == "macos" ]]; then
            brew install hadolint
        else
            sudo wget -O /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64
            sudo chmod +x /usr/local/bin/hadolint
        fi
    else
        print_message $GREEN "✅ Hadolint already installed"
    fi
    
    # Semgrep
    if ! command_exists semgrep; then
        print_message $YELLOW "Installing Semgrep..."
        pip3 install semgrep
    else
        print_message $GREEN "✅ Semgrep already installed"
    fi
    
    # Bandit
    if ! command_exists bandit; then
        print_message $YELLOW "Installing Bandit..."
        pip3 install bandit
    else
        print_message $GREEN "✅ Bandit already installed"
    fi
    
    # ESLint
    if ! command_exists eslint; then
        print_message $YELLOW "Installing ESLint..."
        npm install -g eslint eslint-plugin-security
    else
        print_message $GREEN "✅ ESLint already installed"
    fi
    
    # Snyk
    if ! command_exists snyk; then
        print_message $YELLOW "Installing Snyk CLI..."
        npm install -g snyk
    else
        print_message $GREEN "✅ Snyk already installed"
    fi
    
    # gosec
    if command_exists go && ! command_exists gosec; then
        print_message $YELLOW "Installing gosec..."
        go install github.com/securego/gosec/v2/cmd/gosec@latest
        print_message $YELLOW "Adding Go binaries to PATH..."
        echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
        export PATH=$PATH:$(go env GOPATH)/bin
    else
        print_message $GREEN "✅ gosec already installed or Go not available"
    fi
}

# Install cloud tools
install_cloud_tools() {
    print_message $YELLOW "\n☁️  Installing Cloud Tools..."
    
    # Azure CLI
    if ! command_exists az; then
        print_message $YELLOW "Installing Azure CLI..."
        if [[ "$OS" == "macos" ]]; then
            brew install azure-cli
        else
            curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
        fi
    else
        print_message $GREEN "✅ Azure CLI already installed"
    fi
    
    # GitHub CLI
    if ! command_exists gh; then
        print_message $YELLOW "Installing GitHub CLI..."
        if [[ "$OS" == "macos" ]]; then
            brew install gh
        elif [[ "$DISTRO" == "debian" ]]; then
            type -p curl >/dev/null || sudo apt install curl -y
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt update
            sudo apt install gh -y
        fi
    else
        print_message $GREEN "✅ GitHub CLI already installed"
    fi
    
    # Docker
    if ! command_exists docker; then
        print_message $YELLOW "Installing Docker..."
        if [[ "$OS" == "macos" ]]; then
            brew install --cask docker
            print_message $YELLOW "Please start Docker Desktop manually"
        else
            curl -fsSL https://get.docker.com -o get-docker.sh
            sudo sh get-docker.sh
            sudo usermod -aG docker $USER
            rm get-docker.sh
            print_message $YELLOW "Please log out and back in for Docker group changes"
        fi
    else
        print_message $GREEN "✅ Docker already installed"
    fi
    
    # kubectl
    if ! command_exists kubectl; then
        print_message $YELLOW "Installing kubectl..."
        if [[ "$OS" == "macos" ]]; then
            brew install kubectl
        else
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
            sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
            rm kubectl
        fi
    else
        print_message $GREEN "✅ kubectl already installed"
    fi
}

# Configure git-secrets
configure_git_secrets() {
    print_message $YELLOW "\n🔧 Configuring git-secrets..."
    
    if command_exists git-secrets; then
        # Register patterns for different providers
        git secrets --register-aws || true
        git secrets --register-azure || true
        
        # Add custom patterns
        git secrets --add 'password\s*=\s*["\'][^"\']{8,}["\']' || true
        git secrets --add 'api[_-]?key\s*=\s*["\'][^"\']{8,}["\']' || true
        git secrets --add 'secret\s*=\s*["\'][^"\']{8,}["\']' || true
        git secrets --add 'token\s*=\s*["\'][^"\']{8,}["\']' || true
        
        print_message $GREEN "✅ git-secrets configured"
    fi
}

# Install VS Code extensions
install_vscode_extensions() {
    print_message $YELLOW "\n📝 Installing VS Code Extensions..."
    
    if command_exists code; then
        extensions=(
            "ms-vscode.azure-account"
            "ms-azuretools.vscode-azureresourcegroups"
            "github.vscode-github-actions"
            "github.copilot"
            "github.copilot-chat"
            "ms-vscode.vscode-node-azure-pack"
            "humao.rest-client"
            "redhat.vscode-yaml"
            "ms-vscode.powershell"
            "hashicorp.terraform"
            "ms-kubernetes-tools.vscode-kubernetes-tools"
            "snyk-security.snyk-vulnerability-scanner"
            "SonarSource.sonarlint-vscode"
            "dbaeumer.vscode-eslint"
            "esbenp.prettier-vscode"
            "streetsidesoftware.code-spell-checker"
        )
        
        for ext in "${extensions[@]}"; do
            print_message $YELLOW "Installing $ext..."
            code --install-extension "$ext" || true
        done
        
        print_message $GREEN "✅ VS Code extensions installed"
    else
        print_message $RED "VS Code not found, skipping extensions"
    fi
}

# Main execution
main() {
    print_message $BLUE "\n🚀 Starting Security Environment Setup...\n"
    
    # macOS specific
    if [[ "$OS" == "macos" ]]; then
        install_homebrew
    fi
    
    # Install tools
    install_dev_tools
    install_security_tools
    install_cloud_tools
    
    # Configure tools
    configure_git_secrets
    install_vscode_extensions
    
    print_message $GREEN "\n✅ Security Environment Setup Complete!"
    print_message $BLUE "\n📋 Next Steps:"
    print_message $YELLOW "1. Authenticate with cloud providers:"
    print_message $YELLOW "   - Azure: az login"
    print_message $YELLOW "   - GitHub: gh auth login"
    print_message $YELLOW "   - Snyk: snyk auth"
    print_message $YELLOW "2. Configure VS Code settings (see module documentation)"
    print_message $YELLOW "3. Run the test script: ./test-security-env.sh"
    
    # Show installed versions
    print_message $BLUE "\n📊 Installed Versions:"
    command_exists git && echo "Git: $(git --version)"
    command_exists node && echo "Node.js: $(node --version)"
    command_exists python3 && echo "Python: $(python3 --version)"
    command_exists go && echo "Go: $(go version)"
    command_exists docker && echo "Docker: $(docker --version)"
    command_exists az && echo "Azure CLI: $(az --version | head -1)"
    command_exists gh && echo "GitHub CLI: $(gh --version | head -1)"
    command_exists trivy && echo "Trivy: $(trivy --version)"
}

# Run main
main 