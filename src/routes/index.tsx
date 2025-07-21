import { createFileRoute } from '@tanstack/react-router';
import type { JSX } from 'react';
import { ContenedorCustom } from '../components/layout/ContenedorCustom';
import { IconsMap } from '../resource/icons.resource';

export const Route = createFileRoute('/')({
  component: RouteComponent,
});

// Vista de la ruta //
function RouteComponent(): JSX.Element {
  return (
    <main className="flex flex-col justify-center bg-black">
      <ContenedorCustom className="mt-15 h-[80vh] flex flex-col items-center justify-center">
        <div className="w-32 h-32 rounded-full">
          <img
            className="rounded-full object-cover border-white-cream-vanill border-2 border-borders p-1 shadow-lg"
            src="https://i.pinimg.com/736x/9e/e1/17/9ee117a4fcdce09aebf3fd0b516f3693.jpg"
            alt=""
          />
        </div>
        <div className="mt-6">
          <p className="text-white-cream-vanill font-consolas text-xl sm:text-2xl text-balance font-bold mt-1">
            baa4ts
          </p>
        </div>
        <div>
          <p className="text-gray-500 font-consolas font-medium">Desarollador backend</p>
        </div>
        <div className="flex flex-row gap-2 mt-5">
          {IconsMap.map((Icono) => (
            <div>
              <img className="h-8 w-8 invert brightness-200" src={Icono.url} alt={Icono.alt} />
            </div>
          ))}
        </div>
      </ContenedorCustom>
    </main>
  );
}
