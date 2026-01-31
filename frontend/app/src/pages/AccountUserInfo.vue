<template>
  <div class="space-y-6">
    <div>
      <h3 class="text-lg font-semibold text-foreground">User Info</h3>
      <p class="mt-2 text-sm text-muted-foreground">Basic profile information</p>
    </div>

    <Card as="section" :hoverable="false" class="rounded-md">
      <div class="p-6">
        <div class="flex items-center gap-4">
          <div class="h-14 w-14 overflow-hidden rounded-full border border-border bg-muted/30">
            <img v-if="avatarUrl" :src="avatarUrl" :alt="displayName" class="h-full w-full object-cover" />
            <div v-else class="flex h-full w-full items-center justify-center text-foreground font-semibold">
              {{ initials }}
            </div>
          </div>

          <div class="min-w-0">
            <p class="text-base font-semibold text-foreground truncate">{{ displayName }}</p>
            <p class="text-sm text-muted-foreground truncate">{{ email || '—' }}</p>
          </div>
        </div>

        <div class="mt-5 grid gap-3 sm:grid-cols-2">
          <div class="rounded-md border border-border bg-muted/30 p-4">
            <p class="text-xs font-semibold text-muted-foreground">Username</p>
            <p class="mt-1 text-sm font-semibold text-foreground break-all">{{ username || '—' }}</p>
          </div>
          <div class="rounded-md border border-border bg-muted/30 p-4">
            <p class="text-xs font-semibold text-muted-foreground">Email</p>
            <p class="mt-1 text-sm font-semibold text-foreground break-all">{{ email || '—' }}</p>
          </div>
        </div>

        <div class="mt-5 space-y-4">
          <div>
            <label class="block text-sm font-semibold text-foreground mb-2">Display name</label>
            <Input v-model="form.display_name" type="text" class="h-10 rounded-md" placeholder="Your name" />
          </div>

          <div>
            <label class="block text-sm font-semibold text-foreground mb-2">Bio</label>
            <textarea
              v-model="form.bio"
              rows="4"
              class="w-full px-3 py-2 rounded-md border border-border bg-background text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 focus:ring-offset-background"
              placeholder="A short bio"
            />
          </div>

          <div>
            <label class="block text-sm font-semibold text-foreground mb-2">Avatar</label>
            <div class="flex flex-col sm:flex-row gap-3 sm:items-center">
              <input
                ref="fileInputRef"
                type="file"
                accept="image/*"
                class="hidden"
                @change="onPickFile"
              />
              <Button type="button" variant="outline" size="sm" class="rounded-md" @click="openFilePicker">
                Choose image
              </Button>
              <Button
                type="button"
                variant="outline"
                size="sm"
                class="rounded-md bg-[#8ecbff] text-white hover:bg-[#8ecbff]/90 hover:text-white disabled:opacity-50 disabled:cursor-not-allowed"
                :disabled="!pickedFile || avatarUploading"
                @click="uploadAvatar"
              >
                {{ avatarUploading ? 'Uploading…' : 'Upload' }}
              </Button>
              <p v-if="pickedFileName" class="text-xs text-muted-foreground break-all">{{ pickedFileName }}</p>
            </div>
          </div>

          <p v-if="error" class="text-sm text-red-600">{{ error }}</p>

          <div class="flex justify-end gap-2">
            <Button type="button" variant="outline" size="sm" class="rounded-md" :disabled="saving" @click="resetForm">
              Reset
            </Button>
            <Button
              type="button"
              variant="outline"
              size="sm"
              class="rounded-md bg-[#8ecbff] text-white hover:bg-[#8ecbff]/90 hover:text-white disabled:opacity-50 disabled:cursor-not-allowed"
              :disabled="saving"
              @click="save"
            >
              {{ saving ? 'Saving…' : 'Save changes' }}
            </Button>
          </div>
        </div>
      </div>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { storeToRefs } from 'pinia'
import { useAuthStore } from '../stores/auth'
import { getOrCreateDefaultAvatarForUser } from '../utils/avatars'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import { updateCurrentUser, uploadMyAvatar } from '../api/user'

const authStore = useAuthStore()
const { user, isAuthed } = storeToRefs(authStore)

onMounted(() => {
  if (isAuthed.value) authStore.fetchProfile(true).catch(() => {})
})

const displayName = computed(() => (user.value as any)?.display_name || user.value?.username || 'User')
const username = computed(() => user.value?.username || '')
const email = computed(() => user.value?.email || '')
const initials = computed(() => displayName.value.slice(0, 2).toUpperCase())
const avatarUrl = computed(() => {
  const explicit = String((user.value as any)?.avatar_url || '').trim()
  if (explicit) return explicit
  const uid = Number((user.value as any)?.id || 0)
  return uid ? getOrCreateDefaultAvatarForUser(uid) : ''
})

const form = ref({
  display_name: '' as string,
  bio: '' as string,
})

const saving = ref(false)
const avatarUploading = ref(false)
const error = ref('')

const fileInputRef = ref<HTMLInputElement | null>(null)
const pickedFile = ref<File | null>(null)
const pickedFileName = computed(() => pickedFile.value?.name || '')

function syncFormFromUser() {
  form.value = {
    display_name: String((user.value as any)?.display_name || ''),
    bio: String((user.value as any)?.bio || ''),
  }
}

function resetForm() {
  error.value = ''
  pickedFile.value = null
  syncFormFromUser()
}

function openFilePicker() {
  fileInputRef.value?.click()
}

function onPickFile(e: Event) {
  const input = e.target as HTMLInputElement
  const file = input.files?.[0] || null
  pickedFile.value = file
}

async function uploadAvatar() {
  if (!pickedFile.value) return
  error.value = ''
  avatarUploading.value = true
  try {
    await uploadMyAvatar(pickedFile.value)
    pickedFile.value = null
    await authStore.fetchProfile(true)
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || 'Failed to upload avatar')
  } finally {
    avatarUploading.value = false
  }
}

async function save() {
  error.value = ''
  saving.value = true
  try {
    const next = await updateCurrentUser({
      display_name: form.value.display_name,
      bio: form.value.bio,
    })
    authStore.setUser(next as any)
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || 'Failed to save')
  } finally {
    saving.value = false
  }
}

watch(
  () => user.value,
  () => {
    syncFormFromUser()
  },
  { immediate: true },
)
</script>
