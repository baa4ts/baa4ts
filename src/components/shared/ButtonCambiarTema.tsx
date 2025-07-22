import type { FC } from "react";
import { Moon, Sun } from "lucide-react";
import { Tema, useSelectorTema } from "../../hooks/temeSelector";

export const ButtonCambiarTema: FC = () => {
    const { tema, cambiarTema } = useSelectorTema();
    const Icono = tema === Tema.Claro ? Sun : Moon;

    return (
        <button
            onClick={cambiarTema}
            className="fixed bottom-2 right-2 flex h-10 w-10 md:h-15 md:w-15 flex-col items-center justify-center rounded-2xl bg-black dark:bg-white border-2"
        >
            <Icono className="h-6 w-6 md:h-9 md:w-9 invert dark:invert-0 dark:brightness-0" />
        </button>
    );
};
