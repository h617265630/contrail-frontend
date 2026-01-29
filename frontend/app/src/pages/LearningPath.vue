<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <p class="text-xs font-medium tracking-[0.14em] uppercase text-muted-foreground">LearningPool</p>
          <h1 class="mt-3 text-3xl font-semibold tracking-tight text-foreground md:text-4xl">LearningPool</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">浏览所有 learning paths，并按分类快速发现热门与 AI 相关内容</p>
        </div>
      </div>
    </section>

      <!-- Section 1: Categories (8 labels) -->
      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">分类</h2>
            <p class="text-sm text-muted-foreground">8 categories</p>
          </div>
        </div>
        <div class="flex flex-wrap gap-3">
          <Button
            v-for="cat in categories"
            :key="cat"
            :as="RouterLinkComp"
            :to="{ name: 'learningpool-category', params: { category: cat } }"
            variant="outline"
            size="sm"
            class="rounded-none text-xs font-medium tracking-[0.14em] uppercase"
          >
            {{ cat }}
          </Button>
        </div>
      </section>

      <!-- Section 2: Hot paths -->
      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">热门 learning paths</h2>
            <p class="text-sm text-muted-foreground">Top picks</p>
          </div>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <RouterLink
            v-for="p in hotPaths"
            :key="p.id"
            :to="{ name: 'learningpath', params: { id: p.id } }"
            class="block"
          >
            <Card as="article" :hoverable="true">
              <div class="h-36 bg-muted">
                <img :src="p.thumbnail" :alt="p.title" class="w-full h-full object-cover" />
              </div>
              <div class="p-4 space-y-2">
                <div class="flex items-start justify-between gap-2">
                  <h3 class="text-foreground font-semibold line-clamp-1" :title="p.title">{{ p.title }}</h3>
                  <span class="px-2 py-1 rounded-full border border-border bg-background text-xs font-semibold text-foreground">HOT</span>
                </div>
                <p class="text-muted-foreground text-sm line-clamp-2" :title="p.description">{{ p.description }}</p>
                <div class="flex flex-wrap gap-2">
                  <span class="px-2 py-1 rounded-full border border-border bg-background text-xs font-semibold text-foreground">{{ p.category }}</span>
                  <span class="px-2 py-1 rounded-full border border-border bg-background text-xs text-muted-foreground">{{ p.level }}</span>
                </div>
              </div>
            </Card>
          </RouterLink>
        </div>
      </section>

      <!-- Section 3: AI related -->
      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">AI 相关</h2>
            <p class="text-sm text-muted-foreground">AI</p>
          </div>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <RouterLink
            v-for="p in aiPaths"
            :key="p.id"
            :to="{ name: 'learningpath', params: { id: p.id } }"
            class="block"
          >
            <Card as="article" :hoverable="true" class="p-5">
              <div class="flex items-start justify-between gap-3">
                <div class="min-w-0">
                  <h3 class="text-foreground font-semibold line-clamp-1" :title="p.title">{{ p.title }}</h3>
                  <p class="text-muted-foreground text-sm mt-1 line-clamp-2" :title="p.description">{{ p.description }}</p>
                </div>
                <span class="px-2 py-1 rounded-full border border-border bg-background text-xs font-semibold text-foreground">AI</span>
              </div>
              <div class="mt-4 flex flex-wrap gap-2">
                <span class="px-2 py-1 rounded-full border border-border bg-background text-xs font-semibold text-foreground">{{ p.category }}</span>
                <span class="px-2 py-1 rounded-full border border-border bg-background text-xs text-muted-foreground">{{ p.level }}</span>
              </div>
            </Card>
          </RouterLink>
        </div>
      </section>

      <!-- Section 4: Other -->
      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">其他</h2>
            <p class="text-sm text-muted-foreground">Non-AI</p>
          </div>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <RouterLink
            v-for="p in otherPaths"
            :key="p.id"
            :to="{ name: 'learningpath', params: { id: p.id } }"
            class="block"
          >
            <Card as="article" :hoverable="true">
              <div class="p-5 space-y-2">
                <div class="flex items-center justify-between gap-3">
                  <h3 class="text-foreground font-semibold line-clamp-1" :title="p.title">{{ p.title }}</h3>
                  <span class="px-2 py-1 rounded-full border border-border bg-background text-xs text-muted-foreground">{{ p.category }}</span>
                </div>
                <p class="text-muted-foreground text-sm line-clamp-3" :title="p.description">{{ p.description }}</p>
                <div class="flex flex-wrap gap-2">
                  <span class="px-2 py-1 rounded-full border border-border bg-background text-xs font-semibold text-foreground">{{ p.level }}</span>
                  <span class="px-2 py-1 rounded-full border border-border bg-background text-xs text-muted-foreground">{{ p.items }} items</span>
                </div>
              </div>
            </Card>
          </RouterLink>
        </div>
      </section>

      <!-- Section 5: Waterfall (all paths) -->
      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">全部（瀑布流）</h2>
            <p class="text-sm text-muted-foreground">{{ allPaths.length }} total</p>
          </div>
        </div>

        <div class="columns-1 sm:columns-2 md:columns-3 lg:columns-5 gap-4">
          <RouterLink
            v-for="p in allPaths"
            :key="p.id"
            :to="{ name: 'learningpath', params: { id: p.id } }"
            class="block mb-4 break-inside-avoid"
          >
            <Card as="article" :hoverable="true">
              <div class="h-32 bg-muted">
                <img :src="p.thumbnail" :alt="p.title" class="w-full h-full object-cover" />
              </div>
              <div class="p-5 space-y-2">
                <div class="flex items-start justify-between gap-2">
                  <h3 class="text-foreground font-semibold line-clamp-2" :title="p.title">{{ p.title }}</h3>
                  <span v-if="p.isAI" class="px-2 py-1 rounded-full border border-border bg-background text-xs font-semibold text-foreground">AI</span>
                </div>
                <p class="text-muted-foreground text-sm whitespace-pre-wrap">{{ p.description }}</p>
                <div class="flex flex-wrap gap-2">
                  <span class="px-2 py-1 rounded-full border border-border bg-background text-xs font-semibold text-foreground">{{ p.category }}</span>
                  <span class="px-2 py-1 rounded-full border border-border bg-background text-xs text-muted-foreground">{{ p.level }}</span>
                  <span class="px-2 py-1 rounded-full border border-border bg-background text-xs text-muted-foreground">{{ p.items }} items</span>
                </div>
              </div>
            </Card>
          </RouterLink>
        </div>
      </section>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { listPublicLearningPaths, mapPublicLearningPathToDisplayBase } from '../api/learningPath'
import { RouterLink } from 'vue-router'
import { Button } from '../components/ui/button'
import Card from '../components/ui/Card.vue'

const RouterLinkComp = RouterLink

const categories = ['AI','Frontend','Backend','DevOps','Database','Design','Product','Career']

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

type LearningPoolPath = {
  id: string
  title: string
  description: string
  category: string
  level: string
  items: number
  thumbnail: string
  hotScore: number
  isAI: boolean
}

const allPaths = ref<LearningPoolPath[]>([])

function mapDbToPool(p: any): LearningPoolPath {
  const base = mapPublicLearningPathToDisplayBase(p)
  const category = base.categoryName || inferCategoryFromText(`${base.title}\n${base.description}`)
  const thumbnail = base.thumbnail || 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=900&h=506&fit=crop'
  return {
    id: base.id,
    title: base.title,
    description: base.description || '（无介绍）',
    category,
    level: 'Beginner',
    items: 0,
    thumbnail,
    hotScore: 50,
    isAI: category === 'AI',
  }
}

onMounted(async () => {
  try {
    const db = await listPublicLearningPaths()
    const mapped = (db || []).map(mapDbToPool)
    allPaths.value = mapped
  } catch {
    // keep static fallback
  }
})

const hotPaths = computed(() => [...allPaths.value].sort((a, b) => b.hotScore - a.hotScore).slice(0, 4))
const aiPaths = computed(() => allPaths.value.filter(p => p.isAI))
const otherPaths = computed(() => allPaths.value.filter(p => !p.isAI))
</script>
