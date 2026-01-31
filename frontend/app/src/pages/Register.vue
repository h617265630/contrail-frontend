<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Register</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">Sign up to get started</p>
        </div>
      </div>
    </section>

    <section class="flex justify-center">
      <Card className="w-full max-w-md" :hoverable="false" padded>
        <form @submit.prevent="submit" class="space-y-6">
        <div>
          <label for="name" class="block text-sm font-medium text-foreground mb-2">Username</label>
          <div class="relative">
            <User class="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground w-4 h-4" />
            <Input
              id="name"
              type="text"
              v-model="form.username"
              @blur="onBlur('username')"
              :class="[
                'pl-9',
                fieldErrors.username ? 'border-destructive' : '',
              ]"
              placeholder="your username"
              @update:modelValue="onInput('username')"
            />

            <span v-if="fieldErrors.username" class="absolute left-9 -bottom-5 text-xs text-destructive pointer-events-none">
              {{ fieldErrors.username }}
            </span>
          </div>
        </div>

        <div>
          <label for="email" class="block text-sm font-medium text-foreground mb-2">Email</label>
          <div class="relative">
            <Mail class="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground w-4 h-4" />
            <Input
              id="email"
              type="email"
              v-model="form.email"
              @blur="onBlur('email')"
              :class="[
                'pl-9',
                fieldErrors.email ? 'border-destructive' : '',
              ]"
              placeholder="you@example.com"
              @update:modelValue="onInput('email')"
            />

            <span v-if="fieldErrors.email" class="absolute left-9 -bottom-5 text-xs text-destructive pointer-events-none">
              {{ fieldErrors.email }}
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
              v-model="form.password"
              @blur="onBlur('password')"
              :class="[
                'pl-9 pr-10',
                fieldErrors.password ? 'border-destructive' : '',
              ]"
              placeholder="Create a password"
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

            <span v-if="fieldErrors.password" class="absolute left-9 -bottom-5 text-xs text-destructive pointer-events-none">
              {{ fieldErrors.password }}
            </span>
          </div>
        </div>

        <div>
          <label for="confirmPassword" class="block text-sm font-medium text-foreground mb-2">Confirm Password</label>
          <div class="relative">
            <Lock class="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground w-4 h-4" />
            <Input
              id="confirmPassword"
              :type="showConfirmPassword ? 'text' : 'password'"
              v-model="form.confirm_password"
              @blur="onBlur('confirm_password')"
              :class="[
                'pl-9 pr-10',
                fieldErrors.confirm_password ? 'border-destructive' : '',
              ]"
              placeholder="Confirm your password"
              @update:modelValue="onInput('confirm_password')"
            />
            <Button
              type="button"
              variant="ghost"
              size="icon"
              class="absolute right-1 top-1/2 -translate-y-1/2"
              @click="showConfirmPassword = !showConfirmPassword"
            >
              <EyeOff v-if="showConfirmPassword" class="w-4 h-4" />
              <Eye v-else class="w-4 h-4" />
            </Button>

            <span v-if="fieldErrors.confirm_password" class="absolute left-9 -bottom-5 text-xs text-destructive pointer-events-none">
              {{ fieldErrors.confirm_password }}
            </span>
          </div>
        </div>

        <div class="flex items-start">
          <input type="checkbox" id="terms" class="w-4 h-4 border-input rounded-md mt-1" />
          <label for="terms" class="ml-2 text-sm text-muted-foreground">
            I agree to the <a href="#" class="text-foreground underline underline-offset-4">Terms of Service</a> and
            <a href="#" class="text-foreground underline underline-offset-4"> Privacy Policy</a>
          </label>
        </div>

        <Button type="submit" :disabled="loading || !isFormValid" class="w-full rounded-md">
          {{ loading ? 'Creating...' : 'Create Account' }}
        </Button>
        <p v-if="formError" class="text-destructive text-sm text-center">{{ formError }}</p>
        <p v-if="successMessage" class="text-foreground text-sm text-center">{{ successMessage }}</p>
        </form>

      <div class="mt-6 text-center">
        <p class="text-sm text-muted-foreground">
          Already have an account?
          <RouterLink to="/login" class="text-foreground underline underline-offset-4"> Sign in</RouterLink>
        </p>
      </div>
      </Card>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref, watch } from 'vue'
import { Eye, EyeOff, Lock, Mail, User } from 'lucide-vue-next'
import { register } from '../api/auth'
import { useRouter, RouterLink } from 'vue-router'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'

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
  const errors = {
    username: '',
    email: '',
    password: '',
    confirm_password: '',
  }

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
    errors.password = `Password must be at least ${PASSWORD_MIN} characters`
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
  return Object.values(errors).every((message) => !message)
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

function onInput(field: keyof typeof touched) {
  if (!touched[field]) return
  syncTouchedErrors()
}

watch(
  () => [form.username, form.email, form.password, form.confirm_password],
  () => {
    if (touched.username || touched.email || touched.password || touched.confirm_password) {
      syncTouchedErrors()
    }
  }
)

const submit = async () => {
  formError.value = ''
  successMessage.value = ''
  touched.username = true
  touched.email = true
  touched.password = true
  touched.confirm_password = true
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
    console.error('Registration failed:', err)
    formError.value = err?.detail || err?.message || 'Registration failed, please try again'
  } finally {
    loading.value = false
  }
}
</script>
