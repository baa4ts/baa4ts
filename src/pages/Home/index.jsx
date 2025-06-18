import "./style.css";
import { Vista } from "../../components/global/Vista";
import { useEffect, useRef, useState } from "preact/hooks";
import logoSvg from "../../assets/LOGO.svg";
import gsap from "gsap";

export function Home() {
  const refLogoSvg = useRef(null);
  const refTitulo = useRef(null);

  // Mov svg
  useEffect(() => {
    gsap.from(refLogoSvg.current, {
      x: -450,
      duration: 2.5,
      ease: "power3.out",
    });

    // logo rotacion
    gsap.to(refLogoSvg.current, {
      rotation: "+=360",
      duration: 3,
      repeat: -1,
      ease: "linear",
    });

    // Titulo
    gsap.from(refTitulo.current, {
      opacity: 0,
      duration: 1.8,
      delay: 0.6,
      ease: "power1.in",
    });
  }, []);

  return (
    <Vista>
      <section className="Hero">
        <div className="HeroContenedor">
          <div className="HeroTitle">
            <h1 ref={refTitulo}>BAA4TS</h1>
          </div>
          <div className="HeroLogo">
            <img
              ref={refLogoSvg}
              src={logoSvg}
              alt="Logo de BAA4TS"
              height={128}
              width={128}
            />
          </div>
        </div>
      </section>
    </Vista>
  );
}
