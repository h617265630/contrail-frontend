<template>
  <div class="min-h-screen bg-stone-50">

    <!-- Masthead -->
    <header class="border-b border-stone-200 bg-white">
      <div class="mx-auto max-w-7xl px-4 py-6 md:py-8">
        <div class="flex items-end justify-between gap-6">
          <div>
            <div class="flex items-center gap-2 mb-3">
              <span class="h-px w-8 bg-indigo-500"></span>
              <span class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">Personal</span>
            </div>
            <h1 class="text-3xl md:text-4xl font-black tracking-tight text-stone-900 leading-[0.92]">
              My<br/><span class="text-indigo-600">Resources.</span>
            </h1>
          </div>
          <div class="hidden md:flex flex-col items-end gap-2">
            <span class="text-xs text-stone-400">
              <span class="font-semibold text-stone-700">{{ totalCards }}</span> resources ·
              <span class="font-semibold text-stone-700">{{ decks.length }}</span> decks
            </span>
          </div>
        </div>

        <!-- Toolbar -->
        <div class="mt-6 flex flex-col sm:flex-row gap-3 items-start sm:items-center justify-between">
          <!-- Search -->
          <div class="relative flex-1 max-w-sm">
            <Search class="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-stone-400" />
            <input
              v-model="searchKeyword"
              type="text"
              placeholder="Search your resources..."
              class="h-10 w-full rounded-none border border-stone-200 bg-white pl-10 pr-4 text-sm text-stone-900 placeholder:text-stone-400 outline-none focus:border-indigo-400 focus:ring-1 focus:ring-indigo-100 transition-colors"
            />
          </div>

          <div class="flex items-center gap-3">
            <button
              class="h-10 px-4 text-xs font-semibold uppercase tracking-wider border border-stone-200 bg-white text-stone-600 hover:border-stone-400 hover:text-stone-900 transition-all rounded-none"
              @click="expandAll = !expandAll"
            >
              {{ expandAll ? 'Collapse all' : 'Expand all' }}
            </button>
            <Button
              type="button"
              size="sm"
              class="rounded-none bg-indigo-600 text-white hover:bg-indigo-700 font-semibold text-xs uppercase tracking-wider px-5"
              @click="router.push({ name: 'add-resource' })"
            >
              + Add
            </Button>
          </div>
        </div>
      </div>
    </header>

    <!-- Main content -->
    <main class="mx-auto max-w-7xl px-4 py-8">

      <!-- Loading -->
      <div v-if="loading" class="py-20 text-center">
        <div class="inline-flex items-center gap-3">
          <div class="h-2 w-2 rounded-full bg-indigo-500 animate-pulse"></div>
          <span class="text-sm text-stone-400">Loading your library…</span>
        </div>
      </div>

      <!-- Empty -->
      <div v-else-if="filteredResources.length === 0" class="py-20 text-center">
        <div class="text-5xl mb-4">📚</div>
        <h3 class="text-base font-semibold text-stone-700 mb-1">No resources yet</h3>
        <p class="text-sm text-stone-400 mb-5">Start by adding your first resource to build your personal library.</p>
        <Button
          type="button"
          class="rounded-none bg-indigo-600 text-white hover:bg-indigo-700 font-semibold text-sm"
          @click="router.push({ name: 'add-resource' })"
        >
          + Add your first resource
        </Button>
      </div>

      <!-- Decks -->
      <template v-else>
        <div v-for="(deck, deckIndex) in decks" :key="deck.key" class="mb-12">

          <!-- Deck header -->
          <div class="flex items-center justify-between mb-5">
            <div class="flex items-center gap-3">
              <div class="w-1 h-6 bg-indigo-500 rounded-full"></div>
              <h2 class="text-base font-bold text-stone-900 tracking-tight">{{ deck.name }}</h2>
              <span class="text-xs text-stone-400 font-medium">{{ deck.cards.length }} cards</span>
            </div>
            <button
              class="text-[11px] font-semibold uppercase tracking-wider text-stone-400 hover:text-stone-600 transition-colors"
              @click="toggleDeck(deckIndex)"
            >
              {{ isDeckExpanded(deckIndex) ? 'Collapse' : 'Expand' }}
            </button>
          </div>

          <!-- Collapsed fan view -->
          <div
            v-if="!isDeckExpanded(deckIndex)"
            class="relative h-64 overflow-visible cursor-pointer"
            @click="toggleDeck(deckIndex)"
          >
            <div class="inline-flex items-center h-full" :style="{ paddingLeft: '16px' }">
              <div
                v-for="(resource, cardIndex) in deck.cards.slice(0, collapsedPreviewCount)"
                :key="resource.id"
                :class="[
                  'shrink-0 w-52 rounded-xl overflow-hidden bg-white border border-stone-100 shadow-sm transition-all duration-300 cursor-pointer hover:shadow-xl flex flex-col',
                  getWeightCardClass(resource),
                ]"
                :style="getCollapsedPreviewCardStyle(cardIndex, Math.min(deck.cards.length, collapsedPreviewCount))"
                @click.stop="openCard(resource)"
              >
                <!-- Thumbnail -->
                <div class="relative bg-stone-100 overflow-hidden transition-transform duration-500 group-hover:scale-105" style="aspect-ratio: 16/9; width: 100%;">
                  <img
                    v-if="resource.thumbnail"
                    :src="resource.thumbnail"
                    :alt="resource.title"
                    class="block w-full h-full object-contain"
                    style="width: 100%; height: 100%; object-fit: contain; background-color: #f7f7f7;"
                  />
                  <div v-else class="w-full h-full flex items-center justify-center">
                    <div
                      class="w-10 h-10 rounded-full flex items-center justify-center text-lg font-bold text-white"
                      :style="{ backgroundColor: getCategoryColor(resource.category) }"
                    >
                      {{ resource.title.charAt(0) }}
                    </div>
                  </div>
                  <!-- Type badge -->
                  <div class="absolute top-2 left-2">
                    <span class="inline-flex items-center rounded-full bg-white/90 backdrop-blur-sm border border-white/20 px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider text-stone-600">
                      {{ resource.type }}
                    </span>
                  </div>
                </div>

                <!-- Content -->
                <div class="flex-1 p-3 flex flex-col">
                  <span
                    class="text-[10px] font-semibold uppercase tracking-wider mb-1"
                    :style="{ color: getCategoryColor(resource.category) }"
                  >
                    {{ resource.category || '—' }}
                  </span>
                  <h3 class="text-xs font-semibold text-stone-800 leading-snug line-clamp-2 group-hover:text-amber-700 transition-colors" :title="resource.title">
                    {{ resource.title }}
                  </h3>
                  <p class="text-[11px] text-stone-400 mt-1 line-clamp-2 flex-1">{{ resource.summary }}</p>
                  <div class="flex items-center justify-between mt-2 pt-2 border-t border-stone-50">
                    <span class="text-[10px] text-stone-400">{{ formatPlatform(resource.platform) }}</span>
                    <span class="text-[10px] text-stone-400">#{{ resource.user_seq ?? resource.id }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Expanded grid -->
          <div
            v-else
            class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-3"
          >
            <article
              v-for="(resource, i) in deck.cards"
              :key="resource.id"
              :class="[
                'aspect-4/5 rounded-xl overflow-hidden bg-white border border-stone-100 hover:border-stone-200 hover:shadow-md transition-all duration-200 cursor-pointer flex flex-col',
                getWeightCardClass(resource),
              ]"
              @click="openCard(resource)"
            >
              <!-- Thumbnail -->
              <div class="relative bg-stone-100 overflow-hidden transition-transform duration-500 group-hover:scale-105" style="aspect-ratio: 16/9; width: 100%;">
                <img
                  v-if="resource.thumbnail"
                  :src="resource.thumbnail"
                  :alt="resource.title"
                  class="block w-full h-full object-contain"
                  style="width: 100%; height: 100%; object-fit: contain; background-color: #f7f7f7;"
                />
                <div v-else class="w-full h-full flex items-center justify-center">
                  <div
                    class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold text-white"
                    :style="{ backgroundColor: getCategoryColor(resource.category) }"
                  >
                    {{ resource.title.charAt(0) }}
                  </div>
                </div>
                <!-- Type badge -->
                <div class="absolute top-2 left-2">
                  <span class="inline-flex items-center rounded-full bg-white/90 backdrop-blur-sm border border-white/20 px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider text-stone-600">
                    {{ resource.type }}
                  </span>
                </div>
              </div>

              <!-- Content -->
              <div class="flex-1 p-3.5 flex flex-col">
                <span
                  class="text-[10px] font-semibold uppercase tracking-wider mb-1.5"
                  :style="{ color: getCategoryColor(resource.category) }"
                >
                  {{ resource.category || '—' }}
                </span>
                <h3 class="text-sm font-semibold text-stone-800 leading-snug line-clamp-2 group-hover:text-amber-700 transition-colors" :title="resource.title">
                  {{ resource.title }}
                </h3>
                <p class="text-xs text-stone-400 mt-1 line-clamp-2 flex-1">{{ resource.summary }}</p>
                <div class="flex items-center justify-between mt-3 pt-2 border-t border-stone-50">
                  <span class="text-[10px] text-stone-400">{{ formatPlatform(resource.platform) }}</span>
                  <span class="text-[10px] font-semibold text-stone-400">#{{ resource.user_seq ?? resource.id }}</span>
                </div>
              </div>
            </article>
          </div>

          <p class="text-xs text-stone-400 mt-4">{{ deck.cards.length }} cards</p>
        </div>
      </template>
    </main>

    <!-- Detail modal -->
    <Teleport to="body">
      <Transition name="modal">
        <div
          v-if="activeResource"
          class="fixed inset-0 z-50 flex items-center justify-center p-4"
          @click.self="closeActiveResource"
        >
          <div class="absolute inset-0 bg-stone-900/60 backdrop-blur-sm"></div>
          <div class="relative w-full max-w-md rounded-2xl overflow-hidden bg-white shadow-2xl border border-stone-100">
            <div class="relative bg-stone-100 overflow-hidden" style="aspect-ratio: 16/9; width: 100%;">
              <img
                :src="activeResource.thumbnail || fallbackThumb"
                :alt="activeResource.title"
                class="block w-full h-full object-contain"
                style="width: 100%; height: 100%; object-fit: contain; background-color: #f7f7f7;"
              />
              <button
                class="absolute top-3 right-3 w-8 h-8 rounded-full bg-white/90 backdrop-blur-sm flex items-center justify-center text-stone-500 hover:text-stone-900 transition"
                @click="closeActiveResource"
              >
                <X class="w-4 h-4" />
              </button>
              <div class="absolute bottom-3 left-3 flex items-center gap-2">
                <span
                  class="text-[10px] font-bold uppercase tracking-wider px-2.5 py-1 rounded-full"
                  :style="{ backgroundColor: getCategoryColor(activeResource.category) + '18', color: getCategoryColor(activeResource.category) }"
                >
                  {{ activeResource.category || '—' }}
                </span>
                <span class="text-[10px] text-white/80">#{{ String(activeResource.id).padStart(3, '0') }}</span>
              </div>
            </div>

            <div class="p-5 border-b border-stone-100">
              <h2 class="text-lg font-bold text-stone-900">{{ activeResource.title }}</h2>
            </div>

            <div class="p-5">
              <p class="text-sm text-stone-500 mb-4 leading-relaxed">{{ activeResource.summary }}</p>
              <div class="flex items-center gap-4 text-xs text-stone-400">
                <span>{{ formatPlatform(activeResource.platform) }}</span>
                <span class="text-stone-200">·</span>
                <span class="font-semibold text-stone-600 uppercase tracking-wider text-[10px]">{{ activeResource.type }}</span>
              </div>
            </div>

            <div class="p-5 border-t border-stone-100 flex flex-col gap-3">
              <Button
                type="button"
                class="w-full rounded-full bg-stone-900 text-white hover:bg-stone-800 font-semibold text-sm transition-all hover:-translate-y-px"
                @click="seeDetail(activeResource)"
              >
                View details
              </Button>
              <div class="flex items-center gap-2">
                <!-- Privacy toggle -->
                <button
                  class="relative inline-flex h-8 w-28 items-center rounded-full border border-stone-200 bg-stone-50 p-0.5 transition-colors"
                  @click.stop="togglePublic(activeResource)"
                  :disabled="publicUpdatingId === activeResource.id"
                  aria-label="Toggle privacy"
                >
                  <span
                    class="absolute inset-y-0.5 left-0.5 w-[calc(50%-0.25rem)] rounded-full shadow-sm transition-transform duration-200"
                    :class="[
                      activeResource.is_system_public ? 'bg-rose-400' : 'bg-indigo-400',
                      activeResource.is_system_public ? 'translate-x-[calc(100%+0.25rem)]' : 'translate-x-0',
                    ]"
                  />
                  <span class="relative z-10 flex w-full text-[11px] font-semibold">
                    <span class="flex w-1/2 justify-center" :class="activeResource.is_system_public ? 'text-stone-400' : 'text-white'">Private</span>
                    <span class="flex w-1/2 justify-center" :class="activeResource.is_system_public ? 'text-white' : 'text-stone-400'">Public</span>
                  </span>
                </button>

                <div class="flex-1"></div>

                <Button type="button" variant="outline" size="sm" class="rounded-none h-8 text-xs" @click.stop="editFromModal(activeResource)">Edit</Button>
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  class="rounded-none h-8 text-xs text-red-500 border-red-200 hover:bg-red-50 hover:border-red-300"
                  :disabled="deletingId === activeResource.id"
                  @click.stop="deleteFromModal(activeResource)"
                >
                  Delete
                </Button>
              </div>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>

    <!-- Delete confirm -->
    <div v-if="showDeleteConfirm" class="fixed inset-0 z-50 flex items-center justify-center bg-stone-900/40 backdrop-blur-sm p-4">
      <div class="w-full max-w-sm rounded-2xl bg-white shadow-2xl border border-stone-100 overflow-hidden">
        <div class="px-6 py-5 border-b border-stone-100 flex items-center justify-between">
          <h2 class="text-base font-bold text-stone-900">Delete resource?</h2>
          <button
            class="w-7 h-7 rounded-full bg-stone-100 flex items-center justify-center text-stone-400 hover:text-stone-600 transition"
            @click="closeDeleteConfirm"
            :disabled="deletingId !== null"
          >
            <X class="w-4 h-4" />
          </button>
        </div>
        <div class="p-6 space-y-3">
          <p class="text-sm text-stone-600">This will permanently delete the resource. This action cannot be undone.</p>
          <div v-if="deleteTarget" class="rounded-lg border border-stone-100 bg-stone-50/50 p-3">
            <div class="text-sm font-semibold text-stone-800 line-clamp-1">{{ deleteTarget.title }}</div>
            <div class="text-xs text-stone-400 mt-0.5">ID: {{ deleteTarget.id }}</div>
          </div>
          <p v-if="deleteError" class="text-sm text-red-500">{{ deleteError }}</p>
        </div>
        <div class="px-6 py-4 border-t border-stone-100 flex justify-end gap-2">
          <Button type="button" variant="outline" size="sm" class="rounded-none h-8 text-xs" @click="closeDeleteConfirm" :disabled="deletingId !== null">Cancel</Button>
          <Button
            type="button"
            size="sm"
            class="rounded-none h-8 text-xs bg-red-500 text-white hover:bg-red-600 border-0"
            @click="confirmDelete"
            :disabled="deletingId !== null"
          >
            {{ deletingId !== null ? 'Deleting…' : 'Delete' }}
          </Button>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, onUnmounted, ref, watch } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import { Search, X } from 'lucide-vue-next'
import { deleteMyResource, listMyResources, type DbResource } from '../api/resource'
import { Button } from '../components/ui/button'
import { formatPlatform } from '../utils/platform'

const router = useRouter()
const route = useRoute()

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
  user_seq?: number | null
}

const resources = ref<UiResource[]>([])
const searchKeyword = ref('')
const loading = ref(false)
const deletingId = ref<number | null>(null)
const publicUpdatingId = ref<number | null>(null)
const clickedDeck = ref<number | null>(null)
const expandAll = ref(true)
const collapsedPreviewCount = 5

const activeResourceId = ref<number | null>(null)
const activeResource = computed(() => {
  if (activeResourceId.value === null) return null
  return resources.value.find(r => r.id === activeResourceId.value) || null
})

const showDeleteConfirm = ref(false)
const deleteTarget = ref<UiResource | null>(null)
const deleteError = ref('')

const fallbackThumb = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&h=400&fit=crop'

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
    user_seq: (r as any).user_seq ?? null,
  }
}

function getWeightCardClass(resource: UiResource) {
  const w = Number(resource.manual_weight)
  if (w >= 5) return 'weight-gold'
  if (w === 4) return 'weight-silver'
  if (w === 3) return 'weight-bronze'
  if (w === 2) return 'weight-iron'
  return ''
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
  loading.value = true
  try {
    const data = await listMyResources()
    resources.value = (data || []).map(mapDbToUi)
  } catch (e: any) {
    resources.value = []
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  expandAll.value = true
  clickedDeck.value = null
  load()
  window.addEventListener('focus', load)
  document.addEventListener('visibilitychange', onVisibilityChange)
})

function onVisibilityChange() {
  if (document.visibilityState === 'visible') load()
}

onUnmounted(() => {
  window.removeEventListener('focus', load)
  document.removeEventListener('visibilitychange', onVisibilityChange)
})

watch(() => route.fullPath, () => {
  expandAll.value = true
  clickedDeck.value = null
  load()
})

const filteredResources = computed(() => {
  const q = searchKeyword.value.trim().toLowerCase()
  return resources.value.filter(r => {
    if (['xiaohongshu', 'xhs'].includes(String(r.platform || '').trim().toLowerCase())) return false
    if (!q) return true
    return (
      r.title.toLowerCase().includes(q) ||
      r.summary.toLowerCase().includes(q) ||
      r.category.toLowerCase().includes(q) ||
      r.platform.toLowerCase().includes(q)
    )
  })
})

type Deck = { key: string; name: string; cards: UiResource[] }

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

const totalCards = computed(() => decks.value.reduce((sum, d) => sum + d.cards.length, 0))

function isDeckExpanded(deckIndex: number) {
  return expandAll.value || clickedDeck.value === deckIndex
}

function toggleDeck(deckIndex: number) {
  clickedDeck.value = clickedDeck.value === deckIndex ? null : deckIndex
}

function getCollapsedPreviewCardStyle(cardIndex: number, total: number) {
  const reverseIndex = total - 1 - cardIndex
  return {
    marginLeft: cardIndex === 0 ? '0' : '-208px',
    zIndex: cardIndex,
    transform: `rotate(${reverseIndex * 0.3}deg)`,
  }
}

function getCategoryColor(category?: string) {
  const key = String(category || '').trim().toLowerCase() || 'other'
  const palette = ['#3b82f6', '#22c55e', '#f59e0b', '#8b5cf6', '#ef4444', '#06b6d4', '#f97316', '#84cc16']
  let hash = 0
  for (let i = 0; i < key.length; i += 1) hash = (hash * 31 + key.charCodeAt(i)) >>> 0
  return palette[hash % palette.length]
}

function openCard(resource: UiResource) { activeResourceId.value = resource.id }
function closeActiveResource() { activeResourceId.value = null }

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
  const name = resource.type === 'video' ? 'my-resource-video' : resource.type === 'document' ? 'my-resource-document' : 'my-resource-article'
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
  if (!deleteTarget.value || deletingId.value !== null) return
  deleteError.value = ''
  deletingId.value = deleteTarget.value.id
  try {
    await deleteMyResource(deleteTarget.value.id)
    resources.value = resources.value.filter(r => r.id !== deleteTarget.value!.id)
    showDeleteConfirm.value = false
    deleteTarget.value = null
  } catch (e: any) {
    deleteError.value = String(e?.response?.data?.detail || e?.message || 'Failed to delete')
  } finally {
    deletingId.value = null
  }
}
</script>

<style scoped>
.modal-enter-active, .modal-leave-active { transition: opacity 250ms ease; }
.modal-enter-from, .modal-leave-to { opacity: 0; }

.weight-gold { border: 2px solid transparent; background: linear-gradient(#fff, #fff) padding-box, linear-gradient(135deg, #FFD700, #FFF8DC, #FFD700) border-box; }
.weight-silver { border: 2px solid transparent; background: linear-gradient(#fff, #fff) padding-box, linear-gradient(135deg, #C0C0C0, #F8F8FF, #C0C0C0) border-box; }
.weight-bronze { border: 2px solid transparent; background: linear-gradient(#fff, #fff) padding-box, linear-gradient(135deg, #CD7F32, #FFE1C2, #CD7F32) border-box; }
.weight-iron { border: 1px solid #e2e8f0; }
</style>
