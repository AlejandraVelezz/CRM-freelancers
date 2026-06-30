import { useState } from "react";

function Registro({ setVista }) {

    const [nombre, setNombre] = useState("");
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");

    async function registrar() {

        try {

            const respuesta = await fetch(
                "http://127.0.0.1:8000/auth/registro",
                {
                    method: "POST",

                    headers: {
                        "Content-Type": "application/json"
                    },

                    body: JSON.stringify({
                        nombre,
                        email,
                        password,
                        tipo_usuario: "usuario"
                    })
                }
            );

            const datos = await respuesta.json();

            if (respuesta.ok) {

                alert("Usuario registrado correctamente");

                setVista("login");

            } else {

                alert(datos.detail);

            }

        } catch {

            alert("No fue posible conectar con el servidor.");

        }

    }

    return (

        <div style={{ padding: 40 }}>

            <h1>Registro</h1>

            <input
                placeholder="Nombre"
                value={nombre}
                onChange={(e)=>setNombre(e.target.value)}
            />

            <br/><br/>

            <input
                placeholder="Correo"
                value={email}
                onChange={(e)=>setEmail(e.target.value)}
            />

            <br/><br/>

            <input
                type="password"
                placeholder="Contraseña"
                value={password}
                onChange={(e)=>setPassword(e.target.value)}
            />

            <br/><br/>

            <button onClick={registrar}>
                Registrarme
            </button>

            <br/><br/>

            <button onClick={()=>setVista("inicio")}>
                Volver
            </button>

        </div>

    );

}

export default Registro;