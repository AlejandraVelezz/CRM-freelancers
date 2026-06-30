<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sesión - CRM Freelancer</title>
    <style>
        .error-message { 
            color: #721c24; 
            background-color: #f8d7da; 
            border: 1px solid #f5c6cb; 
            padding: 10px; 
            margin-bottom: 15px; 
            display: none; 
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <h2>Iniciar Sesión - CRM</h2>
    
    <div id="error-box" class="error-message"></div>

    <form id="loginForm">
        <label for="email">Correo Electrónico:</label><br>
        <input type="email" id="email" required><br><br>

        <label for="password">Contraseña:</label><br>
        <input type="password" id="password" required><br><br>

        <button type="submit">Ingresar</button>
    </form>

    <p>¿No tienes cuenta todavía? <a href="registro.php">Regístrate aquí</a></p>

    <script>
        document.getElementById('loginForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const errorBox = document.getElementById('error-box');
            errorBox.style.display = 'none';

            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;

            try {
                // Petición directa al endpoint /auth/login de FastAPI
                const response = await fetch('http://127.0.0.1:8000/auth/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ email: email, password: password })
                });

                const data = await response.json();

                if (response.ok) {
                    // Guardamos el token de seguridad JWT en la sesión del navegador
                    localStorage.setItem('crm_token', data.access_token);
                    
                    // Redirección directa a tu panel principal de graduación
                    window.location.href = 'dashboard.php';
                } else {
                    // Captura y muestra el mensaje de error "detail" enviado por FastAPI
                    errorBox.innerText = data.detail || 'Error en las credenciales.';
                    errorBox.style.display = 'block';
                }
            } catch (error) {
                errorBox.innerText = 'Error de conexión: Asegúrate de que el servidor de FastAPI esté activo en el puerto 8000.';
                errorBox.style.display = 'block';
            }
        });
    </script>
</body>
</html>