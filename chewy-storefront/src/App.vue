<template>
  <div id="app">
    <!-- Global Header / Nav -->
    <header class="site-header">
      <div class="header-inner">
        <!-- Logo -->
        <router-link to="/" class="logo">
          🐾 PawShop
        </router-link>

        <!-- Main Nav -->
        <nav class="main-nav">
          <router-link to="/">Home</router-link>
          <router-link to="/products">Products</router-link>
        </nav>

        <!-- Right Actions -->
        <div class="header-actions">
          <router-link to="/cart" class="cart-link">
            🛒 Cart
            <span v-if="cartCount > 0" class="cart-badge">{{ cartCount }}</span>
          </router-link>
          <router-link to="/user" class="user-link">👤 Account</router-link>
        </div>
      </div>
    </header>

    <!-- Page Content -->
    <main class="site-main">
      <router-view />
    </main>

    <!-- Footer -->
    <footer class="site-footer">
      <div class="footer-inner">
        <p>© 2025 PawShop – Your North American Pet Supply Store</p>
        <p class="footer-links">
          <a href="#">Privacy Policy</a>
          <a href="#">Terms of Service</a>
          <a href="#">Contact Us</a>
        </p>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useCartStore } from './stores/cart'

const cartStore = useCartStore()
const cartCount = computed(() => cartStore.totalItems)
</script>

<style>
/* Reset */
*, *::before, *::after {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

:root {
  --primary: #0077cc;
  --primary-hover: #005fa3;
  --accent: #ff6b35;
  --text: #1a1a2e;
  --text-muted: #6b7280;
  --bg: #f8f9fa;
  --white: #ffffff;
  --border: #e5e7eb;
  --radius: 8px;
  --shadow: 0 2px 8px rgba(0,0,0,0.08);
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  background: var(--bg);
  color: var(--text);
  line-height: 1.6;
}

a {
  text-decoration: none;
  color: inherit;
}

/* Header */
.site-header {
  background: var(--white);
  border-bottom: 1px solid var(--border);
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: var(--shadow);
}

.header-inner {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 24px;
  height: 64px;
  display: flex;
  align-items: center;
  gap: 32px;
}

.logo {
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--primary);
  white-space: nowrap;
}

.main-nav {
  display: flex;
  gap: 24px;
  flex: 1;
}

.main-nav a,
.header-actions a {
  font-size: 0.95rem;
  font-weight: 500;
  color: var(--text-muted);
  transition: color 0.2s;
  padding: 4px 0;
}

.main-nav a:hover,
.main-nav a.router-link-active,
.header-actions a:hover {
  color: var(--primary);
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-left: auto;
}

.cart-link {
  position: relative;
  display: flex;
  align-items: center;
  gap: 4px;
}

.cart-badge {
  background: var(--accent);
  color: white;
  font-size: 0.7rem;
  font-weight: 700;
  border-radius: 50%;
  width: 18px;
  height: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* Main */
.site-main {
  min-height: calc(100vh - 64px - 80px);
}

/* Footer */
.site-footer {
  background: var(--text);
  color: #9ca3af;
  padding: 24px;
  text-align: center;
  font-size: 0.85rem;
}

.footer-inner {
  max-width: 1280px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.footer-links {
  display: flex;
  gap: 20px;
  justify-content: center;
}

.footer-links a {
  color: #9ca3af;
  transition: color 0.2s;
}

.footer-links a:hover {
  color: white;
}

/* Responsive */
@media (max-width: 768px) {
  .header-inner {
    padding: 0 16px;
    gap: 16px;
  }
  .logo { font-size: 1.2rem; }
  .main-nav { gap: 12px; }
}
</style>
