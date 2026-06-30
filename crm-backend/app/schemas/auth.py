from pydantic import BaseModel, EmailStr


class UsuarioRegistro(BaseModel):
    nombre: str
    email: EmailStr
    password: str


class UsuarioLogin(BaseModel):
    email: EmailStr
    password: str


class UsuarioRespuesta(BaseModel):
    id: int
    nombre: str
    email: str
    tipo_usuario: str

    class Config:
        from_attributes = True


class Token(BaseModel):
    access_token: str
    token_type: str