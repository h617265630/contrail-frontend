<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <p class="text-xs font-medium tracking-[0.14em] uppercase text-muted-foreground">About</p>
          <h1 class="mt-3 text-3xl font-semibold tracking-tight text-foreground md:text-4xl">What is Contrail?</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">
            Contrail is a platform for building personal learning paths. It helps you turn scattered resources—found across
            YouTube, blogs, and course platforms—into a clear, actionable path you can actually finish.
            Instead of collecting links and losing momentum, you get structure, progress, and feedback in one place.
          </p>
        </div>
      </div>
    </section>

    <section class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
      <Card as="article" :hoverable="false" class="rounded-none">
        <div class="p-6 space-y-2">
          <h3 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Resources</h3>
          <p class="text-sm leading-relaxed text-muted-foreground">Import videos, articles, documents, and links—then manage them in one library instead of browser bookmarks.</p>
        </div>
      </Card>
      <Card as="article" :hoverable="false" class="rounded-none">
        <div class="p-6 space-y-2">
          <h3 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Learning Paths</h3>
          <p class="text-sm leading-relaxed text-muted-foreground">Drag resources into a path, reorder steps, and shape a learning rhythm that fits your goal and schedule.</p>
        </div>
      </Card>
      <Card as="article" :hoverable="false" class="rounded-none">
        <div class="p-6 space-y-2">
          <h3 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Progress</h3>
          <p class="text-sm leading-relaxed text-muted-foreground">Track progress per resource and see how much of a path you’ve completed—so learning stays continuous, not fragmented.</p>
        </div>
      </Card>
    </section>

    <section class="grid gap-6 md:grid-cols-2">
      <Card as="section" :hoverable="false" class="rounded-none">
        <div class="p-6 space-y-3">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Why Contrail</h2>
          <ul class="space-y-2 text-sm leading-relaxed list-disc list-inside text-muted-foreground">
            <li>Your learning resources are scattered across platforms and hard to organize systematically.</li>
            <li>You save a lot, but you don’t know where to start—or where you stopped.</li>
            <li>Learning happens in small fragments, but you lack a single framework to measure progress and outcomes.</li>
            <li>Contrail’s goal is to turn fragmented learning into structured, repeatable progress.</li>
          </ul>
        </div>
      </Card>
      <Card as="section" :hoverable="false" class="rounded-none">
        <div class="p-6 space-y-3">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Core Features</h2>
          <ul class="space-y-2 text-sm leading-relaxed list-disc list-inside text-muted-foreground">
            <li><span class="font-semibold text-foreground">Resource</span>: discover public resources and keep your own private library.</li>
            <li><span class="font-semibold text-foreground">Learning Path</span>: build a path by adding resources, reordering steps, and categorizing.</li>
            <li><span class="font-semibold text-foreground">Progress</span>: record learning progress per step and see overall completion at a glance.</li>
            <li><span class="font-semibold text-foreground">Personal Pool</span>: save quick ideas (links, images, notes) and turn them into resources later.</li>
            <li><span class="font-semibold text-foreground">Public & Private</span>: choose what you share and what stays personal.</li>
          </ul>
        </div>
      </Card>
    </section>
  </div>
</template>

<script setup lang="ts">
import Card from '../components/ui/Card.vue'
</script>
