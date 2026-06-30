from app.database import SessionLocal, Usuario
from security import encriptar_password

db = SessionLocal()

try:

    admin = db.query(Usuario).filter(
        Usuario.email == "admin@crm.com"
    ).first()

    if admin:

        print("✅ El administrador ya existe.")

    else:

        nuevo_admin = Usuario(
            nombre="Administrador",
            email="admin@crm.com",
            password=encriptar_password("Admin123*"),
            rol="administrador"
        )

        db.add(nuevo_admin)
        db.commit()

        print("====================================")
        print("Administrador creado correctamente")
        print("Correo: admin@crm.com")
        print("Contraseña: Admin123*")
        print("====================================")

finally:

    db.close()