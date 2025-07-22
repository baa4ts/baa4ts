import type { JSX } from 'react'
import { createFileRoute } from '@tanstack/react-router'
import { Contenedor } from '../components/shared/ContenedorCustom'
import { ButtonCambiarTema } from '../components/shared/ButtonCambiarTema'

export const Route = createFileRoute('/')({
  component: RouteComponent,
})

function RouteComponent(): JSX.Element {


  return (
    <main className='flex flex-col items-center'>
      {/* Boton para cambiar el tema */}
      <ButtonCambiarTema />

      {/* Hero */}
      <Contenedor defaultView className='h-48 flex flex-col items-center justify-center'>
        <h1 className="font-title text-7xl md:text-9xl lg:text-[10rem] text-red-500 dark:text-yellow-400">baa4ts</h1>
      </Contenedor>
    </main>

  )
}
