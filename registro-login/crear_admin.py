from database import SessionLocal
from models import Usuario

db = SessionLocal()

admin = Usuario(
    nombre="Administrador",
    email="admin@crm.com",
    password=encriptar_password("123456"),
    rol="administrador"
)

db.add(admin)
db.commit()