<template>
  <div class="min-h-screen bg-background">
    <div class="container mx-auto px-4 py-6 -mt-4 md:-mt-6">
      <main class="flex flex-col gap-4">

    <Card as="section" :hoverable="false" class="mx-auto w-full max-w-6xl rounded-none">
      <div class="p-3">
        <div class="flex flex-col lg:flex-row gap-4 items-start lg:items-center justify-between">
          <div class="flex flex-col sm:flex-row gap-3 flex-1 w-full lg:w-auto">
            <div class="flex gap-3 flex-1">
              <div class="relative flex-1">
              <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
              <Input
                ref="searchInputEl"
                type="text"
                placeholder="Search trending resources..."
                v-model="searchQuery"
                class="h-9 w-full rounded-none pl-10"
              />
            </div>
            </div>

            <div class="relative">
              <select
                v-model="selectedSource"
                class="h-9 appearance-none rounded-none border border-input bg-background pl-10 pr-10 text-sm text-foreground outline-none transition focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background cursor-pointer"
              >
                <option value="all">All Sources</option>
                <option value="github">GitHub</option>
                <option value="youtube">YouTube</option>
              </select>
              <Filter class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground pointer-events-none" />
              <ChevronDown class="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground pointer-events-none" />
            </div>
          </div>

          <div class="flex gap-3 w-full lg:w-auto">
            <Button
              type="button"
              variant="outline"
              size="sm"
              class="rounded-none"
              @click="loadTrendingData"
              :disabled="loading"
            >
              {{ loading ? 'Loading...' : 'Refresh' }}
            </Button>
          </div>
        </div>
      </div>
    </Card>

    <div v-if="loading" class="mx-auto w-full max-w-6xl text-center py-16">
      <p class="text-sm text-muted-foreground">Loading trending resources…</p>
    </div>

    <Card v-else-if="error" as="section" :hoverable="false" class="mx-auto w-full max-w-6xl rounded-none">
      <div class="py-16 text-center">
        <h3 class="text-foreground mb-2">Error Loading Trending Data</h3>
        <p class="text-destructive mb-6">{{ error }}</p>
        <Button @click="loadTrendingData">Try Again</Button>
      </div>
    </Card>

    <Card v-else-if="filteredResources.length === 0" as="section" :hoverable="false" class="mx-auto w-full max-w-6xl rounded-none">
      <div class="py-16 text-center">
        <BookOpen class="w-16 h-16 text-muted-foreground/30 mx-auto mb-4" />
        <h3 class="text-foreground mb-2">No trending resources found</h3>
        <p class="text-muted-foreground mb-6">
          {{ searchQuery || selectedSource !== 'all' ? 'Try adjusting your filters' : 'Click Refresh to load trending data' }}
        </p>
      </div>
    </Card>

      <div v-else class="mt-4 mx-auto w-full max-w-6xl">
        <div class="grid grid-cols-1 gap-4 justify-items-center sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5">
          <Card
            v-for="resource in filteredResources"
            :key="resource.id"
            class="shrink-0 w-56 min-h-72 rounded-md border border-border bg-card shadow-sm transition-all duration-300 ease-out cursor-pointer hover:shadow-xl hover:!z-[100] card-hover"
            :hoverable="false"
            @click="openCard(resource)"
          >
            <div class="h-full flex flex-col overflow-hidden rounded-md">
              <div class="px-3 py-2 border-b border-border flex items-center justify-between">
                <span
                  class="px-2 py-0.5 text-xs font-medium rounded"
                  :style="{
                    backgroundColor: getPlatformColor(resource.platform) + '20',
                    color: getPlatformColor(resource.platform),
                  }"
                >
                  {{ resource.platform }}
                </span>
                <span class="text-xs text-muted-foreground">{{ formatStats(resource) }}</span>
              </div>

              <div class="relative h-28 bg-white overflow-hidden px-2">
                <img :src="resource.thumbnail || fallbackThumb" :alt="resource.title" class="w-full h-full object-cover" />
              </div>

              <div class="px-3 py-2 border-b border-border bg-white">
                <h3 class="text-sm font-bold text-foreground line-clamp-1" :title="resource.title">{{ resource.title }}</h3>
              </div>

              <div class="px-3 py-2 flex-1 bg-muted/30">
                <p class="text-xs text-muted-foreground line-clamp-2">{{ resource.summary || '' }}</p>
              </div>

              <div class="px-3 py-2 border-t border-border flex items-center justify-between">
                <span class="text-xs text-muted-foreground">{{ resource.category_name }}</span>
                <span class="text-xs font-medium text-foreground">{{ resource.resource_type }}</span>
              </div>
            </div>
          </Card>
        </div>
      </div>
      </main>
    </div>

    <Teleport to="body">
      <Transition name="modal">
        <div
          v-if="activeResource"
          class="fixed inset-0 z-50 flex items-center justify-center p-4"
          @click.self="closeActiveResource"
        >
          <div class="absolute inset-0 bg-black/50"></div>
          <div class="relative w-full max-w-md rounded-md overflow-hidden bg-card border border-border shadow-xl">
            <div class="relative h-48 bg-muted overflow-hidden">
              <img
                :src="activeResource.thumbnail || fallbackThumb"
                :alt="activeResource.title"
                class="w-full h-full object-cover"
              />
              <button
                class="absolute top-3 right-3 w-8 h-8 rounded-full bg-red-500 flex items-center justify-center text-white hover:bg-red-600 transition"
                @click="closeActiveResource"
              >
                ✕
              </button>
            </div>

            <div class="p-4 border-b border-border">
              <div class="flex items-center gap-2 mb-2">
                <span
                  class="px-2 py-0.5 text-xs font-medium rounded"
                  :style="{
                    backgroundColor: getPlatformColor(activeResource.platform) + '20',
                    color: getPlatformColor(activeResource.platform),
                  }"
                >
                  {{ activeResource.platform }}
                </span>
                <span class="text-xs text-muted-foreground">{{ formatStats(activeResource) }}</span>
              </div>
              <h2 class="text-xl font-bold text-foreground">{{ activeResource.title }}</h2>
            </div>

            <div class="p-4">
              <p class="text-sm text-muted-foreground mb-4">{{ activeResource.summary || '' }}</p>
              <div class="flex items-center gap-4 text-sm text-muted-foreground">
                <span>{{ activeResource.platform }}</span>
                <span>•</span>
                <span>{{ activeResource.resource_type }}</span>
              </div>
              <div v-if="activeResource.stats" class="mt-4 space-y-2">
                <div v-if="activeResource.stats.stars" class="flex items-center gap-2 text-sm">
                  <span class="text-muted-foreground">⭐ Stars:</span>
                  <span class="font-medium">{{ formatNumber(activeResource.stats.stars) }}</span>
                </div>
                <div v-if="activeResource.stats.views" class="flex items-center gap-2 text-sm">
                  <span class="text-muted-foreground">👁 Views:</span>
                  <span class="font-medium">{{ formatNumber(activeResource.stats.views) }}</span>
                </div>
                <div v-if="activeResource.stats.likes" class="flex items-center gap-2 text-sm">
                  <span class="text-muted-foreground">👍 Likes:</span>
                  <span class="font-medium">{{ formatNumber(activeResource.stats.likes) }}</span>
                </div>
                <div v-if="activeResource.stats.language" class="flex items-center gap-2 text-sm">
                  <span class="text-muted-foreground">💻 Language:</span>
                  <span class="font-medium">{{ activeResource.stats.language }}</span>
                </div>
                <div v-if="activeResource.stats.channel" class="flex items-center gap-2 text-sm">
                  <span class="text-muted-foreground">📺 Channel:</span>
                  <span class="font-medium">{{ activeResource.stats.channel }}</span>
                </div>
              </div>
            </div>

            <div class="p-4 border-t border-border flex flex-col gap-3">
              <Button
                type="button"
                class="w-full rounded-none bg-foreground text-background font-medium hover:bg-foreground/90"
                @click="openSource(activeResource)"
              >
                Open Source
              </Button>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { BookOpen, ChevronDown, Filter, Search } from 'lucide-vue-next'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import Card from '../components/ui/Card.vue'
import { getCombinedTrending, type TrendingItem } from '../api/trending'

const fallbackThumb = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400&h=225&fit=crop'

const resources = ref<TrendingItem[]>([])
const loading = ref(false)
const error = ref('')
const selectedSource = ref<string>('all')
const searchQuery = ref('')

const searchInputEl = ref<HTMLInputElement | null>(null)

const activeResourceId = ref<string | number | null>(null)
const activeResource = computed(() => {
  if (activeResourceId.value === null) return null
  return resources.value.find(r => r.id === activeResourceId.value) || null
})

const filteredResources = computed(() => {
  return resources.value.filter(r => {
    const matchesSource = selectedSource.value === 'all' || r.platform.toLowerCase() === selectedSource.value.toLowerCase()
    const q = searchQuery.value.trim().toLowerCase()
    if (!q) return matchesSource

    const title = (r.title || '').toLowerCase()
    const desc = (r.summary || '').toLowerCase()
    return matchesSource && (title.includes(q) || desc.includes(q))
  })
})

function getPlatformColor(platform?: string) {
  const p = String(platform || '').toLowerCase()
  if (p === 'github') return '#333333'
  if (p === 'youtube') return '#FF0000'
  return '#3b82f6'
}

function formatStats(resource: TrendingItem) {
  if (resource.stats?.stars) {
    return `⭐ ${formatNumber(resource.stats.stars)}`
  }
  if (resource.stats?.views) {
    return `👁 ${formatNumber(resource.stats.views)}`
  }
  return ''
}

function formatNumber(num: number) {
  if (num >= 1000000) return `${(num / 1000000).toFixed(1)}M`
  if (num >= 1000) return `${(num / 1000).toFixed(1)}K`
  return String(num)
}

async function loadTrendingData() {
  loading.value = true
  error.value = ''
  try {
    // Note: YouTube API key should be configured in environment or settings
    // For now, we'll fetch without YouTube data (only GitHub)
    const data = await getCombinedTrending({
      github_per_page: 30,
      github_language: undefined,
      // youtube_api_key: 'YOUR_API_KEY_HERE', // User needs to configure this
    })
    
    resources.value = data.items || []
    
    // Show warning if YouTube failed
    if (data.sources?.youtube?.error && !data.sources.youtube.error.includes('No YouTube API key')) {
      console.warn('YouTube API error:', data.sources.youtube.error)
    }
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || 'Failed to load trending resources')
    resources.value = []
  } finally {
    loading.value = false
  }
}

function openCard(resource: TrendingItem) {
  activeResourceId.value = resource.id
}

function closeActiveResource() {
  activeResourceId.value = null
}

function openSource(resource: TrendingItem) {
  const url = String(resource.source_url || '').trim()
  if (!url) return
  window.open(url, '_blank', 'noopener,noreferrer')
  closeActiveResource()
}

onMounted(() => {
  loadTrendingData()
})
</script>

<style scoped>
.card-hover:hover {
  animation: card-tilt-up 0.4s ease forwards;
}

@keyframes card-tilt-up {
  0% {
    transform: rotate(0deg) scale(1);
  }
  30% {
    transform: rotate(-6deg) scale(1.08);
  }
  100% {
    transform: rotate(0deg) scale(1.25);
  }
}

.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}
</style>
