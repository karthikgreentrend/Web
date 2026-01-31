<?php
namespace App\Service;
use App\Entity\{Order, OrderItem, Cart};
use Doctrine\ORM\EntityManagerInterface;
class CheckoutService
{
    public function __construct(private EntityManagerInterface $em, private CartService $cartService) {}
    public function checkout(Cart $cart): Order
    {
        $order = (new Order())->setUser($cart->getUser());
        $total = 0;
        foreach ($cart->getItems() as $ci) {
            $oi = (new OrderItem())
                ->setOrder($order)
                ->setProductId($ci->getProduct()->getId())
                ->setProductName($ci->getProduct()->getName())
                ->setUnitPriceCents($ci->getUnitPriceCents())
                ->setQuantity($ci->getQuantity());
            $this->em->persist($oi);
            $total += $ci->getUnitPriceCents() * $ci->getQuantity();
            $p = $ci->getProduct();
            $p->setStock(max(0, $p->getStock() - $ci->getQuantity()));
        }
        $order->setTotalCents($total); $cart->setStatus('CHECKED_OUT');
        $this->em->persist($order); $this->em->flush();
        return $order;
    }
}
