<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="relative overflow-hidden rounded-xl border border-l-4 border-l-amber-500 border-border bg-gradient-to-r from-amber-50/60 via-white to-amber-50/30 pb-8">
      <div class="absolute right-6 top-6 opacity-30">
        <svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="hsl(38 92% 50%)" stroke-width="1" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
      </div>
      <div class="grid gap-6 md:grid-cols-12 md:items-end px-6 pt-6">
        <div class="md:col-span-8">
          <div class="inline-flex items-center gap-1.5 rounded-full border border-amber-200 bg-amber-50 px-3 py-1 mb-3">
            <span class="h-1.5 w-1.5 rounded-full bg-amber-500"></span>
            <span class="text-xs font-medium text-amber-600">Progress</span>
          </div>
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Progress</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-slate-600">
            Progress helps you keep continuity. Learnpathly stores progress per path item so you can resume learning without losing context.
          </p>
        </div>
        <div class="md:col-span-4 md:flex md:justify-end md:items-end">
          <Button :as="RouterLinkComp" to="/my-paths" variant="outline" size="sm" class="rounded-none border-amber-200 text-amber-700 hover:bg-amber-50">View my paths</Button>
        </div>
      </div>
    </section>

    <section class="grid gap-6 md:grid-cols-2">
      <Card as="section" :hoverable="false" class="rounded-none border-t-4 border-t-amber-500">
        <div class="p-6 space-y-3">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-amber-700">Tracked per step</h2>
          <ul class="space-y-2 text-sm leading-relaxed list-disc list-inside text-slate-600">
            <li>Mark a document/article as complete in one click.</li>
            <li>Videos can update progress when player APIs are available.</li>
          </ul>
        </div>
      </Card>
      <Card as="section" :hoverable="false" class="rounded-none border-t-4 border-t-amber-500">
        <div class="p-6 space-y-3">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-amber-700">Why it works</h2>
          <ul class="space-y-2 text-sm leading-relaxed list-disc list-inside text-slate-600">
            <li>Resuming is instant.</li>
            <li>You see completion at both step and path level.</li>
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
