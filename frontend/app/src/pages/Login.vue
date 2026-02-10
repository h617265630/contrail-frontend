<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Login</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">Sign in to your account to continue</p>
        </div>
      </div>
    </section>

    <section class="flex justify-center">
      <Card className="w-full max-w-md" :hoverable="false" padded>
        <form @submit.prevent="handleSubmit" class="space-y-6">
        <div>
          <label for="email" class="block text-sm font-medium text-foreground mb-2">Username or Email</label>
          <div class="relative">
            <Mail class="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground w-4 h-4" />
            <Input
              id="email"
              type="text"
              v-model="email"
              @blur="onBlur('email')"
              :class="[
                'pl-9',
                errors.email ? 'border-destructive' : '',
              ]"
              placeholder="Enter your username or email"
              @update:modelValue="onInput('email')"
            />

            <span v-if="errors.email" class="absolute left-9 -bottom-5 text-xs text-destructive pointer-events-none">
              {{ errors.email }}
            </span>
          </div>
        </div>

        <div>
          <label for="password" class="block text-sm font-medium text-foreground mb-2">Password</label>
          <div class="relative">
            <Lock class="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground w-4 h-4" />
            <Input
              id="password"
              :type="showPassword ? 'text' : 'password'"
              v-model="password"
              @blur="onBlur('password')"
              :class="[
                'pl-9 pr-10',
                errors.password ? 'border-destructive' : '',
              ]"
              placeholder="Enter your password"
              @update:modelValue="onInput('password')"
            />
            <Button
              type="button"
              variant="ghost"
              size="icon"
              class="absolute right-1 top-1/2 -translate-y-1/2"
              @click="showPassword = !showPassword"
            >
              <EyeOff v-if="showPassword" class="w-4 h-4" />
              <Eye v-else class="w-4 h-4" />
            </Button>

            <span v-if="errors.password" class="absolute left-9 -bottom-5 text-xs text-destructive pointer-events-none">
              {{ errors.password }}
            </span>
          </div>
        </div>

        <div class="flex items-center justify-between">
          <label class="flex items-center">
            <input type="checkbox" class="w-4 h-4 border-input rounded-md" />
            <span class="ml-2 text-sm text-muted-foreground">Remember me</span>
          </label>
          <a href="#" class="text-sm text-foreground underline underline-offset-4">Forgot password?</a>
        </div>

        <Button
          type="submit"
          :disabled="loading || !isFormValid"
          variant="outline"
          size="lg"
          class="w-full rounded-none border-border bg-[#8ecbff] text-white transition-all hover:-translate-y-px hover:bg-[#8ecbff]/90 hover:text-white hover:shadow-sm active:translate-y-0"
        >
          {{ loading ? 'Signing in...' : 'Sign In' }}
        </Button>

        <p v-if="formError" class="text-destructive text-sm text-center">{{ formError }}</p>
      </form>

      <div v-if="googleEnabled" class="mt-6 space-y-4">
        <div class="flex items-center gap-3">
          <div class="h-px flex-1 bg-border" />
          <div class="text-xs text-muted-foreground">or</div>
          <div class="h-px flex-1 bg-border" />
        </div>
        <div class="flex justify-center">
          <div ref="googleButtonEl" class="w-full flex justify-center" />
        </div>
        <p v-if="googleLoading" class="text-xs text-muted-foreground text-center">Signing in with Google…</p>
      </div>

      <div class="mt-6 text-center">
        <p class="text-sm text-muted-foreground">
          Don't have an account?
          <RouterLink to="/register" class="text-foreground underline underline-offset-4"> Sign up</RouterLink>
        </p>
      </div>
      </Card>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, reactive, ref } from 'vue'
import { Eye, EyeOff, Lock, Mail } from 'lucide-vue-next'
import { googleLogin, login } from '../api/auth'
import {useRouter, RouterLink} from 'vue-router'
import {useAuthStore} from '../stores/auth'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'

defineOptions({ name: 'LoginPage' })
const router = useRouter()
const loading = ref(false)
const formError = ref('')

const googleButtonEl = ref<HTMLDivElement | null>(null)
const googleLoading = ref(false)
const googleClientId = String(import.meta.env.VITE_GOOGLE_CLIENT_ID || '').trim()
const googleEnabled = computed(() => !!googleClientId)

const authStore = useAuthStore()




// Backend /users/login uses OAuth2PasswordRequestForm: username/password
const email = ref('')
const password = ref('')
const showPassword = ref(false)
const errors = reactive({ email: '', password: '' })

const touched = reactive({ email: false, password: false })

const USERNAME_MIN = 3
const USERNAME_MAX = 32
const PASSWORD_MIN = 8
const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

function buildLoginErrors() {
  const newErrors = { email: '', password: '' }
  const identifier = email.value.trim()

  if (!identifier) {
    newErrors.email = 'Username or email is required'
  } else if (identifier.includes('@')) {
    if (!EMAIL_REGEX.test(identifier)) {
      newErrors.email = 'Please enter a valid email address'
    }
  } else if (identifier.length < USERNAME_MIN || identifier.length > USERNAME_MAX) {
    newErrors.email = `Username must be ${USERNAME_MIN}-${USERNAME_MAX} characters`
  }

  if (!password.value || !password.value.trim()) {
    newErrors.password = 'Password is required'
  } else if (password.value.length < PASSWORD_MIN) {
    newErrors.password = `Password must be at least ${PASSWORD_MIN} characters`
  } else if (!/[A-Za-z]/.test(password.value) || !/\d/.test(password.value)) {
    newErrors.password = 'Password must include both letters and numbers'
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

function syncTouchedErrors() {
  const newErrors = buildLoginErrors()
  errors.email = touched.email ? newErrors.email : ''
  errors.password = touched.password ? newErrors.password : ''
}

function onBlur(field: keyof typeof touched) {
  touched[field] = true
  syncTouchedErrors()
}

function onInput(field: keyof typeof touched) {
  if (!touched[field]) return
  syncTouchedErrors()
}

// 提交表单后的操作
async function handleSubmit() {
  formError.value = ''
  touched.email = true
  touched.password = true
  if (!validateForm()) return

  loading.value = true
  try {
    const res = await login({ username: email.value.trim(), password: password.value })
    const token = (res as any)?.access_token
    if (!token) {
      throw new Error('Login response did not include access_token')
    }

    authStore.setToken(token)
    try {
      await authStore.fetchProfile(true)
    } catch (profileError) {
      console.warn('Failed to sync user profile:', profileError)
    }

    // Redirect after login
    router.push({ name: 'my-paths' })
  } catch (e: any) {
    // 后端 err.response?.data 会被 request.ts 里拦截器直接 reject(data)
    formError.value = 'Invalid username/email or password. Please try again.'
  } finally {
    loading.value = false
  }
}

async function handleGoogleCredential(idToken: string) {
  formError.value = ''
  googleLoading.value = true
  try {
    const res = await googleLogin({ id_token: idToken })
    const token = (res as any)?.access_token
    if (!token) {
      throw new Error('Google login response did not include access_token')
    }

    authStore.setToken(token)
    try {
      await authStore.fetchProfile(true)
    } catch (profileError) {
      console.warn('Failed to sync user profile:', profileError)
    }

    router.push({ name: 'my-paths' })
  } catch (e: any) {
    formError.value = 'Google sign-in failed. Please try again.'
  } finally {
    googleLoading.value = false
  }
}

onMounted(() => {
  if (!googleEnabled.value) return
  const g = (globalThis as any).google
  if (!g?.accounts?.id) return
  if (!googleButtonEl.value) return

  g.accounts.id.initialize({
    client_id: googleClientId,
    callback: (resp: any) => {
      const credential = String(resp?.credential || '').trim()
      if (!credential) return
      void handleGoogleCredential(credential)
    },
  })

  g.accounts.id.renderButton(googleButtonEl.value, {
    theme: 'outline',
    size: 'large',
    shape: 'rectangular',
    width: 360,
  })
})

onBeforeUnmount(() => {
  const g = (globalThis as any).google
  try {
    g?.accounts?.id?.cancel?.()
  } catch {
    // ignore
  }
})
</script>
