<template>
  <div class="space-y-6">
    <div>
      <h3 class="text-lg font-semibold text-foreground">Change Password</h3>
      <p class="mt-2 text-sm text-muted-foreground">Update your account password</p>
    </div>

    <div v-if="success" class="rounded-md border border-border bg-muted/30 p-4 text-sm text-foreground">
      Password updated successfully.
    </div>

    <div v-if="error" class="rounded-md border border-border bg-muted/30 p-4 text-sm text-destructive">
      {{ error }}
    </div>

    <Card as="section" :hoverable="false" class="rounded-md">
      <form class="space-y-4 p-6" @submit.prevent="onSubmit">
        <div class="space-y-1">
          <label class="text-sm font-semibold text-foreground">Current password</label>
          <Input
            v-model="currentPassword"
            type="password"
            autocomplete="current-password"
            class="rounded-md"
            @blur="touched.current = true"
          />
          <p v-if="showCurrentError" class="text-sm text-destructive">{{ currentError }}</p>
        </div>

        <div class="space-y-1">
          <label class="text-sm font-semibold text-foreground">New password</label>
          <Input
            v-model="newPassword"
            type="password"
            autocomplete="new-password"
            class="rounded-md"
            @blur="touched.new = true"
          />
          <p v-if="showNewError" class="text-sm text-destructive">{{ newError }}</p>
          <p class="text-xs text-muted-foreground">At least 8 characters, including letters and numbers.</p>
        </div>

        <div class="space-y-1">
          <label class="text-sm font-semibold text-foreground">Confirm new password</label>
          <Input
            v-model="confirmPassword"
            type="password"
            autocomplete="new-password"
            class="rounded-md"
            @blur="touched.confirm = true"
          />
          <p v-if="showConfirmError" class="text-sm text-destructive">{{ confirmError }}</p>
        </div>

        <div class="pt-2 flex items-center gap-2">
          <Button type="submit" class="rounded-md" :disabled="submitting || !isValid">
            {{ submitting ? 'Saving…' : 'Save' }}
          </Button>
          <Button type="button" variant="outline" class="rounded-md" :disabled="submitting" @click="reset">
            Reset
          </Button>
        </div>
      </form>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { computed, reactive, ref } from 'vue'
import { changeMyPassword } from '../api/user'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'

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
