'use client'

import React from 'react'
import { Tooltip } from 'react-tooltip'
import { motion } from 'motion/react'

interface Props {
  icono: React.ComponentType<React.SVGProps<SVGSVGElement>>
  color: string
  tipText: string
  animate?: boolean
}

export const CustomIcon = React.memo(
  ({ icono: Icono, color, tipText, animate = false }: Props) => {
    const tooltipId = `tooltip-${tipText}`

    return (
      <>
        <motion.span
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.95 }}
          data-tooltip-id={tooltipId}
          data-tooltip-content={tipText}
          className="h-14 w-14 flex items-center justify-center rounded-md border hover:cursor-pointer"
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
        </motion.span>

        <Tooltip
          id={tooltipId}
          style={{
            backgroundColor: '#1c1d21',
            color: '#fafbfa',
            fontSize: '11px',
            fontFamily: 'monospace',
            border: '1px solid #323239',
            borderRadius: '6px',
          }}
        />
      </>
    )
  },
)
