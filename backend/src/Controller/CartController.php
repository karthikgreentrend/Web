<?php
namespace App\Controller;
use App\Entity\Product;
use App\Service\CartService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;
class CartController extends AbstractController
{
    public function __construct(private CartService $cartService, private EntityManagerInterface $em) {}
    #[Route('/api/cart', methods: ['GET'])]
    public function getCart()
    {
        $user = $this->getUser(); $cart = $this->cartService->getOrCreateCartForUser($user);
        return $this->json([
            'id' => $cart->getId(), 'status' => $cart->getStatus(),
            'items' => array_map(fn($i) => [ 'productId' => $i->getProduct()->getId(), 'name' => $i->getProduct()->getName(), 'priceCents' => $i->getUnitPriceCents(), 'quantity' => $i->getQuantity() ], $cart->getItems()->toArray()),
            'totalCents' => $this->cartService->totalCents($cart)
        ]);
    }
    #[Route('/api/cart/items', methods: ['POST'])]
    public function addItem(Request $req)
    {
        $data = json_decode($req->getContent(), true) ?? []; $productId=(int)($data['productId']??0); $qty=(int)($data['quantity']??1);
        $product = $this->em->getRepository(Product::class)->find($productId);
        if (!$product) return $this->json(['error' => 'Invalid product'], 400);
        $cart = $this->cartService->getOrCreateCartForUser($this->getUser()); $this->cartService->addItem($cart,$product,$qty);
        $this->em->flush(); return $this->json(['message' => 'Added']);
    }
    #[Route('/api/cart/items/{productId}', methods: ['PUT','PATCH'])]
    public function updateItem(int $productId, Request $req)
    {
        $qty = (int)((json_decode($req->getContent(), true) ?? [])['quantity'] ?? 1);
        $cart = $this->cartService->getOrCreateCartForUser($this->getUser()); $this->cartService->updateItem($cart, $productId, $qty); $this->em->flush();
        return $this->json(['message' => 'Updated']);
    }
    #[Route('/api/cart/items/{productId}', methods: ['DELETE'])]
    public function removeItem(int $productId)
    {
        $cart = $this->cartService->getOrCreateCartForUser($this->getUser()); $this->cartService->updateItem($cart, $productId, 0); $this->em->flush(); return $this->json(['message' => 'Removed']);
    }
    #[Route('/api/cart/clear', methods: ['POST'])]
    public function clear()
    {
        $cart = $this->cartService->getOrCreateCartForUser($this->getUser()); $this->cartService->clear($cart); $this->em->flush(); return $this->json(['message' => 'Cleared']);
    }
}
