import { defineConfig } from 'vite'
import react, { reactCompilerPreset } from '@vitejs/plugin-react'
import babel from '@rolldown/plugin-babel'
import { tanstackRouter } from '@tanstack/router-plugin/vite'
import tailwindcss from '@tailwindcss/vite'

// https://vite.dev/config/
export default defineConfig({
  plugins: [

    // Router
    tanstackRouter({
      target: 'react',
      autoCodeSplitting: true,
    }),

    // Tailwind
    tailwindcss(),
    
    react(),
    babel({ presets: [reactCompilerPreset()] })
  ],
})
