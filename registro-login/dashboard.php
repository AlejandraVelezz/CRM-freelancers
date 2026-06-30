<?php
session_start();

// Validar si el usuario NO ha iniciado sesión
if (!isset($_SESSION['usuario_id'])) {
    // Mandarlo directo al login e impedir la carga del resto de la página
    header("Location: login.php");
    exit;
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - CRM Freelancer</title>
</head>
<body>
    <h1>Bienvenido(a), <?php echo htmlspecialchars($_SESSION['usuario_nom']); ?>!</h1>
    <p>Tu rol asignado es: <strong><?php echo htmlspecialchars($_SESSION['usuario_tipo']); ?></strong></p>
    
    <hr>
    <h3>Acciones del CRM</h3>
    <p>Aquí irá tu lógica para listar tus proyectos, clientes y tareas asignadas.</p>

    <a href="logout.php">Cerrar Sesión Cerrar de forma segura</a>
</body>
</html>