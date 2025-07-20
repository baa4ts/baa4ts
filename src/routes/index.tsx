import { createFileRoute } from '@tanstack/react-router';
import type { JSX } from 'react';
import { TitleCompo } from '../component/index/title';
import { UserCompo } from '../component/index/user';
import { SkillsCompo } from '../component/index/skills';

export const Route = createFileRoute('/')({
  component: RouteComponent,
});

// Vista de la ruta /
function RouteComponent(): JSX.Element {
  return (
    <main className="bg-black flex flex-col items-center min-h-screen min-w-screen">
      {/* Seccion titulo: baa4ts */}
      <TitleCompo />

      {/* Seccion de img y bio */}
      <UserCompo />

      {/* Seccion de skills */}
      <SkillsCompo /> 
    </main>
  );
}
