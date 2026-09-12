<?php
declare(strict_types=1);

final class ErrorController extends Controller
{
    public function notFound(): void { $this->view('errors/404', ['title' => 'Page not found']); }
    public function serverError(): void { $this->view('errors/500', ['title' => 'Something went wrong']); }
}
