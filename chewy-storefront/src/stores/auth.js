import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { authApi } from '../api/index'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('token') || null)
  const user = ref(JSON.parse(localStorage.getItem('user') || 'null'))

  const isLoggedIn = computed(() => !!token.value)

  function setAuth(data) {
    token.value = data.token
    user.value = { userId: data.userId, username: data.username, email: data.email }
    localStorage.setItem('token', data.token)
    localStorage.setItem('user', JSON.stringify(user.value))
  }

  function logout() {
    token.value = null
    user.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('user')
  }

  async function register(email, password, username) {
    const res = await authApi.register({ email, password, username })
    const data = res?.data || res
    setAuth(data)
    return data
  }

  async function login(email, password) {
    const res = await authApi.login({ email, password })
    const data = res?.data || res
    setAuth(data)
    return data
  }

  return { token, user, isLoggedIn, register, login, logout, setAuth }
})
