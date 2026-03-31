<template>
  <div class="min-h-[calc(100vh-4rem)] flex">
    <!-- Left editorial panel -->
    <div class="hidden lg:flex lg:w-1/2 bg-stone-900 relative overflow-hidden flex-col justify-between p-12 xl:p-16">
      <!-- Decorative large index -->
      <div class="absolute -right-8 -top-8 text-[20rem] xl:text-[24rem] font-black text-white/5 leading-none select-none pointer-events-none font-serif tracking-tight">
        02
      </div>

      <!-- Accent bar -->
      <div class="absolute left-0 top-0 bottom-0 w-1 bg-amber-400" />

      <div class="relative z-10">
        <p class="text-[10px] font-bold uppercase tracking-[0.3em] text-amber-400 mb-6">Learnpathly</p>
        <h1 class="text-5xl xl:text-6xl font-black text-white leading-[0.9] tracking-tight font-serif">
          Join<br />us.
        </h1>
        <p class="mt-6 text-stone-400 text-sm leading-relaxed max-w-xs">
          Start building your personal knowledge library. Turn scattered resources into structured learning paths.
        </p>
      </div>

      <div class="relative z-10 space-y-3">
        <div class="flex items-center gap-3">
          <div class="w-8 h-px bg-amber-400" />
          <p class="text-[11px] uppercase tracking-[0.2em] text-stone-500">Free to start · No credit card</p>
        </div>
        <p class="text-xs text-stone-600">Join thousands of learners building structured knowledge</p>
      </div>
    </div>

    <!-- Right form panel -->
    <div class="flex-1 flex flex-col justify-center px-8 py-12 lg:px-16 xl:px-24 bg-stone-50/50">
      <!-- Mobile logo -->
      <div class="lg:hidden mb-10">
        <p class="text-[10px] font-bold uppercase tracking-[0.3em] text-amber-600 mb-2">Learnpathly</p>
        <h1 class="text-3xl font-black text-stone-900 tracking-tight font-serif">Join us.</h1>
      </div>

      <div class="w-full max-w-sm mx-auto lg:mx-0">
        <!-- Form masthead -->
        <div class="mb-8">
          <p class="text-[10px] font-bold uppercase tracking-[0.25em] text-amber-500 mb-2">Account</p>
          <h2 class="text-2xl font-black text-stone-900 font-serif tracking-tight leading-tight">Create account.</h2>
          <p class="mt-2 text-xs text-stone-400">Free to start · No credit card required</p>
        </div>

        <form @submit.prevent="submit" class="space-y-5">
          <!-- Identity fields — tight grouping -->
          <div class="space-y-4">
            <div>
              <label for="username" class="block text-xs font-bold uppercase tracking-[0.15em] text-stone-500 mb-2">Username</label>
              <div class="relative">
                <div class="absolute left-0 top-0 bottom-0 w-0.5 transition-all duration-200" :class="touched.username && !fieldErrors.username ? 'bg-emerald-400' : fieldErrors.username ? 'bg-red-400' : 'bg-stone-200'" />
                <User class="absolute left-3.5 top-1/2 -translate-y-1/2 text-stone-400 w-4 h-4" />
                <input
                  id="username"
                  type="text"
                  v-model="form.username"
                  @blur="onBlur('username')"
                  @focus="onFocus('username')"
                  :aria-invalid="fieldErrors.username ? 'true' : 'false'"
                  :aria-describedby="fieldErrors.username ? 'register-username-error' : undefined"
                  class="w-full pl-10 pr-4 py-3 bg-white border border-stone-200 text-stone-900 text-sm placeholder:text-stone-400 outline-none focus:border-amber-400 focus:ring-2 focus:ring-amber-100 transition-all"
                  placeholder="your_username"
                />
              </div>
              <p v-if="fieldErrors.username" id="register-username-error" class="mt-1.5 text-xs text-red-500" role="alert">{{ fieldErrors.username }}</p>
            </div>

            <div>
              <label for="email" class="block text-xs font-bold uppercase tracking-[0.15em] text-stone-500 mb-2">Email</label>
              <div class="relative">
                <div class="absolute left-0 top-0 bottom-0 w-0.5 transition-all duration-200" :class="touched.email && !fieldErrors.email ? 'bg-emerald-400' : fieldErrors.email ? 'bg-red-400' : 'bg-stone-200'" />
                <Mail class="absolute left-3.5 top-1/2 -translate-y-1/2 text-stone-400 w-4 h-4" />
                <input
                  id="email"
                  type="email"
                  v-model="form.email"
                  @blur="onBlur('email')"
                  @focus="onFocus('email')"
                  :aria-invalid="fieldErrors.email ? 'true' : 'false'"
                  :aria-describedby="fieldErrors.email ? 'register-email-error' : undefined"
                  class="w-full pl-10 pr-4 py-3 bg-white border border-stone-200 text-stone-900 text-sm placeholder:text-stone-400 outline-none focus:border-amber-400 focus:ring-2 focus:ring-amber-100 transition-all"
                  placeholder="you@example.com"
                />
              </div>
              <p v-if="fieldErrors.email" id="register-email-error" class="mt-1.5 text-xs text-red-500" role="alert">{{ fieldErrors.email }}</p>
            </div>

            <div>
              <label for="password" class="block text-xs font-bold uppercase tracking-[0.15em] text-stone-500 mb-2">Password</label>
              <div class="relative">
                <div class="absolute left-0 top-0 bottom-0 w-0.5 transition-all duration-200" :class="touched.password && !fieldErrors.password ? 'bg-emerald-400' : fieldErrors.password ? 'bg-red-400' : 'bg-stone-200'" />
                <Lock class="absolute left-3.5 top-1/2 -translate-y-1/2 text-stone-400 w-4 h-4" />
                <input
                  id="password"
                  :type="showPassword ? 'text' : 'password'"
                  v-model="form.password"
                  @blur="onBlur('password')"
                  @focus="onFocus('password')"
                  :aria-invalid="fieldErrors.password ? 'true' : 'false'"
                  :aria-describedby="fieldErrors.password ? 'register-password-error' : undefined"
                  class="w-full pl-10 pr-12 py-3 bg-white border border-stone-200 text-stone-900 text-sm placeholder:text-stone-400 outline-none focus:border-amber-400 focus:ring-2 focus:ring-amber-100 transition-all"
                  placeholder="••••••••"
                />
                <button
                  type="button"
                  class="absolute right-3.5 top-1/2 -translate-y-1/2 text-stone-400 hover:text-stone-600 transition-colors"
                  @click="showPassword = !showPassword"
                >
                  <EyeOff v-if="showPassword" class="w-4 h-4" />
                  <Eye v-else class="w-4 h-4" />
                </button>
              </div>
              <p v-if="fieldErrors.password" id="register-password-error" class="mt-1.5 text-xs text-red-500" role="alert">{{ fieldErrors.password }}</p>
            </div>

            <div>
              <label for="confirmPassword" class="block text-xs font-bold uppercase tracking-[0.15em] text-stone-500 mb-2">Confirm Password</label>
              <div class="relative">
                <div class="absolute left-0 top-0 bottom-0 w-0.5 transition-all duration-200" :class="touched.confirm_password && !fieldErrors.confirm_password ? 'bg-emerald-400' : fieldErrors.confirm_password ? 'bg-red-400' : 'bg-stone-200'" />
                <Lock class="absolute left-3.5 top-1/2 -translate-y-1/2 text-stone-400 w-4 h-4" />
                <input
                  id="confirmPassword"
                  :type="showConfirmPassword ? 'text' : 'password'"
                  v-model="form.confirm_password"
                  @blur="onBlur('confirm_password')"
                  @focus="onFocus('confirm_password')"
                  :aria-invalid="fieldErrors.confirm_password ? 'true' : 'false'"
                  :aria-describedby="fieldErrors.confirm_password ? 'register-confirm-error' : undefined"
                  class="w-full pl-10 pr-12 py-3 bg-white border border-stone-200 text-stone-900 text-sm placeholder:text-stone-400 outline-none focus:border-amber-400 focus:ring-2 focus:ring-amber-100 transition-all"
                  placeholder="••••••••"
                />
                <button
                  type="button"
                  class="absolute right-3.5 top-1/2 -translate-y-1/2 text-stone-400 hover:text-stone-600 transition-colors"
                  @click="showConfirmPassword = !showConfirmPassword"
                >
                  <EyeOff v-if="showConfirmPassword" class="w-4 h-4" />
                  <Eye v-else class="w-4 h-4" />
                </button>
              </div>
              <p v-if="fieldErrors.confirm_password" id="register-confirm-error" class="mt-1.5 text-xs text-red-500" role="alert">{{ fieldErrors.confirm_password }}</p>
            </div>
          </div>

          <!-- Terms + Submit -->
          <div class="space-y-3 pt-1">
            <div class="flex items-start gap-2.5">
              <input type="checkbox" id="terms" v-model="agreedToTerms" class="w-3.5 h-3.5 mt-0.5 border-stone-300 rounded text-amber-500 focus:ring-amber-200 cursor-pointer" />
              <label for="terms" class="text-xs text-stone-400 leading-relaxed cursor-pointer">
                I agree to the
                <RouterLink to="/about" class="text-amber-600 hover:text-amber-700 font-medium"> Terms of Service</RouterLink>
                and
                <RouterLink to="/about" class="text-amber-600 hover:text-amber-700 font-medium"> Privacy Policy</RouterLink>
              </label>
            </div>

            <button
              type="submit"
              :disabled="loading || !isFormValid"
              class="w-full py-3 bg-amber-500 text-white text-sm font-bold hover:bg-amber-600 disabled:opacity-40 disabled:cursor-not-allowed transition-all hover:-translate-y-px active:translate-y-0 tracking-wide"
            >
              {{ loading ? 'Creating account…' : 'Create Account' }}
            </button>

            <p v-if="formError" class="text-xs text-red-500 text-center py-2 border border-red-100 bg-red-50 rounded">{{ formError }}</p>
            <p v-if="successMessage" class="text-xs text-emerald-600 text-center py-2 border border-emerald-100 bg-emerald-50 rounded font-medium">{{ successMessage }}</p>
          </div>
        </form>

        <!-- Sign in link -->
        <p class="mt-8 pt-6 border-t border-stone-100 text-center text-xs text-stone-400">
          Already have an account?
          <RouterLink to="/login" class="text-amber-600 hover:text-amber-700 font-semibold transition-colors"> Sign in →</RouterLink>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref, watch } from 'vue'
import { Eye, EyeOff, Lock, Mail, User } from 'lucide-vue-next'
import { register } from '../api/auth'
import { useRouter, RouterLink } from 'vue-router'

const form = reactive({
  username: '',
  email: '',
  password: '',
  confirm_password: '',
})
const showPassword = ref(false)
const showConfirmPassword = ref(false)
const agreedToTerms = ref(false)
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

const touched = reactive({
  username: false,
  email: false,
  password: false,
  confirm_password: false,
})

const USERNAME_MIN = 3
const USERNAME_MAX = 32
const PASSWORD_MIN = 8
const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

function buildFieldErrors() {
  const errors = { username: '', email: '', password: '', confirm_password: '' }
  const trimmedUsername = form.username.trim()
  if (!trimmedUsername) {
    errors.username = 'Username is required'
  } else if (trimmedUsername.length < USERNAME_MIN || trimmedUsername.length > USERNAME_MAX) {
    errors.username = `Username must be ${USERNAME_MIN}-${USERNAME_MAX} characters`
  }
  const trimmedEmail = form.email.trim()
  if (!trimmedEmail) {
    errors.email = 'Email is required'
  } else if (!EMAIL_REGEX.test(trimmedEmail)) {
    errors.email = 'Please enter a valid email address'
  }
  const passwordValue = form.password
  if (!passwordValue || !passwordValue.trim()) {
    errors.password = 'Password is required'
  } else if (passwordValue.length < PASSWORD_MIN) {
    errors.password = 'Password must be at least 8 characters'
  } else if (!/[A-Za-z]/.test(passwordValue) || !/\d/.test(passwordValue)) {
    errors.password = 'Password must include both letters and numbers'
  }
  if (!form.confirm_password) {
    errors.confirm_password = 'Please confirm your password'
  } else if (form.confirm_password !== form.password) {
    errors.confirm_password = 'Passwords do not match'
  }
  return errors
}

const isFormValid = computed(() => {
  const errors = buildFieldErrors()
  return Object.values(errors).every((message) => !message) && agreedToTerms.value
})

function syncTouchedErrors() {
  const errors = buildFieldErrors()
  fieldErrors.username = touched.username ? errors.username : ''
  fieldErrors.email = touched.email ? errors.email : ''
  fieldErrors.password = touched.password ? errors.password : ''
  fieldErrors.confirm_password = touched.confirm_password ? errors.confirm_password : ''
}

function validateForm() {
  const errors = buildFieldErrors()
  fieldErrors.username = errors.username
  fieldErrors.email = errors.email
  fieldErrors.password = errors.password
  fieldErrors.confirm_password = errors.confirm_password
  return Object.values(errors).every((message) => !message)
}

function onBlur(field: keyof typeof touched) {
  touched[field] = true
  syncTouchedErrors()
}

function onFocus(field: keyof typeof touched) {
  touched[field] = true
}

watch(
  () => [form.username, form.email, form.password, form.confirm_password],
  () => {
    if (touched.username || touched.email || touched.password || touched.confirm_password) {
      syncTouchedErrors()
    }
  },
)

const submit = async () => {
  formError.value = ''
  successMessage.value = ''
  touched.username = true
  touched.email = true
  touched.password = true
  touched.confirm_password = true
  if (!validateForm() || !agreedToTerms.value) return

  loading.value = true
  try {
    await register({
      username: form.username.trim(),
      email: form.email.trim(),
      password: form.password,
    })
    successMessage.value = 'Account created! Redirecting to sign in…'
    setTimeout(() => router.push('/login'), 1200)
  } catch (err: any) {
    formError.value = err?.detail || err?.message || 'Registration failed, please try again'
  } finally {
    loading.value = false
  }
}
</script>
