<?php
namespace App\Controller;
use App\Entity\Order;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;
class OrderController extends AbstractController
{
    public function __construct(private EntityManagerInterface $em) {}
    #[Route('/api/orders', methods: ['GET'])]
    public function list()
    {
        $orders = $this->em->getRepository(Order::class)->findBy(['user' => $this->getUser()], ['id' => 'DESC']);
        $data = array_map(fn(Order $o) => ['id'=>$o->getId(), 'totalCents'=>$o->getTotalCents(), 'createdAt'=>$o->getCreatedAt()->format(DATE_ATOM)], $orders);
        return $this->json($data);
    }
    #[Route('/api/orders/{id}', methods: ['GET'])]
    public function show(int $id)
    {
        $order = $this->em->getRepository(Order::class)->find($id);
        if (!$order || $order->getUser()->getId() !== $this->getUser()->getId()) return $this->json(['error'=>'Not found'], 404);
        return $this->json(['id'=>$order->getId(),'totalCents'=>$order->getTotalCents(),'items'=>array_map(fn($i)=>['productId'=>$i->getProductId(),'productName'=>$i->getProductName(),'unitPriceCents'=>$i->getUnitPriceCents(),'quantity'=>$i->getQuantity()], $order->getItems()->toArray())]);
    }
}
