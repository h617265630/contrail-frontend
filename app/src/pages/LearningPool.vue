<template>
  <div class="mx-auto max-w-7xl px-4 py-8 -mt-4 md:-mt-6">

    <!-- Page header -->
    <section class="mb-12">
      <div class="grid grid-cols-12 gap-6 items-end">
        <div class="col-span-12 md:col-span-7">
          <span class="text-xs font-semibold uppercase tracking-[0.2em] text-blue-500 mb-3 block">LearningPool</span>
          <h1 class="text-3xl md:text-4xl font-semibold tracking-tight text-slate-900 leading-[1.1]">
            Discover learning paths
          </h1>
          <p class="mt-3 text-sm text-slate-500 leading-relaxed max-w-lg">
            Browse curated paths across topics. Follow a structured path, or explore a flexible pool of resources at your own pace.
          </p>
        </div>
        <div class="col-span-12 md:col-span-5 flex items-center gap-3">
          <!-- Search bar -->
          <div class="relative flex-1">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            <input
              v-model="searchInput"
              type="search"
              placeholder="Search paths..."
              class="w-full rounded-full border border-slate-200 bg-white pl-9 pr-4 py-2 text-sm text-slate-700 placeholder:text-slate-400 outline-none focus:border-blue-300 focus:ring-2 focus:ring-blue-100 transition-all"
            />
          </div>
          <Button
            :as="RouterLinkComp"
            to="/createpath"
            class="rounded-full bg-slate-900 text-white hover:bg-slate-800 px-5 py-2 text-xs font-semibold"
          >
            + New path
          </Button>
        </div>
      </div>
    </section>

    <!-- Category pills -->
    <section class="mb-10">
      <div class="flex items-center gap-2 flex-wrap">
        <button
          type="button"
          class="rounded-full border px-3 py-1.5 text-xs font-semibold transition-all duration-150"
          :class="activeCategory === '' ? 'bg-slate-900 text-white border-slate-900' : 'border-slate-200 text-slate-500 bg-white hover:border-slate-300 hover:text-slate-700'"
          @click="activeCategory = ''"
        >
          All
        </button>
        <button
          v-for="cat in categories"
          :key="cat"
          type="button"
          class="rounded-full border px-3 py-1.5 text-xs font-semibold transition-all duration-150"
          :class="activeCategory === cat ? 'bg-slate-900 text-white border-slate-900' : 'border-slate-200 text-slate-500 bg-white hover:border-slate-300 hover:text-slate-700'"
          @click="activeCategory = cat"
        >
          {{ cat }}
        </button>
      </div>
    </section>

    <!-- Trending / Hot picks: horizontal scrollable strip -->
    <section v-if="searchQuery === '' && hotPaths.length > 0" class="mb-14">
      <div class="flex items-center justify-between mb-5">
        <div class="flex items-center gap-2">
          <span class="text-xs font-bold uppercase tracking-[0.15em] text-amber-500">🔥</span>
          <h2 class="text-sm font-semibold uppercase tracking-widest text-slate-800">Trending now</h2>
        </div>
        <span class="text-xs text-slate-400">{{ hotPaths.length }} paths</span>
      </div>
      <div class="flex gap-4 overflow-x-auto pb-3 -mx-4 px-4 scrollbar-hide">
        <RouterLink
          v-for="p in hotPaths"
          :key="p.id"
          :to="{ name: 'learningpath', params: { id: p.id } }"
          class="group shrink-0 w-56 block"
        >
          <div class="card-image rounded-none bg-slate-100 w-56 mb-3">
            <img
              :src="p.thumbnail || fallbackThumb"
              :alt="p.title"
              loading="lazy"
              class="block w-full h-full"
            />
          </div>
          <div class="space-y-1">
            <h3 class="text-sm font-semibold text-slate-800 line-clamp-2 leading-snug group-hover:text-blue-600 transition-colors">{{ p.title }}</h3>
            <p class="text-xs text-slate-400">{{ p.category }}</p>
          </div>
        </RouterLink>
      </div>
    </section>

    <!-- Type tabs -->
    <section v-if="searchQuery === ''" class="mb-8">
      <div class="border-b border-slate-100 flex items-center gap-0">
        <button
          v-for="tab in typeTabs"
          :key="tab.key"
          type="button"
          class="px-5 py-2.5 text-xs font-semibold uppercase tracking-wider border-b-2 transition-all duration-150 -mb-px"
          :class="activeType === tab.key
            ? 'border-blue-500 text-blue-600'
            : 'border-transparent text-slate-400 hover:text-slate-600 hover:border-slate-200'"
          @click="activeType = tab.key"
        >
          {{ tab.label }}
          <span class="ml-1.5 text-[10px] font-medium text-slate-300">{{ tab.count }}</span>
        </button>
      </div>
    </section>

    <!-- Filtered results count -->
    <section v-if="searchQuery !== ''" class="mb-6">
      <p class="text-sm text-slate-500">
        <span class="font-semibold text-slate-700">{{ filteredByType.length }}</span> results
        <span v-if="searchQuery"> for "<span class="font-semibold text-slate-700">{{ searchQuery }}</span>"</span>
        <span v-if="activeType !== 'all'"> in <span class="font-semibold text-slate-700">{{ activeType }}</span></span>
      </p>
    </section>

    <!-- Path grid: masonry for pool / regular for others -->
    <section v-if="filteredByType.length > 0">
      <!-- Regular grid for "All" type -->
      <div v-if="activeType === 'all'" class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
        <RouterLink
          v-for="(p, idx) in filteredByType"
          :key="`${p.id}-${idx}`"
          :to="{ name: 'learningpath', params: { id: p.id } }"
          class="group block"
        >
          <div class="rounded-md overflow-hidden border border-slate-100 bg-white hover:border-slate-200 hover:shadow-md transition-all duration-200">
            <div class="card-image bg-slate-100">
              <img
                :src="p.thumbnail || fallbackThumb"
                :alt="p.title"
                loading="lazy"
                decoding="async"
                class="block w-full h-full"
              />
            </div>
            <div class="p-4">
              <div class="flex items-center justify-between gap-2 mb-1">
                <span class="inline-flex items-center rounded-full border border-slate-200 bg-white px-2 py-0.5 text-[10px] font-semibold uppercase tracking-wider text-slate-600">
                  {{ p.typeLabel }}
                </span>
              </div>
              <h3 class="text-sm font-semibold text-slate-800 line-clamp-2 leading-snug group-hover:text-blue-600 transition-colors">{{ p.title }}</h3>
              <p class="text-xs text-slate-400 mt-1 line-clamp-2">{{ p.description }}</p>
              <div class="flex items-center gap-2 mt-3">
                <span class="text-[10px] font-semibold uppercase tracking-wider text-slate-400">{{ p.category }}</span>
                <span class="text-slate-200">·</span>
                <span class="text-[10px] text-slate-400">{{ p.level }}</span>
              </div>
            </div>
          </div>
        </RouterLink>
      </div>

      <!-- Regular grid for typed views -->
      <div v-else class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-5 gap-4">
        <RouterLink
          v-for="p in filteredByType"
          :key="p.id"
          :to="{ name: 'learningpath', params: { id: p.id } }"
          class="group block"
        >
          <div class="rounded-md overflow-hidden border border-slate-100 bg-white hover:border-slate-200 hover:shadow-lg transition-all duration-200">
            <div class="card-image bg-slate-100">
              <img
                :src="p.thumbnail || fallbackThumb"
                :alt="p.title"
                loading="lazy"
                decoding="async"
                class="block w-full h-full"
              />
            </div>
            <div class="p-5">
              <div class="flex items-center justify-between gap-2 mb-1">
                <span class="inline-flex items-center rounded-full border border-slate-200 bg-white px-2 py-0.5 text-[10px] font-semibold uppercase tracking-wider text-slate-600">
                  {{ p.typeLabel }}
                </span>
              </div>
              <h3 class="text-sm font-semibold text-slate-800 line-clamp-2 leading-snug group-hover:text-blue-600 transition-colors mb-1">{{ p.title }}</h3>
              <p class="text-xs text-slate-400 line-clamp-2">{{ p.description }}</p>
              <div class="flex items-center gap-2 mt-3">
                <span class="text-[10px] font-semibold uppercase tracking-wider text-slate-400">{{ p.category }}</span>
                <span class="text-slate-200">·</span>
                <span class="text-[10px] text-slate-400">{{ p.level }}</span>
              </div>
            </div>
          </div>
        </RouterLink>
      </div>
    </section>

    <!-- Empty state -->
    <section v-else class="py-20 text-center">
      <div class="text-4xl mb-3">🔍</div>
      <h3 class="text-base font-semibold text-slate-700 mb-1">No paths found</h3>
      <p class="text-sm text-slate-400">
        <span v-if="searchQuery">Try a different search term.</span>
        <span v-else>Be the first to create one in this category.</span>
      </p>
      <Button
        :as="RouterLinkComp"
        to="/createpath"
        class="mt-4 rounded-none text-xs font-semibold"
      >
        Create a path →
      </Button>
    </section>

  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { listPublicLearningPaths } from '../api/learningPath'
import { listCategories, type Category } from '../api/category'
import { RouterLink } from 'vue-router'
import { Button } from '../components/ui/button'

const RouterLinkComp = RouterLink
const route = useRoute()

const searchInput = ref(String(route.query.search || '').trim())
const searchQuery = computed(() => searchInput.value.toLowerCase())
const activeCategory = ref('')
const activeType = ref('all')

const categories = ref<string[]>([])
const fallbackThumb = 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=900&h=506&fit=crop'

type PoolPath = {
  id: string
  title: string
  description: string
  category: string
  typeLabel: string
  level: string
  items: number
  thumbnail: string
  hotScore: number
}

const allPaths = ref<PoolPath[]>([])

function mapDbToPool(p: any): PoolPath {
  const lpType = String(p.type || '').trim().toLowerCase()
  let typeLabel = 'Path'
  if (lpType.includes('linear')) typeLabel = 'Linear'
  else if (lpType.includes('struct')) typeLabel = 'Structured'
  else if (lpType.includes('partical') || lpType.includes('pool')) typeLabel = 'Pool'

  const thumbnail = p.cover_image_url || fallbackThumb
  return {
    id: String(p.id),
    title: p.title || `Path ${p.id}`,
    description: p.description || '',
    category: p.category_name || 'Other',
    typeLabel,
    level: 'Beginner',
    items: 0,
    thumbnail,
    hotScore: 50,
  }
}

const typeTabs = computed(() => [
  { key: 'all', label: 'All', count: allPaths.value.length },
  { key: 'linear path', label: 'Linear', count: allPaths.value.filter(p => p.typeLabel === 'Linear').length },
  { key: 'structured path', label: 'Structured', count: allPaths.value.filter(p => p.typeLabel === 'Structured').length },
  { key: 'partical pool', label: 'Pool', count: allPaths.value.filter(p => p.typeLabel === 'Pool').length },
])

const hotPaths = computed(() => [...allPaths.value].sort(() => Math.random() - 0.5).slice(0, 8))

const filteredByType = computed(() => {
  let result = allPaths.value

  if (activeType.value !== 'all') {
    result = result.filter(p => p.typeLabel.toLowerCase() === activeType.value.toLowerCase())
  }

  if (searchQuery.value) {
    const q = searchQuery.value
    result = result.filter(p =>
      p.title.toLowerCase().includes(q) ||
      p.description.toLowerCase().includes(q) ||
      p.category.toLowerCase().includes(q)
    )
  }

  if (activeCategory.value) {
    result = result.filter(p => p.category === activeCategory.value)
  }

  return result
})

onMounted(async () => {
  try {
    const [db, cats] = await Promise.all([
      listPublicLearningPaths(),
      listCategories(),
    ])
    categories.value = (cats || []).map((c: Category) => c.name)
    allPaths.value = (db || []).map(mapDbToPool)
  } catch {
    allPaths.value = []
  }
})
</script>

<style scoped>
.card-image {
  width: 100%;
  aspect-ratio: 16 / 9;
  overflow: hidden;
  border-radius: 12px;
  position: relative;
}

.card-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
</style>
