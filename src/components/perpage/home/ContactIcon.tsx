import React from 'react'

interface Props {
  icono: React.ComponentType<React.SVGProps<SVGSVGElement>>
  label: string
  link: string
}

export const ContactIcon = ({ icono: Icono, label, link }: Props) => {
  return (
    <a
      href={link}
      target="_blank"
      rel="noopener noreferrer"
      className="font-mono text-xs text-white/90 border border-white/15 rounded-md px-2.5 py-1.5 hover:bg-white/10 hover:border-white/30 transition-colors flex items-center gap-1.5"
    >
      <span className="w-3.5 h-3.5 flex items-center justify-center">
        <Icono />
      </span>
      {label}
    </a>
  )
}
