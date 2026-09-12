<?php
declare(strict_types=1);

final class EmployerController extends Controller
{
	private function authorize(): int
	{
		AuthMiddleware::handle();
		if (Session::get('role') !== 'employer') {
			$target = Session::get('role') === 'freelancer' ? '/dashboard/freelancer' : (Session::get('role') === 'admin' ? '/admin' : '/login');
			$this->redirect($target);
		}
		return (int) Session::get('user_id');
	}
	private function data(int $userId): array { return ['profile'=>(new Profile())->findByUserId($userId),'skills'=>(new Skill())->all(),'jobs'=>(new Job())->forEmployer($userId),'freelancers'=>(new Profile())->freelancers(),'invitations'=>(new Invitation())->forEmployer($userId),'proposals'=>(new Proposal())->forEmployer($userId)]; }
	public function dashboard(): void { $id=$this->authorize(); $this->view('dashboard/employer/overview',['title'=>'داشبورد کارفرما']+$this->data($id),'employer'); }
	public function profilePage(): void { $id=$this->authorize(); $this->view('dashboard/employer/profile',['title'=>'پروفایل کسب‌وکار']+$this->data($id),'employer'); }
	public function jobsPage(): void { $id=$this->authorize(); $this->view('dashboard/employer/jobs',['title'=>'پروژه‌های من']+$this->data($id),'employer'); }
	public function proposalsPage(): void { $id=$this->authorize(); $this->view('dashboard/employer/proposals',['title'=>'پیشنهادهای دریافتی']+$this->data($id),'employer'); }
	public function freelancersPage(): void { $id=$this->authorize(); $this->view('dashboard/employer/freelancers',['title'=>'فریلنسرها']+$this->data($id),'employer'); }
	public function settingsPage(): void { $this->authorize(); $this->view('dashboard/employer/settings',['title'=>'تنظیمات حساب'],'employer'); }
	public function saveProfile(): void
	{
		$userId = $this->authorize(); if (!CSRF::verify($_POST['_csrf'] ?? null)) { Session::flash('error', 'درخواست امنیتی نامعتبر است.'); $this->redirect('/dashboard/employer'); }
		$data = ['username' => trim((string) ($_POST['username'] ?? '')), 'display_name' => trim((string) ($_POST['display_name'] ?? '')), 'headline' => trim((string) ($_POST['headline'] ?? '')), 'bio' => trim((string) ($_POST['bio'] ?? '')), 'timezone' => 'UTC', 'hourly_rate' => null, 'availability' => 'available'];
		if ($data['username'] === '' || $data['display_name'] === '') { Session::flash('error', 'نام شرکت و نام کاربری الزامی هستند.'); $this->redirect('/dashboard/employer'); }
		try { (new Profile())->save($userId, $data); Session::flash('success', 'پروفایل کارفرما ذخیره شد.'); } catch (PDOException $e) { Session::flash('error', 'این نام کاربری قبلاً استفاده شده است.'); }
		$this->redirect('/dashboard/employer');
	}
	public function createJob(): void
	{
		$userId = $this->authorize(); if (!CSRF::verify($_POST['_csrf'] ?? null)) { Session::flash('error', 'درخواست امنیتی نامعتبر است.'); $this->redirect('/dashboard/employer'); }
		$title = trim((string) ($_POST['title'] ?? '')); $description = trim((string) ($_POST['description'] ?? '')); $min = (float) ($_POST['budget_min'] ?? 0); $max = (float) ($_POST['budget_max'] ?? 0);
		if ($title === '' || $description === '' || $min <= 0 || $max < $min) { Session::flash('error', 'عنوان، توضیحات و بازه بودجه معتبر الزامی است.'); $this->redirect('/dashboard/employer'); }
		$slug = trim(preg_replace('/[^a-z0-9]+/i', '-', strtolower($title)), '-') . '-' . bin2hex(random_bytes(3));
		$jobId = (new Job())->create($userId, ['title' => $title, 'slug' => $slug, 'description' => $description, 'budget_min' => $min, 'budget_max' => $max]);
		(new Job())->addSkills($jobId, (array) ($_POST['skill_ids'] ?? [])); Session::flash('success', 'پروژه با موفقیت منتشر شد.'); $this->redirect('/dashboard/employer');
	}
	public function inviteFreelancer(): void
	{
		$userId = $this->authorize(); if (!CSRF::verify($_POST['_csrf'] ?? null)) { Session::flash('error', 'درخواست امنیتی نامعتبر است.'); $this->redirect('/dashboard/employer'); }
		$message = trim((string) ($_POST['message'] ?? '')); $amount = (float) ($_POST['proposed_amount'] ?? 0);
		if ($message === '' || $amount <= 0) { Session::flash('error', 'متن دعوت و مبلغ پیشنهادی الزامی است.'); $this->redirect('/dashboard/employer'); }
		try { (new Invitation())->create($userId, (int) $_POST['job_id'], (int) $_POST['freelancer_id'], $message, $amount); Session::flash('success', 'دعوت همکاری برای فریلنسر ارسال شد.'); } catch (Throwable $e) { Session::flash('error', 'ارسال دعوت انجام نشد؛ پروژه و فریلنسر را بررسی کنید.'); }
		$this->redirect('/dashboard/employer');
	}
	public function updateProposalStatus(): void
	{
		$userId = $this->authorize(); if (!CSRF::verify($_POST['_csrf'] ?? null)) { Session::flash('error', 'درخواست امنیتی نامعتبر است.'); $this->redirect('/dashboard/employer#proposals'); }
		$status = in_array($_POST['status'] ?? '', ['accepted', 'rejected'], true) ? $_POST['status'] : 'rejected';
		try { (new Proposal())->updateStatus((int) ($_POST['proposal_id'] ?? 0), $userId, $status); Session::flash('success', $status === 'accepted' ? 'پیشنهاد پذیرفته شد و قرارداد فعال ایجاد شد.' : 'پیشنهاد رد شد.'); } catch (Throwable $e) { Session::flash('error', 'تغییر وضعیت پیشنهاد انجام نشد.'); }
		$this->redirect('/dashboard/employer#proposals');
	}
	public function replyToProposal(): void
	{
		$userId = $this->authorize(); if (!CSRF::verify($_POST['_csrf'] ?? null)) { Session::flash('error', 'درخواست امنیتی نامعتبر است.'); $this->redirect('/dashboard/employer#proposals'); }
		$body = trim((string) ($_POST['body'] ?? '')); if ($body === '') { Session::flash('error', 'متن پاسخ نمی‌تواند خالی باشد.'); $this->redirect('/dashboard/employer#proposals'); }
		try { (new Proposal())->addMessage((int) ($_POST['proposal_id'] ?? 0), $userId, $body); Session::flash('success', 'پاسخ شما برای فریلنسر ارسال شد.'); } catch (Throwable $e) { Session::flash('error', 'ارسال پاسخ انجام نشد.'); }
		$this->redirect('/dashboard/employer#proposals');
	}
}
