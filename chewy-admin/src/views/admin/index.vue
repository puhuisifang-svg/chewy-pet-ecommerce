<template>
  <div class="admin-page">
    <!-- Admin Header -->
    <header class="admin-header">
      <div class="admin-logo">🐾 PawShop Admin</div>
      <nav class="admin-nav">
        <button
          v-for="tab in tabs"
          :key="tab.id"
          class="admin-nav-btn"
          :class="{ active: activeTab === tab.id }"
          @click="activeTab = tab.id"
        >
          {{ tab.icon }} {{ tab.label }}
        </button>
      </nav>
      <router-link to="/" class="btn-storefront">← Storefront</router-link>
    </header>

    <div class="admin-content">

      <!-- Dashboard -->
      <div v-if="activeTab === 'dashboard'" class="tab-pane">
        <h2>Dashboard</h2>
        <div class="stats-grid">
          <div class="stat-card">
            <p class="stat-value">$12,480</p>
            <p class="stat-label">Total Revenue (Month)</p>
            <p class="stat-delta up">↑ 18% vs last month</p>
          </div>
          <div class="stat-card">
            <p class="stat-value">247</p>
            <p class="stat-label">Orders This Month</p>
            <p class="stat-delta up">↑ 12% vs last month</p>
          </div>
          <div class="stat-card">
            <p class="stat-value">1,034</p>
            <p class="stat-label">Active Customers</p>
            <p class="stat-delta up">↑ 8% vs last month</p>
          </div>
          <div class="stat-card">
            <p class="stat-value">38</p>
            <p class="stat-label">Low Stock Items</p>
            <p class="stat-delta down">↑ 5 from last week</p>
          </div>
        </div>

        <h3 style="margin: 24px 0 14px">Recent Orders</h3>
        <div class="data-table">
          <table>
            <thead>
              <tr>
                <th>Order ID</th><th>Customer</th><th>Date</th><th>Total</th><th>Status</th><th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="order in recentOrders" :key="order.id">
                <td>#{{ order.id }}</td>
                <td>{{ order.customer }}</td>
                <td>{{ order.date }}</td>
                <td>${{ order.total.toFixed(2) }}</td>
                <td><span class="status-badge" :class="order.status">{{ order.status }}</span></td>
                <td><button class="btn-sm">View</button></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Products -->
      <div v-if="activeTab === 'products'" class="tab-pane">
        <div class="pane-header">
          <h2>Product Management</h2>
          <button class="btn-primary" @click="openProductModal()">+ Add Product</button>
        </div>

        <!-- Search / Filter -->
        <div class="table-toolbar">
          <input v-model="productSearch" type="text" placeholder="Search products..." class="search-input" />
          <select v-model="productCategoryFilter" class="filter-select">
            <option value="">All Categories</option>
            <option v-for="cat in categories" :key="cat">{{ cat }}</option>
          </select>
        </div>

        <div class="data-table">
          <table>
            <thead>
              <tr>
                <th>Product</th><th>Category</th><th>Price</th><th>Stock</th><th>Status</th><th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="product in filteredAdminProducts" :key="product.id">
                <td>
                  <div class="product-cell">
                    <span class="p-emoji">{{ product.emoji }}</span>
                    <div>
                      <p class="p-name">{{ product.name }}</p>
                      <p class="p-brand">{{ product.brand }}</p>
                    </div>
                  </div>
                </td>
                <td>{{ product.category }}</td>
                <td>${{ product.price.toFixed(2) }}</td>
                <td>
                  <span class="stock-badge" :class="{ low: product.stock < 10, out: product.stock === 0 }">
                    {{ product.stock }}
                  </span>
                </td>
                <td>
                  <span class="status-badge" :class="product.active ? 'active' : 'inactive'">
                    {{ product.active ? 'Active' : 'Inactive' }}
                  </span>
                </td>
                <td class="actions-cell">
                  <button class="btn-sm" @click="openProductModal(product)">Edit</button>
                  <button class="btn-sm danger" @click="toggleProduct(product)">
                    {{ product.active ? 'Disable' : 'Enable' }}
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Inventory -->
      <div v-if="activeTab === 'inventory'" class="tab-pane">
        <h2>Inventory Management</h2>
        <div class="data-table">
          <table>
            <thead>
              <tr><th>Product</th><th>SKU</th><th>Current Stock</th><th>Adjust</th><th>Save</th></tr>
            </thead>
            <tbody>
              <tr v-for="product in adminProducts" :key="product.id">
                <td>
                  <div class="product-cell">
                    <span class="p-emoji">{{ product.emoji }}</span>
                    <p class="p-name">{{ product.name }}</p>
                  </div>
                </td>
                <td class="sku">{{ 'SKU-' + String(product.id).padStart(4, '0') }}</td>
                <td>
                  <span class="stock-badge" :class="{ low: product.stock < 10, out: product.stock === 0 }">
                    {{ product.stock }}
                  </span>
                </td>
                <td>
                  <input
                    v-model.number="product.newStock"
                    type="number"
                    min="0"
                    class="stock-input"
                    :placeholder="product.stock"
                  />
                </td>
                <td>
                  <button class="btn-sm" @click="updateStock(product)">Update</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Orders -->
      <div v-if="activeTab === 'orders'" class="tab-pane">
        <div class="pane-header">
          <h2>Order Management</h2>
          <select v-model="orderStatusFilter" class="filter-select">
            <option value="">All Status</option>
            <option>processing</option>
            <option>shipped</option>
            <option>delivered</option>
            <option>cancelled</option>
          </select>
        </div>
        <div class="data-table">
          <table>
            <thead>
              <tr><th>Order ID</th><th>Customer</th><th>Date</th><th>Items</th><th>Total</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
              <tr v-for="order in filteredOrders" :key="order.id">
                <td>#{{ order.id }}</td>
                <td>{{ order.customer }}</td>
                <td>{{ order.date }}</td>
                <td>{{ order.itemCount }}</td>
                <td>${{ order.total.toFixed(2) }}</td>
                <td>
                  <select class="status-select" v-model="order.status" @change="updateOrderStatus(order)">
                    <option>processing</option>
                    <option>shipped</option>
                    <option>delivered</option>
                    <option>cancelled</option>
                  </select>
                </td>
                <td><button class="btn-sm">Details</button></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

    </div>

    <!-- Product Modal -->
    <div v-if="showProductModal" class="modal-overlay" @click.self="showProductModal = false">
      <div class="modal">
        <div class="modal-header">
          <h3>{{ editingProduct.id ? 'Edit Product' : 'Add New Product' }}</h3>
          <button class="modal-close" @click="showProductModal = false">✕</button>
        </div>
        <div class="modal-body">
          <div class="form-row"><div class="form-group">
            <label>Product Name</label>
            <input v-model="editingProduct.name" type="text" />
          </div></div>
          <div class="form-row two-col">
            <div class="form-group">
              <label>Brand</label>
              <input v-model="editingProduct.brand" type="text" />
            </div>
            <div class="form-group">
              <label>Category</label>
              <select v-model="editingProduct.category">
                <option v-for="cat in categories" :key="cat" :value="cat">{{ cat }}</option>
              </select>
            </div>
          </div>
          <div class="form-row two-col">
            <div class="form-group">
              <label>Price ($)</label>
              <input v-model.number="editingProduct.price" type="number" step="0.01" />
            </div>
            <div class="form-group">
              <label>Original Price ($)</label>
              <input v-model.number="editingProduct.originalPrice" type="number" step="0.01" placeholder="Leave blank if no discount" />
            </div>
          </div>
          <div class="form-group">
            <label>Initial Stock</label>
            <input v-model.number="editingProduct.stock" type="number" min="0" />
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn-cancel" @click="showProductModal = false">Cancel</button>
          <button class="btn-primary" @click="saveProduct">
            {{ editingProduct.id ? 'Save Changes' : 'Create Product' }}
          </button>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { productApi, orderApi } from '../../api/index'
import { ElMessage } from 'element-plus'

const activeTab = ref('dashboard')
const showProductModal = ref(false)
const editingProduct = ref({})
const productSearch = ref('')
const productCategoryFilter = ref('')
const orderStatusFilter = ref('')

const tabs = [
  { id: 'dashboard', icon: '📊', label: 'Dashboard' },
  { id: 'products', icon: '📦', label: 'Products' },
  { id: 'inventory', icon: '🏭', label: 'Inventory' },
  { id: 'orders', icon: '🛒', label: 'Orders' },
]

const categories = ['dog', 'cat', 'fish', 'bird', 'small-pet', 'reptile']

const adminProducts = ref([
  { id: 1, name: 'Adult Complete Dry Dog Food', brand: 'Blue Buffalo', category: 'dog', emoji: '🥩', price: 54.99, originalPrice: 64.99, stock: 142, active: true },
  { id: 2, name: 'Indoor Cat Grain-Free Food', brand: 'Wellness', category: 'cat', emoji: '🐱', price: 28.49, originalPrice: null, stock: 87, active: true },
  { id: 3, name: 'Interactive Puzzle Toy', brand: 'KONG', category: 'dog', emoji: '🧩', price: 14.99, originalPrice: 19.99, stock: 6, active: true },
  { id: 4, name: 'Orthopedic Memory Foam Bed', brand: 'Big Barker', category: 'dog', emoji: '🛏️', price: 89.95, originalPrice: null, stock: 23, active: true },
  { id: 5, name: 'Premium Kitten Dry Food', brand: 'Royal Canin', category: 'cat', emoji: '🐟', price: 38.99, originalPrice: null, stock: 0, active: false },
])

const recentOrders = ref([
  { id: '10045', customer: 'Sarah M.', date: 'Apr 13, 2025', total: 79.44, status: 'processing' },
  { id: '10044', customer: 'John D.', date: 'Apr 12, 2025', total: 28.49, status: 'shipped' },
  { id: '10043', customer: 'Emily R.', date: 'Apr 11, 2025', total: 144.90, status: 'delivered' },
  { id: '10042', customer: 'Mike T.', date: 'Apr 10, 2025', total: 54.99, status: 'delivered' },
])

const allOrders = ref([
  { id: '10045', customer: 'Sarah M.', date: 'Apr 13', itemCount: 2, total: 79.44, status: 'processing' },
  { id: '10044', customer: 'John D.', date: 'Apr 12', itemCount: 1, total: 28.49, status: 'shipped' },
  { id: '10043', customer: 'Emily R.', date: 'Apr 11', itemCount: 3, total: 144.90, status: 'delivered' },
])

const filteredAdminProducts = computed(() => {
  let list = adminProducts.value
  if (productSearch.value) {
    const q = productSearch.value.toLowerCase()
    list = list.filter(p => p.name.toLowerCase().includes(q) || p.brand.toLowerCase().includes(q))
  }
  if (productCategoryFilter.value) {
    list = list.filter(p => p.category === productCategoryFilter.value)
  }
  return list
})

const filteredOrders = computed(() => {
  if (!orderStatusFilter.value) return allOrders.value
  return allOrders.value.filter(o => o.status === orderStatusFilter.value)
})

function openProductModal(product = {}) {
  editingProduct.value = { ...product }
  showProductModal.value = true
}

function saveProduct() {
  if (editingProduct.value.id) {
    const idx = adminProducts.value.findIndex(p => p.id === editingProduct.value.id)
    if (idx >= 0) adminProducts.value[idx] = { ...editingProduct.value }
    ElMessage({ message: 'Product updated!', type: 'success' })
  } else {
    adminProducts.value.push({
      ...editingProduct.value,
      id: Date.now(),
      emoji: '🐾',
      active: true,
      stock: editingProduct.value.stock || 0,
    })
    ElMessage({ message: 'Product created!', type: 'success' })
  }
  showProductModal.value = false
  // Sync to backend when ready
  const fn = editingProduct.value.id
    ? productApi.update(editingProduct.value.id, editingProduct.value)
    : productApi.create(editingProduct.value)
  fn.catch(() => {})
}

function toggleProduct(product) {
  product.active = !product.active
  ElMessage({ message: `Product ${product.active ? 'enabled' : 'disabled'}.`, type: 'info' })
}

function updateStock(product) {
  if (product.newStock === undefined || product.newStock === '') return
  product.stock = product.newStock
  product.newStock = undefined
  ElMessage({ message: `Stock updated to ${product.stock}.`, type: 'success' })
  productApi.updateStock(product.id, product.stock).catch(() => {})
}

function updateOrderStatus(order) {
  ElMessage({ message: `Order #${order.id} status → ${order.status}`, type: 'success' })
}
</script>

<style scoped>
.admin-page { background: #0f172a; min-height: 100vh; display: flex; flex-direction: column; }

/* Header */
.admin-header {
  background: #1e293b;
  border-bottom: 1px solid #334155;
  padding: 0 24px;
  height: 56px;
  display: flex;
  align-items: center;
  gap: 24px;
}

.admin-logo { color: white; font-weight: 800; font-size: 1.1rem; white-space: nowrap; }

.admin-nav { display: flex; gap: 4px; flex: 1; }

.admin-nav-btn {
  padding: 7px 14px;
  background: none;
  border: none;
  color: #94a3b8;
  border-radius: 6px;
  font-size: 0.85rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.15s;
}

.admin-nav-btn:hover { background: #334155; color: white; }
.admin-nav-btn.active { background: #3b82f6; color: white; }

.btn-storefront {
  color: #94a3b8;
  font-size: 0.82rem;
  font-weight: 600;
  white-space: nowrap;
  transition: color 0.15s;
}

.btn-storefront:hover { color: white; }

/* Content */
.admin-content { padding: 28px 24px; flex: 1; }

.tab-pane h2 { color: white; font-size: 1.3rem; font-weight: 700; margin-bottom: 20px; }
.tab-pane h3 { color: #e2e8f0; font-size: 1rem; font-weight: 600; }

/* Stats */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 28px;
}

.stat-card {
  background: #1e293b;
  border: 1px solid #334155;
  border-radius: var(--radius);
  padding: 20px;
}

.stat-value { font-size: 1.8rem; font-weight: 800; color: white; margin-bottom: 4px; }
.stat-label { font-size: 0.82rem; color: #94a3b8; margin-bottom: 6px; }
.stat-delta { font-size: 0.78rem; font-weight: 600; }
.stat-delta.up { color: #34d399; }
.stat-delta.down { color: #f87171; }

/* Toolbar */
.pane-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.pane-header h2 { margin-bottom: 0; }

.table-toolbar { display: flex; gap: 12px; margin-bottom: 16px; }

.search-input, .filter-select {
  padding: 8px 14px;
  background: #1e293b;
  border: 1px solid #334155;
  border-radius: 6px;
  color: white;
  font-size: 0.88rem;
  outline: none;
}

.search-input { width: 280px; }
.search-input::placeholder { color: #64748b; }

/* Table */
.data-table {
  background: #1e293b;
  border: 1px solid #334155;
  border-radius: var(--radius);
  overflow: hidden;
}

.data-table table { width: 100%; border-collapse: collapse; }

.data-table th {
  background: #0f172a;
  color: #94a3b8;
  font-size: 0.78rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  padding: 10px 14px;
  text-align: left;
}

.data-table td {
  padding: 12px 14px;
  color: #e2e8f0;
  font-size: 0.88rem;
  border-top: 1px solid #334155;
}

.data-table tr:hover td { background: #263248; }

/* Product Cell */
.product-cell { display: flex; align-items: center; gap: 10px; }
.p-emoji { font-size: 1.5rem; flex-shrink: 0; }
.p-name { font-weight: 600; font-size: 0.88rem; }
.p-brand { font-size: 0.78rem; color: #64748b; }

/* Badges */
.status-badge {
  font-size: 0.75rem;
  font-weight: 700;
  padding: 3px 8px;
  border-radius: 4px;
  text-transform: capitalize;
}

.status-badge.processing { background: #7c3aed22; color: #a78bfa; }
.status-badge.shipped { background: #1d4ed822; color: #60a5fa; }
.status-badge.delivered { background: #16a34a22; color: #4ade80; }
.status-badge.cancelled { background: #dc262622; color: #f87171; }
.status-badge.active { background: #16a34a22; color: #4ade80; }
.status-badge.inactive { background: #334155; color: #94a3b8; }

.stock-badge {
  font-weight: 700;
  font-size: 0.88rem;
  padding: 2px 8px;
  border-radius: 4px;
  background: #16a34a22;
  color: #4ade80;
}

.stock-badge.low { background: #f59e0b22; color: #fbbf24; }
.stock-badge.out { background: #dc262622; color: #f87171; }

/* Buttons */
.btn-primary {
  padding: 8px 18px;
  background: #3b82f6;
  color: white;
  border: none;
  border-radius: 6px;
  font-weight: 600;
  font-size: 0.88rem;
  cursor: pointer;
}

.btn-primary:hover { background: #2563eb; }

.btn-sm {
  padding: 4px 12px;
  background: #334155;
  color: #e2e8f0;
  border: none;
  border-radius: 4px;
  font-size: 0.78rem;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.15s;
}

.btn-sm:hover { background: #475569; }
.btn-sm.danger { color: #f87171; }
.btn-sm.danger:hover { background: #7f1d1d44; }

.actions-cell { display: flex; gap: 6px; }

.sku { font-family: monospace; font-size: 0.8rem; color: #64748b; }

.stock-input {
  width: 80px;
  padding: 4px 8px;
  background: #0f172a;
  border: 1px solid #334155;
  border-radius: 4px;
  color: white;
  font-size: 0.88rem;
}

.status-select {
  background: #0f172a;
  border: 1px solid #334155;
  border-radius: 4px;
  color: #e2e8f0;
  font-size: 0.82rem;
  padding: 4px 6px;
}

/* Modal */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.7);
  z-index: 200;
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal {
  background: #1e293b;
  border: 1px solid #334155;
  border-radius: 12px;
  width: 500px;
  max-width: 90vw;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid #334155;
}

.modal-header h3 { color: white; font-weight: 700; }

.modal-close {
  background: none;
  border: none;
  color: #94a3b8;
  font-size: 1.1rem;
  cursor: pointer;
}

.modal-body { padding: 20px; }
.modal-footer { padding: 16px 20px; border-top: 1px solid #334155; display: flex; justify-content: flex-end; gap: 10px; }

.form-row { margin-bottom: 0; }
.form-row.two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }

.form-group { display: flex; flex-direction: column; gap: 6px; margin-bottom: 14px; }
.form-group label { font-size: 0.82rem; font-weight: 600; color: #94a3b8; }

.form-group input, .form-group select {
  padding: 9px 12px;
  background: #0f172a;
  border: 1px solid #334155;
  border-radius: 6px;
  color: white;
  font-size: 0.88rem;
  outline: none;
}

.form-group input:focus, .form-group select:focus { border-color: #3b82f6; }

.btn-cancel {
  padding: 8px 18px;
  background: #334155;
  color: #e2e8f0;
  border: none;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
}

@media (max-width: 1024px) {
  .stats-grid { grid-template-columns: repeat(2, 1fr); }
}

@media (max-width: 600px) {
  .admin-header { flex-wrap: wrap; height: auto; padding: 10px 16px; gap: 10px; }
  .admin-nav { flex-wrap: wrap; }
  .stats-grid { grid-template-columns: 1fr 1fr; }
}
</style>
