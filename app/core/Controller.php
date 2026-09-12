<?php
declare(strict_types=1);

abstract class Controller
{
    protected function view(string $template, array $data = [], string $layout = 'main'): void
    {
        View::render($template, $data, $layout);
    }

    protected function redirect(string $path)
    {
        header('Location: ' . url($path), true, 302);
        exit;
    }
}
