import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/', redirect: '/admin' },
  { path: '/admin', component: () => import('../views/admin/index.vue') },
  { path: '/:pathMatch(.*)*', redirect: '/admin' },
]

export default createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior: () => ({ top: 0 }),
})
