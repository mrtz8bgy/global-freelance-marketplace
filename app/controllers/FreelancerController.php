<?php
declare(strict_types=1);

final class FreelancerController extends Controller
{
	private function authorize(): int
	{
		AuthMiddleware::handle();
		if (Session::get('role') !== 'freelancer') {
			$target = Session::get('role') === 'employer' ? '/dashboard/employer' : (Session::get('role') === 'admin' ? '/admin' : '/login');
			$this->redirect($target);
		}
		return (int) Session::get('user_id');
	}
	private function data(int $userId): array { return ['profile'=>(new Profile())->findByUserId($userId),'skills'=>(new Skill())->forUser($userId),'availableSkills'=>(new Skill())->all(),'jobs'=>(new Job())->openForFreelancer($userId),'proposals'=>(new Proposal())->forFreelancer($userId),'portfolios'=>(new Portfolio())->forUser($userId)]; }
	public function dashboard(): void { $id=$this->authorize(); $this->view('dashboard/freelancer/overview',['title'=>'داشبورد فریلنسر']+$this->data($id),'dashboard'); }
	public function profilePage(): void { $id=$this->authorize(); $this->view('dashboard/freelancer/profile',['title'=>'پروفایل فریلنسر']+$this->data($id),'dashboard'); }
	public function jobsPage(): void { $id=$this->authorize(); $this->view('dashboard/freelancer/jobs',['title'=>'پروژه‌های پیشنهادی']+$this->data($id),'dashboard'); }
	public function proposalsPage(): void { $id=$this->authorize(); $this->view('dashboard/freelancer/proposals',['title'=>'پیشنهادهای من']+$this->data($id),'dashboard'); }
	public function portfolioPage(): void { $id=$this->authorize(); $this->view('dashboard/freelancer/portfolio',['title'=>'نمونه‌کارهای من']+$this->data($id),'dashboard'); }
	public function settingsPage(): void { $this->authorize(); $this->view('dashboard/freelancer/settings',['title'=>'تنظیمات حساب'],'dashboard'); }
	public function saveProfile(): void
	{
		$userId = $this->authorize(); if (!CSRF::verify($_POST['_csrf'] ?? null)) { Session::flash('error', 'درخواست امنیتی نامعتبر است.'); $this->redirect('/dashboard/freelancer'); }
		$data = ['username' => trim((string) ($_POST['username'] ?? '')), 'display_name' => trim((string) ($_POST['display_name'] ?? '')), 'headline' => trim((string) ($_POST['headline'] ?? '')), 'bio' => trim((string) ($_POST['bio'] ?? '')), 'timezone' => trim((string) ($_POST['timezone'] ?? 'UTC')), 'hourly_rate' => (float) ($_POST['hourly_rate'] ?? 0), 'availability' => in_array($_POST['availability'] ?? '', ['available', 'busy', 'unavailable'], true) ? $_POST['availability'] : 'available'];
		if ($data['username'] === '' || $data['display_name'] === '') { Session::flash('error', 'نام کاربری و نام نمایشی الزامی هستند.'); $this->redirect('/dashboard/freelancer'); }
		try { (new Profile())->save($userId, $data); Session::flash('success', 'پروفایل شما ذخیره شد.'); } catch (PDOException $e) { Session::flash('error', 'این نام کاربری قبلاً استفاده شده است.'); }
		$this->redirect('/dashboard/freelancer');
	}
	public function addSkill(): void
	{
		$userId = $this->authorize(); if (!CSRF::verify($_POST['_csrf'] ?? null)) { Session::flash('error', 'درخواست امنیتی نامعتبر است.'); $this->redirect('/dashboard/freelancer'); }
		$level = in_array($_POST['level'] ?? '', ['beginner', 'intermediate', 'advanced', 'expert'], true) ? $_POST['level'] : 'intermediate';
		if ((int) ($_POST['skill_id'] ?? 0) > 0) (new Skill())->attachToUser($userId, (int) $_POST['skill_id'], $level);
		Session::flash('success', 'مهارت به پروفایل اضافه شد.'); $this->redirect('/dashboard/freelancer');
	}
	public function submitProposal(): void
	{
		$userId = $this->authorize(); if (!CSRF::verify($_POST['_csrf'] ?? null)) { Session::flash('error', 'درخواست امنیتی نامعتبر است.'); $this->redirect('/dashboard/freelancer'); }
		$letter = trim((string) ($_POST['cover_letter'] ?? '')); $amount = (float) ($_POST['bid_amount'] ?? 0); $jobId = (int) ($_POST['job_id'] ?? 0);
		if ($jobId < 1 || $letter === '' || $amount <= 0) { Session::flash('error', 'متن پیشنهاد و مبلغ معتبر الزامی است.'); $this->redirect('/dashboard/freelancer'); }
		try { (new Proposal())->create($userId, $jobId, $letter, $amount); Session::flash('success', 'پیشنهاد همکاری شما ثبت شد.'); } catch (PDOException $e) { Session::flash('error', 'شما قبلاً برای این پروژه پیشنهاد ثبت کرده‌اید.'); }
		$this->redirect('/dashboard/freelancer');
	}
}
