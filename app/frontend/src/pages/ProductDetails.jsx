import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { fetchProduct, addToCart } from '../api/endpoints';
export default function ProductDetails() {
  const { id } = useParams();
  const [p, setP] = useState(null);
  const [qty, setQty] = useState(1);
  const navigate = useNavigate();
  useEffect(() => { fetchProduct(id).then(setP); }, [id]);
  if (!p) return <div>Loading...</div>;
  return (
    <div style={{ padding: 24 }}>
      <h2>{p.name}</h2>
      <p>₹{(p.priceCents/100).toFixed(2)}</p>
      <p>{p.description}</p>
      <input type="number" min="1" value={qty} onChange={e => setQty(+e.target.value)} />
      <button onClick={async () => { await addToCart(p.id, qty); navigate('/cart'); }}>Add to Cart</button>
    </div>
  );
}
