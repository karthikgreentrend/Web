import { useEffect, useState } from 'react';
import { fetchProducts } from '../api/endpoints';
import { Link } from 'react-router-dom';
export default function Catalog() {
  const [data, setData] = useState([]);
  useEffect(() => { fetchProducts().then(setData); }, []);
  return (
    <div style={{ padding: 24 }}>
      <h1>Catalog</h1>
      <ul>
        {data.map(p => (
          <li key={p.id}><Link to={`/product/${p.id}`}>{p.name}</Link> — ₹{(p.priceCents/100).toFixed(2)}</li>
        ))}
      </ul>
    </div>
  );
}
