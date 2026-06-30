<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Freelancers CRM - Acceso</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f7f6; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 100%; max-width: 400px; }
        .tabs { display: flex; justify-content: space-around; margin-bottom: 20px; border-bottom: 2px solid #eee; }
        .tab-btn { background: none; border: none; padding: 10px 20px; font-size: 16px; cursor: pointer; color: #888; }
        .tab-btn.active { color: #2563eb; border-bottom: 2px solid #2563eb; font-weight: bold; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; color: #333; }
        .form-group input { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .btn { width: 100%; padding: 10px; background-color: #2563eb; border: none; color: white; font-size: 16px; border-radius: 4px; cursor: pointer; }
        .btn:hover { background-color: #1d4ed8; }
        .hidden { display: none; }
    </style>
</head>
<body>

<div class="container">
    <div class="tabs">
        <button class="tab-btn active" onclick="switchTab('login-form', this)">Iniciar Sesión</button>
        <button class="tab-btn" onclick="switchTab('register-form', this)">Registrarse</button>
    </div>

    <form id="login-form" action="validar.php" method="POST">
        <div class="form-group">
            <label for="login-email">Correo Electrónico</label>
            <input type="email" id="login-email" name="email" required>
        </div>
        <div class="form-group">
            <label for="login-password">Contraseña</label>
            <input type="password" id="login-password" name="password" required>
        </div>
        <button type="submit" name="btn_login" class="btn">Ingresar</button>
    </form>

    <form id="register-form" action="registro-login/procesar_registro.php" method="POST" class="hidden">
        <div class="form-group">
            <label for="reg-nombre">Nombre Completo</label>
            <input type="text" id="reg-nombre" name="nombre" required>
        </div>
        <div class="form-group">
            <label for="reg-email">Correo Electrónico</label>
            <input type="email" id="reg-email" name="email" required>
        </div>
        <div class="form-group">
            <label for="reg-password">Contraseña</label>
            <input type="password" id="reg-password" name="password" required>
        </div>
        <button type="submit" name="btn_registro" class="btn">Crear Cuenta</button>
    </form>
</div>

<script>
    function switchTab(formId, btn) {
        // Ocultar ambos formularios
        document.getElementById('login-form').classList.add('hidden');
        document.getElementById('register-form').classList.add('hidden');
        
        // Quitar clase activa a los botones
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        
        // Mostrar el formulario seleccionado y activar botón
        document.getElementById(formId).classList.remove('hidden');
        btn.classList.add('active');
    }
</script>

</body>
</html>