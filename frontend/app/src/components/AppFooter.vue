<template>
  <footer class="border-t border-border bg-background py-8">
    <div class="mx-auto max-w-7xl px-4 flex flex-col gap-6 md:flex-row md:items-center md:justify-between">
      <div class="flex items-center gap-2 font-semibold text-foreground">
        <img src="/favicon.svg" alt="Contrail" class="h-8 w-8 rounded-sm" />
        <span class="brand-wordmark tracking-tight">
          <span class="font-semibold text-foreground">Contrail</span>
        </span>
      </div>
      <div class="flex flex-wrap gap-4">
        <Button
          :as="RouterLinkComp"
          to="/about"
          variant="ghost"
          size="sm"
          class="h-8 rounded-none px-0 py-0 hover:bg-transparent text-xs font-medium tracking-[0.14em] uppercase text-muted-foreground hover:text-foreground"
        >
          About
        </Button>
        <Button
          :as="RouterLinkComp"
          to="/my-paths"
          variant="ghost"
          size="sm"
          class="h-8 rounded-none px-0 py-0 hover:bg-transparent text-xs font-medium tracking-[0.14em] uppercase text-muted-foreground hover:text-foreground"
        >
          My Paths
        </Button>
        <Button
          :as="RouterLinkComp"
          to="/resources"
          variant="ghost"
          size="sm"
          class="h-8 rounded-none px-0 py-0 hover:bg-transparent text-xs font-medium tracking-[0.14em] uppercase text-muted-foreground hover:text-foreground"
        >
          Resources
        </Button>
        <Button
          :as="RouterLinkComp"
          to="/login"
          variant="ghost"
          size="sm"
          class="h-8 rounded-none px-0 py-0 hover:bg-transparent text-xs font-medium tracking-[0.14em] uppercase text-muted-foreground hover:text-foreground"
        >
          Login
        </Button>
        <Button
          :as="RouterLinkComp"
          to="/register"
          variant="ghost"
          size="sm"
          class="h-8 rounded-none px-0 py-0 hover:bg-transparent text-xs font-medium tracking-[0.14em] uppercase text-muted-foreground hover:text-foreground"
        >
          Sign Up
        </Button>
      </div>
      <div class="text-xs text-muted-foreground">
        © {{ new Date().getFullYear() }}
        <span class="tracking-tight">
          <span class="font-semibold text-foreground">Contrail</span>
        </span>.
        All rights reserved.
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
import { RouterLink } from 'vue-router'
import { Button } from './ui/button'

const RouterLinkComp = RouterLink
</script>
