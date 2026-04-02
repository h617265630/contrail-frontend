import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'
import path from 'node:path'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue(), tailwindcss()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          'vendor-vue': ['vue', 'vue-router', 'pinia'],
          'vendor-ui': ['naive-ui', 'lucide-vue-next'],
          'vendor-editor': ['codemirror', '@codemirror/state', '@codemirror/view', '@codemirror/commands', '@codemirror/lang-markdown', '@codemirror/language-data', '@codemirror/theme-one-dark'],
          'vendor-bytemd': ['@bytemd/vue-next', '@bytemd/plugin-gfm', '@bytemd/plugin-highlight', '@bytemd/plugin-math'],
        },
      },
    },
  },
})