import { createFileRoute } from '@tanstack/react-router';

export const Route = createFileRoute('/')({
  component: RouteComponent,
});

// Vista de la ruta /
function RouteComponent() {
  return (
    <>
      <h1 className='font-bold font-mono text-5xl text-red-300'>HOla</h1>
    </>
  );
}
