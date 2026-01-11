<template>
  <div class="space-y-4">
    <div class="rounded-2xl bg-white p-5 shadow-sm border border-slate-100">
      <h1 class="text-xl font-semibold text-slate-900">Change Password</h1>
      <p class="text-sm text-slate-600 mt-1">Update your account password</p>
    </div>

    <div v-if="success" class="rounded-2xl border border-emerald-200 bg-emerald-50 p-4 text-emerald-700">
      Password updated successfully.
    </div>

    <div v-if="error" class="rounded-2xl border border-red-200 bg-red-50 p-4 text-red-700">
      {{ error }}
    </div>

    <form class="rounded-2xl bg-white p-6 shadow-sm border border-slate-100 space-y-4" @submit.prevent="onSubmit">
      <div class="space-y-1">
        <label class="text-sm font-semibold text-slate-700">Current password</label>
        <input
          v-model="currentPassword"
          type="password"
          autocomplete="current-password"
          class="w-full rounded-lg border border-slate-200 px-3 py-2 text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-500"
          @blur="touched.current = true"
        />
        <p v-if="showCurrentError" class="text-sm text-red-600">{{ currentError }}</p>
      </div>

      <div class="space-y-1">
        <label class="text-sm font-semibold text-slate-700">New password</label>
        <input
          v-model="newPassword"
          type="password"
          autocomplete="new-password"
          class="w-full rounded-lg border border-slate-200 px-3 py-2 text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-500"
          @blur="touched.new = true"
        />
        <p v-if="showNewError" class="text-sm text-red-600">{{ newError }}</p>
        <p class="text-xs text-slate-500">At least 8 characters, including letters and numbers.</p>
      </div>

      <div class="space-y-1">
        <label class="text-sm font-semibold text-slate-700">Confirm new password</label>
        <input
          v-model="confirmPassword"
          type="password"
          autocomplete="new-password"
          class="w-full rounded-lg border border-slate-200 px-3 py-2 text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-500"
          @blur="touched.confirm = true"
        />
        <p v-if="showConfirmError" class="text-sm text-red-600">{{ confirmError }}</p>
      </div>

      <div class="pt-2 flex items-center gap-3">
        <button
          type="submit"
          class="inline-flex items-center justify-center rounded-lg bg-blue-600 px-4 py-2 text-white font-semibold hover:bg-blue-700 disabled:opacity-50"
          :disabled="submitting || !isValid"
        >
          {{ submitting ? 'Saving…' : 'Save' }}
        </button>
        <button
          type="button"
          class="inline-flex items-center justify-center rounded-lg bg-slate-100 px-4 py-2 text-slate-800 font-semibold hover:bg-slate-200"
          :disabled="submitting"
          @click="reset"
        >
          Reset
        </button>
      </div>
    </form>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref } from 'vue'
import { changeMyPassword } from '../api/user'

const currentPassword = ref('')
const newPassword = ref('')
const confirmPassword = ref('')

const touched = reactive({
  current: false,
  new: false,
  confirm: false,
})

const submitting = ref(false)
const error = ref('')
const success = ref(false)

function passwordRule(pwd: string) {
  const v = String(pwd || '')
  const hasLetter = /[A-Za-z]/.test(v)
  const hasDigit = /\d/.test(v)
  return v.length >= 8 && hasLetter && hasDigit
}

const currentError = computed(() => {
  if (!currentPassword.value.trim()) return 'Current password is required.'
  return ''
})

const newError = computed(() => {
  if (!newPassword.value.trim()) return 'New password is required.'
  if (!passwordRule(newPassword.value)) return 'New password must be at least 8 characters and include letters and numbers.'
  if (newPassword.value === currentPassword.value) return 'New password must be different from current password.'
  return ''
})

const confirmError = computed(() => {
  if (!confirmPassword.value.trim()) return 'Please confirm your new password.'
  if (confirmPassword.value !== newPassword.value) return 'Passwords do not match.'
  return ''
})

const isValid = computed(() => !currentError.value && !newError.value && !confirmError.value)

const showCurrentError = computed(() => touched.current && !!currentError.value)
const showNewError = computed(() => touched.new && !!newError.value)
const showConfirmError = computed(() => touched.confirm && !!confirmError.value)

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
    await changeMyPassword({
      current_password: currentPassword.value,
      new_password: newPassword.value,
    })
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
