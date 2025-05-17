document.addEventListener("DOMContentLoaded", () => {
    const TemaActual = document.documentElement.getAttribute('data-scheme');

    if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
        CambiarTema();
    }

    const boton = document.getElementById('HandleTema');
    if (boton) {
        boton.addEventListener('click', () => {
            CambiarTema();
        });
    }

    const MovimientoHero = document.getElementById('HandleHero');
    const Hero = document.getElementById('Hero');

    if (MovimientoHero && Hero) {
        MovimientoHero.addEventListener('click', () => {
            Hero.scrollIntoView({ behavior: 'smooth' });
        });
    }

});

function CambiarTema() {
    const actual = document.documentElement.getAttribute('data-scheme');
    const nuevoTema = actual === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-scheme', nuevoTema);
}