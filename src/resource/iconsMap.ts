interface Icons {
  path: string;
  filter?: boolean;
  name: string;
}

export const iconResourceSkills: Icons[] = [
  {
    filter: false,
    name: 'python',
    path: 'https://upload.wikimedia.org/wikipedia/commons/c/c3/Python-logo-notext.svg',
  },
  {
    filter: false,
    name: 'css',
    path: 'https://upload.wikimedia.org/wikipedia/commons/a/ab/Official_CSS_Logo.svg',
  },
  {
    filter: false,
    name: 'html',
    path: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Devicon-html5-plain.svg/640px-Devicon-html5-plain.svg.png',
  },
  {
    filter: false,
    name: 'Js',
    path: 'https://upload.wikimedia.org/wikipedia/commons/9/99/Unofficial_JavaScript_logo_2.svg',
  },
  { filter: false, name: 'php', path: 'https://upload.wikimedia.org/wikipedia/commons/2/27/PHP-logo.svg' },
  { filter: true, name: 'django', path: '/assets/django.svg' },
  {
    filter: false,
    name: 'mysql',
    path: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Antu_mysql-workbench.svg/800px-Antu_mysql-workbench.svg.png?20160706123657',
  },
  {
    filter: false,
    name: 'docker',
    path: 'https://upload.wikimedia.org/wikipedia/commons/a/a7/Docker-svgrepo-com.svg',
  },
];

export const iconResourceStudy: Icons[] = [
  {
    filter: true,
    name: 'Tecnicatura en  Redes y Software',
    path: '/assets/lupa.svg',
  },
  { filter: true, name: 'react', path: 'https://upload.wikimedia.org/wikipedia/commons/a/a7/React-icon.svg' },
  {
    filter: true,
    name: 'typescript',
    path: 'https://upload.wikimedia.org/wikipedia/commons/4/4c/Typescript_logo_2020.svg',
  },
  {
    filter: true,
    name: 'tailwindcss',
    path: 'https://upload.wikimedia.org/wikipedia/commons/d/d5/Tailwind_CSS_Logo.svg',
  },
  { filter: false, name: 'TanStack', path: 'http://tanstack.com/assets/splash-dark-8nwlc0Nt.png' },
];
