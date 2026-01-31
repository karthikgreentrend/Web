<?php
namespace App\DataFixtures;
use App\Entity\Product;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;
class AppFixtures extends Fixture
{
    public function load(ObjectManager $manager): void
    {
        foreach ([['name'=>'Laptop Pro 15','price'=>149999,'stock'=>10],['name'=>'Wireless Mouse','price'=>1999,'stock'=>100],['name'=>'Mechanical Keyboard','price'=>5999,'stock'=>50]] as $p) {
            $prod = (new Product())->setName($p['name'])->setPriceCents($p['price'])->setStock($p['stock'])->setDescription('Sample product')->setImageUrl(null);
            $manager->persist($prod);
        }
        $manager->flush();
    }
}
