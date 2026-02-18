<template>
  <header class="fixed top-0 left-0 right-0 z-30 border-b border-border bg-background">
    <div class="mx-auto flex h-14 max-w-7xl items-center gap-10 px-4">
      <RouterLink to="/home" class="flex shrink-0 items-center gap-2 font-semibold text-foreground">
        <img
          src="/favicon.svg"
          alt="Contrail"
          class="h-9 w-9 rounded-sm"
        />
        <span class="brand-wordmark text-lg text-foreground">
          <span class="font-semibold">Contrail</span>
        </span>
      </RouterLink>
      <nav class="hidden md:flex items-center gap-6 text-[11px] font-medium tracking-[0.16em] text-muted-foreground uppercase">
        <Button
          :as="RouterLinkComp"
          to="/learningpool"
          variant="ghost"
          size="sm"
          class="h-9 rounded-none px-0 py-0 hover:bg-transparent border-b-2 text-[11px]"
          :class="isActive('/learningpool') ? 'text-foreground border-foreground' : 'border-transparent hover:text-foreground hover:border-foreground/30'"
        >
          LearningPool
        </Button>
        <Button
          :as="RouterLinkComp"
          to="/notification"
          variant="ghost"
          size="sm"
          class="h-9 rounded-none px-0 py-0 hover:bg-transparent border-b-2 text-[11px]"
          :class="isActive('/notification') ? 'text-foreground border-foreground' : 'border-transparent hover:text-foreground hover:border-foreground/30'"
        >
          Notification
        </Button>
        <Button
          :as="RouterLinkComp"
          to="/about"
          variant="ghost"
          size="sm"
          class="h-9 rounded-none px-0 py-0 hover:bg-transparent border-b-2 text-[11px]"
          :class="isActive('/about') ? 'text-foreground border-foreground' : 'border-transparent hover:text-foreground hover:border-foreground/30'"
        >
          About
        </Button>
        <Button
          :as="RouterLinkComp"
          to="/plan"
          variant="ghost"
          size="sm"
          class="h-9 rounded-none px-0 py-0 hover:bg-transparent border-b-2 text-[11px]"
          :class="isActive('/plan') ? 'text-foreground border-foreground' : 'border-transparent hover:text-foreground hover:border-foreground/30'"
        >
          Plan
        </Button>
        <Button
          :as="RouterLinkComp"
          to="/resources"
          variant="ghost"
          size="sm"
          class="h-9 rounded-none px-0 py-0 hover:bg-transparent border-b-2 text-[11px]"
          :class="isActive('/resources') ? 'text-foreground border-primary' : 'border-transparent hover:text-foreground hover:border-foreground/30'"
        >
          <Library class="h-4 w-4" />
          Resources
        </Button>
      </nav>

      <div class="ml-auto flex items-center gap-3">
        <div class="relative hidden lg:block">
          <Button
            type="button"
            variant="ghost"
            size="icon"
            class="absolute left-0 top-1/2 -translate-y-1/2 h-9 w-9 rounded-none border-0 bg-transparent text-muted-foreground hover:text-foreground hover:bg-transparent"
            @click="handleSearch"
            :aria-label="t('Search')"
          >
            <Search class="h-4 w-4" />
          </Button>
          <Input
            v-model="searchQuery"
            type="search"
            :placeholder="t('Search...')"
            aria-label="Search"
            class="h-9 w-56 rounded-none border-0 border-b border-input bg-transparent pl-9 pr-0 shadow-none focus-visible:ring-0 focus-visible:ring-offset-0"
            @keyup.enter="handleSearch"
          />
        </div>

        <Button
          type="button"
          variant="ghost"
          size="icon"
          class="hidden md:inline-flex h-9 w-9 rounded-none border-0 bg-transparent text-foreground hover:bg-transparent hover:text-foreground/80"
          :aria-label="theme === 'dark' ? 'Switch to light mode' : 'Switch to dark mode'"
          @click="toggleTheme"
        >
          <Sun v-if="theme === 'dark'" class="h-5 w-5" />
          <Moon v-else class="h-5 w-5" />
        </Button>

        <div
          v-if="isAuthed"
          class="relative hidden md:block"
          @mouseenter="openDesktopMenu"
          @mouseleave="scheduleDesktopMenuClose"
        >
          <Button
            type="button"
            variant="ghost"
            size="sm"
            class="h-9 rounded-none border-0 bg-transparent px-1 py-1 text-left font-semibold hover:bg-transparent"
            :aria-label="t('User menu')"
          >
            <div class="h-8 w-8 shrink-0 overflow-hidden rounded-full">
              <img v-if="avatarUrl" :src="avatarUrl" :alt="displayName" referrerpolicy="no-referrer" class="h-full w-full rounded-full object-cover" />
              <div v-else class="flex h-full w-full items-center justify-center bg-linear-to-r from-blue-500 to-indigo-500 text-white text-xs">
                {{ userInitials }}
              </div>
            </div>
            <ChevronDown class="h-4 w-4 text-muted-foreground transition-transform" :class="desktopMenuOpen ? 'rotate-180' : ''" />
          </Button>

          <div
            v-if="desktopMenuOpen"
            class="absolute right-0 mt-2 w-60 rounded-xl border border-border bg-background p-3 shadow-xl"
            @mouseenter="openDesktopMenu"
            @mouseleave="scheduleDesktopMenuClose"
          >
            <div class="flex items-center gap-3 rounded-xl border border-border bg-background p-3">
              <div class="h-12 w-12 shrink-0 overflow-hidden rounded-full shadow">
                <img v-if="avatarUrl" :src="avatarUrl" :alt="displayName" referrerpolicy="no-referrer" class="h-full w-full rounded-full object-cover" />
                <div
                  v-else
                  class="flex h-full w-full items-center justify-center bg-linear-to-r from-blue-500 to-indigo-500 text-white text-lg"
                >
                  {{ userInitials }}
                </div>
              </div>
              <div>
                <p class="text-base font-semibold text-foreground">{{ displayName }}</p>
                <p class="text-xs text-muted-foreground">{{ userEmail }}</p>
              </div>
            </div>
            <div class="mt-3 flex flex-col text-sm text-foreground">
              <RouterLink
                to="/account/user-info"
                class="flex items-center justify-between rounded-xl px-3 py-2 transition-colors hover:bg-accent hover:text-accent-foreground"
              >
                <span>Account</span>
                <span class="text-xs text-muted-foreground">Go</span>
              </RouterLink>
              <RouterLink
                to="/my-resources"
                class="flex items-center justify-between rounded-xl px-3 py-2 transition-colors hover:bg-accent hover:text-accent-foreground"
              >
                <span>{{ t('My Resources') }}</span>
                <span class="text-xs text-muted-foreground">Hot</span>
              </RouterLink>
              <RouterLink
                to="/my-paths"
                class="flex items-center justify-between rounded-xl px-3 py-2 transition-colors hover:bg-accent hover:text-accent-foreground"
              >
                <span>{{ t('My Paths') }}</span>
                <span class="text-xs text-muted-foreground">Go</span>
              </RouterLink>
              <RouterLink
                to="/partical"
                class="flex items-center justify-between rounded-xl px-3 py-2 transition-colors hover:bg-accent hover:text-accent-foreground"
              >
                <span>Partical</span>
                <span class="text-xs text-muted-foreground">Go</span>
              </RouterLink>
              <RouterLink
                to="/tools"
                class="flex items-center justify-between rounded-xl px-3 py-2 transition-colors hover:bg-accent hover:text-accent-foreground"
              >
                <span>Tools</span>
                <span class="text-xs text-muted-foreground">DB</span>
              </RouterLink>
              <RouterLink
                to="/creator"
                class="flex items-center justify-between rounded-xl px-3 py-2 transition-colors hover:bg-accent hover:text-accent-foreground"
              >
                <span>{{ t('Creator Center') }}</span>
                <span class="text-xs text-muted-foreground">Beta</span>
              </RouterLink>
            </div>
            <button
              type="button"
              class="mt-3 flex w-full items-center justify-between rounded-xl border border-border bg-background px-3 py-2 text-sm font-semibold text-red-500 transition-colors hover:bg-red-500/10"
              @click="handleLogout"
            >
              {{ t('Log out') }}
              <LogOut class="h-4 w-4" />
            </button>
          </div>
        </div>
        <Button
          v-else
          :as="RouterLinkComp"
          to="/login"
          variant="ghost"
          size="sm"
          class="hidden md:inline-flex h-9 rounded-none px-0 py-0 hover:bg-transparent text-xs font-medium tracking-[0.14em] uppercase text-muted-foreground hover:text-foreground"
        >
          Login
        </Button>

        <div ref="createMenuRef" class="relative hidden md:inline-flex">
          <Button
            type="button"
            variant="ghost"
            size="sm"
            class="h-9 rounded-full border border-border px-3 text-xs font-medium tracking-[0.14em] uppercase text-white shadow-sm transition-colors"
            :class="createMenuOpen
              ? 'bg-[#8ecbff]/80 hover:bg-[#8ecbff]/80'
              : 'bg-[#8ecbff] hover:bg-[#8ecbff]/90'"
            @click="createMenuOpen = !createMenuOpen"
          >
            <span><span class="font-bold">+</span>CREATE</span>
          </Button>

          <div
            v-if="createMenuOpen"
            class="absolute left-0 top-full mt-0 w-56 rounded-md border border-border bg-background p-1 shadow-xl"
          >
            <RouterLink
              class="flex w-full items-center gap-3 rounded-md border border-transparent px-3 py-2 text-sm text-foreground transition-colors hover:bg-muted/30 active:bg-muted/60"
              to="/createpath"
              @click="createMenuOpen = false"
            >
              <Plus class="h-4 w-4" />
              <span>{{ t('Create path') }}</span>
            </RouterLink>
            <RouterLink
              class="flex w-full items-center gap-3 rounded-md border border-transparent px-3 py-2 text-sm text-foreground transition-colors hover:bg-muted/30 active:bg-muted/60"
              to="/my-resources/add"
              @click="createMenuOpen = false"
            >
              <Library class="h-4 w-4" />
              <span>Add resource</span>
            </RouterLink>
            <RouterLink
              class="flex w-full items-center gap-3 rounded-md border border-transparent px-3 py-2 text-sm text-foreground transition-colors hover:bg-muted/30 active:bg-muted/60"
              to="/creator?tab=markdown"
              @click="createMenuOpen = false"
            >
              <PenLine class="h-4 w-4" />
              <span>Write note</span>
            </RouterLink>
          </div>
        </div>

        <div ref="langMenuRef" class="relative">
          <Button
            type="button"
            variant="ghost"
            size="icon"
            class="hidden md:inline-flex h-9 w-9 rounded-none border-0 bg-transparent text-foreground hover:bg-transparent hover:text-foreground/80"
            :aria-label="t('Language')"
            @click="langMenuOpen = !langMenuOpen"
          >
            <Globe class="h-5 w-5" />
          </Button>

          <div
            v-if="langMenuOpen"
            class="absolute right-0 mt-2 w-44 rounded-xl border border-border bg-background p-2 shadow-xl"
          >
            <button
              v-for="opt in languages"
              :key="opt.code"
              type="button"
              class="flex w-full items-center justify-between rounded-xl px-3 py-2 text-sm text-foreground transition-colors hover:bg-accent hover:text-accent-foreground"
              @click="selectLang(opt.code)"
            >
              <span>{{ opt.label }}</span>
              <span v-if="lang === opt.code" class="text-xs text-primary">✓</span>
            </button>
          </div>
        </div>

        <Button
          type="button"
          variant="outline"
          size="icon"
          class="inline-flex md:hidden h-9 w-9 rounded-none"
          :aria-label="open ? 'Close menu' : 'Open menu'"
          @click="open = !open"
        >
          <X v-if="open" class="h-5 w-5" />
          <Menu v-else class="h-5 w-5" />
        </Button>
      </div>
    </div>
  </header>
  <div v-if="open" class="md:hidden border-b border-border bg-background">
    <div class="mx-auto max-w-7xl px-4 py-3">
      <div class="flex flex-col gap-2 text-xs font-medium tracking-[0.14em] uppercase text-muted-foreground">
        <RouterLink class="py-2 hover:text-foreground" to="/home" @click="open = false">Home</RouterLink>
        <RouterLink class="py-2 hover:text-foreground" to="/learningpool" @click="open = false">LearningPool</RouterLink>
        <RouterLink class="py-2 hover:text-foreground" to="/notification" @click="open = false">Notification</RouterLink>
        <RouterLink class="py-2 hover:text-foreground" to="/about" @click="open = false">About</RouterLink>
        <RouterLink class="py-2 hover:text-foreground" to="/plan" @click="open = false">Plan</RouterLink>
        <RouterLink class="py-2 hover:text-foreground" to="/resources" @click="open = false">Resources</RouterLink>
        <div class="my-1 h-px bg-border"></div>
        <RouterLink class="py-2 hover:text-foreground" to="/createpath" @click="open = false">{{ t('CreatePath') }}</RouterLink>
        <RouterLink class="py-2 hover:text-foreground" to="/my-resources/add" @click="open = false">Add resource</RouterLink>
        <RouterLink class="py-2 hover:text-foreground" to="/creator?tab=markdown" @click="open = false">Write note</RouterLink>
        <RouterLink v-if="!isAuthed" class="py-2 hover:text-foreground" to="/login" @click="open = false">Login</RouterLink>
        <button
          type="button"
          class="mt-1 inline-flex items-center justify-between border border-border bg-background px-3 py-2 text-foreground"
          @click="toggleTheme"
        >
          <span>{{ theme === 'dark' ? 'Light mode' : 'Dark mode' }}</span>
          <Sun v-if="theme === 'dark'" class="h-4 w-4" />
          <Moon v-else class="h-4 w-4" />
        </button>
      </div>
    </div>
  </div>
  <!-- spacer to prevent fixed header from covering page content -->
  <div class="h-16 md:h-16"></div>
</template>

<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import { Library, Plus, Search, User, ChevronDown, LogOut, Globe, Moon, Sun, Menu, X, PenLine } from 'lucide-vue-next'
import { storeToRefs } from 'pinia'
import { Button } from './ui/button'
import { Input } from './ui/input'
import { useAuthStore } from '../stores/auth'
import { useI18n, type AppLang } from '../i18n'
import { getOrCreateDefaultAvatarForUser } from '../utils/avatars'

const RouterLinkComp = RouterLink

const route = useRoute()
const router = useRouter()
const currentTab = computed(() => (route.path.startsWith('/resources') ? 'resourceLibrary' : ''))

function isActive(prefix: string) {
  return route.path === prefix || route.path.startsWith(prefix + '/')
}

const open = ref(false)
const searchQuery = ref('')
const authStore = useAuthStore()
const { user, isAuthed, avatarBuster } = storeToRefs(authStore)
const { lang, setLang, t, languages } = useI18n()

const langMenuOpen = ref(false)
const langMenuRef = ref<HTMLElement | null>(null)
const createMenuOpen = ref(false)
const createMenuRef = ref<HTMLElement | null>(null)
const displayName = computed(() => user.value?.username || 'User')
const avatarUrl = computed(() => {
  const explicit = String((user.value as any)?.avatar_url || '').trim()
  if (explicit) {
    const abs = explicit.startsWith('http://') || explicit.startsWith('https://')
      ? explicit
      : `http://localhost:8000${explicit.startsWith('/') ? '' : '/'}${explicit}`
    const sep0 = abs.includes('?') ? '&' : '?'
    const withV = `${abs}${sep0}v=${avatarBuster.value}`
    const sep = explicit.includes('?') ? '&' : '?'
    return withV
  }
  const uid = Number((user.value as any)?.id || 0)
  return uid ? getOrCreateDefaultAvatarForUser(uid) : ''
})
const userInitials = computed(() => displayName.value.slice(0, 2).toUpperCase())
const userLevel = computed(() => (user.value?.is_superuser ? 'Lv.SUPER' : 'Lv.1'))
const userEmail = computed(() => user.value?.email || 'No email')
const desktopMenuOpen = ref(false)
let desktopMenuCloseTimer: ReturnType<typeof setTimeout> | null = null

type ThemeMode = 'light' | 'dark'
const theme = ref<ThemeMode>('light')

function applyTheme(next: ThemeMode) {
  theme.value = next
  const root = document.documentElement
  if (next === 'dark') root.classList.add('dark')
  else root.classList.remove('dark')
  localStorage.setItem('theme', next)
}

function toggleTheme() {
  applyTheme(theme.value === 'dark' ? 'light' : 'dark')
}

function selectLang(next: AppLang) {
  setLang(next)
  langMenuOpen.value = false
}

function onDocumentClick(event: MouseEvent) {
  const target = event.target as Node | null
  if (langMenuOpen.value) {
    if (target && langMenuRef.value && !langMenuRef.value.contains(target)) {
      langMenuOpen.value = false
    }
  }
  if (createMenuOpen.value) {
    if (target && createMenuRef.value && !createMenuRef.value.contains(target)) {
      createMenuOpen.value = false
    }
  }
}

function openDesktopMenu() {
  if (desktopMenuCloseTimer) {
    clearTimeout(desktopMenuCloseTimer)
    desktopMenuCloseTimer = null
  }
  desktopMenuOpen.value = true
}

function scheduleDesktopMenuClose() {
  if (desktopMenuCloseTimer) {
    clearTimeout(desktopMenuCloseTimer)
  }
  desktopMenuCloseTimer = setTimeout(() => {
    desktopMenuOpen.value = false
    desktopMenuCloseTimer = null
  }, 180)
}

function handleLogout() {
  authStore.logout()
  desktopMenuOpen.value = false
  open.value = false
  router.push('/home')
}

function handleSearch() {
  const query = searchQuery.value.trim()
  if (!query) return
  
  // 跳转到 LearningPool 页面并传递搜索关键词
  router.push({
    path: '/learningpool',
    query: { search: query }
  })
  
  // 清空搜索框
  searchQuery.value = ''
}

onMounted(() => {
  document.addEventListener('click', onDocumentClick)

  const saved = (localStorage.getItem('theme') || '').toLowerCase()
  if (saved === 'dark' || saved === 'light') {
    applyTheme(saved as ThemeMode)
  } else {
    const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches
    applyTheme(prefersDark ? 'dark' : 'light')
  }
})

onBeforeUnmount(() => {
  if (desktopMenuCloseTimer) {
    clearTimeout(desktopMenuCloseTimer)
  }
  document.removeEventListener('click', onDocumentClick)
})
</script>
