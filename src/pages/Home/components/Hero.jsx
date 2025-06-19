import { useEffect, useRef } from "preact/hooks";
import starSvg from "./../../../assets/LOGO.svg";
import gsap from "gsap";

import arrowSvg from "./../../../assets/arrow.svg";

export function Hero() {
  const refArrow = useRef(null);

  useEffect(() => {
    gsap.fromTo(
      ".textoTitulo",
      {
        opacity: 0,
        x: 0,
        clipPath: "inset(100% 100% 0 0)",
      },
      {
        opacity: 1,
        x: 0,
        clipPath: "inset(0% 0% 0 0)",
        duration: 1,
        stagger: 0.2,
        ease: "power4.out",
      }
    );
  }, []);

  const letras = ["B", "A", "A", "4", "T", "S"];

  return (
    <section className="Hero centrado">
      <div className="HeroContenedor centrado">
        <div className="HeroTitle centrado">
          {letras.map((letra, index) => (
            <h1 key={index} className="textoTitulo titulo">
              {letra}
            </h1>
          ))}
          <div></div>
        </div>
      </div>
    </section>
  );
}
