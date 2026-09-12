<?php
declare(strict_types=1);

define('APP_NAME', 'Global Freelance Marketplace');
define('APP_VERSION', '1.0.0');
define('BASE_PATH', dirname(__DIR__, 2));
define('PUBLIC_PATH', BASE_PATH . '/public');
define('STORAGE_PATH', BASE_PATH . '/storage');
define('APP_ENV', getenv('APP_ENV') ?: 'development');
