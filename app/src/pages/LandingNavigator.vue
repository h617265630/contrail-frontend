<template>
  <div class="mx-auto max-w-7xl space-y-16 px-4 py-8">
    <section class="relative overflow-hidden rounded-none border border-border bg-white shadow-sm">
      <div class="absolute inset-0 bg-[linear-gradient(120deg,#eef7ff_0%,#ffffff_45%,#f0fbff_100%)]" aria-hidden="true" />
      <div class="relative grid gap-6 px-6 py-8 md:grid-cols-12 md:items-stretch md:px-10 md:py-12">
        <div class="space-y-6 md:col-span-8">
          <p class="text-xs font-semibold tracking-[0.16em] text-sky-700 uppercase">Landing V2 - Navigator</p>
          <h1 class="text-3xl font-semibold tracking-tight text-foreground md:text-5xl md:leading-tight">Discover, collect, and learn with visual paths</h1>
          <p class="max-w-3xl text-sm leading-relaxed text-muted-foreground md:text-base">
            Learnpathly combines AI generation and manual resource editing, so every learning path matches your pace and your goals.
          </p>

          <div class="grid gap-3 sm:grid-cols-3">
            <div class="rounded-md border border-border bg-white p-4">
              <p class="text-xs font-semibold tracking-[0.14em] text-muted-foreground uppercase">Mode A</p>
              <p class="mt-1 text-sm font-medium text-foreground">AI generated path</p>
            </div>
            <div class="rounded-md border border-border bg-white p-4">
              <p class="text-xs font-semibold tracking-[0.14em] text-muted-foreground uppercase">Mode B</p>
              <p class="mt-1 text-sm font-medium text-foreground">Manual resource editing</p>
            </div>
            <div class="rounded-md border border-border bg-white p-4">
              <p class="text-xs font-semibold tracking-[0.14em] text-muted-foreground uppercase">Outcome</p>
              <p class="mt-1 text-sm font-medium text-foreground">Track progress to completion</p>
            </div>
          </div>
        </div>

        <div class="md:col-span-4">
          <Card as="article" :hoverable="false" className="h-full rounded-md border-border bg-white">
            <form class="space-y-4 p-5" @submit.prevent="handleGeneratePath">
              <label for="navigator-topic" class="block text-sm font-medium text-foreground">What do you want to learn?</label>
              <Input
                id="navigator-topic"
                v-model="heroTopic"
                type="search"
                placeholder="Learn system design"
                class="h-11 rounded-none"
              />
              <Button type="submit" class="h-11 w-full rounded-none bg-[#8ecbff] text-slate-950 hover:bg-[#8ecbff]/90">Generate my learning path</Button>
              <Button type="button" variant="outline" class="h-10 w-full rounded-none" @click="handleManualBuild">Create path from my resources</Button>
              <p class="text-xs text-muted-foreground">Preview: {{ previewTitle }}</p>
            </form>
          </Card>
        </div>
      </div>
    </section>

    <section class="space-y-5">
      <h2 class="text-2xl font-semibold tracking-tight text-foreground">What problem you solve</h2>
      <div class="grid gap-4 md:grid-cols-3">
        <Card as="article" :hoverable="false" className="rounded-md border-border">
          <div class="space-y-2 p-5">
            <h3 class="text-base font-semibold text-foreground">Unstructured learning</h3>
            <p class="text-sm text-muted-foreground">Random resources create confusion and slow progress.</p>
          </div>
        </Card>
        <Card as="article" :hoverable="false" className="rounded-md border-border">
          <div class="space-y-2 p-5">
            <h3 class="text-base font-semibold text-foreground">No ownership</h3>
            <p class="text-sm text-muted-foreground">People need both AI guidance and manual control.</p>
          </div>
        </Card>
        <Card as="article" :hoverable="false" className="rounded-md border-border">
          <div class="space-y-2 p-5">
            <h3 class="text-base font-semibold text-foreground">No feedback loop</h3>
            <p class="text-sm text-muted-foreground">Without visible checkpoints, it is hard to finish a path.</p>
          </div>
        </Card>
      </div>
    </section>

    <section class="space-y-5">
      <h2 class="text-2xl font-semibold tracking-tight text-foreground">Example Learning Paths</h2>

      <div v-if="isLoadingPaths" class="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <Card v-for="idx in 4" :key="`navigator-loading-${idx}`" as="article" :hoverable="false" className="rounded-md border-border overflow-hidden">
          <div class="h-36 animate-pulse bg-slate-200" />
          <div class="space-y-2 p-4">
            <div class="h-4 w-3/4 animate-pulse rounded bg-slate-200" />
            <div class="h-3 w-5/6 animate-pulse rounded bg-slate-200" />
          </div>
        </Card>
      </div>

      <div v-else-if="hasPublicPaths" class="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <RouterLink v-for="card in exampleCards" :key="card.topic" :to="card.to" class="block">
          <Card as="article" :hoverable="true" className="h-full rounded-md border-border">
            <div class="relative h-36 bg-slate-100">
              <img :src="card.thumbnail" :alt="card.topic" class="h-full w-full object-cover" />
            </div>
            <div class="space-y-2 p-4">
              <h3 class="text-sm font-semibold text-foreground">{{ card.topic }}</h3>
              <p class="line-clamp-3 text-sm text-muted-foreground">{{ card.description }}</p>
            </div>
          </Card>
        </RouterLink>
      </div>

      <Card v-else as="article" :hoverable="false" className="rounded-md border-border">
        <div class="space-y-3 p-8 text-center">
          <p class="text-xs font-semibold tracking-[0.14em] uppercase text-muted-foreground">Empty</p>
          <h3 class="text-lg font-semibold text-foreground">No public learning paths found</h3>
          <p class="text-sm text-muted-foreground">Generate one with AI or build one manually from resources.</p>
          <div class="flex flex-wrap justify-center gap-2">
            <Button :as="RouterLinkComp" to="/createpath" class="h-10 rounded-none bg-[#8ecbff] px-6 text-slate-950 hover:bg-[#8ecbff]/90">Generate path</Button>
            <Button variant="outline" class="h-10 rounded-none" @click="handleManualBuild">Manual build</Button>
          </div>
        </div>
      </Card>
    </section>

    <section class="space-y-5">
      <h2 class="text-2xl font-semibold tracking-tight text-foreground">How it works</h2>
      <div class="grid gap-4 md:grid-cols-3">
        <Card v-for="step in howItWorks" :key="step.title" as="article" :hoverable="false" className="rounded-md border-border">
          <div class="space-y-3 p-5">
            <div class="inline-flex h-10 w-10 items-center justify-center rounded-full bg-sky-100 text-sky-700">
              <component :is="step.icon" class="h-5 w-5" />
            </div>
            <h3 class="text-base font-semibold text-foreground">{{ step.title }}</h3>
            <p class="text-sm text-muted-foreground">{{ step.description }}</p>
          </div>
        </Card>
      </div>
    </section>

    <section class="space-y-4 rounded-md border border-border bg-slate-950 p-6 text-white md:p-8">
      <h2 class="text-2xl font-semibold tracking-tight">Social proof</h2>
      <div class="grid gap-3 md:grid-cols-3">
        <div class="rounded-md border border-white/20 bg-white/5 p-4 text-sm text-white/85">{{ socialProofCount }}+ learning paths generated</div>
        <div class="rounded-md border border-white/20 bg-white/5 p-4 text-sm text-white/85">Used by developers and students</div>
        <div class="rounded-md border border-white/20 bg-white/5 p-4 text-sm text-white/85">Curated with high quality resources</div>
      </div>
    </section>

    <section class="space-y-4 border-t border-border pt-10 text-center">
      <h2 class="text-3xl font-semibold tracking-tight text-foreground">Create your next learning path</h2>
      <p class="mx-auto max-w-2xl text-sm text-muted-foreground">Start with AI generation or switch to manual editing when you want full resource control.</p>
      <div class="flex flex-wrap justify-center gap-3">
        <Button :as="RouterLinkComp" to="/createpath" class="h-11 rounded-none bg-[#8ecbff] px-8 text-slate-950 hover:bg-[#8ecbff]/90">Generate my learning path</Button>
        <Button variant="outline" class="h-11 rounded-none" @click="handleManualBuild">Manual resource mode</Button>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, type Component } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { Search, Sparkles, ListChecks } from 'lucide-vue-next'
import { listPublicLearningPaths, type PublicLearningPath } from '../api/learningPath'
import { Button } from '../components/ui/button'
import Card from '../components/ui/Card.vue'
import { Input } from '../components/ui/input'

const router = useRouter()
const RouterLinkComp = RouterLink

const heroTopic = ref('Learn system design')
const publicPaths = ref<PublicLearningPath[]>([])
const isLoadingPaths = ref(true)

const fallbackCovers = [
  'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?auto=format&fit=crop&w=900&h=600&q=80',
  'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=900&h=600&q=80',
  'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&w=900&h=600&q=80',
  'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?auto=format&fit=crop&w=900&h=600&q=80',
]

function normalize(text: string) {
  return String(text || '').trim().toLowerCase()
}

function includesKeyword(path: PublicLearningPath, keyword: string) {
  const source = [path.title, path.description, path.category_name].map((v) => normalize(String(v || ''))).join(' ')
  const keys = normalize(keyword).split(/\s+/).filter(Boolean)
  if (!keys.length) return false
  return keys.every((k) => source.includes(k)) || source.includes(normalize(keyword))
}

function findPathByKeyword(paths: PublicLearningPath[], keyword: string) {
  return paths.find((p) => includesKeyword(p, keyword))
}

const exampleTopics = [
  { topic: 'Learn Python', keyword: 'python', description: 'Practical Python roadmap from basics to projects.' },
  { topic: 'Learn Machine Learning', keyword: 'machine learning', description: 'Modeling workflow with clear milestones.' },
  { topic: 'Learn System Design', keyword: 'system design', description: 'Scalable architecture and trade-off practice.' },
  { topic: 'Learn Startup', keyword: 'startup', description: 'Build product thinking and early execution habits.' },
] as const

const exampleCards = computed(() => {
  const usedIds = new Set<number>()
  const pool = publicPaths.value

  return exampleTopics.map((item, idx) => {
    let matched = findPathByKeyword(pool, item.keyword)
    if (matched && usedIds.has(matched.id)) matched = undefined
    if (!matched) matched = pool.find((p) => !usedIds.has(p.id))

    if (matched) {
      usedIds.add(matched.id)
      return {
        topic: item.topic,
        description: matched.description || item.description,
        thumbnail: matched.cover_image_url || fallbackCovers[idx % fallbackCovers.length],
        to: { name: 'learningpath', params: { id: String(matched.id) } },
      }
    }

    return {
      topic: item.topic,
      description: item.description,
      thumbnail: fallbackCovers[idx % fallbackCovers.length],
      to: { name: 'createpath', query: { topic: item.topic } },
    }
  })
})

const howItWorks: Array<{ title: string; description: string; icon: Component }> = [
  { title: '1. Enter topic', description: 'Describe the capability you want to build.', icon: Search },
  { title: '2. Generate or manually craft', description: 'Use AI output or curate resources yourself.', icon: Sparkles },
  { title: '3. Learn with checkpoints', description: 'Complete each step and track progress over time.', icon: ListChecks },
]

const hasPublicPaths = computed(() => publicPaths.value.length > 0)
const socialProofCount = computed(() => Math.max(publicPaths.value.length, 200))
const previewTitle = computed(() => (heroTopic.value.trim() ? `${heroTopic.value.trim()} Roadmap` : 'Your Learning Roadmap'))

function handleGeneratePath() {
  const topic = heroTopic.value.trim()
  if (!topic) {
    router.push({ name: 'createpath' })
    return
  }
  const matched = findPathByKeyword(publicPaths.value, topic)
  if (matched) {
    router.push({ name: 'learningpath', params: { id: String(matched.id) } })
    return
  }
  router.push({ name: 'createpath', query: { topic } })
}

function handleManualBuild() {
  const topic = heroTopic.value.trim()
  router.push({ name: 'createpath', query: topic ? { mode: 'manual', topic } : { mode: 'manual' } })
}

onMounted(async () => {
  isLoadingPaths.value = true
  try {
    publicPaths.value = await listPublicLearningPaths()
  } catch {
    publicPaths.value = []
  } finally {
    isLoadingPaths.value = false
  }
})
</script>
