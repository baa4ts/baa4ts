import { useEffect, useRef, type JSX } from 'react';
import { CustomContenedor } from '../shared/customContenedor';
import { gsap } from 'gsap';
import { SplitText } from 'gsap/SplitText';

export const TitleCompo = (): JSX.Element => {
  const refTitle = useRef<HTMLHeadingElement>(null);

  useEffect(() => {
    gsap.registerPlugin(SplitText);

    if (refTitle.current) {
      const split = new SplitText(refTitle.current, { type: 'chars' });

      gsap.from(split.chars, {
        duration: 2,
        opacity: 0,
        y: -150,
        stagger: 0.09,
        ease: 'power2.out',
      });

      return () => {
        split.revert();
      };
    }
  }, []);

  return (
    <CustomContenedor defaultSize className="flex h-48 items-center justify-center overflow-hidden">
      <h1
        ref={refTitle}
        className="mt-10 text-6xl sm:text-7xl md:text-8xl lg:text-[10rem] font-poppins font-black text-white-cream-vanill will-change-transform"
      >
        baa4ts
      </h1>
    </CustomContenedor>
  );
};
