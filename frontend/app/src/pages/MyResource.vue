<template>
  <div class="min-h-screen bg-linear-to-br from-blue-50 to-indigo-100 p-6">
    <div class="max-w-7xl mx-auto">
      <div class="mb-8 flex items-start justify-between gap-4">
        <div>
          <h1 class="text-gray-900 mb-2">My Resources</h1>
          <p class="text-gray-600">Resources you added</p>
        </div>
        <button
          type="button"
          class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors inline-flex items-center gap-2"
          @click="openAddModal"
        >
          <Plus class="w-4 h-4" />
          Add Resource
        </button>
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

                <div class="grid grid-cols-2 gap-2 mt-2">
                  <button
                    type="button"
                    class="px-3 py-2 rounded-lg bg-white border border-gray-200 text-gray-700 hover:bg-gray-50 font-semibold"
                    @click.stop="editResource(resource)"
                  >
                    Edit
                  </button>
                  <button
                    type="button"
                    class="px-3 py-2 rounded-lg bg-pink-600 text-white hover:bg-pink-700 font-semibold disabled:opacity-50 disabled:cursor-not-allowed"
                    :disabled="deletingId === resource.id"
                    @click.stop="deleteResource(resource)"
                  >
                    {{ deletingId === resource.id ? 'Deleting…' : 'Delete' }}
                  </button>
                </div>
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
                <div class="flex flex-col gap-2">
                  <button
                    @click.stop="viewResource(resource)"
                    class="px-3 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-semibold"
                  >
                    View
                  </button>
                  <button
                    type="button"
                    class="px-3 py-2 rounded-lg bg-white border border-gray-200 text-gray-700 hover:bg-gray-50 font-semibold"
                    @click.stop="editResource(resource)"
                  >
                    Edit
                  </button>
                  <button
                    type="button"
                    class="px-3 py-2 rounded-lg bg-pink-600 text-white hover:bg-pink-700 font-semibold disabled:opacity-50 disabled:cursor-not-allowed"
                    :disabled="deletingId === resource.id"
                    @click.stop="deleteResource(resource)"
                  >
                    {{ deletingId === resource.id ? 'Deleting…' : 'Delete' }}
                  </button>
                </div>
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
          <button type="button" @click="closeAddModal" class="text-gray-400 hover:text-gray-600">
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
          <button type="button" @click="closeAddModal" class="px-6 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">Cancel</button>
          <button
            type="button"
            @click="confirmAdd"
            :disabled="!urlInput || extracting || !extractedMeta?.title || submitting"
            class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {{ submitting ? 'Saving…' : 'Add Resource' }}
          </button>
        </div>
      </div>
    </div>

    <div v-if="showDeleteConfirm" class="fixed inset-0 bg-black/20 backdrop-blur-sm flex items-center justify-center p-4 z-50">
      <div class="bg-white rounded-xl shadow-2xl max-w-md w-full overflow-hidden">
        <div class="border-b border-gray-200 p-6 flex items-center justify-between">
          <h2 class="text-gray-900 text-lg font-semibold">确认删除</h2>
          <button type="button" @click="closeDeleteConfirm" class="text-gray-400 hover:text-gray-600" :disabled="deletingId !== null">
            <X class="w-6 h-6" />
          </button>
        </div>

        <div class="p-6 space-y-3">
          <div class="text-gray-700">是否确认删除该资源？</div>
          <div v-if="deleteTarget" class="rounded-lg border border-gray-200 bg-gray-50 p-3">
            <div class="text-gray-900 font-semibold line-clamp-1">{{ deleteTarget.title }}</div>
            <div class="text-xs text-gray-600 line-clamp-1 mt-1">ID: {{ deleteTarget.id }}</div>
          </div>
          <p v-if="deleteError" class="text-sm text-red-600">{{ deleteError }}</p>
        </div>

        <div class="bg-gray-50 border-t border-gray-200 p-6 flex gap-3 justify-end">
          <button
            type="button"
            class="px-6 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
            @click="closeDeleteConfirm"
            :disabled="deletingId !== null"
          >
            取消
          </button>
          <button
            type="button"
            class="px-6 py-2 bg-pink-600 text-white rounded-lg hover:bg-pink-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
            @click="confirmDelete"
            :disabled="!deleteTarget || deletingId !== null"
          >
            {{ deletingId !== null ? 'Deleting…' : '确定' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { BookOpen, FileText, Grid3x3, Link as LinkIcon, List, Plus, Search, Tag, Video, X } from 'lucide-vue-next'
import { createMyResourceFromUrl, deleteMyResource, extractVideoMetadata, listMyResources, type DbResource, type UrlExtractResponse } from '../api/resource'

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
const deletingId = ref<number | null>(null)

const showDeleteConfirm = ref(false)
const deleteTarget = ref<UiResource | null>(null)
const deleteError = ref('')

const showAddModal = ref(false)
const urlInput = ref('')
const extracting = ref(false)
const extractError = ref('')
const extractedMeta = ref<UrlExtractResponse | null>(null)
const submitting = ref(false)
const submitError = ref('')

const fallbackThumb = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400&h=225&fit=crop'

function formatDate(iso?: string | null) {
  if (!iso) return ''
  const d = new Date(iso)
  if (Number.isNaN(d.getTime())) return ''
  return d.toLocaleDateString()
}

function formatExtractDate(iso?: string | null) {
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

async function confirmAdd() {
  if (!urlInput.value || !extractedMeta.value?.title) return
  submitError.value = ''
  submitting.value = true
  try {
    await createMyResourceFromUrl(urlInput.value, 'Other')
    closeAddModal()
    await load()
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
  router.push({ name: 'my-resource-detail', params: { id: resource.id } })
}

function editResource(resource: UiResource) {
  router.push({ name: 'my-resource-edit', params: { id: resource.id } })
}

async function deleteResource(resource: UiResource) {
  if (deletingId.value !== null) return
  deleteError.value = ''
  deleteTarget.value = resource
  showDeleteConfirm.value = true
}

function closeDeleteConfirm() {
  if (deletingId.value !== null) return
  showDeleteConfirm.value = false
  deleteTarget.value = null
  deleteError.value = ''
}

async function confirmDelete() {
  if (!deleteTarget.value) return
  if (deletingId.value !== null) return
  deleteError.value = ''
  deletingId.value = deleteTarget.value.id
  try {
    await deleteMyResource(deleteTarget.value.id)
    resources.value = resources.value.filter(r => r.id !== deleteTarget.value!.id)
    showDeleteConfirm.value = false
    deleteTarget.value = null
  } catch (e: any) {
    const msg = e?.response?.data?.detail || e?.message || 'Failed to delete resource'
    deleteError.value = String(msg)
  } finally {
    deletingId.value = null
  }
}
</script>
