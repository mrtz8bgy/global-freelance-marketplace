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
require_once BASE_PATH . '/app/models/User.php';
require_once BASE_PATH . '/app/models/Profile.php';
require_once BASE_PATH . '/app/models/Skill.php';
require_once BASE_PATH . '/app/models/Job.php';
require_once BASE_PATH . '/app/models/Proposal.php';
require_once BASE_PATH . '/app/models/Portfolio.php';
require_once BASE_PATH . '/app/models/Invitation.php';
require_once BASE_PATH . '/app/middleware/AdminMiddleware.php';
require_once BASE_PATH . '/app/middleware/AuthMiddleware.php';
require_once BASE_PATH . '/app/controllers/EmployerController.php';
require_once BASE_PATH . '/app/controllers/HomeController.php';
require_once BASE_PATH . '/app/controllers/AuthController.php';
require_once BASE_PATH . '/app/controllers/FreelancerController.php';
require_once BASE_PATH . '/app/controllers/ErrorController.php';
require_once BASE_PATH . '/app/controllers/AdminController.php';

error_reporting(APP_ENV === 'production' ? 0 : E_ALL);
ini_set('display_errors', APP_ENV === 'production' ? '0' : '1');
date_default_timezone_set(getenv('APP_TIMEZONE') ?: 'UTC');
Session::start();
