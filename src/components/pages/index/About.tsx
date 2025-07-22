import type { JSX } from "react";
import { Contenedor } from "../../shared/ContenedorCustom";

export const About = (): JSX.Element => (
    <Contenedor defaultView className="bg-black rounded-t-2xl h-auto dark:bg-linen">
        <section className="size-full flex flex-col md:flex-row">
            <article className="basis-1/2 p-2 text-yellow-400 flex flex-col items-center justify-center">
                <img className="h-80 mt-10 rounded-2xl mb-5" src="https://i.pinimg.com/736x/d9/3c/47/d93c47b2d860f617b57574636915d782.jpg" alt="" />
            </article>
            <article className="basis-1/2 text-yellow-400 flex flex-col">
                <div className="md:mt-25 p-2">
                    <h2 className="text-white dark:text-black text-6xl font-extrabold font-title">About  me</h2>
                </div>
                <div className="p-2 md:pr-20 font-mono">
                    <p className="text-white dark:text-black">Hola, soy carlos morales, un desarollador backend simple, me especializo en crear soluciones simples y limpias, con las tecnologias como php y django con python</p>
                </div>
            </article>
        </section>
    </Contenedor>
)