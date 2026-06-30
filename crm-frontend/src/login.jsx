import { useState } from "react";

function Login({ setVista }) {

    const [email,setEmail]=useState("");
    const [password,setPassword]=useState("");

    async function ingresar(){

        try{

            const respuesta=await fetch(
                "http://127.0.0.1:8000/auth/login",
                {

                    method:"POST",

                    headers:{
                        "Content-Type":"application/json"
                    },

                    body:JSON.stringify({
                        email,
                        password
                    })

                }
            );

            const datos=await respuesta.json();

            if(respuesta.ok){

                localStorage.setItem(
                    "usuario",
                    JSON.stringify(datos.usuario)
                );

                setVista("app");

            }

            else{

                alert(datos.detail);

            }

        }

        catch{

            alert("No se pudo conectar con el servidor.");

        }

    }

    return(

        <div style={{padding:40}}>

            <h1>Login</h1>

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

            <button onClick={ingresar}>
                Ingresar
            </button>

            <br/><br/>

            <button onClick={()=>setVista("inicio")}>
                Volver
            </button>

        </div>

    );

}

export default Login;