const SecureCodeLogo = ({ className = "w-12 h-12" }) => {
  return (
    <svg className={className} viewBox="0 0 120 120" fill="none" xmlns="http://www.w3.org/2000/svg">
      {/* Shield */}
      <path d="M60 20 L85 30 L85 60 C85 80, 70 95, 60 100 C50 95, 35 80, 35 60 L35 30 Z" 
            fill="url(#shieldGradient)" opacity="0.9"/>
      
      {/* Lock icon in shield */}
      <g transform="translate(60, 50)">
        <rect x="-12" y="-5" width="24" height="18" rx="3" fill="#065f46"/>
        <path d="M-7 -5 L-7 -10 A 7 7 0 0 1 7 -10 L7 -5" stroke="#10b981" strokeWidth="3" fill="none"/>
        <circle cx="0" cy="4" r="3" fill="#10b981"/>
      </g>
      
      {/* Code elements */}
      <text x="45" y="85" fill="#10b981" fontSize="12" fontFamily="monospace">&lt;/&gt;</text>
      
      {/* AI sparkle */}
      <g transform="translate(85, 25)">
        <path d="M0 6 L3 0 L6 6 L12 9 L6 12 L3 18 L0 12 L-6 9 Z" fill="#34d399" opacity="0.8"/>
      </g>
      
      {/* Check mark */}
      <circle cx="90" cy="85" r="10" fill="#10b981"/>
      <path d="M85 85 L88 88 L95 81" stroke="white" strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round"/>
      
      <defs>
        <linearGradient id="shieldGradient" x1="35" y1="20" x2="85" y2="100">
          <stop offset="0%" stopColor="#6ee7b7"/>
          <stop offset="100%" stopColor="#059669"/>
        </linearGradient>
      </defs>
    </svg>
  );
};

export default SecureCodeLogo;