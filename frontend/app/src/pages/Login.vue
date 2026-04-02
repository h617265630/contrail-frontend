<template>
  <div class="min-h-[calc(100vh-4rem)] flex">
    <!-- Left editorial panel -->
    <div class="hidden lg:flex lg:w-1/2 bg-stone-950 relative overflow-hidden flex-col justify-between p-12 xl:p-16">
      <!-- Decorative large index -->
      <div class="absolute -right-8 -top-8 text-[20rem] xl:text-[24rem] font-black text-white/5 leading-none select-none pointer-events-none font-serif tracking-tight">
        01
      </div>

      <!-- Accent bar -->
      <div class="absolute left-0 top-0 bottom-0 w-1 bg-amber-500" />

      <div class="relative z-10">
        <p class="text-[10px] font-bold uppercase tracking-[0.3em] text-amber-500 mb-6">Learnpathly</p>
        <h1 class="text-5xl xl:text-6xl font-black text-white leading-[0.9] tracking-tight font-serif">
          Sign<br />in.
        </h1>
        <p class="mt-6 text-stone-400 text-sm leading-relaxed max-w-xs">
          Access your personal library, track progress, and continue building your knowledge.
        </p>
      </div>

      <div class="relative z-10 space-y-3">
        <div class="flex items-center gap-3">
          <div class="w-8 h-px bg-amber-500" />
          <p class="text-[11px] uppercase tracking-[0.2em] text-stone-500">Personal learning platform</p>
        </div>
        <p class="text-xs text-stone-600">Build structured paths · Track progress · Turn scattered resources into lasting knowledge</p>
      </div>
    </div>

    <!-- Right form panel -->
    <div class="flex-1 flex flex-col justify-center px-8 py-12 lg:px-16 xl:px-24 bg-stone-50/50">
      <!-- Mobile logo -->
      <div class="lg:hidden mb-10">
        <p class="text-[10px] font-bold uppercase tracking-[0.3em] text-amber-600 mb-2">Learnpathly</p>
        <h1 class="text-3xl font-black text-stone-900 tracking-tight font-serif">Sign in.</h1>
      </div>

      <div class="w-full max-w-sm mx-auto lg:mx-0">
        <!-- Form masthead — visual anchor -->
        <div class="mb-8">
          <p class="text-[10px] font-bold uppercase tracking-[0.25em] text-amber-500 mb-2">Account</p>
          <h2 class="text-2xl font-black text-stone-900 font-serif tracking-tight leading-tight">Welcome back.</h2>
          <p class="mt-2 text-xs text-stone-400">Sign in to continue to Learnpathly</p>
        </div>

        <form @submit.prevent="handleSubmit" class="space-y-5">
          <!-- Identity fields — tight grouping -->
          <div class="space-y-4">
            <div>
              <label for="email" class="block text-xs font-bold uppercase tracking-[0.15em] text-stone-500 mb-2">Username or Email</label>
              <div class="relative">
                <div class="absolute left-0 top-0 bottom-0 w-0.5 transition-all duration-200" :class="touched.email && !errors.email ? 'bg-emerald-400' : errors.email ? 'bg-red-400' : 'bg-stone-200'" />
                <Mail class="absolute left-3.5 top-1/2 -translate-y-1/2 text-stone-400 w-4 h-4" />
                <input
                  id="email"
                  type="text"
                  v-model="email"
                  @blur="onBlur('email')"
                  @focus="onFocus('email')"
                  :aria-invalid="errors.email ? 'true' : 'false'"
                  :aria-describedby="errors.email ? 'login-email-error' : undefined"
                  class="w-full pl-10 pr-4 py-3 bg-white border border-stone-200 text-stone-900 text-sm placeholder:text-stone-400 outline-none focus:border-amber-400 focus:ring-2 focus:ring-amber-100 transition-all"
                  placeholder="your@email.com"
                />
              </div>
              <p v-if="errors.email" id="login-email-error" class="mt-1.5 text-xs text-red-500" role="alert">{{ errors.email }}</p>
            </div>

            <div>
              <label for="password" class="block text-xs font-bold uppercase tracking-[0.15em] text-stone-500 mb-2">Password</label>
              <div class="relative">
                <div class="absolute left-0 top-0 bottom-0 w-0.5 transition-all duration-200" :class="touched.password && !errors.password ? 'bg-emerald-400' : errors.password ? 'bg-red-400' : 'bg-stone-200'" />
                <Lock class="absolute left-3.5 top-1/2 -translate-y-1/2 text-stone-400 w-4 h-4" />
                <input
                  id="password"
                  :type="showPassword ? 'text' : 'password'"
                  v-model="password"
                  @blur="onBlur('password')"
                  @focus="onFocus('password')"
                  :aria-invalid="errors.password ? 'true' : 'false'"
                  :aria-describedby="errors.password ? 'login-password-error' : undefined"
                  class="w-full pl-10 pr-12 py-3 bg-white border border-stone-200 text-stone-900 text-sm placeholder:text-stone-400 outline-none focus:border-amber-400 focus:ring-2 focus:ring-amber-100 transition-all"
                  placeholder="••••••••"
                />
                <button
                  type="button"
                  class="absolute right-3.5 top-1/2 -translate-y-1/2 text-stone-400 hover:text-stone-600 transition-colors"
                  @click="showPassword = !showPassword"
                  :aria-label="showPassword ? 'Hide password' : 'Show password'"
                >
                  <EyeOff v-if="showPassword" class="w-4 h-4" />
                  <Eye v-else class="w-4 h-4" />
                </button>
              </div>
              <p v-if="errors.password" id="login-password-error" class="mt-1.5 text-xs text-red-500" role="alert">{{ errors.password }}</p>
            </div>
          </div>

          <!-- Options row — de-emphasized -->
          <div class="flex items-center justify-between">
            <label class="flex items-center gap-2 cursor-pointer">
              <input v-model="remember" type="checkbox" class="w-3.5 h-3.5 border-stone-300 rounded text-amber-500 focus:ring-amber-200" />
              <span class="text-xs text-stone-400">Remember me</span>
            </label>
            <a href="#" class="text-xs text-stone-400 hover:text-amber-600 transition-colors">Forgot password?</a>
          </div>

          <!-- Submit -->
          <button
            type="submit"
            :disabled="loading || !isFormValid"
            class="w-full py-3 bg-stone-900 text-white text-sm font-bold hover:bg-stone-800 disabled:opacity-40 disabled:cursor-not-allowed transition-all hover:-translate-y-px active:translate-y-0 tracking-wide"
          >
            {{ loading ? 'Signing in…' : 'Sign In' }}
          </button>

          <p v-if="formError" class="text-xs text-red-500 text-center py-2 border border-red-100 bg-red-50 rounded">{{ formError }}</p>
        </form>

        <!-- Google — visually separated -->
        <div v-if="googleEnabled" class="mt-6">
          <div class="flex items-center gap-3 mb-4">
            <div class="flex-1 h-px bg-stone-200" />
            <span class="text-[10px] uppercase tracking-[0.2em] text-stone-400">or</span>
            <div class="flex-1 h-px bg-stone-200" />
          </div>
          <div ref="googleButtonEl" class="w-full" />
          <p v-if="googleLoading" class="text-xs text-stone-400 text-center mt-2">Signing in with Google…</p>
        </div>

        <!-- Sign up link -->
        <p class="mt-8 pt-6 border-t border-stone-100 text-center text-xs text-stone-400">
          Don't have an account?
          <RouterLink to="/register" class="text-amber-600 hover:text-amber-700 font-semibold transition-colors"> Create one →</RouterLink>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, reactive, ref } from 'vue'
import { Eye, EyeOff, Lock, Mail } from 'lucide-vue-next'
import { googleLogin, login } from '../api/auth'
import { useRouter, RouterLink } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const loading = ref(false)
const formError = ref('')
const googleButtonEl = ref<HTMLDivElement | null>(null)
const googleLoading = ref(false)
const googleClientId = String(import.meta.env.VITE_GOOGLE_CLIENT_ID || '').trim()
const googleEnabled = computed(() => !!googleClientId)

const authStore = useAuthStore()

const email = ref('')
const password = ref('')
const showPassword = ref(false)
const remember = ref(false)
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

function onBlur(field: 'email' | 'password') {
  touched[field] = true
  syncTouchedErrors()
}

function onFocus(field: 'email' | 'password') {
  touched[field] = true
}

async function handleSubmit() {
  formError.value = ''
  touched.email = true
  touched.password = true
  if (!validateForm()) return

  loading.value = true
  try {
    const res = await login({ username: email.value.trim(), password: password.value })
    const token = (res as any)?.access_token
    if (!token) throw new Error('Login response did not include access_token')

    authStore.setToken(token, remember.value)
    try {
      await authStore.fetchProfile(true)
    } catch (profileError) {
      console.warn('Failed to sync user profile:', profileError)
    }
    router.push({ name: 'my-paths' })
  } catch {
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
    if (!token) throw new Error('Google login response did not include access_token')
    authStore.setToken(token, remember.value)
    try {
      await authStore.fetchProfile(true)
    } catch (profileError) {
      console.warn('Failed to sync user profile:', profileError)
    }
    router.push({ name: 'my-paths' })
  } catch {
    formError.value = 'Google sign-in failed. Please try again.'
  } finally {
    googleLoading.value = false
  }
}

onMounted(() => {
  try {
    const local = (globalThis as any).localStorage
    remember.value = local?.getItem?.('learnsmart_remember') === '1'
  } catch {
    remember.value = false
  }

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
    width: Math.min(360, window.innerWidth - 32),
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
