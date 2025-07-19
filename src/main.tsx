import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';

// ==========| Tailwind|========== \\
import './styles/globals.css';

// ==========| TanStack Router |========== \\
import { createRouter, RouterProvider } from '@tanstack/react-router';
import { routeTree } from './routeTree.gen';
import { TanStackRouterDevtools } from '@tanstack/react-router-devtools';

const router = createRouter({ routeTree });

declare module '@tanstack/react-router' {
  interface Register {
    router: typeof router;
  }
}

// ==========| Render Aplicacion |========== \\
//
createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <RouterProvider router={router} />
    {import.meta.env.DEV && <TanStackRouterDevtools router={router} />}
  </StrictMode>
);
