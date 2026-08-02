import { GenerarCV } from '#/functions/cv/generarCV'
import { renderToStream } from '@react-pdf/renderer'
import { createFileRoute } from '@tanstack/react-router'
import { Readable } from 'node:stream'

export const Route = createFileRoute('/cv/')({
  server: {
    handlers: {
      GET: async () => {
        const nodeStream = await renderToStream(<GenerarCV />)
        const webStream = Readable.toWeb(nodeStream as unknown as Readable)

        return new Response(webStream as unknown as BodyInit, {
          headers: {
            'Content-Type': 'application/pdf',
            'Content-Disposition': 'inline; filename="cv-carlos.pdf"',
          },
        })
      },
    },
  },
})
