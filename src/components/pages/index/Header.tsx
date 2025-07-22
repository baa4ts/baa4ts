import { useEffect, useRef } from "react";
import { Contenedor } from "../../shared/ContenedorCustom";
import { Physics2DPlugin, ScrambleTextPlugin } from "gsap/all";
import gsap from "gsap";

export const Header = () => {

    const titulo = useRef<HTMLHeadingElement | null>(null);

    useEffect(() => {
        gsap.registerPlugin(ScrambleTextPlugin)
        gsap.registerPlugin(Physics2DPlugin)



        if (!titulo.current) return;


        gsap.to(titulo.current, {
            duration: 2,
            speed: 0.5,
            scrambleText: "baa4ts"
        })

    }, [])


    return (
        <Contenedor defaultView className='h-48 flex flex-col items-center justify-center'>
            <h1 ref={titulo} className="font-title font-black text-7xl md:text-9xl lg:text-[10rem] text-black dark:text-white"></h1>
        </Contenedor>
    )
}