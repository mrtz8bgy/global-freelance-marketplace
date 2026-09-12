<?php
declare(strict_types=1);

require_once __DIR__ . '/constants.php';
// Load local environment values without overriding server-provided variables.
$envFile = BASE_PATH . '/.env';
if (is_readable($envFile)) {
	foreach (file($envFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $line) {
		$line = trim($line);
		if ($line === '' || $line[0] === '#' || strpos($line, '=') === false) continue;
		[$key, $value] = explode('=', $line, 2);
		if (getenv(trim($key)) === false) putenv(trim($key) . '=' . trim($value, " \t\"'"));
	}
}

require_once __DIR__ . '/database.php';
require_once BASE_PATH . '/app/helpers/functions.php';
require_once BASE_PATH . '/app/helpers/url_helper.php';
require_once BASE_PATH . '/app/core/Router.php';
require_once BASE_PATH . '/app/core/Controller.php';
require_once BASE_PATH . '/app/core/View.php';
require_once BASE_PATH . '/app/core/Session.php';
require_once BASE_PATH . '/app/core/CSRF.php';
require_once BASE_PATH . '/app/core/Security.php';
require_once BASE_PATH . '/app/core/Validator.php';
require_once BASE_PATH . '/app/core/Database.php';
require_once BASE_PATH . '/app/core/Model.php';
// Load the base model before dependent model classes, then load the remainder.
require_once BASE_PATH . '/app/models/Profile.php';
foreach (glob(BASE_PATH . '/app/models/*.php') ?: [] as $modelFile) {
	if (basename($modelFile) !== 'Profile.php') require_once $modelFile;
}
require_once BASE_PATH . '/app/middleware/AdminMiddleware.php';
require_once BASE_PATH . '/app/middleware/AuthMiddleware.php';
foreach (glob(BASE_PATH . '/app/middleware/*.php') ?: [] as $middlewareFile) {
	require_once $middlewareFile;
}
foreach (glob(BASE_PATH . '/app/controllers/*.php') ?: [] as $controllerFile) {
	require_once $controllerFile;
}

error_reporting(APP_ENV === 'production' ? 0 : E_ALL);
ini_set('display_errors', APP_ENV === 'production' ? '0' : '1');
date_default_timezone_set(getenv('APP_TIMEZONE') ?: 'UTC');
Session::start();
