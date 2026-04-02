<template>
  <div>
    <!-- Success -->
    <div v-if="success" class="mb-5 p-4 flex items-start gap-3 bg-emerald-50 border border-emerald-200 rounded-md">
      <div class="w-5 h-5 shrink-0 rounded-full bg-emerald-500 flex items-center justify-center mt-0.5">
        <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
      </div>
      <div>
        <p class="text-sm font-bold text-emerald-800">Password updated</p>
        <p class="text-xs text-emerald-600 mt-0.5">Your password has been changed successfully.</p>
      </div>
    </div>

    <!-- Error -->
    <div v-if="error" class="mb-5 p-4 flex items-start gap-3 bg-red-50 border border-red-200 rounded-md">
      <div class="w-5 h-5 shrink-0 rounded-full bg-red-500 flex items-center justify-center mt-0.5">
        <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
      </div>
      <p class="text-sm text-red-700">{{ error }}</p>
    </div>

    <!-- Form -->
    <div class="p-6 bg-white rounded-md border border-stone-100 shadow-sm">
      <div class="space-y-5">
        <div>
          <label class="block text-xs font-bold uppercase tracking-[0.15em] text-stone-500 mb-2.5">Current password</label>
          <div class="relative">
            <div class="absolute left-0 top-0 bottom-0 w-0.5 transition-all duration-200" :class="touched.current && !currentError ? 'bg-emerald-400' : currentError ? 'bg-red-400' : ''" />
            <input
              v-model="currentPassword"
              type="password"
              autocomplete="current-password"
              @blur="touched.current = true"
              class="w-full pl-4 pr-4 py-3 bg-white border border-stone-200 text-stone-900 text-sm placeholder:text-stone-400 outline-none focus:border-amber-400 focus:ring-2 focus:ring-amber-100 transition-all"
              placeholder="••••••••"
            />
          </div>
          <p v-if="currentError" class="mt-1.5 text-xs text-red-500">{{ currentError }}</p>
        </div>

        <div>
          <label class="block text-xs font-bold uppercase tracking-[0.15em] text-stone-500 mb-2.5">New password</label>
          <div class="relative">
            <div class="absolute left-0 top-0 bottom-0 w-0.5 transition-all duration-200" :class="touched.new && !newError ? 'bg-emerald-400' : newError ? 'bg-red-400' : ''" />
            <input
              v-model="newPassword"
              type="password"
              autocomplete="new-password"
              @blur="touched.new = true"
              class="w-full pl-4 pr-4 py-3 bg-white border border-stone-200 text-stone-900 text-sm placeholder:text-stone-400 outline-none focus:border-amber-400 focus:ring-2 focus:ring-amber-100 transition-all"
              placeholder="••••••••"
            />
          </div>
          <p v-if="newError" class="mt-1.5 text-xs text-red-500">{{ newError }}</p>
          <p v-else class="mt-1.5 text-xs text-stone-400">At least 8 characters, including letters and numbers.</p>
        </div>

        <div>
          <label class="block text-xs font-bold uppercase tracking-[0.15em] text-stone-500 mb-2.5">Confirm new password</label>
          <div class="relative">
            <div class="absolute left-0 top-0 bottom-0 w-0.5 transition-all duration-200" :class="touched.confirm && !confirmError ? 'bg-emerald-400' : confirmError ? 'bg-red-400' : ''" />
            <input
              v-model="confirmPassword"
              type="password"
              autocomplete="new-password"
              @blur="touched.confirm = true"
              class="w-full pl-4 pr-4 py-3 bg-white border border-stone-200 text-stone-900 text-sm placeholder:text-stone-400 outline-none focus:border-amber-400 focus:ring-2 focus:ring-amber-100 transition-all"
              placeholder="••••••••"
            />
          </div>
          <p v-if="confirmError" class="mt-1.5 text-xs text-red-500">{{ confirmError }}</p>
        </div>

        <div class="flex items-center gap-3 pt-2">
          <button
            type="button"
            class="px-5 py-2.5 border border-stone-200 text-stone-600 text-xs font-semibold hover:border-stone-300 hover:bg-stone-50 transition-all rounded-sm"
            :disabled="submitting"
            @click="reset"
          >
            Reset
          </button>
          <button
            type="button"
            class="px-5 py-2.5 bg-stone-900 text-white text-xs font-bold hover:bg-stone-800 disabled:opacity-40 disabled:cursor-not-allowed transition-all hover:-translate-y-px active:translate-y-0 rounded-sm"
            :disabled="submitting || !isValid"
            @click="onSubmit"
          >
            {{ submitting ? 'Saving…' : 'Update Password' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref } from 'vue'
import { changeMyPassword } from '../api/user'

const currentPassword = ref('')
const newPassword = ref('')
const confirmPassword = ref('')

const touched = reactive({ current: false, new: false, confirm: false })
const submitting = ref(false)
const error = ref('')
const success = ref(false)

function passwordRule(pwd: string) {
  const v = String(pwd || '')
  return v.length >= 8 && /[A-Za-z]/.test(v) && /\d/.test(v)
}

const currentError = computed(() => !currentPassword.value.trim() ? 'Current password is required.' : '')
const newError = computed(() => {
  if (!newPassword.value.trim()) return 'New password is required.'
  if (!passwordRule(newPassword.value)) return 'Must be at least 8 characters with letters and numbers.'
  if (newPassword.value === currentPassword.value) return 'Must be different from current password.'
  return ''
})
const confirmError = computed(() => {
  if (!confirmPassword.value.trim()) return 'Please confirm your new password.'
  if (confirmPassword.value !== newPassword.value) return 'Passwords do not match.'
  return ''
})
const isValid = computed(() => !currentError.value && !newError.value && !confirmError.value)

function reset() {
  currentPassword.value = ''
  newPassword.value = ''
  confirmPassword.value = ''
  touched.current = false
  touched.new = false
  touched.confirm = false
  error.value = ''
  success.value = false
}

async function onSubmit() {
  touched.current = true
  touched.new = true
  touched.confirm = true
  success.value = false
  error.value = ''
  if (!isValid.value) return

  submitting.value = true
  try {
    await changeMyPassword({ current_password: currentPassword.value, new_password: newPassword.value })
    success.value = true
    currentPassword.value = ''
    newPassword.value = ''
    confirmPassword.value = ''
    touched.current = false
    touched.new = false
    touched.confirm = false
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || 'Failed to change password')
  } finally {
    submitting.value = false
  }
}
</script>
