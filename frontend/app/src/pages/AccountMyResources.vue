<template>
  <div class="space-y-4">
    <div class="rounded-2xl bg-white p-5 shadow-sm border border-slate-100">
      <h1 class="text-xl font-semibold text-slate-900">My Resources</h1>
      <p class="text-sm text-slate-600 mt-1">Resources you added</p>
    </div>

    <div v-if="loading" class="rounded-2xl bg-white p-6 shadow-sm text-slate-700">Loading…</div>

    <div v-else-if="filtered.length === 0" class="rounded-2xl bg-white p-6 shadow-sm">
      <p class="text-slate-700 font-semibold">No resources yet</p>
      <RouterLink to="/resources" class="inline-flex mt-4 px-4 py-2 rounded-lg bg-blue-600 text-white font-semibold hover:bg-blue-700">
        Add Resource
      </RouterLink>
    </div>

    <div v-else class="rounded-2xl bg-white p-4 shadow-sm border border-slate-100">
      <div class="flex flex-col sm:flex-row gap-3 items-start sm:items-center justify-between mb-4">
        <div class="relative flex-1 w-full">
          <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400" />
          <input
            v-model="q"
            type="text"
            placeholder="Search my resources..."
            class="w-full pl-10 pr-4 py-2 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>
      </div>

      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        <button
          v-for="r in filtered"
          :key="r.id"
          type="button"
          class="text-left rounded-xl border border-slate-100 bg-slate-50 hover:bg-slate-100 overflow-hidden"
          @click="open(r.id)"
        >
          <img :src="r.thumbnail" :alt="r.title" class="w-full h-36 object-cover" />
          <div class="p-4 space-y-2">
            <p class="font-semibold text-slate-900 line-clamp-1">{{ r.title }}</p>
            <p class="text-sm text-slate-600 line-clamp-2">{{ r.description || '—' }}</p>
            <div class="text-xs text-slate-500">{{ r.source }}</div>
          </div>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { Search } from 'lucide-vue-next'
import { listMyResources, type DbResource } from '../api/resource'

const router = useRouter()
const loading = ref(false)
const q = ref('')

type Ui = {
  id: number
  title: string
  description: string
  source: string
  thumbnail: string
}

const items = ref<Ui[]>([])
const fallbackThumb = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400&h=225&fit=crop'

function mapDb(r: DbResource): Ui {
  return {
    id: r.id,
    title: r.title,
    description: (r.description || '').trim(),
    source: (r.source || '').trim() || 'youtube',
    thumbnail: (r.thumbnail_url || '').trim() || fallbackThumb,
  }
}

const filtered = computed(() => {
  const query = q.value.trim().toLowerCase()
  if (!query) return items.value
  return items.value.filter(i => i.title.toLowerCase().includes(query) || i.description.toLowerCase().includes(query) || i.source.toLowerCase().includes(query))
})

async function load() {
  loading.value = true
  try {
    const data = await listMyResources()
    items.value = (data || []).map(mapDb)
  } finally {
    loading.value = false
  }
}

function open(id: number) {
  router.push({ name: 'resource-video', params: { id: String(id) } })
}

onMounted(() => {
  load()
})
</script>
