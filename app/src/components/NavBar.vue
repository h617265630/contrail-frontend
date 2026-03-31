<template>
  <!-- Topbar: slim utility bar -->
  <div class="border-b border-slate-100 bg-white">
    <div class="mx-auto max-w-7xl px-4 h-8 flex items-center justify-between">
      <div class="flex items-center gap-4 text-[11px] text-slate-400">
        <span class="hidden md:inline">Learn structured, learn better.</span>
        <span class="hidden md:inline text-slate-200">·</span>
        <a href="https://github.com" target="_blank" rel="noopener" class="hover:text-slate-600 transition-colors" aria-label="GitHub">
          <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="currentColor" class="text-slate-400"><path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0 0 24 12c0-6.63-5.37-12-12-12z"/></svg>
        </a>
      </div>
      <div class="flex items-center gap-3">
        <!-- Language selector -->
        <div class="relative">
          <button
            type="button"
            class="flex items-center gap-1 text-[11px] text-slate-400 hover:text-slate-600 transition-colors font-medium"
            @click="langMenuOpen = !langMenuOpen"
          >
            <Globe class="w-3.5 h-3.5" />
            <span>{{ currentLangLabel }}</span>
            <ChevronDown class="w-3 h-3" />
          </button>
          <div
            v-if="langMenuOpen"
            class="absolute right-0 top-full mt-1 w-36 rounded-lg border border-slate-100 bg-white shadow-lg z-50 py-1"
          >
            <button
              v-for="opt in languages"
              :key="opt.code"
              type="button"
              class="flex w-full items-center justify-between px-3 py-2 text-xs text-slate-600 hover:bg-slate-50 transition-colors"
              :class="lang === opt.code ? 'bg-slate-50 text-slate-900 font-semibold' : ''"
              @click="selectLang(opt.code)"
            >
              <span>{{ opt.label }}</span>
              <span v-if="lang === opt.code" class="text-blue-500">✓</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Main navbar -->
  <header class="sticky top-0 z-40 bg-stone-50 backdrop-blur-md border-b border-stone-100">
    <div class="mx-auto max-w-7xl px-4">
      <div class="h-16 flex items-center justify-between gap-8">
        <!-- Logo -->
        <RouterLink to="/home" class="flex items-center gap-3 shrink-0 group">
          <img src="/favicon.svg" alt="Learnpathly" class="h-10 w-10 rounded-xl shadow-sm" />
          <div class="flex flex-col leading-none">
            <span class="text-base font-black tracking-tight text-stone-900 group-hover:text-blue-600 transition-colors">
              Learnpathly
            </span>
            <span class="text-[10px] font-medium tracking-widest text-stone-400 uppercase mt-0.5">Learning Platform</span>
          </div>
        </RouterLink>

        <!-- Primary nav: desktop -->
        <nav class="hidden md:flex items-center gap-1" aria-label="Main navigation">
          <RouterLink
            v-for="link in mainNavLinks"
            :key="link.to"
            :to="link.to"
            class="relative px-3 py-1.5 text-xs font-semibold uppercase tracking-widest transition-colors duration-150 group"
            :class="isActive(link.to) ? 'text-blue-600' : 'text-slate-500 hover:text-slate-900'"
          >
            {{ link.label }}
            <span
              class="absolute bottom-0 left-3 right-3 h-px bg-blue-500 transition-all duration-300 origin-left"
              :class="isActive(link.to) ? 'scale-x-100' : 'scale-x-0 group-hover:scale-x-100'"
            />
          </RouterLink>
        </nav>

        <!-- Right actions -->
        <div class="flex items-center gap-2">
          <!-- Search -->
          <div v-if="searchOpen" class="hidden lg:flex items-center gap-2 h-9 rounded-full border border-slate-200 bg-white pl-3 pr-1">
            <Search class="w-3.5 h-3.5 text-slate-400 shrink-0" />
            <input
              ref="searchInputRef"
              v-model="searchQuery"
              type="text"
              placeholder="Search..."
              class="w-40 h-full text-xs text-slate-900 placeholder:text-slate-400 bg-transparent outline-none"
              @keydown.enter="submitSearch"
              @keydown.escape="closeSearch"
            />
            <button
              type="button"
              class="w-6 h-6 rounded-full flex items-center justify-center text-slate-400 hover:text-slate-600 transition-colors"
              aria-label="Close search"
              @click="closeSearch"
            >
              <X class="w-3.5 h-3.5" />
            </button>
          </div>
          <button
            v-else
            type="button"
            class="hidden lg:flex items-center gap-2 h-9 rounded-full border border-slate-200 bg-slate-50/50 pl-3 pr-4 text-xs text-slate-400 hover:border-slate-300 hover:text-slate-600 transition-all group"
            aria-label="Search"
            @click="openSearch"
          >
            <Search class="w-3.5 h-3.5" />
            <span class="font-medium">Search</span>
            <kbd class="hidden xl:inline-flex items-center rounded border border-slate-200 bg-white px-1 py-0.5 text-[10px] text-slate-400 font-sans">⌘K</kbd>
          </button>

          <!-- Auth: logged in -->
          <div v-if="isAuthed" class="relative hidden md:block" @mouseenter="openDesktopMenu" @mouseleave="scheduleDesktopMenuClose">
            <button
              type="button"
              class="flex items-center gap-2 rounded-full border border-slate-200 bg-white px-2 py-1.5 hover:border-slate-300 hover:bg-slate-50 transition-all"
              :aria-expanded="desktopMenuOpen"
              aria-haspopup="menu"
              @keydown.escape.prevent="closeDesktopMenu"
            >
              <div class="h-6 w-6 shrink-0 overflow-hidden rounded-full">
                <img v-if="avatarUrl" :src="avatarUrl" :alt="displayName" referrerpolicy="no-referrer" class="h-full w-full object-cover" />
                <div v-else class="flex h-full w-full items-center justify-center bg-blue-500 text-white text-[10px] font-bold">{{ userInitials }}</div>
              </div>
              <span class="text-xs font-semibold text-slate-700 hidden lg:inline">{{ displayName }}</span>
              <ChevronDown class="w-3.5 h-3.5 text-slate-400 transition-transform" :class="desktopMenuOpen ? 'rotate-180' : ''" />
            </button>

            <!-- Dropdown menu -->
            <div
              v-if="desktopMenuOpen"
              role="menu"
              class="absolute right-0 top-full mt-2 w-56 rounded-xl border border-slate-100 bg-white shadow-xl z-50 py-1"
              @mouseenter="openDesktopMenu"
              @mouseleave="scheduleDesktopMenuClose"
            >
              <div class="px-4 py-3 border-b border-slate-50 mb-1">
                <p class="text-sm font-semibold text-slate-900">{{ displayName }}</p>
                <p class="text-xs text-slate-400 mt-0.5">{{ userEmail }}</p>
              </div>
              <div class="py-1">
                <RouterLink
                  v-for="item in userMenuItems"
                  :key="item.to"
                  :to="item.to"
                  class="flex items-center gap-3 px-4 py-2 text-sm text-slate-600 hover:bg-slate-50 hover:text-slate-900 transition-colors"
                  role="menuitem"
                  @click="desktopMenuOpen = false"
                >
                  <component :is="item.icon" class="w-4 h-4 text-slate-400" />
                  {{ item.label }}
                </RouterLink>
              </div>
              <div class="border-t border-slate-50 mt-1 pt-1 pb-1">
                <button
                  type="button"
                  class="flex w-full items-center gap-3 px-4 py-2 text-sm text-red-500 hover:bg-red-50 transition-colors"
                  role="menuitem"
                  @click="handleLogout"
                >
                  <LogOut class="w-4 h-4" />
                  Log out
                </button>
              </div>
            </div>
          </div>

          <!-- Auth: logged out -->
          <template v-else>
            <Button
              :as="RouterLinkComp"
              to="/login"
              variant="ghost"
              size="sm"
              class="hidden md:inline-flex h-9 rounded-full px-4 text-xs font-semibold text-slate-600 hover:text-slate-900 hover:bg-slate-100 transition-all"
            >
              Login
            </Button>
            <Button
              :as="RouterLinkComp"
              to="/register"
              size="sm"
              class="hidden md:inline-flex h-9 rounded-full bg-slate-900 text-white hover:bg-slate-800 px-5 text-xs font-semibold shadow-sm transition-all hover:-translate-y-px"
            >
              Get started
            </Button>
          </template>

          <!-- CREATE button: always visible -->
          <div class="relative hidden md:inline-flex">
            <Button
              type="button"
              size="sm"
              class="h-9 rounded-full bg-blue-500 text-white hover:bg-blue-600 px-4 text-xs font-semibold shadow-sm transition-all hover:-translate-y-px"
              @click="createMenuOpen = !createMenuOpen"
            >
              + Create
            </Button>
            <div
              v-if="createMenuOpen"
              class="absolute right-0 top-full mt-2 w-48 rounded-xl border border-slate-100 bg-white shadow-xl z-50 py-1"
            >
              <RouterLink
                v-for="item in createMenuItems"
                :key="item.to"
                :to="item.to"
                class="flex items-center gap-3 px-4 py-2.5 text-sm text-slate-600 hover:bg-slate-50 hover:text-slate-900 transition-colors"
                @click="createMenuOpen = false"
              >
                <component :is="item.icon" class="w-4 h-4 text-slate-400" />
                {{ item.label }}
              </RouterLink>
            </div>
          </div>

          <!-- Mobile menu toggle -->
          <button
            type="button"
            class="inline-flex md:hidden h-9 w-9 items-center justify-center rounded-lg border border-slate-200 bg-white text-slate-500 hover:bg-slate-50 transition-all"
            :aria-label="mobileMenuOpen ? 'Close menu' : 'Open menu'"
            @click="mobileMenuOpen = !mobileMenuOpen"
          >
            <X v-if="mobileMenuOpen" class="w-4 h-4" />
            <Menu v-else class="w-4 h-4" />
          </button>
        </div>
      </div>
    </div>

    <!-- Mobile menu -->
    <div v-if="mobileMenuOpen" class="md:hidden border-t border-slate-100 bg-white">
      <div class="mx-auto max-w-7xl px-4 py-4 space-y-1">
        <RouterLink
          v-for="link in mainNavLinks"
          :key="link.to"
          :to="link.to"
          class="flex items-center justify-between px-3 py-2.5 rounded-lg text-sm font-semibold text-slate-600 hover:bg-slate-50 hover:text-slate-900 transition-colors"
          :class="isActive(link.to) ? 'bg-slate-50 text-blue-600' : ''"
          @click="mobileMenuOpen = false"
        >
          {{ link.label }}
        </RouterLink>
        <div class="border-t border-slate-100 pt-3 mt-3">
          <RouterLink
            v-for="item in createMenuItems"
            :key="item.to"
            :to="item.to"
            class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm text-slate-600 hover:bg-slate-50 transition-colors"
            @click="mobileMenuOpen = false"
          >
            <component :is="item.icon" class="w-4 h-4 text-slate-400" />
            {{ item.label }}
          </RouterLink>
        </div>
        <div v-if="!isAuthed" class="border-t border-slate-100 pt-3 mt-3 space-y-1">
          <RouterLink to="/login" class="flex items-center justify-center gap-2 px-3 py-2.5 rounded-lg text-sm font-semibold text-slate-600 hover:bg-slate-50 transition-colors" @click="mobileMenuOpen = false">
            Login
          </RouterLink>
          <RouterLink to="/register" class="flex items-center justify-center gap-2 px-3 py-2.5 rounded-lg text-sm font-semibold bg-slate-900 text-white hover:bg-slate-800 transition-colors" @click="mobileMenuOpen = false">
            Get started
          </RouterLink>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, ref } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import {
  Library, Plus, Search, User, ChevronDown, LogOut, Globe, Menu, X, PenLine,
  LayoutDashboard, BookOpen, Settings, CreditCard,
} from 'lucide-vue-next'
import { storeToRefs } from 'pinia'
import { Button } from './ui/button'
import { useAuthStore } from '../stores/auth'
import { useI18n, type AppLang } from '../i18n'
import { toBackendAbsoluteUrl } from '../utils/backendUrl'
import { getOrCreateDefaultAvatarForUser } from '../utils/avatars'

const RouterLinkComp = RouterLink
const route = useRoute()
const router = useRouter()

function isActive(prefix: string) {
  return route.path === prefix || route.path.startsWith(prefix + '/')
}

const authStore = useAuthStore()
const { user, isAuthed, avatarBuster } = storeToRefs(authStore)
const { lang, setLang, languages } = useI18n()

const mobileMenuOpen = ref(false)
const createMenuOpen = ref(false)
const langMenuOpen = ref(false)
const desktopMenuOpen = ref(false)
const searchOpen = ref(false)
const searchQuery = ref('')
const searchInputRef = ref<HTMLInputElement | null>(null)
let desktopMenuCloseTimer: ReturnType<typeof setTimeout> | null = null

const mainNavLinks = [
  { to: '/learningpool', label: 'Pool' },
  { to: '/resources', label: 'Resources' },
  { to: '/ai-path', label: 'AI Path' },
  { to: '/plan', label: 'Plan' },
  { to: '/about', label: 'About' },
  { to: '/notification', label: 'Updates' },
]

const createMenuItems = [
  { to: '/createpath', label: 'New learning path', icon: Plus },
  { to: '/my-resources/add', label: 'Add resource', icon: Library },
  { to: '/creator?tab=markdown', label: 'Write a note', icon: PenLine },
]

const userMenuItems = [
  { to: '/account/user-info', label: 'Account', icon: User },
  { to: '/my-paths', label: 'My Paths', icon: LayoutDashboard },
  { to: '/my-resources', label: 'My Resources', icon: BookOpen },
  { to: '/account/plan', label: 'Plan & Billing', icon: CreditCard },
  { to: '/account', label: 'Settings', icon: Settings },
]

const currentLangLabel = computed(() => {
  const found = languages.find(l => l.code === lang.value)
  return found ? found.label : 'EN'
})

const displayName = computed(() => user.value?.username || 'User')
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
const userInitials = computed(() => displayName.value.slice(0, 2).toUpperCase())
const userEmail = computed(() => user.value?.email || '')

function selectLang(code: AppLang) {
  setLang(code)
  langMenuOpen.value = false
}

function openDesktopMenu() {
  if (desktopMenuCloseTimer) { clearTimeout(desktopMenuCloseTimer); desktopMenuCloseTimer = null }
  desktopMenuOpen.value = true
}

function scheduleDesktopMenuClose() {
  desktopMenuCloseTimer = setTimeout(() => { desktopMenuOpen.value = false; desktopMenuCloseTimer = null }, 180)
}

function closeDesktopMenu() {
  if (desktopMenuCloseTimer) { clearTimeout(desktopMenuCloseTimer); desktopMenuCloseTimer = null }
  desktopMenuOpen.value = false
}

function handleLogout() {
  authStore.logout()
  closeDesktopMenu()
  mobileMenuOpen.value = false
  router.push('/home')
}

function openSearch() {
  searchOpen.value = true
  searchQuery.value = ''
  nextTick(() => { searchInputRef.value?.focus() })
}

function closeSearch() {
  searchOpen.value = false
  searchQuery.value = ''
}

function submitSearch() {
  const q = searchQuery.value.trim()
  closeSearch()
  if (q) {
    router.push({ path: '/learningpool', query: { search: q } })
  } else {
    router.push({ path: '/learningpool' })
  }
}

onMounted(() => {
  document.addEventListener('click', (e) => {
    const t = e.target as Node | null
    if (langMenuOpen.value && t) {
      // handled by direct ref tracking
    }
  })
})

onBeforeUnmount(() => {
  if (desktopMenuCloseTimer) clearTimeout(desktopMenuCloseTimer)
})
</script>
