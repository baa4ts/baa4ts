<?php
$extensiones = get_loaded_extensions();
sort($extensiones);

echo "Extensiones PHP instaladas:\n";
foreach ($extensiones as $ext) {
    echo "- " . $ext . "\n";
}
