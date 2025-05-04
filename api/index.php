<?php
$extensiones = get_loaded_extensions();
sort($extensiones);

echo "Extensiones de PHP cargadas:\n\n";

foreach ($extensiones as $extension) {
    echo "- $extension\n";
}

echo "\nTotal: " . count($extensiones) . " extensiones.\n";
