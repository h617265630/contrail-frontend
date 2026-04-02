<template>
  <div class="min-h-screen bg-slate-50">
    <div class="max-w-7xl mx-auto p-6">
      <div class="grid gap-6 lg:grid-cols-12">
        <aside class="lg:col-span-3">
          <div class="rounded-none bg-white p-4 shadow-sm border border-slate-100">
            <div class="space-y-1">
              <p class="text-sm font-semibold text-slate-900">My Partical</p>
              <p class="text-xs text-slate-500">我的素材与灵感</p>
            </div>

            <div class="mt-4 space-y-2">
              <RouterLink
                to="/my-partical/home"
                class="block rounded-sm px-3 py-2 text-sm font-semibold"
                :class="isActive('/my-partical/home') ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
              >
                Home
              </RouterLink>
              <RouterLink
                to="/my-partical/image"
                class="block rounded-sm px-3 py-2 text-sm font-semibold"
                :class="isActive('/my-partical/image') ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
              >
                Image
              </RouterLink>
              <RouterLink
                to="/my-partical/flashed-ideas"
                class="block rounded-sm px-3 py-2 text-sm font-semibold"
                :class="isActive('/my-partical/flashed-ideas') ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
              >
                Flashed Ideas
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
import { RouterLink, RouterView, useRoute } from 'vue-router'

const route = useRoute()

function isActive(prefix: string) {
  return route.path.startsWith(prefix)
}
</script>
