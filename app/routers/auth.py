from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, EmailStr
from sqlalchemy.orm import Session
import bcrypt

from app.database import get_db
from app.models import Usuario

router = APIRouter(
    prefix="/auth",
    tags=["Autenticación"]
)


# ==========================
# ESQUEMAS
# ==========================

class RegistroUsuario(BaseModel):
    nombre: str
    email: EmailStr
    password: str


class LoginUsuario(BaseModel):
    email: EmailStr
    password: str


# ==========================
# REGISTRO
# ==========================

@router.post("/registro", status_code=status.HTTP_201_CREATED)
def registrar_usuario(
    usuario: RegistroUsuario,
    db: Session = Depends(get_db)
):

    usuario_existente = (
        db.query(Usuario)
        .filter(Usuario.email == usuario.email)
        .first()
    )

    if usuario_existente:
        raise HTTPException(
            status_code=400,
            detail="El correo ya está registrado."
        )

    password_encriptada = bcrypt.hashpw(
        usuario.password.encode("utf-8"),
        bcrypt.gensalt()
    ).decode("utf-8")

    nuevo_usuario = Usuario(
        workspace_id=1,
        nombre=usuario.nombre,
        apellido="",
        email=usuario.email,
        password=password_encriptada,
        foto="default.png",
        estado="ACTIVO",
        ultimo_login=datetime.now(),
        created_at=datetime.now(),
        updated_at=datetime.now()
    )

    try:
        db.add(nuevo_usuario)
        db.commit()
        db.refresh(nuevo_usuario)

        return {
            "mensaje": "Usuario registrado exitosamente",
            "id": nuevo_usuario.id
        }

    except Exception as e:
        db.rollback()

        raise HTTPException(
            status_code=500,
            detail=str(e)
        )


# ==========================
# LOGIN
# ==========================

@router.post("/login")
def login_usuario(
    credenciales: LoginUsuario,
    db: Session = Depends(get_db)
):

    usuario = (
        db.query(Usuario)
        .filter(Usuario.email == credenciales.email)
        .first()
    )

    if not usuario:
        raise HTTPException(
            status_code=401,
            detail="Correo o contraseña incorrectos."
        )

    if not bcrypt.checkpw(
        credenciales.password.encode("utf-8"),
        usuario.password.encode("utf-8")
    ):
        raise HTTPException(
            status_code=401,
            detail="Correo o contraseña incorrectos."
        )

    usuario.ultimo_login = datetime.now()
    db.commit()

    return {
        "mensaje": "Inicio de sesión exitoso",
        "usuario": {
            "id": usuario.id,
            "nombre": usuario.nombre,
            "email": usuario.email,
            "workspace_id": usuario.workspace_id
        }
    }