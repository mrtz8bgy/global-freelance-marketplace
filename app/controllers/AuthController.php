<?php
declare(strict_types=1);

final class AuthController extends Controller
{
    public function showLogin(): void { $this->view('auth/login', ['title' => 'ورود به حساب کاربری'], 'auth'); }
    public function showRegister(): void { $role = in_array($_GET['role'] ?? '', ['freelancer', 'employer'], true) ? $_GET['role'] : ''; $this->view('auth/register', ['title' => 'ساخت حساب کاربری', 'default_role' => $role], 'auth'); }
    public function login(): void
    {
        if (!RateLimitMiddleware::hit('login_'.($_SERVER['REMOTE_ADDR']??'unknown'),8,300)) { Session::flash('error','تعداد تلاش‌ها زیاد است. چند دقیقه بعد دوباره تلاش کنید.'); $this->redirect('/login'); }
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
        try { $newId=(new User())->create($_POST); $raw=bin2hex(random_bytes(32)); $s=Database::connection()->prepare("INSERT INTO auth_tokens(user_id,email,token_hash,type,expires_at) VALUES(:uid,:email,:hash,'verify',DATE_ADD(NOW(),INTERVAL 24 HOUR))");$s->execute(['uid'=>$newId,'email'=>$_POST['email'],'hash'=>hash('sha256',$raw)]); } catch (PDOException $exception) {
            if ((int) $exception->errorInfo[1] === 1062) { $errors['email'] = 'حسابی با این ایمیل از قبل وجود دارد.'; $this->view('auth/register', ['title' => 'ساخت حساب کاربری', 'errors' => $errors, 'default_role' => $_POST['role'] ?? ''], 'auth'); return; }
            throw $exception;
        }
        Session::flash('success', 'حساب شما ساخته شد. لطفاً پیش از ورود ایمیل خود را تأیید کنید.'); $this->redirect('/login');
    }
    public function verifyEmail(): void { $token=(string)($_GET['token']??'');if($token!==''){ $db=Database::connection();$s=$db->prepare("SELECT user_id FROM auth_tokens WHERE token_hash=:h AND type='verify' AND used_at IS NULL AND expires_at>NOW() LIMIT 1");$s->execute(['h'=>hash('sha256',$token)]);if($row=$s->fetch()){$db->prepare("UPDATE users SET status='active',email_verified_at=NOW() WHERE id=:id")->execute(['id'=>$row['user_id']]);$db->prepare('UPDATE auth_tokens SET used_at=NOW() WHERE token_hash=:h')->execute(['h'=>hash('sha256',$token)]);Session::flash('success','ایمیل شما تأیید شد.');}}$this->redirect('/login'); }
    public function logout(): void { Session::start(); session_destroy(); $this->redirect('/'); }
}
