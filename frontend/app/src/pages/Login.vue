<template>
  <div class="min-h-[calc(100vh-120px)] flex items-center justify-center pt-6">
    <div class="w-full max-w-md bg-white rounded-2xl shadow-xl p-8">
      <div class="text-center mb-8">
        <h1 class="text-gray-900 mb-2">Welcome Back</h1>
        <p class="text-gray-600">Sign in to your account to continue</p>
      </div>

      <form @submit.prevent="handleSubmit" class="space-y-6">
        <div>
          <label for="email" class="block text-gray-700 mb-2">Username</label>
          <div class="relative">
            <Mail class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-5 h-5" />
            <input
              id="email"
              type="text"
              v-model="email"
              :class="['w-full pl-11 pr-4 py-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent', errors.email ? 'border-red-500' : 'border-gray-300']"
              placeholder="your username"
            />
          </div>
          <p v-if="errors.email" class="text-red-500 text-sm mt-1">{{ errors.email }}</p>
        </div>

        <div>
          <label for="password" class="block text-gray-700 mb-2">Password</label>
          <div class="relative">
            <Lock class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-5 h-5" />
            <input
              id="password"
              :type="showPassword ? 'text' : 'password'"
              v-model="password"
              :class="['w-full pl-11 pr-12 py-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent', errors.password ? 'border-red-500' : 'border-gray-300']"
              placeholder="Enter your password"
            />
            <button type="button" @click="showPassword = !showPassword" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
              <EyeOff v-if="showPassword" class="w-5 h-5" />
              <Eye v-else class="w-5 h-5" />
            </button>
          </div>
          <p v-if="errors.password" class="text-red-500 text-sm mt-1">{{ errors.password }}</p>
        </div>

        <div class="flex items-center justify-between">
          <label class="flex items-center">
            <input type="checkbox" class="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500" />
            <span class="ml-2 text-gray-700">Remember me</span>
          </label>
          <a href="#" class="text-blue-600 hover:text-blue-700">Forgot password?</a>
        </div>

        <button
          type="submit"
          :disabled="loading || !isFormValid"
          class="w-full bg-blue-600 text-white py-3 rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-60 disabled:cursor-not-allowed"
        >
          {{ loading ? 'Signing in...' : 'Sign In' }}
        </button>

        <p v-if="formError" class="text-red-600 text-sm text-center">{{ formError }}</p>
      </form>

      <div class="mt-6 text-center">
        <p class="text-gray-600">
          Don't have an account?
          <RouterLink to="/register" class="text-blue-600 hover:text-blue-700"> Sign up</RouterLink>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref } from 'vue'
import { Eye, EyeOff, Lock, Mail } from 'lucide-vue-next'
import {login} from '../api/auth'  // Example import for login API
import {useRouter, RouterLink} from 'vue-router'
import {useAuthStore} from '../stores/auth'

defineOptions({ name: 'LoginPage' })
const router = useRouter()
const loading = ref(false)
const formError = ref('')

const authStore = useAuthStore()




// 后端 /users/login 使用 OAuth2PasswordRequestForm：字段名是 username/password
const email = ref('')
const password = ref('')
const showPassword = ref(false)
const errors = reactive({ email: '', password: '' })

const USERNAME_MIN = 3
const USERNAME_MAX = 32
const PASSWORD_MIN = 8
const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

function buildLoginErrors() {
  const newErrors = { email: '', password: '' }
  const identifier = email.value.trim()

  if (!identifier) {
    newErrors.email = '用户名或邮箱不能为空'
  } else if (identifier.includes('@')) {
    if (!EMAIL_REGEX.test(identifier)) {
      newErrors.email = '请输入合法邮箱地址'
    }
  } else if (identifier.length < USERNAME_MIN || identifier.length > USERNAME_MAX) {
    newErrors.email = `用户名需为 ${USERNAME_MIN}-${USERNAME_MAX} 位`
  }

  if (!password.value || !password.value.trim()) {
    newErrors.password = '密码不能为空'
  } else if (password.value.length < PASSWORD_MIN) {
    newErrors.password = `密码至少 ${PASSWORD_MIN} 位`
  } else if (!/[A-Za-z0-9]/.test(password.value)) {
    newErrors.password = '密码需包含字母或数字'
  }

  return newErrors
}

const isFormValid = computed(() => {
  const newErrors = buildLoginErrors()
  return !newErrors.email && !newErrors.password
})

// 表单验证 verification
function validateForm() {
  const newErrors = buildLoginErrors()
  errors.email = newErrors.email
  errors.password = newErrors.password
  return !newErrors.email && !newErrors.password
}

// 提交表单后的操作
async function handleSubmit() {
  formError.value = ''
  if (!validateForm()) return

  loading.value = true
  try {
    const res = await login({ username: email.value.trim(), password: password.value })
    const token = (res as any)?.access_token
    if (!token) {
      throw new Error('登录接口未返回 access_token')
    }

    authStore.setToken(token)
    try {
      await authStore.fetchProfile(true)
    } catch (profileError) {
      console.warn('同步用户信息失败：', profileError)
    }

    // 登录成功后跳转：优先回到来源页，否则去 /my-paths
    router.push({ name: 'my-paths' })
  } catch (e: any) {
    // 后端 err.response?.data 会被 request.ts 里拦截器直接 reject(data)
    formError.value = '用户名或密码错误，请稍后再试'
  } finally {
    loading.value = false
  }
}
</script>
