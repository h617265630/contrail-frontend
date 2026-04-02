<template>
  <div>
    <!-- Section header -->
    <div class="mb-6">
      <p class="text-[10px] font-bold uppercase tracking-[0.3em] text-stone-400 mb-1.5">Account</p>
      <h2 class="text-2xl font-black text-stone-900 font-serif tracking-tight">User Info.</h2>
    </div>

    <!-- Avatar + identity block -->
    <div class="mb-8 p-6 bg-white rounded-md border border-stone-100 shadow-sm">
      <div class="flex items-center gap-4 mb-5">
        <div class="w-16 h-16 shrink-0 overflow-hidden rounded-none border-2 border-stone-100">
          <img v-if="avatarUrl" :src="avatarUrl" :alt="displayName" referrerpolicy="no-referrer" class="h-full w-full rounded-none object-cover" />
          <div v-else class="h-full w-full flex items-center justify-center bg-amber-500 text-white text-lg font-bold">{{ initials }}</div>
        </div>
        <div class="min-w-0">
          <p class="text-base font-bold text-stone-900 truncate">{{ displayName }}</p>
          <p class="text-sm text-stone-400 truncate">{{ email || '—' }}</p>
        </div>
      </div>
      <div class="grid gap-3 sm:grid-cols-2">
        <div class="px-4 py-3 bg-stone-50 rounded-sm border border-stone-100">
          <p class="text-[10px] font-bold uppercase tracking-[0.15em] text-stone-400 mb-1">Username</p>
          <p class="text-sm font-semibold text-stone-900 break-all">{{ username || '—' }}</p>
        </div>
        <div class="px-4 py-3 bg-stone-50 rounded-sm border border-stone-100">
          <p class="text-[10px] font-bold uppercase tracking-[0.15em] text-stone-400 mb-1">Email</p>
          <p class="text-sm font-semibold text-stone-900 break-all">{{ email || '—' }}</p>
        </div>
      </div>
    </div>

    <!-- Edit form -->
    <div class="p-6 bg-white rounded-md border border-stone-100 shadow-sm">
      <div class="space-y-5">
        <div>
          <label class="block text-xs font-bold uppercase tracking-[0.15em] text-stone-500 mb-2.5">Display name</label>
          <input
            v-model="form.display_name"
            type="text"
            class="w-full px-4 py-3 bg-white border border-stone-200 text-stone-900 text-sm placeholder:text-stone-400 outline-none focus:border-amber-400 focus:ring-2 focus:ring-amber-100 transition-all"
            placeholder="Your display name"
          />
        </div>

        <div>
          <label class="block text-xs font-bold uppercase tracking-[0.15em] text-stone-500 mb-2.5">Bio</label>
          <textarea
            v-model="form.bio"
            rows="4"
            class="w-full px-4 py-3 bg-white border border-stone-200 text-stone-900 text-sm placeholder:text-stone-400 outline-none focus:border-amber-400 focus:ring-2 focus:ring-amber-100 transition-all resize-none"
            placeholder="A short bio about yourself"
          />
        </div>

        <div>
          <label class="block text-xs font-bold uppercase tracking-[0.15em] text-stone-500 mb-2.5">Avatar</label>
          <div class="flex flex-col sm:flex-row gap-3 sm:items-center">
            <input ref="fileInputRef" type="file" accept="image/*" class="hidden" @change="onPickFile" />
            <button
              type="button"
              class="inline-flex items-center gap-2 px-4 py-2 border border-stone-200 text-stone-600 text-xs font-semibold hover:border-stone-300 hover:bg-stone-50 transition-all rounded-sm"
              @click="openFilePicker"
            >
              <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
              Choose image
            </button>
            <button
              type="button"
              class="inline-flex items-center gap-2 px-4 py-2 bg-amber-500 text-white text-xs font-semibold hover:bg-amber-600 disabled:opacity-40 disabled:cursor-not-allowed transition-all rounded-sm"
              :disabled="!pickedFile || avatarUploading"
              @click="uploadAvatar"
            >
              <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
              {{ avatarUploading ? 'Uploading…' : 'Upload' }}
            </button>
            <p v-if="pickedFileName" class="text-xs text-stone-400 break-all">{{ pickedFileName }}</p>
          </div>
        </div>

        <p v-if="error" class="text-xs text-red-500 py-2 px-3 border border-red-100 bg-red-50 rounded-sm">{{ error }}</p>

        <div class="flex items-center gap-3 pt-2">
          <button
            type="button"
            class="px-5 py-2.5 border border-stone-200 text-stone-600 text-xs font-semibold hover:border-stone-300 hover:bg-stone-50 transition-all rounded-sm"
            :disabled="saving"
            @click="resetForm"
          >
            Reset
          </button>
          <button
            type="button"
            class="px-5 py-2.5 bg-stone-900 text-white text-xs font-bold hover:bg-stone-800 disabled:opacity-40 disabled:cursor-not-allowed transition-all hover:-translate-y-px active:translate-y-0 rounded-sm"
            :disabled="saving"
            @click="save"
          >
            {{ saving ? 'Saving…' : 'Save Changes' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { storeToRefs } from 'pinia'
import { useAuthStore } from '../stores/auth'
import { getOrCreateDefaultAvatarForUser } from '../utils/avatars'
import { toBackendAbsoluteUrl } from '../utils/backendUrl'
import { updateCurrentUser, uploadMyAvatar } from '../api/user'

const authStore = useAuthStore()
const { user, isAuthed, avatarBuster } = storeToRefs(authStore)

onMounted(() => {
  if (isAuthed.value) authStore.fetchProfile(true).catch(() => {})
})

const displayName = computed(() => (user.value as any)?.display_name || user.value?.username || 'User')
const username = computed(() => user.value?.username || '')
const email = computed(() => user.value?.email || '')
const initials = computed(() => displayName.value.slice(0, 2).toUpperCase())
const avatarUrl = computed(() => {
  const explicit = String((user.value as any)?.avatar_url || '').trim()
  if (explicit) {
    const abs = toBackendAbsoluteUrl(explicit)
    const sep = abs.includes('?') ? '&' : '?'
    return `${abs}${sep}v=${avatarBuster.value}`
  }
  const uid = Number((user.value as any)?.id || 0)
  return uid ? getOrCreateDefaultAvatarForUser(uid) : ''
})

const form = ref({ display_name: '', bio: '' })
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
  pickedFile.value = input.files?.[0] || null
}

async function uploadAvatar() {
  if (!pickedFile.value) return
  error.value = ''
  avatarUploading.value = true
  try {
    await uploadMyAvatar(pickedFile.value)
    pickedFile.value = null
    authStore.bumpAvatarBuster()
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
    authStore.setUser({ ...(user.value as any), ...(next as any) })
    authStore.bumpAvatarBuster()
    await authStore.fetchProfile(true)
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || 'Failed to save')
  } finally {
    saving.value = false
  }
}

watch(
  () => user.value,
  () => { syncFormFromUser() },
  { immediate: true },
)
</script>
