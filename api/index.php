<?php
$extensiones = get_loaded_extensions();
sort($extensiones);

echo "Extensiones PHP instaladas:\n";
foreach ($extensiones as $ext) {
    echo "- " . $ext . "\n";
}


// Mostrar configuración de OPcache
print_r(opcache_get_configuration());

// Mostrar estado actual de OPcache
print_r(opcache_get_status());
?>

