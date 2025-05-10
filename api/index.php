<?php
$paths = [
    __DIR__ . '/vendor',
    dirname(__DIR__) . '/vendor',
];

$found = false;

foreach ($paths as $path) {
    if (is_dir($path)) {
        require $path . '/autoload.php';
        $found = true;
        break;
    }
}

if (!$found) {
    echo "❌ No se pudo encontrar la carpeta 'vendor'.";
}else{
    echo "SI";
}
