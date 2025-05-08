<?php
$servername = "server-db";
$username = "usuario";
$password = "usuario";
$dbname = "usuario";

// Conexión usando MySQLi
$conn_mysqli = new mysqli($servername, $username, $password, $dbname);

// Verificar la conexión de MySQLi
if ($conn_mysqli->connect_error) {
    die("Conexión MySQLi fallida: " . $conn_mysqli->connect_error);
} else {
    echo "Conexión a MySQLi correcta<br>";
}

// Cerrar conexión MySQLi
$conn_mysqli->close();

// Conexión usando PDO
try {
    $conn_pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    // Establecer el modo de error de PDO para excepciones
    $conn_pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "Conexión a PDO correcta";
} catch(PDOException $e) {
    echo "Conexión PDO fallida: " . $e->getMessage();
}

// Cerrar conexión PDO
$conn_pdo = null;
?>
