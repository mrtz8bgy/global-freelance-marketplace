<?php
declare(strict_types=1);

final class Contract extends Model
{
    public function forUser(int $userId, string $role): array
    {
        $field = $role === 'employer' ? 'c.employer_id' : 'c.freelancer_id';
        $s = $this->db->prepare("SELECT c.*, j.title, p.display_name AS other_party FROM contracts c INNER JOIN jobs j ON j.id=c.job_id LEFT JOIN profiles p ON p.user_id=CASE WHEN c.employer_id=:uid THEN c.freelancer_id ELSE c.employer_id END WHERE {$field}=:uid ORDER BY c.created_at DESC");
        $s->execute(['uid'=>$userId]); return $s->fetchAll();
    }
    public function milestones(int $contractId): array { $s=$this->db->prepare('SELECT * FROM milestones WHERE contract_id=:id ORDER BY sort_order,id'); $s->execute(['id'=>$contractId]); return $s->fetchAll(); }
    public function addMilestone(int $contractId, string $title, string $description, float $amount, ?string $dueDate): void { $s=$this->db->prepare('INSERT INTO milestones (contract_id,title,description,amount,due_date,sort_order) VALUES (:contract_id,:title,:description,:amount,:due_date,(SELECT COALESCE(MAX(m.sort_order),0)+1 FROM milestones m WHERE m.contract_id=:contract_id2))'); $s->execute(['contract_id'=>$contractId,'contract_id2'=>$contractId,'title'=>$title,'description'=>$description,'amount'=>$amount,'due_date'=>$dueDate]); }
    public function updateMilestone(int $milestoneId, int $userId, string $status): bool { $allowed=['submitted','revision','approved','released']; if(!in_array($status,$allowed,true)) return false; $s=$this->db->prepare("UPDATE milestones m INNER JOIN contracts c ON c.id=m.contract_id SET m.status=:status WHERE m.id=:mid AND (c.employer_id=:uid OR c.freelancer_id=:uid2)"); return $s->execute(['status'=>$status,'mid'=>$milestoneId,'uid'=>$userId,'uid2'=>$userId]); }
}