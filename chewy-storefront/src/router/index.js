import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/', component: () => import('../views/home/index.vue') },
  { path: '/products', component: () => import('../views/product/list.vue') },
  { path: '/product/:id', component: () => import('../views/product/detail.vue') },
  { path: '/cart', component: () => import('../views/cart/index.vue') },
  {
    path: '/checkout',
    component: () => import('../views/checkout/CheckoutLayout.vue'),
    children: [
      { path: '', redirect: '/checkout/shipping' },
      { path: 'shipping', component: () => import('../views/checkout/Shipping.vue') },
      { path: 'delivery', component: () => import('../views/checkout/Delivery.vue') },
      { path: 'payment', component: () => import('../views/checkout/Payment.vue') },
    ],
  },
  { path: '/order/confirm/:id', component: () => import('../views/order/Confirm.vue') },
  { path: '/order/confirm', component: () => import('../views/order/Confirm.vue') },
  { path: '/account', component: () => import('../views/account/index.vue') },
  { path: '/user', redirect: '/account' },
  { path: '/:pathMatch(.*)*', redirect: '/' },
]

export default createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior: () => ({ top: 0 }),
})
