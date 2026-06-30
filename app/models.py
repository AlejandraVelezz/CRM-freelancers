from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship
from app.database import Base


class Workspace(Base):
    __tablename__ = "workspace"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(150))


class Usuario(Base):
    __tablename__ = "usuarios"

    id = Column(Integer, primary_key=True, index=True)

    workspace_id = Column(Integer, ForeignKey("workspace.id"))

    nombre = Column(String(100))
    apellido = Column(String(100))
    email = Column(String(100), unique=True)
    password = Column(String(255))

    foto = Column(String(255))
    estado = Column(String(20))

    ultimo_login = Column(DateTime)
    created_at = Column(DateTime)
    updated_at = Column(DateTime)

    workspace = relationship("Workspace")


class Cliente(Base):
    __tablename__ = "clientes"

    id = Column(Integer, primary_key=True, index=True)

    workspace_id = Column(Integer, ForeignKey("workspace.id"))
    persona_id = Column(Integer)

    codigo_cliente = Column(String(100))
    fecha_registro = Column(DateTime)

    categoria = Column(String(100))
    estado = Column(String(50))

    created_at = Column(DateTime)
    updated_at = Column(DateTime)
    deleted_at = Column(DateTime)

    created_by = Column(Integer)
    updated_by = Column(Integer)


class Proyecto(Base):
    __tablename__ = "proyectos"

    id = Column(Integer, primary_key=True, index=True)

    cliente_id = Column(Integer, ForeignKey("clientes.id"))

    nombre = Column(String(150))
    descripcion = Column(Text)
    estado = Column(String(50))

    created_at = Column(DateTime)
    updated_at = Column(DateTime)


class Tarea(Base):
    __tablename__ = "tareas"

    id = Column(Integer, primary_key=True, index=True)

    proyecto_id = Column(Integer, ForeignKey("proyectos.id"))

    titulo = Column(String(150))
    descripcion = Column(Text)
    estado = Column(String(50))

    created_at = Column(DateTime)
    updated_at = Column(DateTime)


class CorreoHistorial(Base):
    __tablename__ = "correos_historial"

    id = Column(Integer, primary_key=True, index=True)

    cliente_id = Column(Integer, ForeignKey("clientes.id"))

    proyecto = Column(String(200))
    contenido = Column(Text)

    fecha = Column(DateTime)


class Notificacion(Base):
    __tablename__ = "notificaciones"

    id = Column(Integer, primary_key=True, index=True)

    cliente_id = Column(Integer, ForeignKey("clientes.id"))

    asunto = Column(String(200))
    mensaje = Column(Text)

    estado = Column(String(50))
    tipo = Column(String(50))

    fecha = Column(DateTime)