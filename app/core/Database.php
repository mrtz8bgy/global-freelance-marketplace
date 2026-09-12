<?php
declare(strict_types=1);

final class Database
{
    private static ?PDO $connection = null;
    public static function connection(): PDO
    {
        if (!self::$connection) { $c = database_config(); self::$connection = new PDO("mysql:host={$c['host']};port={$c['port']};dbname={$c['name']};charset={$c['charset']}", $c['user'], $c['password'], [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC, PDO::ATTR_EMULATE_PREPARES => false]); }
        return self::$connection;
    }
}
