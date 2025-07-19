import { createFileRoute } from '@tanstack/react-router';

export const Route = createFileRoute('/')({
  component: RouteComponent,
});

// Vista de la ruta /
function RouteComponent() {
  return (
    <>
      <h1>HOla</h1>
    </>
  );
}
