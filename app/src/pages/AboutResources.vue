<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="relative overflow-hidden rounded-xl border border-l-4 border-l-emerald-500 border-border bg-gradient-to-r from-emerald-50/60 via-white to-emerald-50/30 pb-8">
      <div class="absolute right-6 top-6 opacity-30">
        <svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="hsl(160 84% 39%)" stroke-width="1" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
      </div>
      <div class="grid gap-6 md:grid-cols-12 md:items-end px-6 pt-6">
        <div class="md:col-span-8">
          <div class="inline-flex items-center gap-1.5 rounded-full border border-emerald-200 bg-emerald-50 px-3 py-1 mb-3">
            <span class="h-1.5 w-1.5 rounded-full bg-emerald-500"></span>
            <span class="text-xs font-medium text-emerald-600">Resources</span>
          </div>
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Resources</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-slate-600">
            Resources are the raw inputs of learning: videos, articles, documents, and links.
            Learnpathly helps you collect them into a single library and keeps them organized with metadata.
          </p>
        </div>
        <div class="md:col-span-4 md:flex md:justify-end md:items-end">
          <Button :as="RouterLinkComp" to="/my-resources" variant="outline" size="sm" class="rounded-none border-emerald-200 text-emerald-700 hover:bg-emerald-50">View my resources</Button>
        </div>
      </div>
    </section>

    <section class="grid gap-6 md:grid-cols-2">
      <Card as="section" :hoverable="false" class="rounded-none border-t-4 border-t-emerald-500">
        <div class="p-6 space-y-3">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-emerald-700">What you can store</h2>
          <ul class="space-y-2 text-sm leading-relaxed list-disc list-inside text-slate-600">
            <li><span class="inline-flex items-center gap-1 rounded bg-red-50 px-1.5 py-0.5 text-xs text-red-600 font-medium">Video</span> YouTube / Bilibili</li>
            <li><span class="inline-flex items-center gap-1 rounded bg-blue-50 px-1.5 py-0.5 text-xs text-blue-600 font-medium">Article</span> blogs, newsletters</li>
            <li><span class="inline-flex items-center gap-1 rounded bg-orange-50 px-1.5 py-0.5 text-xs text-orange-600 font-medium">Document</span> PDFs and docs</li>
            <li><span class="inline-flex items-center gap-1 rounded bg-slate-100 px-1.5 py-0.5 text-xs text-slate-600 font-medium">Link</span> to be converted later</li>
          </ul>
        </div>
      </Card>
      <Card as="section" :hoverable="false" class="rounded-none border-t-4 border-t-emerald-500">
        <div class="p-6 space-y-3">
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-emerald-700">Why it matters</h2>
          <ul class="space-y-2 text-sm leading-relaxed list-disc list-inside text-slate-600">
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
