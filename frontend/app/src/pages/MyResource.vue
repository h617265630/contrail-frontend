<template>
  <div class="min-h-screen bg-linear-to-br from-blue-50 to-indigo-100 p-6">
    <div class="max-w-7xl mx-auto">
      <div class="mb-8 flex items-start justify-between gap-4">
        <div>
          <h1 class="text-gray-900 mb-2">My Resources</h1>
          <p class="text-gray-600">Resources you added</p>
        </div>
        <RouterLink
          to="/resources"
          class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors inline-flex items-center gap-2"
        >
          <Plus class="w-4 h-4" />
          Add Resource
        </RouterLink>
      </div>

      <div class="bg-white rounded-xl shadow-lg p-4 mb-6">
        <div class="flex flex-col sm:flex-row gap-3 items-start sm:items-center justify-between">
          <div class="relative flex-1 w-full">
            <Search class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search my resources..."
              v-model="searchQuery"
              class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <div class="flex gap-1 bg-gray-100 rounded-lg p-1">
            <button @click="setView('grid')" :class="['p-2 rounded', viewMode === 'grid' ? 'bg-white shadow-sm' : 'text-gray-500']">
              <Grid3x3 class="w-5 h-5" />
            </button>
            <button @click="setView('list')" :class="['p-2 rounded', viewMode === 'list' ? 'bg-white shadow-sm' : 'text-gray-500']">
              <List class="w-5 h-5" />
            </button>
          </div>
        </div>
      </div>

      <div v-if="filteredResources.length === 0" class="text-center py-16 bg-white rounded-xl shadow-lg">
        <BookOpen class="w-16 h-16 text-gray-300 mx-auto mb-4" />
        <h3 class="text-gray-900 mb-2">No resources yet</h3>
        <p class="text-gray-600 mb-6">
          {{ searchQuery ? 'Try a different keyword' : 'Go add your first resource in Resource Library' }}
        </p>
        <RouterLink
          v-if="!searchQuery"
          to="/resources"
          class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors inline-flex items-center gap-2"
        >
          <Plus class="w-4 h-4" />
          Add Resource
        </RouterLink>
      </div>

      <div v-else>
        <div v-if="viewMode === 'grid'" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-6">
          <div
            v-for="resource in filteredResources"
            :key="resource.id"
            class="bg-white rounded-xl shadow-lg overflow-hidden transition-all cursor-pointer hover:shadow-xl h-90 flex flex-col"
            @click="viewResource(resource)"
          >
            <div class="relative h-32">
              <img :src="resource.thumbnail" :alt="resource.title" class="w-full h-full object-cover" />

              <div class="absolute top-3 right-3">
                <div :class="['px-2 py-1 rounded-full flex items-center gap-1', getTypeColor(resource.type)]">
                  <component :is="typeIcon(resource.type)" class="w-4 h-4" />
                  <span class="text-xs capitalize">{{ resource.type }}</span>
                </div>
              </div>

              <div class="absolute bottom-3 left-3">
                <div class="px-2 py-1 rounded-full bg-black bg-opacity-60 text-white text-xs flex items-center gap-1">
                  <LinkIcon class="w-3 h-3" />
                  {{ resource.source }}
                </div>
              </div>
            </div>

            <div class="p-4 flex flex-col flex-1 min-h-0">
              <div class="flex items-start justify-between mb-2">
                <h3 class="text-gray-900 flex-1 font-semibold text-sm truncate">{{ resource.title }}</h3>
              </div>

              <p class="text-gray-600 text-sm mb-3 line-clamp-3">{{ resource.description }}</p>

              <div class="flex items-center gap-4 text-xs text-gray-500">
                <div class="flex items-center gap-1">
                  <Tag class="w-3 h-3" />
                  {{ resource.category }}
                </div>
              </div>

              <div class="mt-auto pt-4">
                <button
                  @click.stop="viewResource(resource)"
                  class="w-full px-3 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-semibold"
                >
                  View
                </button>
              </div>
            </div>
          </div>
        </div>

        <div v-else class="space-y-4">
          <div
            v-for="resource in filteredResources"
            :key="resource.id"
            class="bg-white rounded-xl shadow-lg p-4 transition-all cursor-pointer hover:shadow-xl"
            @click="viewResource(resource)"
          >
            <div class="flex gap-4">
              <img :src="resource.thumbnail" :alt="resource.title" class="w-32 h-28 object-cover rounded-lg shrink-0" />

              <div class="flex-1 min-w-0">
                <div class="flex items-start justify-between gap-4 mb-2">
                  <div class="flex-1">
                    <h3 class="text-gray-900 mb-1">{{ resource.title }}</h3>
                    <p class="text-gray-600 text-sm line-clamp-2">{{ resource.description }}</p>
                  </div>
                  <div :class="['px-2 py-1 rounded-full flex items-center gap-1', getTypeColor(resource.type), 'shrink-0']">
                    <component :is="typeIcon(resource.type)" class="w-4 h-4" />
                    <span class="text-xs capitalize">{{ resource.type }}</span>
                  </div>
                </div>

                <div class="flex items-center gap-4 text-xs text-gray-500">
                  <div class="flex items-center gap-1">
                    <Tag class="w-3 h-3" />
                    {{ resource.category }}
                  </div>
                  <div class="flex items-center gap-1">
                    <LinkIcon class="w-3 h-3" />
                    {{ resource.source }}
                  </div>
                  <div>Added {{ resource.addedDate }}</div>
                </div>
              </div>

              <div class="shrink-0">
                <button
                  @click.stop="viewResource(resource)"
                  class="px-3 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-semibold"
                >
                  View
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { BookOpen, FileText, Grid3x3, Link as LinkIcon, List, Plus, Search, Tag, Video } from 'lucide-vue-next'
import { listMyResources, type DbResource } from '../api/resource'

const router = useRouter()

type UiResource = {
  id: number
  title: string
  description: string
  category: string
  source: string
  thumbnail: string
  type: 'video'
  addedDate?: string
}

const resources = ref<UiResource[]>([])
const searchQuery = ref('')
const viewMode = ref<'grid' | 'list'>('grid')

const fallbackThumb = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400&h=225&fit=crop'

function formatDate(iso?: string | null) {
  if (!iso) return ''
  const d = new Date(iso)
  if (Number.isNaN(d.getTime())) return ''
  return d.toLocaleDateString()
}

function mapDbToUi(r: DbResource): UiResource {
  const source = (r.source || '').trim() || 'youtube'
  return {
    id: r.id,
    title: r.title,
    description: (r.description || '').trim(),
    category: (r.category || '').trim() || 'Other',
    source,
    thumbnail: (r.thumbnail_url || '').trim() || fallbackThumb,
    type: 'video',
    addedDate: formatDate(r.created_at),
  }
}

async function load() {
  const data = await listMyResources()
  resources.value = (data || []).map(mapDbToUi)
}

onMounted(() => {
  load()
})

const filteredResources = computed(() => {
  const q = searchQuery.value.trim().toLowerCase()
  if (!q) return resources.value

  return resources.value.filter(r => {
    return (
      r.title.toLowerCase().includes(q) ||
      r.description.toLowerCase().includes(q) ||
      r.category.toLowerCase().includes(q) ||
      r.source.toLowerCase().includes(q)
    )
  })
})

function setView(mode: 'grid' | 'list') {
  viewMode.value = mode
}

function typeIcon(type: string) {
  switch (type) {
    case 'video':
      return Video
    case 'document':
      return FileText
    case 'article':
      return BookOpen
    default:
      return FileText
  }
}

function getTypeColor(type: string) {
  switch (type) {
    case 'video':
      return 'bg-purple-100 text-purple-600'
    case 'document':
      return 'bg-blue-100 text-blue-600'
    case 'article':
      return 'bg-green-100 text-green-600'
    default:
      return 'bg-gray-100 text-gray-600'
  }
}

function viewResource(resource: UiResource) {
  router.push({ name: 'resource-video', params: { id: resource.id } })
}
</script>
