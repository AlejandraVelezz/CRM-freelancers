from sqlalchemy import Column, Integer, String, DateTime, Text, ForeignKey, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from datetime import datetime, timedelta
from passlib.context import CryptContext
import jwt

# Conexión local a MySQL en XAMPP / Laragon
DATABASE_URL = "mysql+pymysql://root:@localhost:3306/freelancer_os"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# Configuración de Seguridad
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
JWT_SECRET = "mi_clave_secreta_para_los_tokens_123"
ALGORITHM = "HS256"

# ==========================================
# 📑 MODELOS DE LA BASE DE DATOS EXACTOS
# ==========================================

class UsuarioDB(Base):
    __tablename__ = "usuarios"

    id = Column(Integer, primary_key=True, index=True)

    workspace_id = Column(Integer, nullable=False)

    nombre = Column(String(100), nullable=False)

    apellido = Column(String(100), nullable=False)

    email = Column(String(100), unique=True, index=True, nullable=False)

    password = Column(String(255), nullable=False)

    foto = Column(String(255), default="")

    estado = Column(String(20), default="ACTIVO")

    ultimo_login = Column(DateTime)

    created_at = Column(DateTime, default=datetime.utcnow)

    updated_at = Column(
        DateTime,
        default=datetime.utcnow,
        onupdate=datetime.utcnow
    )




class Tarea(Base):
    __tablename__ = "tareas"
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    titulo = Column(String(150), nullable=False)
    descripcion = Column(Text, nullable=True)
    estado = Column(String(50), nullable=True)
    proyecto_id = Column(Integer, ForeignKey("proyectos.id", ondelete="CASCADE"), nullable=True)
    usuario_id = Column(Integer, ForeignKey("usuarios.id", ondelete="CASCADE"), nullable=True)

class CorreoHistorial(Base):
    __tablename__ = "correos_historial"
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    cliente_id = Column(Integer, ForeignKey("clientes.id", ondelete="CASCADE"), nullable=True)
    proyecto = Column(String(200), nullable=True)
    contenido = Column(Text, nullable=False)
    fecha = Column(DateTime, default=datetime.utcnow)
    usuario_id = Column(Integer, ForeignKey("usuarios.id", ondelete="CASCADE"), nullable=True)

class Notificacion(Base):
    __tablename__ = "notificaciones"
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    cliente_id = Column(Integer, ForeignKey("clientes.id", ondelete="CASCADE"), nullable=True)
    asunto = Column(String(200), nullable=False)
    mensaje = Column(Text, nullable=False)
    estado = Column(String(50), nullable=True)
    tipo = Column(String(50), nullable=True)
    fecha = Column(DateTime, default=datetime.utcnow)
    usuario_id = Column(Integer, ForeignKey("usuarios.id", ondelete="CASCADE"), nullable=True)

# ==========================================
# ⚙️ FUNCIONES DE UTILIDAD Y SEGURIDAD
# ==========================================

def verificar_password(password_plano: str, password_hasheado: str) -> bool:
    return pwd_context.verify(password_plano, password_hasheado)

def obtener_password_hasheado(password: str) -> str:
    return pwd_context.hash(password)

def crear_token_acceso(usuario_id: int) -> str:
    payload = {
        "sub": str(usuario_id),
        "exp": datetime.utcnow() + timedelta(hours=8)
    }
    return jwt.encode(payload, JWT_SECRET, algorithm=ALGORITHM)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()