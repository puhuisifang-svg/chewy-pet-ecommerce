<template>
  <div class="checkout-page">
    <div class="checkout-inner">
      <!-- Steps Indicator -->
      <div class="steps-bar">
        <div
          v-for="(step, i) in steps"
          :key="step.path"
          class="step"
          :class="{
            active: currentStep === i,
            done: currentStep > i,
          }"
        >
          <div class="step-circle">
            <span v-if="currentStep > i">✓</span>
            <span v-else>{{ i + 1 }}</span>
          </div>
          <span class="step-label">{{ step.label }}</span>
          <div v-if="i < steps.length - 1" class="step-line"></div>
        </div>
      </div>

      <!-- Step Content + Summary -->
      <div class="checkout-layout">
        <div class="checkout-form">
          <router-view />
        </div>
        <aside class="checkout-summary">
          <h3>Order Summary</h3>
          <div class="summary-items">
            <div v-for="item in cartStore.items" :key="item.id" class="summary-item">
              <span class="s-emoji">{{ item.emoji }}</span>
              <div class="s-info">
                <p class="s-name">{{ item.name }}</p>
                <p class="s-qty">Qty: {{ item.qty }}</p>
              </div>
              <span class="s-price">${{ (item.price * item.qty).toFixed(2) }}</span>
            </div>
          </div>
          <div class="s-divider"></div>
          <div class="s-row"><span>Subtotal</span><span>${{ cartStore.totalPrice.toFixed(2) }}</span></div>
          <div class="s-row">
            <span>Shipping</span>
            <span :class="{ free: shipping === 0 }">{{ shipping === 0 ? 'FREE' : `$${shipping.toFixed(2)}` }}</span>
          </div>
          <div class="s-divider"></div>
          <div class="s-row total">
            <span>Total</span>
            <span>${{ (cartStore.totalPrice + shipping).toFixed(2) }}</span>
          </div>
        </aside>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { useCartStore } from '../../stores/cart'

const route = useRoute()
const cartStore = useCartStore()

const steps = [
  { label: 'Shipping', path: '/checkout/shipping' },
  { label: 'Delivery', path: '/checkout/delivery' },
  { label: 'Payment', path: '/checkout/payment' },
]

const currentStep = computed(() => {
  const idx = steps.findIndex(s => route.path.includes(s.path.split('/').pop()))
  return idx >= 0 ? idx : 0
})

const shipping = computed(() => cartStore.totalPrice >= 49 ? 0 : 4.95)
</script>

<style scoped>
.checkout-page { background: var(--bg); min-height: 100vh; }

.checkout-inner {
  max-width: 1100px;
  margin: 0 auto;
  padding: 32px 24px 60px;
}

/* Steps */
.steps-bar {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 36px;
  gap: 0;
}

.step {
  display: flex;
  align-items: center;
  gap: 8px;
  opacity: 0.45;
  transition: opacity 0.2s;
}

.step.active, .step.done { opacity: 1; }

.step-circle {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  border: 2px solid var(--border);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.85rem;
  font-weight: 700;
  background: white;
  transition: all 0.2s;
  flex-shrink: 0;
}

.step.active .step-circle {
  border-color: var(--primary);
  color: var(--primary);
}

.step.done .step-circle {
  background: var(--primary);
  border-color: var(--primary);
  color: white;
}

.step-label {
  font-size: 0.88rem;
  font-weight: 600;
  white-space: nowrap;
}

.step.active .step-label { color: var(--primary); }

.step-line {
  width: 60px;
  height: 2px;
  background: var(--border);
  margin: 0 8px;
}

/* Layout */
.checkout-layout {
  display: grid;
  grid-template-columns: 1fr 320px;
  gap: 32px;
  align-items: start;
}

/* Summary */
.checkout-summary {
  background: white;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 20px;
  position: sticky;
  top: 80px;
}

.checkout-summary h3 {
  font-size: 1rem;
  font-weight: 700;
  margin-bottom: 16px;
}

.summary-items {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 12px;
}

.summary-item {
  display: flex;
  align-items: center;
  gap: 10px;
}

.s-emoji {
  font-size: 1.6rem;
  background: #f0f9ff;
  border-radius: 6px;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.s-info { flex: 1; }
.s-name { font-size: 0.82rem; font-weight: 600; line-height: 1.3; }
.s-qty { font-size: 0.78rem; color: var(--text-muted); }
.s-price { font-size: 0.88rem; font-weight: 600; white-space: nowrap; }

.s-divider { height: 1px; background: var(--border); margin: 12px 0; }

.s-row {
  display: flex;
  justify-content: space-between;
  font-size: 0.88rem;
  margin-bottom: 8px;
}

.s-row.total { font-weight: 700; font-size: 1rem; margin-top: 4px; }
.free { color: #16a34a; font-weight: 600; }

@media (max-width: 800px) {
  .checkout-layout { grid-template-columns: 1fr; }
  .checkout-summary { position: static; }
  .step-line { width: 30px; }
}
</style>
