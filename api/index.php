<?php
require './vendor/autoload.php';  // Retrocede un directorio para cargar autoload.php

use AltoRouter;

// Crear una instancia del enrutador
$router = new AltoRouter();

// Definir algunas rutas
$router->map('GET', '/', function() {
    echo "Página de inicio";
});

$router->map('GET', '/hola', function() {
    echo "¡Hola Mundo!";
});

$router->map('GET', '/usuario/[i:id]', function($vars) {
    echo "Usuario con ID: " . $vars['id'];
});

// Obtener la ruta que coincide con la solicitud actual
$match = $router->match();

// Si hay una coincidencia y el objetivo es callable, lo ejecutamos
if ($match && is_callable($match['target'])) {
    call_user_func_array($match['target'], $match['params']);
} else {
    // En caso de que no haya coincidencia, mostramos un error 404
    header($_SERVER["SERVER_PROTOCOL"] . ' 404 Not Found');
    echo 'Página no encontrada';
}
