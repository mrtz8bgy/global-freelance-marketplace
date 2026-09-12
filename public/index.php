<?php
declare(strict_types=1);

require dirname(__DIR__) . '/app/config/config.php';
require dirname(__DIR__) . '/app/core/App.php';

$app = new App();
$app->run();
