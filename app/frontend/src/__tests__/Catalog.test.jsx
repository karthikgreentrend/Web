import { render, screen, waitFor } from '@testing-library/react';
import Catalog from '../pages/Catalog';
import * as api from '../api/endpoints';
test('renders products from API', async () => {
  vi.spyOn(api, 'fetchProducts').mockResolvedValue([
    { id:1, name:'Laptop Pro 15', priceCents:149999 },
    { id:2, name:'Wireless Mouse', priceCents:1999 },
  ]);
  render(<Catalog />);
  await waitFor(() => expect(screen.getByText(/Laptop Pro 15/)).toBeInTheDocument());
  expect(screen.getByText(/Wireless Mouse/)).toBeInTheDocument();
});
