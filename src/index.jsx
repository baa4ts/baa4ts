import { render } from "preact";
import { LocationProvider, Router, Route } from "preact-iso";

// import { Header } from './components/Header.jsx';
import { Home } from "./pages/Home/index.jsx";
import { NotFound } from "./pages/404/rutaNoValida.jsx";
import "./style.css";

// Componentes
import { Unami } from "./components/Analitics/Unami.jsx";

export function App() {
  return (
    <LocationProvider>
      {/* <Header /> */}
      <Unami />
      <main>
        <Router>
          <Route path="/" component={Home} />
          <Route default component={NotFound} />
        </Router>
      </main>
    </LocationProvider>
  );
}

render(<App />, document.getElementById("app"));
