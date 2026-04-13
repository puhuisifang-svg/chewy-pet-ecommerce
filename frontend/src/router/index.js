import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/', component: () => import('../views/home/index.vue') },
  { path: '/products', component: () => import('../views/product/list.vue') },
  { path: '/product/:id', component: () => import('../views/product/detail.vue') },
  { path: '/cart', component: () => import('../views/cart/index.vue') },
  { path: '/checkout', component: () => import('../views/checkout/index.vue') },
  { path: '/user', component: () => import('../views/user/index.vue') },
]

export default createRouter({
  history: createWebHistory(),
  routes
})
