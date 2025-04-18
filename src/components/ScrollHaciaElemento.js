export function ScrollHaciaElemento(id) {
    const Elemento = document.getElementById(id);
    if (Elemento) {
        Elemento.scrollIntoView({ behavior: "smooth" })
    }
}