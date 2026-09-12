<?php
declare(strict_types=1);

function e($value): string { return htmlspecialchars((string) $value, ENT_QUOTES, 'UTF-8'); }
function old(string $key, string $default = ''): string { return e($_POST[$key] ?? $default); }
function csrf_field(): string { return CSRF::field(); }
