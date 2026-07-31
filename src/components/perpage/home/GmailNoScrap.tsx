import { Gmail } from '#/components/constants/Gmail'
import React from 'react'

export const GmailNoScrap = React.memo(() => {
  return (
    <button className="font-mono text-xs text-white/90 border border-white/15 rounded-md px-2.5 py-1.5 hover:bg-white/10 hover:border-white/30 transition-colors flex items-center gap-1.5">
      <span className="w-5 h-5 flex items-center justify-center">
        <Gmail />
      </span>
      Gmail
    </button>
  )
})
