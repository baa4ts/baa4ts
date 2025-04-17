import { CambiarTema } from "./../components/CambiarTema.js";

document.addEventListener("DOMContentLoaded", () => {
  if (sessionStorage.getItem("Esquema-colores-usuario") === "dark") {
    CambiarTema();
  }


  document.getElementById('CambiarTema').addEventListener('click', () => {
    CambiarTema();
  })
});
