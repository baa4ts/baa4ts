import { createRootRoute, Outlet } from '@tanstack/react-router';

export const Route = createRootRoute({
  component: () => (
    <main className="bg-black flex flex-col items-center min-h-screen min-w-screen">
      <Outlet />
    </main>
  ),
});
