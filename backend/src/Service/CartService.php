<?php
namespace App\Service;
use App\Entity\{Cart, CartItem, Product, User};
use Doctrine\ORM\EntityManagerInterface;
class CartService
{
    public function __construct(private EntityManagerInterface $em) {}
    public function getOrCreateCartForUser(User $user): Cart
    {
        $repo = $this->em->getRepository(Cart::class);
        $cart = $repo->findOneBy(['user' => $user, 'status' => 'OPEN']);
        if (!$cart) { $cart = (new Cart())->setUser($user); $this->em->persist($cart); $this->em->flush(); }
        return $cart;
    }
    public function addItem(Cart $cart, Product $product, int $qty): Cart
    {
        if ($qty < 1) $qty = 1;
        foreach ($cart->getItems() as $item) {
            if ($item->getProduct() === $product) { $item->setQuantity($item->getQuantity()+$qty); return $cart; }
        }
        $item = (new CartItem())->setCart($cart)->setProduct($product)->setQuantity($qty)->setUnitPriceCents($product->getPriceCents());
        $this->em->persist($item); return $cart;
    }
    public function updateItem(Cart $cart, int $productId, int $qty): void
    {
        foreach ($cart->getItems() as $item) {
            if ($item->getProduct() && $item->getProduct()->getId() == $productId) {
                if ($qty <= 0) { $this->em->remove($item); } else { $item->setQuantity($qty); }
                return;
            }
        }
    }
    public function clear(Cart $cart): void { foreach ($cart->getItems() as $item) { $this->em->remove($item); } }
    public function totalCents(Cart $cart): int { $sum=0; foreach ($cart->getItems() as $i) { $sum += $i->getUnitPriceCents()*$i->getQuantity(); } return $sum; }
}
