<?php

include_once("../conexion.php");

$nombre = mysqli_real_escape_string(
    $conexion,
    trim($_POST['nombre'] ?? '')
);

$email = mysqli_real_escape_string(
    $conexion,
    trim($_POST['email'] ?? '')
);

$password = trim($_POST['password'] ?? '');

if (
    empty($nombre) ||
    empty($email) ||
    empty($password)
) {
    die("Todos los campos son obligatorios");
}

$verificar = mysqli_query(
    $conexion,
    "SELECT id FROM usuarios WHERE email='$email'"
);

if (mysqli_num_rows($verificar) > 0) {

    echo "
    <script>
        alert('El correo ya está registrado');
        window.location='../index.php';
    </script>
    ";

    exit();
}

$password_hash = password_hash(
    $password,
    PASSWORD_DEFAULT
);

$sql = "
INSERT INTO usuarios
(nombre,email,password)
VALUES
('$nombre','$email','$password_hash')
";

if (mysqli_query($conexion, $sql)) {

    echo "
    <script>
        alert('Registro exitoso');
        window.location='../index.php';
    </script>
    ";

} else {

    echo "
    <script>
        alert('Error al registrar');
        window.location='../index.php';
    </script>
    ";
}
?>