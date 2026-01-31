<?php
namespace App\Entity;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Security\Core\User\PasswordAuthenticatedUserInterface;
use Symfony\Component\Security\Core\User\UserInterface;
use Symfony\Component\Validator\Constraints as Assert;
#[ORM\Entity]
class User implements UserInterface, PasswordAuthenticatedUserInterface
{
    #[ORM\Id, ORM\GeneratedValue, ORM\Column] private ?int $id = null;
    #[ORM\Column(length:180, unique:true)] #[Assert\NotBlank, Assert\Email] private ?string $email = null;
    #[ORM\Column] private array $roles = [];
    #[ORM\Column] private ?string $password = null;
    public function getId(): ?int { return $this->id; }
    public function getEmail(): ?string { return $this->email; }
    public function setEmail(string $email): self { $this->email = $email; return $this; }
    public function getUserIdentifier(): string { return (string)$this->email; }
    public function getRoles(): array { $r = $this->roles; $r[]='ROLE_USER'; return array_unique($r); }
    public function setRoles(array $roles): self { $this->roles=$roles; return $this; }
    public function getPassword(): ?string { return $this->password; }
    public function setPassword(string $password): self { $this->password=$password; return $this; }
    public function eraseCredentials() {}
}
