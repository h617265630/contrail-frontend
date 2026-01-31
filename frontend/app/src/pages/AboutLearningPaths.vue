<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Learning Paths</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">
            Learning paths turn resources into a sequence: what to learn, in what order, and why.
            Build a path that matches your goal and keep it iterative.
          </p>
        </div>
        <div class="md:col-span-4 md:flex md:justify-end md:items-end">
          <Button :as="RouterLinkComp" to="/createpath" variant="outline" size="sm" class="rounded-none">Create a path</Button>
        </div>
      </div>
    </section>

    <section class="grid gap-6 md:grid-cols-2">
      <Card as="section" :hoverable="false" class="rounded-none">
        <div class="p-6 space-y-3">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">How it works</h2>
          <ul class="space-y-2 text-sm leading-relaxed list-disc list-inside text-muted-foreground">
            <li>Select resources from your library.</li>
            <li>Arrange them into a sequence.</li>
            <li>Attach them to categories and set visibility.</li>
          </ul>
        </div>
      </Card>
      <Card as="section" :hoverable="false" class="rounded-none">
        <div class="p-6 space-y-3">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Path types</h2>
          <ul class="space-y-2 text-sm leading-relaxed list-disc list-inside text-muted-foreground">
            <li>Linear path: step-by-step progression.</li>
            <li>Structured path: modules with a stronger framework.</li>
            <li>Partical pool: a curated pool you can explore freely.</li>
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
