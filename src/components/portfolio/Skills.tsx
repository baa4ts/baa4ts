import React from 'react'
import { TypeScript } from '../svg/TypeScript'
import { Expressjs } from '../svg/Express'
import { MySQL } from '../svg/MySql'
import { Prisma } from '../svg/Prisma'
import { Docker } from '../svg/Docker'
import { ReactSVG } from '../svg/React'
import { TailwindCSS } from '../svg/Tailwind'
import { Tooltip } from 'react-tooltip'

const skills = [
    {
        id: 'ts',
        label: 'TypeScript',
        desc: 'Lenguaje principal. Tipado estático sobre JavaScript para mayor seguridad y escalabilidad.',
        Icon: TypeScript,
        cat: 'language',
    },
    {
        id: 'express',
        label: 'Express.js',
        desc: 'Framework HTTP minimalista para Node.js. Ideal para construir APIs REST rápidas.',
        Icon: Expressjs,
        cat: 'backend',
    },
    {
        id: 'prisma',
        label: 'Prisma',
        desc: 'ORM moderno con tipado automático. Simplifica el acceso y modelado de la base de datos.',
        Icon: Prisma,
        cat: 'backend',
    },
    {
        id: 'react',
        label: 'React',
        desc: 'UI library basada en componentes. Usada para construir interfaces dinámicas y reactivas.',
        Icon: ReactSVG,
        cat: 'frontend',
    },
    {
        id: 'tailwind',
        label: 'Tailwind',
        desc: 'Framework CSS utilitario. Permite estilizar directo en el markup sin salir del componente.',
        Icon: TailwindCSS,
        cat: 'frontend',
    },
    {
        id: 'docker',
        label: 'Docker',
        desc: 'Contenedores para aislar servicios. Facilita el deploy y la reproducibilidad del entorno.',
        Icon: Docker,
        cat: 'devops',
    },
    {
        id: 'mysql',
        label: 'MySQL',
        desc: 'Base de datos relacional. Robusta y ampliamente usada en proyectos de producción.',
        Icon: MySQL,
        cat: 'database',
    },
] as const

const catClass = {
    language: { dot: 'bg-yellow-400', card: 'bg-yellow-500/15 border-yellow-500/20' },
    backend: { dot: 'bg-blue-400', card: 'bg-blue-500/15 border-blue-500/20' },
    frontend: { dot: 'bg-purple-400', card: 'bg-purple-500/15 border-purple-500/20' },
    devops: { dot: 'bg-rose-400', card: 'bg-rose-500/15 border-rose-500/20' },
    database: { dot: 'bg-cyan-400', card: 'bg-cyan-500/15 border-cyan-500/20' },
}

const catLabel = {
    language: 'Lenguaje',
    backend: 'Backend',
    frontend: 'Frontend',
    devops: 'DevOps',
    database: 'Database',
}

export const Skills = React.memo(() => {
    return (
        <section className="w-full rounded-lg border border-white/10 bg-white/5 px-4 py-3">
            <h2 className="mb-3 font-mono text-xl font-medium text-white">Skills</h2>
            <div className="mb-3 flex flex-wrap gap-x-6 gap-y-2">
                {(['language', 'backend', 'frontend', 'devops', 'database'] as const).map((cat) => (
                    <span key={cat} className="flex items-center gap-2 text-xs text-neutral-400">
                        <span className={`h-1.5 w-1.5 rounded-full ${catClass[cat].dot}`} />
                        {catLabel[cat]}
                    </span>
                ))}
            </div>
            <div className="flex flex-wrap gap-2">
                {skills.map(({ id, label, desc, Icon, cat }) => (
                    <div
                        key={id}
                        data-tooltip-id={id}
                        className={`flex cursor-default items-center justify-center rounded-lg border p-2.5 transition-all hover:brightness-125 ${catClass[cat].card}`}
                    >
                        <Icon className="h-8 w-8" />
                        <Tooltip
                            id={id}
                            render={() => (
                                <div className="flex flex-col gap-0.5">
                                    <span className="text-sm font-medium">{label}</span>
                                    <span className="text-xs text-neutral-400">{desc}</span>
                                </div>
                            )}
                        />
                    </div>
                ))}
            </div>
        </section>
    )
})
