<?php
declare(strict_types=1);
require dirname(__DIR__) . '/app/config/database.php';
$config = database_config();
$pdo = new PDO("mysql:host={$config['host']};port={$config['port']};charset=utf8mb4", $config['user'], $config['password'], [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
$sql = file_get_contents(__DIR__ . '/migrations/001_initial_schema.sql');
$pdo->exec($sql);
echo "Database installed successfully.\n";
