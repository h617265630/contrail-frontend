<template>
  <div class="min-h-screen bg-background">
    <div class="container mx-auto px-4 py-6 -mt-4 md:-mt-6">
      <main class="flex flex-col gap-8">

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
                placeholder="Search resources..."
                v-model="searchQuery"
                class="h-9 w-full rounded-none pl-10"
              />
            </div>
            </div>

            <div class="relative">
              <select
                v-model="selectedCategory"
                class="h-9 appearance-none rounded-none border border-input bg-background pl-10 pr-10 text-sm text-foreground outline-none transition focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background cursor-pointer"
              >
                <option v-for="cat in categories" :key="cat" :value="cat">{{ cat }}</option>
              </select>
              <Filter class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground pointer-events-none" />
              <ChevronDown class="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground pointer-events-none" />
            </div>
          </div>

          <div class="flex gap-3 w-full lg:w-auto">
          </div>
        </div>
      </div>
    </Card>

    <div v-if="loading" class="mx-auto w-full max-w-6xl text-center py-16">
      <p class="text-sm text-muted-foreground">Loading…</p>
    </div>

    <Card v-else-if="filteredResources.length === 0" as="section" :hoverable="false" class="mx-auto w-full max-w-6xl rounded-none">
      <div class="py-16 text-center">
        <BookOpen class="w-16 h-16 text-muted-foreground/30 mx-auto mb-4" />
        <h3 class="text-foreground mb-2">No resources found</h3>
        <p class="text-muted-foreground mb-6">
          {{ searchQuery || selectedCategory !== 'All' ? 'Try adjusting your filters' : 'Start by adding your first resource' }}
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
                    backgroundColor: getCategoryColor(resourceCategoryLabel(resource)) + '20',
                    color: getCategoryColor(resourceCategoryLabel(resource)),
                  }"
                >
                  {{ resourceCategoryLabel(resource) || '—' }}
                </span>
                <span class="text-xs text-muted-foreground">#{{ String(resource.id).padStart(3, '0') }}</span>
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
                <span class="text-xs text-muted-foreground">{{ formatPlatform((resource as any).platform) }}</span>
                <span class="text-xs font-medium text-foreground">{{ displayResourceType(resource) }}</span>
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
                    backgroundColor: getCategoryColor(resourceCategoryLabel(activeResource)) + '20',
                    color: getCategoryColor(resourceCategoryLabel(activeResource)),
                  }"
                >
                  {{ resourceCategoryLabel(activeResource) || '—' }}
                </span>
                <span class="text-xs text-muted-foreground">#{{ String(activeResource.id).padStart(3, '0') }}</span>
              </div>
              <h2 class="text-xl font-bold text-foreground">{{ activeResource.title }}</h2>
            </div>

            <div class="p-4">
              <p class="text-sm text-muted-foreground mb-4">{{ activeResource.summary || '' }}</p>
              <div class="flex items-center gap-4 text-sm text-muted-foreground">
                <span>{{ formatPlatform((activeResource as any).platform) }}</span>
                <span>•</span>
                <span>{{ displayResourceType(activeResource) }}</span>
              </div>
            </div>

            <div class="p-4 border-t border-border flex flex-col gap-3">
              <Button
                type="button"
                class="w-full rounded-none bg-foreground text-background font-medium hover:bg-foreground/90"
                @click="seeDetail(activeResource)"
              >
                View
              </Button>

              <Button
                type="button"
                variant="outline"
                class="w-full rounded-none"
                :disabled="addingToMy[activeResource.id] || addedToMy[activeResource.id]"
                @click="addToMyResources(activeResource)"
              >
                {{ addedToMy[activeResource.id] ? 'Added' : (addingToMy[activeResource.id] ? 'Adding…' : 'Add') }}
              </Button>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>


  <Teleport to="body">
  <div v-if="showAddResultModal" class="fixed inset-0 bg-black/20 backdrop-blur-sm flex items-center justify-center p-4 z-[100]">
    <Card as="section" :hoverable="false" class="w-full max-w-md rounded-none">
      <div class="flex items-center justify-between border-b border-border p-6">
        <h2 class="text-lg font-semibold text-foreground">{{ addResultTitle }}</h2>
        <Button type="button" variant="ghost" size="icon" class="rounded-none" @click="closeAddResultModal">
          <X class="h-5 w-5" />
        </Button>
      </div>

      <div class="space-y-3 p-6">
        <div class="text-sm text-foreground">{{ addResultMessage }}</div>
      </div>

      <div class="flex justify-end gap-2 border-t border-border bg-muted/30 p-6">
        <Button type="button" class="rounded-none" @click="closeAddResultModal">OK</Button>
      </div>
    </Card>
  </div>
  </Teleport>

  <div v-if="showCreateModal" class="fixed inset-0 bg-black/20 backdrop-blur-sm flex items-center justify-center p-4 z-50">
    <Card as="section" :hoverable="false" class="w-full max-w-md rounded-none">
      <div class="flex items-center justify-between border-b border-border p-6">
        <h2 class="text-lg font-semibold text-foreground">Add Resource</h2>
        <Button type="button" variant="ghost" size="icon" class="rounded-none" @click="closeCreateModal" :disabled="creating">
          <X class="h-5 w-5" />
        </Button>
      </div>

      <div class="space-y-4 p-6">
        <div>
          <label class="mb-2 block text-sm font-semibold text-foreground">Resource URL *</label>
          <Input v-model="createUrl" type="url" placeholder="Paste YouTube URL" class="rounded-none" />
        </div>

        <div>
          <label class="mb-2 block text-sm font-semibold text-foreground">Category</label>
          <div class="relative">
            <select
              v-model="createCategoryId"
              class="h-10 w-full appearance-none rounded-none border border-input bg-background px-3 pr-10 text-sm text-foreground outline-none transition focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background cursor-pointer"
            >
              <option value="">选择分类</option>
              <option v-for="c in dbCategories" :key="c.id" :value="String(c.id)">{{ c.name }}</option>
            </select>
            <ChevronDown class="absolute right-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground pointer-events-none" />
          </div>
        </div>

        <p v-if="createError" class="text-sm text-destructive">{{ createError }}</p>
      </div>

      <div class="flex justify-end gap-2 border-t border-border bg-muted/30 p-6">
        <Button type="button" variant="outline" class="rounded-none" @click="closeCreateModal" :disabled="creating">Cancel</Button>
        <Button type="button" class="rounded-none" @click="submitCreate" :disabled="!createUrl || creating">
          {{ creating ? 'Saving…' : 'Add' }}
        </Button>
      </div>
    </Card>
  </div>

  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { BookOpen, ChevronDown, FileText, Filter, Plus, Scissors, Search, Tag, Video, X, Link as LinkIcon } from 'lucide-vue-next'
import { useRouter } from 'vue-router'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import Card from '../components/ui/Card.vue'
import { formatPlatform } from '../utils/platform'
import {
  addPublicResourceToMyResourcesWithStatus,
  addPublicResourceToMyResourcesWithStatusAndWeight,
  createMyResourceFromUrl,
  extractVideoMetadata,
  listMyResources,
  listResources,
  type DbResource,
  type UrlExtractResponse,
} from '../api/resource'
import { listCategories, type Category } from '../api/category'

const dbCategories = ref<Category[]>([])
const categories = computed(() => ['All', ...dbCategories.value.map(c => c.name)])
const fallbackThumb = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400&h=225&fit=crop'

const resources = ref<DbResource[]>([])
const loading = ref(false)
const selectedCategory = ref<string>('All')
const searchQuery = ref('')

const searchInputEl = ref<HTMLInputElement | null>(null)

const router = useRouter()

const cardMetaById = ref<Record<number, UrlExtractResponse>>({})
const addingToMy = ref<Record<number, boolean>>({})
const addedToMy = ref<Record<number, boolean>>({})

const activeResourceId = ref<number | null>(null)
const activeResource = computed(() => {
  if (activeResourceId.value === null) return null
  return resources.value.find(r => r.id === activeResourceId.value) || null
})

const showAddResultModal = ref(false)
const addResultTitle = ref('')
const addResultMessage = ref('')

const showCreateModal = ref(false)
const createUrl = ref('')
const createCategoryId = ref('')
const creating = ref(false)
const createError = ref('')

function openAddResultModal(title: string, message: string) {
  addResultTitle.value = title
  addResultMessage.value = message
  showAddResultModal.value = true
}

function closeAddResultModal() {
  showAddResultModal.value = false
  addResultTitle.value = ''
  addResultMessage.value = ''
}

function getCardMeta(id: number) {
  return cardMetaById.value[id]
}

function resourceCategoryLabel(resource: DbResource) {
  return String((resource as any).category_name || '').trim() || 'Other'
}

function normalizeResourceType(resourceType: string) {
  const t = String(resourceType || '').trim().toLowerCase()
  return t || 'article'
}

function displayResourceType(resource: DbResource) {
  const raw = normalizeResourceType(resource.resource_type)
  if (raw === 'video' || raw === 'document' || raw === 'article') return raw
  return 'article'
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

function getCategoryColor(category?: string) {
  const key = String(category || '').trim().toLowerCase() || 'other'
  const palette = ['#3b82f6', '#22c55e', '#f59e0b', '#8b5cf6', '#ef4444', '#06b6d4', '#f97316', '#84cc16']
  let hash = 0
  for (let i = 0; i < key.length; i += 1) {
    hash = (hash * 31 + key.charCodeAt(i)) >>> 0
  }
  return palette[hash % palette.length]
}

async function prefetchCardMetas(list: DbResource[]) {
  const targets = (list || []).filter(r => {
    if (!r?.id) return false
    if (cardMetaById.value[r.id]) return false
    const url = String(r.source_url || '').trim()
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
        const url = String(current.source_url || '').trim()
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
    const platform = String((r as any)?.platform || '').trim().toLowerCase()
    if (platform === 'xiaohongshu' || platform === 'xhs' || platform.includes('小红书')) return false
    if (platform === 'reddit') return false
    const cat = resourceCategoryLabel(r)
    const matchesCategory = selectedCategory.value === 'All' || cat === selectedCategory.value
    const q = searchQuery.value.trim().toLowerCase()
    if (!q) return matchesCategory

    const title = (r.title || '').toLowerCase()
    const desc = (r.summary || '').toLowerCase()
    return matchesCategory && (title.includes(q) || desc.includes(q))
  })
})

function openCreateModal() {
  showCreateModal.value = true
  createUrl.value = ''
  if (!createCategoryId.value) {
    const other = dbCategories.value.find(c => String(c.code).toLowerCase() === 'other')
    createCategoryId.value = other ? String(other.id) : ''
  }
  createError.value = ''
}

function closeCreateModal() {
  showCreateModal.value = false
  createUrl.value = ''
  // keep selected category for next create
  createError.value = ''
}

async function submitCreate() {
  const url = createUrl.value.trim()
  if (!url) return
  createError.value = ''
  creating.value = true
  try {
    const catId = createCategoryId.value ? Number(createCategoryId.value) : NaN
    if (!Number.isFinite(catId)) throw new Error('请选择分类')
    await createMyResourceFromUrl(url, { category_id: catId })

    closeCreateModal()
    await loadResources()
    openAddResultModal('保存成功', '资源已创建并添加到 My Resources。')
  } catch (e: any) {
    const msg = e?.response?.data?.detail || e?.message || 'Failed to add resource'
    createError.value = String(msg)
  } finally {
    creating.value = false
  }
}

function focusSearch() {
  try {
    searchInputEl.value?.focus?.()
  } catch {
    // ignore
  }
}

async function loadResources() {
  loading.value = true
  try {
    resources.value = await listResources()
    // best-effort: fill cards with parsed metadata in background
    void prefetchCardMetas(resources.value)

    // best-effort: mark which ones already exist in My Resources
    void syncAddedFlags()
  } finally {
    loading.value = false
  }
}

async function loadCategories() {
  try {
    dbCategories.value = await listCategories()
    const other = dbCategories.value.find(c => String(c.code).toLowerCase() === 'other')
    if (other && !createCategoryId.value) createCategoryId.value = String(other.id)
  } catch {
    dbCategories.value = []
  }
}

async function syncAddedFlags() {
  try {
    const mine = await listMyResources()
    const next: Record<number, boolean> = {}
    for (const r of mine || []) {
      if (r?.id) next[r.id] = true
    }
    addedToMy.value = next
  } catch {
    // not logged in / network errors: ignore, keep default Add state
  }
}

function viewResource(resource: DbResource) {
  const t = displayResourceType(resource)
  const name = t === 'video' ? 'resource-video' : t === 'document' ? 'resource-document' : 'resource-article'
  router.push({ name, params: { id: resource.id } })
}

function openCard(resource: DbResource) {
  activeResourceId.value = resource.id
}

function closeActiveResource() {
  activeResourceId.value = null
}

function seeDetail(resource: DbResource) {
  closeActiveResource()
  viewResource(resource)
}

async function addToMyResources(resource: DbResource) {
  if (!resource?.id) return
  if (addingToMy.value[resource.id] || addedToMy.value[resource.id]) return

  addingToMy.value = { ...addingToMy.value, [resource.id]: true }
  try {
    const res = await addPublicResourceToMyResourcesWithStatusAndWeight(resource.id, { manual_weight: 1 })
    addedToMy.value = { ...addedToMy.value, [resource.id]: true }

    if (res?.already_exists) {
      openAddResultModal('Already Exists', 'This resource is already in your My Resources.')
    } else {
      openAddResultModal('Added Successfully', 'The resource has been added to My Resources.')
    }
  } catch (e: any) {
    const msg = e?.response?.data?.detail || e?.message || 'Failed to add to my resources'
    openAddResultModal('Failed', String(msg))
  } finally {
    addingToMy.value = { ...addingToMy.value, [resource.id]: false }
  }
}

onMounted(() => {
  loadCategories()
  loadResources()
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
</style>
