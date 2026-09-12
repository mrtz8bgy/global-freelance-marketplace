<?php
declare(strict_types=1);

final class App
{
    private Router $router;

    public function __construct(?Router $router = null)
    {
        $this->router = $router ?: new Router();
        $router = $this->router;
        require BASE_PATH . '/app/config/routes.php';
    }

    public function run(): void
    {
        try {
            $path = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';
            $basePath = parse_url(url('/'), PHP_URL_PATH) ?: '/';
            if ($basePath !== '/' && strpos($path, $basePath) === 0) $path = substr($path, strlen($basePath));
            $path = '/' . ltrim($path, '/');
            if ($path === '/index.php' || $path === '') $path = '/';
            $this->router->dispatch($_SERVER['REQUEST_METHOD'] ?? 'GET', $path);
        } catch (Throwable $exception) {
            error_log($exception->__toString());
            http_response_code(500);
            (new ErrorController())->serverError();
        }
    }
}
