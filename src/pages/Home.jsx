import React, { useEffect, useState } from "react";
import { motion } from "framer-motion";
import "../styles/Home.css";

export const Home = () => {
  const [username, setUsername] = useState(null);
  const [repositorios, setRepositorios] = useState(null);
  const [estrellas, setEstrellas] = useState(null);
  const [seguidores, setSeguidores] = useState(null);

  const obtenerPerfil = async () => {
    try {
      const response = await fetch("https://api.github.com/users/baa4ts");

      if (!response.ok) {
        alert("Error al obtener los datos");
        return null;
      }

      return await response.json();
    } catch {
      alert("Error de red al obtener el perfil");
      return null;
    }
  };

  const obtenerRepositorios = async () => {
    try {
      const response = await fetch("https://api.github.com/users/baa4ts/repos");

      if (!response.ok) {
        alert("Error al obtener repositorios");
        return null;
      }
      return await response.json();
    } catch {
      alert("Error de red al obtener repositorios");
      return null;
    }
  };

  useEffect(() => {
    const cargarDatos = async () => {
      const data = await obtenerPerfil();

      if (data) {
        setUsername(data.login);
        setRepositorios(data.public_repos);
        setSeguidores(data.followers);
      }

      const repos = await obtenerRepositorios();

      if (repos) {
        const totalEstrellas = repos.reduce(
          (total, repo) => total + repo.stargazers_count,
          0
        );

        setEstrellas(totalEstrellas);
      }
    };

    cargarDatos();
  }, []);

  return (
    <section className="hero">
      <div>
        {username ? (
          <motion.div
            className="HeroContenenedorTitulo"
            initial={{ opacity: 0, y: 100 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 1, ease: "easeOut" }}
          >
            <h1 className="heroTitulo">{username.toUpperCase()}</h1>
            <div className="heroContenedorStats">
              <div>Repositorios: {repositorios}</div>
              <div>Seguidores: {seguidores}</div>
              <div>Estrellas totales: {estrellas}</div>
            </div>
          </motion.div>
        ) : (
          <p>Cargando...</p>
        )}
      </div>
    </section>
  );
};
