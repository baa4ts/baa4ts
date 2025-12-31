
import Hero from '@/components/Hero';
import Proyectos from '@/components/Proyectos';
import Skills from '@/components/Skills';
import { createFileRoute } from '@tanstack/react-router';

export const Route = createFileRoute('/')({ component: App });

function App() {
  return (
    <main className="w-full flex flex-col items-center">
      <Hero />
      <Skills />
      <Proyectos />
    </main>
  );
}