import { Moon, Sun } from "lucide-react";
import { Tema, useSelectorTema } from "../../hooks/temeSelector";
import type { FC } from "react";

export const ButtonCambiarTema: FC = () => {
    const { tema, cambiarTema } = useSelectorTema();
    const Icono = tema === Tema.Claro ? Sun : Moon;

    return (
        <button
            onClick={cambiarTema}
            className="fixed bottom-5 right-5 flex h-10 w-10 md:h-15 md:w-15 flex-col items-center justify-center rounded-2xl bg-black dark:border-2 md:dark:border-3 dark:bg-white"
        >
            <Icono className="h-6 w-6 md:h-9 md:w-9 invert dark:invert-0 dark:brightness-0" />
        </button>
    );
};
