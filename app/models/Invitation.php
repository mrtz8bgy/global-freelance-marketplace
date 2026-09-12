<?php
declare(strict_types=1);

final class Invitation extends Model
{
    public function forEmployer(int $employerId): array { $s = $this->db->prepare('SELECT i.*, j.title, p.display_name AS freelancer_name FROM job_invitations i INNER JOIN jobs j ON j.id = i.job_id INNER JOIN profiles p ON p.user_id = i.freelancer_id WHERE i.employer_id = :employer_id ORDER BY i.created_at DESC'); $s->execute(['employer_id' => $employerId]); return $s->fetchAll(); }
    public function create(int $employerId, int $jobId, int $freelancerId, string $message, float $amount): void { $s = $this->db->prepare('INSERT INTO job_invitations (job_id, employer_id, freelancer_id, message, proposed_amount) SELECT j.id, j.employer_id, :freelancer_id, :message, :amount FROM jobs j INNER JOIN users u ON u.id = :freelancer_id_check AND u.role = \'freelancer\' AND u.status = \'active\' WHERE j.id = :job_id AND j.employer_id = :employer_id'); $s->execute(['freelancer_id' => $freelancerId, 'message' => $message, 'amount' => $amount, 'freelancer_id_check' => $freelancerId, 'job_id' => $jobId, 'employer_id' => $employerId]); if ($s->rowCount() < 1) throw new RuntimeException('دعوت همکاری نامعتبر است.'); }
}