<?php
declare(strict_types=1);

class Profile extends Model
{
	public function findByUserId(int $userId): ?array { $s = $this->db->prepare('SELECT * FROM profiles WHERE user_id = :user_id'); $s->execute(['user_id' => $userId]); return $s->fetch() ?: null; }
	public function findByUsername(string $username): ?array { $s = $this->db->prepare('SELECT * FROM profiles WHERE username = :username'); $s->execute(['username' => $username]); return $s->fetch() ?: null; }
	public function save(int $userId, array $data): void
	{
		$sql = 'INSERT INTO profiles (user_id, username, display_name, headline, bio, timezone, hourly_rate, availability) VALUES (:user_id, :username, :display_name, :headline, :bio, :timezone, :hourly_rate, :availability) ON DUPLICATE KEY UPDATE username = VALUES(username), display_name = VALUES(display_name), headline = VALUES(headline), bio = VALUES(bio), timezone = VALUES(timezone), hourly_rate = VALUES(hourly_rate), availability = VALUES(availability)';
		$this->db->prepare($sql)->execute(['user_id' => $userId, 'username' => $data['username'], 'display_name' => $data['display_name'], 'headline' => $data['headline'], 'bio' => $data['bio'], 'timezone' => $data['timezone'], 'hourly_rate' => $data['hourly_rate'] ?: null, 'availability' => $data['availability']]);
	}
	public function freelancers(): array { return $this->db->query("SELECT p.*, u.id AS user_id FROM profiles p INNER JOIN users u ON u.id = p.user_id WHERE u.role = 'freelancer' AND u.status = 'active' ORDER BY p.created_at DESC")->fetchAll(); }
}
