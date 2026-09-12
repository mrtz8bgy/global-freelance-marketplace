<?php
declare(strict_types=1);

final class HomeController extends Controller
{
    public function index(): void { try { $jobs = (new Job())->featuredPublic(); $portfolios = (new Portfolio())->featuredPublic(); } catch (Throwable $e) { $jobs = []; $portfolios = []; } $this->view('home/index', ['title' => 'Build what matters', 'featuredJobs' => $jobs, 'featuredPortfolios' => $portfolios]); }
}
