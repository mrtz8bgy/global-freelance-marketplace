<?php
declare(strict_types=1);

function url(string $path = ''): string { return rtrim(getenv('APP_URL') ?: '/global-freelance-marketplace/public', '/') . '/' . ltrim($path, '/'); }
