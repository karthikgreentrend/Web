<?php
namespace App\Entity;
use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
#[ORM\Entity]
#[ORM\Table(name: '`order`')]
class Order
{
    #[ORM\Id, ORM\GeneratedValue, ORM\Column] private ?int $id = null;
    #[ORM\ManyToOne(targetEntity: User::class)] private ?User $user = null;
    #[ORM\OneToMany(mappedBy: 'order', targetEntity: OrderItem::class, cascade: ['persist'], orphanRemoval: true)] private Collection $items;
    #[ORM\Column] private int $totalCents = 0;
    #[ORM\Column(type: 'datetime_immutable')] private \DateTimeImmutable $createdAt;
    public function __construct(){ $this->items = new ArrayCollection(); $this->createdAt = new \DateTimeImmutable(); }
    public function getId(): ?int { return $this->id; }
    public function getUser(): ?User { return $this->user; }
    public function setUser(User $u): self { $this->user=$u; return $this; }
    /** @return Collection<int, OrderItem> */
    public function getItems(): Collection { return $this->items; }
    public function addItem(OrderItem $i): self { if(!$this->items->contains($i)){ $this->items->add($i); $i->setOrder($this);} return $this; }
    public function getTotalCents(): int { return $this->totalCents; }
    public function setTotalCents(int $t): self { $this->totalCents=$t; return $this; }
    public function getCreatedAt(): \DateTimeImmutable { return $this->createdAt; }
}
