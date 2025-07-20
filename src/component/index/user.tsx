import { useEffect, useRef, type JSX } from 'react';
import { CustomContenedor } from '../shared/customContenedor';
import { gsap } from 'gsap/gsap-core';

export const UserCompo = (): JSX.Element => {
  const refUsuario = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (refUsuario.current) {
      gsap.fromTo(
        refUsuario.current,
        { opacity: 0, y: 150 },
        { duration: 1, opacity: 1, y: 0, stagger: 0.04, ease: 'power2.out' }
      );
    }
  }, []);

  return (
    <CustomContenedor defaultSize className="mt-5 lg:mt-16 flex flex-col md:flex-row h-auto overflow-hidden">
      <section
        ref={refUsuario}
        className="basis-1/2 flex flex-col items-center justify-center overflow-hidden md:mt-10 "
      >
        <img
          className="h-60 md:h-50 lg:h-80 max-w-full rounded-lg shadow-md object-cover transition-transform duration-500 ease-in-out hover:scale-95"
          src="https://i.pinimg.com/736x/9e/e1/17/9ee117a4fcdce09aebf3fd0b516f3693.jpg"
          alt="User content"
          loading="lazy"
        />
      </section>
      <section className="basis-1/2 flex flex-col md:mt-10">
        <div className="flex flex-row">
          <h2 className="text-white-cream-vanill ml-5 mt-5 text-3xl font-black font-poppins">Sobre mí</h2>
        </div>
        <article>
          <p className="ml-5 mt-5 text-white">
            Hola 👋, soy Carlos Morales desarollador backend especializado en django y php
          </p>
        </article>
      </section>
    </CustomContenedor>
  );
};
