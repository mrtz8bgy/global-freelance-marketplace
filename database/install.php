<?php
declare(strict_types=1);
require dirname(__DIR__) . '/app/config/database.php';
$config=database_config();
$pdo=new PDO("mysql:host={$config['host']};port={$config['port']};charset=utf8mb4",$config['user'],$config['password'],[PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION]);
foreach([__DIR__.'/migrations/global_freelance_marketplace.sql',__DIR__.'/migrations/20260912_banners.sql'] as $file){if(is_file($file)){$pdo->exec(file_get_contents($file));}}
echo "Database installed successfully.\n";