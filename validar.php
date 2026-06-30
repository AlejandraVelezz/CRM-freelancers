<?php
session_start();
include_once("conexion.php");

if (isset($_POST['btn_login'])) {
    $email = trim($_POST['email']);
    $password = trim($_POST['password']);

    // Consultar si el usuario existe
    $consulta = "SELECT * FROM usuarios WHERE email = '$email'";
    $resultado = mysqli_query($conexion, $consulta);

    if ($resultado && mysqli_num_rows($resultado) > 0) {
        $usuario = mysqli_fetch_assoc($resultado);

        // Verificar la contraseña encriptada
        if (password_verify($password, $usuario['password'])) {
            // Guardar datos en la sesión
            $_SESSION['usuario_id'] = $usuario['id'];
            $_SESSION['usuario_nombre'] = $usuario['nombre'];

            // Redireccionar al panel principal del CRM
            header("Location: app/dashboard.php");
            exit();
        } else {
            echo "<script>alert('Contraseña incorrecta.'); window.location.href='index.php';</script>";
        }
    } else {
        echo "<script>alert('El correo electrónico no está registrado.'); window.location.href='index.php';</script>";
    }
}
?>