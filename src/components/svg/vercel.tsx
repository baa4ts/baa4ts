import type { SVGProps } from 'react'
import React from 'react'

const Vercel = React.memo((props: SVGProps<SVGSVGElement>) => (
    <svg {...props} viewBox="0 0 256 222" preserveAspectRatio="xMidYMid">
        <path fill="#fff" d="m128 0 128 221.705H0z" />
    </svg>
))

export { Vercel }
