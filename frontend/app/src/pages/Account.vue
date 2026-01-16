<template>
  <div class="min-h-screen bg-slate-50">
    <div class="max-w-7xl mx-auto p-6">
      <div class="grid gap-6 lg:grid-cols-12">
        <aside class="lg:col-span-3">
          <div class="rounded-2xl bg-white p-4 shadow-sm border border-slate-100">
            <div class="flex items-center gap-3">
              <div class="h-12 w-12 overflow-hidden rounded-full border border-slate-200 bg-slate-50">
                <img v-if="avatarUrl" :src="avatarUrl" :alt="displayName" class="h-full w-full object-cover" />
                <div v-else class="h-full w-full flex items-center justify-center text-slate-700 font-semibold">
                  {{ initials }}
                </div>
              </div>
              <div class="min-w-0">
                <p class="font-semibold text-slate-900 truncate">{{ displayName }}</p>
                <p class="text-xs text-slate-500 truncate">{{ email }}</p>
              </div>
            </div>

            <div class="mt-4 space-y-2">
              <RouterLink
                to="/account/my-resources"
                class="block rounded-xl px-3 py-2 text-sm font-semibold"
                :class="isActive('/account/my-resources') ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
              >
                My Resources
              </RouterLink>
              <RouterLink
                to="/account/my-paths"
                class="block rounded-xl px-3 py-2 text-sm font-semibold"
                :class="isActive('/account/my-paths') ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
              >
                My Paths
              </RouterLink>
              <RouterLink
                to="/account/user-info"
                class="block rounded-xl px-3 py-2 text-sm font-semibold"
                :class="isActive('/account/user-info') ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
              >
                User Info
              </RouterLink>
              <RouterLink
                to="/account/plan"
                class="block rounded-xl px-3 py-2 text-sm font-semibold"
                :class="isActive('/account/plan') ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
              >
                Plan
              </RouterLink>
              <RouterLink
                to="/account/change-password"
                class="block rounded-xl px-3 py-2 text-sm font-semibold"
                :class="isActive('/account/change-password') ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
              >
                Change Password
              </RouterLink>
            </div>
          </div>
        </aside>

        <main class="lg:col-span-9">
          <RouterView />
        </main>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { RouterLink, RouterView, useRoute } from 'vue-router'
import { storeToRefs } from 'pinia'
import { useAuthStore } from '../stores/auth'
import { getOrCreateDefaultAvatarForUser } from '../utils/avatars'

const route = useRoute()
const authStore = useAuthStore()
const { user, isAuthed } = storeToRefs(authStore)

onMounted(() => {
  // Ensure profile is available when refreshing the page.
  if (isAuthed.value) authStore.fetchProfile(true).catch(() => {})
})

const displayName = computed(() => (user.value as any)?.display_name || user.value?.username || 'User')
const email = computed(() => user.value?.email || '')
const initials = computed(() => displayName.value.slice(0, 2).toUpperCase())
const avatarUrl = computed(() => {
  const explicit = String((user.value as any)?.avatar_url || '').trim()
  if (explicit) return explicit
  const uid = Number((user.value as any)?.id || 0)
  return uid ? getOrCreateDefaultAvatarForUser(uid) : ''
})

function isActive(prefix: string) {
  return route.path.startsWith(prefix)
}
</script>
