# ❓ Secure Code AI Workshop - Frequently Asked Questions

## General Questions

### Q: What is the Secure Code AI Workshop?
**A:** The Secure Code AI Workshop is a comprehensive, hands-on training program that teaches you how to implement end-to-end security from code to cloud using GitHub Advanced Security, Microsoft Defender for Cloud, Microsoft Sentinel, and AI-powered security tools.

### Q: Who is this workshop for?
**A:** This workshop is designed for:
- Developers wanting to learn secure coding practices
- DevOps engineers implementing security in CI/CD
- Security professionals modernizing their approach
- Cloud architects designing secure systems
- Anyone interested in shift-left security

### Q: How long does the workshop take?
**A:** 
- **Fast Track**: 8 hours (one day intensive)
- **Complete Path**: 20+ hours (self-paced over 1-2 weeks)
- **Individual Module**: 2-3 hours each

### Q: What are the prerequisites?
**A:** 
- Basic understanding of Git and GitHub
- Familiarity with command line
- Basic cloud concepts knowledge
- No advanced security experience required

### Q: Is this workshop free?
**A:** Yes! The workshop content is completely free. You'll need:
- Azure free account ($200 credits)
- GitHub account (GHAS 30-day trial)
- Optional: AWS/GCP free tier accounts

## Technical Questions

### Q: Which operating systems are supported?
**A:** 
- **Linux**: Full support (Ubuntu 20.04+ recommended)
- **macOS**: Full support (Big Sur or later)
- **Windows**: Full support with WSL2
- **Cloud IDEs**: GitHub Codespaces supported

### Q: Do I need powerful hardware?
**A:** Minimum requirements:
- 8GB RAM (16GB recommended)
- 20GB free disk space
- Stable internet connection
- Modern web browser

### Q: Can I use my company's Azure subscription?
**A:** Yes, but ensure you have:
- Contributor access to create resources
- Ability to create service principals
- Budget approval for resources (~$50/month if kept running)

### Q: What if I don't have admin rights on my machine?
**A:** Options:
1. Use GitHub Codespaces (recommended)
2. Use Azure Cloud Shell
3. Request temporary admin access
4. Use a personal machine or VM

## Module-Specific Questions

### Q: Can I skip modules?
**A:** Modules build on each other, but you can:
- Skip to Module 4 if you know GHAS basics
- Skip to Module 7 for multi-cloud only
- Start with Module 8 for Sentinel focus

### Q: What if I get stuck on an exercise?
**A:** 
1. Check the troubleshooting guide
2. Review the solution branch in the repo
3. Ask in GitHub Discussions
4. Skip and return later

### Q: Are exercise solutions provided?
**A:** Yes! Each exercise has:
- Detailed hints in the module
- Solution branch in the repository
- Video walkthroughs (coming soon)

## Cost and Budget Questions

### Q: How much will this cost?
**A:** Using free tiers and shutting down resources:
- **During workshop**: $0-10
- **If left running**: ~$50-100/month
- **Clean up script provided**: Returns to $0

### Q: How do I avoid unexpected charges?
**A:** 
1. Use the provided cleanup scripts
2. Set up cost alerts ($10 threshold)
3. Use free tier services
4. Stop/deallocate resources when not in use

### Q: Can I use this for my team?
**A:** Absolutely! For teams:
- Fork the repository
- Customize for your environment
- Use shared Azure subscription
- Run as internal training

## Security and Compliance Questions

### Q: Is it safe to use real company code?
**A:** 
- **Don't** use production code
- **Do** use sample applications provided
- **Do** create test repositories
- **Don't** commit real secrets

### Q: Will this meet compliance requirements?
**A:** The workshop covers:
- SOC2 concepts
- ISO 27001 alignment
- GDPR considerations
- But isn't a compliance certification

### Q: Can I get a certificate?
**A:** 
- Workshop completion certificate (self-generated)
- Not an official certification
- Great preparation for:
  - AZ-500 (Azure Security)
  - GitHub Advanced Security Cert

## Troubleshooting Questions

### Q: What if Azure services aren't available in my region?
**A:** 
- Most services available in major regions
- Use East US or West Europe
- Check [Azure Products by Region](https://azure.microsoft.com/global-infrastructure/services/)

### Q: GitHub Actions workflow keeps failing?
**A:** Common fixes:
1. Check secrets are set correctly
2. Ensure GHAS is enabled
3. Verify Azure credentials
4. Check workflow syntax

### Q: Can't connect to AKS cluster?
**A:** 
```bash
# Get fresh credentials
az aks get-credentials --resource-group rg-secure-code-workshop --name aks-secure-workshop

# Verify
kubectl get nodes
```

## Best Practices Questions

### Q: Should I use this architecture in production?
**A:** 
- **Yes**: Core security concepts
- **Maybe**: Exact configurations
- **No**: Without customization for your needs
- **Always**: Test thoroughly first

### Q: How do I maintain what I learned?
**A:** 
1. Join the community discussions
2. Practice with your projects
3. Stay updated with the repo
4. Contribute improvements back

### Q: What's the most important takeaway?
**A:** 
- Security is everyone's responsibility
- Shift-left saves time and money
- Automation is key to scale
- Continuous learning is essential

## Workshop Updates

### Q: How often is the workshop updated?
**A:** 
- **Quarterly**: Major updates
- **Monthly**: Bug fixes
- **As needed**: Security updates
- **Watch** the repo for notifications

### Q: Can I contribute?
**A:** Yes! We welcome:
- Bug fixes
- New exercises
- Translations
- Success stories
- Additional modules

### Q: Is there a Slack/Discord channel?
**A:** 
- GitHub Discussions for Q&A
- Monthly community calls (check repo)
- LinkedIn group (coming soon)

## Next Steps Questions

### Q: What should I do after completing the workshop?
**A:** 
1. Apply learnings to a real project
2. Share knowledge with your team
3. Pursue relevant certifications
4. Contribute to open source security

### Q: Which certification should I pursue next?
**A:** Based on your role:
- **Developers**: GitHub Advanced Security
- **Cloud Engineers**: AZ-500
- **DevOps**: AZ-400 + Security specialty
- **Security Pros**: CCSK, CCSP

### Q: How do I convince my manager to implement this?
**A:** Use our business case template:
- ROI calculations
- Risk reduction metrics
- Compliance benefits
- Competitive advantages

## Support Questions

### Q: Where can I get help?
**A:** 
1. [Troubleshooting Guide](./docs/troubleshooting.md)
2. [GitHub Discussions](https://github.com/YOUR-USERNAME/secure-code-ai-workshop/discussions)
3. [Issue Tracker](https://github.com/YOUR-USERNAME/secure-code-ai-workshop/issues)
4. Community calls (monthly)

### Q: Found a bug/security issue?
**A:** 
- **Bugs**: Open a GitHub issue
- **Security issues**: Email security@workshop.dev
- **Improvements**: Submit a PR

### Q: Can I get 1-on-1 help?
**A:** 
- Community help is free
- Mentorship program (coming soon)
- Commercial training available
- Check discussions for study groups

## Quick Tips

### 🚀 Success Tips
1. **Complete exercises** - Don't just read
2. **Take notes** - Document your learnings
3. **Join discussions** - Learn from others
4. **Practice regularly** - Security is a skill
5. **Share knowledge** - Teach others

### ⏰ Time-Saving Tips
1. Use GitHub Codespaces for quick setup
2. Run cleanup scripts after each session
3. Bookmark the troubleshooting guide
4. Use the fast-track path first
5. Return for deep dives later

### 💡 Learning Tips
1. Focus on concepts, not just commands
2. Understand the "why" behind practices
3. Experiment in safe environments
4. Break complex topics into parts
5. Celebrate small wins

---

**Still have questions?** 
- Ask in [Discussions](https://github.com/YOUR-USERNAME/secure-code-ai-workshop/discussions)
- Check for similar questions first
- Provide context and error messages
- Help others with their questions

Remember: There are no stupid questions in security - it's better to ask than to assume! 🛡️

---

## 🧭 Navigation

| Previous | Up | Next |
|----------|----|----- |
| [📦 Products Overview](products-overview.md) | [📚 Documentation](../README.md#-documentation) | [🔧 Troubleshooting Guide](troubleshooting-guide.md) |

**Quick Links**: [🚀 Quick Start](QUICK_START.md) • [🚀 Workshop Overview](secure-code-ai-workshop.md) • [📋 All Modules](../modules/)
