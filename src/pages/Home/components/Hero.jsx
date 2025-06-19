import { useEffect, useRef } from "preact/hooks";
import gsap from "gsap";

import arrowSvg from "./../../../assets/arrow.svg";

export function Hero() {
  const refButton = useRef(null);

  useEffect(() => {
    gsap.fromTo(
      ".textoTitulo",
      {
        opacity: 0,
        x: 0,
        clipPath: "inset(0 100% 0 0)",
      },
      {
        opacity: 1,
        x: 0,
        clipPath: "inset(0 0% 0 0)",
        duration: 1,
        stagger: 0.15,
        ease: "power4.out",
      }
    );

    gsap.to(refButton.current, {
      y: -10,
      duration: 0.7,
      repeat: -1,
      yoyo: true,
      ease: "power1.inOut",
    });
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
        </div>
      </div>
      <button className="HeroContenedorButton centrado">
        <img ref={refButton} src={arrowSvg} alt="Flecha hacia abajo" />
      </button>
    </section>
  );
}
