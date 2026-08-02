import { GenerarCV } from '#/functions/cv/GenerarCV'
import { renderToBuffer } from '@react-pdf/renderer'
import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/cv/')({
  server: {
    handlers: {
      GET: async () => {
        const pdfBuffer = await renderToBuffer(<GenerarCV />)

        return new Response(new Uint8Array(pdfBuffer), {
          headers: {
            'Content-Type': 'application/pdf',
            'Content-Disposition': 'inline; filename="Carlos-Morales-Cv.pdf"',
          },
        })
      },
    },
  },
})
