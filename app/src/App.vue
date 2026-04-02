<template>
  <div class="min-h-screen bg-background text-foreground flex flex-col">
    <NavBar />
    <main class="pt-16 flex-1" :class="isAuthPage ? '' : 'py-6'">
      <div v-if="isAuthPage" class="px-4 py-6">
        <router-view />
      </div>
      <div v-else class="mx-auto w-full max-w-7xl 2xl:max-w-[1536px] px-4 sm:px-6 lg:px-8">
        <router-view />
      </div>
    </main>
    <AppFooter />
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import NavBar from './components/NavBar.vue'
import AppFooter from './components/AppFooter.vue'
import { useAuthStore } from './stores/auth'
import { setAnalyticsUser } from './utils/analytics'

const authStore = useAuthStore()
const route = useRoute()

const isAuthPage = computed(() => route.name === 'login' || route.name === 'register')

onMounted(() => {
  authStore
    .fetchProfile()
    .catch((error) => console.warn('Failed to initialize user profile:', error))
})

watch(
  () => authStore.user,
  (next) => {
    setAnalyticsUser(next)
  },
  { immediate: true },
)
</script>
