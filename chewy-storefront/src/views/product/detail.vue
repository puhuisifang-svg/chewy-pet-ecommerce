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

      <!-- Loading -->
      <div v-if="loading" class="loading-state">
        <div class="skeleton-detail">
          <div class="sk-img"></div>
          <div class="sk-info">
            <div class="sk-line w60"></div>
            <div class="sk-line w80"></div>
            <div class="sk-line w40"></div>
          </div>
        </div>
      </div>

      <!-- Main Detail -->
      <div v-else class="detail-grid">

        <!-- Left: Image -->
        <div class="image-section">
          <div class="main-image">
            <img
              v-if="activeImage"
              :src="activeImage"
              :alt="product.name"
              @error="e => e.target.style.display='none'"
            />
            <span v-else class="fallback-emoji">🐾</span>
            <span v-if="selectedSku && selectedSku.salePrice < selectedSku.price" class="product-badge">Sale</span>
          </div>
          <div v-if="images.length > 1" class="thumbnail-row">
            <div
              v-for="(img, i) in images"
              :key="i"
              class="thumbnail"
              :class="{ active: activeImage === img }"
              @click="activeImage = img"
            >
              <img :src="img" :alt="`view ${i+1}`" @error="e => e.target.parentElement.style.display='none'" />
            </div>
          </div>
        </div>

        <!-- Right: Info -->
        <div class="info-section">
          <span class="brand">{{ product.brand }}</span>
          <h1 class="product-title">{{ product.name }}</h1>

          <div class="price-block">
            <span class="price">${{ displayPrice }}</span>
            <span v-if="selectedSku && selectedSku.salePrice < selectedSku.price" class="original-price">
              ${{ Number(selectedSku.price).toFixed(2) }}
            </span>
            <span v-if="selectedSku && selectedSku.salePrice < selectedSku.price" class="discount-tag">
              {{ Math.round((1 - selectedSku.salePrice / selectedSku.price) * 100) }}% OFF
            </span>
          </div>

          <div class="stock-row">
            <span v-if="selectedSku && selectedSku.stock > 0" class="in-stock">
              ✓ In Stock ({{ selectedSku.stock }} available)
            </span>
            <span v-else-if="selectedSku" class="out-stock">✗ Out of Stock</span>
          </div>

          <p class="free-ship-note">☑️ Free shipping on orders over $49</p>

          <!-- SKU Selector -->
          <div v-if="skus.length > 1" class="option-group">
            <label class="option-label">Option</label>
            <div class="option-pills">
              <button
                v-for="sku in skus"
                :key="sku.id"
                class="pill"
                :class="{ active: selectedSku?.id === sku.id, disabled: sku.stock === 0 }"
                @click="selectSku(sku)"
              >{{ sku.specName }}</button>
            </div>
          </div>

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

          <!-- Qty + CTA -->
          <div class="purchase-row">
            <div class="qty-control">
              <button @click="qty > 1 && qty--">−</button>
              <span class="qty-value">{{ qty }}</span>
              <button @click="qty++">+</button>
            </div>
            <button
              class="btn-add-cart"
              :disabled="!selectedSku || selectedSku.stock === 0"
              @click="handleAddToCart"
            >
              🛒 Add to Cart
            </button>
          </div>

          <button
            class="btn-buy-now"
            :disabled="!selectedSku || selectedSku.stock === 0"
            @click="handleBuyNow"
          >Buy Now</button>

          <!-- Description -->
          <div class="description">
            <h3>About This Product</h3>
            <p>{{ product.description }}</p>
            <div v-if="product.tags" class="tag-list">
              <span v-for="tag in parsedTags" :key="tag" class="tag">{{ tag }}</span>
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useCartStore } from '../../stores/cart'
import { productApi, cartApi } from '../../api/index'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()
const cartStore = useCartStore()

const loading = ref(true)
const product = ref({})
const skus = ref([])
const selectedSku = ref(null)
const activeImage = ref(null)
const qty = ref(1)
const autoship = ref(false)
const autoshipFreq = ref('4 weeks')

const images = computed(() => {
  try {
    const raw = selectedSku.value?.image || product.value.images
    const parsed = JSON.parse(raw)
    return Array.isArray(parsed) ? parsed : [parsed]
  } catch {
    return product.value.images ? [product.value.images] : []
  }
})

const displayPrice = computed(() => {
  if (!selectedSku.value) return '—'
  const p = selectedSku.value.salePrice < selectedSku.value.price
    ? selectedSku.value.salePrice
    : selectedSku.value.price
  return Number(p).toFixed(2)
})

const parsedTags = computed(() => {
  try {
    return JSON.parse(product.value.tags || '[]')
  } catch { return [] }
})

function selectSku(sku) {
  selectedSku.value = sku
  // Update image if sku has its own image
  const imgs = images.value
  if (imgs.length) activeImage.value = imgs[0]
}

async function handleAddToCart() {
  if (!selectedSku.value) return
  try {
    // Try real API first (requires auth)
    await cartApi.addItem(selectedSku.value.id, qty.value)
  } catch {
    // Fallback: local store
  }
  // Always update local store for UI
  cartStore.addItem({
    id: selectedSku.value.id,
    productId: product.value.id,
    name: product.value.name,
    brand: product.value.brand,
    price: selectedSku.value.salePrice || selectedSku.value.price,
    skuId: selectedSku.value.id,
    specName: selectedSku.value.specName,
    image: activeImage.value,
    emoji: '🐾',
  })
  for (let i = 1; i < qty.value; i++) {
    cartStore.items[cartStore.items.length - 1].qty++
  }
  ElMessage({ message: 'Added to cart!', type: 'success', duration: 2000 })
}

async function handleBuyNow() {
  await handleAddToCart()
  router.push('/checkout/shipping')
}

onMounted(async () => {
  try {
    const res = await productApi.getById(route.params.id)
    const data = res?.data || res
    product.value = data?.product || data
    skus.value = data?.skus || []
    if (skus.value.length) {
      selectedSku.value = skus.value[0]
      activeImage.value = images.value[0] || null
    }
  } catch (err) {
    ElMessage({ message: 'Failed to load product.', type: 'error' })
  } finally {
    loading.value = false
  }
})

watch(selectedSku, () => {
  const imgs = images.value
  if (imgs.length) activeImage.value = imgs[0]
})
</script>

<style scoped>
.product-detail-page { background: var(--bg); min-height: 100vh; }
.page-inner { max-width: 1280px; margin: 0 auto; padding: 24px 24px 60px; }

.breadcrumb {
  display: flex; align-items: center; gap: 8px;
  font-size: 0.85rem; color: var(--text-muted); margin-bottom: 28px;
}
.breadcrumb a { color: var(--primary); }
.breadcrumb a:hover { text-decoration: underline; }
.current { color: var(--text); font-weight: 500; max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

/* Skeleton */
.loading-state { padding: 20px 0; }
.skeleton-detail { display: grid; grid-template-columns: 1fr 1fr; gap: 48px; background: white; border-radius: var(--radius); padding: 40px; }
.sk-img { height: 380px; background: #e5e7eb; border-radius: 8px; animation: pulse 1.5s infinite; }
.sk-info { display: flex; flex-direction: column; gap: 16px; padding-top: 20px; }
.sk-line { height: 16px; background: #e5e7eb; border-radius: 4px; animation: pulse 1.5s infinite; }
.sk-line.w60 { width: 60%; } .sk-line.w80 { width: 80%; } .sk-line.w40 { width: 40%; }
@keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.5} }

/* Grid */
.detail-grid {
  display: grid; grid-template-columns: 1fr 1fr; gap: 48px;
  background: white; border: 1px solid var(--border); border-radius: var(--radius); padding: 40px;
}

/* Image */
.image-section { display: flex; flex-direction: column; gap: 12px; }
.main-image {
  position: relative; background: #f8f9fa; border-radius: var(--radius);
  height: 380px; display: flex; align-items: center; justify-content: center;
  border: 1px solid var(--border); overflow: hidden;
}
.main-image img { width: 100%; height: 100%; object-fit: contain; padding: 20px; }
.fallback-emoji { font-size: 8rem; }
.product-badge {
  position: absolute; top: 14px; left: 14px;
  background: var(--accent); color: white; font-size: 0.78rem; font-weight: 700;
  padding: 3px 9px; border-radius: 4px;
}
.thumbnail-row { display: flex; gap: 8px; flex-wrap: wrap; }
.thumbnail { width: 68px; height: 68px; border: 2px solid var(--border); border-radius: 6px; overflow: hidden; cursor: pointer; background: #f8f9fa; }
.thumbnail.active { border-color: var(--primary); }
.thumbnail img { width: 100%; height: 100%; object-fit: contain; padding: 4px; }

/* Info */
.info-section { display: flex; flex-direction: column; }
.brand { font-size: 0.8rem; color: var(--text-muted); font-weight: 600; text-transform: uppercase; letter-spacing: 0.06em; }
.product-title { font-size: 1.5rem; font-weight: 700; line-height: 1.3; margin: 8px 0 16px; }

.price-block { display: flex; align-items: center; gap: 10px; margin-bottom: 8px; }
.price { font-size: 2rem; font-weight: 800; color: var(--primary); }
.original-price { font-size: 1rem; color: var(--text-muted); text-decoration: line-through; }
.discount-tag { background: #fef3c7; color: #92400e; font-size: 0.8rem; font-weight: 700; padding: 3px 8px; border-radius: 4px; }

.stock-row { margin-bottom: 4px; font-size: 0.85rem; }
.in-stock { color: #16a34a; font-weight: 600; }
.out-stock { color: #dc2626; font-weight: 600; }
.free-ship-note { font-size: 0.85rem; color: #16a34a; margin-bottom: 20px; }

/* SKU */
.option-group { margin-bottom: 18px; }
.option-label { display: block; font-size: 0.82rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text-muted); margin-bottom: 8px; }
.option-pills { display: flex; gap: 8px; flex-wrap: wrap; }
.pill { padding: 7px 16px; border: 1px solid var(--border); border-radius: 20px; font-size: 0.88rem; font-weight: 500; cursor: pointer; background: white; transition: all 0.15s; }
.pill:hover:not(.disabled) { border-color: var(--primary); color: var(--primary); }
.pill.active { background: var(--primary); border-color: var(--primary); color: white; }
.pill.disabled { opacity: 0.4; cursor: not-allowed; text-decoration: line-through; }

/* AutoShip */
.autoship-box { display: flex; align-items: center; gap: 10px; background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: var(--radius); padding: 12px 16px; margin-bottom: 20px; font-size: 0.88rem; }
.autoship-box input[type="checkbox"] { width: 16px; height: 16px; cursor: pointer; flex-shrink: 0; }
.freq-select { border: 1px solid var(--border); border-radius: 4px; padding: 2px 6px; font-size: 0.85rem; margin-left: 4px; }

/* Purchase */
.purchase-row { display: flex; gap: 12px; margin-bottom: 12px; }
.qty-control { display: flex; align-items: center; border: 1px solid var(--border); border-radius: 6px; overflow: hidden; }
.qty-control button { width: 38px; height: 46px; border: none; background: #f8f9fa; font-size: 1.2rem; cursor: pointer; }
.qty-control button:hover { background: #e5e7eb; }
.qty-value { width: 44px; text-align: center; font-weight: 700; border-left: 1px solid var(--border); border-right: 1px solid var(--border); line-height: 46px; }
.btn-add-cart { flex: 1; height: 46px; background: var(--primary); color: white; border: none; border-radius: 6px; font-size: 1rem; font-weight: 700; cursor: pointer; transition: background 0.2s; }
.btn-add-cart:hover:not(:disabled) { background: var(--primary-hover); }
.btn-add-cart:disabled { opacity: 0.5; cursor: not-allowed; }
.btn-buy-now { width: 100%; height: 46px; background: var(--accent); color: white; border: none; border-radius: 6px; font-size: 1rem; font-weight: 700; cursor: pointer; margin-bottom: 24px; }
.btn-buy-now:hover:not(:disabled) { opacity: 0.9; }
.btn-buy-now:disabled { opacity: 0.5; cursor: not-allowed; }

/* Description */
.description { border-top: 1px solid var(--border); padding-top: 20px; }
.description h3 { font-size: 1rem; font-weight: 700; margin-bottom: 10px; }
.description p { font-size: 0.9rem; color: var(--text-muted); line-height: 1.7; margin-bottom: 14px; }
.tag-list { display: flex; flex-wrap: wrap; gap: 6px; }
.tag { font-size: 0.75rem; background: #f0f9ff; color: var(--primary); padding: 3px 10px; border-radius: 20px; border: 1px solid #bfdbfe; }

@media (max-width: 900px) { .detail-grid { grid-template-columns: 1fr; padding: 20px; gap: 24px; } .main-image { height: 260px; } }
</style>
