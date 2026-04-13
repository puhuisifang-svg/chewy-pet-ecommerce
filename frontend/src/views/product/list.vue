<template>
  <div class="product-list-page">
    <div class="page-inner">

      <!-- Sidebar Filters -->
      <aside class="sidebar">
        <h3>Filter By</h3>

        <div class="filter-group">
          <h4>Pet Type</h4>
          <ul class="filter-list">
            <li :class="{ active: !filters.category }" @click="setFilter('category', null)">
              🐾 All Pets
            </li>
            <li
              v-for="cat in categories"
              :key="cat.slug"
              :class="{ active: filters.category === cat.slug }"
              @click="setFilter('category', cat.slug)"
            >
              {{ cat.emoji }} {{ cat.name }}
            </li>
          </ul>
        </div>

        <div class="filter-group">
          <h4>Price Range</h4>
          <ul class="filter-list">
            <li :class="{ active: !filters.priceRange }" @click="setFilter('priceRange', null)">
              Any Price
            </li>
            <li
              v-for="range in priceRanges"
              :key="range.label"
              :class="{ active: filters.priceRange === range.label }"
              @click="setFilter('priceRange', range.label)"
            >
              {{ range.label }}
            </li>
          </ul>
        </div>
      </aside>

      <!-- Main Content -->
      <div class="main-content">

        <!-- Toolbar -->
        <div class="toolbar">
          <div class="result-count">
            <span v-if="loading">Loading...</span>
            <span v-else>{{ total }} Products</span>
          </div>
          <div class="toolbar-right">
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search products..."
              class="search-input"
              @input="onSearch"
            />
            <select v-model="sortBy" class="sort-select" @change="fetchProducts">
              <option value="">Featured</option>
              <option value="price_asc">Price: Low to High</option>
              <option value="price_desc">Price: High to Low</option>
            </select>
          </div>
        </div>

        <!-- Loading -->
        <div v-if="loading" class="loading-grid">
          <div v-for="n in 12" :key="n" class="skeleton-card">
            <div class="skeleton-img"></div>
            <div class="skeleton-line wide"></div>
            <div class="skeleton-line"></div>
            <div class="skeleton-line narrow"></div>
          </div>
        </div>

        <!-- Product Grid -->
        <div v-else-if="products.length" class="product-grid">
          <div
            v-for="product in products"
            :key="product.id"
            class="product-card"
          >
            <router-link :to="`/product/${product.id}`">
              <div class="product-img">
                <img
                  v-if="getImage(product)"
                  :src="getImage(product)"
                  :alt="product.name"
                  @error="onImgError($event)"
                />
                <span v-else class="product-emoji">🐾</span>
                <span v-if="product.salePrice && product.salePrice < product.price" class="product-badge">Sale</span>
              </div>
              <div class="product-info">
                <span class="product-brand">{{ product.brand }}</span>
                <h3 class="product-name">{{ product.name }}</h3>
                <div class="product-price">
                  <span class="price">${{ displayPrice(product) }}</span>
                  <span v-if="product.salePrice && product.salePrice < product.price" class="original-price">
                    ${{ product.price.toFixed(2) }}
                  </span>
                </div>
              </div>
            </router-link>
            <button class="btn-add-cart" @click="addToCart(product)">Add to Cart</button>
          </div>
        </div>

        <!-- Empty -->
        <div v-else class="empty-state">
          <span>🔍</span>
          <p>No products found. Try adjusting your filters.</p>
        </div>

        <!-- Pagination -->
        <div v-if="totalPages > 1" class="pagination">
          <button
            class="page-btn"
            :disabled="currentPage === 1"
            @click="goPage(currentPage - 1)"
          >‹ Prev</button>
          <button
            v-for="p in visiblePages"
            :key="p"
            class="page-btn"
            :class="{ active: p === currentPage }"
            @click="goPage(p)"
          >{{ p }}</button>
          <button
            class="page-btn"
            :disabled="currentPage === totalPages"
            @click="goPage(currentPage + 1)"
          >Next ›</button>
        </div>

      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useCartStore } from '../../stores/cart'
import { productApi } from '../../api/index'
import { ElMessage } from 'element-plus'

const route = useRoute()
const cartStore = useCartStore()

const products = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(20)
const loading = ref(false)
const searchQuery = ref('')
const sortBy = ref('')

let searchTimer = null

const filters = ref({
  category: route.query.category || null,
  priceRange: null,
})

const categories = [
  { slug: 'dog', name: 'Dogs', emoji: '🐶' },
  { slug: 'cat', name: 'Cats', emoji: '🐱' },
  { slug: 'fish', name: 'Fish', emoji: '🐟' },
  { slug: 'bird', name: 'Birds', emoji: '🐦' },
  { slug: 'small-pet', name: 'Small Pets', emoji: '🐹' },
  { slug: 'reptile', name: 'Reptiles', emoji: '🦎' },
]

const priceRanges = [
  { label: 'Under $25', min: 0, max: 25 },
  { label: '$25 – $50', min: 25, max: 50 },
  { label: '$50 – $100', min: 50, max: 100 },
  { label: 'Over $100', min: 100, max: 9999 },
]

const totalPages = computed(() => Math.ceil(total.value / pageSize.value))

const visiblePages = computed(() => {
  const pages = []
  const start = Math.max(1, currentPage.value - 2)
  const end = Math.min(totalPages.value, currentPage.value + 2)
  for (let i = start; i <= end; i++) pages.push(i)
  return pages
})

async function fetchProducts() {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      size: pageSize.value,
    }
    if (searchQuery.value) params.keyword = searchQuery.value
    if (filters.value.category) params.category = filters.value.category
    if (sortBy.value) params.sort = sortBy.value
    if (filters.value.priceRange) {
      const range = priceRanges.find(r => r.label === filters.value.priceRange)
      if (range) {
        params.minPrice = range.min
        params.maxPrice = range.max
      }
    }

    const res = await productApi.list(params)
    // Handle response envelope: { code, data: { records, total, ... } }
    const data = res?.data || res
    products.value = data?.records || data?.list || data || []
    total.value = data?.total || products.value.length
  } catch (err) {
    console.error('[Products] fetch failed', err)
    ElMessage({ message: 'Failed to load products. Please retry.', type: 'error' })
    products.value = []
  } finally {
    loading.value = false
  }
}

function setFilter(key, value) {
  filters.value[key] = value
  currentPage.value = 1
  fetchProducts()
}

function onSearch() {
  clearTimeout(searchTimer)
  searchTimer = setTimeout(() => {
    currentPage.value = 1
    fetchProducts()
  }, 400)
}

function goPage(p) {
  if (p < 1 || p > totalPages.value) return
  currentPage.value = p
  fetchProducts()
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

function getImage(product) {
  try {
    const imgs = JSON.parse(product.images)
    return Array.isArray(imgs) ? imgs[0] : imgs
  } catch {
    return product.images || null
  }
}

function onImgError(e) {
  e.target.style.display = 'none'
  e.target.parentElement.querySelector('.product-emoji') && (e.target.parentElement.querySelector('.product-emoji').style.display = 'flex')
}

function displayPrice(product) {
  const p = product.salePrice && product.salePrice < product.price
    ? product.salePrice
    : product.price
  return Number(p).toFixed(2)
}

function addToCart(product) {
  cartStore.addItem({
    id: product.id,
    name: product.name,
    brand: product.brand,
    price: product.salePrice || product.price,
    emoji: '🐾',
    image: getImage(product),
  })
  ElMessage({ message: `${product.name.slice(0, 30)}... added to cart!`, type: 'success', duration: 2000 })
}

onMounted(fetchProducts)
</script>

<style scoped>
.product-list-page { background: var(--bg); min-height: 100vh; }

.page-inner {
  max-width: 1280px;
  margin: 0 auto;
  padding: 32px 24px;
  display: grid;
  grid-template-columns: 220px 1fr;
  gap: 28px;
  align-items: start;
}

/* Sidebar */
.sidebar {
  background: white;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 20px;
  position: sticky;
  top: 80px;
}

.sidebar > h3 {
  font-size: 1rem;
  font-weight: 700;
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 1px solid var(--border);
}

.filter-group { margin-bottom: 20px; }
.filter-group h4 {
  font-size: 0.8rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--text-muted);
  margin-bottom: 8px;
}

.filter-list { list-style: none; display: flex; flex-direction: column; gap: 2px; }
.filter-list li {
  padding: 6px 10px;
  border-radius: 6px;
  font-size: 0.88rem;
  cursor: pointer;
  color: var(--text-muted);
  transition: all 0.15s;
}
.filter-list li:hover { background: #f0f9ff; color: var(--primary); }
.filter-list li.active { background: #e0f2fe; color: var(--primary); font-weight: 600; }

/* Toolbar */
.toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
  gap: 12px;
  flex-wrap: wrap;
}

.result-count { font-weight: 600; }

.toolbar-right { display: flex; gap: 10px; align-items: center; }

.search-input {
  padding: 8px 14px;
  border: 1px solid var(--border);
  border-radius: 6px;
  font-size: 0.88rem;
  outline: none;
  width: 200px;
}
.search-input:focus { border-color: var(--primary); }

.sort-select {
  padding: 8px 10px;
  border: 1px solid var(--border);
  border-radius: 6px;
  font-size: 0.88rem;
  background: white;
  cursor: pointer;
  outline: none;
}

/* Skeleton */
.loading-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 18px;
}

.skeleton-card {
  background: white;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  overflow: hidden;
  animation: pulse 1.5s ease-in-out infinite;
}

.skeleton-img { height: 160px; background: #e5e7eb; }
.skeleton-line { height: 14px; background: #e5e7eb; margin: 12px 14px 8px; border-radius: 4px; }
.skeleton-line.wide { width: 80%; }
.skeleton-line.narrow { width: 40%; margin-bottom: 16px; }

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.6; }
}

/* Product Grid */
.product-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 18px;
}

.product-card {
  background: white;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  transition: box-shadow 0.2s, transform 0.2s;
}
.product-card:hover { box-shadow: 0 6px 20px rgba(0,0,0,0.1); transform: translateY(-2px); }
.product-card > a { flex: 1; }

.product-img {
  position: relative;
  background: #f8f9fa;
  height: 180px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.product-img img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  padding: 12px;
}

.product-emoji { font-size: 4rem; }

.product-badge {
  position: absolute;
  top: 8px;
  left: 8px;
  background: var(--accent);
  color: white;
  font-size: 0.7rem;
  font-weight: 700;
  padding: 2px 7px;
  border-radius: 4px;
}

.product-info { padding: 12px 14px; }
.product-brand { font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.04em; }
.product-name { font-size: 0.88rem; font-weight: 600; margin: 4px 0 8px; line-height: 1.4; }
.product-price { display: flex; align-items: center; gap: 6px; }
.price { font-size: 1rem; font-weight: 700; color: var(--primary); }
.original-price { font-size: 0.8rem; color: var(--text-muted); text-decoration: line-through; }

.btn-add-cart {
  width: 100%;
  padding: 11px;
  background: var(--primary);
  color: white;
  border: none;
  font-weight: 600;
  font-size: 0.88rem;
  cursor: pointer;
  transition: background 0.2s;
}
.btn-add-cart:hover { background: var(--primary-hover); }

/* Empty */
.empty-state { text-align: center; padding: 60px 24px; color: var(--text-muted); }
.empty-state span { font-size: 3rem; display: block; margin-bottom: 14px; }

/* Pagination */
.pagination {
  display: flex;
  justify-content: center;
  gap: 6px;
  margin-top: 36px;
}

.page-btn {
  padding: 8px 14px;
  border: 1px solid var(--border);
  border-radius: 6px;
  background: white;
  font-size: 0.88rem;
  cursor: pointer;
  transition: all 0.15s;
}
.page-btn:hover:not(:disabled) { border-color: var(--primary); color: var(--primary); }
.page-btn.active { background: var(--primary); color: white; border-color: var(--primary); }
.page-btn:disabled { opacity: 0.4; cursor: not-allowed; }

/* Responsive */
@media (max-width: 1024px) {
  .page-inner { grid-template-columns: 180px 1fr; }
  .product-grid { grid-template-columns: repeat(2, 1fr); }
  .loading-grid { grid-template-columns: repeat(2, 1fr); }
}

@media (max-width: 768px) {
  .page-inner { grid-template-columns: 1fr; padding: 16px; }
  .sidebar { display: none; }
  .product-grid { grid-template-columns: repeat(2, 1fr); gap: 12px; }
  .loading-grid { grid-template-columns: repeat(2, 1fr); }
}

@media (max-width: 480px) {
  .product-grid { grid-template-columns: 1fr; }
  .loading-grid { grid-template-columns: 1fr; }
}
</style>
