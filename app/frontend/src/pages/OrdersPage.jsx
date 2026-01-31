import { useEffect, useState } from 'react';
import { getOrders } from '../api/endpoints';
export default function OrdersPage() {
  const [orders, setOrders] = useState([]);
  useEffect(() => { getOrders().then(setOrders); }, []);
  return (
    <div style={{ padding: 24 }}>
      <h1>Your Orders</h1>
      <ul>
        {orders.map(o => (
          <li key={o.id}>Order #{o.id} — ₹{(o.totalCents/100).toFixed(2)} — {o.createdAt}</li>
        ))}
      </ul>
    </div>
  );
}
