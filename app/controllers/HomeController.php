<?php
declare(strict_types=1);

final class HomeController extends Controller
{
    public function index(): void { try { $jobs = (new Job())->featuredPublic(); $portfolios = (new Portfolio())->featuredPublic(); $banners = (new Banner())->active(); $freelancers = (new Profile())->freelancers(); } catch (Throwable $e) { $jobs = []; $portfolios = []; $banners = []; } $this->view('home/index', ['title' => 'Build what matters', 'featuredJobs' => $jobs, 'featuredPortfolios' => $portfolios, 'freelancers' => array_slice($freelancers ?? [],0,6), 'banners' => $banners]); }
}
