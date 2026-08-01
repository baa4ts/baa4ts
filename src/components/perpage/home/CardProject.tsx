import { VerticalSeparator } from '#/components/shared/VerticalSeparator'
import React from 'react'

interface Props {
  name: string
  type: 'frontend' | 'backend' | 'libreria'
  desc: string
  tech?: readonly string[]
  web?: string
  npm?: string
  github: string
  test?: string
}

const TYPE_STYLES: Record<Props['type'], { label: string; color: string }> = {
  frontend: { label: 'frontend', color: '#A855F7' },
  backend: { label: 'backend', color: '#3B82F6' },
  libreria: { label: 'libreria', color: '#EF4444' },
}

export const CardProject = React.memo(
  ({ name, type, desc, tech, web, npm, github, test }: Props) => {
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

        <div className="flex flex-row gap-3 mt-1 items-center">
          <a
            href={github}
            target="_blank"
            rel="noopener noreferrer"
            className="font-mono text-xs text-white/50 hover:text-white/80 transition-colors"
          >
            github
          </a>
          {npm && <VerticalSeparator />}
          {npm && (
            <a
              href={npm}
              target="_blank"
              rel="noopener noreferrer"
              className="font-mono text-xs text-red-400 hover:text-red-300 transition-colors"
            >
              npm
            </a>
          )}
          {web && <VerticalSeparator />}
          {web && (
            <a
              href={web}
              target="_blank"
              rel="noopener noreferrer"
              className="font-mono text-xs text-blue-400 hover:text-blue-300 transition-colors"
            >
              visitar
            </a>
          )}
          {test && <VerticalSeparator />}
          {test && (
            <a
              href={test}
              target="_blank"
              rel="noopener noreferrer"
              className="font-mono text-xs text-yellow-400 hover:text-yellow-300 transition-colors"
            >
              ver tests
            </a>
          )}
        </div>
      </div>
    )
  },
)
