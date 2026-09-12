<?php
declare(strict_types=1);

final class PortfolioController extends Controller
{
	public function createForm(): void { AuthMiddleware::handle(); if (Session::get('role') !== 'freelancer') $this->redirect('/'); $this->view('freelancer/add-portfolio', ['title' => 'افزودن نمونه‌کار'], 'dashboard'); }
	public function create(): void
	{
		AuthMiddleware::handle(); if (Session::get('role') !== 'freelancer') $this->redirect('/');
		if (!CSRF::verify($_POST['_csrf'] ?? null)) { Session::flash('error', 'درخواست امنیتی نامعتبر است.'); $this->redirect('/portfolio/create'); }
		$title = trim((string) ($_POST['title'] ?? '')); $description = trim((string) ($_POST['description'] ?? ''));
		if ($title === '' || $description === '') { Session::flash('error', 'عنوان و توضیحات نمونه‌کار الزامی است.'); $this->redirect('/portfolio/create'); }
		$slug = trim(preg_replace('/[^a-z0-9]+/i', '-', strtolower($title)), '-') . '-' . bin2hex(random_bytes(3));
		try { (new Portfolio())->create((int) Session::get('user_id'), ['title' => $title, 'slug' => $slug, 'description' => $description, 'project_url' => trim((string) ($_POST['project_url'] ?? '')), 'github_url' => trim((string) ($_POST['github_url'] ?? '')), 'technologies' => trim((string) ($_POST['technologies'] ?? '')), 'project_result' => trim((string) ($_POST['project_result'] ?? ''))]); Session::flash('success', 'نمونه‌کار با موفقیت ثبت شد.'); } catch (Throwable $e) { Session::flash('error', 'ثبت نمونه‌کار انجام نشد.'); }
		$this->redirect('/dashboard/freelancer#portfolio');
	}
	public function update(): void { AuthMiddleware::handle();if(CSRF::verify($_POST['_csrf']??null)){ $title=trim((string)$_POST['title']);$description=trim((string)$_POST['description']);if($title!==''&&$description!=='')(new Portfolio())->updateOwned((int)$_POST['id'],(int)Session::get('user_id'),['title'=>$title,'description'=>$description,'project_url'=>trim((string)$_POST['project_url']),'github_url'=>trim((string)$_POST['github_url']),'technologies'=>trim((string)$_POST['technologies']),'project_result'=>trim((string)$_POST['project_result'])]);} $this->redirect('/dashboard/freelancer/portfolio'); }
	public function delete(): void { AuthMiddleware::handle();if(CSRF::verify($_POST['_csrf']??null))(new Portfolio())->deleteOwned((int)$_POST['id'],(int)Session::get('user_id'));$this->redirect('/dashboard/freelancer/portfolio'); }
	public function publicIndex(): void { $this->view('portfolio/index', ['title' => 'نمونه‌کارهای فریلنسرها', 'portfolios' => (new Portfolio())->featuredPublic()]); }
}
