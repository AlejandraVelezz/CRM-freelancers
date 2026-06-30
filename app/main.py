from app.routers.auth import router as auth_router
from app.routers.clientes import router as clientes_router
from app.routers.proyectos import router as proyectos_router
from app.routers.tareas import router as tareas_router
from app.routers.ia import router as ia_router
from fastapi import FastAPI
from app.database import engine
from app.models import Base

# Importamos todos los routers desde tu paquete app.routers

# Crea las tablas automáticamente en MySQL usando SQLAlchemy (si no existen)
Base.metadata.create_all(bind=engine)

app = FastAPI(title="Freelancer CRM API", version="1.0.0")

# CONFIGURACIÓN DE CORS: Permite que tu frontend en React se conecte sin bloqueos
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En producción, cámbialo por la URL de tu app en React (ej: http://localhost:5173)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Inclusión de rutas modulares (APIs)
app.include_router(auth.router)
app.include_router(clientes.router)
app.include_router(ia.router)
app.include_router(proyectos.router)
app.include_router(tareas.router)

@app.get("/")
def inicio():
    return {"mensaje": "¡Backend Freelancer CRM conectado con CORS, MySQL e IA!"}