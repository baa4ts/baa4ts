export function CambiarTema() {
  const TemaActual = document.documentElement.getAttribute("data-scheme");
  const NuevoTema = TemaActual === "light" ? "dark" : "light";
  document.documentElement.setAttribute("data-scheme", NuevoTema);
}
