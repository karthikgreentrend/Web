<?php
namespace App\Controller;
use App\Entity\Product;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;
class ProductController extends AbstractController
{
    public function __construct(private EntityManagerInterface $em) {}
    #[Route('/api/products', methods: ['GET'])]
    public function list()
    {
        $products = $this->em->getRepository(Product::class)->findAll();
        $data = array_map(fn(Product $p) => [
            'id' => $p->getId(), 'name' => $p->getName(), 'description' => $p->getDescription(),
            'priceCents' => $p->getPriceCents(), 'imageUrl' => $p->getImageUrl(), 'stock' => $p->getStock(),
        ], $products);
        return $this->json($data);
    }
    #[Route('/api/products/{id}', methods: ['GET'])]
    public function show(int $id)
    {
        $p = $this->em->getRepository(Product::class)->find($id);
        if (!$p) return $this->json(['error' => 'Not found'], 404);
        return $this->json(['id'=>$p->getId(),'name'=>$p->getName(),'description'=>$p->getDescription(),'priceCents'=>$p->getPriceCents(),'imageUrl'=>$p->getImageUrl(),'stock'=>$p->getStock()]);
    }
}
