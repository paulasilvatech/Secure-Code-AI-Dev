# GitHub Copilot Security Prompts Library

## 🛡️ Security-First Code Generation

### Input Validation

```javascript
// Prompt: Create a secure input validation function for user registration that prevents SQL injection and XSS
```

```python
# Prompt: Implement input sanitization for a REST API endpoint that handles file uploads with security checks
```

### Authentication & Authorization

```javascript
// Prompt: Generate a secure JWT authentication middleware with refresh token support and proper error handling
```

```python
# Prompt: Create a role-based access control decorator that validates permissions against Azure AD groups
```

### Secure Data Handling

```javascript
// Prompt: Implement a function to securely store sensitive data in Azure Key Vault with encryption
```

```python
# Prompt: Create a secure data serialization class that redacts PII before logging
```

## 🔐 Cryptography Patterns

### Encryption

```javascript
// Prompt: Generate a secure encryption service using AES-256-GCM with proper key management
```

```python
# Prompt: Implement end-to-end encryption for messages using modern cryptographic standards
```

### Hashing & Password Storage

```javascript
// Prompt: Create a secure password hashing function using bcrypt with appropriate salt rounds
```

```python
# Prompt: Implement a secure password reset flow with time-limited tokens
```

## 🌐 API Security

### Rate Limiting

```javascript
// Prompt: Implement rate limiting middleware that prevents brute force attacks with Redis backend
```

### API Key Management

```python
# Prompt: Create an API key rotation system with secure storage and audit logging
```

## 🚨 Error Handling

### Secure Error Messages

```javascript
// Prompt: Generate error handling middleware that logs detailed errors internally but returns safe messages to clients
```

```python
# Prompt: Create a custom exception handler that prevents information disclosure in production
```

## 🔍 Security Scanning

### Code Analysis

```javascript
// Prompt: Write a function that scans configuration files for hardcoded secrets using regex patterns
```

### Dependency Checking

```python
# Prompt: Create a script to check npm/pip dependencies for known vulnerabilities and suggest updates
```

## 📊 Logging & Monitoring

### Security Logging

```javascript
// Prompt: Implement security event logging that captures authentication attempts and suspicious activities
```

```python
# Prompt: Create an audit trail system that logs all data access with user context and timestamps
```

## 🛠️ DevSecOps Integration

### CI/CD Security

```yaml
# Prompt: Generate a GitHub Actions workflow that includes security scanning, secret detection, and compliance checks
```

### Infrastructure as Code

```bicep
// Prompt: Create a Bicep template for deploying a secure web application with network isolation and managed identities
```

## 💡 Best Practices Examples

### Secure by Default

```javascript
// Prompt: Refactor this Express.js application to follow security best practices including helmet, CORS, and CSP
```

### Zero Trust Implementation

```python
# Prompt: Implement a zero trust network access validator for microservices communication
```

## 🎯 Copilot Configuration

### .github/copilot-instructions.md

```markdown
# Copilot Instructions for Security

When generating code:
1. Always validate and sanitize user inputs
2. Use parameterized queries for database operations
3. Implement proper authentication and authorization
4. Handle errors securely without exposing sensitive information
5. Use strong encryption for sensitive data
6. Follow the principle of least privilege
7. Include security headers in HTTP responses
8. Log security events for monitoring
9. Validate file uploads and limit sizes
10. Use secure communication protocols (HTTPS/TLS)

Preferred security libraries:
- Node.js: helmet, bcrypt, jsonwebtoken, express-rate-limit
- Python: cryptography, passlib, pyjwt, python-jose
- .NET: Microsoft.AspNetCore.Authentication, System.Security.Cryptography

Always consider OWASP Top 10 vulnerabilities when generating code.
```

## 📝 Custom Security Snippets

### VS Code Snippets

```json
{
  "Secure API Endpoint": {
    "prefix": "secapi",
    "body": [
      "router.${1:post}('/${2:endpoint}',",
      "  authenticate,",
      "  authorize(['${3:role}']),",
      "  validateInput(${4:schema}),",
      "  rateLimiter,",
      "  async (req, res, next) => {",
      "    try {",
      "      // Secure implementation",
      "      $0",
      "    } catch (error) {",
      "      logger.error('${2:endpoint} error:', { error: error.message, user: req.user.id });",
      "      next(error);",
      "    }",
      "  }",
      ");"
    ],
    "description": "Secure API endpoint with authentication, authorization, and validation"
  }
}
``` 