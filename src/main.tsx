import ReactDOM from 'react-dom/client'
import { StrictMode } from 'react'
import { RouterProvider, createRouter } from '@tanstack/react-router'
import { routeTree } from './routeTree.gen'

// Crear el router a partir del árbol de rutas
const router = createRouter({ routeTree })

// Registrar la instancia del router para seguridad de tipos
declare module '@tanstack/react-router' {
  interface Register {
    router: typeof router
  }
}

// Obtener el elemento raíz del HTML
const rootElement = document.getElementById('root')!
if (!rootElement.innerHTML) {
  const root = ReactDOM.createRoot(rootElement)
  
  // Renderizar la aplicación dentro del StrictMode de React
  root.render(
    <StrictMode>
      <RouterProvider router={router} />
    </StrictMode>
  )
}
