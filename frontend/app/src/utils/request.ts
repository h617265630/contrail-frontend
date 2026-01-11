import axios from 'axios'
import type {AxiosInstance} from 'axios'

// Read token at runtime only; avoids importing pinia/DOM types that may break builds.
function getToken() {
    try {
        const storage = (globalThis as any).localStorage
        return storage?.getItem('learnsmart_token') || ''
    } catch {
        return ''
    }
}

const request:AxiosInstance =  axios.create({
  // FastAPI base URL
    baseURL:'http://localhost:8000',
    timeout:10000,
})

request.interceptors.request.use((config) => {
    // Set JSON content-type only when sending plain objects (not FormData)
    const headers = (config.headers || {}) as any
    const isFormData = typeof FormData !== 'undefined' && config.data instanceof FormData
    if (!isFormData) {
      if (!headers['Content-Type'] && !headers['content-type']) {
        headers['Content-Type'] = 'application/json'
      }
    }

    const token = getToken()
    if (token) {
        headers.Authorization = `Bearer ${token}`
    }
    config.headers = headers
    return config
})

request.interceptors.response.use(
  (response) => {
    console.log(`Response: ${response.status} ${response.config.url}`)
    return response.data
  },
  (error) => {
    if (error.response) {
      console.error('Request error:', {
        status: error.response.status,
        data: error.response.data,
        headers: error.response.headers
      })
      
      // CORS-related errors
      if (error.message.includes('CORS') || error.message.includes('Access-Control')) {
        console.error('CORS error! Please check the backend configuration.')
        alert('CORS request error. Please check the backend CORS configuration.')
      }
    } else if (error.request) {
      console.error('No response:', error.request)
    } else {
      console.error('Request setup error:', error.message)
    }
    return Promise.reject(error)
  }
)
export default request