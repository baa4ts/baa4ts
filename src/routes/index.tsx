import { createFileRoute } from '@tanstack/react-router'

import { constants } from '#/constants/constants'

import { Docker } from '#/components/constants/Docker'
import { Expressjs } from '#/components/constants/Express'
import { JavaScript } from '#/components/constants/JavaScript'
import { MySQL } from '#/components/constants/MySql'
import { Reactjs } from '#/components/constants/Reactjs'
import { TailwindCSS } from '#/components/constants/Tailwind'
import { TypeScript } from '#/components/constants/TypeScript'

import { CustomIcon } from '#/components/perpage/home/CustomIcon'
import { TextToolTip } from '#/components/shared/TextToolTip'
import { CardProject } from '#/components/perpage/home/CardProject'
import { TanStack } from '#/components/constants/TanStack'
import { LinkedIn } from '#/components/constants/Linkedin'
import { ContactIcon } from '#/components/perpage/home/ContactIcon'
import { NPM } from '#/components/constants/npm'
import { GitHub } from '#/components/constants/Github'
import { GmailNoScrap } from '#/components/perpage/home/GmailNoScrap'

export const Route = createFileRoute('/')({
  ssr: true,
  component: Home,
  notFoundComponent: () => <div>404 - No encontrado</div>,
})

function Home() {
  return (
    <main className="w-full md:w-4/5 md:mx-auto lg:w-160 gap-2">
      {/* Header */}
      <article className="flex flex-col md:flex-row gap-2 m-2">
        <figure className="w-full md:w-1/4 h-auto">
          <img
            className="rounded-lg object-cover w-full h-full"
            src={constants.PERFIL}
          />
        </figure>
        <div className="md:w-3/4 flex flex-col seccion px-4 py-3 justify-center">
          <span className="text-white font-mono text-xl font-bold">
            {constants.USERNAME}
          </span>
          <p className="text-white/70 font-mono text-sm leading-relaxed">
            {constants.BIO}
          </p>
          <div className="flex flex-row flex-wrap gap-2 mt-2">
            <GmailNoScrap />
            <ContactIcon
              icono={GitHub}
              label="Github"
              link="https://github.com/baa4ts"
            />
            <ContactIcon
              icono={NPM}
              label="NPM"
              link="https://www.npmjs.com/~baa4ts"
            />
            <ContactIcon icono={LinkedIn} label="Linkedin" link="" />
          </div>
        </div>
      </article>

      {/* Skills */}
      <article className="flex flex-col gap-2 m-2 seccion px-4 py-3">
        <span className="text-white font-mono text-xl font-bold">Skills</span>

        <div className="flex flex-row flex-wrap gap-2">
          {constants.TECH.map((habilidades, i) => (
            <TextToolTip
              key={i}
              color={habilidades.color}
              text={habilidades.categoria}
            />
          ))}
        </div>

        <div className="flex flex-row flex-wrap gap-2">
          <CustomIcon
            color="#F59E0B"
            icono={TypeScript}
            tipText="TypeScript"
            animate
          />
          <CustomIcon color="#F59E0B" icono={JavaScript} tipText="JavaScript" />
          <CustomIcon
            color="#3B82F6"
            icono={Expressjs}
            tipText="Express.js — Framework backend para Node.js"
          />
          <CustomIcon
            color="#A855F7"
            icono={Reactjs}
            tipText="React — Libreria UI de JavaScript"
          />
          <CustomIcon
            color="#A855F7"
            icono={TanStack}
            tipText="TanStack — Routing, Query y Table para React"
          />
          <CustomIcon
            color="#A855F7"
            icono={TailwindCSS}
            tipText="Tailwind CSS — Framework de estilos utility-first"
          />
          <CustomIcon
            color="#EF4444"
            icono={Docker}
            tipText="Docker — Contenedores para deploy y desarrollo"
          />
          <CustomIcon
            color="#06B6D4"
            icono={MySQL}
            tipText="MySQL — Base de datos relacional"
          />
        </div>
      </article>

      {/* Proyectos */}
      <article className="flex flex-col gap-2 m-2 seccion px-4 py-3">
        <span className="text-white font-mono text-xl font-bold">
          Proyectos
        </span>
        <div className="flex flex-col divide-y divide-white/10">
          {constants.PROJECT.map((p) => (
            <CardProject key={p.name} {...p} />
          ))}
        </div>
      </article>
    </main>
  )
}
