<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Resource Library</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">Manage your resources</p>
        </div>
      </div>
    </section>

    <Card as="section" :hoverable="false" class="rounded-none">
      <div class="p-4">
        <div class="flex flex-col lg:flex-row gap-4 items-start lg:items-center justify-between">
          <div class="flex flex-col sm:flex-row gap-3 flex-1 w-full lg:w-auto">
            <div class="relative flex-1">
              <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
              <Input
                ref="searchInputEl"
                type="text"
                placeholder="Search resources..."
                v-model="searchQuery"
                class="h-10 w-full rounded-none pl-10"
              />
            </div>

            <div class="relative">
              <select
                v-model="selectedCategory"
                class="h-10 appearance-none rounded-none border border-input bg-background pl-10 pr-10 text-sm text-foreground outline-none transition focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background cursor-pointer"
              >
                <option v-for="cat in categories" :key="cat" :value="cat">{{ cat }}</option>
              </select>
              <Filter class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground pointer-events-none" />
              <ChevronDown class="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground pointer-events-none" />
            </div>
          </div>

          <div class="flex gap-3 w-full lg:w-auto">
            <div class="flex gap-1 border border-border bg-background rounded-none p-1">
              <Button
                type="button"
                variant="ghost"
                size="icon"
                class="rounded-none"
                :class="viewMode === 'grid' ? 'bg-accent text-accent-foreground' : ''"
                @click="setView('grid')"
              >
                <Grid3x3 class="w-4 h-4" />
              </Button>
              <Button
                type="button"
                variant="ghost"
                size="icon"
                class="rounded-none"
                :class="viewMode === 'list' ? 'bg-accent text-accent-foreground' : ''"
                @click="setView('list')"
              >
                <List class="w-4 h-4" />
              </Button>
            </div>

            <Button
              type="button"
              variant="outline"
              size="sm"
              class="rounded-none"
              @click="focusSearch"
            >
              <Search class="w-4 h-4" />
              Search
            </Button>
          </div>
        </div>
      </div>
    </Card>

    <div v-if="loading" class="text-center py-16">
      <p class="text-sm text-muted-foreground">Loading…</p>
    </div>

    <Card v-else-if="filteredResources.length === 0" as="section" :hoverable="false" class="rounded-none">
      <div class="py-16 text-center">
        <BookOpen class="w-16 h-16 text-muted-foreground/30 mx-auto mb-4" />
        <h3 class="text-foreground mb-2">No resources found</h3>
        <p class="text-muted-foreground mb-6">
          {{ searchQuery || selectedCategory !== 'All' ? 'Try adjusting your filters' : 'Start by adding your first resource' }}
        </p>
        <Button type="button" variant="outline" size="sm" class="rounded-none" @click="focusSearch">
          <Search class="w-4 h-4" />
          Search
        </Button>
      </div>
    </Card>

      <div v-else>
        <div v-if="viewMode === 'grid'" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-6">
          <Card
            v-for="resource in filteredResources"
            :key="resource.id"
            :hoverable="true"
            className="rounded-none cursor-pointer"
            @click="viewResource(resource)"
          >
            <div class="relative h-32 bg-muted">
              <img :src="resource.thumbnail || fallbackThumb" :alt="resource.title" class="h-full w-full object-cover" />
              <div class="absolute top-3 right-3">
                <span class="px-2 py-1 border border-border bg-background text-foreground text-xs font-semibold">
                  {{ displayResourceType(resource) }}
                </span>
              </div>
              <div class="absolute bottom-3 left-3">
                <span class="px-2 py-1 border border-border bg-background/90 text-foreground text-xs">
                  {{ formatPlatform((resource as any).platform) }}
                </span>
              </div>
            </div>

            <div class="p-4 flex min-h-0 flex-1 flex-col">
              <h3 class="truncate text-sm font-semibold text-foreground">{{ resource.title }}</h3>
              <p class="mt-2 line-clamp-3 text-sm text-muted-foreground">{{ resource.summary || '' }}</p>

              <div class="mt-3 space-y-1 text-xs text-muted-foreground">
                <div class="flex items-center justify-between gap-3">
                  <span>分类</span>
                  <span class="truncate text-foreground">{{ resourceCategoryLabel(resource) }}</span>
                </div>
                <div class="flex items-center justify-between gap-3">
                  <span>发布时间</span>
                  <span class="text-foreground">{{ formatExtractDate(getCardMeta(resource.id)?.publish_date || null) || '—' }}</span>
                </div>
              </div>

              <div class="mt-auto pt-4">
                <div class="grid grid-cols-2 gap-2">
                  <Button type="button" size="sm" class="rounded-none" @click.stop="viewResource(resource)">
                    View
                  </Button>
                  <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    class="rounded-none"
                    @click.stop="addToMyResources(resource)"
                    :disabled="addingToMy[resource.id] || addedToMy[resource.id]"
                  >
                    {{ addedToMy[resource.id] ? 'Added' : (addingToMy[resource.id] ? 'Adding…' : 'Add') }}
                  </Button>
                </div>
              </div>
            </div>
          </Card>
        </div>

        <div v-else class="space-y-4">
          <Card
            v-for="resource in filteredResources"
            :key="resource.id"
            :hoverable="true"
            className="rounded-none cursor-pointer"
            @click="viewResource(resource)"
          >
            <div class="p-4">
              <div class="flex gap-4">
                <div class="relative w-32 shrink-0">
                  <img
                    :src="resource.thumbnail || fallbackThumb"
                    :alt="resource.title"
                    class="h-28 w-32 rounded-none object-cover"
                  />
                  <div class="absolute top-2 left-2">
                    <span class="px-2 py-1 border border-border bg-background text-foreground text-xs font-semibold">
                      {{ displayResourceType(resource) }}
                    </span>
                  </div>
                </div>

                <div class="min-w-0 flex-1">
                  <div class="flex items-start justify-between gap-4">
                    <div class="min-w-0">
                      <h3 class="truncate text-sm font-semibold text-foreground">{{ resource.title }}</h3>
                      <p class="mt-2 line-clamp-2 text-sm text-muted-foreground">{{ resource.summary || '' }}</p>
                    </div>

                    <div class="shrink-0">
                      <span class="px-2 py-1 border border-border bg-background/90 text-foreground text-xs">
                        {{ formatPlatform((resource as any).platform) }}
                      </span>
                    </div>
                  </div>

                  <div class="mt-3 grid grid-cols-1 gap-2 text-xs text-muted-foreground sm:grid-cols-2">
                    <div class="flex items-center justify-between gap-3">
                      <span>分类</span>
                      <span class="truncate text-foreground">{{ resourceCategoryLabel(resource) }}</span>
                    </div>
                    <div class="flex items-center justify-between gap-3">
                      <span>发布时间</span>
                      <span class="text-foreground">{{ formatExtractDate(getCardMeta(resource.id)?.publish_date || null) || '—' }}</span>
                    </div>
                  </div>
                </div>

                <div class="flex shrink-0 flex-col gap-2">
                  <Button type="button" size="sm" class="rounded-none" @click.stop="viewResource(resource)">View</Button>
                  <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    class="rounded-none"
                    @click.stop="addToMyResources(resource)"
                    :disabled="addingToMy[resource.id] || addedToMy[resource.id]"
                  >
                    {{ addedToMy[resource.id] ? 'Added' : (addingToMy[resource.id] ? 'Adding…' : 'Add') }}
                  </Button>
                </div>
              </div>
            </div>
          </Card>
        </div>
      </div>
    </div>


  <div v-if="showAddResultModal" class="fixed inset-0 bg-black/20 backdrop-blur-sm flex items-center justify-center p-4 z-50">
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
        <Button type="button" class="rounded-none" @click="closeAddResultModal">确定</Button>
      </div>
    </Card>
  </div>

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
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { BookOpen, ChevronDown, FileText, Filter, Grid3x3, Link as LinkIcon, List, Plus, Scissors, Search, Tag, Video, X } from 'lucide-vue-next'
import { useRouter } from 'vue-router'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import Card from '../components/ui/Card.vue'
import { formatPlatform } from '../utils/platform'
import {
  addPublicResourceToMyResourcesWithStatus,
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

const viewMode = ref<'grid' | 'list'>('grid')
const selectedCategory = ref<string>('All')
const searchQuery = ref('')

const searchInputEl = ref<HTMLInputElement | null>(null)

const router = useRouter()

const cardMetaById = ref<Record<number, UrlExtractResponse>>({})
const addingToMy = ref<Record<number, boolean>>({})
const addedToMy = ref<Record<number, boolean>>({})

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
  return String((resource as any).category_name || '').trim() || '其他'
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

function setView(mode: 'grid' | 'list') {
  viewMode.value = mode
}

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

async function addToMyResources(resource: DbResource) {
  if (!resource?.id) return
  if (addingToMy.value[resource.id] || addedToMy.value[resource.id]) return

  addingToMy.value = { ...addingToMy.value, [resource.id]: true }
  try {
    const res = await addPublicResourceToMyResourcesWithStatus(resource.id)
    addedToMy.value = { ...addedToMy.value, [resource.id]: true }

    if (res?.already_exists) {
      openAddResultModal('已存在', '该资源已经在 My Resources 中。')
    } else {
      openAddResultModal('保存成功', '已添加到 My Resources。')
    }
  } catch (e: any) {
    const msg = e?.response?.data?.detail || e?.message || 'Failed to add to my resources'
    openAddResultModal('保存失败', String(msg))
  } finally {
    addingToMy.value = { ...addingToMy.value, [resource.id]: false }
  }
}

onMounted(async () => {
  await loadCategories()
  await loadResources()
})
</script>
