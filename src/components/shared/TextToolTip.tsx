import React from 'react'

interface Props {
  color: string
  text: string
}

export const TextToolTip = ({ color, text }: Props) => {
  return (
    <span className="flex items-center gap-2 text-xs text-neutral-400">
      <span
        className="h-1.5 w-1.5 rounded-full"
        style={{ backgroundColor: color }}
      />
      {text}
    </span>
  )
}
