import { HeadContent, Scripts, createRootRoute } from '@tanstack/react-router'
import { TanStackRouterDevtoolsPanel } from '@tanstack/react-router-devtools'
import { TanStackDevtools } from '@tanstack/react-devtools'

import appCss from '../styles.css?url'

export const Route = createRootRoute({
  head: () => {
    //  URL dinamica
    const currentUrl = typeof window !== 'undefined' ? window.location.href : 'https://baa4ts.is-a-good.dev/';

    return {
      meta: [
        {
          charSet: 'utf-8',
        },
        {
          name: 'viewport',
          content: 'width=device-width, initial-scale=1',
        },
        {
          title: 'baa4ts',
        },
        {
          name: 'description',
          content: 'baa4ts desarrollador backend, tecnologias modernas, soluciones escalables con React, TypeScript, JavaScript y Express.js.',
        },
        {
          property: 'og:title',
          content: 'baa4ts',
        },
        {
          property: 'og:description',
          content: 'baa4ts desarrollador backend, tecnologias modernas, soluciones escalables con React, TypeScript, JavaScript y Express.js.',
        },
        {
          property: 'og:type',
          content: 'website',
        },
        {
          property: 'og:image',
          content: 'https://i.pinimg.com/1200x/44/c4/83/44c4837d944315f8f4bcb7f9e65e63ad.jpg',
        },
        {
          property: 'og:site_name',
          content: 'baa4ts',
        },
        {
          property: 'og:url',
          content: currentUrl,
        },
        {
          name: 'twitter:title',
          content: 'baa4ts',
        },
        {
          name: 'twitter:description',
          content: 'baa4ts desarrollador backend, tecnologias modernas, soluciones escalables con React, TypeScript, JavaScript y Express.js.',
        },
        {
          name: 'twitter:image',
          content: 'https://i.pinimg.com/1200x/44/c4/83/44c4837d944315f8f4bcb7f9e65e63ad.jpg',
        },
        {
          name: 'twitter:url',
          content: currentUrl,
        },
        {
          property: 'og:url',
          content: currentUrl,
        },
      ],
      links: [
        {
          rel: 'stylesheet',
          href: appCss,
        },
      ],
    };
  },
  notFoundComponent: () => <div>Pagina no encontrada 😢</div>,
  shellComponent: RootDocument,
});

function RootDocument({ children }: { children: React.ReactNode }) {
  return (
    <html lang="es">
      <head>
        <HeadContent />
      </head>
      <body className="bg-black bg-fill bg-center bg-no-repeat bg-fixed">
        {children}
        <TanStackDevtools
          config={{ position: 'bottom-right' }}
          plugins={[
            {
              name: 'Tanstack Router',
              render: <TanStackRouterDevtoolsPanel />,
            },
          ]}
        />
        <Scripts />
      </body>
    </html>
  )
}
