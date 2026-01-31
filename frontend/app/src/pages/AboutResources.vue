<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Resources</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">
            Resources are the raw inputs of learning: videos, articles, documents, and links.
            Contrail helps you collect them into a single library and keeps them organized with metadata.
          </p>
        </div>
        <div class="md:col-span-4 md:flex md:justify-end md:items-end">
          <Button :as="RouterLinkComp" to="/my-resources" variant="outline" size="sm" class="rounded-none">View my resources</Button>
        </div>
      </div>
    </section>

    <section class="grid gap-6 md:grid-cols-2">
      <Card as="section" :hoverable="false" class="rounded-none">
        <div class="p-6 space-y-3">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">What you can store</h2>
          <ul class="space-y-2 text-sm leading-relaxed list-disc list-inside text-muted-foreground">
            <li>Videos (YouTube / Bilibili)</li>
            <li>Articles (blogs, newsletters)</li>
            <li>Documents (PDFs and docs)</li>
            <li>Links (to be converted later)</li>
          </ul>
        </div>
      </Card>
      <Card as="section" :hoverable="false" class="rounded-none">
        <div class="p-6 space-y-3">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Why it matters</h2>
          <ul class="space-y-2 text-sm leading-relaxed list-disc list-inside text-muted-foreground">
            <li>Less tab chaos and fewer lost links.</li>
            <li>Cleaner context when you return to learn.</li>
            <li>Better building blocks for learning paths.</li>
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
