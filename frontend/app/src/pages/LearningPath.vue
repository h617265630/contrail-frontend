<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
      <!-- Section 1: Categories (8 labels) -->
      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">LearningPool</h2>
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

      <!-- Section 2: Top picks -->
      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Trending learning paths</h2>
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
              <div class="relative h-36 bg-muted">
                <img :src="p.thumbnail" :alt="p.title" class="w-full h-full object-cover" />
                <span
                  v-if="p.lpType"
                  class="absolute right-3 top-3 px-2 py-1 rounded-full border border-border bg-background text-[10px] font-semibold tracking-[0.14em] uppercase text-foreground"
                >
                  {{ p.lpType }}
                </span>
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

      <!-- Section 3: Linear path -->
      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Linear path</h2>
            <p class="text-sm text-muted-foreground">linear path</p>
          </div>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <RouterLink
            v-for="p in linearPaths"
            :key="p.id"
            :to="{ name: 'learningpath', params: { id: p.id } }"
            class="block"
          >
            <Card as="article" :hoverable="true">
              <div class="relative h-36 bg-muted">
                <img :src="p.thumbnail" :alt="p.title" class="w-full h-full object-cover" />
                <span
                  v-if="p.lpType"
                  class="absolute right-3 top-3 px-2 py-1 rounded-full border border-border bg-background text-[10px] font-semibold tracking-[0.14em] uppercase text-foreground"
                >
                  {{ p.lpType }}
                </span>
              </div>
              <div class="p-4 space-y-2">
                <div class="flex items-start justify-between gap-2">
                  <h3 class="text-foreground font-semibold line-clamp-1" :title="p.title">{{ p.title }}</h3>
                  <span class="px-2 py-1 rounded-full border border-border bg-background text-xs font-semibold text-foreground">LINEAR</span>
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

      <!-- Section 4: Structured path -->
      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Structured path</h2>
            <p class="text-sm text-muted-foreground">structured path</p>
          </div>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <RouterLink
            v-for="p in structuredPaths"
            :key="p.id"
            :to="{ name: 'learningpath', params: { id: p.id } }"
            class="block"
          >
            <Card as="article" :hoverable="true">
              <div class="relative h-36 bg-muted">
                <img :src="p.thumbnail" :alt="p.title" class="w-full h-full object-cover" />
                <span
                  v-if="p.lpType"
                  class="absolute right-3 top-3 px-2 py-1 rounded-full border border-border bg-background text-[10px] font-semibold tracking-[0.14em] uppercase text-foreground"
                >
                  {{ p.lpType }}
                </span>
              </div>
              <div class="p-4 space-y-2">
                <div class="flex items-start justify-between gap-2">
                  <h3 class="text-foreground font-semibold line-clamp-1" :title="p.title">{{ p.title }}</h3>
                  <span class="px-2 py-1 rounded-full border border-border bg-background text-xs font-semibold text-foreground">STRUCTURED</span>
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

      <!-- Section 5: Partical pool -->
      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Partical pool</h2>
            <p class="text-sm text-muted-foreground">partical pool</p>
          </div>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <RouterLink
            v-for="p in particalPoolPaths"
            :key="p.id"
            :to="{ name: 'learningpath', params: { id: p.id } }"
            class="block"
          >
            <Card as="article" :hoverable="true">
              <div class="relative h-36 bg-muted">
                <img :src="p.thumbnail" :alt="p.title" class="w-full h-full object-cover" />
                <span
                  v-if="p.lpType"
                  class="absolute right-3 top-3 px-2 py-1 rounded-full border border-border bg-background text-[10px] font-semibold tracking-[0.14em] uppercase text-foreground"
                >
                  {{ p.lpType }}
                </span>
              </div>
              <div class="p-4 space-y-2">
                <div class="flex items-start justify-between gap-2">
                  <h3 class="text-foreground font-semibold line-clamp-1" :title="p.title">{{ p.title }}</h3>
                  <span class="px-2 py-1 rounded-full border border-border bg-background text-xs font-semibold text-foreground">POOL</span>
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

      <!-- Section 6: Other -->
      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Other</h2>
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
            <Card as="article" :hoverable="true" class="relative">
              <span
                v-if="p.lpType"
                class="absolute right-4 top-4 px-2 py-1 rounded-full border border-border bg-background text-[10px] font-semibold tracking-[0.14em] uppercase text-foreground"
              >
                {{ p.lpType }}
              </span>
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

      <!-- Section 7: Waterfall (all paths) -->
      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">All (masonry)</h2>
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
import { listCategories, type Category } from '../api/category'
import { RouterLink } from 'vue-router'
import { Button } from '../components/ui/button'
import Card from '../components/ui/Card.vue'

const RouterLinkComp = RouterLink

const categories = ref<string[]>([])

function inferCategoryFromText(text: string): string {
  const t = text.toLowerCase()
  // Try matching against loaded category names
  for (const cat of categories.value) {
    if (t.includes(cat.toLowerCase())) return cat
  }
  // Keyword fallback
  if (t.includes('ai') || t.includes('llm') || t.includes('rag') || t.includes('agent')) return 'AI'
  if (t.includes('front') || t.includes('vue') || t.includes('react') || t.includes('css')) return 'Frontend'
  if (t.includes('back') || t.includes('api') || t.includes('fastapi') || t.includes('node')) return 'Backend'
  if (t.includes('devops') || t.includes('docker') || t.includes('k8s') || t.includes('kubernetes') || t.includes('ci')) return 'DevOps'
  if (t.includes('design') || t.includes('figma') || t.includes('ux')) return 'Design'
  return categories.value[0] || 'Other'
}

type LearningPoolPath = {
  id: string
  title: string
  description: string
  category: string
  lpType: string
  level: string
  items: number
  thumbnail: string
  hotScore: number
}

const allPaths = ref<LearningPoolPath[]>([])

function mapDbToPool(p: any): LearningPoolPath {
  const base = mapPublicLearningPathToDisplayBase(p)
  const category = base.categoryName || inferCategoryFromText(`${base.title}\n${base.description}`)
  const thumbnail = base.thumbnail || 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=900&h=506&fit=crop'
  const lpType = String((p as any)?.type || '').trim().toLowerCase()
  return {
    id: base.id,
    title: base.title,
    description: base.description || '(No description)',
    category,
    lpType,
    level: 'Beginner',
    items: 0,
    thumbnail,
    hotScore: 50,
  }
}

onMounted(async () => {
  try {
    const [db, cats] = await Promise.all([
      listPublicLearningPaths(),
      listCategories(),
    ])
    categories.value = (cats || []).map((c: Category) => c.name)
    const mapped = (db || []).map(mapDbToPool)
    allPaths.value = mapped
  } catch {
    // keep static fallback
  }
})

const hotPaths = computed(() => [...allPaths.value].sort((a, b) => b.hotScore - a.hotScore).slice(0, 4))

const linearPaths = computed(() =>
  allPaths.value
    .filter(p => p.lpType === 'linear path')
    .slice()
    .sort((a, b) => b.hotScore - a.hotScore)
    .slice(0, 4),
)

const structuredPaths = computed(() =>
  allPaths.value
    .filter(p => p.lpType === 'structured path')
    .slice()
    .sort((a, b) => b.hotScore - a.hotScore)
    .slice(0, 4),
)

const particalPoolPaths = computed(() =>
  allPaths.value
    .filter(p => p.lpType === 'partical pool')
    .slice()
    .sort((a, b) => b.hotScore - a.hotScore)
    .slice(0, 4),
)

const otherPaths = computed(() =>
  allPaths.value.filter(p => !['linear path', 'structured path', 'partical pool'].includes(p.lpType)),
)
</script>
