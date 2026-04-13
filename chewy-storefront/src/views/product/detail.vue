<template>
  <div class="product-detail-page">
    <div class="page-inner">

      <!-- Breadcrumb -->
      <nav class="breadcrumb">
        <router-link to="/">Home</router-link>
        <span>›</span>
        <router-link to="/products">Products</router-link>
        <span>›</span>
        <span class="current">{{ product.name }}</span>
      </nav>

      <!-- Main Detail Block -->
      <div class="detail-grid">

        <!-- Left: Image Gallery -->
        <div class="image-section">
          <div class="main-image">
            <span class="main-emoji">{{ activeImage }}</span>
            <span v-if="product.badge" class="product-badge">{{ product.badge }}</span>
          </div>
          <div class="thumbnail-row">
            <div
              v-for="(img, i) in product.images"
              :key="i"
              class="thumbnail"
              :class="{ active: activeImage === img }"
              @click="activeImage = img"
            >{{ img }}</div>
          </div>
        </div>

        <!-- Right: Info -->
        <div class="info-section">
          <span class="brand">{{ product.brand }}</span>
          <h1 class="product-title">{{ product.name }}</h1>

          <!-- Rating -->
          <div class="rating-row">
            <span class="stars">★★★★★</span>
            <span class="review-count">{{ product.reviews.toLocaleString() }} reviews</span>
            <span class="in-stock" v-if="product.inStock">✓ In Stock</span>
            <span class="out-stock" v-else>✗ Out of Stock</span>
          </div>

          <!-- Price -->
          <div class="price-block">
            <span class="price">${{ product.price.toFixed(2) }}</span>
            <span v-if="product.originalPrice" class="original-price">
              ${{ product.originalPrice.toFixed(2) }}
            </span>
            <span v-if="product.originalPrice" class="discount-tag">
              {{ Math.round((1 - product.price / product.originalPrice) * 100) }}% OFF
            </span>
          </div>
          <p class="price-note">☑️ Free shipping on orders over $49</p>

          <!-- AutoShip -->
          <div class="autoship-box">
            <input type="checkbox" id="autoship" v-model="autoship" />
            <label for="autoship">
              <strong>Subscribe &amp; Save 10%</strong> — AutoShip every
              <select v-model="autoshipFreq" class="freq-select">
                <option>2 weeks</option>
                <option>4 weeks</option>
                <option>6 weeks</option>
                <option>8 weeks</option>
              </select>
            </label>
          </div>

          <!-- Size / Variant -->
          <div class="option-group" v-if="product.sizes?.length">
            <label class="option-label">Size</label>
            <div class="option-pills">
              <button
                v-for="size in product.sizes"
                :key="size"
                class="pill"
                :class="{ active: selectedSize === size }"
                @click="selectedSize = size"
              >{{ size }}</button>
            </div>
          </div>

          <!-- Quantity + Add to Cart -->
          <div class="purchase-row">
            <div class="qty-control">
              <button @click="decreaseQty" :disabled="qty <= 1">−</button>
              <span class="qty-value">{{ qty }}</span>
              <button @click="qty++">+</button>
            </div>
            <button
              class="btn-add-cart"
              :disabled="!product.inStock"
              @click="handleAddToCart"
            >
              🛒 Add to Cart
            </button>
          </div>

          <button class="btn-buy-now" :disabled="!product.inStock" @click="handleBuyNow">
            Buy Now
          </button>

          <!-- Description -->
          <div class="description">
            <h3>About This Product</h3>
            <p>{{ product.description }}</p>
            <ul class="feature-list">
              <li v-for="feat in product.features" :key="feat">✓ {{ feat }}</li>
            </ul>
          </div>
        </div>
      </div>

      <!-- You May Also Like -->
      <section class="related-section">
        <h2>You May Also Like</h2>
        <div class="related-grid">
          <div
            v-for="rel in relatedProducts"
            :key="rel.id"
            class="related-card"
          >
            <router-link :to="`/product/${rel.id}`">
              <div class="rel-img">{{ rel.emoji }}</div>
              <div class="rel-info">
                <p class="rel-name">{{ rel.name }}</p>
                <p class="rel-price">${{ rel.price.toFixed(2) }}</p>
              </div>
            </router-link>
          </div>
        </div>
      </section>

    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useCartStore } from '../../stores/cart'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()
const cartStore = useCartStore()

const qty = ref(1)
const autoship = ref(false)
const autoshipFreq = ref('4 weeks')
const selectedSize = ref(null)

// Mock product data (will be replaced by API)
const allProducts = {
  1: {
    id: 1,
    name: 'Adult Complete Dry Dog Food',
    brand: 'Blue Buffalo',
    images: ['🥩', '📦', '🐶'],
    emoji: '🥩',
    price: 54.99,
    originalPrice: 64.99,
    reviews: 2341,
    badge: 'Sale',
    inStock: true,
    sizes: ['5 lbs', '15 lbs', '30 lbs'],
    description: 'Blue Buffalo Life Protection Formula adult dog food features real meat as the first ingredient. Made with high-quality protein to help build and maintain lean muscle mass.',
    features: [
      'Real chicken as #1 ingredient',
      'No chicken by-product meals, corn, wheat, or soy',
      'Enhanced with LifeSource Bits – a precise blend of antioxidants, vitamins & minerals',
      'Supports immune system health, life stage needs, and healthy oxidative balance',
    ],
  },
  2: {
    id: 2,
    name: 'Indoor Cat Grain-Free Food',
    brand: 'Wellness',
    images: ['🐱', '📦', '🐟'],
    emoji: '🐱',
    price: 28.49,
    originalPrice: null,
    reviews: 1892,
    badge: null,
    inStock: true,
    sizes: ['5 lbs', '11 lbs'],
    description: 'Wellness CORE grain-free indoor dry cat food is protein-focused, high-quality nutrition designed specifically for indoor cats to support a healthy weight.',
    features: [
      'High protein, grain-free formula',
      'Deboned turkey and chicken as first ingredients',
      'Supports healthy weight management',
      'Added taurine for heart health',
    ],
  },
  3: {
    id: 3,
    name: 'Interactive Puzzle Toy',
    brand: 'KONG',
    images: ['🧩', '🐕', '🎮'],
    emoji: '🧩',
    price: 14.99,
    originalPrice: 19.99,
    reviews: 987,
    badge: 'Sale',
    inStock: true,
    sizes: null,
    description: 'The KONG Wobbler interactive toy provides mental stimulation and slows down fast eaters. Fill with treats or kibble for hours of entertainment.',
    features: [
      'Unpredictable wobble action keeps dogs engaged',
      'Fill with treats, kibble, or peanut butter',
      'Durable, dishwasher-safe material',
      'Recommended by veterinarians',
    ],
  },
}

// Fallback product for unknown IDs
const defaultProduct = {
  id: 99,
  name: 'Premium Pet Product',
  brand: 'PawShop',
  images: ['🐾', '📦', '⭐'],
  emoji: '🐾',
  price: 29.99,
  originalPrice: null,
  reviews: 100,
  badge: null,
  inStock: true,
  sizes: ['S', 'M', 'L'],
  description: 'A high-quality pet product designed with your pet\'s well-being in mind.',
  features: ['Premium quality', 'Vet recommended', 'Made in USA'],
}

const product = computed(() => allProducts[route.params.id] || defaultProduct)
const activeImage = ref(product.value.images[0])

if (product.value.sizes?.length) {
  selectedSize.value = product.value.sizes[0]
}

const relatedProducts = [
  { id: 1, name: 'Adult Dry Dog Food', emoji: '🥩', price: 54.99 },
  { id: 2, name: 'Indoor Cat Food', emoji: '🐱', price: 28.49 },
  { id: 3, name: 'Puzzle Toy', emoji: '🧩', price: 14.99 },
  { id: 4, name: 'Orthopedic Dog Bed', emoji: '🛏️', price: 89.95 },
].filter(p => p.id !== Number(route.params.id)).slice(0, 4)

function decreaseQty() {
  if (qty.value > 1) qty.value--
}

function handleAddToCart() {
  const item = {
    ...product.value,
    selectedSize: selectedSize.value,
    autoship: autoship.value,
  }
  for (let i = 0; i < qty.value; i++) {
    cartStore.addItem(item)
  }
  ElMessage({ message: `${product.value.name} added to cart!`, type: 'success', duration: 2000 })
}

function handleBuyNow() {
  handleAddToCart()
  router.push('/checkout')
}
</script>

<style scoped>
.product-detail-page {
  background: var(--bg);
  min-height: 100vh;
}

.page-inner {
  max-width: 1280px;
  margin: 0 auto;
  padding: 24px 24px 60px;
}

/* Breadcrumb */
.breadcrumb {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 0.85rem;
  color: var(--text-muted);
  margin-bottom: 28px;
}

.breadcrumb a {
  color: var(--primary);
}

.breadcrumb a:hover { text-decoration: underline; }

.current {
  color: var(--text);
  font-weight: 500;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 260px;
}

/* Detail Grid */
.detail-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 48px;
  background: white;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 40px;
  margin-bottom: 48px;
}

/* Image Section */
.image-section {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.main-image {
  position: relative;
  background: #f0f9ff;
  border-radius: var(--radius);
  height: 380px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid var(--border);
}

.main-emoji {
  font-size: 9rem;
  filter: drop-shadow(0 4px 12px rgba(0,0,0,0.1));
}

.product-badge {
  position: absolute;
  top: 16px;
  left: 16px;
  background: var(--accent);
  color: white;
  font-size: 0.8rem;
  font-weight: 700;
  padding: 4px 10px;
  border-radius: 4px;
}

.thumbnail-row {
  display: flex;
  gap: 10px;
}

.thumbnail {
  width: 72px;
  height: 72px;
  border: 2px solid var(--border);
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.8rem;
  cursor: pointer;
  transition: border-color 0.2s;
  background: #f8f9fa;
}

.thumbnail.active,
.thumbnail:hover {
  border-color: var(--primary);
}

/* Info Section */
.info-section {
  display: flex;
  flex-direction: column;
  gap: 0;
}

.brand {
  font-size: 0.82rem;
  color: var(--text-muted);
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.06em;
}

.product-title {
  font-size: 1.6rem;
  font-weight: 700;
  line-height: 1.3;
  margin: 8px 0 14px;
}

/* Rating */
.rating-row {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 18px;
  flex-wrap: wrap;
}

.stars { color: #f59e0b; font-size: 1rem; }
.review-count { font-size: 0.88rem; color: var(--primary); }
.in-stock { font-size: 0.85rem; color: #16a34a; font-weight: 600; }
.out-stock { font-size: 0.85rem; color: #dc2626; font-weight: 600; }

/* Price */
.price-block {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 6px;
}

.price {
  font-size: 2rem;
  font-weight: 800;
  color: var(--primary);
}

.original-price {
  font-size: 1rem;
  color: var(--text-muted);
  text-decoration: line-through;
}

.discount-tag {
  background: #fef3c7;
  color: #92400e;
  font-size: 0.82rem;
  font-weight: 700;
  padding: 3px 8px;
  border-radius: 4px;
}

.price-note {
  font-size: 0.85rem;
  color: #16a34a;
  margin-bottom: 20px;
}

/* AutoShip */
.autoship-box {
  display: flex;
  align-items: center;
  gap: 10px;
  background: #f0fdf4;
  border: 1px solid #bbf7d0;
  border-radius: var(--radius);
  padding: 14px 16px;
  margin-bottom: 20px;
  font-size: 0.9rem;
}

.autoship-box input[type="checkbox"] {
  width: 16px;
  height: 16px;
  cursor: pointer;
  flex-shrink: 0;
}

.freq-select {
  border: 1px solid var(--border);
  border-radius: 4px;
  padding: 2px 6px;
  font-size: 0.88rem;
  margin-left: 6px;
}

/* Options */
.option-group {
  margin-bottom: 20px;
}

.option-label {
  display: block;
  font-size: 0.85rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--text-muted);
  margin-bottom: 8px;
}

.option-pills {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.pill {
  padding: 7px 16px;
  border: 1px solid var(--border);
  border-radius: 20px;
  font-size: 0.88rem;
  font-weight: 500;
  cursor: pointer;
  background: white;
  transition: all 0.15s;
  color: var(--text);
}

.pill:hover { border-color: var(--primary); color: var(--primary); }
.pill.active {
  background: var(--primary);
  border-color: var(--primary);
  color: white;
}

/* Purchase Row */
.purchase-row {
  display: flex;
  gap: 12px;
  align-items: center;
  margin-bottom: 12px;
}

.qty-control {
  display: flex;
  align-items: center;
  border: 1px solid var(--border);
  border-radius: 6px;
  overflow: hidden;
}

.qty-control button {
  width: 38px;
  height: 46px;
  border: none;
  background: #f8f9fa;
  font-size: 1.2rem;
  cursor: pointer;
  transition: background 0.15s;
}

.qty-control button:hover:not(:disabled) { background: #e5e7eb; }
.qty-control button:disabled { opacity: 0.4; cursor: not-allowed; }

.qty-value {
  width: 46px;
  text-align: center;
  font-weight: 700;
  font-size: 1rem;
  border-left: 1px solid var(--border);
  border-right: 1px solid var(--border);
  line-height: 46px;
}

.btn-add-cart {
  flex: 1;
  height: 46px;
  background: var(--primary);
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  transition: background 0.2s;
}

.btn-add-cart:hover:not(:disabled) { background: var(--primary-hover); }
.btn-add-cart:disabled { opacity: 0.5; cursor: not-allowed; }

.btn-buy-now {
  width: 100%;
  height: 46px;
  background: var(--accent);
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  margin-bottom: 24px;
  transition: opacity 0.2s;
}

.btn-buy-now:hover:not(:disabled) { opacity: 0.9; }
.btn-buy-now:disabled { opacity: 0.5; cursor: not-allowed; }

/* Description */
.description h3 {
  font-size: 1rem;
  font-weight: 700;
  margin-bottom: 10px;
  padding-top: 20px;
  border-top: 1px solid var(--border);
}

.description p {
  font-size: 0.92rem;
  color: var(--text-muted);
  line-height: 1.7;
  margin-bottom: 14px;
}

.feature-list {
  list-style: none;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.feature-list li {
  font-size: 0.9rem;
  color: var(--text);
  padding-left: 2px;
}

/* Related */
.related-section h2 {
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 20px;
}

.related-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
}

.related-card {
  background: white;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  overflow: hidden;
  transition: box-shadow 0.2s, transform 0.2s;
}

.related-card:hover {
  box-shadow: 0 6px 18px rgba(0,0,0,0.1);
  transform: translateY(-2px);
}

.rel-img {
  background: #f0f9ff;
  font-size: 3rem;
  height: 120px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.rel-info {
  padding: 12px;
}

.rel-name {
  font-size: 0.88rem;
  font-weight: 600;
  margin-bottom: 4px;
  line-height: 1.3;
}

.rel-price {
  font-size: 0.95rem;
  font-weight: 700;
  color: var(--primary);
}

/* Responsive */
@media (max-width: 1024px) {
  .detail-grid { gap: 32px; padding: 28px; }
  .related-grid { grid-template-columns: repeat(2, 1fr); }
}

@media (max-width: 768px) {
  .detail-grid {
    grid-template-columns: 1fr;
    padding: 20px;
    gap: 24px;
  }
  .main-image { height: 260px; }
  .main-emoji { font-size: 6rem; }
  .product-title { font-size: 1.3rem; }
  .price { font-size: 1.6rem; }
  .related-grid { grid-template-columns: repeat(2, 1fr); }
}
</style>
