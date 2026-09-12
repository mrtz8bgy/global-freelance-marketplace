# Deployment

Use PHP 8.1+, Apache with `mod_rewrite`, MySQL 8+, HTTPS and a document root pointing to `public/`. Set production environment variables, disable PHP display errors, configure writable `storage/` directories, import migrations, and schedule `scripts/cron.php`.
