<template>
  <footer class="border-t border-gray-200 bg-white/80 backdrop-blur py-6">
    <div class="max-w-7xl mx-auto px-4 flex flex-col md:flex-row md:items-center md:justify-between gap-4 text-sm text-gray-600">
      <div class="flex items-center gap-2 text-gray-800 font-semibold">
        <img src="/logo.svg" alt="Contrail" class="h-8 w-8" />
        <span class="tracking-tight">
          <span class="font-extrabold italic text-blue-600">C</span>
          <span class="font-medium tracking-[0.12em] text-gray-900">ontrail</span>
        </span>
      </div>
      <div class="flex flex-wrap gap-4">
        <RouterLink class="hover:text-blue-600" to="/about">About</RouterLink>
        <RouterLink class="hover:text-blue-600" to="/my-paths">My Paths</RouterLink>
        <RouterLink class="hover:text-blue-600" to="/resources">Resources</RouterLink>
        <RouterLink class="hover:text-blue-600" to="/login">Login</RouterLink>
        <RouterLink class="hover:text-blue-600" to="/register">Sign Up</RouterLink>
      </div>
      <div class="text-xs text-gray-500">
        © {{ new Date().getFullYear() }}
        <span class="tracking-tight">
          <span class="font-extrabold italic text-blue-600">C</span>
          <span class="font-medium tracking-[0.12em] text-gray-900">ontrail</span>
        </span>.
        All rights reserved.
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
import { RouterLink } from 'vue-router'
</script>
