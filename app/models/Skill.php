<?php
declare(strict_types=1);
final class Skill extends Model
{
	public function all(): array { return $this->db->query('SELECT id, name FROM skills ORDER BY name')->fetchAll(); }
	public function forUser(int $userId): array { $s = $this->db->prepare('SELECT s.id, s.name, us.level FROM skills s INNER JOIN user_skills us ON us.skill_id = s.id WHERE us.user_id = :user_id ORDER BY s.name'); $s->execute(['user_id' => $userId]); return $s->fetchAll(); }
	public function attachToUser(int $userId, int $skillId, string $level): void { $s = $this->db->prepare('INSERT INTO user_skills (user_id, skill_id, level) VALUES (:user_id, :skill_id, :level) ON DUPLICATE KEY UPDATE level = VALUES(level)'); $s->execute(['user_id' => $userId, 'skill_id' => $skillId, 'level' => $level]); }
}
