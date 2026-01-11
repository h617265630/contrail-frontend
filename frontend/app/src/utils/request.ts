import axios from 'axios'
import type {AxiosInstance} from 'axios'

// 仅在运行时读取 token；避免引入 pinia/DOM 类型导致 build 问题
function getToken() {
    try {
        const storage = (globalThis as any).localStorage
        return storage?.getItem('learnsmart_token') || ''
    } catch {
        return ''
    }
}

const request:AxiosInstance =  axios.create({
    // FastAPI 地址（之前验证 swagger 在 8000 可用）
    baseURL:'http://localhost:8000',
    timeout:10000,
    headers:{
        'Content-Type':'application/json'
    },
})

request.interceptors.request.use((config) => {
    const token = getToken()
    if (token) {
        const headers = (config.headers || {}) as any
        headers.Authorization = `Bearer ${token}`
        config.headers = headers
    }
    return config
})

request.interceptors.response.use(
  (response) => {
    console.log(`响应: ${response.status} ${response.config.url}`)
    return response.data
  },
  (error) => {
    if (error.response) {
      console.error('请求错误:', {
        status: error.response.status,
        data: error.response.data,
        headers: error.response.headers
      })
      
      // 如果是 CORS 错误
      if (error.message.includes('CORS') || error.message.includes('Access-Control')) {
        console.error('CORS 错误！请检查后端配置。')
        alert('跨域请求错误，请检查后端 CORS 配置')
      }
    } else if (error.request) {
      console.error('无响应:', error.request)
    } else {
      console.error('请求设置错误:', error.message)
    }
    return Promise.reject(error)
  }
)
export default request