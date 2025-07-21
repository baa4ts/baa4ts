import { createFileRoute } from '@tanstack/react-router';
import type { JSX } from 'react';

export const Route = createFileRoute('/')({
  component: RouteComponent,
});

// Vista de la ruta //
function RouteComponent(): JSX.Element {
  return <h1>Home</h1>;
}
