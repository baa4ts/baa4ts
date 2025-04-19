import { CambiarTema } from "./../components/CambiarTema.js";
import { ScrollTop } from "../components/ScrollTop.js";
import { ScrollHaciaElemento } from "../components/ScrollHaciaElemento.js";

document.addEventListener("DOMContentLoaded", () => {
  // Cargar la config del tema
  if (sessionStorage.getItem("Esquema-colores-usuario") === "dark") {
    CambiarTema();
  }

  // Boton para cambiar de tema
  document.getElementById('CambiarTema').addEventListener('click', () => {
    CambiarTema();
  })

  // Boton para suvir el scroll al top
  document.getElementById('ScrollTop').addEventListener('click', () => {
    ScrollTop();
  })

  // Scroll ala seccion menu
  document.getElementById('ScrollMenu').addEventListener('click', () => {
    ScrollHaciaElemento('Menu')
  })



  document.querySelectorAll('.menu__sub__opcion h3').forEach((titulo) => {
    titulo.addEventListener('click', () => {
      document.querySelectorAll('.menu__sub__opcion').forEach((opcion) => {
        if (opcion !== titulo.parentElement) {
          opcion.classList.remove('activo');
        }
      });
      titulo.parentElement.classList.toggle('activo');
    });
  });
  

});
