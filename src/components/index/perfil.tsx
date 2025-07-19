import type { JSX } from 'react';
import { CustomContenedor } from '../shared/customContenedor';

export const Perfil = (): JSX.Element => {
  return (
    <CustomContenedor defaultSize={true} className="h-96 bg-red-300">
      <h1>Hola</h1>
    </CustomContenedor>
  );
};
