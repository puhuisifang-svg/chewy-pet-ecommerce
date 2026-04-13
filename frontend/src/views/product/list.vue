<template>
  <div class="product-list-page">
    <div class="page-inner">

      <!-- Sidebar Filters -->
      <aside class="sidebar">
        <h3>Filter By</h3>

        <!-- Category -->
        <div class="filter-group">
          <h4>Pet Type</h4>
          <ul class="filter-list">
            <li
              v-for="cat in categories"
              :key="cat.slug"
              :class="{ active: filters.category === cat.slug }"
              @click="setFilter('category', cat.slug)"
            >
              {{ cat.emoji }} {{ cat.name }}
            </li>
            <li :class="{ active: !filters.category }" @click="setFilter('category', null)">
              🐾 All Pets
            </li>
          </ul>
        </div>

        <!-- Price Range -->
        <div class="filter-group">
          <h4>Price Range</h4>
          <ul class="filter-list">
            <li
              v-for="range in priceRanges"
              :key="range.label"
              :class="{ active: filters.priceRange === range.label }"
              @click="setFilter('priceRange', range.label)"
            >
              {{ range.label }}
            </li>
            <li :class="{ active: !filters.priceRange }" @click="setFilter('priceRange', null)">
              Any Price
            </li>
          </ul>
        </div>

        <!-- Brand -->
        <div class="filter-group">
          <h4>Brand</h4>
          <ul class="filter-list">
            <li
              v-for="brand in brands"
              :key="brand"
              :class="{ active: filters.brand === brand }"
              @click="setFilter('brand', brand)"
            >
              {{ brand }}
            </li>
            <li :class="{ active: !filters.brand }" @click="setFilter('brand', null)">
              All Brands
            </li>
          </ul>
        </div>
      </aside>

      <!-- Main Content -->
      <div class="main-content">

        <!-- Toolbar -->
        <div class="toolbar">
          <div class="result-count">
            {{ filteredProducts.length }} Products
            <span v-if="searchQuery" class="search-term">for "{{ searchQuery }}"</span>
          </div>
          <div class="toolbar-right">
            <!-- Search -->
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search products..."
              class="search-input"
            />
            <!-- Sort -->
            <select v-model="sortBy" class="sort-select">
              <option value="featured">Featured</option>
              <option value="price-asc">Price: Low to High</option>
              <option value="price-desc">Price: High to Low</option>
              <option value="rating">Top Rated</option>
            </select>
          </div>
        </div>

        <!-- Product Grid -->
        <div class="product-grid" v-if="filteredProducts.length">
          <div
            v-for="product in filteredProducts"
            :key="product.id"
            class="product-card"
          >
            <router-link :to="`/product/${product.id}`">
              <div class="product-img">
                <span class="product-emoji">{{ product.emoji }}</span>
                <span v-if="product.badge" class="product-badge">{{ product.badge }}</span>
              </div>
              <div class="product-info">
                <span class="product-brand">{{ product.brand }}</span>
                <h3 class="product-name">{{ product.name }}</h3>
                <div class="product-rating">
                  <span class="stars">★★★★★</span>
                  <span class="review-count">({{ product.reviews.toLocaleString() }})</span>
                </div>
                <div class="product-price">
                  <span class="price">${{ product.price.toFixed(2) }}</span>
                  <span v-if="product.originalPrice" class="original-price">
                    ${{ product.originalPrice.toFixed(2) }}
                  </span>
                  <span v-if="product.originalPrice" class="discount">
                    {{ Math.round((1 - product.price / product.originalPrice) * 100) }}% off
                  </span>
                </div>
              </div>
            </router-link>
            <button class="btn-add-cart" @click="addToCart(product)">Add to Cart</button>
          </div>
        </div>

        <!-- Empty State -->
        <div v-else class="empty-state">
          <span>🔍</span>
          <p>No products found. Try adjusting your filters.</p>
        </div>

      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import { useCartStore } from '../../stores/cart'
import { ElMessage } from 'element-plus'

const route = useRoute()
const cartStore = useCartStore()

const searchQuery = ref('')
const sortBy = ref('featured')
const filters = ref({
  category: route.query.category || null,
  priceRange: null,
  brand: null,
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
  { label: 'Over $100', min: 100, max: Infinity },
]

const brands = ['Blue Buffalo', 'Wellness', 'KONG', 'Purina', 'Hill\'s', 'Royal Canin']

const allProducts = ref([
  { id: 1, name: 'Adult Complete Dry Dog Food', brand: 'Blue Buffalo', category: 'dog', emoji: '🥩', price: 54.99, originalPrice: 64.99, reviews: 2341, badge: 'Sale' },
  { id: 2, name: 'Indoor Cat Grain-Free Food', brand: 'Wellness', category: 'cat', emoji: '🐱', price: 28.49, originalPrice: null, reviews: 1892, badge: null },
  { id: 3, name: 'Interactive Puzzle Toy', brand: 'KONG', category: 'dog', emoji: '🧩', price: 14.99, originalPrice: 19.99, reviews: 987, badge: 'Sale' },
  { id: 4, name: 'Orthopedic Memory Foam Bed', brand: 'Blue Buffalo', category: 'dog', emoji: '🛏️', price: 89.95, originalPrice: null, reviews: 654, badge: null },
  { id: 5, name: 'Premium Kitten Dry Food', brand: 'Royal Canin', category: 'cat', emoji: '🐟', price: 38.99, originalPrice: null, reviews: 1234, badge: 'New' },
  { id: 6, name: 'Tropical Fish Food Flakes', brand: 'Purina', category: 'fish', emoji: '🐠', price: 8.99, originalPrice: 12.99, reviews: 445, badge: 'Sale' },
  { id: 7, name: 'Dog Dental Chews', brand: 'Hill\'s', category: 'dog', emoji: '🦷', price: 22.49, originalPrice: null, reviews: 768, badge: null },
  { id: 8, name: 'Canary Seed Mix', brand: 'Purina', category: 'bird', emoji: '🌻', price: 16.99, originalPrice: null, reviews: 321, badge: null },
  { id: 9, name: 'Guinea Pig Habitat', brand: 'KONG', category: 'small-pet', emoji: '🏠', price: 79.99, originalPrice: 99.99, reviews: 203, badge: 'Sale' },
  { id: 10, name: 'Reptile Heat Lamp', brand: 'Wellness', category: 'reptile', emoji: '🔆', price: 34.99, originalPrice: null, reviews: 156, badge: 'New' },
  { id: 11, name: 'Cat Scratching Post Tower', brand: 'KONG', category: 'cat', emoji: '🗼', price: 49.99, originalPrice: 59.99, reviews: 892, badge: 'Sale' },
  { id: 12, name: 'Dog Harness No-Pull', brand: 'Blue Buffalo', category: 'dog', emoji: '🦺', price: 29.95, originalPrice: null, reviews: 1102, badge: null },
])

const filteredProducts = computed(() => {
  let result = allProducts.value

  // Search
  if (searchQuery.value) {
    const q = searchQuery.value.toLowerCase()
    result = result.filter(p =>
      p.name.toLowerCase().includes(q) || p.brand.toLowerCase().includes(q)
    )
  }

  // Category filter
  if (filters.value.category) {
    result = result.filter(p => p.category === filters.value.category)
  }

  // Brand filter
  if (filters.value.brand) {
    result = result.filter(p => p.brand === filters.value.brand)
  }

  // Price range filter
  if (filters.value.priceRange) {
    const range = priceRanges.find(r => r.label === filters.value.priceRange)
    if (range) {
      result = result.filter(p => p.price >= range.min && p.price < range.max)
    }
  }

  // Sort
  if (sortBy.value === 'price-asc') result = [...result].sort((a, b) => a.price - b.price)
  if (sortBy.value === 'price-desc') result = [...result].sort((a, b) => b.price - a.price)
  if (sortBy.value === 'rating') result = [...result].sort((a, b) => b.reviews - a.reviews)

  return result
})

function setFilter(key, value) {
  filters.value[key] = value
}

function addToCart(product) {
  cartStore.addItem(product)
  ElMessage({ message: `${product.name} added to cart!`, type: 'success', duration: 2000 })
}
</script>

<style scoped>
.product-list-page {
  background: var(--bg);
  min-height: 100vh;
}

.page-inner {
  max-width: 1280px;
  margin: 0 auto;
  padding: 32px 24px;
  display: grid;
  grid-template-columns: 240px 1fr;
  gap: 32px;
  align-items: start;
}

/* Sidebar */
.sidebar {
  background: white;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 24px;
  position: sticky;
  top: 80px;
}

.sidebar > h3 {
  font-size: 1rem;
  font-weight: 700;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 1px solid var(--border);
}

.filter-group {
  margin-bottom: 24px;
}

.filter-group h4 {
  font-size: 0.85rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--text-muted);
  margin-bottom: 10px;
}

.filter-list {
  list-style: none;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.filter-list li {
  padding: 7px 10px;
  border-radius: 6px;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.15s;
  color: var(--text-muted);
}

.filter-list li:hover {
  background: #f0f9ff;
  color: var(--primary);
}

.filter-list li.active {
  background: #e0f2fe;
  color: var(--primary);
  font-weight: 600;
}

/* Toolbar */
.toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 24px;
  gap: 16px;
  flex-wrap: wrap;
}

.result-count {
  font-weight: 600;
  font-size: 1rem;
}

.search-term {
  font-weight: 400;
  color: var(--text-muted);
}

.toolbar-right {
  display: flex;
  gap: 12px;
  align-items: center;
}

.search-input {
  padding: 8px 14px;
  border: 1px solid var(--border);
  border-radius: 6px;
  font-size: 0.9rem;
  outline: none;
  width: 220px;
  transition: border-color 0.2s;
}

.search-input:focus {
  border-color: var(--primary);
}

.sort-select {
  padding: 8px 12px;
  border: 1px solid var(--border);
  border-radius: 6px;
  font-size: 0.9rem;
  background: white;
  cursor: pointer;
  outline: none;
}

/* Product Grid */
.product-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.product-card {
  background: white;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  overflow: hidden;
  transition: box-shadow 0.2s, transform 0.2s;
  display: flex;
  flex-direction: column;
}

.product-card:hover {
  box-shadow: 0 8px 24px rgba(0,0,0,0.12);
  transform: translateY(-2px);
}

.product-card > a { flex: 1; }

.product-img {
  position: relative;
  background: #f0f9ff;
  height: 160px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.product-emoji { font-size: 3.5rem; }

.product-badge {
  position: absolute;
  top: 10px;
  left: 10px;
  background: var(--accent);
  color: white;
  font-size: 0.75rem;
  font-weight: 700;
  padding: 3px 8px;
  border-radius: 4px;
}

.product-info {
  padding: 14px;
}

.product-brand {
  font-size: 0.78rem;
  color: var(--text-muted);
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.product-name {
  font-size: 0.9rem;
  font-weight: 600;
  margin: 5px 0 7px;
  line-height: 1.4;
  color: var(--text);
}

.product-rating {
  display: flex;
  align-items: center;
  gap: 4px;
  margin-bottom: 8px;
}

.stars { color: #f59e0b; font-size: 0.82rem; }
.review-count { font-size: 0.78rem; color: var(--text-muted); }

.product-price {
  display: flex;
  align-items: center;
  gap: 6px;
  flex-wrap: wrap;
}

.price {
  font-size: 1rem;
  font-weight: 700;
  color: var(--primary);
}

.original-price {
  font-size: 0.82rem;
  color: var(--text-muted);
  text-decoration: line-through;
}

.discount {
  font-size: 0.78rem;
  background: #fef3c7;
  color: #92400e;
  padding: 2px 6px;
  border-radius: 4px;
  font-weight: 600;
}

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

.btn-add-cart:hover {
  background: var(--primary-hover);
}

/* Empty State */
.empty-state {
  text-align: center;
  padding: 80px 24px;
  color: var(--text-muted);
}

.empty-state span {
  font-size: 3rem;
  display: block;
  margin-bottom: 16px;
}

/* Responsive */
@media (max-width: 1024px) {
  .page-inner { grid-template-columns: 200px 1fr; }
  .product-grid { grid-template-columns: repeat(2, 1fr); }
}

@media (max-width: 768px) {
  .page-inner {
    grid-template-columns: 1fr;
    padding: 16px;
  }
  .sidebar {
    position: static;
    display: none; /* Simplified: hide sidebar on mobile */
  }
  .product-grid { grid-template-columns: repeat(2, 1fr); gap: 12px; }
  .toolbar { flex-direction: column; align-items: flex-start; }
  .search-input { width: 100%; }
}

@media (max-width: 480px) {
  .product-grid { grid-template-columns: 1fr; }
}
</style>
