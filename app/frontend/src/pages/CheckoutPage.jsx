import { checkout } from '../api/endpoints';
import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
export default function CheckoutPage() {
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();
  return (
    <div style={{ padding: 24 }}>
      <h1>Checkout</h1>
      <p>For demo, this creates an order from your cart.</p>
      <button disabled={loading} onClick={async () => { setLoading(true); await checkout(); setLoading(false); navigate(`/orders`); }}>Place Order</button>
    </div>
  );
}
