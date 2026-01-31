import { createContext, useContext, useState, useEffect } from 'react';
import { login as apiLogin, register as apiRegister } from '../api/endpoints';
const AuthContext = createContext();
export function AuthProvider({ children }) {
  const [token, setToken] = useState(() => localStorage.getItem('token') || null);
  useEffect(() => { if (token) localStorage.setItem('token', token); else localStorage.removeItem('token'); }, [token]);
  const login = async (email, password) => { const res = await apiLogin(email, password); const t = res.token || res.id_token || res.data?.token; setToken(t); };
  const register = (email, password) => apiRegister(email, password);
  const logout = () => setToken(null);
  return (<AuthContext.Provider value={{ token, login, register, logout, isAuth: !!token }}>{children}</AuthContext.Provider>);
}
export const useAuth = () => useContext(AuthContext);
