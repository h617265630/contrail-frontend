<template>
  <div class="space-y-4">
    <div class="rounded-2xl bg-white p-5 shadow-sm border border-slate-100">
      <h1 class="text-xl font-semibold text-slate-900">My Paths</h1>
      <p class="text-sm text-slate-600 mt-1">Manage your learning paths</p>
    </div>

    <div class="rounded-2xl bg-white p-6 shadow-sm border border-slate-100">
      <p class="text-slate-700">Open the full page to manage paths:</p>
      <RouterLink to="/my-paths" class="inline-flex mt-4 px-4 py-2 rounded-lg bg-blue-600 text-white font-semibold hover:bg-blue-700">
        Go to My Paths
      </RouterLink>
    </div>
  </div>
</template>

<script setup lang="ts">
import { RouterLink } from 'vue-router'
</script>
