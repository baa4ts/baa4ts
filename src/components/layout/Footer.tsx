// src/components/layout/Footer.tsx
import { Link } from '@tanstack/react-router';

type FooterLink = { label: string; to: string; external?: boolean };

const FooterLinks = ({ title, links }: { title: string; links: FooterLink[] }) => (
  <article className="m-6 flex flex-1/2 flex-col">
    <h3 className="text-white-cream-vanill">{title}</h3>
    <div className="ml-10 mt-5 flex flex-row gap-5">
      <div className="flex flex-col gap-5">
        {links.slice(0, 3).map((link, i) =>
          link.external ? (
            <a
              key={i}
              href={link.to}
              target="_blank"
              rel="noopener noreferrer"
              className="cursor-pointer text-gray-400 transition-transform duration-300 ease-in-out hover:scale-110 hover:text-pink-punchy-pink"
            >
              {link.label}
            </a>
          ) : (
            <Link
              key={i}
              to={link.to}
              className="cursor-pointer text-gray-400 transition-transform duration-300 ease-in-out hover:scale-110 hover:text-pink-punchy-pink"
            >
              {link.label}
            </Link>
          )
        )}
      </div>
      <div className="ml-10 flex flex-col gap-5">
        {links.slice(3).map((link, i) =>
          link.external ? (
            <a
              key={i}
              href={link.to}
              target="_blank"
              rel="noopener noreferrer"
              className="cursor-pointer text-gray-400 transition-transform duration-300 ease-in-out hover:scale-110 hover:text-pink-punchy-pink"
            >
              {link.label}
            </a>
          ) : (
            <Link
              key={i}
              to={link.to}
              className="cursor-pointer text-gray-400 transition-transform duration-300 ease-in-out hover:scale-110 hover:text-pink-punchy-pink"
            >
              {link.label}
            </Link>
          )
        )}
      </div>
    </div>
  </article>
);

export const Footer = () => (
  <footer className="mt-16 flex w-full flex-col bg-black">
    <section className="flex flex-row">
      <div>
        <img
          className="m-5 h-[46px] w-[46px] rounded-full"
          src="https://i.pinimg.com/736x/9e/e1/17/9ee117a4fcdce09aebf3fd0b516f3693.jpg"
          alt="Avatar"
        />
      </div>
      <div className="flex flex-col justify-center font-consolas">
        <h2 className="text-white-cream-vanill">Carlos Morales. Alias: baa4ts</h2>
        <p className="text-gray-400">Desarrollador backend</p>
      </div>
    </section>

    <section className="flex flex-col bg-black font-consolas md:flex-row">
      <FooterLinks
        title="Contacto"
        links={[
          { label: 'LinkedIn', to: 'https://uy.linkedin.com/in/carlos-morales-baa4ts', external: true },
          { label: 'GitHub', to: 'https://github.com/baa4ts', external: true },
        ]}
      />
      <FooterLinks
        title="Enlaces del sitio"
        links={[
          { label: 'Home', to: '/' },
          { label: 'Blog', to: '/blog' },
          { label: 'Project', to: '/project' },
          { label: 'About', to: '/about' },
          { label: 'Contact', to: '/contact' },
        ]}
      />
    </section>
  </footer>
);
