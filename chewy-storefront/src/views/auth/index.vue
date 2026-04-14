<template>
  <div class="auth-page">
    <div class="auth-card">
      <!-- Tabs -->
      <div class="auth-tabs">
        <button :class="{ active: mode === 'login' }" @click="mode = 'login'">Sign In</button>
        <button :class="{ active: mode === 'register' }" @click="mode = 'register'">Create Account</button>
      </div>

      <!-- Login Form -->
      <form v-if="mode === 'login'" @submit.prevent="handleLogin" class="auth-form">
        <h2>Welcome back 🐾</h2>
        <div class="form-group">
          <label>Email Address</label>
          <input v-model="loginForm.email" type="email" placeholder="you@example.com" required />
        </div>
        <div class="form-group">
          <label>Password</label>
          <input v-model="loginForm.password" type="password" placeholder="••••••••" required />
        </div>
        <p v-if="error" class="error-msg">{{ error }}</p>
        <button type="submit" class="btn-submit" :disabled="loading">
          {{ loading ? 'Signing in...' : 'Sign In' }}
        </button>
        <p class="switch-link">
          New here? <a href="#" @click.prevent="mode = 'register'">Create an account</a>
        </p>
      </form>

      <!-- Register Form -->
      <form v-else @submit.prevent="handleRegister" class="auth-form">
        <h2>Join PawShop 🐾</h2>
        <div class="form-group">
          <label>Username</label>
          <input v-model="regForm.username" type="text" placeholder="pawlover123" required minlength="3" />
        </div>
        <div class="form-group">
          <label>Email Address</label>
          <input v-model="regForm.email" type="email" placeholder="you@example.com" required />
        </div>
        <div class="form-group">
          <label>Password <span class="hint">(min 8 chars)</span></label>
          <input v-model="regForm.password" type="password" placeholder="••••••••" required minlength="8" />
        </div>
        <p v-if="error" class="error-msg">{{ error }}</p>
        <button type="submit" class="btn-submit" :disabled="loading">
          {{ loading ? 'Creating account...' : 'Create Account' }}
        </button>
        <p class="switch-link">
          Already have an account? <a href="#" @click.prevent="mode = 'login'">Sign in</a>
        </p>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '../../stores/auth'
import { ElMessage } from 'element-plus'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()

const mode = ref(route.query.mode === 'register' ? 'register' : 'login')
const loading = ref(false)
const error = ref('')

const loginForm = ref({ email: '', password: '' })
const regForm = ref({ username: '', email: '', password: '' })

async function handleLogin() {
  loading.value = true
  error.value = ''
  try {
    await authStore.login(loginForm.value.email, loginForm.value.password)
    ElMessage({ message: 'Welcome back!', type: 'success' })
    router.push(route.query.redirect || '/')
  } catch (err) {
    error.value = err?.response?.data?.message || 'Invalid email or password.'
  } finally {
    loading.value = false
  }
}

async function handleRegister() {
  loading.value = true
  error.value = ''
  try {
    await authStore.register(regForm.value.email, regForm.value.password, regForm.value.username)
    ElMessage({ message: 'Account created! Welcome to PawShop 🎉', type: 'success' })
    router.push(route.query.redirect || '/')
  } catch (err) {
    error.value = err?.response?.data?.message || 'Registration failed. Please try again.'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.auth-page {
  min-height: 100vh;
  background: var(--bg);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 32px 16px;
}

.auth-card {
  background: white;
  border: 1px solid var(--border);
  border-radius: 12px;
  width: 100%;
  max-width: 420px;
  overflow: hidden;
  box-shadow: 0 8px 32px rgba(0,0,0,0.08);
}

.auth-tabs {
  display: grid;
  grid-template-columns: 1fr 1fr;
  border-bottom: 1px solid var(--border);
}

.auth-tabs button {
  padding: 14px;
  background: none;
  border: none;
  font-size: 0.95rem;
  font-weight: 600;
  cursor: pointer;
  color: var(--text-muted);
  border-bottom: 2px solid transparent;
  transition: all 0.2s;
}

.auth-tabs button.active {
  color: var(--primary);
  border-bottom-color: var(--primary);
  background: #f0f9ff;
}

.auth-form {
  padding: 28px;
}

.auth-form h2 {
  font-size: 1.3rem;
  font-weight: 700;
  margin-bottom: 22px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
  margin-bottom: 16px;
}

.form-group label {
  font-size: 0.83rem;
  font-weight: 600;
  color: var(--text-muted);
}

.hint { font-weight: 400; font-size: 0.78rem; }

.form-group input {
  padding: 10px 14px;
  border: 1px solid var(--border);
  border-radius: 6px;
  font-size: 0.92rem;
  outline: none;
  transition: border-color 0.2s;
}

.form-group input:focus { border-color: var(--primary); }

.error-msg {
  color: #dc2626;
  font-size: 0.85rem;
  margin-bottom: 12px;
  background: #fef2f2;
  padding: 8px 12px;
  border-radius: 6px;
}

.btn-submit {
  width: 100%;
  padding: 13px;
  background: var(--primary);
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  transition: background 0.2s;
  margin-bottom: 14px;
}

.btn-submit:hover:not(:disabled) { background: var(--primary-hover); }
.btn-submit:disabled { opacity: 0.6; cursor: not-allowed; }

.switch-link {
  text-align: center;
  font-size: 0.87rem;
  color: var(--text-muted);
}

.switch-link a {
  color: var(--primary);
  font-weight: 600;
}
</style>
