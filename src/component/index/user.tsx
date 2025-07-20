import { useEffect, useRef, type JSX } from 'react';
import { CustomContenedor } from '../shared/customContenedor';
import { gsap } from 'gsap/gsap-core';

export const UserCompo = (): JSX.Element => {
  const refUserImg = useRef<HTMLDivElement>(null);
  const refUserText = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (refUserImg.current && refUserText.current) {
      gsap.fromTo(
        refUserImg.current,
        { opacity: 0, y: 150 },
        { duration: 1.5, opacity: 1, y: 0, stagger: 0.04, ease: 'power2.out' }
      );

      gsap.fromTo(
        refUserText.current,
        { opacity: 0, y: 150 },
        { duration: 1.5, opacity: 1, y: 0, stagger: 0.04, ease: 'power2.out' }
      );
    }
  }, []);

  return (
    <CustomContenedor defaultSize className="mt-5 lg:mt-16 flex flex-col md:flex-row h-auto overflow-hidden">
      <section
        ref={refUserImg}
        className="basis-1/2 flex flex-col items-center justify-center overflow-hidden md:mt-10"
      >
        <img
          className="h-60 md:h-50 lg:h-80 max-w-full rounded-lg shadow-md object-cover transition-transform duration-500 ease-in-out hover:scale-95"
          src="https://i.pinimg.com/736x/9e/e1/17/9ee117a4fcdce09aebf3fd0b516f3693.jpg"
          alt="User content"
          loading="lazy"
        />
      </section>

      <section ref={refUserText} className="basis-1/2 flex flex-col md:mt-10">
        <div className="flex flex-row">
          <h2 className="text-white-cream-vanill ml-5 mt-5 text-3xl font-black font-poppins border-b-4 border-b-white-cream-vanill">
            Sobre mí
          </h2>
        </div>
        <article className="mt-3.5 md:mt-0 mb-10">
          <p className="ml-5 mt-5 text-white font-poppins">
            Hola 👋, soy Carlos Morales, desarrollador backend especializado en Django y PHP. con con un
            conocimiento basico de html, css, js
          </p>
          <p className="ml-5 mt-5 text-white font-poppins">
            Actualmente estudiando la Tecnicatura en redes y software, y frontend para mejorar mis UI pedorras
            (
            <span style={{ color: '#61DAFB' }}>
              <a href="https://es.react.dev/">React</a>
            </span>
            <span style={{ color: '#FFFFFF' }}>, </span>
            <span style={{ color: '#3178C6' }}>
              <a href="https://www.typescriptlang.org/"></a>TypeScript
            </span>
            <span style={{ color: '#FFFFFF' }}>, </span>
            <span style={{ color: '#38BDF8' }}>
              <a href="https://tailwindcss.com/">Tailwind</a>
            </span>
            <span style={{ color: '#FFFFFF' }}>, </span>
            <span style={{ color: '#F97316' }}>
              <a href="https://tanstack.com/router/latest">TanStack Router</a>
            </span>
            )
          </p>
        </article>
      </section>
    </CustomContenedor>
  );
};
