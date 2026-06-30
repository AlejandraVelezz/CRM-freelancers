<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registro de Usuario - CRM Freelancer</title>
</head>
<body>
    <h2>Crear Nueva Cuenta</h2>
    <form action="procesar_registro.php" method="POST">
        <label for="nombre">Nombre Completo:</label><br>
        <input type="text" id="nombre" name="nombre" required><br><br>

        <label for="email">Correo Electrónico:</label><br>
        <input type="email" id="email" name="email" required><br><br>

        <label for="tipo_usuario">Tipo de Usuario:</label><br>
        <select id="tipo_usuario" name="tipo_usuario" required>
            <option value="Freelancer">Freelancer</option>
            <option value="Administrador">Administrador</option>
        </select><br><br>

        <label for="password">Contraseña:</label><br>
        <input type="password" id="password" name="password" required><br><br>

        <button type="submit">Registrarse</button>
    </form>
    <p>¿Ya tienes cuenta? <a href="login.php">Inicia sesión aquí</a></p>
</body>
</html>