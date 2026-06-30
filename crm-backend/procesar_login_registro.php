<?php
echo "ESTE ES EL ARCHIVO DE XAMPP";
exit;
//<?php
// crm-backend/procesar_login_registro.php
session_start();

// Configurar la cabecera JSON para que el Fetch reciba el formato correcto
header('Content-Type: application/json');

// Importar tu conexión real con mysqli (la que tiene la variable $conexion)
require_once 'conexion.php'; 

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Capturar la operación enviada desde tu index.php
    $operacion = $_POST['operacion_usuario'] ?? '';

    // ==========================================
    // ACCIÓN: REGISTRAR NUEVO FREELANCER
    // ==========================================
    if ($operacion === 'usr_registrar') {
        $txtNombre   = trim($_POST['usr_txt_nombre'] ?? '');
        $txtEmail    = trim($_POST['usr_txt_email'] ?? '');
        $txtPassword = $_POST['usr_txt_password'] ?? '';

        if (empty($txtNombre) || empty($txtEmail) || empty($txtPassword)) {
            echo json_encode(['status' => 'error', 'message' => 'Todos los campos son obligatorios.']);
            exit;
        }

        // Usar la variable $conexion de tu conexion.php con mysqli
        $stmt = $conexion->prepare("SELECT id FROM usuarios WHERE email = ?");
        $stmt->bind_param("s", $txtEmail);
        $stmt->execute();
        $stmt->store_result();
        
        if ($stmt->num_rows > 0) {
            echo json_encode(['status' => 'error', 'message' => 'Este correo ya se encuentra registrado.']);
            $stmt->close();
            exit;
        }
        $stmt->close();

        // Encriptación de contraseña segura
        $clave_encriptada = password_hash($txtPassword, PASSWORD_BCRYPT);

        // Insertar el usuario con mysqli usando $conexion
        $stmtInsert = $conexion->prepare("INSERT INTO usuarios (nombre, email, password) VALUES (?, ?, ?)");
        $stmtInsert->bind_param("sss", $txtNombre, $txtEmail, $clave_encriptada);

        if ($stmtInsert->execute()) {
            echo json_encode(['status' => 'success', 'message' => '¡Usuario registrado correctamente! Ya puedes ingresar.']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Error al registrar el usuario en la base de datos.']);
        }
        $stmtInsert->close();
        exit;
    }

    // ==========================================
    // ACCIÓN: INICIAR SESIÓN EN EL CRM
    // ==========================================
    if ($operacion === 'usr_ingresar') {
        $txtEmail    = trim($_POST['usr_txt_email'] ?? '');
        $txtPassword = $_POST['usr_txt_password'] ?? '';

        if (empty($txtEmail) || empty($txtPassword)) {
            echo json_encode(['status' => 'error', 'message' => 'Por favor, rellene todos los campos.']);
            exit;
        }

        // Buscar el usuario usando mysqli con $conexion
        $stmt = $conexion->prepare("SELECT id, nombre, email, password FROM usuarios WHERE email = ?");
        $stmt->bind_param("s", $txtEmail);
        $stmt->execute();
        $resultado = $stmt->get_result();
        $datos_usuario = $resultado->fetch_assoc();
        $stmt->close();

        // Verificar la contraseña con el hash encriptado
        if ($datos_usuario && password_verify($txtPassword, $datos_usuario['password'])) {
            
            // Guardar variables de sesión del sistema
            $_SESSION['crm_usr_id']     = $datos_usuario['id'];
            $_SESSION['crm_usr_nombre'] = $datos_usuario['nombre'];
            $_SESSION['crm_usr_email']  = $datos_usuario['email'];

            echo json_encode([
                'status' => 'success', 
                'message' => 'Acceso concedido con éxito.',
                'redireccion_crm' => 'dashboard.php'
            ]);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'El correo o la contraseña son incorrectos.']);
        }
        exit;
    }
}
?>