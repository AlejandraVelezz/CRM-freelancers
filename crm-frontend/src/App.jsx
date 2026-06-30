import React, { useState, useEffect } from 'react';
import ProyectosCliente from './ProyectosCliente';
import axios from 'axios';

function App() {
  const API_CLIENTES = "http://127.0.0.1:8000/clientes/";
  const API_IA = "http://127.0.0.1:8000/ia/generar-correo";
  const API_PROYECTOS = "http://127.0.0.1:8000/proyectos/";
  const API_TAREAS = "http://127.0.0.1:8000/tareas/";

  // Estados de Clientes
  const [clientes, setClientes] = useState([]);
  const [proyectoIA, setProyectoIA] = useState('');
  const [proyectosIA, setProyectosIA] = useState([]);
  const [nombre, setNombre] = useState('');
  const [empresa, setEmpresa] = useState('');
  const [email, setEmail] = useState('');
  const [telefono, setTelefono] = useState('');
  const [clienteSeleccionado, setClienteSeleccionado] = useState(null);

  // Estado para controlar cuál menú desplegable (opciones) está abierto por ID de cliente
  const [clienteMenuAbiertoId, setClienteMenuAbiertoId] = useState(null);

  // Estados de Proyectos
  const [proyectosCliente, setProyectosCliente] = useState([]);
  const [nombreProyecto, setNombreProyecto] = useState('');
  const [descProyecto, setDescProyecto] = useState('');
  const [proyectoSeleccionadoId, setProyectoSeleccionadoId] = useState(null);

  // Estados de Tareas
  const [tareasProyecto, setTareasProyecto] = useState([]);
  const [tituloTarea, setTituloTarea] = useState('');

  // Estados de la IA
  const [clienteIA, setClienteIA] = useState(null);
  const [detalleProyecto, setDetalleProyecto] = useState('');
  const [tono, setTono] = useState('profesional');
  const [correoGenerado, setCorreoGenerado] = useState('');
  const [cargandoIA, setCargandoIA] = useState(false);
  const [historialCorreos, setHistorialCorreos] = useState([]);
  const [correoSeleccionado, setCorreoSeleccionado] = useState(null);
  const [mostrarCorreoCompleto, setMostrarCorreoCompleto] = useState(false);

  // Función de optimización declarada y cerrada correctamente
  const optimizeObtenerClientes = async () => {
    try {
      const res = await axios.get(API_CLIENTES);
      setClientes(res.data);
    } catch (error) {
      console.error("Error al obtener clientes:", error);
    }
  };

  // El useEffect ahora está en el nivel superior del componente
  useEffect(() => {
    optimizeObtenerClientes();
  }, []);

  const guardarCliente = async (e) => {
    e.preventDefault();
    try {
      await axios.post(API_CLIENTES, { nombre, empresa, email, telefono });
      alert("¡Cliente registrado!");
      setNombre(''); setEmpresa(''); setEmail(''); setTelefono('');
      optimizeObtenerClientes();
    } catch (error) {
      console.error(error);
      alert("Error al guardar cliente");
    }
  };

 const cargarHistorialCorreos = async (clienteId) => {

    try {

        const res = await axios.get(
            `http://127.0.0.1:8000/clientes/${clienteId}/correos`
        );

        console.log("HISTORIAL COMPLETO");

        console.table(res.data);

        setHistorialCorreos(res.data);

    } catch (error) {

        console.error(error);

    }

};

  const guardarCorreoEnHistorial = async () => {
    if (!clienteIA || !correoGenerado) {
      alert("No hay un cliente seleccionado o un correo generado para guardar.");
      return;
    }
    try {
      await axios.post(`http://127.0.0.1:8000/clientes/${clienteIA.id}/correos`, {
        proyecto: proyectoIA,
        contenido: correoGenerado,
        fecha: new Date().toISOString()
      });
      alert("¡Correo registrado con éxito en el expediente del cliente!");
      if (clienteSeleccionado && clienteSeleccionado.id === clienteIA.id) {
        cargarHistorialCorreos(clienteIA.id);
      }
    } catch (error) {
      console.error("Error al guardar el correo:", error);
      alert("No se pudo registrar el correo en la base de datos.");
    }
  };

  const seleccionarClienteDetalle = async (cliente) => {
    setClienteSeleccionado(cliente);
    setProyectoSeleccionadoId(null);
    setTareasProyecto([]);
    try {
      const res = await axios.get(`${API_PROYECTOS}cliente/${cliente.id}`);
      setProyectosCliente(res.data);
      cargarHistorialCorreos(cliente.id);
    } catch (error) {
      console.error(error);
    }
  };

  const cargarProyectosIA = async (clienteId) => {
    try {
      const res = await axios.get(`${API_PROYECTOS}cliente/${clienteId}`);
      setProyectosIA(res.data);
    } catch (error) {
      console.error(error);
    }
  };

  const guardarProyecto = async (e) => {
    e.preventDefault();
    try {
      await axios.post(API_PROYECTOS, { nombre: nombreProyecto, descripcion: descProyecto, cliente_id: clienteSeleccionado.id });
      alert("¡Proyecto asignado!");
      setNombreProyecto(''); setDescProyecto('');
      seleccionarClienteDetalle(clienteSeleccionado);
    } catch (error) {
      alert("Error al guardar proyecto");
    }
  };

  const verTareasProyecto = async (proyectoId) => {
    setProyectoSeleccionadoId(proyectoId);
    try {
      const res = await axios.get(`${API_TAREAS}proyecto/${proyectoId}`);
      setTareasProyecto(res.data);
    } catch (error) {
      console.error(error);
    }
  };

  const guardarTarea = async (e) => {
    e.preventDefault();
    try {
      await axios.post(API_TAREAS, { titulo: tituloTarea, proyecto_id: proyectoSeleccionadoId });
      setTituloTarea('');
      verTareasProyecto(proyectoSeleccionadoId);
    } catch (error) {
      console.error(error);
      alert("Error al guardar tarea");
    }
  };

  const completarTarea = async (tareaId, estadoActual) => {
    const nuevoEstado = estadoActual === "Completada" ? "Pendiente" : "Completada";
    try {
      await axios.put(`${API_TAREAS}${tareaId}/cambiar-estado?estado=${nuevoEstado}`);
      verTareasProyecto(proyectoSeleccionadoId);
    } catch (error) {
      console.error(error);
    }
  };

  const generarTextoIA = async (e) => {
    e.preventDefault();
    setCargandoIA(true);
    setCorreoGenerado('');
    try {
      const res = await axios.post(API_IA, {
        clienteId: clienteIA?.id,
        nombre_cliente: clienteIA?.nombre,
        proyecto_detalle: `Proyecto: ${proyectoIA}\n\n${detalleProyecto}`,
        tono: tono
      });
      setCorreoGenerado(res.data.correo_generado);
    } catch (error) {
      console.error("Error capturado de la IA:", error.response?.data || error.message);
      alert("Error con la IA: Revisa la consola de tu servidor de Python para ver el rastro.");
    } finally {
      setCargandoIA(false);
    }
  };



  return (
    <div style={{ padding: '20px', fontFamily: 'Arial, sans-serif', maxWidth: '1300px', margin: '0 auto' }}>
      <h1>💼 CRM Inteligente para Freelancers</h1>
      <hr />

      <div style={{ display: 'flex', gap: '25px', marginTop: '20px' }}>

        {/* COLUMNA 1: CLIENTES */}
        <div style={{ flex: 1 }}>
          <h3>👥 Nuevo Cliente</h3>
          <form onSubmit={guardarCliente} style={{ display: 'flex', flexDirection: 'column', gap: '8px', marginBottom: '20px' }}>
            <input type="text" placeholder="Nombre" value={nombre} onChange={e => setNombre(e.target.value)} required style={{ padding: '6px' }} />
            <input type="text" placeholder="Empresa" value={empresa} onChange={e => setEmpresa(e.target.value)} style={{ padding: '6px' }} />
            <input type="email" placeholder="Correo" value={email} onChange={e => setEmail(e.target.value)} required style={{ padding: '6px' }} />
            <input type="text" placeholder="Teléfono" value={telefono} onChange={e => setTelefono(e.target.value)} style={{ padding: '6px' }} />
            <button type="submit" style={{ padding: '6px', background: '#007bff', color: 'white', border: 'none', cursor: 'pointer' }}>Guardar</button>
          </form>

          <h4>📋 Lista de Clientes</h4>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
            {clientes.map(c => (
              <div
                key={c.id}
                style={{
                  padding: '12px',
                  background: clienteSeleccionado?.id === c.id ? '#e2f0ff' : '#f8f9fa',
                  border: '1px solid #ddd',
                  borderRadius: '6px',
                  position: 'relative',
                  boxShadow: '0 2px 4px rgba(0,0,0,0.03)'
                }}
              >
                <div
                  onClick={() => seleccionarClienteDetalle(c)}
                  style={{ cursor: 'pointer', paddingRight: '30px' }}
                >
                  <strong style={{ fontSize: '15px', color: '#333' }}>{c.nombre}</strong> <br />
                  <small style={{ color: '#666' }}>{c.empresa || 'Independiente'}</small>
                </div>

                <button
                  onClick={(e) => {
                    e.stopPropagation();
                    setClienteMenuAbiertoId(clienteMenuAbiertoId === c.id ? null : c.id);
                  }}
                  style={{
                    position: 'absolute', top: '10px', right: '10px', background: 'none', border: 'none',
                    fontSize: '18px', cursor: 'pointer', color: '#888', padding: '0 5px'
                  }}
                >
                  ⋮
                </button>

                {clienteMenuAbiertoId === c.id && (
                  <div
                    style={{
                      position: 'absolute', top: '32px', right: '10px', background: 'white',
                      border: '1px solid #ccc', borderRadius: '4px', boxShadow: '0 4px 8px rgba(0,0,0,0.12)',
                      zIndex: 10, display: 'flex', flexDirection: 'column', width: '160px'
                    }}
                  >
                    <button
                      onClick={() => {
                        seleccionarClienteDetalle(c);
                        setClienteMenuAbiertoId(null);
                      }}
                      style={{ padding: '8px 12px', background: 'none', border: 'none', textAlign: 'left', cursor: 'pointer', fontSize: '13px', borderBottom: '1px solid #eee' }}
                    >
                      📂 Ver Expediente
                    </button>
                    <button
                      onClick={() => {
                        setClienteIA(c);
                        setClienteMenuAbiertoId(null);
                      }}
                      style={{ padding: '8px 12px', background: 'none', border: 'none', textAlign: 'left', cursor: 'pointer', fontSize: '13px' }}
                    >
                      🧠 Redactar con IA
                    </button>
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>

        {/* COLUMNA 2: PROYECTOS Y TAREAS */}
        <div style={{ flex: 1.5, background: '#fdfdfd', padding: '15px', border: '1px solid #ddd', borderRadius: '6px' }}>
          {clienteSeleccionado ? (
            <div>
              <h3>📂 Expediente: <span style={{ color: '#007bff' }}>{clienteSeleccionado.nombre}</span></h3>

              <form onSubmit={guardarProyecto} style={{ display: 'flex', gap: '10px', marginBottom: '15px', background: '#f1f1f1', padding: '10px', borderRadius: '4px' }}>
                <input type="text" placeholder="Nuevo Proyecto" value={nombreProyecto} onChange={e => setNombreProyecto(e.target.value)} required style={{ padding: '5px', flex: 1 }} />
                <button type="submit" style={{ background: '#28a745', color: 'white', border: 'none', padding: '5px 10px', cursor: 'pointer' }}>+ Añadir</button>
              </form>

              <h4>🛠️ Proyectos del Cliente</h4>

              {/* UBICACIÓN EXACTA: Reemplaza el map viejo por esta línea */}
              <ProyectosCliente proyectos={proyectosCliente} />
              {/* ================= BANDEJA DE HISTORIAL DE CORREOS ESTILIZADA ================= */}
              <div className="mt-8 pt-6 border-t border-gray-100">
                <div className="flex items-center justify-between mb-4">
                  <h4 className="text-sm font-bold text-gray-700 flex items-center gap-2">
                    ✉️ Historial de Comunicaciones
                  </h4>
                  <span className="bg-indigo-50 text-indigo-700 text-[11px] font-semibold px-2.5 py-0.5 rounded-full">
                    {historialCorreos.length} Enviados
                  </span>
                </div>

                {historialCorreos.length === 0 ? (
                  <div className="text-center py-8 bg-gray-50 rounded-xl border border-dashed border-gray-200 p-4">
                    <p className="text-gray-400 text-xs">No hay correos registrados en el expediente de este cliente.</p>
                  </div>
                ) : (
                  <div className="flex flex-col gap-3 max-h-[520px] overflow-y-auto pr-2">
                    {historialCorreos.map((correo, index) => {

                      const contenidoCompleto =
                        correo?.contenido ||
                        correo?.mensaje ||
                        correo?.cuerpo ||
                        "No hay contenido disponible";

                      return (
                        <div
                          key={correo.id}
                          className="bg-white rounded-xl border border-gray-100 shadow-sm hover:shadow-md transition-all duration-200 overflow-hidden"
                        >

                          <div className="bg-gray-50/80 px-4 py-2.5 border-b border-gray-100 flex justify-between items-center text-xs">
                            <div className="flex items-center gap-2">
                              <span className="w-2 h-2 rounded-full bg-emerald-500"></span>
                              <span className="font-semibold text-gray-700">
                                Notificación Enviada
                              </span>

                              <span className="text-gray-300">|</span>

                              <span className="text-indigo-600 font-medium bg-indigo-50 px-2 py-0.5 rounded text-[10px]">
                                📁 {correo.proyecto || "General"}
                              </span>
                            </div>

                            <span className="text-gray-400 text-[11px]">
                              {correo.fecha
                                ? new Date(correo.fecha).toLocaleDateString("es-CO", {
                                  day: "numeric",
                                  month: "short"
                                })
                                : "Reciente"}
                            </span>
                          </div>

                          <div className="p-4">
                           <div className="p-4">

  <div
    style={{
      maxHeight: "120px",
      overflow: "hidden",
      position: "relative"
    }}
  >

    <p
      className="text-gray-600 text-xs leading-relaxed whitespace-pre-line bg-gray-50/40 p-3 rounded-lg border border-gray-50"
    >
      {contenidoCompleto}
    </p>

    <div
      style={{
        position: "absolute",
        bottom: 0,
        left: 0,
        right: 0,
        height: "40px",
        background:
          "linear-gradient(to bottom, rgba(255,255,255,0), white)"
      }}
    />

  </div>

</div>
                          </div>

                          <div className="px-4 py-2 bg-white border-t border-gray-50 flex justify-between items-center text-[11px] text-gray-400">

                            <span className="italic">
                              Redactado con Groq IA
                            </span>

                            <div style={{ display: "flex", gap: "10px" }}>

<button
    type="button"
    onClick={() => {

        console.log("==========");
        console.log(correo);

        console.log("Contenido:", correo.contenido);
        console.log("Mensaje:", correo.mensaje);
        console.log("Cuerpo:", correo.cuerpo);

        /*alert(
            (correo.contenido ||
             correo.mensaje ||
             correo.cuerpo ||
             "VACÍO").substring(0,200)
        );*/

        setCorreoSeleccionado(correo);
        setMostrarCorreoCompleto(true);

    }}
    className="text-blue-600"
>
    👁 Ver completo
</button>
                             <button
    type="button"
    onClick={() => {
        navigator.clipboard.writeText(contenidoCompleto);
        alert("Correo copiado");
    }}
    className="text-indigo-600"
>
    📋 Copiar
</button>

                            </div>

                          </div>

                        </div>
                      );
                    })}
                  </div>
                )}
              </div>
              {/* ============================================================================= */}


            </div>
          ) : <p style={{ color: '#888', textAlign: 'center', marginTop: '40px' }}>Selecciona un cliente para gestionar sus proyectos y checklists.</p>}
        </div>

        {/* COLUMNA 3: IA */}
        <div style={{ flex: 1, background: '#f4f6f9', padding: '15px', borderRadius: '6px' }}>
          <h3>🧠 Redactar con Groq IA</h3>
          <form onSubmit={generarTextoIA} style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>

            <label style={{ fontSize: '14px', fontWeight: 'bold', color: '#555' }}>
              Selecciona el Cliente:
            </label>

            <select
              value={clienteIA?.id || ''}
              onChange={(e) => {
                const idSeleccionado = Number(e.target.value);
                const cliente = clientes.find(c => c.id === idSeleccionado);
                setClienteIA(cliente || null);
                setProyectoIA('');
                if (idSeleccionado) {
                  cargarProyectosIA(idSeleccionado);
                }
              }}
              required
              style={{ padding: '8px', borderRadius: '4px', border: '1px solid #ccc' }}
            >
              <option value="">-- Elige un cliente --</option>
              {clientes.map(c => (
                <option key={c.id} value={c.id}>
                  {c.nombre}
                </option>
              ))}
            </select>

            <label style={{ fontSize: '14px', fontWeight: 'bold', color: '#555' }}>
              Selecciona el Proyecto:
            </label>

            <select
              value={proyectoIA}
              onChange={e => setProyectoIA(e.target.value)}
              required
              style={{ padding: '8px', borderRadius: '4px', border: '1px solid #ccc' }}
            >
              <option value="">-- Elige el proyecto --</option>
              {proyectosIA.map(p => (
                <option key={p.id} value={p.nombre}>
                  {p.nombre}
                </option>
              ))}
            </select>

            <label style={{ fontSize: '14px', fontWeight: 'bold', color: '#555', marginTop: '5px' }}>¿Qué quieres notificarle?</label>
            <textarea
              placeholder="Ej. El desarrollo del módulo de login está listo y requiere revisión."
              value={detalleProyecto}
              onChange={e => setDetalleProyecto(e.target.value)}
              required
              rows="3"
              style={{ padding: '6px', borderRadius: '4px', border: '1px solid #ccc', resize: 'vertical' }}
            />

            <label style={{ fontSize: '14px', fontWeight: 'bold', color: '#555' }}>Tono del mensaje:</label>
            <select value={tono} onChange={e => setTono(e.target.value)} style={{ padding: '6px', borderRadius: '4px' }}>
              <option value="profesional">Profesional</option>
              <option value="amigable">Amigable</option>
              <option value="formal">Formal</option>
            </select>

            <button type="submit" disabled={cargandoIA} style={{ padding: '8px', background: '#17a2b8', color: 'white', border: 'none', cursor: 'pointer', marginTop: '5px', borderRadius: '4px', fontWeight: 'bold' }}>
              {cargandoIA ? "Redactando..." : "Generar Correo"}
            </button>
          </form>

          {/* CORREGIDO: Envoltura en un contenedor único <div> para evitar elementos JSX adyacentes sueltos */}
          {correoGenerado && (
            <div style={{ marginTop: '10px' }}>
              <div style={{ background: 'white', padding: '10px', borderLeft: '4px solid #17a2b8', whiteSpace: 'pre-line', fontSize: '13px', borderRadius: '4px', boxShadow: '0 2px 4px rgba(0,0,0,0.05)' }}>
                {correoGenerado}
              </div>
              <button
                type='button'
                onClick={guardarCorreoEnHistorial}
                style={{ marginTop: '8px', width: '100%', padding: '6px', background: '#28a745', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer', fontWeight: 'bold' }}
              >
                💾 Guardar Correo en Historial
              </button>
            </div>
          )}
        </div>

      </div>
      {mostrarCorreoCompleto && correoSeleccionado && (

        <div
          style={{
            position: "fixed",
            inset: 0,
            backgroundColor: "rgba(0,0,0,0.5)",
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
            zIndex: 9999
          }}
        >

          <div
            style={{
              background: "white",
              width: "900px",
              maxHeight: "85vh",
              overflowY: "auto",
              borderRadius: "10px",
              padding: "25px"
            }}
          >

            <div
              style={{
                display: "flex",
                justifyContent: "space-between",
                marginBottom: "20px"
              }}
            >

              <h2>📧 Correo Completo</h2>

              <button
                onClick={() => setMostrarCorreoCompleto(false)}
                style={{
                  background: "#dc3545",
                  color: "white",
                  border: "none",
                  padding: "8px 15px",
                  cursor: "pointer"
                }}
              >
                Cerrar
              </button>

            </div>

            <div style={{ marginBottom: "15px" }}>
              <strong>Proyecto:</strong>{" "}
              {correoSeleccionado.proyecto}
            </div>

     <div
  style={{
    border: "1px solid #ddd",
    borderRadius: "8px",
    padding: "20px"
  }}
>

<pre
  style={{
    whiteSpace: "pre-wrap",
    fontFamily: "Arial",
    margin: 0,
    lineHeight: "1.8"
  }}
>
{correoSeleccionado.contenido}
</pre>

</div>

          </div>

        </div>

      )}
    </div>
  );
}

export default App;