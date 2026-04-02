<template>
  <div class="mx-auto max-w-7xl space-y-16 px-4 py-8">
    <section class="relative overflow-hidden rounded-md border border-border bg-slate-950 text-white shadow-2xl">
      <div class="absolute inset-0 bg-[radial-gradient(circle_at_20%_20%,rgba(142,203,255,0.32),transparent_42%),radial-gradient(circle_at_82%_76%,rgba(56,189,248,0.28),transparent_38%)]" aria-hidden="true" />
      <div class="relative grid gap-8 px-6 py-8 md:grid-cols-12 md:items-center md:px-10 md:py-12">
        <div class="space-y-5 md:col-span-7">
          <p class="text-xs font-semibold tracking-[0.16em] text-sky-200 uppercase">Landing V1 - Studio</p>
          <h1 class="text-3xl font-semibold tracking-tight md:text-5xl md:leading-tight">Learn anything with structured AI learning paths</h1>
          <p class="max-w-2xl text-sm leading-relaxed text-white/80 md:text-base">
            Generate your roadmap with AI, or manually build and edit a path from your own curated resources.
          </p>

          <form class="space-y-3" @submit.prevent="handleGeneratePath">
            <label for="studio-topic" class="block text-sm font-medium text-white">What do you want to learn?</label>
            <div class="flex flex-col gap-3 sm:flex-row">
              <Input
                id="studio-topic"
                v-model="heroTopic"
                type="search"
                placeholder="Learn Python for AI"
                class="h-11 rounded-none border-white/35 bg-white/95 text-foreground placeholder:text-slate-500 sm:flex-1"
              />
              <Button type="submit" class="h-11 rounded-none bg-[#8ecbff] px-6 text-slate-950 hover:bg-[#8ecbff]/90">Generate</Button>
            </div>
            <div class="flex flex-wrap items-center gap-3 text-sm text-white/85">
              <span>Need full control?</span>
              <Button
                type="button"
                variant="outline"
                class="h-9 rounded-none border-white/50 bg-transparent text-white hover:bg-white/15 hover:text-white"
                @click="handleManualBuild"
              >
                Build manually with resources
              </Button>
            </div>
          </form>
        </div>

        <div class="md:col-span-5">
          <Card as="article" :hoverable="false" className="rounded-md border-white/25 bg-white/10 backdrop-blur-md">
            <div class="space-y-4 p-5">
              <p class="text-xs font-semibold tracking-[0.14em] text-white/70 uppercase">Roadmap Preview</p>
              <h2 class="text-lg font-semibold text-white">{{ previewTitle }}</h2>
              <div class="space-y-2 text-sm text-white/80">
                <p>1. Fundamentals and key vocabulary</p>
                <p>2. High quality resources in sequence</p>
                <p>3. Practice tasks and progress checkpoints</p>
              </div>
            </div>
          </Card>
        </div>
      </div>
    </section>

    <section class="space-y-5">
      <div class="space-y-2">
        <h2 class="text-2xl font-semibold tracking-tight text-foreground">What problem Learnpathly solves</h2>
        <p class="max-w-3xl text-sm leading-relaxed text-muted-foreground md:text-base">
          Most learners save links but never turn them into a clear learning system. Learnpathly converts scattered content into a path you can finish.
        </p>
      </div>
      <div class="grid gap-4 md:grid-cols-3">
        <Card as="article" :hoverable="false" className="rounded-md border-border">
          <div class="space-y-2 p-5">
            <h3 class="text-sm font-semibold tracking-[0.14em] uppercase text-foreground">Scattered resources</h3>
            <p class="text-sm text-muted-foreground">Videos, docs, and articles are spread across tools and tabs.</p>
          </div>
        </Card>
        <Card as="article" :hoverable="false" className="rounded-md border-border">
          <div class="space-y-2 p-5">
            <h3 class="text-sm font-semibold tracking-[0.14em] uppercase text-foreground">No learning sequence</h3>
            <p class="text-sm text-muted-foreground">Without order, it is hard to know what to learn next.</p>
          </div>
        </Card>
        <Card as="article" :hoverable="false" className="rounded-md border-border">
          <div class="space-y-2 p-5">
            <h3 class="text-sm font-semibold tracking-[0.14em] uppercase text-foreground">Weak momentum</h3>
            <p class="text-sm text-muted-foreground">Progress is invisible, so motivation drops quickly.</p>
          </div>
        </Card>
      </div>
    </section>

    <section class="space-y-5">
      <div class="space-y-2">
        <h2 class="text-2xl font-semibold tracking-tight text-foreground">Example Learning Paths</h2>
        <p class="text-sm text-muted-foreground">Real paths from your existing public learning data.</p>
      </div>

      <div v-if="isLoadingPaths" class="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <Card v-for="idx in 4" :key="`studio-loading-${idx}`" as="article" :hoverable="false" className="rounded-md border-border overflow-hidden">
          <div class="h-32 animate-pulse bg-slate-200" />
          <div class="space-y-2 p-4">
            <div class="h-4 w-2/3 animate-pulse rounded bg-slate-200" />
            <div class="h-3 w-full animate-pulse rounded bg-slate-200" />
          </div>
        </Card>
      </div>

      <div v-else-if="hasPublicPaths" class="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <RouterLink v-for="card in exampleCards" :key="card.topic" :to="card.to" class="block">
          <Card as="article" :hoverable="true" className="h-full rounded-md border-border">
            <div class="relative h-32 bg-slate-100">
              <img :src="card.thumbnail" :alt="card.topic" class="h-full w-full object-cover" />
              <span class="absolute right-3 top-3 rounded-sm border border-border bg-white/95 px-2 py-1 text-[10px] font-semibold tracking-[0.14em] text-foreground uppercase">{{ card.badge }}</span>
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
          <h3 class="text-lg font-semibold text-foreground">No learning paths yet</h3>
          <p class="text-sm text-muted-foreground">Create your first path to populate this section.</p>
          <div>
            <Button :as="RouterLinkComp" to="/createpath" class="h-10 rounded-none bg-[#8ecbff] px-6 text-slate-950 hover:bg-[#8ecbff]/90">Create your first path</Button>
          </div>
        </div>
      </Card>
    </section>

    <section class="space-y-5">
      <div class="space-y-2">
        <h2 class="text-2xl font-semibold tracking-tight text-foreground">How it works</h2>
      </div>
      <div class="grid gap-4 md:grid-cols-3">
        <Card v-for="step in howItWorks" :key="step.title" as="article" :hoverable="false" className="rounded-md border-border">
          <div class="space-y-3 p-5">
            <div class="inline-flex h-10 w-10 items-center justify-center rounded-sm bg-sky-100 text-sky-700">
              <component :is="step.icon" class="h-5 w-5" />
            </div>
            <h3 class="text-base font-semibold text-foreground">{{ step.title }}</h3>
            <p class="text-sm text-muted-foreground">{{ step.description }}</p>
          </div>
        </Card>
      </div>
    </section>

    <section class="rounded-md border border-border bg-[#f7fbff] p-6 md:p-8">
      <h2 class="text-2xl font-semibold tracking-tight text-foreground">Social proof</h2>
      <div class="mt-4 grid gap-3 md:grid-cols-3">
        <div class="rounded-md border border-border bg-white p-4 text-sm text-muted-foreground">{{ socialProofCount }}+ learning paths generated</div>
        <div class="rounded-md border border-border bg-white p-4 text-sm text-muted-foreground">Used by developers and students</div>
        <div class="rounded-md border border-border bg-white p-4 text-sm text-muted-foreground">Curated with high quality resources</div>
      </div>
    </section>

    <section class="space-y-4 border-t border-border pt-10 text-center">
      <h2 class="text-3xl font-semibold tracking-tight text-foreground">Ready to build your roadmap?</h2>
      <p class="mx-auto max-w-2xl text-sm text-muted-foreground">Start with AI generation or manually craft your path from selected resources.</p>
      <div class="flex flex-wrap justify-center gap-3">
        <Button :as="RouterLinkComp" to="/createpath" class="h-11 rounded-none bg-[#8ecbff] px-8 text-slate-950 hover:bg-[#8ecbff]/90">Create your first learning path</Button>
        <Button variant="outline" class="h-11 rounded-none" @click="handleManualBuild">Manual edit mode</Button>
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

const heroTopic = ref('Learn Python for AI')
const publicPaths = ref<PublicLearningPath[]>([])
const isLoadingPaths = ref(true)

const fallbackCovers = [
  'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?auto=format&fit=crop&w=900&h=600&q=80',
  'https://images.unsplash.com/photo-1487058792275-0ad4aaf24ca7?auto=format&fit=crop&w=900&h=600&q=80',
  'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&w=900&h=600&q=80',
  'https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&w=900&h=600&q=80',
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
  { topic: 'Learn Python', keyword: 'python', description: 'Start from Python basics and move toward practical coding projects.' },
  { topic: 'Learn Machine Learning', keyword: 'machine learning', description: 'Understand models, training workflows, and evaluation in a clear order.' },
  { topic: 'Learn System Design', keyword: 'system design', description: 'Practice scalable architecture, trade-offs, and interview-ready thinking.' },
  { topic: 'Learn Startup', keyword: 'startup', description: 'Learn product thinking, user validation, and execution fundamentals.' },
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
        badge: 'Live path',
        to: { name: 'learningpath', params: { id: String(matched.id) } },
      }
    }

    return {
      topic: item.topic,
      description: item.description,
      thumbnail: fallbackCovers[idx % fallbackCovers.length],
      badge: 'Generate',
      to: { name: 'createpath', query: { topic: item.topic } },
    }
  })
})

const howItWorks: Array<{ title: string; description: string; icon: Component }> = [
  { title: '1. Enter topic', description: 'Describe what you want to learn in one line.', icon: Search },
  { title: '2. Generate or curate', description: 'Use AI generation or manually select resources.', icon: Sparkles },
  { title: '3. Execute and track', description: 'Follow the path and track progress to completion.', icon: ListChecks },
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
