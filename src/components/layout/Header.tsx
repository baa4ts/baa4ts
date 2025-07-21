// src/components/layout/Header.tsx
import { useState } from 'react';
import { Menu, X } from 'lucide-react';
import { Link } from '@tanstack/react-router';

export const Header = () => {
  const [isOpen, setIsOpen] = useState(false);

  const toggleMenu = () => setIsOpen(!isOpen);
  const closeMenu = () => setIsOpen(false);

  return (
    <header className="fixed top-0 left-0 z-50 w-full bg-black text-white-cream-vanill font-consolas">
      <nav className="flex h-16 items-center justify-between px-4 md:px-8">
        <div className="font-consolas text-[20px] font-bold">baa4ts</div>

        {/* Desktop Menu */}
        <ul className="hidden gap-6 md:flex">
          <li>
            <Link to="/" className="hover:text-pink-punchy-pink">
              Home
            </Link>
          </li>
          <li>
            <Link to="/blog" className="hover:text-pink-punchy-pink">
              Blog
            </Link>
          </li>
          <li>
            <Link to="/Project" className="hover:text-pink-punchy-pink">
              Proyectos
            </Link>
          </li>
          <li>
            <Link to="/About" className="hover:text-pink-punchy-pink">
              Sobre mí
            </Link>
          </li>
          <li>
            <Link to="/Contact" className="hover:text-pink-punchy-pink">
              Contacto
            </Link>
          </li>
        </ul>

        {/* Mobile Hamburger Button */}
        <button className="md:hidden" onClick={toggleMenu} aria-label="Abrir menú">
          {isOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
        </button>
      </nav>

      {/* Mobile Dropdown Menu con transición */}
      <div
        className={`overflow-hidden transition-all duration-300 md:hidden ${
          isOpen ? 'max-h-96 py-4' : 'max-h-0 py-0'
        }`}
      >
        <ul className="flex flex-col gap-4 bg-black px-4">
          <li>
            <Link to="/" onClick={closeMenu} className="block hover:text-pink-punchy-pink">
              Home
            </Link>
          </li>
          <li>
            <Link to="/blog" onClick={closeMenu} className="block hover:text-pink-punchy-pink">
              Blog
            </Link>
          </li>
          <li>
            <Link to="/Project" onClick={closeMenu} className="block hover:text-pink-punchy-pink">
              Proyectos
            </Link>
          </li>
          <li>
            <Link to="/About" onClick={closeMenu} className="block hover:text-pink-punchy-pink">
              Sobre mí
            </Link>
          </li>
          <li>
            <Link to="/Contact" onClick={closeMenu} className="block hover:text-pink-punchy-pink">
              Contacto
            </Link>
          </li>
        </ul>
      </div>
    </header>
  );
};
