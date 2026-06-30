<?php
// 1. Iniciar la sesión para acceder a los datos del usuario logueado
session_start();

// 2. Control de acceso: Si no hay una sesión activa, redirigir al login
if (!isset($_SESSION['usuario'])) {
    // Ajusta la ruta de redirección según dónde esté tu archivo de login (ej: ../index.php o ../login.php)
    header("Location: ../index.php"); 
    exit();
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Freelancers CRM</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
</head>
<body class="bg-gray-100 font-sans">

    <nav class="bg-indigo-600 p-4 text-white flex justify-between items-center">
        <h1 class="text-xl font-bold">Freelancers CRM 💼</h1>
        <div class="flex items-center gap-4">
            <span>Bienvenido, <strong><?php echo htmlspecialchars($_SESSION['usuario']); ?></strong></span>
            <a href="logout.php" class="bg-red-500 hover:bg-red-600 px-3 py-1 rounded text-sm transition">Cerrar Sesión</a>
        </div>
    </nav>

    <main class="container mx-auto mt-10 p-6 bg-white rounded-lg shadow-md">
        <h2 class="text-2xl font-semibold text-gray-800 mb-4">Panel de Control</h2>
        <p class="text-gray-600">¡Inicio de sesión exitoso! Aquí puedes comenzar a gestionar tus proyectos, clientes y facturas.</p>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mt-8">
            <div class="p-6 bg-blue-50 border-l-4 border-blue-500 rounded-r shadow-sm">
                <h3 class="text-sm font-medium text-gray-500 uppercase">Proyectos Activos</h3>
                <p class="text-2xl font-bold text-gray-800 mt-1">5</p>
            </div>
            <div class="p-6 bg-green-50 border-l-4 border-green-500 rounded-r shadow-sm">
                <h3 class="text-sm font-medium text-gray-500 uppercase">Clientes Totales</h3>
                <p class="text-2xl font-bold text-gray-800 mt-1">12</p>
            </div>
            <div class="p-6 bg-yellow-50 border-l-4 border-yellow-500 rounded-r shadow-sm">
                <h3 class="text-sm font-medium text-gray-500 uppercase">Facturas Pendientes</h3>
                <p class="text-2xl font-bold text-gray-800 mt-1">$1,200 USD</p>
            </div>
        </div>
    </main>

</body>
</html>