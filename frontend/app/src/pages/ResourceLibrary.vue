<template>
  <div class="min-h-screen bg-stone-50">

    <!-- Masthead header -->
    <header class="border-b border-stone-200 bg-white">
      <div class="mx-auto max-w-7xl px-4 py-6 md:py-8">
        <div class="flex items-end justify-between gap-6">
          <div>
            <div class="flex items-center gap-2 mb-3">
              <span class="h-px w-8 bg-amber-500"></span>
              <span class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">Discover</span>
            </div>
            <h1 class="text-3xl md:text-4xl font-black tracking-tight text-stone-900 leading-[0.92]">
              Resource<br/><span class="text-amber-600">Library.</span>
            </h1>
          </div>
          <p class="hidden md:block text-sm leading-relaxed text-stone-500 max-w-xs">
            Browse and discover public resources. Add them to your personal library with one click.
          </p>
        </div>

        <!-- Filter bar -->
        <div class="mt-6 flex flex-col sm:flex-row gap-3">
          <!-- Search -->
          <div class="relative flex-1">
            <Search class="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-stone-400" />
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search resources, topics..."
              class="h-10 w-full rounded-none border border-stone-200 bg-white pl-10 pr-4 text-sm text-stone-900 placeholder:text-stone-400 outline-none focus:border-amber-400 focus:ring-1 focus:ring-amber-100 transition-colors"
            />
          </div>

          <!-- Category filter -->
          <div class="relative">
            <select
              v-model="selectedCategory"
              class="appearance-none h-10 rounded-none border border-stone-200 bg-white pl-4 pr-10 text-sm text-stone-700 outline-none focus:border-amber-400 focus:ring-1 focus:ring-amber-100 transition-colors cursor-pointer"
            >
              <option v-for="cat in categories" :key="cat" :value="cat">{{ cat }}</option>
            </select>
            <ChevronDown class="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-stone-400 pointer-events-none" />
          </div>
        </div>

        <!-- Type pills -->
        <div class="mt-4 flex gap-2 flex-wrap">
          <button
            v-for="t in typeFilters"
            :key="t.value"
            type="button"
            class="h-7 rounded-full border px-3 text-[11px] font-semibold uppercase tracking-wider transition-all"
            :class="activeType === t.value
              ? 'border-stone-900 bg-stone-900 text-white'
              : 'border-stone-200 bg-white text-stone-500 hover:border-stone-400'"
            @click="activeType = t.value"
          >
            {{ t.label }}
          </button>
        </div>
      </div>
    </header>

    <!-- Spacer placeholder -->
    <div class="h-4 bg-stone-100"></div>

    <!-- Main content -->
    <main class="mx-auto max-w-7xl px-4 py-8 bg-stone-50">

      <!-- Loading -->
      <div v-if="loading" class="py-20 text-center">
        <div class="inline-flex items-center gap-3">
          <div class="h-2 w-2 rounded-full bg-amber-500 animate-pulse"></div>
          <span class="text-sm text-stone-400">Loading resources…</span>
        </div>
      </div>

      <!-- Empty state -->
      <div v-else-if="filteredResources.length === 0" class="py-20 text-center">
        <div class="text-5xl mb-4">📭</div>
        <h3 class="text-base font-semibold text-stone-700 mb-1">No resources found</h3>
        <p class="text-sm text-stone-400">{{ searchQuery || selectedCategory !== 'All' ? 'Try adjusting your filters.' : 'Nothing public yet.' }}</p>
      </div>

      <!-- Resource grid: asymmetric editorial layout -->
      <div v-else>
        <!-- Results count -->
        <div class="mb-6 flex items-center justify-between">
          <p class="text-xs text-stone-400">
            <span class="font-semibold text-stone-600">{{ filteredResources.length }}</span> resources
          </p>
          <button
            class="text-[11px] font-semibold uppercase tracking-wider text-stone-400 hover:text-stone-600 transition-colors"
            @click="searchQuery = ''; selectedCategory = 'All'"
          >
            Clear filters
          </button>
        </div>

        <!-- Editorial grid: alternating large/small cards -->
        <div class="grid grid-cols-5 gap-4">
          <template v-for="(resource, idx) in filteredResources" :key="resource.id">
            <!-- Hero card: every 7th item spans full width -->
            <div
              v-if="idx % 7 === 0 && idx > 0"
              class="col-span-5"
            >
              <article
                class="group relative flex gap-0 rounded-xl overflow-hidden bg-white border border-stone-100 hover:border-stone-200 hover:shadow-lg transition-all duration-300 cursor-pointer"
                @click="openCard(resource)"
              >
                <div class="w-64 h-44 shrink-0 bg-stone-100 overflow-hidden relative transition-transform duration-500 group-hover:scale-105" style="width: 256px; height: 176px; flex-shrink: 0;">
                  <img
                    :src="resource.thumbnail || fallbackThumb"
                    :alt="resource.title"
                    loading="lazy"
                    class="block w-full h-full object-cover object-center"
                    style="width: 100%; height: 100%; object-fit: cover; object-position: center;"
                  />
                </div>
                <div class="flex-1 p-6 flex flex-col justify-between">
                  <div>
                    <div class="flex items-center gap-2 mb-2">
                      <span
                        class="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded"
                        :style="{ backgroundColor: getCategoryColor(resourceCategoryLabel(resource)) + '18', color: getCategoryColor(resourceCategoryLabel(resource)) }"
                      >
                        {{ resourceCategoryLabel(resource) }}
                      </span>
                      <span class="text-[10px] text-stone-400">#{{ String(resource.id).padStart(3, '0') }}</span>
                    </div>
                    <h3 class="text-lg font-bold text-stone-900 leading-snug group-hover:text-amber-700 transition-colors">
                      {{ resource.title }}
                    </h3>
                    <p class="text-sm text-stone-500 mt-2 line-clamp-2">{{ resource.summary || '' }}</p>
                  </div>
                  <div class="flex items-center justify-between mt-4">
                    <span class="text-xs text-stone-400">{{ formatPlatform((resource as any).platform) }} · {{ displayResourceType(resource) }}</span>
                    <button
                      class="text-[11px] font-semibold uppercase tracking-wider text-stone-400 hover:text-amber-600 transition-colors"
                      @click.stop="addToMyResources(resource)"
                    >
                      + Add to my resources
                    </button>
                  </div>
                </div>
              </article>
            </div>

            <!-- Standard cards: 5 per row -->
            <div v-else class="col-span-1 group">
              <article
                class="h-full rounded-xl overflow-hidden bg-white border border-stone-100 hover:border-stone-200 hover:shadow-md transition-all duration-200 cursor-pointer flex flex-col"
                @click="openCard(resource)"
              >
                <!-- Thumbnail -->
                <div class="relative bg-stone-100 overflow-hidden transition-transform duration-500 group-hover:scale-105" style="aspect-ratio: 16/9; width: 100%;">
                  <img
                    :src="resource.thumbnail || fallbackThumb"
                    :alt="resource.title"
                    loading="lazy"
                    class="block w-full h-full object-cover object-center"
                    style="width: 100%; height: 100%; object-fit: cover; object-position: center;"
                  />
                  <!-- Type badge -->
                  <div class="absolute top-2 left-2">
                    <span class="inline-flex items-center rounded-full bg-white/90 backdrop-blur-sm border border-white/20 px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider text-stone-600">
                      {{ displayResourceType(resource) }}
                    </span>
                  </div>
                </div>

                <!-- Content -->
                <div class="flex-1 p-3.5 flex flex-col">
                  <span
                    class="text-[10px] font-semibold uppercase tracking-wider mb-1.5"
                    :style="{ color: getCategoryColor(resourceCategoryLabel(resource)) }"
                  >
                    {{ resourceCategoryLabel(resource) }}
                  </span>
                  <h3 class="text-sm font-semibold text-stone-800 leading-snug line-clamp-2 group-hover:text-amber-700 transition-colors" :title="resource.title">
                    {{ resource.title }}
                  </h3>
                  <p class="text-xs text-stone-400 mt-1 line-clamp-2 flex-1">{{ resource.summary || '' }}</p>
                  <div class="flex items-center justify-between mt-3 pt-2 border-t border-stone-50">
                    <span class="text-[10px] text-stone-400">{{ formatPlatform((resource as any).platform) }}</span>
                    <button
                      v-if="!addedToMy[resource.id]"
                      class="text-[10px] font-semibold text-stone-400 hover:text-amber-600 transition-colors"
                      @click.stop="addToMyResources(resource)"
                    >
                      + Save
                    </button>
                    <span v-else class="text-[10px] font-semibold text-emerald-500">Saved</span>
                  </div>
                </div>
              </article>
            </div>
          </template>
        </div>
      </div>
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
          <div class="relative w-full max-w-lg rounded-2xl overflow-hidden bg-white shadow-2xl border border-stone-100">
            <!-- Image header -->
            <div class="relative bg-stone-100 overflow-hidden" style="aspect-ratio: 16/9; width: 100%;">
              <img
                :src="activeResource.thumbnail || fallbackThumb"
                :alt="activeResource.title"
                class="block w-full h-full object-cover object-center"
                style="width: 100%; height: 100%; object-fit: cover; object-position: center;"
              />
              <button
                class="absolute top-3 right-3 w-8 h-8 rounded-full bg-white/90 backdrop-blur-sm flex items-center justify-center text-stone-500 hover:text-stone-900 hover:bg-white transition"
                @click="closeActiveResource"
                aria-label="Close"
              >
                <X class="w-4 h-4" />
              </button>
              <!-- Category badge -->
              <div class="absolute bottom-3 left-3">
                <span
                  class="text-[10px] font-bold uppercase tracking-wider px-2.5 py-1 rounded-full"
                  :style="{ backgroundColor: getCategoryColor(resourceCategoryLabel(activeResource)) + '18', color: getCategoryColor(resourceCategoryLabel(activeResource)) }"
                >
                  {{ resourceCategoryLabel(activeResource) }}
                </span>
              </div>
            </div>

            <!-- Content -->
            <div class="p-6">
              <div class="flex items-start justify-between gap-3 mb-3">
                <div>
                  <span class="text-[10px] text-stone-400">#{{ String(activeResource.id).padStart(3, '0') }}</span>
                  <h2 class="text-xl font-bold text-stone-900 leading-tight mt-1">{{ activeResource.title }}</h2>
                </div>
              </div>
              <p class="text-sm leading-relaxed text-stone-600">{{ activeResource.summary || 'No description available.' }}</p>

              <div class="flex items-center gap-4 mt-4 text-xs text-stone-400">
                <span>{{ formatPlatform((activeResource as any).platform) }}</span>
                <span class="text-stone-200">·</span>
                <span class="font-medium text-stone-600 uppercase text-[10px] tracking-wider">{{ displayResourceType(activeResource) }}</span>
              </div>
            </div>

            <!-- Actions -->
            <div class="px-6 pb-6 flex flex-col gap-2">
              <Button
                type="button"
                class="w-full rounded-full bg-stone-900 text-white hover:bg-stone-800 font-semibold text-sm transition-all hover:-translate-y-px"
                @click="seeDetail(activeResource)"
              >
                View details
              </Button>
              <Button
                type="button"
                :disabled="addingToMy[activeResource.id] || addedToMy[activeResource.id]"
                class="w-full rounded-full border border-stone-200 text-stone-600 hover:border-stone-900 hover:text-stone-900 font-semibold text-sm transition-all"
                @click="addToMyResources(activeResource)"
              >
                {{ addedToMy[activeResource.id] ? 'Already saved' : (addingToMy[activeResource.id] ? 'Saving…' : '+ Save to my resources') }}
              </Button>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>

    <!-- Add result toast -->
    <Teleport to="body">
      <Transition name="toast">
        <div
          v-if="showAddResultModal"
          class="fixed bottom-6 left-1/2 -translate-x-1/2 z-100 rounded-full bg-stone-900 text-white px-6 py-3 shadow-2xl flex items-center gap-3"
        >
          <div v-if="addResultTitle.includes('Success') || addResultTitle.includes('成功')" class="h-5 w-5 rounded-full bg-emerald-500 flex items-center justify-center">
            <svg xmlns="http://www.w3.org/2000/svg" width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
          </div>
          <span class="text-sm font-semibold">{{ addResultMessage }}</span>
          <button class="text-stone-400 hover:text-white transition-colors ml-1" @click="closeAddResultModal">
            <X class="w-4 h-4" />
          </button>
        </div>
      </Transition>
    </Teleport>

  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { ChevronDown, Search, X } from 'lucide-vue-next'
import { Button } from '../components/ui/button'
import { formatPlatform } from '../utils/platform'
import {
  addPublicResourceToMyResourcesWithStatusAndWeight,
  createMyResourceFromUrl,
  listMyResources,
  listResources,
  type DbResource,
} from '../api/resource'
import { listCategories, type Category } from '../api/category'

const dbCategories = ref<Category[]>([])
const categories = computed(() => ['All', ...dbCategories.value.map(c => c.name)])
const fallbackThumb = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&h=400&fit=crop'

const resources = ref<DbResource[]>([])
const loading = ref(false)
const selectedCategory = ref<string>('All')
const searchQuery = ref('')
const activeType = ref('all')

const typeFilters = [
  { label: 'All', value: 'all' },
  { label: 'Video', value: 'video' },
  { label: 'Article', value: 'article' },
  { label: 'Document', value: 'document' },
]

const cardMetaById = ref<Record<number, any>>({})
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

function openAddResultModal(title: string, message: string) {
  addResultTitle.value = title
  addResultMessage.value = message
  showAddResultModal.value = true
  setTimeout(() => { showAddResultModal.value = false }, 3000)
}

function closeAddResultModal() {
  showAddResultModal.value = false
}

function resourceCategoryLabel(resource: DbResource) {
  return String((resource as any).category_name || '').trim() || 'Other'
}

function normalizeResourceType(t: string) {
  return String(t || '').trim().toLowerCase()
}

function displayResourceType(resource: DbResource) {
  const raw = normalizeResourceType(resource.resource_type)
  if (raw === 'video' || raw === 'document' || raw === 'article') return raw
  return 'article'
}

function getCategoryColor(category?: string) {
  const key = String(category || '').trim().toLowerCase() || 'other'
  const palette = ['#3b82f6', '#22c55e', '#f59e0b', '#8b5cf6', '#ef4444', '#06b6d4', '#f97316', '#84cc16']
  let hash = 0
  for (let i = 0; i < key.length; i += 1) hash = (hash * 31 + key.charCodeAt(i)) >>> 0
  return palette[hash % palette.length]
}

const filteredResources = computed(() => {
  return resources.value.filter(r => {
    const platform = String((r as any)?.platform || '').trim().toLowerCase()
    if (platform === 'xiaohongshu' || platform === 'xhs' || platform.includes('小红书')) return false
    if (platform === 'reddit') return false
    const cat = resourceCategoryLabel(r)
    if (selectedCategory.value !== 'All' && cat !== selectedCategory.value) return false
    const type = normalizeResourceType(r.resource_type)
    if (activeType.value !== 'all' && type !== activeType.value) return false
    const q = searchQuery.value.trim().toLowerCase()
    if (!q) return true
    const title = (r.title || '').toLowerCase()
    const desc = (r.summary || '').toLowerCase()
    return title.includes(q) || desc.includes(q)
  })
})

async function loadResources() {
  loading.value = true
  try {
    resources.value = await listResources()
    void syncAddedFlags()
  } finally {
    loading.value = false
  }
}

async function loadCategories() {
  try {
    dbCategories.value = await listCategories()
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
  } catch { /* ignore */ }
}

function openCard(resource: DbResource) {
  activeResourceId.value = resource.id
}

function closeActiveResource() {
  activeResourceId.value = null
}

function seeDetail(resource: DbResource) {
  closeActiveResource()
  const t = displayResourceType(resource)
  const name = t === 'video' ? 'resource-video' : t === 'document' ? 'resource-document' : 'resource-article'
  // Use router push if available, else open in new tab
  window.location.href = `/resources/${t}/${resource.id}`
}

async function addToMyResources(resource: DbResource) {
  if (!resource?.id) return
  if (addingToMy.value[resource.id] || addedToMy.value[resource.id]) return
  addingToMy.value = { ...addingToMy.value, [resource.id]: true }
  try {
    const res = await addPublicResourceToMyResourcesWithStatusAndWeight(resource.id, { manual_weight: 1 })
    addedToMy.value = { ...addedToMy.value, [resource.id]: true }
    if (res?.already_exists) {
      openAddResultModal('Already Saved', 'This resource is already in your My Resources.')
    } else {
      openAddResultModal('Saved!', 'Resource added to My Resources.')
    }
  } catch (e: any) {
    const msg = e?.response?.data?.detail || e?.message || 'Failed to save'
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
.modal-enter-active,
.modal-leave-active {
  transition: opacity 300ms ease;
}
.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}
.modal-enter-active .relative,
.modal-leave-active .relative {
  transition: transform 300ms ease, opacity 300ms ease;
}
.modal-enter-from .relative,
.modal-leave-to .relative {
  transform: translateY(16px);
  opacity: 0;
}

.toast-enter-active,
.toast-leave-active {
  transition: opacity 300ms ease, transform 300ms ease;
}
.toast-enter-from,
.toast-leave-to {
  opacity: 0;
  transform: translate(-50%, 12px);
}
</style>
