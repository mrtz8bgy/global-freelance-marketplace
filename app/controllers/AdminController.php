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
		$this->view('admin/dashboard', ['title' => 'داشبورد مدیریت', 'stats' => ['all' => $model->countByStatus(), 'pending' => $model->countByStatus('pending'), 'active' => $model->countByStatus('active'), 'suspended' => $model->countByStatus('suspended'), 'jobs' => $this->countTable('jobs'), 'proposals' => $this->countTable('proposals'), 'transactions' => $this->countTable('transactions')]], 'admin');
	}
	private function countTable(string $table): int { return (int) Database::connection()->query("SELECT COUNT(*) FROM `{$table}`")->fetchColumn(); }
	public function users(): void { AdminMiddleware::handle(); $this->view('admin/users', ['title' => 'مدیریت کاربران', 'users' => (new User())->allForAdmin((string) ($_GET['status'] ?? ''), (string) ($_GET['role'] ?? ''))], 'admin'); }
	public function jobs(): void { $this->resourcePage('jobs', 'مدیریت پروژه‌ها', 'شناسه، عنوان، بودجه و وضعیت پروژه‌ها'); }
	public function proposals(): void { $this->resourcePage('proposals', 'مدیریت پیشنهادها', 'پیشنهادهای ارسال‌شده توسط فریلنسرها'); }
	public function reports(): void { $this->resourcePage('reports', 'صف گزارش‌ها', 'گزارش‌های نیازمند بررسی تیم پشتیبانی'); }
	public function transactions(): void { $this->resourcePage('transactions', 'تراکنش‌های مالی', 'دفتر ثبت رویدادهای مالی پلتفرم'); }
	public function commissions(): void { $this->resourcePage('platform_commissions', 'کمیسیون‌های پلتفرم', 'درآمد سایت از قراردادهای موفق'); }
	public function auditLogs(): void { $this->resourcePage('audit_logs', 'گزارش فعالیت مدیران', 'رویدادهای حساس برای کنترل و امنیت'); }
	public function banners(): void { AdminMiddleware::handle(); $this->view('admin/banners',['title'=>'مدیریت بنرهای صفحه اصلی','banners'=>(new Banner())->all()],'admin'); }
	public function createBanner(): void { AdminMiddleware::handle(); if(!CSRF::verify($_POST['_csrf']??null)){Session::flash('error','درخواست امنیتی نامعتبر است.');$this->redirect('/admin/banners');} $title=trim((string)($_POST['title']??'')); if($title===''){Session::flash('error','عنوان بنر الزامی است.');$this->redirect('/admin/banners');} (new Banner())->create(['title'=>$title,'subtitle'=>trim((string)($_POST['subtitle']??'')),'cta_text'=>trim((string)($_POST['cta_text']??'')),'cta_url'=>trim((string)($_POST['cta_url']??'/register')),'image_url'=>trim((string)($_POST['image_url']??'')),'sort_order'=>(int)($_POST['sort_order']??0),'status'=>$_POST['status']==='active'?'active':'draft']); Session::flash('success','بنر با موفقیت ایجاد شد.');$this->redirect('/admin/banners'); }
	public function bannerStatus(): void { AdminMiddleware::handle(); if(CSRF::verify($_POST['_csrf']??null))(new Banner())->updateStatus((int)$_POST['banner_id'],(string)$_POST['status']);$this->redirect('/admin/banners'); }
	public function deleteResource(): void { AdminMiddleware::handle(); if(!CSRF::verify($_POST['_csrf']??null)){$this->redirect('/admin');} $table=(string)($_POST['table']??'');$id=(int)($_POST['id']??0);if(in_array($table,['jobs','posts','reports'],true)&&$id>0){$db=Database::connection();$db->prepare("DELETE FROM `{$table}` WHERE id=:id")->execute(['id'=>$id]);} $this->redirect('/admin/'.$table); }
	private function resourcePage(string $table, string $title, string $description): void
	{
		AdminMiddleware::handle();
		$allowed = ['jobs','proposals','reports','transactions','audit_logs','platform_commissions'];
		if (!in_array($table, $allowed, true)) { $this->redirect('/admin'); return; }
		$db = Database::connection();
		$columns = ['id','created_at'];
		$available = $db->query("DESCRIBE `{$table}`")->fetchAll(PDO::FETCH_COLUMN);
		$columns = array_values(array_intersect(['id','title','status','email','amount','type','action','user_id','job_id','contract_id','gross_amount','rate','commission_amount','target_type','target_id','reason','created_at'], $available));
		$rows = $db->query('SELECT '.implode(',', array_map(fn($c) => "`$c`", $columns))." FROM `{$table}` ORDER BY `created_at` DESC LIMIT 100")->fetchAll();
		$this->view('admin/resource', compact('title','description','table','columns','rows'), 'admin');
	}
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
