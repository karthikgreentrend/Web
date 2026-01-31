<?php
namespace App\Entity;
use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
#[ORM\Entity]
class Cart
{
    #[ORM\Id, ORM\GeneratedValue, ORM\Column] private ?int $id = null;
    #[ORM\OneToOne(targetEntity: User::class)] private ?User $user = null;
    #[ORM\OneToMany(mappedBy: 'cart', targetEntity: CartItem::class, cascade: ['persist','remove'], orphanRemoval: true)] private Collection $items;
    #[ORM\Column(length:16)] private string $status = 'OPEN';
    public function __construct(){ $this->items = new ArrayCollection(); }
    public function getId(): ?int { return $this->id; }
    public function getUser(): ?User { return $this->user; }
    public function setUser(User $u): self { $this->user=$u; return $this; }
    /** @return Collection<int, CartItem> */
    public function getItems(): Collection { return $this->items; }
    public function addItem(CartItem $i): self { if(!$this->items->contains($i)){ $this->items->add($i); $i->setCart($this);} return $this; }
    public function removeItem(CartItem $i): self { $this->items->removeElement($i); return $this; }
    public function getStatus(): string { return $this->status; }
    public function setStatus(string $s): self { $this->status=$s; return $this; }
}
