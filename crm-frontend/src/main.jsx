import React, { useState } from 'react'
import ReactDOM from 'react-dom/client'
import './index.css'

import App from './App.jsx'
import Inicio from './inicio.jsx'
import Login from './login.jsx'
import Registro from './registro.jsx'

function Root() {
  const [vista, setVista] = useState("inicio");

  // Renderizado condicional devolviendo el componente correcto
  if (vista === "inicio") return <Inicio setVista={setVista} />;
  if (vista === "login") return <Login setVista={setVista} />;
  if (vista === "registro") return <Registro setVista={setVista} />;
  if (vista === "app") return <App setVista={setVista} />;

  return null;
}

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <Root />
  </React.StrictMode>,
)