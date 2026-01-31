<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">CreatePath</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">Search and select resources, then drag or click to add them into your learning path.</p>
        </div>
      </div>
    </section>

      <!-- Main content -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Resources panel -->
        <Card as="section" :hoverable="false" class="rounded-none">
          <div class="p-6 space-y-4">
          <div class="flex items-center justify-between gap-3">
            <div>
              <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">Resources</h2>
              <p class="text-sm text-muted-foreground">{{ filteredResources.length }} results</p>
            </div>
          </div>

          <div class="relative">
            <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
            <Input
              v-model="searchQuery"
              type="search"
              placeholder="Search resources..."
              class="h-10 w-full rounded-none pl-9"
            />
          </div>

          <!-- Create resource from URL/share link -->
          <div class="border border-border bg-background p-4 space-y-3">
            <div>
              <p class="text-foreground font-semibold">Create a resource from a link</p>
              <p class="text-muted-foreground text-xs mt-1">Paste a URL / share link and click Generate. It will be added to the list below.</p>
            </div>
            <div class="flex items-center gap-2">
              <Input
                v-model="newResourceUrl"
                type="url"
                placeholder="https://..."
                class="h-10 flex-1 rounded-none"
              />
              <Button
                type="button"
                variant="outline"
                size="sm"
                class="rounded-none"
                :disabled="!newResourceUrl.trim() || newResourceLoading"
                @click="createResourceFromUrl"
              >
                {{ newResourceLoading ? 'Generating…' : 'Generate' }}
              </Button>
            </div>
            <p v-if="newResourceError" class="text-xs text-red-600">{{ newResourceError }}</p>
          </div>

          <div class="max-h-130 overflow-y-auto pr-1 space-y-3">
            <article
              v-for="r in filteredResources"
              :key="r.id"
              class="border border-gray-200 rounded-none overflow-hidden hover:shadow-md transition bg-white"
              draggable="true"
              @dragstart="handleDragStart($event, r)"
            >
              <div class="flex gap-3 p-3">
                <img :src="r.thumbnail" :alt="r.title" class="w-24 h-16 object-cover rounded-none bg-gray-100 shrink-0" />
                <div class="min-w-0 flex-1">
                  <div class="flex items-start justify-between gap-2">
                    <h3 class="text-gray-900 font-semibold text-sm line-clamp-1" :title="r.title">{{ r.title }}</h3>
                    <span class="px-2 py-1 rounded-none text-xs font-semibold" :class="typeBadge(r.type)">{{ r.type }}</span>
                  </div>
                  <p class="text-gray-600 text-xs mt-1 line-clamp-2">{{ r.summary }}</p>
                  <div class="mt-2 flex flex-wrap gap-2 text-xs text-gray-500">
                    <span v-if="r.platform" class="px-2 py-1 rounded-none bg-gray-100 text-gray-700">{{ formatPlatform(r.platform) }}</span>
                  </div>
                </div>
              </div>
              <div class="border-t border-gray-100 p-3 flex items-center justify-between">
                <span class="text-xs text-gray-400">Drag into the builder on the right</span>
                <button
                  type="button"
                  class="px-3 py-1.5 rounded-none bg-blue-600 text-white text-xs font-semibold hover:bg-blue-700 transition-colors inline-flex items-center gap-2"
                  @click="addResource(r)"
                >
                  <Plus class="w-3.5 h-3.5" />
                  Add
                </button>
              </div>
            </article>
          </div>
          </div>
        </Card>

        <!-- Builder panel -->
        <Card as="section" :hoverable="false" class="rounded-none" @dragover.prevent @drop="onDrop">
          <div class="p-6 space-y-4">
          <div class="flex items-center justify-between gap-3">
            <div class="min-w-0">
              <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">LearningPath Builder</h2>
              <p class="text-sm text-muted-foreground">
                <span class="text-muted-foreground">{{ selected.length }} items</span>
              </p>
            </div>
            <Button
              type="button"
              variant="outline"
              size="sm"
              class="rounded-none"
              @click="clearSelected"
              :disabled="selected.length === 0"
            >
              Clear
            </Button>
          </div>

          <!-- Meta inputs -->
          <div class="rounded-none border border-gray-200 p-4 bg-gray-50 space-y-3">
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">Templates</label>
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <button
                  type="button"
                  class="rounded-none border border-gray-200 bg-white p-3 text-left transition hover:bg-gray-50"
                  :class="selectedTemplate === 'github_trends' ? 'border-blue-600' : ''"
                  @click="applyTemplate('github_trends')"
                >
                  <div class="text-sm font-semibold text-gray-900">GitHub Trends</div>
                  <div class="mt-1 text-xs text-gray-600">A structured path to track trending repos and tech updates</div>
                </button>
                <button
                  type="button"
                  class="rounded-none border border-gray-200 bg-white p-3 text-left transition hover:bg-gray-50"
                  :class="selectedTemplate === 'social_news' ? 'border-blue-600' : ''"
                  @click="applyTemplate('social_news')"
                >
                  <div class="text-sm font-semibold text-gray-900">Social News</div>
                  <div class="mt-1 text-xs text-gray-600">A resource pool for collecting and organizing news by topic</div>
                </button>
              </div>
              <p class="mt-2 text-xs text-gray-500">Click a template to auto-fill the fields below (name, description, type, etc.).</p>
            </div>

            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">Name *</label>
              <input
                v-model="pathMeta.title"
                type="text"
                placeholder="e.g. AI Engineer Starter"
                class="w-full px-4 py-2 border border-gray-300 rounded-none focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
              />
            </div>
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">Description</label>
              <textarea
                v-model="pathMeta.description"
                rows="3"
                placeholder="Briefly describe the goal and content of this learning path"
                class="w-full px-4 py-2 border border-gray-300 rounded-none focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none bg-white"
              />
            </div>

            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">Type</label>
              <select
                v-model="pathMeta.type"
                class="w-full px-4 py-2 border border-gray-300 rounded-none bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="linear path">linear path</option>
                <option value="partical pool">partical pool</option>
                <option value="structured path">structured path</option>
              </select>
            </div>

            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">Cover</label>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div class="rounded-none border border-gray-200 bg-white overflow-hidden">
                  <div class="aspect-video bg-gray-100">
                    <img
                      v-if="pathMeta.coverImageUrl"
                      :src="pathMeta.coverImageUrl"
                      alt="Selected cover"
                      class="w-full h-full object-cover"
                    />
                    <div v-else class="w-full h-full flex items-center justify-center text-sm text-gray-500">
                      No cover selected
                    </div>
                  </div>
                  <div class="p-3">
                    <p class="text-xs text-gray-500">Left: current cover preview</p>
                  </div>
                </div>

                <div class="rounded-none border border-gray-200 bg-white p-3">
                  <div v-if="uploadedCoverUrl" class="space-y-3">
                    <button
                      type="button"
                      class="w-full rounded-none overflow-hidden border-2"
                      :class="pathMeta.coverImageUrl === uploadedCoverUrl ? 'border-blue-600' : 'border-gray-200 hover:border-gray-300'"
                      @click="selectCover(uploadedCoverUrl)"
                    >
                      <div class="aspect-video bg-gray-100">
                        <img :src="uploadedCoverUrl" alt="Uploaded cover" class="w-full h-full object-cover" />
                      </div>
                    </button>
                  </div>

                  <div v-else class="grid grid-cols-4 sm:grid-cols-5 gap-2">
                    <button
                      v-for="(u, idx) in defaultCoverUrls"
                      :key="idx"
                      type="button"
                      class="rounded-none overflow-hidden border-2"
                      :class="pathMeta.coverImageUrl === u ? 'border-blue-600' : 'border-gray-200 hover:border-gray-300'"
                      @click="selectCover(u)"
                    >
                      <div class="aspect-video bg-gray-100">
                        <img :src="u" :alt="`Cover ${idx + 1}`" class="w-full h-full object-cover" />
                      </div>
                    </button>
                  </div>

                  <div class="mt-3 flex items-center justify-between gap-3">
                    <input
                      ref="coverFileInput"
                      type="file"
                      accept="image/*"
                      class="hidden"
                      @change="onCoverFileChange"
                    />
                    <button
                      type="button"
                      class="inline-flex items-center justify-center px-3 py-2 rounded-none bg-gray-100 text-gray-700 hover:bg-gray-200 text-xs font-semibold"
                      @click="openCoverFilePicker"
                    >
                      Upload image
                    </button>
                    <p class="text-xs text-gray-500">After uploading, only the uploaded image will be shown on the right</p>
                  </div>
                </div>
              </div>
            </div>

            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">Category</label>
              <select
                v-model.number="pathMeta.categoryId"
                class="w-full px-4 py-2 border border-gray-300 rounded-none bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50"
                :disabled="categoriesLoading || categories.length === 0"
              >
                <option :value="null">Not selected</option>
                <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
              </select>
              <p v-if="categoriesError" class="text-xs text-red-600 mt-2">{{ categoriesError }}</p>
              <p v-else class="text-xs text-gray-500 mt-2">Categories are loaded from the database (optional).</p>
            </div>

            <div class="flex items-center justify-between gap-3">
              <div class="min-w-0">
                <div class="text-sm font-semibold text-gray-700">Visibility</div>
                <div class="text-xs text-gray-500">Public: appears in LearningPool. Private: only visible to you.</div>
              </div>
              <button
                type="button"
                class="inline-flex items-center gap-2 rounded-none bg-gray-100 px-3 py-2 text-xs font-semibold text-gray-700 hover:bg-gray-200"
                @click="pathMeta.isPublic = !pathMeta.isPublic"
              >
                <span>{{ pathMeta.isPublic ? 'Public' : 'Private' }}</span>
                <span
                  class="relative h-5 w-9 rounded-none transition-colors"
                  :class="pathMeta.isPublic ? 'bg-blue-600' : 'bg-gray-300'"
                >
                  <span
                    class="absolute left-0.5 top-0.5 h-4 w-4 rounded-none bg-white transition-transform"
                    :class="pathMeta.isPublic ? 'translate-x-0' : 'translate-x-4'"
                  />
                </span>
              </button>
            </div>
          </div>

          <div
            class="rounded-none border-2 border-dashed p-4"
            :class="selected.length ? 'border-gray-200 bg-gray-50' : 'border-blue-200 bg-blue-50'"
          >
            <div v-if="selected.length === 0" class="text-sm text-gray-600">
              Drag resources here, or click “Add”.
            </div>

            <div v-else class="space-y-2">
              <div v-for="(r, idx) in selected" :key="r.id" class="space-y-2">
                <article
                  :class="[
                    'rounded-none border p-3 flex gap-3 transition',
                    selectedDragState.draggingId === r.id
                      ? 'bg-pink-50/60 backdrop-blur-md border-pink-200/60'
                      : 'bg-white border-gray-200',
                  ]"
                  draggable="true"
                  @dragstart="onSelectedDragStart($event, r.id, idx)"
                  @dragend="onSelectedDragEnd"
                  @dragover.prevent="onSelectedDragOver(idx)"
                  @drop.prevent="onSelectedDrop($event, idx)"
                >
                  <div class="w-8 h-8 rounded-none bg-gray-100 text-gray-700 flex items-center justify-center text-xs font-semibold shrink-0">
                    {{ idx + 1 }}
                  </div>
                  <img :src="r.thumbnail" :alt="r.title" class="w-24 h-16 object-cover rounded-none bg-gray-100 shrink-0" />
                  <div class="min-w-0 flex-1">
                    <div class="flex items-start justify-between gap-2">
                      <h3 class="text-gray-900 font-semibold text-sm line-clamp-1">{{ r.title }}</h3>
                      <button type="button" class="text-gray-400 hover:text-gray-700" @click="removeResource(r.id)" aria-label="Remove">
                        <X class="w-4 h-4" />
                      </button>
                    </div>
                    <p class="text-gray-600 text-xs mt-1 line-clamp-2">{{ r.summary }}</p>
                    <div class="mt-2 flex flex-wrap gap-2 text-xs text-gray-500">
                      <span v-if="r.platform" class="px-2 py-1 rounded-none bg-gray-100 text-gray-700">{{ r.platform }}</span>
                      <span class="px-2 py-1 rounded-none text-xs font-semibold" :class="typeBadge(r.type)">{{ r.type }}</span>
                    </div>
                  </div>
                </article>

                <div
                  v-if="idx !== selected.length - 1"
                  class="flex justify-center text-gray-300"
                  @dragover.prevent
                  @drop.prevent="onSelectedDrop($event, idx + 1)"
                >
                  <ChevronDown class="w-5 h-5" />
                </div>
              </div>
            </div>
          </div>

          <div class="pt-2">
            <Button
              type="button"
              variant="outline"
              size="lg"
              class="w-full rounded-none border-border bg-[#8ecbff] text-white transition-all hover:-translate-y-px hover:bg-[#8ecbff]/90 hover:text-white hover:shadow-sm active:translate-y-0"
              :disabled="!pathMeta.title.trim() || selected.length === 0"
              @click="createLearningPath"
            >
              Create Learning Path
            </Button>
          </div>
          </div>
        </Card>
      </div>
    </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ChevronDown, Plus, Search, X } from 'lucide-vue-next'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import Card from '../components/ui/Card.vue'
import { createMyResourceFromUrl, listMyResources, type DbResource } from '../api/resource'
import { addResourceToMyLearningPath, createLearningPathWithCategory } from '../api/learningPath'
import { listCategories, type Category } from '../api/category'
import { formatPlatform } from '../utils/platform'

type PathMeta = {
  title: string
  description: string
  type: string
  isPublic: boolean
  categoryId: number | null
  coverImageUrl: string
}

type ResourceType = 'video' | 'document' | 'article' | 'clip' | 'link'

type UiResource = {
  id: number
  title: string
  summary: string
  source_url: string | null
  type: ResourceType
  platform: string
  thumbnail: string
}

const router = useRouter()

const allResources = ref<UiResource[]>([])
const searchQuery = ref('')

const newResourceUrl = ref('')
const newResourceError = ref('')
const newResourceLoading = ref(false)

const filteredResources = computed(() => {
  const q = searchQuery.value.trim().toLowerCase()
  if (!q) return allResources.value
  return allResources.value.filter(r => r.title.toLowerCase().includes(q) || r.summary.toLowerCase().includes(q))
})

const selected = ref<UiResource[]>([])

const selectedDragState = reactive({
  draggingId: -1 as number,
  fromIndex: -1 as number,
  overIndex: -1 as number,
})

const pathMeta = reactive<PathMeta>({ title: '', description: '', type: 'linear path', isPublic: true, categoryId: null, coverImageUrl: '' })

type TemplateId = 'github_trends' | 'social_news'
const selectedTemplate = ref<TemplateId | ''>('')

function applyTemplate(id: TemplateId) {
  selectedTemplate.value = id

  if (id === 'github_trends') {
    pathMeta.title = 'GitHub Trends Weekly'
    pathMeta.description = 'Track GitHub Trending weekly: shortlist repos, read READMEs, capture key ideas, and turn them into an actionable learning path.'
    pathMeta.type = 'structured path'
    pathMeta.isPublic = true
    return
  }

  pathMeta.title = 'Social News Digest'
  pathMeta.description = 'Collect tech news, articles, and podcasts you care about: organize by topic, review regularly, and refine over time.'
  pathMeta.type = 'partical pool'
  pathMeta.isPublic = true
}

const coverFileInput = ref<HTMLInputElement | null>(null)
const uploadedCoverUrl = ref<string>('')

function makeCoverSvg(seed: number) {
  // Small deterministic SVG: keep palette aligned to existing blue/indigo background.
  const w = 640
  const h = 360
  const a = (seed * 37) % 100
  const b = (seed * 61) % 100
  const c = (seed * 83) % 100
  const svg = `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="${w}" height="${h}" viewBox="0 0 ${w} ${h}">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#eff6ff"/>
      <stop offset="1" stop-color="#e0e7ff"/>
    </linearGradient>
    <linearGradient id="fg" x1="1" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="#60a5fa" stop-opacity="0.45"/>
      <stop offset="1" stop-color="#818cf8" stop-opacity="0.35"/>
    </linearGradient>
  </defs>
  <rect width="${w}" height="${h}" fill="url(#bg)"/>
  <circle cx="${(a / 100) * w}" cy="${(b / 100) * h}" r="${70 + (c % 40)}" fill="url(#fg)"/>
  <circle cx="${w - (b / 100) * w}" cy="${(c / 100) * h}" r="${40 + (a % 30)}" fill="url(#fg)" opacity="0.8"/>
  <path d="M -40 ${h * 0.75} C ${w * 0.2} ${h * (0.55 + (a % 15) / 100)} , ${w * 0.55} ${h * (0.95 - (b % 20) / 100)} , ${w + 40} ${h * 0.7}" fill="none" stroke="#1f2937" stroke-opacity="0.08" stroke-width="14" stroke-linecap="round"/>
  <path d="M -40 ${h * 0.2} C ${w * 0.3} ${h * (0.3 + (b % 15) / 100)} , ${w * 0.6} ${h * (0.05 + (c % 25) / 100)} , ${w + 40} ${h * 0.25}" fill="none" stroke="#1f2937" stroke-opacity="0.06" stroke-width="10" stroke-linecap="round"/>
</svg>`
  return `data:image/svg+xml;charset=UTF-8,${encodeURIComponent(svg)}`
}

const defaultCoverUrls = Array.from({ length: 20 }, (_, i) => makeCoverSvg(i + 1))

function selectCover(url: string) {
  pathMeta.coverImageUrl = String(url || '').trim()
}

function openCoverFilePicker() {
  coverFileInput.value?.click()
}

function onCoverFileChange(e: Event) {
  const input = e.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return

  const reader = new FileReader()
  reader.onload = () => {
    const url = String(reader.result || '').trim()
    if (!url) return
    uploadedCoverUrl.value = url
    selectCover(url)
  }
  reader.readAsDataURL(file)
}

const categories = ref<Category[]>([])
const categoriesLoading = ref(false)
const categoriesError = ref('')

async function loadCategories() {
  categoriesLoading.value = true
  categoriesError.value = ''
  try {
    const res = await listCategories()
    categories.value = res ?? []
    if (pathMeta.categoryId == null) {
      const other = categories.value.find(c => String(c.code).toLowerCase() === 'other')
      if (other) pathMeta.categoryId = other.id
    }
  } catch (e: any) {
    categories.value = []
    categoriesError.value = e?.message || 'Failed to load categories'
  } finally {
    categoriesLoading.value = false
  }
}

onMounted(() => {
  loadCategories()
  void loadResources()
  if (!pathMeta.coverImageUrl) selectCover(defaultCoverUrls[0] || '')
})

function typeBadge(type: UiResource['type']) {
  switch (type) {
    case 'video':
      return 'bg-purple-50 text-purple-700'
    case 'document':
      return 'bg-blue-50 text-blue-700'
    case 'article':
      return 'bg-green-50 text-green-700'
    case 'clip':
      return 'bg-gray-100 text-gray-700'
    case 'link':
      return 'bg-gray-100 text-gray-700'
  }
}

function normalizePresentedType(raw: unknown): ResourceType {
  const t = String(raw || '').trim().toLowerCase()
  if (t === 'video') return 'video'
  if (t === 'document') return 'document'
  if (t === 'article') return 'article'
  if (t === 'clip') return 'clip'
  if (t === 'link') return 'link'
  return 'article'
}

function toUiResource(r: DbResource): UiResource {
  return {
    id: Number(r.id),
    title: String(r.title || '').trim() || `Resource ${r.id}`,
    summary: String((r as any).summary || '').trim(),
    source_url: ((r as any).source_url ?? null) as any,
    type: normalizePresentedType((r as any).resource_type),
    platform: String((r as any).platform || '').trim(),
    thumbnail: String((r as any).thumbnail || '').trim(),
  }
}

async function loadResources() {
  try {
    const rows = await listMyResources()
    allResources.value = Array.isArray(rows) ? rows.map(toUiResource) : []
  } catch {
    allResources.value = []
  }
}

async function createResourceFromUrl() {
  newResourceError.value = ''
  const raw = newResourceUrl.value.trim()
  if (!raw) return

  let parsed: URL
  try {
    parsed = new URL(raw)
  } catch {
    newResourceError.value = 'Invalid link format. Please enter a full http(s) URL.'
    return
  }

  if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') {
    newResourceError.value = 'Only http(s) links are supported.'
    return
  }

  const exists = allResources.value.some(r => (r.source_url || '') === parsed.toString())
  if (exists) {
    newResourceError.value = 'This link already exists in your resource list.'
    return
  }

  newResourceLoading.value = true
  try {
    if (pathMeta.categoryId == null) {
      throw new Error('Please select a category.')
    }
    await createMyResourceFromUrl(parsed.toString(), { category_id: pathMeta.categoryId })
    newResourceUrl.value = ''
    await loadResources()
  } catch (e: any) {
    newResourceError.value = String(e?.response?.data?.detail || e?.message || 'Failed to generate resource')
  } finally {
    newResourceLoading.value = false
  }
}

function addResource(resource: UiResource) {
  if (selected.value.some(r => r.id === resource.id)) return
  selected.value = [...selected.value, resource]

  // Rule: cover uses the first resource thumbnail.
  const firstThumb = String(selected.value[0]?.thumbnail || '').trim()
  if (firstThumb) selectCover(firstThumb)
}

function removeResource(id: number) {
  selected.value = selected.value.filter(r => r.id !== id)

  // Rule: cover uses the first resource thumbnail.
  const firstThumb = String(selected.value[0]?.thumbnail || '').trim()
  if (firstThumb) selectCover(firstThumb)
}

function clearSelected() {
  selected.value = []
}

function onDrop(e: DragEvent) {
  // 1) Reorder inside builder: drop to empty area -> move to end
  const reorderId = e.dataTransfer?.getData('application/x-selected-resource-id') || ''
  const reorderFromStr = e.dataTransfer?.getData('application/x-selected-resource-from') || ''
  if (reorderId && reorderFromStr) {
    const fromIndex = Number(reorderFromStr)
    if (Number.isFinite(fromIndex)) {
      moveSelected(fromIndex, selected.value.length - 1)
    }
    return
  }

  // 2) Add from resources panel
  const resourceId = e.dataTransfer?.getData('text/plain') || ''
  const n = Number(resourceId)
  const hit = Number.isFinite(n) ? allResources.value.find(r => r.id === n) : undefined
  if (hit) addResource(hit)
}

function handleDragStart(e: DragEvent, resource: UiResource) {
  e.dataTransfer?.setData('text/plain', String(resource.id))
  e.dataTransfer!.effectAllowed = 'copy'
}

function moveSelected(fromIndex: number, toIndex: number) {
  if (fromIndex === toIndex) return
  if (fromIndex < 0 || fromIndex >= selected.value.length) return
  if (toIndex < 0) toIndex = 0
  if (toIndex >= selected.value.length) toIndex = selected.value.length - 1

  const next = [...selected.value]
  const [item] = next.splice(fromIndex, 1)
  next.splice(toIndex, 0, item)
  selected.value = next
}

function onSelectedDragStart(e: DragEvent, id: number, idx: number) {
  selectedDragState.draggingId = id
  selectedDragState.fromIndex = idx
  selectedDragState.overIndex = idx

  e.dataTransfer?.setData('application/x-selected-resource-id', String(id))
  e.dataTransfer?.setData('application/x-selected-resource-from', String(idx))
  if (e.dataTransfer) e.dataTransfer.effectAllowed = 'move'
}

function onSelectedDragOver(idx: number) {
  selectedDragState.overIndex = idx
}

function onSelectedDrop(e: DragEvent, dropIndex: number) {
  const fromStr = e.dataTransfer?.getData('application/x-selected-resource-from') || ''
  if (!fromStr) return
  const fromIndex = Number(fromStr)
  if (!Number.isFinite(fromIndex)) return

  // If dragging downwards, dropping “on” an item should insert at its position.
  moveSelected(fromIndex, dropIndex)
}

function onSelectedDragEnd() {
  selectedDragState.draggingId = -1
  selectedDragState.fromIndex = -1
  selectedDragState.overIndex = -1
}

async function createLearningPath() {
  if (!pathMeta.title.trim()) return
  if (selected.value.length === 0) return
  if (pathMeta.categoryId == null) {
    alert('Please select a category.')
    return
  }

  // Rule: cover_image_url always uses the first resource thumbnail.
  const coverUrl = String(selected.value[0]?.thumbnail || '').trim() || null
  if (coverUrl) selectCover(coverUrl)

  try {
    const createdDb = await createLearningPathWithCategory({
      title: pathMeta.title,
      type: pathMeta.type,
      description: pathMeta.description,
      is_public: pathMeta.isPublic,
      cover_image_url: coverUrl,
      category_id: pathMeta.categoryId,
    })

    const lpId = Number((createdDb as any)?.id)
    if (!Number.isFinite(lpId) || lpId <= 0) throw new Error('Create failed: invalid learning path id')

    for (let i = 0; i < selected.value.length; i++) {
      const r = selected.value[i]
      await addResourceToMyLearningPath(lpId, {
        resource_id: r.id,
        order_index: i + 1,
        is_optional: false,
      })
    }

    router.push({ name: 'learningpath', params: { id: String(lpId) }, query: { from: 'my-paths' } })
  } catch (e: any) {
    alert(String(e?.response?.data?.detail || e?.message || 'Create failed'))
    return
  }

  pathMeta.title = ''
  pathMeta.description = ''
  pathMeta.type = 'linear path'
  pathMeta.isPublic = true
  pathMeta.categoryId = null
  pathMeta.coverImageUrl = defaultCoverUrls[0] || ''
  uploadedCoverUrl.value = ''
  selected.value = []
  searchQuery.value = ''
}
</script>
