<?php
namespace App\Entity;
use Doctrine\ORM\Mapping as ORM;
#[ORM\Entity]
class Product
{
    #[ORM\Id, ORM\GeneratedValue, ORM\Column] private ?int $id = null;
    #[ORM\Column(length:255)] private ?string $name = null;
    #[ORM\Column(type: 'text', nullable: true)] private ?string $description = null;
    #[ORM\Column] private int $priceCents = 0;
    #[ORM\Column(length:255, nullable:true)] private ?string $imageUrl = null;
    #[ORM\Column] private int $stock = 0;
    public function getId(): ?int { return $this->id; }
    public function getName(): ?string { return $this->name; }
    public function setName(string $name): self { $this->name=$name; return $this; }
    public function getDescription(): ?string { return $this->description; }
    public function setDescription(?string $d): self { $this->description=$d; return $this; }
    public function getPriceCents(): int { return $this->priceCents; }
    public function setPriceCents(int $v): self { $this->priceCents=$v; return $this; }
    public function getImageUrl(): ?string { return $this->imageUrl; }
    public function setImageUrl(?string $u): self { $this->imageUrl=$u; return $this; }
    public function getStock(): int { return $this->stock; }
    public function setStock(int $s): self { $this->stock=$s; return $this; }
}
