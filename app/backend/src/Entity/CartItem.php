<?php
namespace App\Entity;
use Doctrine\ORM\Mapping as ORM;
#[ORM\Entity]
class CartItem
{
    #[ORM\Id, ORM\GeneratedValue, ORM\Column] private ?int $id = null;
    #[ORM\ManyToOne(targetEntity: Cart::class, inversedBy: 'items')] #[ORM\JoinColumn(nullable:false)] private ?Cart $cart = null;
    #[ORM\ManyToOne(targetEntity: Product::class)] #[ORM\JoinColumn(nullable:false)] private ?Product $product = null;
    #[ORM\Column] private int $quantity = 1;
    #[ORM\Column] private int $unitPriceCents = 0;
    public function getId(): ?int { return $this->id; }
    public function getCart(): ?Cart { return $this->cart; }
    public function setCart(Cart $c): self { $this->cart=$c; return $this; }
    public function getProduct(): ?Product { return $this->product; }
    public function setProduct(Product $p): self { $this->product=$p; return $this; }
    public function getQuantity(): int { return $this->quantity; }
    public function setQuantity(int $q): self { $this->quantity=$q; return $this; }
    public function getUnitPriceCents(): int { return $this->unitPriceCents; }
    public function setUnitPriceCents(int $c): self { $this->unitPriceCents=$c; return $this; }
}
