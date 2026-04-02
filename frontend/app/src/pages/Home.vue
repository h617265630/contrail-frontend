<template>
  <div class="mx-auto max-w-7xl px-4 py-8 -mt-4 md:-mt-6">

    <!-- Hero Banner -->
    <section
      class="relative overflow-hidden rounded-2xl mb-16 min-h-[380px] md:min-h-[440px]"
      @mouseenter="pauseCarousel"
      @mouseleave="resumeCarousel"
    >
      <img
        :src="bannerSlides[activeBannerIndex].image"
        alt=""
        loading="eager"
        decoding="async"
        fetchpriority="high"
        class="absolute inset-0 w-full h-full object-cover"
      />
      <div class="absolute inset-0 bg-gradient-to-r from-slate-900/80 via-slate-900/40 to-transparent" />
      <div class="absolute inset-0 bg-gradient-to-t from-slate-900/60 via-transparent to-transparent" />

      <div class="relative h-full min-h-[380px] md:min-h-[440px] flex flex-col justify-end pb-10 px-8 md:px-12">
        <div class="max-w-xl space-y-5">
          <!-- Tag -->
          <div class="inline-flex items-center gap-2">
            <span class="h-px w-8 bg-blue-400"></span>
            <span class="text-xs font-semibold uppercase tracking-[0.2em] text-blue-300">Learnpathly</span>
          </div>

          <template v-if="activeBannerIndex === 0">
            <h1 class="text-3xl md:text-4xl font-semibold tracking-tight leading-[1.1] text-white">
              Build system-level skills with structured learning paths
            </h1>
            <p class="text-sm text-white/70 leading-relaxed max-w-md">
              A Learning Path Platform: create and discover great learning paths, turn scattered knowledge into an actionable plan, and track progress as you improve over time.
            </p>
            <div class="flex flex-wrap items-center gap-3 pt-1">
              <Button
                :as="RouterLinkComp"
                to="/learningpool"
                class="rounded-full bg-blue-500 text-white hover:bg-blue-400 px-6 py-2.5 text-sm font-semibold shadow-lg shadow-blue-500/30 transition-all hover:-translate-y-px"
              >
                Start exploring
                <span aria-hidden>→</span>
              </Button>
              <Button
                :as="RouterLinkComp"
                to="/about"
                class="rounded-full border border-white/30 bg-white/10 text-white hover:bg-white/20 backdrop-blur-sm px-6 py-2.5 text-sm font-semibold transition-all"
              >
                About
              </Button>
              <Button
                :as="RouterLinkComp"
                to="/createpath"
                class="rounded-full border border-white/30 bg-white/10 text-white hover:bg-white/20 backdrop-blur-sm px-6 py-2.5 text-sm font-semibold transition-all"
              >
                Create path
              </Button>
            </div>
          </template>

          <template v-else>
            <h1 class="text-3xl md:text-4xl font-semibold tracking-tight leading-[1.1] text-white">
              {{ bannerSlides[activeBannerIndex].title }}
            </h1>
            <p class="text-sm text-white/70 leading-relaxed max-w-md">
              {{ bannerSlides[activeBannerIndex].description }}
            </p>
            <div class="flex flex-wrap items-center gap-3 pt-1">
              <Button
                :as="RouterLinkComp"
                to="/learningpool"
                class="rounded-full bg-blue-500 text-white hover:bg-blue-400 px-6 py-2.5 text-sm font-semibold shadow-lg shadow-blue-500/30 transition-all hover:-translate-y-px"
              >
                Explore
                <span aria-hidden>→</span>
              </Button>
              <Button
                :as="RouterLinkComp"
                to="/createpath"
                class="rounded-full border border-white/30 bg-white/10 text-white hover:bg-white/20 backdrop-blur-sm px-6 py-2.5 text-sm font-semibold transition-all"
              >
                Create one
              </Button>
            </div>
          </template>
        </div>

        <!-- Dot indicators -->
        <div class="flex items-center gap-2 pt-8">
          <button
            v-for="(_, i) in bannerSlides"
            :key="i"
            type="button"
            class="transition-all duration-300 rounded-full"
            :class="i === activeBannerIndex ? 'w-6 h-1.5 bg-white' : 'w-1.5 h-1.5 bg-white/40'"
            :aria-label="`Go to slide ${i + 1}`"
            @click="activeBannerIndex = i"
          />
        </div>
      </div>
    </section>

    <!-- Featured Learning Paths: asymmetric editorial layout -->
    <section class="mb-16">
      <div class="flex items-end justify-between mb-8">
        <div>
          <span class="text-xs font-semibold uppercase tracking-[0.2em] text-blue-500 mb-2 block">Curated</span>
          <h2 class="text-2xl md:text-3xl font-semibold tracking-tight text-slate-900 leading-tight">Featured Paths</h2>
        </div>
        <Button
          :as="RouterLinkComp"
          to="/my-paths"
          variant="ghost"
          size="sm"
          class="rounded-none text-slate-500 hover:text-slate-800 text-xs font-semibold uppercase tracking-widest"
        >
          View all →
        </Button>
      </div>

      <!-- Loading skeleton -->
      <div v-if="featuredPaths.length === 0 && loading" class="grid grid-cols-12 gap-4">
        <div class="col-span-8 rounded-xl bg-slate-100 animate-pulse h-48"></div>
        <div class="col-span-4 space-y-4">
          <div class="rounded-xl bg-slate-100 animate-pulse h-20"></div>
          <div class="rounded-xl bg-slate-100 animate-pulse h-20"></div>
        </div>
      </div>

      <div v-else-if="featuredPaths.length > 0" class="grid grid-cols-12 gap-4">
        <!-- Hero card: spans 8 cols -->
        <RouterLink
          :to="{ name: 'learningpath', params: { id: featuredPaths[0].id } }"
          class="col-span-12 md:col-span-8 group block"
        >
          <div class="relative rounded-xl overflow-hidden bg-slate-100 aspect-[16/7]">
            <img
              :src="featuredPaths[0].thumbnail || fallbackThumb"
              :alt="featuredPaths[0].title"
              loading="lazy"
              decoding="async"
              class="block w-full h-full object-cover object-center transition-transform duration-500 group-hover:scale-105"
              style="width: 100%; height: 100%; object-fit: cover; object-position: center;"
            />
            <div class="absolute inset-0 bg-gradient-to-t from-slate-900/80 via-slate-900/20 to-transparent" />
            <div class="absolute bottom-0 left-0 p-6 md:p-8">
              <span class="inline-block text-[10px] font-bold uppercase tracking-widest text-blue-300 mb-2">{{ featuredPaths[0].level }}</span>
              <h3 class="text-white text-xl md:text-2xl font-semibold leading-tight mb-1">{{ featuredPaths[0].title }}</h3>
              <p class="text-white/60 text-sm line-clamp-1">{{ featuredPaths[0].description }}</p>
            </div>
          </div>
        </RouterLink>

        <!-- Side stack: 4 cols -->
        <div class="col-span-12 md:col-span-4 flex flex-col gap-4">
          <RouterLink
            v-for="path in featuredPaths.slice(1, 4)"
            :key="path.id"
            :to="{ name: 'learningpath', params: { id: path.id } }"
            class="group flex gap-3 items-center bg-white rounded-xl border border-slate-100 p-3 hover:border-slate-200 hover:shadow-sm transition-all"
          >
            <div class="w-16 h-16 rounded-lg overflow-hidden bg-slate-100 shrink-0">
              <img
                :src="path.thumbnail || fallbackThumb"
                :alt="path.title"
                loading="lazy"
                class="block w-full h-full object-cover object-center"
              />
            </div>
            <div class="min-w-0">
              <h3 class="text-sm font-semibold text-slate-800 line-clamp-1 group-hover:text-blue-600 transition-colors">{{ path.title }}</h3>
              <p class="text-xs text-slate-400 mt-0.5">{{ path.level }}</p>
            </div>
          </RouterLink>
        </div>
      </div>

      <div v-else class="rounded-xl border border-dashed border-slate-200 py-16 text-center">
        <p class="text-sm text-slate-400">No paths published yet.</p>
        <Button
          :as="RouterLinkComp"
          to="/createpath"
          class="mt-3 rounded-none text-xs font-semibold"
        >
          Be the first to create one →
        </Button>
      </div>
    </section>

    <!-- LearningPool Picks: masonry with editorial text -->
    <section class="mb-16">
      <div class="flex items-end justify-between mb-8">
        <div>
          <span class="text-xs font-semibold uppercase tracking-[0.2em] text-emerald-500 mb-2 block">Discover</span>
          <h2 class="text-2xl md:text-3xl font-semibold tracking-tight text-slate-900 leading-tight">LearningPool Picks</h2>
          <p class="text-sm text-slate-500 mt-1">A curated collection to explore freely.</p>
        </div>
        <Button
          :as="RouterLinkComp"
          to="/learningpool"
          variant="ghost"
          size="sm"
          class="rounded-none text-slate-500 hover:text-slate-800 text-xs font-semibold uppercase tracking-widest"
        >
          Open pool →
        </Button>
      </div>

      <!-- Masonry grid -->
      <div v-if="randomPoolPaths.length > 0" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4">
        <RouterLink
          v-for="(path, idx) in randomPoolPaths"
          :key="`${path.id}-${idx}`"
          :to="{ name: 'learningpath', params: { id: path.id } }"
          class="group block w-full min-w-0"
        >
          <div class="rounded-xl overflow-hidden border border-slate-100 bg-white hover:border-slate-200 hover:shadow-md transition-all duration-200">
            <div class="relative bg-slate-100 overflow-hidden" style="aspect-ratio: 16/9; width: 100%;">
              <img
                :src="path.thumbnail || fallbackThumb"
                :alt="path.title"
                loading="lazy"
                decoding="async"
                class="block w-full h-full object-cover object-center transition-transform duration-500 group-hover:scale-105"
                style="width: 100%; height: 100%; object-fit: cover; object-position: center;"
              />
              <!-- Type badge -->
              <div class="absolute top-2.5 left-2.5">
                <span class="inline-flex items-center rounded-full border border-white/20 bg-black/30 backdrop-blur-sm px-2 py-0.5 text-[10px] font-semibold uppercase tracking-wider text-white">
                  {{ path.typeLabel }}
                </span>
              </div>
            </div>
            <div class="p-4">
              <h3 class="text-sm font-semibold text-slate-800 line-clamp-2 leading-snug group-hover:text-blue-600 transition-colors" :title="path.title">
                {{ path.title }}
              </h3>
              <p class="text-xs text-slate-400 mt-1.5 line-clamp-2">{{ path.description }}</p>
              <div class="flex items-center gap-2 mt-3">
                <span class="text-[10px] font-semibold uppercase tracking-wider text-slate-400">{{ path.category }}</span>
                <span class="text-slate-200">·</span>
                <span class="text-[10px] text-slate-400">{{ path.level }}</span>
              </div>
            </div>
          </div>
        </RouterLink>
      </div>

      <div v-else-if="!loadingPool" class="rounded-xl border border-dashed border-slate-200 py-16 text-center">
        <p class="text-sm text-slate-400">Nothing in the pool yet.</p>
      </div>

      <div v-else class="grid grid-cols-4 gap-4">
        <div v-for="i in 8" :key="i" class="rounded-xl bg-slate-100 animate-pulse aspect-[4/5]"></div>
      </div>
    </section>

  </div>
</template>

<script setup lang="ts">
import { computed, ref, onBeforeUnmount, onMounted } from 'vue'
import { RouterLink } from 'vue-router'
import { Button } from '../components/ui/button'
import { listPublicLearningPaths, type PublicLearningPath } from '../api/learningPath'

const RouterLinkComp = RouterLink

const bannerSlides = [
  {
    image: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1600&h=900&q=80',
    title: 'Structured Learning Paths',
    description: 'A curriculum with modules and goals. Great for system-level skill building.',
  },
  {
    image: 'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?auto=format&fit=crop&w=1600&h=900&q=80',
    title: 'Linear Learning Paths',
    description: 'Step-by-step, guided learning. Follow a clear sequence and finish with a complete outcome.',
  },
  {
    image: 'https://images.unsplash.com/photo-1556761175-4b46a572b786?auto=format&fit=crop&w=1600&h=900&q=80',
    title: 'Partical Pool',
    description: 'A flexible pool of resources. Collect links, articles, and clips, then revisit anytime.',
  },
] as const

const activeBannerIndex = ref(0)
let bannerTimer: ReturnType<typeof setInterval> | null = null
let prefersReducedMotion = false

function nextBanner() {
  activeBannerIndex.value = (activeBannerIndex.value + 1) % bannerSlides.length
}

function startCarousel() {
  if (prefersReducedMotion) return
  if (bannerTimer) return
  bannerTimer = setInterval(nextBanner, 6000)
}

function stopCarousel() {
  if (!bannerTimer) return
  clearInterval(bannerTimer)
  bannerTimer = null
}

function pauseCarousel() { stopCarousel() }
function resumeCarousel() { startCarousel() }

const fallbackThumb = 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=900&h=506&fit=crop'

type FeaturedPath = {
  id: string
  title: string
  description: string
  thumbnail: string
  level: string
  duration: string
  typeLabel: string
  category: string
}

const featuredPaths = ref<FeaturedPath[]>([])
const randomPoolPaths = ref<FeaturedPath[]>([])
const loading = ref(false)
const loadingPool = ref(false)

function pickRandom<T>(items: T[], count: number): T[] {
  const arr = [...items]
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[arr[i], arr[j]] = [arr[j], arr[i]]
  }
  return arr.slice(0, Math.min(count, arr.length))
}

function mapDbToFeatured(p: PublicLearningPath): FeaturedPath {
  const lpType = String(p.type || '').trim().toLowerCase()
  let typeLabel = 'Path'
  if (lpType.includes('linear')) typeLabel = 'Linear'
  else if (lpType.includes('struct')) typeLabel = 'Structured'
  else if (lpType.includes('partical') || lpType.includes('pool')) typeLabel = 'Pool'

  return {
    id: String(p.id),
    title: p.title || `Path ${p.id}`,
    description: p.description || '',
    thumbnail: p.cover_image_url || fallbackThumb,
    level: 'Beginner',
    duration: '',
    typeLabel,
    category: p.category_name || 'General',
  }
}

onMounted(async () => {
  prefersReducedMotion = window.matchMedia?.('(prefers-reduced-motion: reduce)').matches ?? false
  startCarousel()

  loading.value = true
  try {
    const db = await listPublicLearningPaths()
    const mapped = (db || []).map(mapDbToFeatured)
    featuredPaths.value = mapped.slice(0, 4)
    randomPoolPaths.value = pickRandom(mapped, 12)
  } catch {
    featuredPaths.value = []
    randomPoolPaths.value = []
  } finally {
    loading.value = false
  }
})

onBeforeUnmount(() => {
  stopCarousel()
})
</script>
