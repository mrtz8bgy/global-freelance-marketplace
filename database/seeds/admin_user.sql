-- Development only. Change the password immediately in production.
INSERT INTO users (email, password_hash, role, country, email_verified_at, status)
VALUES ('admin@example.com', '$2y$10$bLibn140tARjEIyQ705tLOh8Tmshg7lT.0dno9XjM1pRq9GP9h2li', 'admin', 'Global', NOW(), 'active')
ON DUPLICATE KEY UPDATE role = 'admin', status = 'active', email_verified_at = COALESCE(email_verified_at, NOW());
