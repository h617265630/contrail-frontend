<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section v-if="!isUserInfoPage" class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Account</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">管理个人信息、资源与学习路径。</p>
        </div>
      </div>
    </section>

    <section>
      <div class="grid gap-6 lg:grid-cols-12">
        <aside class="lg:col-span-3">
          <Card className="rounded-none" :hoverable="false" padded>
            <div class="flex items-center gap-3">
              <div class="h-12 w-12 shrink-0 overflow-hidden rounded-full border border-border bg-muted/30">
                <img v-if="avatarUrl" :src="avatarUrl" :alt="displayName" referrerpolicy="no-referrer" class="h-full w-full rounded-full object-cover" />
                <div v-else class="h-full w-full flex items-center justify-center text-foreground font-semibold">
                  {{ initials }}
                </div>
              </div>
              <div class="min-w-0">
                <p class="font-semibold text-foreground truncate">{{ displayName }}</p>
                <p class="text-xs text-muted-foreground truncate">{{ email }}</p>
              </div>
            </div>

            <div class="mt-4 space-y-2">
              <RouterLink
                to="/account/my-resources"
                class="block px-3 py-2 text-sm font-semibold rounded-none"
                :class="isActive('/account/my-resources') ? 'bg-foreground text-background' : 'text-foreground hover:bg-muted/30'"
              >
                My Resources
              </RouterLink>
              <RouterLink
                to="/account/my-paths"
                class="block px-3 py-2 text-sm font-semibold rounded-none"
                :class="isActive('/account/my-paths') ? 'bg-foreground text-background' : 'text-foreground hover:bg-muted/30'"
              >
                My Paths
              </RouterLink>
              <RouterLink
                to="/account/user-info"
                class="block px-3 py-2 text-sm font-semibold rounded-none"
                :class="isActive('/account/user-info') ? 'bg-foreground text-background' : 'text-foreground hover:bg-muted/30'"
              >
                User Info
              </RouterLink>
              <RouterLink
                to="/account/plan"
                class="block px-3 py-2 text-sm font-semibold rounded-none"
                :class="isActive('/account/plan') ? 'bg-foreground text-background' : 'text-foreground hover:bg-muted/30'"
              >
                Plan
              </RouterLink>
              <RouterLink
                to="/account/change-password"
                class="block px-3 py-2 text-sm font-semibold rounded-none"
                :class="isActive('/account/change-password') ? 'bg-foreground text-background' : 'text-foreground hover:bg-muted/30'"
              >
                Change Password
              </RouterLink>
            </div>
          </Card>
        </aside>

        <main class="lg:col-span-9 space-y-4">
          <Card className="rounded-none" :hoverable="false" padded>
            <RouterView />
          </Card>
        </main>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { RouterLink, RouterView, useRoute } from 'vue-router'
import { storeToRefs } from 'pinia'
import { useAuthStore } from '../stores/auth'
import { getOrCreateDefaultAvatarForUser } from '../utils/avatars'
import Card from '../components/ui/Card.vue'

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
  if (explicit) {
    const abs = explicit.startsWith('http://') || explicit.startsWith('https://')
      ? explicit
      : `http://localhost:8000${explicit.startsWith('/') ? '' : '/'}${explicit}`
    return abs
  }
  const uid = Number((user.value as any)?.id || 0)
  return uid ? getOrCreateDefaultAvatarForUser(uid) : ''
})

const isUserInfoPage = computed(() => route.path.startsWith('/account/user-info'))

function isActive(prefix: string) {
  return route.path.startsWith(prefix)
}
</script>
