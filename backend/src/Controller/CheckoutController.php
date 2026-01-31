<?php
namespace App\Controller;
use App\Service\{CartService, CheckoutService};
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;
class CheckoutController extends AbstractController
{
    public function __construct(private CartService $cartService, private CheckoutService $checkout) {}
    #[Route('/api/checkout', methods: ['POST'])]
    public function checkout()
    {
        $cart = $this->cartService->getOrCreateCartForUser($this->getUser());
        $order = $this->checkout->checkout($cart);
        return $this->json(['orderId' => $order->getId(), 'totalCents' => $order->getTotalCents()]);
    }
}
