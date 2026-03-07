<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8 -mt-4 md:-mt-6">
    <section class="border-b border-border pb-4">
      <nav aria-label="Breadcrumb" class="text-xs text-muted-foreground">
        <ol class="flex items-center gap-2">
          <li v-for="(item, idx) in breadcrumbItems" :key="`${idx}-${item.label}`" class="flex items-center gap-2">
            <RouterLink
              v-if="item.to && idx !== breadcrumbItems.length - 1"
              :to="item.to"
              class="hover:text-foreground"
            >
              {{ item.label }}
            </RouterLink>
            <span v-else class="text-foreground font-semibold">{{ item.label }}</span>
            <span v-if="idx !== breadcrumbItems.length - 1" class="text-muted-foreground">/</span>
          </li>
        </ol>
      </nav>
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
import { toBackendAbsoluteUrl } from '../utils/backendUrl'
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
    return toBackendAbsoluteUrl(explicit)
  }
  const uid = Number((user.value as any)?.id || 0)
  return uid ? getOrCreateDefaultAvatarForUser(uid) : ''
})

type BreadcrumbItem = { label: string; to?: string }

const breadcrumbItems = computed<BreadcrumbItem[]>(() => {
  const base: BreadcrumbItem[] = [{ label: 'Account', to: '/account/user-info' }]
  const p = String(route.path || '')
  if (p.startsWith('/account/my-resources')) return [...base, { label: 'My Resources' }]
  if (p.startsWith('/account/my-paths')) return [...base, { label: 'My Paths' }]
  if (p.startsWith('/account/user-info')) return [...base, { label: 'User Info' }]
  if (p.startsWith('/account/plan')) return [...base, { label: 'Plan' }]
  if (p.startsWith('/account/change-password')) return [...base, { label: 'Change Password' }]
  return base
})

function isActive(prefix: string) {
  return route.path.startsWith(prefix)
}
</script>
