<?php
declare(strict_types=1);

final class View
{
    public static function render(string $template, array $data = [], string $layout = 'main'): void
    {
        extract($data, EXTR_SKIP);
        $view = BASE_PATH . '/app/views/' . $template . '.php';
        $layoutFile = BASE_PATH . '/app/views/layouts/' . $layout . '.php';
        if (!is_file($view) || !is_file($layoutFile)) { throw new RuntimeException('View not found.'); }
        ob_start(); require $view; $content = ob_get_clean();
        require $layoutFile;
    }
}
