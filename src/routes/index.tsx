import { createFileRoute } from '@tanstack/react-router';
export const Route = createFileRoute('/')({ component: App });

function App() {

  return (
    <main>
      <h1>Hola</h1>
    </main>
  );
}
