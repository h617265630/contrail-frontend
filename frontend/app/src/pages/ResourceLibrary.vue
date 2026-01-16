<template>
  <div class="min-h-screen bg-linear-to-br from-blue-50 to-indigo-100 p-6">
    <div class="max-w-7xl mx-auto">
      <div class="mb-8">
        <h1 class="text-gray-900 mb-2">Resource Library</h1>
        <p class="text-gray-600">Manage your resources</p>
      </div>

      <div class="bg-white rounded-xl shadow-lg p-4 mb-6">
        <div class="flex flex-col lg:flex-row gap-4 items-start lg:items-center justify-between">
          <div class="flex flex-col sm:flex-row gap-3 flex-1 w-full lg:w-auto">
            <div class="relative flex-1">
              <Search class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="text"
                placeholder="Search resources..."
                v-model="searchQuery"
                class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>

            <div class="relative">
              <select
                v-model="selectedCategory"
                class="appearance-none pl-10 pr-10 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white cursor-pointer"
              >
                <option v-for="cat in categories" :key="cat" :value="cat">{{ cat }}</option>
              </select>
              <Filter class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400 pointer-events-none" />
              <ChevronDown class="absolute right-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400 pointer-events-none" />
            </div>
          </div>

          <div class="flex gap-3 w-full lg:w-auto">
            <div class="flex gap-1 bg-gray-100 rounded-lg p-1">
              <button @click="setView('grid')" :class="['p-2 rounded', viewMode === 'grid' ? 'bg-white shadow-sm' : 'text-gray-500']">
                <Grid3x3 class="w-5 h-5" />
              </button>
              <button @click="setView('list')" :class="['p-2 rounded', viewMode === 'list' ? 'bg-white shadow-sm' : 'text-gray-500']">
                <List class="w-5 h-5" />
              </button>
            </div>

            <button
              @click="openAddModal"
              class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center gap-2"
            >
              <Plus class="w-4 h-4" />
              Add Resource
            </button>
          </div>
        </div>
      </div>

      <div v-if="loading" class="text-center py-16 bg-white rounded-xl shadow-lg">
        <p class="text-gray-600">Loading…</p>
      </div>

      <div v-else-if="filteredResources.length === 0" class="text-center py-16 bg-white rounded-xl shadow-lg">
        <BookOpen class="w-16 h-16 text-gray-300 mx-auto mb-4" />
        <h3 class="text-gray-900 mb-2">No resources found</h3>
        <p class="text-gray-600 mb-6">
          {{ searchQuery || selectedCategory !== 'All' ? 'Try adjusting your filters' : 'Start by adding your first resource' }}
        </p>
        <button
          v-if="!searchQuery && selectedCategory === 'All'"
          @click="openAddModal"
          class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors inline-flex items-center gap-2"
        >
          <Plus class="w-4 h-4" />
          Add Resource
        </button>
      </div>

      <div v-else>
        <div v-if="viewMode === 'grid'" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-6">
          <div
            v-for="resource in filteredResources"
            :key="resource.id"
            class="bg-white rounded-xl shadow-lg overflow-hidden transition-all cursor-pointer h-90 flex flex-col hover:shadow-xl"
            @click="viewResource(resource)"
          >
            <div class="relative h-32">
              <img :src="resource.thumbnail_url || fallbackThumb" :alt="resource.title" class="w-full h-full object-cover" />

              <div class="absolute top-3 right-3">
                <div
                  class="px-2 py-1 rounded-full flex items-center gap-1"
                  :class="getTypeColor(normalizeResourceType(resource.resource_type))"
                >
                  <component :is="typeIcon(normalizeResourceType(resource.resource_type))" class="w-4 h-4" />
                  <span class="text-xs capitalize">{{ normalizeResourceType(resource.resource_type) }}</span>
                </div>
              </div>

              <div class="absolute bottom-3 left-3">
                <div class="px-2 py-1 rounded-full bg-black bg-opacity-60 text-white text-xs flex items-center gap-1">
                  <LinkIcon class="w-3 h-3" />
                  {{ resource.source || 'link' }}
                </div>
              </div>
            </div>

            <div class="p-4 flex flex-col flex-1 min-h-0">
              <h3 class="text-gray-900 font-semibold text-sm truncate mb-2">{{ resource.title }}</h3>
              <p class="text-gray-600 text-sm mb-3 line-clamp-3">{{ resource.description || '' }}</p>

              <div class="space-y-1 text-xs text-gray-600 mb-3">
                <div class="flex items-center justify-between gap-3">
                  <span class="text-gray-500">Author</span>
                  <span class="font-semibold text-gray-700 truncate">{{ getCardMeta(resource.id)?.author || '—' }}</span>
                </div>
                <div class="flex items-center justify-between gap-3">
                  <span class="text-gray-500">Publish</span>
                  <span class="font-semibold text-gray-700">{{ formatExtractDate(getCardMeta(resource.id)?.publish_date || null) || '—' }}</span>
                </div>
                <div class="flex items-center justify-between gap-3">
                  <span class="text-gray-500">Video ID</span>
                  <span class="font-mono text-[11px] text-gray-700 truncate">{{ getCardMeta(resource.id)?.video_id || '—' }}</span>
                </div>
                <div class="flex items-center justify-between gap-3">
                  <span class="text-gray-500">Chapters</span>
                  <span class="font-semibold text-gray-700">{{ (getCardMeta(resource.id)?.chapters || []).length || 0 }}</span>
                </div>
              </div>

              <div class="flex items-center gap-4 text-xs text-gray-500 mb-3">
                <div class="flex items-center gap-1">
                  <Tag class="w-3 h-3" />
                  {{ resource.category || 'Other' }}
                </div>
              </div>

              <div class="mt-auto">
                <button @click.stop="viewResource(resource)" class="w-full px-3 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-semibold">
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
              <img :src="resource.thumbnail_url || fallbackThumb" :alt="resource.title" class="w-32 h-28 object-cover rounded-lg shrink-0" />

              <div class="flex-1 min-w-0">
                <div class="flex items-start justify-between gap-4 mb-2">
                  <div class="flex-1">
                    <h3 class="text-gray-900 mb-1">{{ resource.title }}</h3>
                    <p class="text-gray-600 text-sm line-clamp-2">{{ resource.description || '' }}</p>
                  </div>
                    <div
                      class="px-2 py-1 rounded-full flex items-center gap-1 shrink-0"
                      :class="getTypeColor(normalizeResourceType(resource.resource_type))"
                    >
                      <component :is="typeIcon(normalizeResourceType(resource.resource_type))" class="w-4 h-4" />
                      <span class="text-xs capitalize">{{ normalizeResourceType(resource.resource_type) }}</span>
                    </div>
                </div>

                <div class="flex items-center gap-4 text-xs text-gray-500">
                  <div class="flex items-center gap-1">
                    <Tag class="w-3 h-3" />
                    {{ resource.category || 'Other' }}
                  </div>
                  <div class="flex items-center gap-1">
                    <LinkIcon class="w-3 h-3" />
                    {{ resource.source || 'link' }}
                  </div>
                </div>
              </div>

              <div class="flex gap-2 shrink-0">
                <button @click.stop="viewResource(resource)" class="px-3 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-semibold">
                  View
                </button>
              </div>
            </div>

            <div class="mt-3 grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs text-gray-600">
              <div class="flex items-center justify-between gap-3">
                <span class="text-gray-500">Author</span>
                <span class="font-semibold text-gray-700 truncate">{{ getCardMeta(resource.id)?.author || '—' }}</span>
              </div>
              <div class="flex items-center justify-between gap-3">
                <span class="text-gray-500">Publish</span>
                <span class="font-semibold text-gray-700">{{ formatExtractDate(getCardMeta(resource.id)?.publish_date || null) || '—' }}</span>
              </div>
              <div class="flex items-center justify-between gap-3">
                <span class="text-gray-500">Video ID</span>
                <span class="font-mono text-[11px] text-gray-700 truncate">{{ getCardMeta(resource.id)?.video_id || '—' }}</span>
              </div>
              <div class="flex items-center justify-between gap-3">
                <span class="text-gray-500">Chapters</span>
                <span class="font-semibold text-gray-700">{{ (getCardMeta(resource.id)?.chapters || []).length || 0 }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div v-if="showAddModal" class="fixed inset-0 bg-black/20 backdrop-blur-sm flex items-center justify-center p-4 z-50">
      <div class="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b border-gray-200 p-6 flex items-center justify-between">
          <h2 class="text-gray-900">Add New Resource</h2>
          <button @click="closeAddModal" class="text-gray-400 hover:text-gray-600">
            <X class="w-6 h-6" />
          </button>
        </div>

        <div class="p-6 space-y-4">
          <div>
            <label class="block text-gray-700 mb-2">Resource URL *</label>
            <div class="relative">
              <LinkIcon class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="url"
                placeholder="Paste YouTube URL"
                v-model="urlInput"
                class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
            <p v-if="extractError" class="mt-2 text-sm text-red-600">{{ extractError }}</p>
          </div>

          <div class="rounded-lg border border-gray-200 bg-gray-50 p-4">
            <div class="flex items-center justify-between gap-3 mb-2">
              <h3 class="text-gray-900 text-sm font-semibold">Parsed Info</h3>
              <span v-if="extracting" class="text-xs text-gray-500">Parsing…</span>
            </div>

            <div class="space-y-3">
              <div v-if="extractedMeta?.thumbnail_url" class="rounded-lg border border-gray-200 bg-white p-2">
                <img
                  :src="extractedMeta.thumbnail_url"
                  :alt="extractedMeta?.title || 'thumbnail'"
                  class="h-28 w-full object-cover rounded-md"
                />
              </div>

              <div>
                <div class="text-xs text-gray-500 mb-1">Title</div>
                <div class="text-sm text-gray-900 wrap-break-word">{{ extractedMeta?.title || '—' }}</div>
              </div>

              <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <div class="text-xs text-gray-500 mb-1">Author</div>
                  <div class="text-sm text-gray-700 wrap-break-word">{{ extractedMeta?.author || '—' }}</div>
                </div>
                <div>
                  <div class="text-xs text-gray-500 mb-1">Publish date</div>
                  <div class="text-sm text-gray-700 wrap-break-word">{{ formatExtractDate(extractedMeta?.publish_date || null) || '—' }}</div>
                </div>
              </div>

              <div>
                <div class="text-xs text-gray-500 mb-1">Video ID</div>
                <div class="text-sm text-gray-700 wrap-break-word">{{ extractedMeta?.video_id || '—' }}</div>
              </div>

              <div>
                <div class="text-xs text-gray-500 mb-1">Description</div>
                <div class="text-sm text-gray-700 whitespace-pre-wrap wrap-break-word max-h-48 overflow-auto">{{ extractedMeta?.description || '—' }}</div>
              </div>

              <div>
                <div class="text-xs text-gray-500 mb-1">Chapters</div>
                <div v-if="(extractedMeta?.chapters || []).length === 0" class="text-sm text-gray-700">—</div>
                <div v-else class="max-h-56 overflow-auto rounded-lg border border-gray-200 bg-white">
                  <div
                    v-for="ch in (extractedMeta?.chapters || []).slice(0, 12)"
                    :key="ch.start_seconds + ':' + ch.title"
                    class="flex items-start justify-between gap-3 px-3 py-2 border-b border-gray-100 last:border-b-0"
                  >
                    <div class="min-w-0">
                      <div class="text-sm text-gray-900 wrap-break-word">{{ ch.title }}</div>
                      <div v-if="ch.description" class="text-xs text-gray-500 mt-0.5 wrap-break-word">{{ ch.description }}</div>
                    </div>
                    <div class="shrink-0 text-xs font-semibold text-gray-500">{{ ch.timestamp }}</div>
                  </div>
                </div>
                <div v-if="(extractedMeta?.chapters || []).length > 12" class="mt-1 text-xs text-gray-500">
                  仅展示前 12 条章节
                </div>
              </div>
            </div>
          </div>

          <p v-if="submitError" class="text-sm text-red-600">{{ submitError }}</p>
        </div>

        <div class="sticky bottom-0 bg-gray-50 border-t border-gray-200 p-6 flex gap-3 justify-end">
          <button @click="closeAddModal" class="px-6 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">Cancel</button>
          <button
            @click="confirmAdd"
            :disabled="!urlInput || extracting || !extractedMeta?.title || submitting"
            class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {{ submitting ? 'Saving…' : 'Add Resource' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { BookOpen, ChevronDown, FileText, Filter, Grid3x3, Link as LinkIcon, List, Plus, Scissors, Search, Tag, Video, X } from 'lucide-vue-next'
import { useRouter } from 'vue-router'
import { createMyResourceFromUrl, extractVideoMetadata, listMyResources, type DbResource, type UrlExtractResponse } from '../api/resource'

const categories = ['All', 'Frontend', 'Backend', 'Database', 'DevOps', 'Design', 'Custom', 'Other']
const fallbackThumb = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400&h=225&fit=crop'

const resources = ref<DbResource[]>([])
const loading = ref(false)

const viewMode = ref<'grid' | 'list'>('grid')
const selectedCategory = ref<string>('All')
const searchQuery = ref('')

const showAddModal = ref(false)
const urlInput = ref('')
const extracting = ref(false)
const extractError = ref('')
const extractedMeta = ref<UrlExtractResponse | null>(null)
const submitting = ref(false)
const submitError = ref('')

const router = useRouter()

const cardMetaById = ref<Record<number, UrlExtractResponse>>({})

function getCardMeta(id: number) {
  return cardMetaById.value[id]
}

function normalizeResourceType(resourceType: string) {
  const t = String(resourceType || '').trim().toLowerCase()
  return t || 'link'
}

function typeIcon(type: string) {
  switch (type) {
    case 'video':
      return Video
    case 'clip':
      return Scissors
    case 'link':
      return LinkIcon
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
    case 'clip':
      return 'bg-emerald-100 text-emerald-700'
    case 'link':
      return 'bg-gray-100 text-gray-700'
    case 'document':
      return 'bg-blue-100 text-blue-600'
    case 'article':
      return 'bg-green-100 text-green-600'
    default:
      return 'bg-gray-100 text-gray-600'
  }
}

function formatExtractDate(iso?: string | null) {
  if (!iso) return ''
  const d = new Date(iso)
  if (Number.isNaN(d.getTime())) return ''
  return d.toLocaleDateString()
}

async function prefetchCardMetas(list: DbResource[]) {
  const targets = (list || []).filter(r => {
    if (!r?.id) return false
    if (cardMetaById.value[r.id]) return false
    const url = String(r.url || '').trim()
    return !!url
  })

  if (targets.length === 0) return

  // simple concurrency limit to avoid flooding the backend
  const concurrency = 3
  let idx = 0

  async function worker() {
    while (idx < targets.length) {
      const current = targets[idx]
      idx += 1
      try {
        const url = String(current.url || '').trim()
        if (!url) continue
        const meta = await extractVideoMetadata(url)
        cardMetaById.value = { ...cardMetaById.value, [current.id]: meta }
      } catch {
        // Ignore per-item failures (e.g. non-YouTube link)
      }
    }
  }

  await Promise.all(Array.from({ length: Math.min(concurrency, targets.length) }, () => worker()))
}

const filteredResources = computed(() => {
  return resources.value.filter(r => {
    const cat = r.category || 'Other'
    const matchesCategory = selectedCategory.value === 'All' || cat === selectedCategory.value
    const q = searchQuery.value.trim().toLowerCase()
    if (!q) return matchesCategory

    const title = (r.title || '').toLowerCase()
    const desc = (r.description || '').toLowerCase()
    return matchesCategory && (title.includes(q) || desc.includes(q))
  })
})

function setView(mode: 'grid' | 'list') {
  viewMode.value = mode
}

async function loadResources() {
  loading.value = true
  try {
    resources.value = await listMyResources()
    // best-effort: fill cards with parsed metadata in background
    void prefetchCardMetas(resources.value)
  } finally {
    loading.value = false
  }
}

function openAddModal() {
  showAddModal.value = true
  urlInput.value = ''
  extractedMeta.value = null
  extractError.value = ''
  submitError.value = ''
}

function closeAddModal() {
  showAddModal.value = false
  urlInput.value = ''
  extractedMeta.value = null
  extractError.value = ''
  submitError.value = ''
}

function viewResource(resource: DbResource) {
  router.push({ name: 'resource-video', params: { id: resource.id } })
}

async function confirmAdd() {
  if (!urlInput.value || !extractedMeta.value?.title) return
  submitError.value = ''
  submitting.value = true
  try {
    const created = await createMyResourceFromUrl(urlInput.value, 'Other')
    // Optimistically update list so the UI reacts immediately.
    resources.value = [created, ...resources.value]
    // Store parsed meta for the newly created resource (so card can show it immediately).
    if (extractedMeta.value) {
      cardMetaById.value = { ...cardMetaById.value, [created.id]: extractedMeta.value }
    }
    alert('Added successfully')
    closeAddModal()
    // Best-effort refresh from server to keep list canonical.
    await loadResources()
  } catch (e: any) {
    const msg = e?.response?.data?.detail || e?.message || 'Failed to add resource'
    submitError.value = String(msg)
  } finally {
    submitting.value = false
  }
}

let extractTimer: number | null = null
watch(
  () => urlInput.value,
  (nextUrl) => {
    extractError.value = ''
    extractedMeta.value = null

    if (extractTimer) {
      clearTimeout(extractTimer)
      extractTimer = null
    }

    const url = (nextUrl || '').trim()
    if (!url) {
      extracting.value = false
      return
    }

    extracting.value = true
    extractTimer = window.setTimeout(async () => {
      try {
        // eslint-disable-next-line no-new
        new URL(url)
        const data = await extractVideoMetadata(url)
        extractedMeta.value = {
          ...data,
          title: (data?.title || '').trim(),
          description: (data?.description ?? null) ? String(data.description) : null,
          thumbnail_url: (data?.thumbnail_url ?? null) ? String(data.thumbnail_url) : null,
          author: (data?.author ?? null) ? String(data.author) : null,
          publish_date: (data?.publish_date ?? null) ? String(data.publish_date) : null,
          video_id: (data?.video_id ?? null) ? String(data.video_id) : null,
          chapters: Array.isArray(data?.chapters) ? data.chapters : [],
        }
        if (!extractedMeta.value.title) {
          extractError.value = 'Parse failed: missing title'
          extractedMeta.value = null
        }
      } catch (e: any) {
        const msg = e?.response?.data?.detail || e?.message || 'Parse failed'
        extractError.value = String(msg)
        extractedMeta.value = null
      } finally {
        extracting.value = false
      }
    }, 500)
  }
)

onMounted(async () => {
  await loadResources()
})
</script>
