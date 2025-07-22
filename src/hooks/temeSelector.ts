import { useEffect, useState } from "react";

export enum Tema {
    Oscuro = "dark",
    Claro = "light"
}

/**
 * Hook para manejar el tema oscuro o claro.
 *
 * Inicializa el tema desde localStorage o la preferencia del sistema,
 * y permite cambiarlo.
 *
 */
export const useSelectorTema = () => {

    const [tema, setTema] = useState<Tema>(() => {
        const temaGuardado = localStorage.getItem("tema");
        if (temaGuardado === Tema.Oscuro || temaGuardado === Tema.Claro) {
            return temaGuardado as Tema;
        }

        const prefiereOscuro = window.matchMedia("(prefers-color-scheme: dark)").matches;
        return prefiereOscuro ? Tema.Oscuro : Tema.Claro;
    });

    useEffect(() => {
        localStorage.setItem("tema", tema);
        document.documentElement.setAttribute('data-theme', tema);
    }, [tema]);

    const cambiarTema = () => {
        setTema(prev => (prev === Tema.Oscuro ? Tema.Claro : Tema.Oscuro));
    };

    return { tema, cambiarTema };
};