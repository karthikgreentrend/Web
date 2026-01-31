import { render, screen, waitFor } from '@testing-library/react';
import CartPage from '../pages/CartPage';
import * as api from '../api/endpoints';
import { MemoryRouter } from 'react-router-dom';
test('shows cart total', async () => {
  vi.spyOn(api, 'getCart').mockResolvedValue({ items: [{ productId: 1, name: 'Item A', priceCents: 1000, quantity: 2 }], totalCents: 2000, status: 'OPEN' });
  render(<MemoryRouter><CartPage /></MemoryRouter>);
  await waitFor(() => expect(screen.getByText(/Total: ₹20\.00/)).toBeInTheDocument());
});
