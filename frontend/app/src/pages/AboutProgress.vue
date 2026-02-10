<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Progress</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">
            Progress helps you keep continuity. linktopath stores progress per path item so you can resume learning without losing context.
          </p>
        </div>
        <div class="md:col-span-4 md:flex md:justify-end md:items-end">
          <Button :as="RouterLinkComp" to="/my-paths" variant="outline" size="sm" class="rounded-none">View my paths</Button>
        </div>
      </div>
    </section>

    <section class="grid gap-6 md:grid-cols-2">
      <Card as="section" :hoverable="false" class="rounded-none">
        <div class="p-6 space-y-3">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Tracked per step</h2>
          <ul class="space-y-2 text-sm leading-relaxed list-disc list-inside text-muted-foreground">
            <li>Mark a document/article as complete in one click.</li>
            <li>Videos can update progress when player APIs are available.</li>
          </ul>
        </div>
      </Card>
      <Card as="section" :hoverable="false" class="rounded-none">
        <div class="p-6 space-y-3">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Why it works</h2>
          <ul class="space-y-2 text-sm leading-relaxed list-disc list-inside text-muted-foreground">
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
