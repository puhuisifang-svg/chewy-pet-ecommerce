<template>
  <div class="checkout-step">
    <h2>Delivery Method</h2>
    <p class="subtitle">Choose how you'd like to receive your order</p>

    <div class="delivery-options">
      <div
        v-for="option in deliveryOptions"
        :key="option.id"
        class="delivery-card"
        :class="{ selected: selectedMethod === option.id }"
        @click="selectedMethod = option.id"
      >
        <input type="radio" :value="option.id" v-model="selectedMethod" />
        <div class="delivery-icon">{{ option.icon }}</div>
        <div class="delivery-info">
          <p class="delivery-name">{{ option.name }}</p>
          <p class="delivery-eta">{{ option.eta }}</p>
          <p class="delivery-desc">{{ option.desc }}</p>
        </div>
        <div class="delivery-price">
          <span v-if="option.price === 0" class="free-label">FREE</span>
          <span v-else class="price-label">${{ option.price.toFixed(2) }}</span>
        </div>
      </div>
    </div>

    <div class="shipping-to" v-if="checkoutStore.address">
      <p>📍 Shipping to: <strong>{{ formatAddress(checkoutStore.address) }}</strong>
        <router-link to="/checkout/shipping" class="change-link">Change</router-link>
      </p>
    </div>

    <div class="step-actions">
      <router-link to="/checkout/shipping" class="btn-back">← Back</router-link>
      <button class="btn-next" @click="handleNext" :disabled="!selectedMethod">
        Continue to Payment →
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useCheckoutStore } from '../../stores/checkout'
import { useCartStore } from '../../stores/cart'

const router = useRouter()
const checkoutStore = useCheckoutStore()
const cartStore = useCartStore()

const subtotal = cartStore.totalPrice
const isFreeShipping = subtotal >= 49

const deliveryOptions = [
  {
    id: 'standard',
    icon: '📦',
    name: 'Standard Shipping',
    eta: '5–7 business days',
    desc: 'Delivered by USPS or UPS',
    price: isFreeShipping ? 0 : 4.95,
  },
  {
    id: 'express',
    icon: '🚚',
    name: 'Express Shipping',
    eta: '2–3 business days',
    desc: 'Delivered by UPS or FedEx',
    price: 9.99,
  },
  {
    id: 'overnight',
    icon: '⚡',
    name: 'Overnight Delivery',
    eta: 'Next business day',
    desc: 'Order by 2PM for next-day delivery',
    price: 24.99,
  },
]

const selectedMethod = ref(checkoutStore.deliveryMethod?.id || 'standard')

function formatAddress(addr) {
  if (!addr) return ''
  return `${addr.line1 || addr.name || ''}, ${addr.city || ''}, ${addr.state || ''}`
}

function handleNext() {
  const method = deliveryOptions.find(o => o.id === selectedMethod.value)
  checkoutStore.setDeliveryMethod(method)
  router.push('/checkout/payment')
}
</script>

<style scoped>
.checkout-step h2 { font-size: 1.4rem; font-weight: 700; margin-bottom: 6px; }
.subtitle { color: var(--text-muted); font-size: 0.9rem; margin-bottom: 24px; }

.delivery-options { display: flex; flex-direction: column; gap: 12px; margin-bottom: 24px; }

.delivery-card {
  border: 2px solid var(--border);
  border-radius: var(--radius);
  padding: 16px 20px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 16px;
  background: white;
  transition: border-color 0.2s, background 0.2s;
}

.delivery-card.selected {
  border-color: var(--primary);
  background: #f0f9ff;
}

.delivery-icon { font-size: 1.8rem; flex-shrink: 0; }

.delivery-info { flex: 1; }
.delivery-name { font-weight: 700; font-size: 0.95rem; margin-bottom: 2px; }
.delivery-eta { font-size: 0.85rem; color: var(--primary); font-weight: 600; margin-bottom: 2px; }
.delivery-desc { font-size: 0.82rem; color: var(--text-muted); }

.delivery-price { text-align: right; }
.free-label { font-size: 1rem; font-weight: 700; color: #16a34a; }
.price-label { font-size: 1rem; font-weight: 700; color: var(--text); }

.shipping-to {
  background: #f8f9fa;
  border-radius: 6px;
  padding: 12px 16px;
  font-size: 0.88rem;
  margin-bottom: 8px;
}

.change-link {
  color: var(--primary);
  font-weight: 600;
  margin-left: 8px;
  font-size: 0.82rem;
}

.change-link:hover { text-decoration: underline; }

.step-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 28px;
}

.btn-back { color: var(--primary); font-size: 0.9rem; font-weight: 600; }
.btn-next {
  padding: 12px 32px;
  background: var(--primary);
  color: white;
  border: none;
  border-radius: 6px;
  font-weight: 700;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.2s;
}
.btn-next:hover:not(:disabled) { background: var(--primary-hover); }
.btn-next:disabled { opacity: 0.5; cursor: not-allowed; }
</style>
