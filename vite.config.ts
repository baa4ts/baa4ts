import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'
import { tanstackRouter } from '@tanstack/router-plugin/vite'

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    // TanStack
    tanstackRouter({
      target: 'react',
      autoCodeSplitting: true,
    }),

    // React
    react()],
})
