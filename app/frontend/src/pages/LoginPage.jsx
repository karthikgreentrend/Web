import { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { useNavigate, Link } from 'react-router-dom';
export default function LoginPage() {
  const { login } = useAuth();
  const [email, setEmail] = useState('test@example.com');
  const [password, setPassword] = useState('password');
  const [error, setError] = useState(null);
  const navigate = useNavigate();
  return (
    <div style={{ padding: 24 }}>
      <h1>Login</h1>
      {error && <p style={{ color:'red' }}>{error}</p>}
      <input placeholder="Email" value={email} onChange={e => setEmail(e.target.value)} /><br/>
      <input placeholder="Password" type="password" value={password} onChange={e => setPassword(e.target.value)} /><br/>
      <button onClick={async () => { try { await login(email, password); navigate('/'); } catch (e) { setError('Invalid credentials'); } }}>Login</button>
      <p>No account? <Link to="/register">Register</Link></p>
    </div>
  );
}
