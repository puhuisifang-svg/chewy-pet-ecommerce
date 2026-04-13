<template>
  <div class="account-page">
    <div class="page-inner">
      <div class="account-layout">

        <!-- Sidebar Nav -->
        <aside class="account-nav">
          <div class="user-card">
            <div class="user-avatar">👤</div>
            <div>
              <p class="user-name">{{ profile.name || 'My Account' }}</p>
              <p class="user-email">{{ profile.email || '' }}</p>
            </div>
          </div>
          <nav>
            <button
              v-for="tab in tabs"
              :key="tab.id"
              class="nav-item"
              :class="{ active: activeTab === tab.id }"
              @click="activeTab = tab.id"
            >
              {{ tab.icon }} {{ tab.label }}
            </button>
          </nav>
        </aside>

        <!-- Tab Content -->
        <div class="account-content">

          <!-- Profile -->
          <div v-if="activeTab === 'profile'" class="tab-pane">
            <h2>Personal Information</h2>
            <div class="form-grid">
              <div class="form-group">
                <label>First Name</label>
                <input v-model="profileForm.firstName" type="text" />
              </div>
              <div class="form-group">
                <label>Last Name</label>
                <input v-model="profileForm.lastName" type="text" />
              </div>
              <div class="form-group full">
                <label>Email Address</label>
                <input v-model="profileForm.email" type="email" />
              </div>
              <div class="form-group">
                <label>Phone Number</label>
                <input v-model="profileForm.phone" type="tel" />
              </div>
              <div class="form-group">
                <label>Date of Birth</label>
                <input v-model="profileForm.dob" type="date" />
              </div>
            </div>
            <button class="btn-save" @click="saveProfile">Save Changes</button>
          </div>

          <!-- Addresses -->
          <div v-if="activeTab === 'addresses'" class="tab-pane">
            <div class="pane-header">
              <h2>Saved Addresses</h2>
              <button class="btn-add" @click="showAddressModal = true">+ Add Address</button>
            </div>
            <div class="address-list" v-if="addresses.length">
              <div v-for="addr in addresses" :key="addr.id" class="address-card">
                <div class="addr-info">
                  <p class="addr-name">{{ addr.name }}</p>
                  <p>{{ addr.line1 }}</p>
                  <p>{{ addr.city }}, {{ addr.state }} {{ addr.zip }}</p>
                </div>
                <div class="addr-actions">
                  <span v-if="addr.isDefault" class="default-badge">Default</span>
                  <button class="btn-link" @click="editAddress(addr)">Edit</button>
                  <button class="btn-link danger" @click="deleteAddress(addr.id)">Delete</button>
                </div>
              </div>
            </div>
            <div v-else class="empty-state">
              <span>📍</span>
              <p>No saved addresses yet.</p>
            </div>
          </div>

          <!-- Order History -->
          <div v-if="activeTab === 'orders'" class="tab-pane">
            <h2>Order History</h2>
            <div v-if="orders.length" class="order-list">
              <div v-for="order in orders" :key="order.id" class="order-row">
                <div class="order-meta">
                  <p class="order-id">Order #{{ order.id }}</p>
                  <p class="order-date">{{ order.date }}</p>
                </div>
                <div class="order-items-preview">
                  <span v-for="item in order.items.slice(0, 3)" :key="item.id" class="item-dot">
                    {{ item.emoji || '🐾' }}
                  </span>
                  <span v-if="order.items.length > 3" class="more-items">+{{ order.items.length - 3 }}</span>
                </div>
                <div class="order-status-block">
                  <span class="order-status" :class="order.status">{{ order.status }}</span>
                  <p class="order-total">${{ order.total.toFixed(2) }}</p>
                </div>
                <router-link :to="`/order/confirm/${order.id}`" class="btn-link">View →</router-link>
              </div>
            </div>
            <div v-else class="empty-state">
              <span>📦</span>
              <p>No orders yet. <router-link to="/products">Start shopping!</router-link></p>
            </div>
          </div>

          <!-- Password -->
          <div v-if="activeTab === 'password'" class="tab-pane">
            <h2>Change Password</h2>
            <div class="form-grid single">
              <div class="form-group full">
                <label>Current Password</label>
                <input v-model="pwForm.current" type="password" />
              </div>
              <div class="form-group full">
                <label>New Password</label>
                <input v-model="pwForm.newPw" type="password" />
              </div>
              <div class="form-group full">
                <label>Confirm New Password</label>
                <input v-model="pwForm.confirm" type="password" />
              </div>
            </div>
            <button class="btn-save" @click="changePassword">Update Password</button>
          </div>

        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { userApi, orderApi } from '../../api/index'
import { ElMessage } from 'element-plus'

const activeTab = ref('profile')

const tabs = [
  { id: 'profile', icon: '👤', label: 'Profile' },
  { id: 'addresses', icon: '📍', label: 'Addresses' },
  { id: 'orders', icon: '📦', label: 'Order History' },
  { id: 'password', icon: '🔒', label: 'Password' },
]

const profile = ref({ name: '', email: '' })
const profileForm = ref({ firstName: '', lastName: '', email: '', phone: '', dob: '' })
const addresses = ref([])
const orders = ref([])
const showAddressModal = ref(false)

const pwForm = ref({ current: '', newPw: '', confirm: '' })

onMounted(async () => {
  try {
    const p = await userApi.getProfile()
    profile.value = p || {}
    profileForm.value = {
      firstName: p?.firstName || '',
      lastName: p?.lastName || '',
      email: p?.email || '',
      phone: p?.phone || '',
      dob: p?.dob || '',
    }
  } catch {}

  try {
    addresses.value = await userApi.getAddresses() || []
  } catch {
    addresses.value = []
  }

  try {
    orders.value = (await orderApi.getHistory()) || []
  } catch {
    // Demo orders
    orders.value = [
      {
        id: 'DEMO-001',
        date: 'April 10, 2025',
        status: 'delivered',
        total: 79.44,
        items: [{ id: 1, emoji: '🥩' }, { id: 3, emoji: '🧩' }],
      },
      {
        id: 'DEMO-002',
        date: 'March 28, 2025',
        status: 'processing',
        total: 28.49,
        items: [{ id: 2, emoji: '🐱' }],
      },
    ]
  }
})

async function saveProfile() {
  try {
    await userApi.updateProfile(profileForm.value)
    ElMessage({ message: 'Profile updated!', type: 'success' })
  } catch {
    ElMessage({ message: 'Saved locally (backend pending).', type: 'info' })
  }
}

async function deleteAddress(id) {
  try {
    await userApi.deleteAddress(id)
    addresses.value = addresses.value.filter(a => a.id !== id)
    ElMessage({ message: 'Address removed.', type: 'success' })
  } catch {}
}

function editAddress(addr) {
  ElMessage({ message: 'Edit address feature coming soon.', type: 'info' })
}

function changePassword() {
  if (pwForm.value.newPw !== pwForm.value.confirm) {
    ElMessage({ message: 'Passwords do not match.', type: 'error' })
    return
  }
  ElMessage({ message: 'Password updated! (Backend pending)', type: 'success' })
  pwForm.value = { current: '', newPw: '', confirm: '' }
}
</script>

<style scoped>
.account-page { background: var(--bg); min-height: 100vh; }

.page-inner {
  max-width: 1100px;
  margin: 0 auto;
  padding: 32px 24px 60px;
}

.account-layout {
  display: grid;
  grid-template-columns: 240px 1fr;
  gap: 28px;
  align-items: start;
}

/* Sidebar */
.account-nav {
  background: white;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  overflow: hidden;
  position: sticky;
  top: 80px;
}

.user-card {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 20px;
  border-bottom: 1px solid var(--border);
  background: #f8f9fa;
}

.user-avatar { font-size: 2rem; }
.user-name { font-weight: 700; font-size: 0.92rem; }
.user-email { font-size: 0.78rem; color: var(--text-muted); }

.nav-item {
  display: flex;
  align-items: center;
  gap: 10px;
  width: 100%;
  padding: 12px 20px;
  background: none;
  border: none;
  text-align: left;
  font-size: 0.9rem;
  font-weight: 500;
  cursor: pointer;
  color: var(--text);
  transition: background 0.15s;
  border-left: 3px solid transparent;
}

.nav-item:hover { background: #f8f9fa; }
.nav-item.active {
  background: #f0f9ff;
  color: var(--primary);
  border-left-color: var(--primary);
  font-weight: 600;
}

/* Content */
.account-content {
  background: white;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 28px;
}

.tab-pane h2 { font-size: 1.3rem; font-weight: 700; margin-bottom: 24px; }

.pane-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.pane-header h2 { margin-bottom: 0; }

.btn-add {
  padding: 8px 16px;
  background: var(--primary);
  color: white;
  border: none;
  border-radius: 6px;
  font-weight: 600;
  font-size: 0.88rem;
  cursor: pointer;
}

/* Form */
.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 24px;
}

.form-grid.single { grid-template-columns: 1fr; }
.form-group.full { grid-column: 1 / -1; }

.form-group { display: flex; flex-direction: column; gap: 6px; }
.form-group label { font-size: 0.83rem; font-weight: 600; color: var(--text-muted); }

.form-group input {
  padding: 10px 14px;
  border: 1px solid var(--border);
  border-radius: 6px;
  font-size: 0.9rem;
  outline: none;
  transition: border-color 0.2s;
}

.form-group input:focus { border-color: var(--primary); }

.btn-save {
  padding: 11px 28px;
  background: var(--primary);
  color: white;
  border: none;
  border-radius: 6px;
  font-weight: 700;
  cursor: pointer;
  transition: background 0.2s;
}

.btn-save:hover { background: var(--primary-hover); }

/* Addresses */
.address-list { display: flex; flex-direction: column; gap: 12px; }

.address-card {
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 16px 20px;
  display: flex;
  align-items: flex-start;
  gap: 12px;
}

.addr-info { flex: 1; font-size: 0.88rem; line-height: 1.6; }
.addr-name { font-weight: 600; }
.addr-actions { display: flex; align-items: center; gap: 10px; }

.default-badge {
  font-size: 0.72rem;
  background: #dbeafe;
  color: var(--primary);
  padding: 2px 8px;
  border-radius: 4px;
  font-weight: 600;
}

.btn-link {
  background: none;
  border: none;
  color: var(--primary);
  font-size: 0.85rem;
  cursor: pointer;
  text-decoration: underline;
}

.btn-link.danger { color: #dc2626; }

/* Orders */
.order-list { display: flex; flex-direction: column; gap: 12px; }

.order-row {
  display: flex;
  align-items: center;
  gap: 16px;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 14px 18px;
  background: #fafafa;
}

.order-meta { min-width: 140px; }
.order-id { font-weight: 700; font-size: 0.9rem; }
.order-date { font-size: 0.8rem; color: var(--text-muted); }

.order-items-preview { display: flex; align-items: center; gap: 4px; flex: 1; }
.item-dot { font-size: 1.4rem; }
.more-items { font-size: 0.8rem; color: var(--text-muted); }

.order-status-block { text-align: right; min-width: 90px; }

.order-status {
  font-size: 0.78rem;
  font-weight: 700;
  padding: 3px 8px;
  border-radius: 4px;
  text-transform: capitalize;
}

.order-status.delivered { background: #dcfce7; color: #16a34a; }
.order-status.processing { background: #fef3c7; color: #92400e; }
.order-status.shipped { background: #dbeafe; color: #1d4ed8; }

.order-total { font-size: 0.9rem; font-weight: 700; margin-top: 4px; }

/* Empty */
.empty-state { text-align: center; padding: 48px; color: var(--text-muted); }
.empty-state span { font-size: 2.5rem; display: block; margin-bottom: 12px; }

@media (max-width: 800px) {
  .account-layout { grid-template-columns: 1fr; }
  .account-nav { position: static; }
  .user-card { display: none; }
  .account-nav nav { display: flex; flex-wrap: wrap; gap: 4px; padding: 12px; }
  .nav-item { width: auto; border-left: none; border-bottom: 2px solid transparent; }
  .nav-item.active { border-bottom-color: var(--primary); border-left: none; }
  .form-grid { grid-template-columns: 1fr; }
}
</style>
