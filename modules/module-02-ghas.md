# Module 02: GitHub Advanced Security Fundamentals

## 📋 Module Overview

**Duration**: 2 hours  
**Level**: Basic  
**Prerequisites**: 
- Completed Module 01
- GitHub account with admin access to a repository
- Basic understanding of Git and GitHub

## 🎯 Learning Objectives

By the end of this module, you will:
- Understand GitHub Advanced Security (GHAS) components
- Enable and configure GHAS features
- Configure Dependabot for automated dependency updates
- Set up code scanning with CodeQL
- Implement secret scanning and push protection
- Create security policies for your repository

## 📚 Module Contents

1. [Introduction to GHAS](#introduction-to-ghas)
2. [Enabling GitHub Advanced Security](#enabling-github-advanced-security)
3. [Dependabot Configuration](#dependabot-configuration)
4. [Code Scanning with CodeQL](#code-scanning-with-codeql)
5. [Secret Scanning](#secret-scanning)
6. [Security Policies](#security-policies)
7. [Exercises](#exercises)

## Introduction to GHAS

GitHub Advanced Security (GHAS) provides a comprehensive suite of security features that help you find, fix, and prevent security vulnerabilities in your code.

### GHAS Components

```mermaid
graph TB
    subgraph "GitHub Advanced Security"
        A[Code Scanning] --> E[Security Overview]
        B[Secret Scanning] --> E
        C[Dependency Review] --> E
        D[Security Policies] --> E
    end
    
    subgraph "Free Security Features"
        F[Dependabot Alerts]
        G[Dependabot Updates]
        H[Security Advisories]
    end
    
    style E fill:#6f9,stroke:#333,stroke-width:2px
```

### Key Features

1. **Code Scanning**
   - Static Application Security Testing (SAST)
   - Powered by CodeQL
   - Supports multiple languages
   - Custom queries available

2. **Secret Scanning**
   - Detects tokens and credentials
   - Push protection prevents commits
   - Partner program for automatic revocation
   - Custom patterns support

3. **Dependency Review**
   - Vulnerability detection in dependencies
   - License compliance checking
   - Pull request integration
   - Actionable fix suggestions

## Enabling GitHub Advanced Security

### Step 1: Check GHAS Availability

GHAS is available for:
- GitHub Enterprise Cloud
- GitHub Enterprise Server 3.0+
- Public repositories (free)
- 30-day trial for private repositories

### Step 2: Enable GHAS for Your Repository

```mermaid
sequenceDiagram
    participant User
    participant Repo Settings
    participant GHAS
    participant Security Tab
    
    User->>Repo Settings: Navigate to Settings
    Repo Settings->>User: Show Security & analysis
    User->>GHAS: Enable Advanced Security
    GHAS->>Security Tab: Features activated
    Security Tab->>User: Configuration options available
```

Navigate to your repository and follow these steps:

1. Go to **Settings** → **Security & analysis**
2. Under "GitHub Advanced Security", click **Enable**
3. Configure individual features as needed

## Dependabot Configuration

### Understanding Dependabot

Dependabot helps you keep dependencies secure and up-to-date by:
- Monitoring for vulnerabilities
- Creating pull requests for updates
- Providing security updates
- Supporting multiple package ecosystems

### Basic Dependabot Configuration

Create `.github/dependabot.yml`:

```yaml
# Dependabot configuration file
version: 2

updates:
  # Enable version updates for npm
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "04:00"
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
      - "ops-team"

  # Enable version updates for GitHub Actions
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    commit-message:
      prefix: "ci"
```

### Dependabot Security Updates

Enable automatic security updates:

1. Go to **Settings** → **Security & analysis**
2. Enable **Dependabot security updates**
3. Configure auto-merge for patches (optional)

## Code Scanning with CodeQL

### Setting Up CodeQL

CodeQL is GitHub's semantic code analysis engine that helps find security vulnerabilities.

Create `.github/workflows/codeql.yml`:

```yaml
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
        language: [ 'javascript', 'python' ]

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Initialize CodeQL
      uses: github/codeql-action/init@v2
      with:
        languages: ${{ matrix.language }}
        queries: security-extended

    - name: Autobuild
      uses: github/codeql-action/autobuild@v2

    - name: Perform CodeQL Analysis
      uses: github/codeql-action/analyze@v2
      with:
        category: "/language:${{matrix.language}}"
```

### Understanding CodeQL Results

```mermaid
graph LR
    A[Code Push] --> B[CodeQL Scan]
    B --> C{Vulnerabilities Found?}
    C -->|Yes| D[Create Alert]
    C -->|No| E[Pass]
    D --> F[Developer Review]
    F --> G{Valid Issue?}
    G -->|Yes| H[Fix Code]
    G -->|No| I[Dismiss Alert]
    H --> A
```

## Secret Scanning

### Enabling Secret Scanning

1. Navigate to **Settings** → **Security & analysis**
2. Enable **Secret scanning**
3. Enable **Push protection** (recommended)

### Custom Secret Patterns

Create custom patterns for organization-specific secrets:

```yaml
# Example custom pattern for API keys
name: "Custom API Key"
pattern: |
  (?i)(?:api[_-]?key|apikey)[[:space:]]*[:=][[:space:]]*['"]?([a-z0-9]{32,64})['"]?
```

### Secret Scanning Partners

GitHub partners automatically revoke exposed tokens:
- AWS
- Azure
- Google Cloud
- Slack
- npm
- PyPI
- And many more...

## Security Policies

### Creating a Security Policy

Create `SECURITY.md` in your repository:

```markdown
# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 5.1.x   | :white_check_mark: |
| 5.0.x   | :x:                |
| 4.0.x   | :white_check_mark: |
| < 4.0   | :x:                |

## Reporting a Vulnerability

We take security seriously. If you discover a vulnerability:

1. **Do not** open a public issue
2. Email security@yourcompany.com with:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

## Response Timeline

- **Acknowledgment**: Within 48 hours
- **Initial Assessment**: Within 5 business days
- **Resolution Target**: Within 30 days for critical issues

## Security Measures

This project implements:
- Automated dependency scanning
- Code security analysis
- Secret scanning
- Regular security audits

## Recognition

We maintain a [Security Hall of Fame](./SECURITY_HALL_OF_FAME.md) for responsible disclosures.
```

## 📝 Exercises

### Exercise 1: Enable GHAS Trial (15 minutes)

**Objective**: Activate GHAS trial for your repository

1. Create a new private repository
2. Navigate to Settings → Security & analysis
3. Enable GitHub Advanced Security trial
4. Document the features that become available
5. Take screenshots for your learning journal

**Deliverable**: `exercises/01-ghas-activation.md` with screenshots

### Exercise 2: Configure Dependabot (25 minutes)

**Objective**: Set up comprehensive Dependabot configuration

1. Create a sample Node.js project:

```bash
mkdir secure-demo-app
cd secure-demo-app
npm init -y
npm install express lodash@4.17.20 axios@0.21.0
```

2. Create `package.json` with known vulnerable versions
3. Create `.github/dependabot.yml` with:
   - Weekly updates for npm
   - Security updates enabled
   - Custom labels and reviewers

4. Push to GitHub and observe Dependabot behavior

**Deliverable**: Repository with working Dependabot configuration

### Exercise 3: Implement CodeQL Scanning (30 minutes)

**Objective**: Set up multi-language CodeQL scanning

1. Create a mixed-language repository with:
   - JavaScript files
   - Python files
   - SQL files

2. Add vulnerable code examples:

```javascript
// Vulnerable JavaScript (SQL Injection)
app.get('/user/:id', (req, res) => {
    const query = `SELECT * FROM users WHERE id = ${req.params.id}`;
    db.query(query, (err, results) => {
        res.json(results);
    });
});
```

```python
# Vulnerable Python (Command Injection)
import os
def process_file(filename):
    os.system(f"cat {filename}")
```

3. Configure CodeQL workflow
4. Run analysis and review results

**Deliverable**: Repository with CodeQL findings and fix commits

### Exercise 4: Secret Scanning Testing (20 minutes)

**Objective**: Test secret scanning and push protection

1. Enable secret scanning and push protection
2. Create a test file with a fake AWS key:

```bash
# test-secrets.txt
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

3. Attempt to commit and push
4. Document the push protection behavior
5. Create custom pattern for your organization

**Deliverable**: Documentation of secret scanning behavior

### Exercise 5: Security Overview Dashboard (30 minutes)

**Objective**: Create organization-wide security visibility

1. Navigate to your organization's Security tab
2. Review the Security Overview dashboard
3. Document:
   - Number of alerts by type
   - Severity distribution
   - Repository risk scores
   - Trends over time

4. Create a security improvement plan based on findings
5. Export data for reporting

**Deliverable**: `exercises/05-security-overview-report.md`

## 🎯 Module Summary

### Key Takeaways

1. **GHAS provides comprehensive security** coverage for your code
2. **Dependabot** automates dependency management
3. **CodeQL** finds complex security vulnerabilities
4. **Secret scanning** prevents credential exposure
5. **Security policies** establish clear communication channels

### Skills Acquired

- ✅ Enabling and configuring GHAS
- ✅ Setting up Dependabot for multiple ecosystems
- ✅ Implementing CodeQL scanning
- ✅ Configuring secret scanning and patterns
- ✅ Creating security policies

## 📚 Additional Resources

### Documentation
- [GitHub Advanced Security Documentation](https://docs.github.com/en/code-security/code-scanning/introduction-to-code-scanning/about-code-scanning)
- [CodeQL Documentation](https://codeql.github.com/docs/)
- [Dependabot Documentation](https://docs.github.com/en/code-security/dependabot)

### Learning Resources
- [GitHub Security Lab](https://securitylab.github.com/)
- [CodeQL Query Examples](https://github.com/github/codeql)
- [GHAS Learning Path](https://docs.microsoft.com/en-us/learn/paths/github-advanced-security/)

### Community
- [GitHub Community Forum](https://github.community/)
- [Security Advisory Database](https://github.com/advisories)

## ✅ Module Completion Checklist

Before moving to the next module, ensure you have:

- [ ] Enabled GHAS trial on a repository
- [ ] Configured Dependabot for automatic updates
- [ ] Set up CodeQL scanning workflow
- [ ] Tested secret scanning and push protection
- [ ] Created a security policy
- [ ] Reviewed Security Overview dashboard

## 🚀 Next Steps

Continue to [Module 03: Setting Up Your Security Environment](../03-environment-setup/README.md) where we'll build the complete development environment for our workshop.

---

**Need Help?** Check our [Troubleshooting Guide](../../docs/troubleshooting.md) or ask in [Discussions](https://github.com/YOUR-USERNAME/secure-code-ai-workshop/discussions).

---

## 🧭 Navigation

| Previous | Up | Next |
|----------|----|----- |
| [← Module 01: Shift-Left Security](module-01-shift-left.md) | [📚 All Modules](../README.md#-learning-path) | [Module 04: Copilot Security →](module-04-copilot.md) |

**Quick Links**: [🏠 Home](../README.md) • [📖 Workshop Overview](../docs/secure-code-ai-workshop.md) • [🔧 Troubleshooting](../docs/troubleshooting-guide.md)
