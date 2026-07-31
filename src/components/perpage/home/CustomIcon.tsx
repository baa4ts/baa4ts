import React from 'react'

interface Props {
  icono: React.ComponentType<React.SVGProps<SVGSVGElement>>
  color: string
  animate?: boolean // opcional
}

export const CustomIcon = React.memo(
  ({ icono: Icono, color, animate = false }: Props) => {
    return (
      <span
        className="h-14 w-14 flex items-center justify-center rounded-md border"
        style={{
          backgroundColor: `${color}1a`,
          borderColor: `${color}40`,
        }}
      >
        <Icono
          className={animate ? 'animate-pulse' : ''}
          height="35"
          width="35"
        />
      </span>
    )
  },
)
