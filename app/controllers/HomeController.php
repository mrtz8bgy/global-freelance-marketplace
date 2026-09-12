<?php
declare(strict_types=1);

final class HomeController extends Controller
{
    public function index(): void { try { $jobs = (new Job())->featuredPublic(); $portfolios = (new Portfolio())->featuredPublic(); $banners = (new Banner())->active(); } catch (Throwable $e) { $jobs = []; $portfolios = []; $banners = []; } $this->view('home/index', ['title' => 'Build what matters', 'featuredJobs' => $jobs, 'featuredPortfolios' => $portfolios, 'banners' => $banners]); }
}
