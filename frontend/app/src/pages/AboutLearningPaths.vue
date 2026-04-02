<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="relative overflow-hidden rounded-xl border border-l-4 border-l-sky-500 border-border bg-gradient-to-r from-sky-50/60 via-white to-sky-50/30 pb-8">
      <div class="absolute right-6 top-6 opacity-30">
        <svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="hsl(197 94% 53%)" stroke-width="1" stroke-linecap="round" stroke-linejoin="round"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>
      </div>
      <div class="grid gap-6 md:grid-cols-12 md:items-end px-6 pt-6">
        <div class="md:col-span-8">
          <div class="inline-flex items-center gap-1.5 rounded-full border border-sky-200 bg-sky-50 px-3 py-1 mb-3">
            <span class="h-1.5 w-1.5 rounded-full bg-sky-500"></span>
            <span class="text-xs font-medium text-sky-600">Learning Paths</span>
          </div>
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Learning Paths</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-slate-600">
            Learning paths turn resources into a sequence: what to learn, in what order, and why.
            Build a path that matches your goal and keep it iterative.
          </p>
        </div>
        <div class="md:col-span-4 md:flex md:justify-end md:items-end">
          <Button :as="RouterLinkComp" to="/createpath" variant="outline" size="sm" class="rounded-none border-sky-200 text-sky-700 hover:bg-sky-50">Create a path</Button>
        </div>
      </div>
    </section>

    <section class="grid gap-6 md:grid-cols-2">
      <Card as="section" :hoverable="false" class="rounded-none border-t-4 border-t-sky-500">
        <div class="p-6 space-y-3">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-sky-700">How it works</h2>
          <ul class="space-y-2 text-sm leading-relaxed list-disc list-inside text-slate-600">
            <li>Select resources from your library.</li>
            <li>Arrange them into a sequence.</li>
            <li>Attach them to categories and set visibility.</li>
          </ul>
        </div>
      </Card>
      <Card as="section" :hoverable="false" class="rounded-none border-t-4 border-t-sky-500">
        <div class="p-6 space-y-3">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-sky-700">Path types</h2>
          <ul class="space-y-2 text-sm leading-relaxed list-disc list-inside text-slate-600">
            <li>
              <span class="inline-flex items-center gap-1 rounded bg-sky-50 px-1.5 py-0.5 text-xs text-sky-600 font-medium">Linear</span>
              step-by-step progression.
            </li>
            <li>
              <span class="inline-flex items-center gap-1 rounded bg-indigo-50 px-1.5 py-0.5 text-xs text-indigo-600 font-medium">Structured</span>
              modules with a stronger framework.
            </li>
            <li>
              <span class="inline-flex items-center gap-1 rounded bg-violet-50 px-1.5 py-0.5 text-xs text-violet-600 font-medium">Pool</span>
              a curated pool you can explore freely.
            </li>
          </ul>
        </div>
      </Card>
    </section>
  </div>
</template>

<script setup lang="ts">
import { RouterLink } from 'vue-router'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'

const RouterLinkComp = RouterLink
</script>
