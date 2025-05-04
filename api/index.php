<?php
$directives = [
    // Memoria general
    'memory_limit',
    'max_execution_time',
    'max_input_time',

    // Uploads
    'upload_max_filesize',
    'post_max_size',
    'max_file_uploads',

    // OPcache
    'opcache.enable',
    'opcache.memory_consumption',
    'opcache.interned_strings_buffer',
    'opcache.max_accelerated_files',
    'opcache.revalidate_freq',
    'opcache.validate_timestamps',

    // APCu
    'apc.enabled',
    'apc.shm_size',
    'apc.ttl',
    'apc.user_ttl',
];

echo "<h2>Valores de configuración relevantes de php.ini</h2>";
echo "<pre>";
foreach ($directives as $directive) {
    $value = ini_get($directive);
    if ($value !== false) {
        echo str_pad($directive, 35) . " => " . $value . "\n";
    }
}
echo "</pre>";
