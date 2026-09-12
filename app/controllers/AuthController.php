<?php
declare(strict_types=1);

final class AuthController extends Controller
{
    public function showLogin(): void { $this->view('auth/login', ['title' => 'ورود به حساب کاربری'], 'auth'); }
    public function showRegister(): void { $role = in_array($_GET['role'] ?? '', ['freelancer', 'employer'], true) ? $_GET['role'] : ''; if ($role !== '') $_POST['role'] = $role; $this->view('auth/register', ['title' => 'ساخت حساب کاربری', 'default_role' => $role], 'auth'); }
    public function login(): void
    {
        if (!CSRF::verify($_POST['_csrf'] ?? null)) { Session::flash('error', 'نشست شما منقضی شده است. دوباره تلاش کنید.'); $this->redirect('/login'); }
        $email = strtolower(trim((string) ($_POST['email'] ?? '')));
        $user = (new User())->findByEmail($email);
        if (!$user || !password_verify((string) ($_POST['password'] ?? ''), $user['password_hash'])) { Session::flash('error', 'ایمیل یا رمز عبور نادرست است.'); $this->redirect('/login'); }
        if ($user['status'] === 'suspended') { Session::flash('error', 'این حساب کاربری تعلیق شده است.'); $this->redirect('/login'); }
        if ($user['status'] === 'pending') { Session::flash('error', 'لطفاً ابتدا ایمیل خود را تأیید کنید.'); $this->redirect('/login'); }
        session_regenerate_id(true); Session::put('user_id', (int) $user['id']); Session::put('role', $user['role']);
        $this->redirect($user['role'] === 'freelancer' ? '/dashboard/freelancer' : ($user['role'] === 'employer' ? '/dashboard/employer' : '/admin'));
    }
    public function register(): void
    {
        $errors = Validator::registration($_POST);
        if (!CSRF::verify($_POST['_csrf'] ?? null)) $errors['_csrf'] = 'Invalid security token.';
        if ($errors) { $this->view('auth/register', ['title' => 'ساخت حساب کاربری', 'errors' => $errors, 'default_role' => $_POST['role'] ?? ''], 'auth'); return; }
        try { (new User())->create($_POST); } catch (PDOException $exception) {
            if ((int) $exception->errorInfo[1] === 1062) { $errors['email'] = 'حسابی با این ایمیل از قبل وجود دارد.'; $this->view('auth/register', ['title' => 'ساخت حساب کاربری', 'errors' => $errors, 'default_role' => $_POST['role'] ?? ''], 'auth'); return; }
            throw $exception;
        }
        Session::flash('success', 'حساب شما ساخته شد. لطفاً پیش از ورود ایمیل خود را تأیید کنید.'); $this->redirect('/login');
    }
    public function logout(): void { Session::start(); session_destroy(); $this->redirect('/'); }
}
