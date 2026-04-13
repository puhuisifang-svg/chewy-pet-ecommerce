<template>
  <div class="confirm-page">
    <div class="confirm-inner">
      <div v-if="loading" class="loading-state">
        <span>⏳</span>
        <p>Loading your order...</p>
      </div>

      <div v-else class="confirm-card">
        <!-- Success Header -->
        <div class="success-header">
          <div class="success-icon">✅</div>
          <h1>Order Confirmed!</h1>
          <p>Thank you for your purchase. We'll send a confirmation email shortly.</p>
          <div class="order-number">Order #{{ order.id }}</div>
        </div>

        <!-- Delivery Info -->
        <div class="info-grid">
          <div class="info-block">
            <h3>📦 Shipping To</h3>
            <p v-if="order.address">
              {{ order.address.name }}<br />
              {{ order.address.line1 }}<br />
              <span v-if="order.address.line2">{{ order.address.line2 }}<br /></span>
              {{ order.address.city }}, {{ order.address.state }} {{ order.address.zip }}
            </p>
            <p v-else>—</p>
          </div>
          <div class="info-block">
            <h3>🚚 Delivery Method</h3>
            <p>{{ order.deliveryMethod || 'Standard Shipping' }}</p>
            <p class="eta">Estimated arrival: <strong>{{ estimatedArrival }}</strong></p>
          </div>
          <div class="info-block">
            <h3>💳 Payment</h3>
            <p>{{ formatPaymentMethod(order.paymentMethod) }}</p>
            <p class="paid-label">✓ Payment Successful</p>
          </div>
        </div>

        <!-- Items -->
        <div class="order-items">
          <h3>Items Ordered</h3>
          <div v-for="item in order.items" :key="item.id" class="order-item">
            <span class="item-emoji">{{ item.emoji || '🐾' }}</span>
            <div class="item-info">
              <p class="item-name">{{ item.name }}</p>
              <p class="item-qty">Qty: {{ item.qty || item.quantity }}</p>
            </div>
            <p class="item-price">${{ ((item.price) * (item.qty || item.quantity)).toFixed(2) }}</p>
          </div>
        </div>

        <!-- Totals -->
        <div class="order-totals">
          <div class="total-row"><span>Subtotal</span><span>${{ order.subtotal?.toFixed(2) }}</span></div>
          <div class="total-row">
            <span>Shipping</span>
            <span :class="{ free: !order.shipping }">{{ order.shipping ? `$${order.shipping.toFixed(2)}` : 'FREE' }}</span>
          </div>
          <div class="total-row grand"><span>Total Charged</span><span>${{ order.total?.toFixed(2) }}</span></div>
        </div>

        <!-- Actions -->
        <div class="confirm-actions">
          <router-link to="/account" class="btn-orders">View All Orders</router-link>
          <router-link to="/products" class="btn-continue">Continue Shopping</router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useCheckoutStore } from '../../stores/checkout'
import { orderApi } from '../../api/index'

const route = useRoute()
const checkoutStore = useCheckoutStore()

const loading = ref(true)
const order = ref({})

const estimatedArrival = computed(() => {
  const d = new Date()
  const method = order.value.deliveryMethod || 'standard'
  const days = method === 'overnight' ? 1 : method === 'express' ? 3 : 7
  d.setDate(d.getDate() + days)
  return d.toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric' })
})

function formatPaymentMethod(method) {
  const map = { card: 'Credit / Debit Card', paypal: 'PayPal', wallet: 'Apple / Google Pay' }
  return map[method] || 'Card'
}

onMounted(async () => {
  const orderId = route.params.id || checkoutStore.orderId

  try {
    const data = await orderApi.getById(orderId)
    order.value = {
      id: orderId,
      address: checkoutStore.address,
      deliveryMethod: checkoutStore.deliveryMethod?.name,
      paymentMethod: 'card',
      ...data,
    }
  } catch {
    // Backend not ready — build from checkout store
    order.value = {
      id: orderId || 'DEMO-' + Date.now(),
      items: [],  // cart was cleared on payment
      address: checkoutStore.address,
      deliveryMethod: checkoutStore.deliveryMethod?.name,
      paymentMethod: 'card',
      subtotal: 0,
      shipping: 0,
      total: 0,
    }
  }
  loading.value = false
  checkoutStore.reset()
})
</script>

<style scoped>
.confirm-page { background: var(--bg); min-height: 100vh; padding: 48px 24px; }

.confirm-inner { max-width: 760px; margin: 0 auto; }

.loading-state { text-align: center; padding: 80px; font-size: 1rem; color: var(--text-muted); }
.loading-state span { font-size: 3rem; display: block; margin-bottom: 12px; }

.confirm-card {
  background: white;
  border: 1px solid var(--border);
  border-radius: 12px;
  overflow: hidden;
}

/* Header */
.success-header {
  background: linear-gradient(135deg, #16a34a, #22c55e);
  color: white;
  text-align: center;
  padding: 40px 24px;
}

.success-icon { font-size: 3.5rem; margin-bottom: 12px; }

.success-header h1 { font-size: 1.8rem; font-weight: 800; margin-bottom: 8px; }
.success-header p { opacity: 0.9; font-size: 0.95rem; margin-bottom: 16px; }

.order-number {
  display: inline-block;
  background: rgba(255,255,255,0.2);
  padding: 6px 16px;
  border-radius: 20px;
  font-weight: 700;
  font-size: 0.9rem;
}

/* Info Grid */
.info-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  border-bottom: 1px solid var(--border);
}

.info-block {
  padding: 20px 24px;
  border-right: 1px solid var(--border);
}

.info-block:last-child { border-right: none; }

.info-block h3 {
  font-size: 0.82rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--text-muted);
  margin-bottom: 10px;
}

.info-block p { font-size: 0.88rem; line-height: 1.6; }
.eta { color: var(--text-muted); }
.paid-label { color: #16a34a; font-weight: 600; }

/* Items */
.order-items { padding: 24px; border-bottom: 1px solid var(--border); }

.order-items h3 {
  font-size: 1rem;
  font-weight: 700;
  margin-bottom: 16px;
}

.order-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 0;
  border-bottom: 1px solid #f3f4f6;
}

.order-item:last-child { border-bottom: none; }

.item-emoji {
  font-size: 1.8rem;
  background: #f0f9ff;
  border-radius: 6px;
  width: 44px;
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.item-info { flex: 1; }
.item-name { font-size: 0.9rem; font-weight: 600; }
.item-qty { font-size: 0.8rem; color: var(--text-muted); }
.item-price { font-weight: 700; font-size: 0.95rem; }

/* Totals */
.order-totals { padding: 20px 24px; border-bottom: 1px solid var(--border); }

.total-row {
  display: flex;
  justify-content: space-between;
  font-size: 0.9rem;
  margin-bottom: 8px;
}

.total-row.grand {
  font-size: 1.1rem;
  font-weight: 700;
  margin-top: 8px;
  padding-top: 12px;
  border-top: 1px solid var(--border);
}

.free { color: #16a34a; font-weight: 600; }

/* Actions */
.confirm-actions {
  padding: 24px;
  display: flex;
  gap: 12px;
  justify-content: center;
}

.btn-orders {
  padding: 12px 28px;
  border: 2px solid var(--primary);
  border-radius: 6px;
  color: var(--primary);
  font-weight: 700;
  transition: all 0.2s;
}

.btn-orders:hover { background: #f0f9ff; }

.btn-continue {
  padding: 12px 28px;
  background: var(--primary);
  color: white;
  border-radius: 6px;
  font-weight: 700;
  transition: background 0.2s;
}

.btn-continue:hover { background: var(--primary-hover); }

@media (max-width: 600px) {
  .info-grid { grid-template-columns: 1fr; }
  .info-block { border-right: none; border-bottom: 1px solid var(--border); }
  .confirm-actions { flex-direction: column; }
}
</style>
