<template>
  <div class="space-y-6">
    <div>
      <h3 class="text-lg font-semibold text-foreground">My Resources</h3>
      <p class="mt-2 text-sm text-muted-foreground">Resources you added</p>
    </div>

    <div v-if="loading" class="rounded-md border border-border bg-muted/30 p-6 text-sm text-muted-foreground">Loading…</div>

    <div v-else-if="filtered.length === 0" class="rounded-md border border-border bg-muted/30 p-6">
      <p class="text-sm font-semibold text-foreground">No resources yet</p>
      <Button :as="RouterLinkComp" to="/resources" size="sm" class="mt-4 rounded-md">
        Add Resource
      </Button>
    </div>

    <div v-else class="space-y-4">
      <div class="flex flex-col sm:flex-row gap-3 items-start sm:items-center justify-between">
        <div class="relative flex-1 w-full">
          <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
          <Input v-model="q" type="text" placeholder="Search my resources..." class="h-10 w-full rounded-md pl-9" />
        </div>
      </div>

      <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        <Card
          v-for="r in filtered"
          :key="r.id"
          as="article"
          :hoverable="true"
          className="rounded-md cursor-pointer"
          @click="open(r.id)"
        >
          <div class="relative h-36 bg-muted">
            <img :src="r.thumbnail" :alt="r.title" class="h-full w-full object-cover" />
            <div class="absolute bottom-3 left-3">
              <span class="px-2 py-1 border border-border bg-background/90 text-foreground text-xs">
                {{ r.source }}
              </span>
            </div>
          </div>
          <div class="p-4 space-y-2">
            <p class="text-sm font-semibold text-foreground line-clamp-1">{{ r.title }}</p>
            <p class="text-sm text-muted-foreground line-clamp-2">{{ r.description || '—' }}</p>
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
import { listMyResources, type DbResource } from '../api/resource'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'

const router = useRouter()
const RouterLinkComp = RouterLink
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
  const anyR = r as any
  return {
    id: r.id,
    title: r.title,
    description: String(anyR.summary || anyR.description || '').trim(),
    source: String(anyR.platform || anyR.source || '').trim() || '—',
    thumbnail: String(anyR.thumbnail || anyR.thumbnail_url || '').trim() || fallbackThumb,
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
