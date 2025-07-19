import { useNavigate } from "@tanstack/react-router";
import { createFileRoute } from "@tanstack/react-router";
import { Home, AlertTriangle } from "lucide-react";

export const Route = createFileRoute("/$404")({
  component: RouteComponent,
});

function RouteComponent() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-black flex items-center justify-center p-4">
      <div className="w-full max-w-md bg-gradient-to-br from-gray-900 to-black border border-purple-500/30 rounded-lg p-8 text-center shadow-2xl shadow-purple-500/20">
        <div className="mb-6">
          <AlertTriangle className="w-16 h-16 text-yellow-400 mx-auto mb-4 animate-pulse" />
          <div className="text-8xl font-bold bg-gradient-to-r from-cyan-400 via-purple-500 to-pink-500 bg-clip-text text-transparent mb-2">
            404
          </div>
          <div className="w-16 h-1 bg-gradient-to-r from-cyan-400 to-purple-500 mx-auto rounded-full"></div>
        </div>

        <h1 className="text-2xl font-bold text-white mb-3">
          Página no encontrada
        </h1>

        <p className="text-gray-300 mb-8 leading-relaxed">
          Lo sentimos, la página que estás buscando no existe o ha sido movida.
          Verifica la URL o regresa al inicio.
        </p>

        <div className="space-y-3">
          <button
            className="w-full bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-700 hover:to-pink-700 text-white font-semibold py-3 px-4 rounded-lg transition-all duration-300 hover:scale-105 flex items-center justify-center gap-2 hover:cursor-pointer"
            onClick={() => navigate({ to: "/" })}
          >
            <Home className="w-4 h-4" />
            Ir al inicio
          </button>
        </div>
      </div>
    </div>
  );
}
