import { useState, useEffect } from 'react';
import { ChevronRight, Clock, Users, Zap, Check, ExternalLink, Star, Book, Shield, Lock, AlertTriangle, TrendingUp, Menu, X, ShieldCheck, Key, Eye } from 'lucide-react';

// Custom Secure Code Logo with Shield
const SecureCodeLogo = ({ className = "w-12 h-12" }) => {
  return (
    <svg className={className} viewBox="0 0 120 120" fill="none" xmlns="http://www.w3.org/2000/svg">
      {/* Shield with gradient */}
      <path d="M60 15 L85 25 L85 55 C85 75, 70 90, 60 95 C50 90, 35 75, 35 55 L35 25 Z" 
            fill="url(#skyBlueGradient)" opacity="0.9"/>
      
      {/* Lock icon in center */}
      <g transform="translate(60, 48)">
        <rect x="-10" y="-3" width="20" height="16" rx="3" fill="#0369a1"/>
        <path d="M-6 -3 L-6 -8 A 6 6 0 0 1 6 -8 L6 -3" stroke="#0ea5e9" strokeWidth="3" fill="none"/>
        <circle cx="0" cy="5" r="2.5" fill="#0ea5e9"/>
      </g>
      
      {/* Code brackets */}
      <text x="25" y="85" fill="#0ea5e9" fontSize="14" fontFamily="monospace" fontWeight="bold">&lt;/&gt;</text>
      
      {/* AI sparkles */}
      <g transform="translate(88, 20)">
        <path d="M0 6 L3 0 L6 6 L12 9 L6 12 L3 18 L0 12 L-6 9 Z" fill="#38bdf8" opacity="0.9"/>
      </g>
      <g transform="translate(25, 30)">
        <path d="M0 4 L2 0 L4 4 L8 6 L4 8 L2 12 L0 8 L-4 6 Z" fill="#7dd3fc" opacity="0.7"/>
      </g>
      
      {/* Check mark circle */}
      <circle cx="90" cy="80" r="8" fill="#0ea5e9"/>
      <path d="M86 80 L88 82 L94 76" stroke="white" strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round"/>
      
      <defs>
        <linearGradient id="skyBlueGradient" x1="35" y1="15" x2="85" y2="95">
          <stop offset="0%" stopColor="#e0f2fe"/>
          <stop offset="50%" stopColor="#7dd3fc"/>
          <stop offset="100%" stopColor="#0284c7"/>
        </linearGradient>
      </defs>
    </svg>
  );
};

const LandingPage = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 20);
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const modules = [
    { id: 1, title: "Shift-Left Security Principles", duration: "45 min", level: "Basic" },
    { id: 2, title: "GitHub Advanced Security (GHAS)", duration: "60 min", level: "Basic" },
    { id: 3, title: "AI-Powered Secure Coding", duration: "90 min", level: "Intermediate" },
    { id: 4, title: "Container Security & DevSecOps", duration: "90 min", level: "Intermediate" },
    { id: 5, title: "Agentic AI Security Workflows", duration: "120 min", level: "Advanced" },
    { id: 6, title: "Multi-Cloud Security", duration: "90 min", level: "Advanced" },
    { id: 7, title: "Azure Sentinel & Monitoring", duration: "120 min", level: "Advanced" },
    { id: 8, title: "Security Dashboards & Metrics", duration: "60 min", level: "Intermediate" },
    { id: 9, title: "Advanced Security Patterns", duration: "180 min", level: "Advanced" }
  ];

  const benefits = [
    { metric: "80%", description: "Reduction in security issues", icon: ShieldCheck },
    { metric: "95%", description: "Compliance maintained", icon: Check },
    { metric: "70%", description: "Less security debt", icon: TrendingUp },
    { metric: "60%", description: "Faster remediation", icon: Zap }
  ];

  const maturityStages = [
    { stage: "Reactive", description: "Traditional scanning and manual fixes", icon: "🔍" },
    { stage: "Assisted", description: "AI-powered detection with guidance", icon: "🤖" },
    { stage: "Proactive", description: "Integrated controls with automation", icon: "🛡️" },
    { stage: "Intelligent", description: "Self-healing with predictive analytics", icon: "🧠" }
  ];

  const prerequisites = [
    "Azure Free Account",
    "GitHub Advanced Security access",
    "GitHub Copilot subscription",
    "VS Code installed",
    "Node.js 18+ and Docker",
    "Basic security knowledge"
  ];

  const securityFeatures = [
    {
      icon: Shield,
      title: "Shift-Left Security",
      description: "Catch vulnerabilities early in development"
    },
    {
      icon: Eye,
      title: "AI-Powered Scanning",
      description: "Intelligent threat detection and analysis"
    },
    {
      icon: Lock,
      title: "DevSecOps Integration",
      description: "Security embedded in CI/CD pipelines"
    },
    {
      icon: Key,
      title: "Secret Management",
      description: "Automated secret scanning and rotation"
    }
  ];

  const relatedRepos = [
    {
      title: "AI Code Development",
      description: "Leverage AI tools to optimize and improve code quality",
      link: "https://github.com/paulasilvatech/Code-AI-Dev"
    },
    {
      title: "Design-to-Code",
      description: "Transform Figma designs into production-ready code with AI",
      link: "https://github.com/paulasilvatech/Design-to-Code-Dev"
    },
    {
      title: "Agentic Operations",
      description: "Implement comprehensive observability solutions",
      link: "https://github.com/paulasilvatech/Agentic-Ops-Dev"
    },
    {
      title: "Figma-to-Code",
      description: "Convert sophisticated designs into functional applications",
      link: "https://github.com/paulasilvatech/Figma-to-Code-Dev"
    }
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-900 via-sky-900 to-cyan-900 text-white">
      {/* Navigation */}
      <nav className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${scrolled ? 'bg-gray-900/95 backdrop-blur-md shadow-lg' : 'bg-transparent'}`}>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center space-x-3">
              <SecureCodeLogo className="w-10 h-10" />
              <span className="text-xl font-bold">Secure Code AI</span>
            </div>
            
            <div className="hidden md:flex items-center space-x-8">
              <a href="#modules" className="hover:text-sky-400 transition-colors">Modules</a>
              <a href="#impact" className="hover:text-sky-400 transition-colors">Impact</a>
              <a href="#features" className="hover:text-sky-400 transition-colors">Features</a>
              <a href="#start" className="hover:text-sky-400 transition-colors">Get Started</a>
              <a href="https://github.com/paulasilvatech/Secure-Code-AI-Dev" target="_blank" rel="noopener noreferrer" className="flex items-center space-x-1 bg-sky-600 hover:bg-sky-700 px-4 py-2 rounded-lg transition-colors">
                <Star className="w-4 h-4" />
                <span>Star on GitHub</span>
              </a>
            </div>

            <button onClick={() => setIsMenuOpen(!isMenuOpen)} className="md:hidden">
              {isMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>
        </div>

        {/* Mobile menu */}
        {isMenuOpen && (
          <div className="md:hidden bg-gray-900/95 backdrop-blur-md">
            <div className="px-4 pt-2 pb-3 space-y-1">
              <a href="#modules" className="block px-3 py-2 hover:bg-gray-800 rounded-md">Modules</a>
              <a href="#impact" className="block px-3 py-2 hover:bg-gray-800 rounded-md">Impact</a>
              <a href="#features" className="block px-3 py-2 hover:bg-gray-800 rounded-md">Features</a>
              <a href="#start" className="block px-3 py-2 hover:bg-gray-800 rounded-md">Get Started</a>
            </div>
          </div>
        )}
      </nav>

      {/* Hero Section */}
      <section className="relative min-h-screen flex items-center justify-center px-4 pt-16">
        <div className="absolute inset-0 overflow-hidden">
          <div className="absolute -inset-[10px] opacity-50">
            <div className="absolute top-0 -left-4 w-72 h-72 bg-sky-500 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-blob"></div>
            <div className="absolute top-0 -right-4 w-72 h-72 bg-cyan-500 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-blob animation-delay-2000"></div>
            <div className="absolute -bottom-8 left-20 w-72 h-72 bg-blue-500 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-blob animation-delay-4000"></div>
          </div>
        </div>

        <div className="relative max-w-4xl mx-auto text-center">
          <div className="flex justify-center mb-8">
            <SecureCodeLogo className="w-24 h-24 animate-pulse" />
          </div>
          
          <div className="flex justify-center mb-6">
            <span className="bg-sky-600/20 text-sky-300 px-4 py-2 rounded-full text-sm font-medium backdrop-blur-sm">
              🛡️ Enterprise-Grade Security with AI-Powered Development
            </span>
          </div>
          
          <h1 className="text-5xl md:text-7xl font-bold mb-6 bg-clip-text text-transparent bg-gradient-to-r from-sky-400 to-cyan-400">
            Secure Code AI Development
          </h1>
          
          <p className="text-xl md:text-2xl text-gray-300 mb-8 max-w-3xl mx-auto">
            Implement comprehensive secure coding practices using AI-powered tools, GitHub Advanced Security, and modern DevSecOps workflows for enterprise software development.
          </p>
          
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <a href="https://github.com/paulasilvatech/Secure-Code-AI-Dev" target="_blank" rel="noopener noreferrer" className="group bg-gradient-to-r from-sky-600 to-cyan-600 hover:from-sky-700 hover:to-cyan-700 text-white px-8 py-4 rounded-lg font-semibold flex items-center justify-center space-x-2 transition-all transform hover:scale-105">
              <span>Visit GitHub Repository</span>
              <ExternalLink className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
            </a>
            <a href="#start" className="bg-gray-800 hover:bg-gray-700 text-white px-8 py-4 rounded-lg font-semibold flex items-center justify-center space-x-2 transition-all">
              <span>Quick Start</span>
              <ChevronRight className="w-5 h-5" />
            </a>
          </div>

          <div className="mt-12 flex flex-wrap justify-center gap-8 text-sm text-gray-400">
            <div className="flex items-center space-x-2">
              <Clock className="w-5 h-5" />
              <span>90 min - 6+ hours</span>
            </div>
            <div className="flex items-center space-x-2">
              <Users className="w-5 h-5" />
              <span>Beginner to Advanced</span>
            </div>
            <div className="flex items-center space-x-2">
              <Shield className="w-5 h-5" />
              <span>Enterprise Security</span>
            </div>
          </div>
        </div>
      </section>

      {/* Security Challenge Section */}
      <section className="py-20 px-4">
        <div className="max-w-7xl mx-auto">
          <div className="bg-gradient-to-br from-sky-600/20 to-cyan-600/20 rounded-2xl p-8 md:p-12 backdrop-blur-sm">
            <h3 className="text-2xl md:text-3xl font-bold mb-8 text-center">The Security Challenge</h3>
            <div className="text-center mb-8">
              <p className="text-xl text-gray-300 italic">
                "Most security issues are caught too late in the development cycle, exponentially increasing fix costs"
              </p>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mt-8">
              <div className="flex items-start space-x-3">
                <AlertTriangle className="w-6 h-6 text-sky-400 flex-shrink-0 mt-1" />
                <p className="text-gray-300">Traditional approaches are reactive, not proactive</p>
              </div>
              <div className="flex items-start space-x-3">
                <AlertTriangle className="w-6 h-6 text-sky-400 flex-shrink-0 mt-1" />
                <p className="text-gray-300">Manual reviews create bottlenecks and inconsistencies</p>
              </div>
              <div className="flex items-start space-x-3">
                <AlertTriangle className="w-6 h-6 text-sky-400 flex-shrink-0 mt-1" />
                <p className="text-gray-300">Difficult to maintain standards across teams</p>
              </div>
              <div className="flex items-start space-x-3">
                <AlertTriangle className="w-6 h-6 text-sky-400 flex-shrink-0 mt-1" />
                <p className="text-gray-300">High cost of late-stage vulnerability fixes</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Business Impact Section */}
      <section id="impact" className="py-20 px-4 bg-gray-900/50">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-4xl md:text-5xl font-bold mb-4">Business Impact</h2>
            <p className="text-xl text-gray-300 max-w-3xl mx-auto">
              Organizations implementing AI-enhanced secure development achieve transformative results
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {benefits.map((benefit, index) => (
              <div key={index} className="bg-gray-800/50 backdrop-blur-sm rounded-xl p-8 text-center transform hover:scale-105 transition-all">
                <benefit.icon className="w-12 h-12 mx-auto mb-4 text-sky-400" />
                <div className="text-5xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-sky-400 to-cyan-400 mb-2">
                  {benefit.metric}
                </div>
                <p className="text-gray-300">{benefit.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Security Features Section */}
      <section id="features" className="py-20 px-4">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-4xl md:text-5xl font-bold mb-4">Security Features</h2>
            <p className="text-xl text-gray-300 max-w-3xl mx-auto">
              Comprehensive security capabilities powered by AI
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {securityFeatures.map((feature, index) => (
              <div key={index} className="bg-gray-800/50 backdrop-blur-sm rounded-xl p-6 hover:bg-gray-800/70 transition-all text-center">
                <feature.icon className="w-12 h-12 mx-auto mb-4 text-sky-400" />
                <h3 className="text-xl font-semibold mb-2">{feature.title}</h3>
                <p className="text-gray-300 text-sm">{feature.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Maturity Stages Section */}
      <section id="stages" className="py-20 px-4 bg-gray-900/50">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-4xl md:text-5xl font-bold mb-4">Security Maturity Journey</h2>
            <p className="text-xl text-gray-300 max-w-3xl mx-auto">
              Progress through four stages of secure development maturity
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {maturityStages.map((stage, index) => (
              <div key={index} className="relative">
                <div className="bg-gray-800/50 backdrop-blur-sm rounded-xl p-6 hover:bg-gray-800/70 transition-all">
                  <div className="text-4xl mb-4">{stage.icon}</div>
                  <h3 className="text-xl font-semibold mb-2 text-sky-400">{stage.stage}</h3>
                  <p className="text-gray-300 text-sm">{stage.description}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Modules Section */}
      <section id="modules" className="py-20 px-4">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-4xl md:text-5xl font-bold mb-4">Workshop Modules</h2>
            <p className="text-xl text-gray-300 max-w-3xl mx-auto">
              Comprehensive learning path for secure AI-powered development
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {modules.map((module) => (
              <div key={module.id} className="group bg-gray-800/50 backdrop-blur-sm rounded-xl p-6 hover:bg-gray-800/70 transition-all hover:transform hover:scale-105">
                <div className="flex items-start justify-between mb-4">
                  <span className="text-3xl font-bold text-gray-600">0{module.id}</span>
                  <span className={`px-3 py-1 rounded-full text-xs font-medium ${
                    module.level === 'Basic' ? 'bg-green-600/20 text-green-300' :
                    module.level === 'Intermediate' ? 'bg-yellow-600/20 text-yellow-300' :
                    'bg-red-600/20 text-red-300'
                  }`}>
                    {module.level}
                  </span>
                </div>
                <h3 className="text-xl font-semibold mb-2 group-hover:text-sky-400 transition-colors">
                  {module.title}
                </h3>
                <div className="flex items-center text-gray-400 text-sm">
                  <Clock className="w-4 h-4 mr-1" />
                  <span>{module.duration}</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Prerequisites Section */}
      <section id="prerequisites" className="py-20 px-4 bg-gray-900/50">
        <div className="max-w-7xl mx-auto">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <div>
              <h2 className="text-4xl md:text-5xl font-bold mb-6">Prerequisites</h2>
              <p className="text-xl text-gray-300 mb-8">
                Essential tools and knowledge for your secure development journey. All tools have free tiers available.
              </p>
              <ul className="space-y-4">
                {prerequisites.map((prereq, index) => (
                  <li key={index} className="flex items-center space-x-3">
                    <Check className="w-5 h-5 text-green-400 flex-shrink-0" />
                    <span className="text-lg">{prereq}</span>
                  </li>
                ))}
              </ul>
            </div>
            <div className="bg-gradient-to-br from-sky-600/20 to-cyan-600/20 rounded-2xl p-8 backdrop-blur-sm">
              <div className="flex justify-center mb-6">
                <SecureCodeLogo className="w-20 h-20" />
              </div>
              <h3 className="text-2xl font-semibold mb-4 text-center">Shift-Left Security</h3>
              <p className="text-gray-300 mb-6 text-center">
                Learn to catch vulnerabilities early with AI-powered security tools, reducing fix costs by 80% and improving overall code quality.
              </p>
              <div className="grid grid-cols-2 gap-4 text-center">
                <div>
                  <span className="text-3xl font-bold text-sky-400">80%</span>
                  <p className="text-gray-300 text-sm">Earlier detection</p>
                </div>
                <div>
                  <span className="text-3xl font-bold text-cyan-400">95%</span>
                  <p className="text-gray-300 text-sm">Compliance rate</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Getting Started Section */}
      <section id="start" className="py-20 px-4">
        <div className="max-w-4xl mx-auto text-center">
          <h2 className="text-4xl md:text-5xl font-bold mb-6">Get Started in Minutes</h2>
          <p className="text-xl text-gray-300 mb-12">
            Begin your journey to secure AI-powered development
          </p>

          <div className="space-y-6 text-left">
            <div className="bg-gray-800/50 backdrop-blur-sm rounded-xl p-6">
              <div className="flex items-start space-x-4">
                <span className="bg-sky-600 text-white w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 font-semibold">1</span>
                <div className="flex-1">
                  <h3 className="text-xl font-semibold mb-2">Fork and Clone the Repository</h3>
                  <code className="bg-gray-900 px-4 py-2 rounded-md text-sm block overflow-x-auto">
                    git clone https://github.com/YourUsername/Secure-Code-AI-Dev.git
                  </code>
                </div>
              </div>
            </div>

            <div className="bg-gray-800/50 backdrop-blur-sm rounded-xl p-6">
              <div className="flex items-start space-x-4">
                <span className="bg-sky-600 text-white w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 font-semibold">2</span>
                <div className="flex-1">
                  <h3 className="text-xl font-semibold mb-2">Quick Start (30 minutes)</h3>
                  <p className="text-gray-300">Complete setup verification and run your first security scan</p>
                </div>
              </div>
            </div>

            <div className="bg-gray-800/50 backdrop-blur-sm rounded-xl p-6">
              <div className="flex items-start space-x-4">
                <span className="bg-sky-600 text-white w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 font-semibold">3</span>
                <div className="flex-1">
                  <h3 className="text-xl font-semibold mb-2">Follow the Workshop Structure</h3>
                  <p className="text-gray-300">Start with Shift-Left Security Principles and progress through modules</p>
                </div>
              </div>
            </div>

            <div className="bg-gray-800/50 backdrop-blur-sm rounded-xl p-6">
              <div className="flex items-start space-x-4">
                <span className="bg-sky-600 text-white w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 font-semibold">4</span>
                <div className="flex-1">
                  <h3 className="text-xl font-semibold mb-2">Implement Secure Practices</h3>
                  <p className="text-gray-300">Apply AI-powered security tools to your own projects</p>
                </div>
              </div>
            </div>
          </div>

          <div className="mt-12">
            <a href="https://github.com/paulasilvatech/Secure-Code-AI-Dev" target="_blank" rel="noopener noreferrer" className="inline-flex items-center space-x-2 bg-gradient-to-r from-sky-600 to-cyan-600 hover:from-sky-700 hover:to-cyan-700 text-white px-8 py-4 rounded-lg font-semibold transition-all transform hover:scale-105">
              <span>View on GitHub</span>
              <ExternalLink className="w-5 h-5" />
            </a>
          </div>
        </div>
      </section>

      {/* Related Repositories */}
      <section className="py-20 px-4 bg-gray-900/50">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-4xl md:text-5xl font-bold mb-4">Related Resources</h2>
            <p className="text-xl text-gray-300 max-w-3xl mx-auto">
              Explore our comprehensive ecosystem of AI-powered development workshops
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {relatedRepos.map((repo, index) => (
              <a key={index} href={repo.link} target="_blank" rel="noopener noreferrer" className="group bg-gray-800/50 backdrop-blur-sm rounded-xl p-6 hover:bg-gray-800/70 transition-all hover:transform hover:scale-105">
                <div className="flex items-start justify-between mb-4">
                  <Book className="w-8 h-8 text-sky-400" />
                  <ExternalLink className="w-5 h-5 text-gray-400 group-hover:text-sky-400 transition-colors" />
                </div>
                <h3 className="text-xl font-semibold mb-2 group-hover:text-sky-400 transition-colors">
                  {repo.title}
                </h3>
                <p className="text-gray-300">
                  {repo.description}
                </p>
              </a>
            ))}
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="py-12 px-4 border-t border-gray-800">
        <div className="max-w-7xl mx-auto text-center">
          <p className="text-gray-400 mb-4">
            Developed by{' '}
            <a href="https://github.com/paulasilvatech" target="_blank" rel="noopener noreferrer" className="text-sky-400 hover:text-sky-300">
              Paula Silva
            </a>
            , Developer Productivity Global Black Belt
          </p>
          <p className="text-gray-500">
            Bridging the gap between security and development through AI-powered automation
          </p>
        </div>
      </footer>
    </div>
  );
};

export default LandingPage;