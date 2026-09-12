-- Development only. Change this password immediately in production.
-- Login: employer@example.com / Employer123456!
INSERT INTO users (email, password_hash, role, country, email_verified_at, status)
VALUES ('employer@example.com', '$2y$10$iyyb20Wt3DLhKG7i8BCeWexwyvK/HtLpW7rgjpezc5TTOCMlWBib6', 'employer', 'ایران', NOW(), 'active')
ON DUPLICATE KEY UPDATE role = 'employer', country = 'ایران', status = 'active', email_verified_at = COALESCE(email_verified_at, NOW());

INSERT INTO profiles (user_id, username, display_name, headline, bio, timezone, availability)
SELECT id, 'demo-employer', 'کارفرمای نمونه', 'مدیریت پروژه و استخدام متخصص', 'ما به دنبال همکاری با متخصصان خلاق و حرفه‌ای هستیم.', 'Asia/Tehran', 'available'
FROM users WHERE email = 'employer@example.com'
ON DUPLICATE KEY UPDATE display_name = VALUES(display_name), headline = VALUES(headline), bio = VALUES(bio), timezone = VALUES(timezone);
