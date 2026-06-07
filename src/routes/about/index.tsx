import { createFileRoute } from '@tanstack/react-router'
import { ReactSVG } from '../../components/svg/React'
import { TailwindCSS } from '../../components/svg/Tailwind'
import { TanStack } from '../../components/svg/TanStack'
import { TypeScript } from '../../components/svg/TypeScript'
import { Vercel } from '../../components/svg/vercel'
import { Bun } from '../../components/svg/Bun'

export const Route = createFileRoute('/about/')({
    component: RouteComponent,
})

const stack = [
    {
        Icon: TypeScript,
        label: 'TypeScript',
        desc: 'Lenguaje principal. Tipado estático sobre JavaScript para mayor seguridad y escalabilidad.',
        href: 'https://www.typescriptlang.org',
    },
    {
        Icon: ReactSVG,
        label: 'React',
        desc: 'UI library basada en componentes. Base del proyecto para construir la interfaz.',
        href: 'https://react.dev',
    },
    {
        Icon: TanStack,
        label: 'TanStack Router',
        desc: 'Router type-safe para React. Maneja las rutas del portfolio con tipado completo.',
        href: 'https://tanstack.com/router',
    },
    {
        Icon: TailwindCSS,
        label: 'Tailwind CSS',
        desc: 'Framework CSS utilitario. Permite estilizar directo en el markup sin salir del componente.',
        href: 'https://tailwindcss.com',
    },
    {
        Icon: Bun,
        label: 'Bun',
        desc: 'Runtime y package manager ultrarrápido. Usado para instalar dependencias y correr scripts.',
        href: 'https://bun.sh',
    },
    {
        Icon: Vercel,
        label: 'Vercel',
        desc: 'Plataforma de deploy. Hospeda el portfolio con CDN global y deploys automáticos desde Git.',
        href: 'https://vercel.com',
    },
]

function RouteComponent() {
    return (
        <section className="w-full rounded-lg border border-white/10 bg-white/5 px-4 py-3">
            <h2 className="mb-3 font-mono text-xl font-medium text-white">Sobre este portfolio</h2>
            <div className="flex flex-col gap-2">
                {stack.map(({ Icon, label, desc, href }) => (
                    <a
                        key={label}
                        href={href}
                        target="_blank"
                        rel="noreferrer"
                        className="flex items-center gap-3 rounded-lg border border-white/5 bg-white/5 px-3 py-2.5 transition-all hover:border-white/10 hover:bg-white/10"
                    >
                        <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg border border-white/10 bg-white/5 p-1.5">
                            <Icon className="h-full w-full" />
                        </div>
                        <div className="flex flex-col gap-0.5">
                            <span className="text-sm font-medium text-white">{label}</span>
                            <span className="text-xs text-neutral-400">{desc}</span>
                        </div>
                    </a>
                ))}
            </div>
        </section>
    )
}
