import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: '/Secure-Code-AI-Dev/',
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
  },
})