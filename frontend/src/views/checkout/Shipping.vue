<template>
  <div class="checkout-step">
    <h2>Shipping Address</h2>

    <!-- Saved Addresses -->
    <div v-if="savedAddresses.length" class="saved-addresses">
      <h3>Saved Addresses</h3>
      <div class="address-grid">
        <div
          v-for="addr in savedAddresses"
          :key="addr.id"
          class="address-card"
          :class="{ selected: selectedAddressId === addr.id }"
          @click="selectedAddressId = addr.id"
        >
          <div class="addr-select">
            <input type="radio" :value="addr.id" v-model="selectedAddressId" />
          </div>
          <div class="addr-info">
            <p class="addr-name">{{ addr.name }}</p>
            <p>{{ addr.line1 }}</p>
            <p v-if="addr.line2">{{ addr.line2 }}</p>
            <p>{{ addr.city }}, {{ addr.state }} {{ addr.zip }}</p>
            <p>{{ addr.country }}</p>
          </div>
          <span v-if="addr.isDefault" class="default-badge">Default</span>
        </div>
      </div>
      <button class="btn-new-addr" @click="showNewForm = !showNewForm">
        {{ showNewForm ? '− Cancel' : '+ Add New Address' }}
      </button>
    </div>

    <!-- New Address Form -->
    <div v-if="!savedAddresses.length || showNewForm" class="address-form">
      <h3 v-if="savedAddresses.length">New Address</h3>
      <div class="form-row two-col">
        <div class="form-group">
          <label>First Name *</label>
          <input v-model="form.firstName" type="text" placeholder="John" required />
        </div>
        <div class="form-group">
          <label>Last Name *</label>
          <input v-model="form.lastName" type="text" placeholder="Doe" required />
        </div>
      </div>
      <div class="form-group">
        <label>Address Line 1 *</label>
        <input v-model="form.line1" type="text" placeholder="123 Main St" required />
      </div>
      <div class="form-group">
        <label>Address Line 2</label>
        <input v-model="form.line2" type="text" placeholder="Apt, Suite, etc." />
      </div>
      <div class="form-row three-col">
        <div class="form-group">
          <label>City *</label>
          <input v-model="form.city" type="text" placeholder="New York" required />
        </div>
        <div class="form-group">
          <label>State *</label>
          <select v-model="form.state">
            <option value="">Select state</option>
            <option v-for="s in usStates" :key="s" :value="s">{{ s }}</option>
          </select>
        </div>
        <div class="form-group">
          <label>ZIP Code *</label>
          <input v-model="form.zip" type="text" placeholder="10001" maxlength="10" required />
        </div>
      </div>
      <div class="form-group">
        <label>Phone Number</label>
        <input v-model="form.phone" type="tel" placeholder="+1 (555) 000-0000" />
      </div>
      <label class="checkbox-label">
        <input type="checkbox" v-model="form.saveAddress" />
        Save this address for future orders
      </label>
    </div>

    <div class="step-actions">
      <router-link to="/cart" class="btn-back">← Back to Cart</router-link>
      <button class="btn-next" @click="handleNext" :disabled="!canProceed">
        Continue to Delivery →
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useCheckoutStore } from '../../stores/checkout'
import { userApi } from '../../api/index'

const router = useRouter()
const checkoutStore = useCheckoutStore()

const savedAddresses = ref([])
const selectedAddressId = ref(null)
const showNewForm = ref(false)

const form = ref({
  firstName: '', lastName: '', line1: '', line2: '',
  city: '', state: '', zip: '', phone: '', saveAddress: true,
})

const usStates = [
  'AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA',
  'KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ',
  'NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT',
  'VA','WA','WV','WI','WY',
]

const canProceed = computed(() => {
  if (selectedAddressId.value && !showNewForm.value) return true
  return form.value.firstName && form.value.lastName &&
         form.value.line1 && form.value.city &&
         form.value.state && form.value.zip
})

onMounted(async () => {
  try {
    const data = await userApi.getAddresses()
    savedAddresses.value = data || []
    if (savedAddresses.value.length) {
      const def = savedAddresses.value.find(a => a.isDefault) || savedAddresses.value[0]
      selectedAddressId.value = def.id
    }
  } catch {
    // Backend not ready, use form
  }
})

async function handleNext() {
  let address
  if (selectedAddressId.value && !showNewForm.value) {
    address = savedAddresses.value.find(a => a.id === selectedAddressId.value)
  } else {
    address = {
      name: `${form.value.firstName} ${form.value.lastName}`,
      ...form.value,
    }
    if (form.value.saveAddress) {
      try { await userApi.createAddress(address) } catch {}
    }
  }
  checkoutStore.setAddress(address)
  router.push('/checkout/delivery')
}
</script>

<style scoped>
.checkout-step h2 { font-size: 1.4rem; font-weight: 700; margin-bottom: 24px; }
.checkout-step h3 { font-size: 1rem; font-weight: 600; margin-bottom: 14px; color: var(--text-muted); }

.saved-addresses { margin-bottom: 24px; }

.address-grid { display: flex; flex-direction: column; gap: 10px; margin-bottom: 14px; }

.address-card {
  border: 2px solid var(--border);
  border-radius: var(--radius);
  padding: 14px 16px;
  cursor: pointer;
  display: flex;
  gap: 12px;
  align-items: flex-start;
  position: relative;
  transition: border-color 0.2s;
  background: white;
}

.address-card.selected { border-color: var(--primary); background: #f0f9ff; }
.addr-name { font-weight: 600; margin-bottom: 2px; }
.addr-info { font-size: 0.88rem; line-height: 1.6; flex: 1; }
.default-badge {
  font-size: 0.72rem;
  background: #dbeafe;
  color: var(--primary);
  padding: 2px 8px;
  border-radius: 4px;
  font-weight: 600;
  white-space: nowrap;
}

.btn-new-addr {
  background: none;
  border: 1px dashed var(--border);
  border-radius: 6px;
  padding: 8px 16px;
  font-size: 0.88rem;
  cursor: pointer;
  color: var(--primary);
  font-weight: 600;
  transition: background 0.2s;
}

.btn-new-addr:hover { background: #f0f9ff; }

/* Form */
.address-form { background: white; border: 1px solid var(--border); border-radius: var(--radius); padding: 24px; }

.form-row { display: grid; gap: 16px; }
.two-col { grid-template-columns: 1fr 1fr; }
.three-col { grid-template-columns: 1fr 1fr 1fr; }

.form-group { display: flex; flex-direction: column; gap: 6px; margin-bottom: 16px; }
.form-group label { font-size: 0.85rem; font-weight: 600; color: var(--text-muted); }

.form-group input,
.form-group select {
  padding: 10px 14px;
  border: 1px solid var(--border);
  border-radius: 6px;
  font-size: 0.9rem;
  outline: none;
  transition: border-color 0.2s;
}

.form-group input:focus,
.form-group select:focus { border-color: var(--primary); }

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 0.88rem;
  cursor: pointer;
}

/* Actions */
.step-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 28px;
}

.btn-back { color: var(--primary); font-size: 0.9rem; font-weight: 600; }
.btn-back:hover { text-decoration: underline; }

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

@media (max-width: 600px) {
  .two-col, .three-col { grid-template-columns: 1fr; }
}
</style>
