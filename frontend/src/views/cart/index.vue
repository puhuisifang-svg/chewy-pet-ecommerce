<template>
  <div class="cart-page">
    <div class="page-inner">
      <h1 class="page-title">Shopping Cart
        <span class="item-count">({{ cartStore.totalItems }} items)</span>
      </h1>

      <div v-if="cartStore.items.length" class="cart-layout">
        <!-- Cart Items -->
        <div class="cart-items">
          <div v-for="item in cartStore.items" :key="item.id" class="cart-item">
            <div class="item-img">{{ item.emoji }}</div>
            <div class="item-details">
              <p class="item-brand">{{ item.brand }}</p>
              <h3 class="item-name">{{ item.name }}</h3>
              <p v-if="item.selectedSize" class="item-size">Size: {{ item.selectedSize }}</p>
              <div class="item-actions">
                <div class="qty-control">
                  <button @click="updateQty(item, item.qty - 1)">−</button>
                  <span>{{ item.qty }}</span>
                  <button @click="updateQty(item, item.qty + 1)">+</button>
                </div>
                <button class="btn-remove" @click="cartStore.removeItem(item.id)">Remove</button>
              </div>
            </div>
            <div class="item-price">
              <p class="line-total">${{ (item.price * item.qty).toFixed(2) }}</p>
              <p class="unit-price">${{ item.price.toFixed(2) }} each</p>
            </div>
          </div>
        </div>

        <!-- Order Summary -->
        <aside class="order-summary">
          <h2>Order Summary</h2>

          <div class="summary-row">
            <span>Subtotal ({{ cartStore.totalItems }} items)</span>
            <span>${{ cartStore.totalPrice.toFixed(2) }}</span>
          </div>
          <div class="summary-row">
            <span>Shipping</span>
            <span :class="{ free: shipping === 0 }">
              {{ shipping === 0 ? 'FREE' : `$${shipping.toFixed(2)}` }}
            </span>
          </div>
          <div v-if="shipping > 0" class="free-shipping-bar">
            <p>Add <strong>${{ (49 - cartStore.totalPrice).toFixed(2) }}</strong> more for free shipping!</p>
            <div class="progress-bar">
              <div class="progress-fill" :style="{ width: Math.min((cartStore.totalPrice / 49) * 100, 100) + '%' }"></div>
            </div>
          </div>

          <!-- Coupon -->
          <div class="coupon-section">
            <p class="coupon-label">Promo Code</p>
            <div class="coupon-row">
              <input v-model="couponCode" type="text" placeholder="Enter code" class="coupon-input" />
              <button class="btn-apply" @click="applyCoupon">Apply</button>
            </div>
            <p v-if="couponMsg" class="coupon-msg" :class="couponMsgType">{{ couponMsg }}</p>
          </div>

          <div class="summary-divider"></div>
          <div class="summary-row total">
            <span>Total</span>
            <span>${{ orderTotal.toFixed(2) }}</span>
          </div>

          <router-link to="/checkout/shipping" class="btn-checkout">
            Proceed to Checkout →
          </router-link>
          <router-link to="/products" class="btn-continue">← Continue Shopping</router-link>
        </aside>
      </div>

      <!-- Empty Cart -->
      <div v-else class="empty-cart">
        <span>🛒</span>
        <h2>Your cart is empty</h2>
        <p>Looks like you haven't added anything yet.</p>
        <router-link to="/products" class="btn-shop">Start Shopping</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useCartStore } from '../../stores/cart'
import { cartApi } from '../../api/index'
import { ElMessage } from 'element-plus'

const cartStore = useCartStore()
const couponCode = ref('')
const couponMsg = ref('')
const couponMsgType = ref('error')

const SHIPPING_THRESHOLD = 49
const SHIPPING_FEE = 4.95

const shipping = computed(() =>
  cartStore.totalPrice >= SHIPPING_THRESHOLD ? 0 : SHIPPING_FEE
)

const orderTotal = computed(() => cartStore.totalPrice + shipping.value)

function updateQty(item, newQty) {
  if (newQty <= 0) {
    cartStore.removeItem(item.id)
  } else {
    cartStore.updateQty(item.id, newQty)
  }
  // Sync to backend (best-effort)
  cartApi.updateItem(item.id, newQty).catch(() => {})
}

function applyCoupon() {
  if (!couponCode.value.trim()) return
  // UI placeholder — backend integration pending
  couponMsg.value = 'Invalid or expired promo code.'
  couponMsgType.value = 'error'
  ElMessage({ message: 'Promo code feature coming soon!', type: 'info' })
}

onMounted(async () => {
  try {
    const data = await cartApi.get()
    if (data?.items?.length) {
      // Merge backend cart with local store if needed
      console.log('[Cart] Backend cart loaded', data)
    }
  } catch {
    // Backend not ready yet, use local store
  }
})
</script>

<style scoped>
.cart-page { background: var(--bg); min-height: 100vh; }

.page-inner {
  max-width: 1280px;
  margin: 0 auto;
  padding: 32px 24px 60px;
}

.page-title {
  font-size: 1.8rem;
  font-weight: 700;
  margin-bottom: 28px;
}

.item-count {
  font-size: 1.1rem;
  color: var(--text-muted);
  font-weight: 400;
  margin-left: 8px;
}

.cart-layout {
  display: grid;
  grid-template-columns: 1fr 360px;
  gap: 32px;
  align-items: start;
}

/* Cart Items */
.cart-items {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.cart-item {
  background: white;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 20px;
  display: grid;
  grid-template-columns: 80px 1fr auto;
  gap: 16px;
  align-items: center;
}

.item-img {
  font-size: 3rem;
  background: #f0f9ff;
  border-radius: 8px;
  width: 80px;
  height: 80px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.item-brand {
  font-size: 0.78rem;
  color: var(--text-muted);
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 2px;
}

.item-name {
  font-size: 0.95rem;
  font-weight: 600;
  margin-bottom: 4px;
}

.item-size {
  font-size: 0.82rem;
  color: var(--text-muted);
  margin-bottom: 10px;
}

.item-actions {
  display: flex;
  align-items: center;
  gap: 16px;
}

.qty-control {
  display: flex;
  align-items: center;
  border: 1px solid var(--border);
  border-radius: 6px;
  overflow: hidden;
}

.qty-control button {
  width: 32px;
  height: 34px;
  border: none;
  background: #f8f9fa;
  font-size: 1.1rem;
  cursor: pointer;
}

.qty-control button:hover { background: #e5e7eb; }

.qty-control span {
  width: 40px;
  text-align: center;
  font-weight: 600;
  font-size: 0.9rem;
  border-left: 1px solid var(--border);
  border-right: 1px solid var(--border);
  line-height: 34px;
}

.btn-remove {
  background: none;
  border: none;
  color: #dc2626;
  font-size: 0.85rem;
  cursor: pointer;
  text-decoration: underline;
}

.item-price { text-align: right; }

.line-total {
  font-size: 1.1rem;
  font-weight: 700;
  color: var(--primary);
}

.unit-price {
  font-size: 0.8rem;
  color: var(--text-muted);
  margin-top: 2px;
}

/* Order Summary */
.order-summary {
  background: white;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 24px;
  position: sticky;
  top: 80px;
}

.order-summary h2 {
  font-size: 1.1rem;
  font-weight: 700;
  margin-bottom: 20px;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  font-size: 0.92rem;
  margin-bottom: 12px;
  color: var(--text);
}

.summary-row.total {
  font-size: 1.1rem;
  font-weight: 700;
  margin-top: 4px;
  margin-bottom: 20px;
}

.free { color: #16a34a; font-weight: 600; }

.free-shipping-bar {
  background: #f0fdf4;
  border-radius: 6px;
  padding: 10px 12px;
  margin-bottom: 14px;
  font-size: 0.82rem;
}

.progress-bar {
  background: #dcfce7;
  border-radius: 99px;
  height: 6px;
  margin-top: 8px;
  overflow: hidden;
}

.progress-fill {
  background: #16a34a;
  height: 100%;
  border-radius: 99px;
  transition: width 0.3s;
}

/* Coupon */
.coupon-section { margin: 16px 0; }

.coupon-label {
  font-size: 0.82rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--text-muted);
  margin-bottom: 8px;
}

.coupon-row { display: flex; gap: 8px; }

.coupon-input {
  flex: 1;
  padding: 8px 12px;
  border: 1px solid var(--border);
  border-radius: 6px;
  font-size: 0.88rem;
  outline: none;
}

.coupon-input:focus { border-color: var(--primary); }

.btn-apply {
  padding: 8px 16px;
  background: var(--text);
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 0.88rem;
  font-weight: 600;
  cursor: pointer;
}

.coupon-msg {
  font-size: 0.82rem;
  margin-top: 6px;
}
.coupon-msg.error { color: #dc2626; }
.coupon-msg.success { color: #16a34a; }

.summary-divider {
  height: 1px;
  background: var(--border);
  margin: 12px 0;
}

.btn-checkout {
  display: block;
  width: 100%;
  padding: 14px;
  background: var(--primary);
  color: white;
  text-align: center;
  border-radius: 6px;
  font-weight: 700;
  font-size: 1rem;
  margin-bottom: 10px;
  transition: background 0.2s;
}

.btn-checkout:hover { background: var(--primary-hover); }

.btn-continue {
  display: block;
  text-align: center;
  font-size: 0.88rem;
  color: var(--primary);
}

/* Empty */
.empty-cart {
  text-align: center;
  padding: 100px 24px;
}

.empty-cart span { font-size: 4rem; display: block; margin-bottom: 20px; }
.empty-cart h2 { font-size: 1.5rem; font-weight: 700; margin-bottom: 10px; }
.empty-cart p { color: var(--text-muted); margin-bottom: 28px; }

.btn-shop {
  display: inline-block;
  padding: 12px 32px;
  background: var(--primary);
  color: white;
  border-radius: 6px;
  font-weight: 700;
}

/* Responsive */
@media (max-width: 900px) {
  .cart-layout { grid-template-columns: 1fr; }
  .order-summary { position: static; }
}

@media (max-width: 560px) {
  .cart-item { grid-template-columns: 64px 1fr; }
  .item-price { grid-column: 2; }
}
</style>
