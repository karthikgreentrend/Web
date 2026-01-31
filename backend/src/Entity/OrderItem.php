<?php
namespace App\Entity;
use Doctrine\ORM\Mapping as ORM;
#[ORM\Entity]
class OrderItem
{
    #[ORM\Id, ORM\GeneratedValue, ORM\Column] private ?int $id = null;
    #[ORM\ManyToOne(targetEntity: Order::class, inversedBy: 'items')] private ?Order $order = null;
    #[ORM\Column] private int $productId;
    #[ORM\Column(length:255)] private string $productName;
    #[ORM\Column] private int $unitPriceCents;
    #[ORM\Column] private int $quantity;
    public function getId(): ?int { return $this->id; }
    public function getOrder(): ?Order { return $this->order; }
    public function setOrder(Order $o): self { $this->order=$o; return $this; }
    public function getProductId(): int { return $this->productId; }
    public function setProductId(int $id): self { $this->productId=$id; return $this; }
    public function getProductName(): string { return $this->productName; }
    public function setProductName(string $n): self { $this->productName=$n; return $this; }
    public function getUnitPriceCents(): int { return $this->unitPriceCents; }
    public function setUnitPriceCents(int $c): self { $this->unitPriceCents=$c; return $this; }
    public function getQuantity(): int { return $this->quantity; }
    public function setQuantity(int $q): self { $this->quantity=$q; return $this; }
}
