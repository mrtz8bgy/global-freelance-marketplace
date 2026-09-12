<?php
declare(strict_types=1);

final class AdminMiddleware
{
	public static function handle(): void
	{
		if (Session::get('role') !== 'admin') {
			Session::flash('error', 'دسترسی به پنل مدیریت مجاز نیست.');
			header('Location: ' . url('/admin/login'), true, 302);
			exit;
		}
	}
}
