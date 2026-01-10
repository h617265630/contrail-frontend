<template>
  <header class="fixed top-0 left-0 right-0 z-30 bg-white/80 backdrop-blur border-b border-gray-200">
    <div class="mx-auto max-w-7xl px-4 py-3 flex items-center justify-between gap-4">
      <RouterLink to="/home" class="flex items-center gap-2 font-semibold text-gray-900">
        <span class="inline-flex h-9 w-9 items-center justify-center rounded-lg bg-blue-600 text-white font-bold">LP</span>
        <span class="text-lg">Learning Path</span>
      </RouterLink>
      <nav class="hidden md:flex items-center gap-6 text-sm font-medium text-gray-700">
        <RouterLink class="hover:text-blue-600" to="/learningpool">LearningPool</RouterLink>
        <RouterLink class="hover:text-blue-600" to="/">Notification</RouterLink>
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
        <div class="relative">
          <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
          <input
            v-model="searchQuery"
            type="search"
            placeholder="Search..."
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
            aria-label="用户菜单"
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
                to="/my-paths"
                class="flex items-center justify-between rounded-lg px-3 py-2 hover:bg-gray-50"
              >
                <span>我的学习路径</span>
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
                <span>我的资源收藏</span>
                <span class="text-xs text-gray-400">Hot</span>
              </RouterLink>
              <RouterLink
                to="/plan"
                class="flex items-center justify-between rounded-lg px-3 py-2 hover:bg-gray-50"
              >
                <span>创作中心</span>
                <span class="text-xs text-gray-400">Beta</span>
              </RouterLink>
            </div>
            <button
              type="button"
              class="mt-3 flex w-full items-center justify-between rounded-xl bg-red-50 px-3 py-2 text-sm font-semibold text-red-600 hover:bg-red-100"
              @click="handleLogout"
            >
              退出登录
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
          CreatePath
        </RouterLink>
      </div>
    </div>
    <div v-if="open" class="md:hidden border-t border-gray-200 bg-white">
      <div class="px-4 py-3 flex flex-col gap-3 text-sm text-gray-700">
        <RouterLink class="hover:text-blue-600" to="/home" @click="open = false">Home</RouterLink>
        <RouterLink class="hover:text-blue-600" to="/learningpool" @click="open = false">LearningPool</RouterLink>
        <RouterLink class="hover:text-blue-600" to="/my-paths" @click="open = false">My Paths</RouterLink>
        <RouterLink class="hover:text-blue-600" to="/createpath" @click="open = false">CreatePath</RouterLink>
        <RouterLink class="hover:text-blue-600" to="/partical" @click="open = false">Partical</RouterLink>
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
              我的收藏
            </RouterLink>
          </div>
          <button
            type="button"
            class="mt-4 flex w-full items-center justify-center gap-2 rounded-xl bg-red-50 px-3 py-2 text-sm font-semibold text-red-600 hover:bg-red-100"
            @click="handleLogout"
          >
            退出登录
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
import { computed, ref, onBeforeUnmount } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import { Library, Plus, Search, User, ChevronDown, LogOut } from 'lucide-vue-next'
import { storeToRefs } from 'pinia'
import { useAuthStore } from '../stores/auth'

const route = useRoute()
const router = useRouter()
const currentTab = computed(() => (route.path.startsWith('/resources') ? 'resourceLibrary' : ''))

const open = ref(false)
const searchQuery = ref('')
const authStore = useAuthStore()
const { user, isAuthed } = storeToRefs(authStore)
const displayName = computed(() => user.value?.username || 'User')
const avatarUrl = computed(() => (user.value as any)?.avatar_url || '')
const userInitials = computed(() => displayName.value.slice(0, 2).toUpperCase())
const userLevel = computed(() => (user.value?.is_superuser ? 'Lv.SUPER' : 'Lv.1'))
const userEmail = computed(() => user.value?.email || '未绑定邮箱')
const desktopMenuOpen = ref(false)
let desktopMenuCloseTimer: ReturnType<typeof setTimeout> | null = null

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

onBeforeUnmount(() => {
  if (desktopMenuCloseTimer) {
    clearTimeout(desktopMenuCloseTimer)
  }
})
</script>
