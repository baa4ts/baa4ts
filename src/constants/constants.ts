export const constants = {
  PERFIL:
    'https://i.pinimg.com/1200x/95/e7/cc/95e7ccfd7ad1cd41012bcd70c160e669.jpg',
  USERNAME: 'Carlos Guillermo Morales Cardozo',
  BIO: 'Estudiante de Tecnicatura en Redes y Software, con enfoque en desarrollo backend con TypeScript y Node.js. Con experiencia en diseno de APIs REST, bases de datos relacionales y despliegue con Docker. Orientado al trabajo remoto y al desarrollo de herramientas open-source.',
  TECH: [
    { color: '#F59E0B', categoria: 'Lenguaje' },
    { color: '#3B82F6', categoria: 'Backend' },
    { color: '#A855F7', categoria: 'Frontend' },
    { color: '#EF4444', categoria: 'DevOps' },
    { color: '#06B6D4', categoria: 'Database' },
  ],
  PROJECT: [
    {
      name: 'craft9bind',
      type: 'frontend',
      desc: 'Aplicación web para diseñar, validar y exportar configuraciones BIND9 (zonas, registros y RPZ). Ofrece gestión de zonas y registros (A, AAAA, CNAME, MX, TXT, SRV), validaciones, import/export, vista previa y exportación de archivos/listas listos para deploy.',
      tech: [
        'React',
        'TanStack',
        'Zustand',
        'TypeScript',
        'Shadcn',
        'Tailwind',
      ],
      web: 'https://craft9bind.vercel.app',
      github: 'https://github.com/baa4ts/craft9bind',
    },
    {
      name: 'crypto-edge',
      type: 'libreria',
      desc: 'Wrapper ligero sobre la Web Crypto API que ofrece hashing (SHA-1/256/384/512), cifrado AES (GCM/CBC/CTR), firmas (HMAC, ECDSA, RSA), gestión de claves y utilidades Base64. Soporta navegadores y runtimes edge (Cloudflare Workers, Vercel Edge Functions).',
      tech: [
        'TypeScript',
        'rslib',
        'rstest',
        'Web Crypto API',
        'GitHub Actions for Testing',
      ],
      npm: 'https://www.npmjs.com/package/crypto-edge',
      github: 'https://github.com/baa4ts/crypto-edge',
      test: 'https://github.com/baa4ts/crypto-edge/actions/runs/30565721166',
    },
    {
      name: 'compress-edge',
      type: 'libreria',
      desc: 'Wrapper ligero sobre la Compression Streams API que ofrece compresión y descompresión (gzip, deflate, deflate-raw) para string, Blob, ArrayBuffer y Uint8Array; API basada en promesas y errores personalizados. Soporta navegadores y runtimes edge (Cloudflare Workers, Vercel Edge Functions).',
      tech: [
        'TypeScript',
        'rslib',
        'rstest',
        'Compression Streams API',
        'GitHub Actions for Testing',
      ],
      npm: 'https://www.npmjs.com/package/compress-edge',
      github: 'https://github.com/baa4ts/compress-edge',
      test: 'https://github.com/baa4ts/compress-edge/actions/runs/30383475532',
    },
  ],
  CV: {
    metadata: {
      title: 'Carlos Morales - CV',
      author: 'Carlos Morales',
      subject: 'Curriculum Vitae',
      keywords: 'redes, software, uruguay, cv',
      creator: 'baa4ts.is-a.dev',
      producer: '@react-pdf/renderer',
      language: 'es',
    },
  },
  proyectos: [
    {
      name: 'craft9bind',
      repo: 'github/baa4ts/craft9bind',
      repolink: 'https://github.com/baa4ts/craft9bind',

      descripcion:
        'Aplicación web para diseñar, validar y exportar configuraciones BIND9 (zonas, registros y RPZ). Ofrece gestión de zonas y registros (A, AAAA, CNAME, MX, TXT, SRV), validaciones, import/export, vista previa y exportación de archivos/listas listos para deploy.',
      tecnologias: [
        'React',
        'TanStack',
        'Zustand',
        'TypeScript',
        'Shadcn',
        'Tailwind',
      ],
    },
    {
      name: 'crypto-edge',
      repo: 'github/baa4ts/crypto-edge',
      repolink: 'https://github.com/baa4ts/crypto-edge',
      descripcion:
        'Wrapper ligero sobre la Web Crypto API que ofrece hashing (SHA-1/256/384/512), cifrado AES (GCM/CBC/CTR), firmas (HMAC, ECDSA, RSA), gestión de claves y utilidades Base64. Soporta navegadores y runtimes edge (Cloudflare Workers, Vercel Edge Functions).',
      tecnologias: [
        'TypeScript',
        'Rslib',
        'Rstest',
        'node.js',
        'Github actions',
        'Web Crypto API',
      ],
    },
    {
      name: 'compress-edge',
      repo: 'github/baa4ts/compress-edge',
      repolink: 'https://github.com/baa4ts/compress-edge',
      descripcion:
        'Wrapper ligero sobre la Compression Streams API que ofrece compresión y descompresión (gzip, deflate, deflate-raw) para string, Blob, ArrayBuffer y Uint8Array; API basada en promesas y errores personalizados. Soporta navegadores y runtimes edge (Cloudflare Workers, Vercel Edge Functions).',
      tecnologias: [
        'TypeScript',
        'Rslib',
        'Rstest',
        'node.js',
        'Github actions',
        'Compression Streams API',
      ],
    },
  ],
} as const
