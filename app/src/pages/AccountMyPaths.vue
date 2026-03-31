<template>
  <div>
    <!-- Loading -->
    <div v-if="loading" class="py-20 text-center">
      <div class="inline-flex items-center gap-2 text-sm text-stone-400">
        <div class="w-4 h-4 rounded-full border-2 border-stone-300 border-t-amber-500 animate-spin" />
        Loading…
      </div>
    </div>

    <!-- Empty state -->
    <div v-else-if="filtered.length === 0" class="py-16 text-center bg-white rounded-xl border border-stone-100">
      <div class="text-4xl mb-3">🛤️</div>
      <h3 class="text-sm font-bold text-stone-700 mb-1">No paths yet</h3>
      <p class="text-xs text-stone-400 mb-5">Build your first structured learning path.</p>
      <div class="flex items-center justify-center gap-2">
        <button
          class="inline-flex items-center gap-2 px-5 py-2.5 bg-stone-900 text-white text-xs font-bold hover:bg-stone-800 transition-all rounded-lg"
          @click="router.push('/createpath')"
        >
          Create Path
        </button>
        <button
          class="inline-flex items-center gap-2 px-5 py-2.5 border border-stone-200 text-stone-600 text-xs font-semibold hover:border-stone-300 hover:bg-stone-50 transition-all rounded-lg"
          @click="router.push('/learningpool')"
        >
          Browse Pool
        </button>
      </div>
    </div>

    <!-- Content -->
    <div v-else class="space-y-5">
      <!-- Search + create -->
      <div class="flex flex-col sm:flex-row gap-3 items-start sm:items-center justify-between">
        <div class="relative flex-1 w-full">
          <Search class="absolute left-3.5 top-1/2 -translate-y-1/2 text-stone-400 w-4 h-4" />
          <input
            v-model="q"
            type="text"
            placeholder="Search my paths…"
            class="w-full pl-10 pr-4 py-3 bg-white border border-stone-200 text-stone-900 text-sm placeholder:text-stone-400 outline-none focus:border-amber-400 focus:ring-2 focus:ring-amber-100 transition-all rounded-xl"
          />
        </div>
        <button
          class="inline-flex items-center gap-2 px-5 py-2.5 bg-amber-500 text-white text-xs font-bold hover:bg-amber-600 transition-all hover:-translate-y-px active:translate-y-0 rounded-lg shrink-0"
          @click="router.push('/createpath')"
        >
          + New Path
        </button>
      </div>

      <!-- Grid -->
      <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        <article
          v-for="p in filtered"
          :key="p.id"
          class="group bg-white rounded-xl border border-stone-100 hover:border-stone-200 hover:shadow-md transition-all duration-200 cursor-pointer overflow-hidden"
          @click="open(p.id)"
        >
          <div class="relative aspect-video bg-stone-100 overflow-hidden">
            <img
              :src="p.thumbnail || fallbackThumb"
              :alt="p.title"
              class="w-full h-full object-cover object-center transition-transform duration-500 group-hover:scale-105"
              loading="lazy"
            />
            <div class="absolute bottom-2.5 left-2.5 flex flex-wrap gap-1.5">
              <span class="inline-flex items-center rounded-full border border-white/20 bg-black/30 backdrop-blur-sm px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider text-white">
                {{ p.category || '—' }}
              </span>
              <span v-if="p.type" class="inline-flex items-center rounded-full border border-white/20 bg-black/30 backdrop-blur-sm px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider text-white">
                {{ p.type }}
              </span>
            </div>
          </div>
          <div class="p-4 space-y-1.5">
            <h3 class="text-sm font-semibold text-stone-800 line-clamp-1 group-hover:text-amber-600 transition-colors">{{ p.title }}</h3>
            <p class="text-xs text-stone-400 line-clamp-2">{{ p.description || '—' }}</p>
          </div>
        </article>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { Search } from 'lucide-vue-next'
import { listMyLearningPaths, type MyLearningPath } from '../api/learningPath'

const router = useRouter()
const loading = ref(false)
const q = ref('')

type Ui = { id: number; title: string; description: string; type: string; category: string; thumbnail: string }
const items = ref<Ui[]>([])
const fallbackThumb = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400&h=225&fit=crop'

function mapDb(p: MyLearningPath): Ui {
  const anyP = p as any
  return {
    id: Number(p.id),
    title: String(p.title || '').trim(),
    description: String(p.description || '').trim(),
    type: String(anyP.type || '').trim(),
    category: String(anyP.category_name || '').trim(),
    thumbnail: String(anyP.cover_image_url || '').trim() || fallbackThumb,
  }
}

const filtered = computed(() => {
  const query = q.value.trim().toLowerCase()
  if (!query) return items.value
  return items.value.filter(i =>
    i.title.toLowerCase().includes(query) ||
    i.description.toLowerCase().includes(query) ||
    i.category.toLowerCase().includes(query) ||
    i.type.toLowerCase().includes(query)
  )
})

async function load() {
  loading.value = true
  try {
    const data = await listMyLearningPaths()
    items.value = (data || []).map(mapDb)
  } finally {
    loading.value = false
  }
}

function open(id: number) {
  router.push({ name: 'learningpath', params: { id: String(id) }, query: { from: 'my-paths' } })
}

onMounted(() => { load() })
</script>
