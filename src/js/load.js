(() => {
  // Detectar si el esquema de color del sistema es oscuro
  const temaOscuro = window.matchMedia("(prefers-color-scheme: dark)").matches;

  sessionStorage.setItem(
    "Esquema-colores-usuario",
    temaOscuro ? "dark" : "light"
  );
})();
