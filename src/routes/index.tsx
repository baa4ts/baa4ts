import type { JSX } from "react";
import { createFileRoute } from "@tanstack/react-router";
import { ButtonCambiarTema } from "../components/shared/ButtonCambiarTema";
import { Header } from "../components/pages/index/Header";
import { About } from "../components/pages/index/About";

export const Route = createFileRoute("/")({
  component: RouteComponent,
});

function RouteComponent(): JSX.Element {
  return (
    <main className="flex flex-col items-center">
      {/* Boton para cambiar el tema */}
      <ButtonCambiarTema />

      {/* Hero  */}
      <Header />

      {/* About */}
      <About />
    </main>
  );
}
