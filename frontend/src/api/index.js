import http from './http'

// ─── Cart ────────────────────────────────────────────────────────────────────
export const cartApi = {
  get: () => http.get('/api/cart'),
  updateItem: (itemId, qty) => http.put(`/api/cart/items/${itemId}`, { quantity: qty }),
  removeItem: (itemId) => http.delete(`/api/cart/items/${itemId}`),
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
export const orderApi = {
  create: (data) => http.post('/api/orders', data),
  getById: (id) => http.get(`/api/orders/${id}`),
  getHistory: (params) => http.get('/api/orders', { params }),
}

// ─── Products ────────────────────────────────────────────────────────────────
export const productApi = {
  list: (params) => http.get('/api/products', { params }),
  getById: (id) => http.get(`/api/products/${id}`),
  create: (data) => http.post('/api/products', data),
  update: (id, data) => http.put(`/api/products/${id}`, data),
  delete: (id) => http.delete(`/api/products/${id}`),
  updateStock: (id, stock) => http.patch(`/api/products/${id}/stock`, { stock }),
}

// ─── Payment ─────────────────────────────────────────────────────────────────
export const paymentApi = {
  createPaymentIntent: (amount) => http.post('/api/payments/intent', { amount }),
  confirmOrder: (orderId, paymentId) =>
    http.post(`/api/payments/confirm`, { orderId, paymentId }),
}
