<?php
namespace App\Tests\Functional;
use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use Doctrine\ORM\EntityManagerInterface;
use App\Entity\User;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
class CartApiTest extends WebTestCase
{
    private function createUser($client, $email='test@example.com', $password='password'): ?string
    {
        $em = static::getContainer()->get(EntityManagerInterface::class);
        $hasher = static::getContainer()->get(UserPasswordHasherInterface::class);
        $u = (new User())->setEmail($email);
        $u->setPassword($hasher->hashPassword($u, $password));
        $em->persist($u); $em->flush();
        $client->request('POST', '/api/login', [], [], ['CONTENT_TYPE'=>'application/json'], json_encode(['email'=>$email,'password'=>$password]));
        $this->assertResponseIsSuccessful();
        $data = json_decode($client->getResponse()->getContent(), true);
        return $data['token'] ?? $data['id_token'] ?? null;
    }
    public function testAddToCartFlow()
    {
        $client = static::createClient();
        $token = $this->createUser($client);
        $client->request('GET', '/api/products');
        $this->assertResponseIsSuccessful();
        $products = json_decode($client->getResponse()->getContent(), true);
        $this->assertNotEmpty($products);
        $pid = $products[0]['id'];
        $client->request('POST', '/api/cart/items', [], [], ['CONTENT_TYPE'=>'application/json','HTTP_Authorization'=>"Bearer $token"], json_encode(['productId'=>$pid,'quantity'=>2]));
        $this->assertResponseIsSuccessful();
        $client->request('GET', '/api/cart', [], [], ['HTTP_Authorization'=>"Bearer $token"]);
        $this->assertResponseIsSuccessful();
        $cart = json_decode($client->getResponse()->getContent(), true);
        $this->assertEquals(1, count($cart['items']));
    }
}
