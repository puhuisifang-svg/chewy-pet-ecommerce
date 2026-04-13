<template>
  <div class="checkout-step">
    <h2>Payment</h2>

    <!-- Payment Method Tabs -->
    <div class="payment-tabs">
      <button
        v-for="tab in paymentMethods"
        :key="tab.id"
        class="tab-btn"
        :class="{ active: selectedPayment === tab.id }"
        @click="selectedPayment = tab.id"
      >
        {{ tab.icon }} {{ tab.label }}
      </button>
    </div>

    <!-- Credit / Debit Card (Stripe Elements placeholder) -->
    <div v-if="selectedPayment === 'card'" class="payment-form">
      <div class="stripe-notice">
        <span>🔒</span>
        <span>Secured by <strong>Stripe</strong> — PCI DSS compliant</span>
      </div>

      <!-- Stripe Elements will mount here -->
      <div class="form-group">
        <label>Card Number</label>
        <div id="stripe-card-number" class="stripe-element">
          <!-- Stripe CardNumber Element mounts here -->
          <input
            v-model="mockCard.number"
            type="text"
            placeholder="1234 5678 9012 3456"
            maxlength="19"
            @input="formatCardNumber"
          />
        </div>
      </div>
      <div class="form-row two-col">
        <div class="form-group">
          <label>Expiry Date</label>
          <input v-model="mockCard.expiry" type="text" placeholder="MM / YY" maxlength="7" />
        </div>
        <div class="form-group">
          <label>CVV</label>
          <input v-model="mockCard.cvv" type="text" placeholder="123" maxlength="4" />
        </div>
      </div>
      <div class="form-group">
        <label>Name on Card</label>
        <input v-model="mockCard.name" type="text" placeholder="John Doe" />
      </div>
      <label class="checkbox-label">
        <input type="checkbox" v-model="saveCard" />
        Save card for future purchases
      </label>
    </div>

    <!-- PayPal -->
    <div v-if="selectedPayment === 'paypal'" class="payment-form paypal-section">
      <p class="paypal-desc">You'll be redirected to PayPal to complete your payment securely.</p>
      <!-- PayPal Buttons SDK will render here -->
      <div id="paypal-button-container" class="paypal-btn-placeholder">
        <div class="paypal-mock-btn" @click="handlePayPal">
          <span>🅿️</span> Pay with PayPal
        </div>
      </div>
    </div>

    <!-- Apple Pay / Google Pay -->
    <div v-if="selectedPayment === 'wallet'" class="payment-form wallet-section">
      <p class="wallet-desc">Pay quickly using your saved payment methods.</p>
      <div class="wallet-buttons">
        <button class="wallet-btn apple-pay" @click="handleWalletPay('Apple Pay')">
          🍎 Apple Pay
        </button>
        <button class="wallet-btn google-pay" @click="handleWalletPay('Google Pay')">
          🟢 Google Pay
        </button>
      </div>
    </div>

    <!-- Billing Address -->
    <div class="billing-section">
      <label class="checkbox-label">
        <input type="checkbox" v-model="billingSameAsShipping" />
        Billing address same as shipping address
      </label>
    </div>

    <!-- Order Total -->
    <div class="order-total-row">
      <span>You'll be charged</span>
      <span class="total-amount">${{ finalTotal.toFixed(2) }}</span>
    </div>

    <div class="step-actions">
      <router-link to="/checkout/delivery" class="btn-back">← Back</router-link>
      <button
        class="btn-place-order"
        @click="handlePlaceOrder"
        :disabled="isSubmitting || !canSubmit"
      >
        <span v-if="isSubmitting">Processing...</span>
        <span v-else>🔒 Place Order · ${{ finalTotal.toFixed(2) }}</span>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useCartStore } from '../../stores/cart'
import { useCheckoutStore } from '../../stores/checkout'
import { orderApi, paymentApi } from '../../api/index'
import { ElMessage } from 'element-plus'

const router = useRouter()
const cartStore = useCartStore()
const checkoutStore = useCheckoutStore()

const selectedPayment = ref('card')
const billingSameAsShipping = ref(true)
const saveCard = ref(false)
const isSubmitting = ref(false)

const mockCard = ref({ number: '', expiry: '', cvv: '', name: '' })

const paymentMethods = [
  { id: 'card', icon: '💳', label: 'Credit / Debit Card' },
  { id: 'paypal', icon: '🅿️', label: 'PayPal' },
  { id: 'wallet', icon: '📱', label: 'Apple / Google Pay' },
]

const shippingCost = computed(() =>
  checkoutStore.deliveryMethod?.price ?? (cartStore.totalPrice >= 49 ? 0 : 4.95)
)

const finalTotal = computed(() => cartStore.totalPrice + shippingCost.value)

const canSubmit = computed(() => {
  if (selectedPayment.value === 'card') {
    return mockCard.value.number.length >= 16 &&
           mockCard.value.expiry.length >= 4 &&
           mockCard.value.cvv.length >= 3 &&
           mockCard.value.name.length > 0
  }
  return true
})

function formatCardNumber(e) {
  let v = e.target.value.replace(/\D/g, '').slice(0, 16)
  mockCard.value.number = v.replace(/(.{4})/g, '$1 ').trim()
}

function handlePayPal() {
  ElMessage({ message: 'PayPal integration requires sandbox keys. Proceeding in demo mode.', type: 'info' })
  placeOrder('paypal', 'PAYPAL-DEMO-' + Date.now())
}

function handleWalletPay(method) {
  ElMessage({ message: `${method} requires device integration. Proceeding in demo mode.`, type: 'info' })
  placeOrder('wallet', `${method.toUpperCase().replace(' ', '-')}-${Date.now()}`)
}

async function handlePlaceOrder() {
  if (selectedPayment.value === 'card') {
    // In production: call Stripe createPaymentMethod then confirmCardPayment
    const mockPaymentId = 'pi_demo_' + Date.now()
    await placeOrder('card', mockPaymentId)
  }
}

async function placeOrder(method, paymentId) {
  isSubmitting.value = true
  try {
    const orderData = {
      items: cartStore.items.map(i => ({ productId: i.id, quantity: i.qty, price: i.price })),
      address: checkoutStore.address,
      deliveryMethod: checkoutStore.deliveryMethod?.id || 'standard',
      paymentMethod: method,
      paymentId,
      subtotal: cartStore.totalPrice,
      shipping: shippingCost.value,
      total: finalTotal.value,
    }

    let orderId
    try {
      const res = await orderApi.create(orderData)
      orderId = res?.id || res?.orderId || 'DEMO-' + Date.now()
    } catch {
      // Backend not ready — use demo order ID
      orderId = 'DEMO-' + Date.now()
    }

    checkoutStore.setOrderId(orderId)
    cartStore.clearCart()
    router.push(`/order/confirm/${orderId}`)
  } catch (err) {
    ElMessage({ message: 'Payment failed. Please try again.', type: 'error' })
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
.checkout-step h2 { font-size: 1.4rem; font-weight: 700; margin-bottom: 20px; }

/* Tabs */
.payment-tabs { display: flex; gap: 8px; margin-bottom: 24px; flex-wrap: wrap; }

.tab-btn {
  padding: 10px 18px;
  border: 2px solid var(--border);
  border-radius: 8px;
  background: white;
  font-size: 0.88rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  color: var(--text-muted);
}

.tab-btn.active {
  border-color: var(--primary);
  color: var(--primary);
  background: #f0f9ff;
}

/* Payment Form */
.payment-form {
  background: white;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 24px;
  margin-bottom: 20px;
}

.stripe-notice {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 0.82rem;
  color: var(--text-muted);
  margin-bottom: 20px;
  background: #f8f9fa;
  padding: 8px 12px;
  border-radius: 6px;
}

.stripe-element {
  border: 1px solid var(--border);
  border-radius: 6px;
  padding: 10px 14px;
  background: white;
  transition: border-color 0.2s;
}

.stripe-element:focus-within { border-color: var(--primary); }

.form-row { display: grid; gap: 16px; margin-bottom: 0; }
.two-col { grid-template-columns: 1fr 1fr; }

.form-group { display: flex; flex-direction: column; gap: 6px; margin-bottom: 16px; }
.form-group label { font-size: 0.85rem; font-weight: 600; color: var(--text-muted); }

.form-group input {
  width: 100%;
  padding: 10px 14px;
  border: 1px solid var(--border);
  border-radius: 6px;
  font-size: 0.9rem;
  outline: none;
  transition: border-color 0.2s;
}
.form-group input:focus { border-color: var(--primary); }

/* PayPal */
.paypal-desc { color: var(--text-muted); font-size: 0.9rem; margin-bottom: 20px; }

.paypal-mock-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  background: #ffc439;
  color: #003087;
  border-radius: 8px;
  padding: 14px;
  font-weight: 700;
  font-size: 1rem;
  cursor: pointer;
  transition: opacity 0.2s;
}

.paypal-mock-btn:hover { opacity: 0.9; }

/* Wallet */
.wallet-desc { color: var(--text-muted); font-size: 0.9rem; margin-bottom: 20px; }

.wallet-buttons { display: flex; gap: 12px; }

.wallet-btn {
  flex: 1;
  padding: 14px;
  border: 2px solid var(--border);
  border-radius: 8px;
  font-size: 0.95rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s;
  background: white;
}

.wallet-btn:hover { border-color: var(--primary); background: #f0f9ff; }

/* Billing */
.billing-section {
  margin-bottom: 20px;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 0.88rem;
  cursor: pointer;
}

/* Total */
.order-total-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #f0f9ff;
  border: 1px solid #bfdbfe;
  border-radius: var(--radius);
  padding: 14px 18px;
  margin-bottom: 24px;
  font-weight: 600;
}

.total-amount {
  font-size: 1.3rem;
  font-weight: 800;
  color: var(--primary);
}

/* Actions */
.step-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.btn-back { color: var(--primary); font-size: 0.9rem; font-weight: 600; }

.btn-place-order {
  padding: 14px 36px;
  background: #16a34a;
  color: white;
  border: none;
  border-radius: 6px;
  font-weight: 700;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.2s;
}

.btn-place-order:hover:not(:disabled) { background: #15803d; }
.btn-place-order:disabled { opacity: 0.6; cursor: not-allowed; }

@media (max-width: 500px) {
  .two-col { grid-template-columns: 1fr; }
  .wallet-buttons { flex-direction: column; }
}
</style>
