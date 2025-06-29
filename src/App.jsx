import React from "react";
import { Routes, Route } from "react-router-dom";
import "./styles/fonts.css";
import "./styles/base.css";

// Rutas
import { Home } from "./pages/Home.jsx";

function App() {
  return (
    <>
      <Routes>
        <Route path="/" element={<Home />} />
      </Routes>
    </>
  );
}

export default App;
