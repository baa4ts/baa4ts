import React from 'react'

export const Hero = React.memo(() => {
    return (
        <section className="flex flex-col gap-4 sm:flex-row sm:items-stretch">
            <img
                src="https://i.pinimg.com/1200x/95/e7/cc/95e7ccfd7ad1cd41012bcd70c160e669.jpg"
                alt="Ilustración estilo cartel de figura con cabello negro largo y cara en semitono fumando un cigarrillo, fondo rojo"
                className="h-48 w-full rounded-lg object-cover sm:h-auto sm:w-40 sm:shrink-0"
            />
            <div className="flex w-full flex-col justify-center gap-1.5 rounded-lg border border-white/10 bg-white/5 px-4 py-3">
                <h2 className="font-mono text-xl font-medium text-white sm:text-2xl">baa4ts</h2>
                <p className="text-sm leading-relaxed text-neutral-400">
                    Estudiante de Redes y Software. Me especializo en backend y sistemas, aunque últimamente estoy metiéndome
                    cada vez más en el frontend. Si algo se puede automatizar, lo automatizo.
                </p>
            </div>
        </section>
    )
})
