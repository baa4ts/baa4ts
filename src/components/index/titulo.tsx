import type { JSX } from 'react';
import { useEffect, useRef } from 'react';
import { CustomContenedor } from '../shared/customContenedor';

import { SplitText } from 'gsap/SplitText';
import gsap from 'gsap';

export const Titulo = (): JSX.Element => {
  // Referencia para gsap
  gsap.registerPlugin(SplitText);
  const tituloRef: React.RefObject<HTMLDivElement | null> = useRef<HTMLDivElement>(null);

  // Animacion
  useEffect(() => {
    if (!tituloRef.current) return;

    const split: SplitText = new SplitText(tituloRef.current, { type: 'chars' });

    gsap.from(split.chars, {
      opacity: 0,
      y: -150,
      stagger: 0.1,
      duration: 1.5,
      ease: 'power3.out',
    });

    return () => split.revert();
  }, []);

  return (
    <CustomContenedor defaultSize={true} className="h-48 flex items-center justify-center bg-transparent">
      <div ref={tituloRef}>
        <h1 className="text-cream-vanilla upper text-7xl md:text-9xl font-poppins font-extrabold">baa4ts</h1>
      </div>
    </CustomContenedor>
  );
};
