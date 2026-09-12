<?php
declare(strict_types=1);

final class AuthMiddleware { public static function handle(): void { if (!Session::get('user_id')) { header('Location: '.url('/login')); exit; } } }
