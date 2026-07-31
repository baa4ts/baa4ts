import { Link } from '@tanstack/react-router'
import React from 'react'

interface Props {
  name: string
  type: 'frontend' | 'backend' | 'libreria'
  desc: string
  tech?: readonly string[]
  web?: string
  npm?: string
  github: string
  project?: string
  test?: string
}

const TYPE_STYLES: Record<Props['type'], { label: string; color: string }> = {
  frontend: { label: 'frontend', color: '#A855F7' },
  backend: { label: 'backend', color: '#3B82F6' },
  libreria: { label: 'libreria', color: '#EF4444' },
}

export const CardProject = React.memo(
  ({ name, type, desc, tech, web, npm, github, project, test }: Props) => {
    const { label, color } = TYPE_STYLES[type]

    return (
      <div className="flex flex-col gap-2 py-3">
        <div className="flex flex-row items-center gap-2">
          <span className="text-white font-mono font-semibold">{name}</span>
          <span className="text-white/30">—</span>
          <span
            className="font-mono text-xs leading-relaxed rounded-full px-2 py-0.5 border"
            style={{ color, borderColor: `${color}4D` }}
          >
            {label}
          </span>
        </div>

        <p className="text-white/70 text-sm leading-relaxed">{desc}</p>

        {tech && tech.length > 0 && (
          <div className="flex flex-row flex-wrap gap-1.5">
            {tech.map((t) => (
              <span
                key={t}
                className="font-mono text-[11px] text-white/60 bg-white/5 border border-white/10 rounded-full px-2 py-0.5"
              >
                {t}
              </span>
            ))}
          </div>
        )}

        <div className="flex flex-row gap-2 mt-1">
          {web && (
            <a
              href={web}
              target="_blank"
              rel="noopener noreferrer"
              className="font-mono text-sm text-white/90 border border-white/15 rounded-md px-3 py-1 hover:bg-white/10 hover:border-white/30 transition-colors"
            >
              Visitar
            </a>
          )}
          {project && (
            <Link
              to="/project/$id"
              params={{ id: project }}
              className="font-mono text-sm text-white/90 border border-white/15 rounded-md px-3 py-1 hover:bg-white/10 hover:border-white/30 transition-colors"
            >
              Ver proyecto
            </Link>
          )}
          {npm && (
            <a
              href={npm}
              target="_blank"
              rel="noopener noreferrer"
              className="font-mono text-sm text-white/90 border border-white/15 rounded-md px-3 py-1 hover:bg-white/10 hover:border-white/30 transition-colors"
            >
              Ir a npm
            </a>
          )}
          <a
            href={github}
            target="_blank"
            rel="noopener noreferrer"
            className="font-mono text-sm text-white/70 border border-white/15 rounded-md px-3 py-1 hover:bg-white/10 hover:border-white/30 transition-colors"
          >
            Github
          </a>
          {test && (
            <a
              href={test}
              target="_blank"
              rel="noopener noreferrer"
              className="font-mono text-sm text-white/90 border border-white/15 rounded-md px-3 py-1 hover:bg-white/10 hover:border-white/30 transition-colors"
            >
              Ver últimos tests
            </a>
          )}
        </div>
      </div>
    )
  },
)
