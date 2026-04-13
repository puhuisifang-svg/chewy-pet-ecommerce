<template>
  <div class="home-page">

    <!-- Hero Banner -->
    <section class="hero">
      <div class="hero-content">
        <h1>Everything Your Pet Needs</h1>
        <p>Premium food, toys, accessories and more — delivered to your door.</p>
        <div class="hero-actions">
          <router-link to="/products" class="btn btn-primary">Shop Now</router-link>
          <router-link to="/products?category=deals" class="btn btn-outline">Today's Deals</router-link>
        </div>
      </div>
      <div class="hero-image">🐶🐱🐾</div>
    </section>

    <!-- Category Quick Links -->
    <section class="categories">
      <div class="section-inner">
        <h2>Shop by Pet</h2>
        <div class="category-grid">
          <router-link
            v-for="cat in categories"
            :key="cat.slug"
            :to="`/products?category=${cat.slug}`"
            class="category-card"
          >
            <span class="cat-emoji">{{ cat.emoji }}</span>
            <span class="cat-name">{{ cat.name }}</span>
          </router-link>
        </div>
      </div>
    </section>

    <!-- Featured Products -->
    <section class="featured">
      <div class="section-inner">
        <div class="section-header">
          <h2>Featured Products</h2>
          <router-link to="/products" class="view-all">View All →</router-link>
        </div>
        <div class="product-grid">
          <div
            v-for="product in featuredProducts"
            :key="product.id"
            class="product-card"
          >
            <router-link :to="`/product/${product.id}`">
              <div class="product-img">{{ product.emoji }}</div>
              <div class="product-info">
                <span class="product-brand">{{ product.brand }}</span>
                <h3 class="product-name">{{ product.name }}</h3>
                <div class="product-rating">
                  <span class="stars">★★★★★</span>
                  <span class="review-count">({{ product.reviews }})</span>
                </div>
                <div class="product-price">
                  <span class="price">${{ product.price.toFixed(2) }}</span>
                  <span v-if="product.originalPrice" class="original-price">
                    ${{ product.originalPrice.toFixed(2) }}
                  </span>
                </div>
              </div>
            </router-link>
            <button class="btn-add-cart" @click="addToCart(product)">
              Add to Cart
            </button>
          </div>
        </div>
      </div>
    </section>

    <!-- Promo Banner -->
    <section class="promo-banner">
      <div class="promo-inner">
        <div class="promo-item">
          <span>🚚</span>
          <div>
            <strong>Free Shipping</strong>
            <p>On orders over $49</p>
          </div>
        </div>
        <div class="promo-item">
          <span>🔄</span>
          <div>
            <strong>AutoShip & Save</strong>
            <p>Up to 30% off repeat orders</p>
          </div>
        </div>
        <div class="promo-item">
          <span>💬</span>
          <div>
            <strong>24/7 Support</strong>
            <p>Vet experts available anytime</p>
          </div>
        </div>
        <div class="promo-item">
          <span>↩️</span>
          <div>
            <strong>Easy Returns</strong>
            <p>365-day return policy</p>
          </div>
        </div>
      </div>
    </section>

  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useCartStore } from '../../stores/cart'
import { ElMessage } from 'element-plus'

const cartStore = useCartStore()

const categories = ref([
  { slug: 'dog', name: 'Dogs', emoji: '🐶' },
  { slug: 'cat', name: 'Cats', emoji: '🐱' },
  { slug: 'fish', name: 'Fish', emoji: '🐟' },
  { slug: 'bird', name: 'Birds', emoji: '🐦' },
  { slug: 'small-pet', name: 'Small Pets', emoji: '🐹' },
  { slug: 'reptile', name: 'Reptiles', emoji: '🦎' },
])

const featuredProducts = ref([
  {
    id: 1,
    name: 'Adult Complete Dry Dog Food',
    brand: 'Blue Buffalo',
    emoji: '🥩',
    price: 54.99,
    originalPrice: 64.99,
    reviews: 2341,
  },
  {
    id: 2,
    name: 'Indoor Cat Grain-Free Food',
    brand: 'Wellness',
    emoji: '🐱',
    price: 28.49,
    originalPrice: null,
    reviews: 1892,
  },
  {
    id: 3,
    name: 'Interactive Puzzle Toy',
    brand: 'KONG',
    emoji: '🧩',
    price: 14.99,
    originalPrice: 19.99,
    reviews: 987,
  },
  {
    id: 4,
    name: 'Orthopedic Memory Foam Bed',
    brand: 'Big Barker',
    emoji: '🛏️',
    price: 89.95,
    originalPrice: null,
    reviews: 654,
  },
])

function addToCart(product) {
  cartStore.addItem(product)
  ElMessage({ message: `${product.name} added to cart!`, type: 'success', duration: 2000 })
}
</script>

<style scoped>
/* Hero */
.hero {
  background: linear-gradient(135deg, #0077cc 0%, #00b4d8 100%);
  color: white;
  padding: 80px 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 60px;
  text-align: left;
}

.hero-content {
  max-width: 560px;
}

.hero-content h1 {
  font-size: 2.8rem;
  font-weight: 800;
  line-height: 1.2;
  margin-bottom: 16px;
}

.hero-content p {
  font-size: 1.1rem;
  opacity: 0.9;
  margin-bottom: 32px;
}

.hero-actions {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
}

.hero-image {
  font-size: 6rem;
  filter: drop-shadow(0 8px 16px rgba(0,0,0,0.2));
}

/* Buttons */
.btn {
  display: inline-block;
  padding: 12px 28px;
  border-radius: 6px;
  font-weight: 600;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.2s;
  border: 2px solid transparent;
}

.btn-primary {
  background: white;
  color: var(--primary);
}

.btn-primary:hover {
  background: #f0f9ff;
}

.btn-outline {
  border-color: rgba(255,255,255,0.7);
  color: white;
}

.btn-outline:hover {
  background: rgba(255,255,255,0.1);
}

/* Sections */
.section-inner {
  max-width: 1280px;
  margin: 0 auto;
  padding: 60px 24px;
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 32px;
}

.section-inner > h2,
.section-header h2 {
  font-size: 1.8rem;
  font-weight: 700;
  margin-bottom: 32px;
}

.section-header h2 {
  margin-bottom: 0;
}

.view-all {
  color: var(--primary);
  font-weight: 600;
  font-size: 0.95rem;
}

.view-all:hover {
  text-decoration: underline;
}

/* Category Grid */
.categories {
  background: white;
  border-bottom: 1px solid var(--border);
}

.category-grid {
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  gap: 16px;
}

.category-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 20px 12px;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  transition: all 0.2s;
  cursor: pointer;
}

.category-card:hover {
  border-color: var(--primary);
  box-shadow: 0 4px 12px rgba(0,119,204,0.15);
  transform: translateY(-2px);
}

.cat-emoji {
  font-size: 2.4rem;
}

.cat-name {
  font-weight: 600;
  font-size: 0.9rem;
  color: var(--text);
}

/* Product Grid */
.featured {
  background: var(--bg);
}

.product-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 24px;
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

.product-card > a {
  flex: 1;
}

.product-img {
  background: #f0f9ff;
  font-size: 4rem;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 180px;
}

.product-info {
  padding: 16px;
}

.product-brand {
  font-size: 0.8rem;
  color: var(--text-muted);
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.product-name {
  font-size: 0.95rem;
  font-weight: 600;
  margin: 6px 0 8px;
  line-height: 1.4;
  color: var(--text);
}

.product-rating {
  display: flex;
  align-items: center;
  gap: 6px;
  margin-bottom: 10px;
}

.stars {
  color: #f59e0b;
  font-size: 0.85rem;
}

.review-count {
  font-size: 0.8rem;
  color: var(--text-muted);
}

.product-price {
  display: flex;
  align-items: center;
  gap: 8px;
}

.price {
  font-size: 1.1rem;
  font-weight: 700;
  color: var(--primary);
}

.original-price {
  font-size: 0.85rem;
  color: var(--text-muted);
  text-decoration: line-through;
}

.btn-add-cart {
  width: 100%;
  padding: 12px;
  background: var(--primary);
  color: white;
  border: none;
  font-weight: 600;
  font-size: 0.9rem;
  cursor: pointer;
  transition: background 0.2s;
}

.btn-add-cart:hover {
  background: var(--primary-hover);
}

/* Promo Banner */
.promo-banner {
  background: white;
  border-top: 1px solid var(--border);
  border-bottom: 1px solid var(--border);
}

.promo-inner {
  max-width: 1280px;
  margin: 0 auto;
  padding: 32px 24px;
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 24px;
}

.promo-item {
  display: flex;
  align-items: center;
  gap: 16px;
}

.promo-item > span {
  font-size: 2rem;
  flex-shrink: 0;
}

.promo-item strong {
  display: block;
  font-weight: 700;
  font-size: 0.95rem;
  margin-bottom: 2px;
}

.promo-item p {
  font-size: 0.85rem;
  color: var(--text-muted);
}

/* Responsive */
@media (max-width: 1024px) {
  .product-grid { grid-template-columns: repeat(2, 1fr); }
  .category-grid { grid-template-columns: repeat(3, 1fr); }
  .promo-inner { grid-template-columns: repeat(2, 1fr); }
}

@media (max-width: 768px) {
  .hero {
    flex-direction: column;
    text-align: center;
    padding: 48px 24px;
    gap: 32px;
  }
  .hero-content h1 { font-size: 2rem; }
  .hero-actions { justify-content: center; }
  .hero-image { font-size: 4rem; }
  .product-grid { grid-template-columns: repeat(2, 1fr); gap: 12px; }
  .category-grid { grid-template-columns: repeat(3, 1fr); }
  .promo-inner { grid-template-columns: 1fr 1fr; }
}

@media (max-width: 480px) {
  .product-grid { grid-template-columns: 1fr; }
  .category-grid { grid-template-columns: repeat(2, 1fr); }
  .promo-inner { grid-template-columns: 1fr; }
}
</style>
