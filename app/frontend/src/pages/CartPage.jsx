import { useEffect, useState } from 'react';
import { getCart, updateCartItem, removeCartItem, clearCart } from '../api/endpoints';
import { Link, useNavigate } from 'react-router-dom';
export default function CartPage() {
  const [cart, setCart] = useState(null);
  const navigate = useNavigate();
  const refresh = () => getCart().then(setCart);
  useEffect(refresh, []);
  if (!cart) return <div>Loading...</div>;
  return (
    <div style={{ padding: 24 }}>
      <h1>Your Cart</h1>
      {cart.items.length === 0 ? <p>Empty cart</p> : (
        <>
          <ul>
            {cart.items.map(i => (
              <li key={i.productId}>
                {i.name} — ₹{(i.priceCents/100).toFixed(2)} x
                <input type="number" value={i.quantity} min={1} onChange={async (e) => { await updateCartItem(i.productId, +e.target.value); refresh(); }} />
                <button onClick={async () => { await removeCartItem(i.productId); refresh(); }}>Remove</button>
              </li>
            ))}
          </ul>
          <h3>Total: ₹{(cart.totalCents/100).toFixed(2)}</h3>
          <button onClick={() => navigate('/checkout')}>Proceed to Checkout</button>
          <button onClick={async () => { await clearCart(); refresh(); }}>Clear Cart</button>
          <p><Link to="/">Continue shopping</Link></p>
        </>
      )}
    </div>
  );
}
