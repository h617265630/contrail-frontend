<template>
  <div class="mx-auto max-w-7xl px-4 py-8">
    <!-- Editorial header -->
    <div class="mb-8 pb-6 border-b border-stone-200">
      <div class="flex items-end justify-between">
        <div>
          <p class="text-[10px] font-bold uppercase tracking-[0.3em] text-amber-500 mb-2">Account</p>
          <h1 class="text-3xl md:text-4xl font-black tracking-tight text-stone-900 font-serif leading-tight">Your Account.</h1>
        </div>
        <RouterLink
          to="/home"
          class="hidden md:flex items-center gap-1.5 text-xs text-stone-400 hover:text-stone-600 transition-colors"
        >
          <span>← Back</span>
        </RouterLink>
      </div>
    </div>

    <div class="grid gap-8 lg:grid-cols-12">
      <!-- Sidebar: editorial nav -->
      <aside class="lg:col-span-3">
        <!-- User profile card -->
        <div class="mb-5 p-5 bg-stone-900 rounded-none">
          <div class="flex items-center gap-3 mb-4">
            <div class="w-11 h-11 shrink-0 overflow-hidden rounded-none border-2 border-amber-500/30">
              <img v-if="avatarUrl" :src="avatarUrl" :alt="displayName" referrerpolicy="no-referrer" class="h-full w-full rounded-none object-cover" />
              <div v-else class="h-full w-full flex items-center justify-center bg-amber-500 text-white text-sm font-bold">{{ initials }}</div>
            </div>
            <div class="min-w-0">
              <p class="font-bold text-white text-sm truncate">{{ displayName }}</p>
              <p class="text-[10px] text-stone-400 truncate">{{ email }}</p>
            </div>
          </div>
          <div class="w-8 h-px bg-amber-500/40 mb-4" />
          <nav class="space-y-0.5">
            <RouterLink
              v-for="item in navItems"
              :key="item.to"
              :to="item.to"
              class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-xs font-semibold transition-all duration-150 group"
              :class="isActive(item.to) ? 'bg-amber-500 text-stone-900' : 'text-stone-400 hover:text-stone-200 hover:bg-white/5'"
            >
              <span class="w-1.5 h-1.5 rounded-full shrink-0 transition-all" :class="isActive(item.to) ? 'bg-stone-900' : 'bg-stone-600 group-hover:bg-stone-400'" />
              {{ item.label }}
              <span v-if="isActive(item.to)" class="ml-auto">
                <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" class="text-stone-700"><polyline points="9 18 15 12 9 6"/></svg>
              </span>
            </RouterLink>
          </nav>
        </div>
        <!-- Back link -->
        <RouterLink to="/home" class="flex items-center gap-1.5 text-xs text-stone-500 hover:text-amber-500 transition-colors px-1">
          <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
          Back to home
        </RouterLink>
      </aside>

      <!-- Main content -->
      <main class="lg:col-span-9">
        <RouterView />
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { RouterLink, RouterView, useRoute } from 'vue-router'
import { storeToRefs } from 'pinia'
import { useAuthStore } from '../stores/auth'
import { getOrCreateDefaultAvatarForUser } from '../utils/avatars'
import { toBackendAbsoluteUrl } from '../utils/backendUrl'

const route = useRoute()
const authStore = useAuthStore()
const { user, isAuthed } = storeToRefs(authStore)

onMounted(() => {
  if (isAuthed.value) authStore.fetchProfile(true).catch(() => {})
})

const displayName = computed(() => (user.value as any)?.display_name || user.value?.username || 'User')
const email = computed(() => user.value?.email || '')
const initials = computed(() => displayName.value.slice(0, 2).toUpperCase())
const avatarUrl = computed(() => {
  const explicit = String((user.value as any)?.avatar_url || '').trim()
  if (explicit) return toBackendAbsoluteUrl(explicit)
  const uid = Number((user.value as any)?.id || 0)
  return uid ? getOrCreateDefaultAvatarForUser(uid) : ''
})

const navItems = [
  { label: 'My Resources', to: '/account/my-resources' },
  { label: 'My Paths', to: '/account/my-paths' },
  { label: 'User Info', to: '/account/user-info' },
  { label: 'Plan', to: '/account/plan' },
  { label: 'Change Password', to: '/account/change-password' },
]

function isActive(prefix: string) {
  return route.path.startsWith(prefix)
}
</script>
