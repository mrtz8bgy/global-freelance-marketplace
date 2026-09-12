<?php
declare(strict_types=1);

final class Validator
{
    public static function registration(array $input): array
    {
        $errors = [];
        if (!filter_var($input['email'] ?? '', FILTER_VALIDATE_EMAIL)) $errors['email'] = 'ایمیل معتبر وارد کنید.';
        if (strlen((string) ($input['password'] ?? '')) < 12) $errors['password'] = 'رمز عبور باید حداقل ۱۲ کاراکتر باشد.';
        if (($input['password'] ?? '') !== ($input['password_confirmation'] ?? '')) $errors['password_confirmation'] = 'رمزهای عبور یکسان نیستند.';
        if (!in_array($input['role'] ?? '', ['freelancer', 'employer'], true)) $errors['role'] = 'نوع حساب را انتخاب کنید.';
        if (trim((string) ($input['country'] ?? '')) === '') $errors['country'] = 'کشور الزامی است.';
        if (empty($input['terms'])) $errors['terms'] = 'پذیرش قوانین و حریم خصوصی الزامی است.';
        return $errors;
    }
}
