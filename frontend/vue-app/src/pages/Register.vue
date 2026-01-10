<template>
  <div class="min-h-[calc(100vh-120px)] flex items-center justify-center pt-6">
    <div class="w-full max-w-md bg-white rounded-2xl shadow-xl p-8">
      <div class="text-center mb-8">
        <h1 class="text-gray-900 mb-2">Create Account</h1>
        <p class="text-gray-600">Sign up to get started</p>
      </div>

      <form @submit.prevent="submit" class="space-y-6">
        <div>
          <label for="name" class="block text-gray-700 mb-2">Username</label>
          <div class="relative">
            <User class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-5 h-5" />
            <input
              id="name"
              type="text"
              v-model="form.username"
              :class="['w-full pl-11 pr-4 py-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent', fieldErrors.username ? 'border-red-500' : 'border-gray-300']"
              placeholder="your username"
            />
          </div>
          <p v-if="fieldErrors.username" class="text-red-500 text-sm mt-1">{{ fieldErrors.username }}</p>
        </div>

        <div>
          <label for="email" class="block text-gray-700 mb-2">Email</label>
          <div class="relative">
            <Mail class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-5 h-5" />
            <input
              id="email"
              type="email"
              v-model="form.email"
              :class="['w-full pl-11 pr-4 py-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent', fieldErrors.email ? 'border-red-500' : 'border-gray-300']"
              placeholder="you@example.com"
            />
          </div>
          <p v-if="fieldErrors.email" class="text-red-500 text-sm mt-1">{{ fieldErrors.email }}</p>
        </div>

        <div>
          <label for="password" class="block text-gray-700 mb-2">Password</label>
          <div class="relative">
            <Lock class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-5 h-5" />
            <input
              id="password"
              :type="showPassword ? 'text' : 'password'"
              v-model="form.password"
              :class="['w-full pl-11 pr-12 py-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent', fieldErrors.password ? 'border-red-500' : 'border-gray-300']"
              placeholder="Create a password"
            />
            <button type="button" @click="showPassword = !showPassword" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
              <EyeOff v-if="showPassword" class="w-5 h-5" />
              <Eye v-else class="w-5 h-5" />
            </button>
          </div>
          <p v-if="fieldErrors.password" class="text-red-500 text-sm mt-1">{{ fieldErrors.password }}</p>
        </div>

        <div>
          <label for="confirmPassword" class="block text-gray-700 mb-2">Confirm Password</label>
          <div class="relative">
            <Lock class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-5 h-5" />
            <input
              id="confirmPassword"
              :type="showConfirmPassword ? 'text' : 'password'"
              v-model="form.confirm_password"
              :class="['w-full pl-11 pr-12 py-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent', fieldErrors.confirm_password ? 'border-red-500' : 'border-gray-300']"
              placeholder="Confirm your password"
            />
            <button type="button" @click="showConfirmPassword = !showConfirmPassword" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
              <EyeOff v-if="showConfirmPassword" class="w-5 h-5" />
              <Eye v-else class="w-5 h-5" />
            </button>
          </div>
          <p v-if="fieldErrors.confirm_password" class="text-red-500 text-sm mt-1">{{ fieldErrors.confirm_password }}</p>
        </div>

        <div class="flex items-start">
          <input type="checkbox" id="terms" class="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500 mt-1" />
          <label for="terms" class="ml-2 text-gray-700">
            I agree to the <a href="#" class="text-blue-600 hover:text-blue-700">Terms of Service</a> and
            <a href="#" class="text-blue-600 hover:text-blue-700"> Privacy Policy</a>
          </label>
        </div>

        <button
          type="submit"
          :disabled="loading"
          class="w-full bg-blue-600 text-white py-3 rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-60 disabled:cursor-not-allowed"
        >
          {{ loading ? 'Creating...' : 'Create Account' }}
        </button>
        <p v-if="formError" class="text-red-600 text-sm text-center">{{ formError }}</p>
        <p v-if="successMessage" class="text-green-600 text-sm text-center">{{ successMessage }}</p>
      </form>

      <div class="mt-6 text-center">
        <p class="text-gray-600">
          Already have an account?
          <RouterLink to="/login" class="text-blue-600 hover:text-blue-700"> Sign in</RouterLink>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue'
import { Eye, EyeOff, Lock, Mail, User } from 'lucide-vue-next'
import { register } from '../api/auth'
import { useRouter, RouterLink } from 'vue-router'

defineOptions({
  name: 'SignUpSection',
})

const form = reactive({
  username: '',
  email: '',
  password: '',
  confirm_password: '',
})
const showPassword = ref(false)
const showConfirmPassword = ref(false)
const fieldErrors = reactive({
  username: '',
  email: '',
  password: '',
  confirm_password: '',
})
const loading = ref(false)
const formError = ref('')
const successMessage = ref('')
const router = useRouter()

function clearErrors() {
  fieldErrors.username = ''
  fieldErrors.email = ''
  fieldErrors.password = ''
  fieldErrors.confirm_password = ''
}

function validateForm() {
  clearErrors()
  let valid = true

  if (!form.username) {
    fieldErrors.username = 'Username is required'
    valid = false
  }

  if (!form.email) {
    fieldErrors.email = 'Email is required'
    valid = false
  }

  if (!form.password) {
    fieldErrors.password = 'Password is required'
    valid = false
  }

  if (!form.confirm_password) {
    fieldErrors.confirm_password = 'Please confirm your password'
    valid = false
  } else if (form.password !== form.confirm_password) {
    fieldErrors.confirm_password = 'Passwords do not match'
    valid = false
  }

  return valid
}

const submit = async () => {
  formError.value = ''
  successMessage.value = ''
  if (!validateForm()) return

  loading.value = true
  try {
    await register({
      username: form.username.trim(),
      email: form.email.trim(),
      password: form.password,
    })
    successMessage.value = 'Registration successful! Redirecting to sign in...'
    setTimeout(() => router.push('/login'), 1200)
  } catch (err: any) {
    console.error('注册失败:', err)
    formError.value = err?.detail || err?.message || 'Registration failed, please try again'
  } finally {
    loading.value = false
  }
}
</script>
