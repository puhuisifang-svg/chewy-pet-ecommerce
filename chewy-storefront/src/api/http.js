import axios from 'axios'

const http = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://47.238.64.8:8080',
  timeout: 10000,
  headers: { 'Content-Type': 'application/json' },
})

// Request interceptor: attach auth token
http.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

// Response interceptor: unwrap data envelope
http.interceptors.response.use(
  (res) => res.data,
  (err) => {
    console.warn('[API Error]', err.message)
    return Promise.reject(err)
  }
)

export default http
