import { createFileRoute } from '@tanstack/react-router';
import type { JSX } from 'react';
import { Titulo } from '../components/index/titulo';
import { Perfil } from '../components/index/perfil';

export const Route = createFileRoute('/')({
  component: RouteComponent,
});

function RouteComponent(): JSX.Element {
  return (
    <>
      <main className="bg-black flex flex-col items-center min-h-screen min-w-screen">
        {/* Titulo de la web: baa4ts */}
        <Titulo />

        {/* Perfil seccion con la img y la breve descripcion */}
        <Perfil />
      </main>
    </>
  );
}
