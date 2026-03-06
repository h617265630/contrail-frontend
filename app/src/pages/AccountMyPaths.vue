<template>
  <div class="space-y-6">
    <div>
      <h3 class="text-lg font-semibold text-foreground">My Paths</h3>
      <p class="mt-2 text-sm text-muted-foreground">Learning paths you created</p>
    </div>

    <div v-if="loading" class="rounded-md border border-border bg-muted/30 p-6 text-sm text-muted-foreground">Loading…</div>

    <div v-else-if="filtered.length === 0" class="rounded-md border border-border bg-muted/30 p-6">
      <p class="text-sm font-semibold text-foreground">No paths yet</p>
      <div class="mt-4 flex flex-wrap gap-2">
        <Button :as="RouterLinkComp" to="/createpath" size="sm" class="rounded-md">
          Create Path
        </Button>
        <Button :as="RouterLinkComp" to="/learningpool" variant="outline" size="sm" class="rounded-md">
          Browse LearningPool
        </Button>
      </div>
    </div>

    <div v-else class="space-y-4">
      <div class="flex flex-col sm:flex-row gap-3 items-start sm:items-center justify-between">
        <div class="relative flex-1 w-full">
          <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
          <Input v-model="q" type="text" placeholder="Search my paths..." class="h-10 w-full rounded-md pl-9" />
        </div>
        <Button :as="RouterLinkComp" to="/createpath" size="sm" class="rounded-md">Create Path</Button>
      </div>

      <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        <Card
          v-for="p in filtered"
          :key="p.id"
          as="article"
          :hoverable="true"
          className="rounded-md cursor-pointer"
          @click="open(p.id)"
        >
          <div class="relative h-36 bg-muted">
            <img :src="p.thumbnail" :alt="p.title" class="h-full w-full object-cover" />
            <div class="absolute bottom-3 left-3 flex flex-wrap gap-2">
              <span class="px-2 py-1 border border-border bg-background/90 text-foreground text-xs">
                {{ p.category || '—' }}
              </span>
              <span v-if="p.type" class="px-2 py-1 border border-border bg-background/90 text-foreground text-xs">
                {{ p.type }}
              </span>
            </div>
          </div>
          <div class="p-4 space-y-2">
            <p class="text-sm font-semibold text-foreground line-clamp-1">{{ p.title }}</p>
            <p class="text-sm text-muted-foreground line-clamp-2">{{ p.description || '—' }}</p>
          </div>
        </Card>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { Search } from 'lucide-vue-next'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import { listMyLearningPaths, type MyLearningPath } from '../api/learningPath'

const RouterLinkComp = RouterLink

const router = useRouter()
const loading = ref(false)
const q = ref('')

type Ui = {
  id: number
  title: string
  description: string
  type: string
  category: string
  thumbnail: string
}

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
  return items.value.filter(i => i.title.toLowerCase().includes(query) || i.description.toLowerCase().includes(query) || i.category.toLowerCase().includes(query) || i.type.toLowerCase().includes(query))
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

onMounted(() => {
  load()
})
</script>
