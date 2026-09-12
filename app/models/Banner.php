<?php declare(strict_types=1);
final class Banner extends Model {
 public function active(): array { $s=$this->db->query("SELECT * FROM banners WHERE status='active' AND (starts_at IS NULL OR starts_at<=NOW()) AND (ends_at IS NULL OR ends_at>=NOW()) ORDER BY sort_order,id"); return $s->fetchAll(); }
 public function all(): array { return $this->db->query('SELECT * FROM banners ORDER BY sort_order,id')->fetchAll(); }
 public function create(array $d): void { $s=$this->db->prepare('INSERT INTO banners (title,subtitle,cta_text,cta_url,image_url,sort_order,status) VALUES (:title,:subtitle,:cta_text,:cta_url,:image_url,:sort_order,:status)');$s->execute($d); }
 public function updateStatus(int $id,string $status): void { $s=$this->db->prepare("UPDATE banners SET status=:status WHERE id=:id");$s->execute(['id'=>$id,'status'=>in_array($status,['active','draft'],true)?$status:'draft']); }
}