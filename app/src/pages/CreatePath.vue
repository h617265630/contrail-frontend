<template>
  <div class="min-h-screen bg-stone-50">

    <!-- Masthead -->
    <header class="border-b-2 border-stone-900 bg-white">
      <div class="mx-auto max-w-7xl px-4 py-6 md:py-8">
        <div class="flex items-end justify-between">
          <div>
            <div class="flex items-center gap-2 mb-3">
              <span class="h-px w-8 bg-sky-500"></span>
              <span class="text-[10px] font-bold uppercase tracking-[0.25em] text-stone-400">Create</span>
            </div>
            <h1 class="text-4xl md:text-5xl font-black tracking-tight text-stone-900 leading-[0.9]">
              Build a<br/><span class="text-sky-600">Learning Path.</span>
            </h1>
          </div>
          <div class="hidden md:flex flex-col items-end gap-1">
            <span class="text-[10px] font-semibold uppercase tracking-widest text-stone-400">Step 1 · 2 · 3</span>
          </div>
        </div>
      </div>
    </header>

    <main class="mx-auto max-w-7xl px-4 py-8">

      <!-- Top meta panel -->
      <section class="bg-white rounded-md border border-stone-100 p-6 mb-6">
        <div class="flex items-center gap-3 mb-6">
          <div class="w-1 h-6 bg-sky-600 rounded-full"></div>
          <h2 class="text-sm font-bold uppercase tracking-widest text-stone-700">Path Details</h2>
        </div>

        <div class="grid grid-cols-12 gap-6">
          <!-- Left: inputs -->
          <div class="col-span-12 lg:col-span-7 space-y-5">

            <!-- Templates -->
            <div>
              <label class="block text-[11px] font-bold uppercase tracking-widest text-stone-400 mb-2">Templates</label>
              <div class="grid grid-cols-2 gap-2">
                <button
                  type="button"
                  class="rounded-sm border p-3.5 text-left transition-all"
                  :class="selectedTemplate === 'github_trends'
                    ? 'border-sky-500 bg-sky-50 ring-1 ring-sky-500'
                    : 'border-stone-200 bg-white hover:border-stone-300 hover:bg-stone-50'"
                  @click="applyTemplate('github_trends')"
                >
                  <p class="text-xs font-bold text-stone-800">GitHub Trends</p>
                  <p class="text-[10px] text-stone-500 mt-0.5 leading-relaxed">Track trending repos and tech updates in a structured path</p>
                </button>
                <button
                  type="button"
                  class="rounded-sm border p-3.5 text-left transition-all"
                  :class="selectedTemplate === 'social_news'
                    ? 'border-sky-500 bg-sky-50 ring-1 ring-sky-500'
                    : 'border-stone-200 bg-white hover:border-stone-300 hover:bg-stone-50'"
                  @click="applyTemplate('social_news')"
                >
                  <p class="text-xs font-bold text-stone-800">Social News</p>
                  <p class="text-[10px] text-stone-500 mt-0.5 leading-relaxed">Collect articles and organize news by topic into a pool</p>
                </button>
              </div>
              <p class="mt-1.5 text-[10px] text-stone-400">Click a template to auto-fill the fields below.</p>
            </div>

            <!-- Name -->
            <div>
              <label class="block text-[11px] font-bold uppercase tracking-widest text-stone-400 mb-2">Name *</label>
              <input
                v-model="pathMeta.title"
                type="text"
                placeholder="e.g. AI Engineer Starter"
                class="w-full h-11 px-4 border border-stone-200 rounded-lg bg-white text-sm text-stone-900 placeholder:text-stone-400 outline-none focus:border-sky-400 focus:ring-2 focus:ring-sky-100 transition-colors"
              />
            </div>

            <!-- Description -->
            <div>
              <label class="block text-[11px] font-bold uppercase tracking-widest text-stone-400 mb-2">Description</label>
              <textarea
                v-model="pathMeta.description"
                rows="3"
                placeholder="Describe the goal and content of this learning path"
                class="w-full px-4 py-3 border border-stone-200 rounded-lg bg-white text-sm text-stone-900 placeholder:text-stone-400 outline-none focus:border-sky-400 focus:ring-2 focus:ring-sky-100 resize-none transition-colors"
              />
            </div>

            <!-- Type + Category -->
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-[11px] font-bold uppercase tracking-widest text-stone-400 mb-2">Type</label>
                <div class="relative">
                  <select
                    v-model="pathMeta.type"
                    class="w-full h-10 px-3 pr-8 border border-stone-200 rounded-lg bg-white text-sm text-stone-700 outline-none focus:border-sky-400 focus:ring-2 focus:ring-sky-100 cursor-pointer appearance-none"
                  >
                    <option value="linear path">Linear path</option>
                    <option value="partical pool">Partical pool</option>
                    <option value="structured path">Structured path</option>
                  </select>
                  <ChevronDown class="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-stone-400 pointer-events-none" />
                </div>
              </div>
              <div>
                <label class="block text-[11px] font-bold uppercase tracking-widest text-stone-400 mb-2">Category</label>
                <div class="relative">
                  <select
                    v-model.number="pathMeta.categoryId"
                    class="w-full h-10 px-3 pr-8 border border-stone-200 rounded-lg bg-white text-sm text-stone-700 outline-none focus:border-sky-400 focus:ring-2 focus:ring-sky-100 cursor-pointer appearance-none disabled:opacity-50"
                    :disabled="categoriesLoading || categories.length === 0"
                  >
                    <option :value="null">Select category</option>
                    <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
                  </select>
                  <ChevronDown class="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-stone-400 pointer-events-none" />
                </div>
                <p v-if="categoriesError" class="text-[10px] text-red-500 mt-1">{{ categoriesError }}</p>
              </div>
            </div>

            <!-- Visibility -->
            <div class="flex items-center justify-between rounded-lg border border-stone-100 bg-stone-50/50 px-4 py-3">
              <div>
                <p class="text-xs font-semibold text-stone-700">Visibility</p>
                <p class="text-[10px] text-stone-400 mt-0.5">Public: appears in LearningPool · Private: only visible to you</p>
              </div>
              <button
                type="button"
                class="relative h-7 w-14 rounded-full transition-colors focus:outline-none"
                :class="pathMeta.isPublic ? 'bg-sky-500' : 'bg-stone-300'"
                @click="pathMeta.isPublic = !pathMeta.isPublic"
              >
                <span
                  class="absolute top-0.5 left-0.5 h-6 w-6 rounded-full bg-white shadow-sm transition-transform duration-200"
                  :class="pathMeta.isPublic ? 'translate-x-7' : 'translate-x-0'"
                />
              </button>
            </div>
          </div>

          <!-- Right: cover picker -->
          <div class="col-span-12 lg:col-span-5">
            <label class="block text-[11px] font-bold uppercase tracking-widest text-stone-400 mb-2">Cover</label>
            <div class="grid grid-cols-2 gap-3">
              <!-- Preview -->
              <div class="rounded-lg overflow-hidden border border-stone-100">
                <div class="aspect-video bg-stone-100">
                  <img
                    v-if="pathMeta.coverImageUrl"
                    :src="pathMeta.coverImageUrl"
                    alt="Cover preview"
                    class="w-full h-full object-contain"
                    style="object-fit: contain; background-color: #f7f7f7;"
                  />
                  <div v-else class="w-full h-full flex items-center justify-center">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="text-stone-300"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
                  </div>
                </div>
                <div class="p-2 bg-stone-50/50 text-center">
                  <p class="text-[10px] text-stone-400">Current cover</p>
                </div>
              </div>
              <!-- Grid of defaults or uploaded -->
              <div class="space-y-2">
                <div v-if="uploadedCoverUrl" class="grid grid-cols-1 gap-2">
                  <button
                    type="button"
                    class="rounded-lg overflow-hidden border-2 transition-all"
                    :class="pathMeta.coverImageUrl === uploadedCoverUrl ? 'border-sky-500' : 'border-stone-200 hover:border-stone-300'"
                    @click="selectCover(uploadedCoverUrl)"
                  >
                    <div class="aspect-video bg-stone-100">
                      <img
                        :src="uploadedCoverUrl"
                        alt="Uploaded"
                        class="w-full h-full object-contain"
                        style="object-fit: contain; background-color: #f7f7f7;"
                      />
                    </div>
                  </button>
                </div>
                <div v-else class="grid grid-cols-4 gap-1.5">
                  <button
                    v-for="(u, idx) in defaultCoverUrls"
                    :key="idx"
                    type="button"
                    class="rounded-lg overflow-hidden border-2 transition-all"
                    :class="pathMeta.coverImageUrl === u ? 'border-sky-500' : 'border-stone-200 hover:border-stone-300'"
                    @click="selectCover(u)"
                  >
                    <div class="aspect-video bg-stone-100">
                      <img
                        :src="u"
                        :alt="`Cover ${idx + 1}`"
                        class="w-full h-full object-contain"
                        style="object-fit: contain; background-color: #f7f7f7;"
                      />
                    </div>
                  </button>
                </div>
                <input
                  ref="coverFileInput"
                  type="file"
                  accept="image/*"
                  class="hidden"
                  @change="onCoverFileChange"
                />
                <button
                  type="button"
                  class="w-full h-9 rounded-sm border border-dashed border-stone-300 bg-white text-xs font-semibold text-stone-500 hover:border-stone-400 hover:text-stone-700 transition-all flex items-center justify-center gap-1.5"
                  @click="openCoverFilePicker"
                >
                  <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                  Upload image
                </button>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Resources + Selected panels -->
      <div class="grid grid-cols-12 gap-6 mb-6">

        <!-- Left: available resources -->
        <div class="col-span-12 lg:col-span-6">
          <div class="bg-white rounded-md border border-stone-100 p-5 h-full">
            <div class="flex items-center justify-between mb-4">
              <div class="flex items-center gap-2">
                <div class="w-1 h-5 bg-emerald-500 rounded-full"></div>
                <h2 class="text-sm font-bold uppercase tracking-widest text-stone-700">Resources</h2>
              </div>
              <span class="text-xs text-stone-400">{{ filteredResources.length }} available</span>
            </div>

            <!-- Search -->
            <div class="relative mb-3">
              <Search class="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-stone-400" />
              <input
                v-model="searchQuery"
                type="text"
                placeholder="Search your resources..."
                class="h-10 w-full pl-10 pr-4 border border-stone-200 rounded-lg bg-white text-sm text-stone-900 placeholder:text-stone-400 outline-none focus:border-emerald-400 focus:ring-2 focus:ring-emerald-100 transition-colors"
              />
            </div>

            <!-- Create resource from URL -->
            <div class="rounded-lg border border-stone-100 bg-stone-50/50 p-3.5 mb-3">
              <p class="text-[11px] font-bold uppercase tracking-widest text-stone-500 mb-2">Create from URL</p>
              <div class="flex gap-2">
                <input
                  v-model="newResourceUrl"
                  type="url"
                  placeholder="https://..."
                  class="h-9 flex-1 px-3 border border-stone-200 rounded-lg bg-white text-xs text-stone-900 placeholder:text-stone-400 outline-none focus:border-emerald-400 transition-colors"
                />
                <button
                  type="button"
                  class="h-9 px-3 rounded-sm bg-stone-800 text-white text-xs font-semibold hover:bg-stone-700 transition-colors disabled:opacity-50"
                  :disabled="!newResourceUrl.trim() || newResourceLoading"
                  @click="createResourceFromUrl"
                >
                  {{ newResourceLoading ? '…' : 'Generate' }}
                </button>
              </div>
              <p v-if="newResourceError" class="text-[10px] text-red-500 mt-1.5">{{ newResourceError }}</p>
            </div>

            <!-- Resource list -->
            <div class="max-h-[420px] overflow-y-auto space-y-2 pr-1">
              <div
                v-for="r in filteredResources"
                :key="r.id"
                class="group rounded-lg border border-stone-100 bg-white hover:border-stone-200 hover:shadow-sm transition-all cursor-pointer overflow-hidden"
                draggable="true"
                @dragstart="handleDragStart($event, r)"
                @click="addResource(r)"
              >
                <div class="flex gap-3 p-3">
                  <div class="w-20 h-14 shrink-0 rounded-none overflow-hidden bg-stone-100">
                    <img
                      :src="r.thumbnail"
                      :alt="r.title"
                      class="w-full h-full object-contain"
                      style="object-fit: contain; background-color: #f7f7f7;"
                      loading="lazy"
                    />
                  </div>
                  <div class="flex-1 min-w-0">
                    <div class="flex items-start justify-between gap-2">
                      <h3 class="text-xs font-bold text-stone-800 line-clamp-1 leading-snug">{{ r.title }}</h3>
                      <span class="shrink-0 text-[9px] font-bold uppercase tracking-wider px-1.5 py-0.5 rounded bg-stone-100 text-stone-500">{{ r.type }}</span>
                    </div>
                    <p class="text-[10px] text-stone-400 mt-1 line-clamp-2 leading-relaxed">{{ r.summary }}</p>
                  </div>
                </div>
              </div>
              <p v-if="filteredResources.length === 0" class="text-xs text-stone-400 text-center py-8">No resources found.</p>
            </div>
          </div>
        </div>

        <!-- Right: selected resources -->
        <div class="col-span-12 lg:col-span-6">
          <div
            class="bg-white rounded-md border-2 p-5 min-h-[400px]"
            :class="selected.length > 0 ? 'border-stone-200' : 'border-dashed border-stone-200'"
            @dragover.prevent
            @drop="onDrop"
          >
            <div class="flex items-center justify-between mb-4">
              <div class="flex items-center gap-2">
                <div class="w-1 h-5 bg-sky-500 rounded-full"></div>
                <h2 class="text-sm font-bold uppercase tracking-widest text-stone-700">Selected</h2>
                <span v-if="selected.length > 0" class="text-xs text-stone-400">{{ selected.length }} items</span>
              </div>
              <button
                v-if="selected.length > 0"
                type="button"
                class="text-[10px] font-semibold uppercase tracking-wider text-stone-400 hover:text-red-500 transition-colors"
                @click="clearSelected"
              >
                Clear all
              </button>
            </div>

            <div v-if="selected.length === 0" class="flex flex-col items-center justify-center py-16 text-center">
              <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="8" y1="12" x2="16" y2="12"/></svg>
              <p class="text-sm text-stone-400">Click a resource or drag it here</p>
            </div>

            <div v-else class="space-y-2">
              <div v-for="(r, idx) in selected" :key="r.id" class="space-y-1.5">
                <!-- Resource card -->
                <div
                  class="flex gap-3 rounded-lg border border-stone-100 bg-white shadow-sm cursor-move transition-all hover:shadow-md"
                  draggable="true"
                  @dragstart="onSelectedDragStart($event, r.id, idx)"
                  @dragend="onSelectedDragEnd"
                  @dragover.prevent="onSelectedDragOver(idx)"
                  @drop.prevent="onSelectedDrop($event, idx)"
                >
                  <!-- Order number -->
                  <div class="w-8 h-full shrink-0 flex items-center justify-center bg-stone-50 rounded-l-lg">
                    <span class="text-xs font-black text-stone-400">{{ idx + 1 }}</span>
                  </div>
                  <div class="w-16 h-14 shrink-0 rounded-none overflow-hidden bg-stone-100 my-2">
                    <img
                      :src="r.thumbnail"
                      :alt="r.title"
                      class="w-full h-full object-contain"
                      style="object-fit: contain; background-color: #f7f7f7;"
                    />
                  </div>
                  <div class="flex-1 min-w-0 py-2.5 pr-3">
                    <h3 class="text-xs font-bold text-stone-800 line-clamp-1 leading-snug">{{ r.title }}</h3>
                    <p class="text-[10px] text-stone-400 mt-0.5 line-clamp-1">{{ r.summary }}</p>
                  </div>
                  <button
                    type="button"
                    class="self-center mr-2 shrink-0 w-7 h-7 rounded-full flex items-center justify-center text-stone-400 hover:text-red-500 hover:bg-red-50 transition-all"
                    @click="removeResource(r.id)"
                    aria-label="Remove"
                  >
                    <X class="w-3.5 h-3.5" />
                  </button>
                </div>
                <!-- Drop zone between items -->
                <div
                  v-if="idx !== selected.length - 1"
                  class="flex justify-center py-0.5"
                  @dragover.prevent
                  @drop.prevent="onSelectedDrop($event, idx + 1)"
                >
                  <div class="h-1 w-8 rounded-full bg-stone-100 group-hover:bg-emerald-200 transition-colors"
                    :class="selectedDragState.overIndex === idx + 1 ? 'bg-emerald-300' : ''"
                  ></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Submit -->
      <div class="flex justify-end">
        <Button
          type="button"
          class="rounded-full bg-sky-600 text-white hover:bg-sky-700 font-semibold text-sm px-10 py-3 transition-all hover:-translate-y-px disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none shadow-lg shadow-sky-600/20"
          :disabled="!pathMeta.title.trim() || selected.length === 0 || !pathMeta.categoryId"
          @click="createLearningPath"
        >
          Create Learning Path →
        </Button>
      </div>
      <p v-if="createError" class="text-sm text-red-500 text-right mt-2">{{ createError }}</p>

    </main>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ChevronDown, Search, X } from 'lucide-vue-next'
import { Button } from '../components/ui/button'
import { createMyResourceFromUrl, listMyResources, type DbResource } from '../api/resource'
import { addResourceToMyLearningPath, createLearningPathWithCategory } from '../api/learningPath'
import { listCategories, type Category } from '../api/category'
import request from '../utils/request'

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
  id: number; title: string; summary: string; source_url: string | null
  type: ResourceType; platform: string; thumbnail: string
}

const router = useRouter()

const allResources = ref<UiResource[]>([])
const searchQuery = ref('')
const newResourceUrl = ref('')
const newResourceError = ref('')
const newResourceLoading = ref(false)
const createError = ref('')

const filteredResources = computed(() => {
  const q = searchQuery.value.trim().toLowerCase()
  if (!q) return allResources.value
  return allResources.value.filter(r => r.title.toLowerCase().includes(q) || r.summary.toLowerCase().includes(q))
})

const selected = ref<UiResource[]>([])
const selectedDragState = reactive({ draggingId: -1 as number, fromIndex: -1 as number, overIndex: -1 as number })

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
  } else {
    pathMeta.title = 'Social News Digest'
    pathMeta.description = 'Collect tech news, articles, and podcasts you care about: organize by topic, review regularly, and refine over time.'
    pathMeta.type = 'partical pool'
    pathMeta.isPublic = true
  }
}

const coverFileInput = ref<HTMLInputElement | null>(null)
const uploadedCoverUrl = ref<string>('')
const categories = ref<Category[]>([])
const categoriesLoading = ref(false)
const categoriesError = ref('')

function toAbsoluteImageUrl(raw: unknown) {
  const url = String(raw || '').trim()
  if (!url) return ''
  if (url.startsWith('data:') || url.startsWith('http://') || url.startsWith('https://')) return url
  const base = String((request as any)?.defaults?.baseURL || '').replace(/\/$/, '')
  if (!base) return url
  return url.startsWith('/') ? `${base}${url}` : `${base}/${url}`
}

function isDefaultCover(url: string) { return String(url || '').startsWith('data:image/svg+xml') }

const defaultCoverUrls = ref<string[]>([])

function selectCover(url: string) { pathMeta.coverImageUrl = toAbsoluteImageUrl(url) }
function openCoverFilePicker() { coverFileInput.value?.click() }

function onCoverFileChange(e: Event) {
  const input = e.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return
  const reader = new FileReader()
  reader.onload = () => {
    const url = String(reader.result || '').trim()
    if (url) { uploadedCoverUrl.value = url; selectCover(url) }
  }
  reader.readAsDataURL(file)
}

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
  } catch (e: any) { categoriesError.value = e?.message || 'Failed to load categories'; categories.value = [] }
  finally { categoriesLoading.value = false }
}

function normalizePresentedType(raw: unknown): ResourceType {
  const t = String(raw || '').trim().toLowerCase()
  if (['video', 'document', 'article', 'clip', 'link'].includes(t)) return t as ResourceType
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
    thumbnail: toAbsoluteImageUrl((r as any).thumbnail),
  }
}

async function loadResources() {
  try {
    const rows = await listMyResources()
    allResources.value = Array.isArray(rows) ? rows.map(toUiResource) : []
    const thumbs = allResources.value.map(r => String(r.thumbnail || '').trim()).filter(Boolean)
    const unique: string[] = []
    for (const t of thumbs) { if (!unique.includes(t)) unique.push(t); if (unique.length >= 20) break }
    defaultCoverUrls.value = unique
    if (!pathMeta.coverImageUrl && defaultCoverUrls.value[0]) selectCover(defaultCoverUrls.value[0])
  } catch { allResources.value = []; defaultCoverUrls.value = [] }
}

async function createResourceFromUrl() {
  newResourceError.value = ''
  const raw = newResourceUrl.value.trim()
  if (!raw) return
  let parsed: URL
  try { parsed = new URL(raw) } catch { newResourceError.value = 'Invalid URL format. Please enter a full http(s) URL.'; return }
  if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') { newResourceError.value = 'Only http(s) links are supported.'; return }
  if (allResources.value.some(r => (r.source_url || '') === parsed.toString())) { newResourceError.value = 'This link already exists in your resource list.'; return }
  newResourceLoading.value = true
  try {
    if (pathMeta.categoryId == null) throw new Error('Please select a category first.')
    await createMyResourceFromUrl(parsed.toString(), { category_id: pathMeta.categoryId })
    newResourceUrl.value = ''
    await loadResources()
  } catch (e: any) { newResourceError.value = String(e?.response?.data?.detail || e?.message || 'Failed to generate resource') }
  finally { newResourceLoading.value = false }
}

function addResource(resource: UiResource) {
  if (selected.value.some(r => r.id === resource.id)) return
  selected.value = [...selected.value, resource]
  const firstThumb = String(selected.value[0]?.thumbnail || '').trim()
  if ((!pathMeta.coverImageUrl || isDefaultCover(pathMeta.coverImageUrl)) && firstThumb) selectCover(firstThumb)
}

function removeResource(id: number) {
  selected.value = selected.value.filter(r => r.id !== id)
  const firstThumb = String(selected.value[0]?.thumbnail || '').trim()
  if ((!pathMeta.coverImageUrl || isDefaultCover(pathMeta.coverImageUrl)) && firstThumb) selectCover(firstThumb)
}

function clearSelected() { selected.value = [] }

function onDrop(e: DragEvent) {
  const reorderId = e.dataTransfer?.getData('application/x-selected-resource-id') || ''
  const reorderFromStr = e.dataTransfer?.getData('application/x-selected-resource-from') || ''
  if (reorderId && reorderFromStr) {
    const fromIndex = Number(reorderFromStr)
    if (Number.isFinite(fromIndex)) moveSelected(fromIndex, selected.value.length - 1)
    return
  }
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
  const next = [...selected.value]
  const [item] = next.splice(fromIndex, 1)
  next.splice(toIndex, 0, item)
  selected.value = next
}

function onSelectedDragStart(e: DragEvent, id: number, idx: number) {
  selectedDragState.draggingId = id; selectedDragState.fromIndex = idx; selectedDragState.overIndex = idx
  e.dataTransfer?.setData('application/x-selected-resource-id', String(id))
  e.dataTransfer?.setData('application/x-selected-resource-from', String(idx))
  if (e.dataTransfer) e.dataTransfer.effectAllowed = 'move'
}

function onSelectedDragOver(idx: number) { selectedDragState.overIndex = idx }

function onSelectedDrop(e: DragEvent, dropIndex: number) {
  const fromStr = e.dataTransfer?.getData('application/x-selected-resource-from') || ''
  if (!fromStr) return
  const fromIndex = Number(fromStr)
  if (Number.isFinite(fromIndex)) moveSelected(fromIndex, dropIndex)
}

function onSelectedDragEnd() {
  selectedDragState.draggingId = -1; selectedDragState.fromIndex = -1; selectedDragState.overIndex = -1
}

async function createLearningPath() {
  if (!pathMeta.title.trim() || selected.value.length === 0 || pathMeta.categoryId == null) return
  createError.value = ''
  const coverUrl = String(pathMeta.coverImageUrl || '').trim() || null
  try {
    const createdDb = await createLearningPathWithCategory({
      title: pathMeta.title, type: pathMeta.type, description: pathMeta.description,
      is_public: pathMeta.isPublic, cover_image_url: coverUrl, category_id: pathMeta.categoryId,
    })
    const lpId = Number((createdDb as any)?.id)
    if (!Number.isFinite(lpId) || lpId <= 0) throw new Error('Create failed: invalid learning path id')
    for (let i = 0; i < selected.value.length; i++) {
      await addResourceToMyLearningPath(lpId, { resource_id: selected.value[i].id, order_index: i + 1, is_optional: false })
    }
    router.push({ name: 'learningpath', params: { id: String(lpId) }, query: { from: 'my-paths' } })
  } catch (e: any) { createError.value = String(e?.response?.data?.detail || e?.message || 'Create failed') }
}

onMounted(() => { void loadCategories(); void loadResources() })
</script>
