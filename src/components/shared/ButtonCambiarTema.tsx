import { useEffect, type FC, useRef } from "react";
import { Moon, Sun } from "lucide-react";
import { Tema, useSelectorTema } from "../../hooks/temeSelector";
import tippy from "tippy.js";
import 'tippy.js/dist/tippy.css';
import 'tippy.js/themes/light.css'; // Cambia por otro si quieres (ej. 'material')

export const ButtonCambiarTema: FC = () => {
  const { tema, cambiarTema } = useSelectorTema();
  const Icono = tema === Tema.Claro ? Sun : Moon;
  const ref = useRef<HTMLButtonElement>(null);

  useEffect(() => {
    if (ref.current) {
      tippy(ref.current, {
        placement: "left",
        content: "Este botón cambia de tema la web",
        theme: "light",
        arrow: true,
        animation: "fade",
      });
    }
  }, []);

  return (
    <button
      ref={ref}
      onClick={cambiarTema}
      className="fixed bottom-2 right-2 flex h-10 w-10 md:h-14 md:w-14 
      items-center justify-center rounded-2xl bg-black dark:bg-white 
      border border-gray-300 dark:border-gray-700 hover:scale-105 
      transition-all shadow-md"
    >
      <Icono className="h-6 w-6 md:h-9 md:w-9 text-white dark:text-black" />
    </button>
  );
};
