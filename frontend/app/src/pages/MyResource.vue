<template>
  <div class="min-h-screen bg-background">
    <section class="container mx-auto px-4 py-8">
      <header class="mb-8 flex items-center justify-between">
        <div>
          <h1 class="text-2xl font-bold text-foreground">My Resources</h1>
          <p class="text-muted-foreground mt-1">Manage the learning resources you saved.</p>
        </div>
        <div class="flex items-center gap-2">
          <Button
            type="button"
            size="sm"
            variant="outline"
            class="rounded-none"
            @click="expandAll = !expandAll"
          >
            {{ expandAll ? '收起全部' : '展开全部' }}
          </Button>

          <Button
            type="button"
            size="sm"
            class="rounded-none hover:bg-[#8ecbff] hover:text-white"
            @click="router.push({ name: 'add-resource' })"
          >
            Add Resource
          </Button>
        </div>
      </header>

      <div class="mb-8 grid gap-4 md:grid-cols-12 md:items-center">
        <div class="md:col-span-8">
          <div class="relative">
            <Search class="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <Input v-model="searchKeyword" placeholder="Search resources..." class="pl-9 rounded-none" />
          </div>
        </div>
        <div class="md:col-span-4 md:flex md:justify-end">
          <select
            v-model="filterType"
            class="h-10 w-full md:w-auto border border-border bg-background px-3 text-sm text-foreground outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background rounded-none"
          >
            <option value="">All types</option>
            <option value="video">Video</option>
            <option value="article">Article</option>
            <option value="document">Document</option>
          </select>
        </div>
      </div>

      <main class="flex flex-col gap-12">
        <div v-if="loading" class="py-12 text-center">
          <div class="inline-block h-8 w-8 animate-spin border-b-2 border-foreground" />
          <p class="mt-3 text-sm text-muted-foreground">Loading...</p>
        </div>

        <div v-else-if="resources.length === 0" class="py-12 text-center">
          <p class="text-sm text-muted-foreground">No resources yet</p>
        </div>

        <template v-else>
          <div
            v-for="deck in decks"
            :key="deck.key"
            class="flex flex-col"
          >
            <h2 class="text-lg font-semibold text-foreground mb-4">{{ deck.name }}</h2>

            <div class="relative h-72 overflow-visible">
              <div
                class="inline-flex items-center h-full"
                :style="{ paddingLeft: '20px' }"
                @mouseenter="hoveredDeckKey = deck.key"
                @mouseleave="hoveredDeckKey = null"
              >
                <div
                  v-for="(resource, cardIndex) in deck.cards"
                  :key="resource.id"
                  :class="[
                    'shrink-0 w-56 h-72 rounded-md border border-border bg-card shadow-sm transition-all duration-300 ease-out cursor-pointer hover:shadow-xl hover:!z-[100] card-hover',
                    getWeightCardClass(resource),
                  ]"
                  :style="getDeckCardStyle(deck.key, cardIndex)"
                  @click="openCard(resource)"
                >
                  <div class="h-full flex flex-col overflow-hidden rounded-md">
                    <div class="px-3 py-2 border-b border-border flex items-center justify-between">
                      <span
                        class="px-2 py-0.5 text-xs font-medium rounded"
                        :style="{
                          backgroundColor: getCategoryColor(resource.category) + '20',
                          color: getCategoryColor(resource.category),
                        }"
                      >
                        {{ resource.category || '—' }}
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
                      <p class="text-xs text-muted-foreground line-clamp-2">{{ resource.summary }}</p>
                    </div>

                    <div class="px-3 py-2 border-t border-border flex items-center justify-between">
                      <span class="text-xs text-muted-foreground">{{ formatPlatform(resource.platform) }}</span>
                      <span class="text-xs font-medium text-foreground">{{ resource.type }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <p class="text-sm text-muted-foreground mt-4">{{ deck.cards.length }} cards</p>
          </div>
        </template>
      </main>
    </section>
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
                  backgroundColor: getCategoryColor(activeResource.category) + '20',
                  color: getCategoryColor(activeResource.category),
                }"
              >
                {{ activeResource.category || '—' }}
              </span>
              <span class="text-xs text-muted-foreground">#{{ String(activeResource.id).padStart(3, '0') }}</span>
            </div>
            <h2 class="text-xl font-bold text-foreground">{{ activeResource.title }}</h2>
          </div>

          <div class="p-4">
            <p class="text-sm text-muted-foreground mb-4">{{ activeResource.summary }}</p>
            <div class="flex items-center gap-4 text-sm text-muted-foreground">
              <span>{{ formatPlatform(activeResource.platform) }}</span>
              <span>•</span>
              <span>{{ activeResource.type }}</span>
            </div>
          </div>

          <div class="p-4 border-t border-border flex flex-col gap-3">
            <Button
              type="button"
              class="w-full rounded-none bg-foreground text-background font-medium hover:bg-foreground/90"
              @click="seeDetail(activeResource)"
            >
              See detail
            </Button>

            <div class="flex items-center justify-between gap-3">
              <button
                type="button"
                class="relative inline-flex h-8 w-28 items-center rounded-full border border-border bg-muted/30 p-0.5 transition-colors"
                @click.stop="togglePublic(activeResource)"
                :disabled="publicUpdatingId === activeResource.id"
                aria-label="Toggle privacy"
              >
                <span
                  class="absolute inset-y-0.5 left-0.5 w-[calc(50%-0.25rem)] rounded-full shadow-sm transition-transform"
                  :class="[
                    activeResource.is_system_public ? 'bg-[#f9a8d4]' : 'bg-[#8ecbff]',
                    activeResource.is_system_public ? 'translate-x-[calc(100%+0.25rem)]' : 'translate-x-0',
                  ]"
                />
                <span class="relative z-10 flex w-full text-[11px] font-semibold">
                  <span class="flex w-1/2 justify-center" :class="activeResource.is_system_public ? 'text-muted-foreground' : 'text-white'">
                    Private
                  </span>
                  <span class="flex w-1/2 justify-center" :class="activeResource.is_system_public ? 'text-white' : 'text-muted-foreground'">
                    Public
                  </span>
                </span>
              </button>

              <div class="flex items-center gap-2">
                <Button type="button" variant="outline" class="rounded-none" @click.stop="editFromModal(activeResource)">Edit</Button>
                <Button
                  type="button"
                  variant="outline"
                  class="rounded-none hover:border-[#8ecbff] hover:bg-[#8ecbff] hover:text-white"
                  :disabled="deletingId === activeResource.id"
                  @click.stop="deleteFromModal(activeResource)"
                >
                  Delete
                </Button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>

  <div v-if="showDeleteConfirm" class="fixed inset-0 z-50 flex items-center justify-center bg-black/20 p-4 backdrop-blur-sm">
    <Card class="w-full max-w-md rounded-none" :hoverable="false">
      <div class="flex items-center justify-between border-b border-border p-6">
        <h2 class="text-lg font-semibold text-foreground">Confirm delete</h2>
        <Button
          type="button"
          variant="ghost"
          size="icon"
          class="rounded-none"
          @click="closeDeleteConfirm"
          :disabled="deletingId !== null"
        >
          <X class="h-5 w-5" />
        </Button>
      </div>

      <div class="space-y-3 p-6">
        <div class="text-sm text-foreground">Are you sure you want to delete this resource?</div>
        <div v-if="deleteTarget" class="border border-border bg-muted/30 p-3">
          <div class="line-clamp-1 font-semibold text-foreground">{{ deleteTarget.title }}</div>
          <div class="mt-1 line-clamp-1 text-xs text-muted-foreground">ID: {{ deleteTarget.id }}</div>
        </div>
        <p v-if="deleteError" class="text-sm text-destructive">{{ deleteError }}</p>
      </div>

      <div class="flex justify-end gap-2 border-t border-border bg-muted/30 p-6">
        <Button type="button" variant="outline" class="rounded-none" @click="closeDeleteConfirm" :disabled="deletingId !== null">
          Cancel
        </Button>
        <Button type="button" variant="destructive" class="rounded-none" @click="confirmDelete" :disabled="deletingId !== null">
          {{ deletingId !== null ? 'Deleting...' : 'Confirm' }}
        </Button>
      </div>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, onUnmounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Search, X } from 'lucide-vue-next'
import { deleteMyResource, listMyResources, type DbResource } from '../api/resource'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import { formatPlatform } from '../utils/platform'

const route = useRoute()
const router = useRouter()

type UiResource = {
  id: number
  title: string
  summary: string
  category: string
  platform: string
  thumbnail: string
  type: 'video' | 'document' | 'article'
  addedDate?: string
  is_system_public?: boolean
  manual_weight?: number | null
}

const resources = ref<UiResource[]>([])
const searchKeyword = ref('')
const filterType = ref('')
const loading = ref(false)
const deletingId = ref<number | null>(null)
const publicUpdatingId = ref<number | null>(null)

const activeResourceId = ref<number | null>(null)
const activeResource = computed(() => {
  if (activeResourceId.value === null) return null
  return resources.value.find(r => r.id === activeResourceId.value) || null
})

const showDeleteConfirm = ref(false)
const deleteTarget = ref<UiResource | null>(null)
const deleteError = ref('')

const fallbackThumb = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400&h=225&fit=crop'

function formatDate(iso?: string | null) {
  if (!iso) return ''
  const d = new Date(iso)
  if (Number.isNaN(d.getTime())) return ''
  return d.toLocaleDateString()
}

function mapDbToUi(r: DbResource): UiResource {
  const platform = String((r as any).platform || '').trim() || '—'
  const rawType = String((r as any).resource_type || '').trim().toLowerCase()
  const type: UiResource['type'] = rawType === 'document' || rawType === 'article' ? rawType : 'video'
  return {
    id: r.id,
    title: r.title,
    summary: String((r as any).summary || '').trim(),
    category: String((r as any).category_name || '').trim() || 'Other',
    platform,
    thumbnail: String((r as any).thumbnail || '').trim() || fallbackThumb,
    type,
    addedDate: formatDate(r.created_at),
    is_system_public: Boolean((r as any).is_system_public),
    manual_weight: (r as any).manual_weight ?? null,
  }
}

function getWeightCardClass(resource: UiResource) {
  const w = Number(resource.manual_weight)
  if (w >= 5) return 'weight-gold'
  if (w === 4) return 'weight-silver'
  if (w === 3) return 'weight-bronze'
  if (w === 2) return 'weight-iron'
  return 'weight-soil'
}

async function togglePublic(resource: UiResource) {
  publicUpdatingId.value = resource.id
  resources.value = resources.value.map(r => {
    if (r.id !== resource.id) return r
    return { ...r, is_system_public: !Boolean(r.is_system_public) }
  })
  publicUpdatingId.value = null
}

async function load() {
  loading.value = true;
  try {
    const data = await listMyResources()
    resources.value = (data || []).map(mapDbToUi)
  } catch (e: any) {
    const msg = e?.response?.data?.detail || e?.message || 'Failed to load my resources'
    alert(String(msg))
    resources.value = []
  } finally {
    loading.value = false;
  }
}

onMounted(() => {
  load()

  window.addEventListener('focus', load)
  document.addEventListener('visibilitychange', onVisibilityChange)
})

function onVisibilityChange() {
  if (document.visibilityState === 'visible') {
    load()
  }
}

onUnmounted(() => {
  window.removeEventListener('focus', load)
  document.removeEventListener('visibilitychange', onVisibilityChange)
})

watch(
  () => route.fullPath,
  () => {
    load()
  },
)

const filteredResources = computed(() => {
  const q = searchKeyword.value.trim().toLowerCase()
  const type = filterType.value

  return resources.value.filter(r => {
    const platform = String(r.platform || '').trim().toLowerCase()
    if (platform === 'xiaohongshu' || platform === 'xhs' || platform.includes('xiaohongshu')) return false
    if (platform === 'reddit') return false
    const matchType = !type || type === '' || r.type === type
    if (!matchType) return false
    if (!q) return true
    return (
      r.title.toLowerCase().includes(q) ||
      r.summary.toLowerCase().includes(q) ||
      r.category.toLowerCase().includes(q) ||
      r.platform.toLowerCase().includes(q)
    )
  })
})

type Deck = {
  key: string
  name: string
  cards: UiResource[]
}

const hoveredDeckKey = ref<string | null>(null)
const expandAll = ref(false)

const decks = computed<Deck[]>(() => {
  const map = new Map<string, UiResource[]>()
  for (const r of filteredResources.value) {
    const key = String(r.category || '').trim() || 'Other'
    const list = map.get(key)
    if (list) list.push(r)
    else map.set(key, [r])
  }

  return Array.from(map.entries())
    .sort((a, b) => a[0].localeCompare(b[0]))
    .map(([name, cards]) => ({ key: name, name, cards }))
})

function getDeckCardStyle(deckKey: string, cardIndex: number) {
  const isHovered = hoveredDeckKey.value === deckKey
  const isExpanded = expandAll.value || isHovered
  const total = decks.value.find(d => d.key === deckKey)?.cards.length || 0

  if (isExpanded) {
    return {
      marginLeft: cardIndex === 0 ? '0' : '16px',
      zIndex: cardIndex,
    }
  }

  const reverseIndex = total - 1 - cardIndex
  return {
    marginLeft: cardIndex === 0 ? '0' : '-210px',
    zIndex: cardIndex,
    transform: `rotate(${reverseIndex * 0.3}deg)`,
  }
}

function getResourceTypeClass(type: string) {
  switch (type) {
    case 'video':
      return 'bg-blue-100 text-blue-600'
    case 'article':
      return 'bg-green-100 text-green-600'
    case 'document':
      return 'bg-yellow-100 text-yellow-600'
    default:
      return 'bg-gray-100 text-gray-600'
  }
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

function openCard(resource: UiResource) {
  activeResourceId.value = resource.id
}

function closeActiveResource() {
  activeResourceId.value = null
}

function seeDetail(resource: UiResource) {
  closeActiveResource()
  viewResource(resource)
}

function editFromModal(resource: UiResource) {
  closeActiveResource()
  editResource(resource)
}

function deleteFromModal(resource: UiResource) {
  closeActiveResource()
  deleteResource(resource)
}

function viewResource(resource: UiResource) {
  const name = resource.type === 'video'
    ? 'my-resource-video'
    : resource.type === 'document'
      ? 'my-resource-document'
      : 'my-resource-article'
  router.push({ name, params: { id: resource.id } })
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

<style scoped>
.card-hover:hover {
  animation: card-tilt-up 0.4s ease forwards;
}

.weight-gold {
  border: 2px solid transparent;
  background:
    linear-gradient(hsl(var(--card)), hsl(var(--card))) padding-box,
    linear-gradient(45deg, #FFD700, #FFF8DC, #FFD700) border-box;
}

.weight-silver {
  border: 2px solid transparent;
  background:
    linear-gradient(hsl(var(--card)), hsl(var(--card))) padding-box,
    linear-gradient(45deg, #C0C0C0, #F8F8FF, #C0C0C0) border-box;
}

.weight-bronze {
  border: 2px solid transparent;
  background:
    linear-gradient(hsl(var(--card)), hsl(var(--card))) padding-box,
    linear-gradient(45deg, #CD7F32, #FFE1C2, #CD7F32) border-box;
}

.weight-iron {
  border: 2px solid transparent;
  background:
    linear-gradient(hsl(var(--card)), hsl(var(--card))) padding-box,
    linear-gradient(45deg, #94A3B8, #E2E8F0, #94A3B8) border-box;
}

.weight-soil {
  border: 1px solid hsl(var(--border));
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