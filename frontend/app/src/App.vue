<template>
  <div class="min-h-screen bg-gray-50 text-gray-900 flex flex-col">
    <NavBar />
    <main class="py-6 px-4 flex-1">
      <router-view />
    </main>
    <AppFooter />
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import NavBar from './components/NavBar.vue'
import AppFooter from './components/AppFooter.vue'
import { useAuthStore } from './stores/auth'

const authStore = useAuthStore()

onMounted(() => {
  authStore
    .fetchProfile()
    .catch((error) => console.warn('Failed to initialize user profile:', error))
})
</script>
