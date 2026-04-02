<template>
  <div class="min-h-[calc(100vh-4rem)] flex">
    <!-- Admin sidebar -->
    <aside class="w-64 shrink-0 bg-stone-900 p-5 flex flex-col">
      <div class="mb-6">
        <p class="text-[10px] font-bold uppercase tracking-[0.3em] text-amber-500 mb-1">Admin</p>
        <h2 class="text-xl font-black text-white font-serif">Dashboard</h2>
      </div>

      <nav class="space-y-0.5 flex-1">
        <RouterLink
          v-for="item in navItems"
          :key="item.to"
          :to="item.to"
          class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-xs font-semibold transition-all duration-150 group"
          :class="isActive(item.to) ? 'bg-amber-500 text-stone-900' : 'text-stone-400 hover:text-stone-200 hover:bg-white/5'"
        >
          <component :is="item.icon" class="w-4 h-4 shrink-0" />
          {{ item.label }}
          <span v-if="isActive(item.to)" class="ml-auto">
            <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" class="text-stone-700"><polyline points="9 18 15 12 9 6"/></svg>
          </span>
        </RouterLink>
      </nav>

      <div class="pt-4 border-t border-stone-700">
        <RouterLink to="/home" class="flex items-center gap-1.5 text-xs text-stone-500 hover:text-amber-500 transition-colors">
          <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
          Back to home
        </RouterLink>
      </div>
    </aside>

    <!-- Main content -->
    <main class="flex-1 p-8 bg-stone-50 overflow-auto">
      <RouterView />
    </main>
  </div>
</template>

<script setup lang="ts">
import { RouterLink, RouterView, useRoute } from 'vue-router'
import { LayoutDashboard, Users, FolderOpen, BarChart3, BookOpen } from 'lucide-vue-next'

const route = useRoute()

const navItems = [
  { label: 'Dashboard', to: '/admin/dashboard', icon: LayoutDashboard },
  { label: 'Users', to: '/admin/users', icon: Users },
  { label: 'Resources', to: '/admin/resources', icon: FolderOpen },
  { label: 'Learning Paths', to: '/admin/paths', icon: BookOpen },
  { label: 'Analytics', to: '/admin/analytics', icon: BarChart3 },
]

function isActive(prefix: string) {
  return route.path.startsWith(prefix)
}
</script>
