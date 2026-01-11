<template>
  <div class="space-y-4">
    <div class="rounded-2xl bg-white p-5 shadow-sm border border-slate-100">
      <h1 class="text-xl font-semibold text-slate-900">User Info</h1>
      <p class="text-sm text-slate-600 mt-1">Basic profile information</p>
    </div>

    <div class="rounded-2xl bg-white p-6 shadow-sm border border-slate-100">
      <div class="flex items-center gap-4">
        <div class="h-14 w-14 overflow-hidden rounded-full border border-slate-200 bg-slate-50">
          <img v-if="avatarUrl" :src="avatarUrl" :alt="displayName" class="h-full w-full object-cover" />
          <div v-else class="h-full w-full flex items-center justify-center text-slate-700 font-semibold">
            {{ initials }}
          </div>
        </div>

        <div class="min-w-0">
          <p class="text-base font-semibold text-slate-900 truncate">{{ displayName }}</p>
          <p class="text-sm text-slate-600 truncate">{{ email || '—' }}</p>
        </div>
      </div>

      <div class="mt-5 grid gap-3 sm:grid-cols-2">
        <div class="rounded-xl border border-slate-100 bg-slate-50 p-4">
          <p class="text-xs font-semibold text-slate-500">Username</p>
          <p class="mt-1 text-sm font-semibold text-slate-900 break-all">{{ username || '—' }}</p>
        </div>
        <div class="rounded-xl border border-slate-100 bg-slate-50 p-4">
          <p class="text-xs font-semibold text-slate-500">Email</p>
          <p class="mt-1 text-sm font-semibold text-slate-900 break-all">{{ email || '—' }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { storeToRefs } from 'pinia'
import { useAuthStore } from '../stores/auth'
import { getOrCreateDefaultAvatarForUser } from '../utils/avatars'

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
</script>
