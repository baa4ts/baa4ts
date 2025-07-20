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
        { duration: 1, opacity: 1, y: 0, ease: 'back.out' }
      );
    }
  }, []);

  return (
    <CustomContenedor defaultSize className="mt-16 flex flex-col md:flex-row h-auto overflow-hidden">
      <section
        ref={refUsuario}
        className="basis-1/2 flex flex-col items-center justify-center overflow-hidden"
      >
        <img
          className="h-96 max-w-full rounded-lg shadow-md object-cover transition-transform duration-500 ease-in-out hover:scale-95"
          src="https://rule34storage.b-cdn.net/posts/911/911621/911621.picsmall.jpg"
          alt="User content"
          loading="lazy"
        />
      </section>
      <section className="basis-1/2 flex items-center justify-center text-xl font-semibold">2</section>
    </CustomContenedor>
  );
};
