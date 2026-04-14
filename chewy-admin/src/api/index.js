import http from './http'

// ─── Auth ─────────────────────────────────────────────────────────────────────
export const authApi = {
  // POST /api/auth/register  { email, password, username }
  register: (data) => http.post('/api/auth/register', data),
  // POST /api/auth/login  { email, password }  ← ⚠️ 后端 login 有 bug，暂用 register token
  login: (data) => http.post('/api/auth/login', data),
}

// ─── Products ────────────────────────────────────────────────────────────────
// GET /api/products?page=1&size=20&keyword=&categoryId=&minPrice=&maxPrice=&sort=
// Response: { code, data: { records, total, size, current, pages } }
export const productApi = {
  list: (params) => http.get('/api/products', { params }),
  // GET /api/products/:id → { code, data: { product, skus[] } }
  getById: (id) => http.get(`/api/products/${id}`),
  // Admin endpoints
  create: (data) => http.post('/api/admin/products', data),
  update: (id, data) => http.put(`/api/admin/products/${id}`, data),
  delete: (id) => http.delete(`/api/admin/products/${id}`),
  updateStock: (skuId, stock) => http.patch(`/api/admin/skus/${skuId}/stock`, { stock }),
}

// ─── Cart ────────────────────────────────────────────────────────────────────
// GET  /api/cart → { items[{ cartItemId, skuId, productId, productName, specName, price, quantity, lineTotal }], totalQty, subtotal, shippingFee, total, freeShipping }
// POST /api/cart/items  { skuId, quantity }  ← ⚠️ 必须用 skuId，不是 productId
// PUT  /api/cart/items/:cartItemId  { quantity }
// DELETE /api/cart/items/:cartItemId
export const cartApi = {
  get: () => http.get('/api/cart'),
  addItem: (skuId, quantity = 1) => http.post('/api/cart/items', { skuId, quantity }),
  updateItem: (cartItemId, quantity) => http.put(`/api/cart/items/${cartItemId}`, { quantity }),
  removeItem: (cartItemId) => http.delete(`/api/cart/items/${cartItemId}`),
  applyCoupon: (code) => http.post('/api/cart/coupon', { code }),
}

// ─── User / Addresses ────────────────────────────────────────────────────────
export const userApi = {
  getProfile: () => http.get('/api/user/profile'),
  updateProfile: (data) => http.put('/api/user/profile', data),
  getAddresses: () => http.get('/api/user/addresses'),
  createAddress: (data) => http.post('/api/user/addresses', data),
  updateAddress: (id, data) => http.put(`/api/user/addresses/${id}`, data),
  deleteAddress: (id) => http.delete(`/api/user/addresses/${id}`),
}

// ─── Orders ──────────────────────────────────────────────────────────────────
// POST /api/orders { items[{skuId,quantity}], addressId, deliveryMethod, paymentMethod, total }
// GET  /api/orders → { records, total, ... }
// GET  /api/orders/:id
export const orderApi = {
  create: (data) => http.post('/api/orders', data),
  getById: (id) => http.get(`/api/orders/${id}`),
  getHistory: (params) => http.get('/api/orders', { params }),
}

// ─── Payment ─────────────────────────────────────────────────────────────────
// POST /api/payments/intent  { amount (cents), currency }  ← 需要 Auth token
export const paymentApi = {
  createPaymentIntent: (amount, currency = 'usd') =>
    http.post('/api/payments/intent', { amount, currency }),
  confirm: (orderId, paymentId) =>
    http.post('/api/payments/confirm', { orderId, paymentId }),
}
