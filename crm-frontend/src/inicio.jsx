import React from 'react';

function Inicio({ setVista }) {
  return (
    <div style={{
      minHeight: "100vh",
      display: "flex",
      justifyContent: "center",
      alignItems: "center",
      background: "#f4f6f9",
      fontFamily: "Arial"
    }}>
      <div style={{
        background: "white",
        padding: "40px",
        borderRadius: "12px",
        width: "380px",
        textAlign: "center",
        boxShadow: "0 8px 25px rgba(0,0,0,0.12)"
      }}>
        <h1>CRM Freelancers</h1>
        <p>Selecciona una opción para continuar</p>
        
        <button 
          onClick={() => setVista("login")}
          style={{
            width: "100%",
            padding: "12px",
            marginTop: "20px",
            background: "#007bff",
            color: "white",
            border: "none",
            borderRadius: "8px",
            cursor: "pointer"
          }}
        >
          Ingresar
        </button>
      </div>
    </div>
  );
}

export default Inicio;