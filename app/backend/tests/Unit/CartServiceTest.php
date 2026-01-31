<?php
namespace App\Tests\Unit;
use PHPUnit\Framework\TestCase;
use App\Service\CartService;
use Doctrine\ORM\EntityManagerInterface;
use App\Entity\{Cart, Product, User};
class CartServiceTest extends TestCase
{
    public function testTotalCents()
    {
        $em = $this->createMock(EntityManagerInterface::class);
        $svc = new CartService($em);
        $user = (new User())->setEmail('u@x.com');
        $cart = (new Cart())->setUser($user);
        $p1 = (new Product())->setName('A')->setPriceCents(1000)->setStock(10);
        $svc->addItem($cart, $p1, 2);
        $this->assertEquals(2000, $svc->totalCents($cart));
    }
}
