<?php
declare(strict_types=1);

final class AdminController extends Controller
{
	public function showLogin(): void { $this->view('admin/login', ['title' => 'ورود مدیر سیستم'], 'auth'); }
	public function login(): void
	{
		if (!CSRF::verify($_POST['_csrf'] ?? null)) { Session::flash('error', 'نشست شما منقضی شده است.'); $this->redirect('/admin/login'); }
		$user = (new User())->findByEmail(strtolower(trim((string) ($_POST['email'] ?? ''))));
		if (!$user || $user['role'] !== 'admin' || !password_verify((string) ($_POST['password'] ?? ''), $user['password_hash'])) { Session::flash('error', 'اطلاعات ورود مدیر نادرست است.'); $this->redirect('/admin/login'); }
		if ($user['status'] !== 'active') { Session::flash('error', 'حساب مدیر فعال نیست.'); $this->redirect('/admin/login'); }
		session_regenerate_id(true); Session::put('user_id', (int) $user['id']); Session::put('role', 'admin'); $this->redirect('/admin');
	}
	public function dashboard(): void
	{
		AdminMiddleware::handle(); $model = new User();
		$this->view('admin/dashboard', ['title' => 'داشبورد مدیریت', 'stats' => ['all' => $model->countByStatus(), 'pending' => $model->countByStatus('pending'), 'active' => $model->countByStatus('active'), 'suspended' => $model->countByStatus('suspended')]], 'admin');
	}
	public function users(): void { AdminMiddleware::handle(); $this->view('admin/users', ['title' => 'مدیریت کاربران', 'users' => (new User())->allForAdmin((string) ($_GET['status'] ?? ''), (string) ($_GET['role'] ?? ''))], 'admin'); }
	public function verifyUser(): void { $this->changeStatus('active'); }
	public function suspendUser(): void { $this->changeStatus('suspended'); }
	private function changeStatus(string $status): void
	{
		AdminMiddleware::handle();
		if (!CSRF::verify($_POST['_csrf'] ?? null)) { Session::flash('error', 'درخواست امنیتی نامعتبر است.'); $this->redirect('/admin/users'); }
		(new User())->updateStatus((int) ($_POST['user_id'] ?? 0), $status);
		Session::flash('success', $status === 'active' ? 'کاربر با موفقیت تأیید شد.' : 'کاربر تعلیق شد.'); $this->redirect('/admin/users');
	}
	public function logout(): void { session_destroy(); $this->redirect('/admin/login'); }
}
