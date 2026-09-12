<?php
declare(strict_types=1);

final class User extends Model
{
    public function create(array $data): int { $stmt = $this->db->prepare('INSERT INTO users (email,password_hash,role,country) VALUES (:email,:password_hash,:role,:country)'); $stmt->execute(['email'=>$data['email'],'password_hash'=>password_hash($data['password'], PASSWORD_DEFAULT),'role'=>$data['role'],'country'=>$data['country'] ?? null]); return (int)$this->db->lastInsertId(); }
    public function findByEmail(string $email): ?array { $s=$this->db->prepare('SELECT * FROM users WHERE email=:email LIMIT 1'); $s->execute(['email'=>$email]); return $s->fetch() ?: null; }
    public function allForAdmin(string $status = '', string $role = ''): array
    {
        $where = []; $params = [];
        if ($status !== '') { $where[] = 'u.status = :status'; $params['status'] = $status; }
        if ($role !== '') { $where[] = 'u.role = :role'; $params['role'] = $role; }
        $sql = 'SELECT u.id, u.email, u.role, u.country, u.status, u.email_verified_at, u.created_at, p.display_name FROM users u LEFT JOIN profiles p ON p.user_id = u.id' . ($where ? ' WHERE ' . implode(' AND ', $where) : '') . ' ORDER BY u.created_at DESC';
        $stmt = $this->db->prepare($sql); $stmt->execute($params); return $stmt->fetchAll();
    }
    public function countByStatus(string $status = ''): int
    {
        $stmt = $status === '' ? $this->db->query('SELECT COUNT(*) FROM users') : $this->db->prepare('SELECT COUNT(*) FROM users WHERE status = :status');
        if ($status !== '') $stmt->execute(['status' => $status]); return (int) $stmt->fetchColumn();
    }
    public function updateStatus(int $id, string $status): bool
    {
        $stmt = $this->db->prepare('UPDATE users SET status = :status, email_verified_at = CASE WHEN :new_status = \'active\' THEN COALESCE(email_verified_at, NOW()) ELSE email_verified_at END WHERE id = :id AND role <> \'admin\'');
        return $stmt->execute(['status' => $status, 'new_status' => $status, 'id' => $id]);
    }
}
