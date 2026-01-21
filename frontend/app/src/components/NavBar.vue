<template>
  <header class="fixed top-0 left-0 right-0 z-30 bg-white/80 backdrop-blur border-b border-gray-200">
    <div class="mx-auto max-w-7xl px-4 py-3 flex items-center justify-between gap-4">
      <RouterLink to="/home" class="flex items-center gap-2 font-semibold text-gray-900">
        <img
          src="/logo.svg"
          alt="Contrail"
          class="h-9 w-9"
        />
        <span class="text-lg font-semibold tracking-tight text-gray-900">
          <span class="text-blue-600 font-bold">C</span><span>ontrail</span>
        </span>
      </RouterLink>
      <nav class="hidden md:flex items-center gap-6 text-sm font-medium text-gray-700">
        <RouterLink class="hover:text-blue-600" to="/learningpool">LearningPool</RouterLink>
        <RouterLink class="hover:text-blue-600" to="/notification">Notification</RouterLink>
        <RouterLink class="hover:text-blue-600" to="/about">About</RouterLink>
        <RouterLink class="hover:text-blue-600" to="/plan">Plan</RouterLink>
        <RouterLink
          to="/resources"
          class="px-4 py-2 rounded-lg flex items-center gap-2 transition-colors"
          :class="currentTab === 'resourceLibrary' ? 'bg-blue-600 text-white' : 'text-gray-600 hover:bg-gray-100'"
        >
          <Library class="w-4 h-4" />
          Resources
        </RouterLink>
      </nav>
      <div class="hidden md:flex items-center gap-3">
        <div class="relative hidden lg:block">
          <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
          <input
            v-model="searchQuery"
            type="search"
            :placeholder="t('Search...')"
            aria-label="Search"
            class="w-56 pl-9 pr-3 py-2 rounded-md border border-gray-200 bg-white text-sm text-gray-900 placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>
        <div
          v-if="isAuthed"
          class="relative"
          @mouseenter="openDesktopMenu"
          @mouseleave="scheduleDesktopMenuClose"
        >
          <button
            type="button"
            class="inline-flex items-center rounded-full bg-gray-50/90 p-1.5 text-left text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-gray-200 transition-all duration-200 hover:bg-white"
            :class="desktopMenuOpen ? 'scale-110 shadow-lg ring-2 ring-blue-100' : 'scale-100'"
            :aria-label="t('User menu')"
          >
            <div
              class="h-9 w-9 overflow-hidden rounded-full shadow transition-all duration-200"
              :class="desktopMenuOpen ? 'scale-110' : 'scale-100'"
            >
              <img
                v-if="avatarUrl"
                :src="avatarUrl"
                :alt="displayName"
                class="h-full w-full object-cover"
              />
              <div
                v-else
                class="flex h-full w-full items-center justify-center bg-linear-to-r from-blue-500 to-indigo-500 text-white"
              >
                {{ userInitials }}
              </div>
            </div>
            <ChevronDown class="ml-2 h-4 w-4 text-gray-400 transition-transform duration-200" :class="desktopMenuOpen ? 'rotate-180' : ''" />
          </button>

          <div
            v-if="desktopMenuOpen"
            class="absolute right-0 mt-3 w-60 rounded-2xl border border-gray-100 bg-white/95 p-3 shadow-2xl ring-1 ring-black/5"
            @mouseenter="openDesktopMenu"
            @mouseleave="scheduleDesktopMenuClose"
          >
            <div class="flex items-center gap-3 rounded-xl bg-linear-to-r from-blue-50 to-violet-50 p-3">
              <div class="h-12 w-12 overflow-hidden rounded-full shadow">
                <img v-if="avatarUrl" :src="avatarUrl" :alt="displayName" class="h-full w-full object-cover" />
                <div
                  v-else
                  class="flex h-full w-full items-center justify-center bg-linear-to-r from-blue-500 to-indigo-500 text-white text-lg"
                >
                  {{ userInitials }}
                </div>
              </div>
              <div>
                <p class="text-base font-semibold text-gray-900">{{ displayName }}</p>
                <p class="text-xs text-gray-500">{{ userEmail }}</p>
              </div>
            </div>
            <div class="mt-3 flex flex-col text-sm text-gray-700">
              <RouterLink
                to="/account/user-info"
                class="flex items-center justify-between rounded-lg px-3 py-2 hover:bg-gray-50"
              >
                <span>Account</span>
                <span class="text-xs text-gray-400">Go</span>
              </RouterLink>
              <RouterLink
                to="/tools"
                class="flex items-center justify-between rounded-lg px-3 py-2 hover:bg-gray-50"
              >
                <span>Tools</span>
                <span class="text-xs text-gray-400">DB</span>
              </RouterLink>
              <RouterLink
                to="/my-paths"
                class="flex items-center justify-between rounded-lg px-3 py-2 hover:bg-gray-50"
              >
                <span>{{ t('My Paths') }}</span>
                <span class="text-xs text-gray-400">Go</span>
              </RouterLink>
           

              <RouterLink
                to="/partical"
                class="flex items-center justify-between rounded-lg px-3 py-2 hover:bg-gray-50"
              >
                <span>Partical</span>
                <span class="text-xs text-gray-400">Go</span>
              </RouterLink>

              <RouterLink
                to="/my-resources"
                class="flex items-center justify-between rounded-lg px-3 py-2 hover:bg-gray-50"
              >
                <span>{{ t('My Resources') }}</span>
                <span class="text-xs text-gray-400">Hot</span>
              </RouterLink>
              <RouterLink
                to="/creator"
                class="flex items-center justify-between rounded-lg px-3 py-2 hover:bg-gray-50"
              >
                <span>{{ t('Creator Center') }}</span>
                <span class="text-xs text-gray-400">Beta</span>
              </RouterLink>
            </div>
            <button
              type="button"
              class="mt-3 flex w-full items-center justify-between rounded-xl bg-red-50 px-3 py-2 text-sm font-semibold text-red-600 hover:bg-red-100"
              @click="handleLogout"
            >
              {{ t('Log out') }}
              <LogOut class="h-4 w-4" />
            </button>
          </div>
        </div>
        <RouterLink v-else class="text-blue-600 hover:text-blue-700 text-sm" to="/login">Login</RouterLink>
        <RouterLink
          to="/createpath"
          class="px-4 py-2 rounded-full bg-pink-600 text-white text-sm hover:bg-pink-700 inline-flex items-center gap-2"
        >
          <Plus class="w-4 h-4" />
          <span class="hidden lg:inline font-semibold">{{ t('CreatePath') }}</span>
        </RouterLink>

        <div ref="langMenuRef" class="relative">
          <button
            type="button"
            class="inline-flex h-10 w-10 items-center justify-center rounded-full border border-gray-200 bg-white text-gray-700 hover:bg-gray-50"
            :aria-label="t('Language')"
            @click="langMenuOpen = !langMenuOpen"
          >
            <Globe class="h-5 w-5" />
          </button>

          <div
            v-if="langMenuOpen"
            class="absolute right-0 mt-2 w-44 rounded-xl border border-gray-100 bg-white p-2 shadow-xl ring-1 ring-black/5"
          >
            <button
              v-for="opt in languages"
              :key="opt.code"
              type="button"
              class="flex w-full items-center justify-between rounded-lg px-3 py-2 text-sm text-gray-700 hover:bg-gray-50"
              @click="selectLang(opt.code)"
            >
              <span>{{ opt.label }}</span>
              <span v-if="lang === opt.code" class="text-xs text-blue-600">✓</span>
            </button>
          </div>
        </div>
      </div>
    </div>
    <div v-if="open" class="md:hidden border-t border-gray-200 bg-white">
      <div class="px-4 py-3 flex flex-col gap-3 text-sm text-gray-700">
        <RouterLink class="hover:text-blue-600" to="/home" @click="open = false">Home</RouterLink>
        <RouterLink class="hover:text-blue-600" to="/learningpool" @click="open = false">LearningPool</RouterLink>
        <RouterLink class="hover:text-blue-600" to="/notification" @click="open = false">Notification</RouterLink>
        <RouterLink class="hover:text-blue-600" to="/my-paths" @click="open = false">My Paths</RouterLink>
        <RouterLink class="hover:text-blue-600" to="/createpath" @click="open = false">CreatePath</RouterLink>
        <RouterLink class="hover:text-blue-600" to="/about" @click="open = false">About</RouterLink>
        <RouterLink
          to="/resources"
          class="px-4 py-2 rounded-lg flex items-center gap-2 transition-colors"
          :class="currentTab === 'resourceLibrary' ? 'bg-blue-600 text-white' : 'text-gray-700 hover:bg-gray-100'"
          @click="open = false"
        >
          <Library class="w-4 h-4" />
          Resources
        </RouterLink>
        <RouterLink class="hover:text-blue-600" to="/my-resources" @click="open = false">My Resources</RouterLink>
        <RouterLink class="hover:text-blue-600" to="/plan" @click="open = false">Plan</RouterLink>
        <div
          v-if="isAuthed"
          class="rounded-2xl border border-gray-100 bg-white/95 p-4 text-gray-900 shadow-sm"
        >
          <div class="flex items-center gap-3">
            <div class="h-12 w-12 overflow-hidden rounded-full shadow">
              <img v-if="avatarUrl" :src="avatarUrl" :alt="displayName" class="h-full w-full object-cover" />
              <div
                v-else
                class="flex h-full w-full items-center justify-center bg-linear-to-r from-blue-500 to-indigo-500 text-white text-lg"
              >
                {{ userInitials }}
              </div>
            </div>
            <div class="flex-1">
              <p class="text-base font-semibold">{{ displayName }}</p>
              <p class="text-xs text-gray-500">{{ userEmail }}</p>
            </div>
            <span class="rounded-full bg-blue-50 px-3 py-1 text-xs font-semibold text-blue-600">{{ userLevel }}</span>
          </div>
          <div class="mt-4 grid grid-cols-2 gap-3 text-sm">
            <RouterLink
              to="/account/user-info"
              class="rounded-xl bg-gray-50 px-3 py-2 text-center font-medium text-gray-700 hover:bg-gray-100"
              @click="open = false"
            >
              Account
            </RouterLink>
            <RouterLink
              to="/my-paths"
              class="rounded-xl bg-gray-50 px-3 py-2 text-center font-medium text-gray-700 hover:bg-gray-100"
              @click="open = false"
            >
              My Paths
            </RouterLink>
            <RouterLink
              to="/learningpool"
              class="rounded-xl bg-gray-50 px-3 py-2 text-center font-medium text-gray-700 hover:bg-gray-100"
              @click="open = false"
            >
              My Favorites
            </RouterLink>
            <RouterLink
              to="/partical"
              class="rounded-xl bg-gray-50 px-3 py-2 text-center font-medium text-gray-700 hover:bg-gray-100"
              @click="open = false"
            >
              Partical
            </RouterLink>
          </div>
          <button
            type="button"
            class="mt-4 flex w-full items-center justify-center gap-2 rounded-xl bg-red-50 px-3 py-2 text-sm font-semibold text-red-600 hover:bg-red-100"
            @click="handleLogout"
          >
            {{ t('Log out') }}
            <LogOut class="h-4 w-4" />
          </button>
        </div>
        <RouterLink v-else class="hover:text-blue-600" to="/login" @click="open = false">Login</RouterLink>
      </div>
    </div>
  </header>
  <!-- spacer to prevent fixed header from covering page content -->
  <div class="h-16 md:h-16"></div>
</template>

<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import { Library, Plus, Search, User, ChevronDown, LogOut, Globe } from 'lucide-vue-next'
import { storeToRefs } from 'pinia'
import { useAuthStore } from '../stores/auth'
import { useI18n, type AppLang } from '../i18n'
import { getOrCreateDefaultAvatarForUser } from '../utils/avatars'

const route = useRoute()
const router = useRouter()
const currentTab = computed(() => (route.path.startsWith('/resources') ? 'resourceLibrary' : ''))

const open = ref(false)
const searchQuery = ref('')
const authStore = useAuthStore()
const { user, isAuthed } = storeToRefs(authStore)
const { lang, setLang, t, languages } = useI18n()

const langMenuOpen = ref(false)
const langMenuRef = ref<HTMLElement | null>(null)
const displayName = computed(() => user.value?.username || 'User')
const avatarUrl = computed(() => {
  const explicit = String((user.value as any)?.avatar_url || '').trim()
  if (explicit) return explicit
  const uid = Number((user.value as any)?.id || 0)
  return uid ? getOrCreateDefaultAvatarForUser(uid) : ''
})
const userInitials = computed(() => displayName.value.slice(0, 2).toUpperCase())
const userLevel = computed(() => (user.value?.is_superuser ? 'Lv.SUPER' : 'Lv.1'))
const userEmail = computed(() => user.value?.email || 'No email')
const desktopMenuOpen = ref(false)
let desktopMenuCloseTimer: ReturnType<typeof setTimeout> | null = null

function selectLang(next: AppLang) {
  setLang(next)
  langMenuOpen.value = false
}

function onDocumentClick(event: MouseEvent) {
  if (!langMenuOpen.value) return
  const target = event.target as Node | null
  if (target && langMenuRef.value && !langMenuRef.value.contains(target)) {
    langMenuOpen.value = false
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

onMounted(() => {
  document.addEventListener('click', onDocumentClick)
})

onBeforeUnmount(() => {
  if (desktopMenuCloseTimer) {
    clearTimeout(desktopMenuCloseTimer)
  }
  document.removeEventListener('click', onDocumentClick)
})
</script>
