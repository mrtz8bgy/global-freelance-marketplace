<?php
declare(strict_types=1);
final class Portfolio extends Model
{
	public function create(int $userId, array $data): void { $s=$this->db->prepare('INSERT INTO portfolios (user_id,title,slug,description,project_url,github_url,technologies,project_result,is_featured) VALUES (:user_id,:title,:slug,:description,:project_url,:github_url,:technologies,:project_result,0)'); $s->execute(['user_id'=>$userId,'title'=>$data['title'],'slug'=>$data['slug'],'description'=>$data['description'],'project_url'=>$data['project_url'] ?: null,'github_url'=>$data['github_url'] ?: null,'technologies'=>$data['technologies'] ?: null,'project_result'=>$data['project_result'] ?: null]); }
	public function forUser(int $userId): array { $s=$this->db->prepare('SELECT * FROM portfolios WHERE user_id=:user_id ORDER BY sort_order,created_at DESC'); $s->execute(['user_id'=>$userId]); return $s->fetchAll(); }
	public function featuredPublic(): array { return $this->db->query("SELECT po.*,p.display_name,p.username FROM portfolios po INNER JOIN users u ON u.id=po.user_id INNER JOIN profiles p ON p.user_id=po.user_id WHERE u.role='freelancer' AND u.status='active' ORDER BY po.is_featured DESC,po.created_at DESC LIMIT 6")->fetchAll(); }
}
