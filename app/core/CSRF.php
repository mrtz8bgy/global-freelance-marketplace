<?php
declare(strict_types=1);

final class CSRF
{
    public static function token(): string { if (!Session::get('_csrf')) Session::put('_csrf', bin2hex(random_bytes(32))); return (string) Session::get('_csrf'); }
    public static function field(): string { return '<input type="hidden" name="_csrf" value="' . e(self::token()) . '">'; }
    public static function verify(?string $token): bool { return is_string($token) && hash_equals((string) Session::get('_csrf', ''), $token); }
}
