<!doctype html>
<html lang="fa" dir="rtl">
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><meta name="description" content="بازار جهانی امن برای همکاری فریلنسرها و کارفرمایان"><title><?= e($title ?? APP_NAME) ?> · <?= APP_NAME ?></title><link rel="stylesheet" href="<?= url('assets/css/main.css') ?>"><link rel="stylesheet" href="<?= url('assets/css/home-enhancements.css') ?>"><link rel="stylesheet" href="<?= url('assets/css/public-directory.css') ?>"><link rel="stylesheet" href="<?= url('assets/css/search.css') ?>"></head>
<body>
<?php $role = Session::get('role'); $dashboardUrl = $role === 'employer' ? '/dashboard/employer' : ($role === 'freelancer' ? '/dashboard/freelancer' : ''); ?>
<header class="nav"><a class="brand" href="<?= url('/') ?>"><span class="brand-mark">G</span> گلوبال<span>فریلنس</span></a><nav><a href="<?=url('/jobs')?>">پیدا کردن کار</a><a href="<?=url('/freelancers')?>">استخدام متخصص</a><a href="<?=url('/portfolio')?>">نمونه‌کارها</a><a href="<?=url('/social')?>">انجمن</a></nav><div class="nav-actions"><?php if ($dashboardUrl !== ''): ?><a href="<?= url($dashboardUrl) ?>">پنل <?= $role === 'employer' ? 'کارفرما' : 'فریلنسر' ?> ↗</a><form method="post" action="<?= url('/logout') ?>" class="inline-form"><?= csrf_field() ?><button type="submit">خروج</button></form><?php else: ?><a href="<?= url('/login') ?>">ورود</a><a class="button button-small" href="<?= url('/register') ?>">ثبت‌نام</a><?php endif; ?></div></header>
<main><?= $content ?></main>
<footer class="footer"><div class="brand">گلوبال<span>فریلنس</span></div><p>کار ارزشمند، بدون مرز.</p><p>© <?= date('Y') ?> بازار جهانی فریلنسری</p></footer>
<script src="<?= url('assets/js/main.js') ?>"></script></body></html>
