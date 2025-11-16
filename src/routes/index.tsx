import Hero from '@/components/Hero';

import { createFileRoute } from '@tanstack/react-router';

export const Route = createFileRoute('/')({ component: App });

function App() {
  return (
    <main className="w-full md:w-5/6 lg:w-4/6">
      <Hero />
    </main>
  );
}
