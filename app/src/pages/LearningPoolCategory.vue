<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Category: {{ category }}</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">Browse learning paths under this category.</p>
        </div>
        <div class="md:col-span-4 md:flex md:justify-end md:items-end">
          <Button :as="RouterLinkComp" to="/learningpool" variant="outline" size="sm" class="rounded-none">Back</Button>
        </div>
      </div>
    </section>

    <section class="space-y-4">
      <div class="flex items-center justify-between">
        <div>
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Results</h2>
          <p class="text-sm text-muted-foreground">{{ filteredPaths.length }} paths</p>
        </div>
      </div>

      <div v-if="filteredPaths.length" class="columns-1 sm:columns-2 lg:columns-3 gap-4">
        <RouterLink
          v-for="p in filteredPaths"
          :key="p.id"
          :to="{ name: 'learningpath', params: { id: p.id } }"
          class="block mb-4 break-inside-avoid"
        >
          <Card as="article" :hoverable="true" class="rounded-none overflow-hidden">
            <div class="relative h-32 bg-muted">
              <img :src="p.thumbnail" :alt="p.title" class="w-full h-full object-cover" />
              <span
                v-if="p.lpType"
                class="absolute right-3 top-3 px-2 py-1 rounded-full border border-border bg-background text-[10px] font-semibold tracking-[0.14em] uppercase text-foreground"
              >
                {{ p.lpType }}
              </span>
            </div>
            <div class="p-5 space-y-2">
              <div class="flex items-start justify-between gap-2">
                <h3 class="text-foreground font-semibold line-clamp-2" :title="p.title">{{ p.title }}</h3>
              </div>
              <p class="text-muted-foreground text-sm whitespace-pre-wrap">{{ p.description }}</p>
              <div class="flex flex-wrap gap-2">
                <span class="px-2 py-1 rounded-none border border-border bg-background text-xs font-semibold text-foreground">{{ p.category }}</span>
                <span class="px-2 py-1 rounded-none border border-border bg-background text-xs text-muted-foreground">{{ p.level }}</span>
                <span class="px-2 py-1 rounded-none border border-border bg-background text-xs text-muted-foreground">{{ p.items }} items</span>
              </div>
            </div>
          </Card>
        </RouterLink>
      </div>

      <Card v-else as="section" :hoverable="false" class="rounded-none">
        <div class="p-6 text-sm text-muted-foreground">No learning paths found for category: {{ category }}.</div>
      </Card>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute, RouterLink } from 'vue-router'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'
import { listPublicLearningPaths, mapPublicLearningPathToDisplayBase } from '../api/learningPath'

const RouterLinkComp = RouterLink

const route = useRoute()
const category = computed(() => decodeURIComponent(String(route.params.category || '')))

type PoolCard = {
  id: string
  title: string
  description: string
  category: string
  level: string
  items: number
  thumbnail: string
  hotScore: number
  lpType: string
}

const dynamicPaths = ref<PoolCard[]>([])

function inferCategoryFromText(text: string): string {
  const t = text.toLowerCase()
  if (t.includes('ai') || t.includes('llm') || t.includes('rag') || t.includes('agent')) return 'AI'
  if (t.includes('front') || t.includes('vue') || t.includes('react') || t.includes('css')) return 'Frontend'
  if (t.includes('back') || t.includes('api') || t.includes('fastapi') || t.includes('node')) return 'Backend'
  if (t.includes('devops') || t.includes('docker') || t.includes('k8s') || t.includes('kubernetes') || t.includes('ci')) return 'DevOps'
  if (t.includes('db') || t.includes('sql') || t.includes('database') || t.includes('postgres')) return 'Database'
  if (t.includes('design') || t.includes('figma') || t.includes('ux')) return 'Design'
  if (t.includes('product') || t.includes('pm') || t.includes('roadmap')) return 'Product'
  if (t.includes('career') || t.includes('resume') || t.includes('interview')) return 'Career'
  return 'Backend'
}

function mapDbToPool(p: any): PoolCard {
  const base = mapPublicLearningPathToDisplayBase(p as any)
  const title = base.title
  const description = base.description
  const cat = base.categoryName || inferCategoryFromText(`${title}\n${description}`)
  const thumbnail = base.thumbnail || 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=900&h=506&fit=crop'
  return {
    id: base.id,
    title,
    description: description || '（无介绍）',
    category: cat,
    level: 'Beginner',
    items: 0,
    thumbnail,
    hotScore: 50,
    lpType: String((p as any)?.type || '').trim(),
  }
}

onMounted(async () => {
  try {
    const db = await listPublicLearningPaths()
    dynamicPaths.value = (db || []).map(mapDbToPool)
  } catch {
    dynamicPaths.value = []
  }
})

const filteredPaths = computed(() => {
  return dynamicPaths.value.filter(p => p.category === category.value)
})
</script>
