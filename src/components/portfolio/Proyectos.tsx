import React from 'react'

export const Proyectos = React.memo(() => (
    <section className="w-full rounded-xl border border-white/10 bg-white/5 p-3 md:p-5">
        <h2 className="mb-2 font-mono text-xl font-semibold tracking-tight text-white">Proyectos</h2>
        <ul className="flex flex-col gap-1">
            <li className="w-full rounded-lg border border-white/5 bg-white/2 p-4 transition-colors hover:border-white/10">
                <div className="mb-2">
                    <h3 className="font-mono text-base font-medium text-white">Uzza</h3>
                </div>

                <p className="mb-4 text-sm leading-relaxed text-white/70">
                    CLI que genera la estructura base de un proyecto Express + TypeScript, con rutas de ejemplo y soporte
                    opcional para Zod y Vitest.
                </p>

                <div className="flex flex-col gap-3 rounded-lg bg-black/30 p-3 text-xs sm:flex-row sm:items-center sm:justify-between">
                    {/* Tech Stack */}
                    <div className="font-medium text-white/50">
                        JavaScript, <span className="font-mono text-white/40">@clack/prompts</span>
                    </div>

                    {/* Links */}
                    <div className="flex items-center gap-3 font-mono">
                        <a
                            className="text-purple-400 underline underline-offset-4 transition-colors hover:text-purple-300"
                            href="https://github.com/baa4ts/create-uzza"
                            target="_blank"
                            rel="noreferrer"
                        >
                            github
                        </a>
                        <span className="text-white/20">|</span>
                        <a
                            className="text-red-400 underline underline-offset-4 transition-colors hover:text-red-300"
                            href="https://www.npmjs.com/package/create-uzza"
                            target="_blank"
                            rel="noreferrer"
                        >
                            npm
                        </a>
                        <span className="text-white/20">|</span>
                        <a
                            className="text-yellow-400 underline underline-offset-4 transition-colors hover:text-yellow-300"
                            href="https://www.npmjs.com/package/create-uzza"
                            target="_blank"
                            rel="noreferrer"
                        >
                            docs
                        </a>
                    </div>
                </div>
            </li>
        </ul>
    </section>
))
