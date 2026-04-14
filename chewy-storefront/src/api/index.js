import http from './http'

// ─── Auth ─────────────────────────────────────────────────────────────────────
// POST /api/auth/register { email, password, username } → { token, userId, username, email }
// POST /api/auth/login    { email, password }           → { token, userId, username, email }
export const authApi = {
  register: (data) => http.post('/api/auth/register', data),
  login: (data) => http.post('/api/auth/login', data),
}

// ─── Products ────────────────────────────────────────────────────────────────
// GET /api/products?page=1&size=20&keyword=&categoryId=&minPrice=&maxPrice=&sort=
//   → { code, data: { records[], total, size, current, pages } }
//
// ⚠️ GET /api/products/{id} → 400 (Java -parameters bug，PathVariable 无效)
//    临时绕过：用 /api/products?spuCode=XXX 或等后端修复
//
// Admin endpoints → 500 (pending Tom fix)
export const productApi = {
  list: (params) => http.get('/api/products', { params }),
  getById: (id) => http.get('/api/products', { params: { id } }),   // ⚠️ PathVar bug workaround
  create: (data) => http.post('/api/admin/products', data),
  update: (id, data) => http.put(`/api/admin/products/${id}`, data),
  delete: (id) => http.delete(`/api/admin/products/${id}`),
  updateStock: (skuId, stock) => http.patch(`/api/admin/skus/${skuId}/stock`, { stock }),
}

// ─── Cart ────────────────────────────────────────────────────────────────────
// GET    /api/cart → { items[], totalQty, subtotal, shippingFee, total, freeShipping }
// POST   /api/cart/items  { skuId, quantity }  ← ⚠️ skuId (not productId)
// PUT    /api/cart/items/:cartItemId { quantity }
// DELETE /api/cart/items/:cartItemId
export const cartApi = {
  get: () => http.get('/api/cart'),
  addItem: (skuId, quantity = 1) => http.post('/api/cart/items', { skuId, quantity }),
  updateItem: (cartItemId, quantity) => http.put(`/api/cart/items/${cartItemId}`, { quantity }),
  removeItem: (cartItemId) => http.delete(`/api/cart/items/${cartItemId}`),
  applyCoupon: (code) => http.post('/api/cart/coupon', { code }),
}

// ─── User / Addresses ────────────────────────────────────────────────────────
// GET /api/user/profile
// PUT /api/user/profile
// GET /api/user/addresses
// POST /api/user/addresses {
//   fullName, addressLine1, addressLine2?, city, state, zipCode, country, phone, isDefault(0/1)
// }
export const userApi = {
  getProfile: () => http.get('/api/user/profile'),
  updateProfile: (data) => http.put('/api/user/profile', data),
  getAddresses: () => http.get('/api/user/addresses'),
  createAddress: (data) => http.post('/api/user/addresses', data),
  updateAddress: (id, data) => http.put(`/api/user/addresses/${id}`, data),
  deleteAddress: (id) => http.delete(`/api/user/addresses/${id}`),
}

// ─── Orders ──────────────────────────────────────────────────────────────────
// POST /api/orders {
//   shippingAddress: { fullName, addressLine1, city, state, zipCode, country, phone },
//   items: [{ skuId, productId, productName, skuName?, image?, quantity, price }],
//   deliveryMethod: "standard"|"express"|"overnight",
//   shippingFee, subtotal, totalAmount,
//   paymentMethod: "stripe"|"paypal",
//   remark?
// } → { order: { id, orderNo, totalAmount, shippingFee, taxAmount, status }, items[] }
//
// ⚠️ GET /api/orders/{id} → 400 (Java -parameters bug)
// ⚠️ GET /api/orders      → 400 (同上，后端待修复)
export const orderApi = {
  create: (data) => http.post('/api/orders', data),
  getById: (id) => http.get(`/api/orders/${id}`),       // ⚠️ pending backend fix
  getHistory: (params) => http.get('/api/orders', { params }),  // ⚠️ pending backend fix
}

// ─── Payment ─────────────────────────────────────────────────────────────────
// POST /api/payments/intent { amount (cents), currency }  → pending (service 8084 down)
export const paymentApi = {
  createPaymentIntent: (amount, currency = 'usd') =>
    http.post('/api/payments/intent', { amount, currency }),
  confirm: (orderId, paymentId) =>
    http.post('/api/payments/confirm', { orderId, paymentId }),
}
