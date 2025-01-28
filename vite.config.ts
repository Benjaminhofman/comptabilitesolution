import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { resolve } from 'path'

export default defineConfig({
 base: '',
 plugins: [react()],
 resolve: {
   alias: {
     '@': resolve(__dirname, 'src')
   }
 },
 build: {
   outDir: 'dist',
   assetsDir: 'assets',
   manifest: true,
   rollupOptions: {
     input: resolve(__dirname, 'index.html'),
     output: {
       manualChunks: undefined
     }
   }
 },
 server: {
   port: 3000,
   proxy: {
     '/api': {
       target: 'http://localhost:8888/.netlify/functions',
       changeOrigin: true,
       rewrite: (path) => path.replace(/^\/api/, '')
     }
   }
 },
 optimizeDeps: {
   include: ['@stripe/stripe-js']
 }
})
