<?php
namespace App\Controller;
use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
class AuthController extends AbstractController
{
    public function __construct(private EntityManagerInterface $em) {}
    #[Route('/api/register', name: 'api_register', methods: ['POST'])]
    public function register(Request $req, UserPasswordHasherInterface $hasher): JsonResponse
    {
        $data = json_decode($req->getContent(), true) ?? [];
        $email = $data['email'] ?? null; $password = $data['password'] ?? null;
        if (!$email || !$password) return $this->json(['error' => 'Email and password required'], 400);
        if ($this->em->getRepository(User::class)->findOneBy(['email' => $email])) return $this->json(['error' => 'Email exists'], 400);
        $user = (new User())->setEmail($email); $user->setPassword($hasher->hashPassword($user, $password));
        $this->em->persist($user); $this->em->flush();
        return $this->json(['message' => 'Registered']);
    }
}
