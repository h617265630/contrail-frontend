<template>
  <div class="min-h-screen bg-linear-to-br from-blue-50 to-indigo-100 p-6">
    <div class="max-w-7xl mx-auto space-y-6">
      <!-- Header -->
      <div class="bg-white rounded-2xl shadow-xl p-8">
        <div class="flex items-start justify-between gap-4">
          <div class="min-w-0">
            <h1 class="text-gray-900 mb-2">CreatePath</h1>
            <p class="text-gray-600">搜索并选择资源，通过拖拽或点击添加到你的学习路径。</p>
          </div>
        </div>
      </div>

      <!-- Main content -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Resources panel -->
        <section class="bg-white rounded-2xl shadow-xl p-6 space-y-4">
          <div class="flex items-center justify-between gap-3">
            <h2 class="text-lg font-semibold text-gray-900">Resources</h2>
            <span class="text-sm text-gray-500">{{ filteredResources.length }} results</span>
          </div>

          <div class="relative">
            <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              v-model="searchQuery"
              type="search"
              placeholder="Search resources..."
              class="w-full pl-9 pr-3 py-2 rounded-lg border border-gray-200 bg-white text-sm text-gray-900 placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <!-- Create resource from URL/share link -->
          <div class="rounded-xl border border-gray-200 bg-gray-50 p-4 space-y-3">
            <div>
              <p class="text-gray-900 font-semibold">通过链接生成资源</p>
              <p class="text-gray-600 text-xs mt-1">粘贴 URL / 分享链接后点击生成，将加入下方资源列表。</p>
            </div>
            <div class="flex items-center gap-2">
              <input
                v-model="newResourceUrl"
                type="url"
                placeholder="https://..."
                class="flex-1 px-3 py-2 rounded-lg border border-gray-200 bg-white text-sm text-gray-900 placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <button
                type="button"
                class="px-4 py-2 rounded-lg bg-blue-600 text-white text-sm font-semibold hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
                :disabled="!newResourceUrl.trim() || newResourceLoading"
                @click="createResourceFromUrl"
              >
                {{ newResourceLoading ? '生成中...' : '生成' }}
              </button>
            </div>
            <p v-if="newResourceError" class="text-xs text-red-600">{{ newResourceError }}</p>
          </div>

          <div class="max-h-130 overflow-y-auto pr-1 space-y-3">
            <article
              v-for="r in filteredResources"
              :key="r.id"
              class="border border-gray-200 rounded-xl overflow-hidden hover:shadow-md transition bg-white"
              draggable="true"
              @dragstart="handleDragStart($event, r)"
            >
              <div class="flex gap-3 p-3">
                <img :src="r.thumbnail" :alt="r.title" class="w-24 h-16 object-cover rounded-lg bg-gray-100 shrink-0" />
                <div class="min-w-0 flex-1">
                  <div class="flex items-start justify-between gap-2">
                    <h3 class="text-gray-900 font-semibold text-sm line-clamp-1" :title="r.title">{{ r.title }}</h3>
                    <span class="px-2 py-1 rounded-full text-xs font-semibold" :class="typeBadge(r.type)">{{ r.type }}</span>
                  </div>
                  <p class="text-gray-600 text-xs mt-1 line-clamp-2">{{ r.summary }}</p>
                  <div class="mt-2 flex flex-wrap gap-2 text-xs text-gray-500">
                    <span v-if="r.platform" class="px-2 py-1 rounded-full bg-gray-100 text-gray-700">{{ r.platform }}</span>
                  </div>
                </div>
              </div>
              <div class="border-t border-gray-100 p-3 flex items-center justify-between">
                <span class="text-xs text-gray-400">拖拽到右侧学习路径区域</span>
                <button
                  type="button"
                  class="px-3 py-1.5 rounded-lg bg-blue-600 text-white text-xs font-semibold hover:bg-blue-700 transition-colors inline-flex items-center gap-2"
                  @click="addResource(r)"
                >
                  <Plus class="w-3.5 h-3.5" />
                  添加
                </button>
              </div>
            </article>
          </div>
        </section>

        <!-- Builder panel -->
        <section
          class="bg-white rounded-2xl shadow-xl p-6 space-y-4"
          @dragover.prevent
          @drop="onDrop"
        >
          <div class="flex items-center justify-between gap-3">
            <div class="min-w-0">
              <h2 class="text-lg font-semibold text-gray-900">LearningPath Builder</h2>
              <p class="text-sm text-gray-600">
                <span class="text-gray-500">{{ selected.length }} items</span>
              </p>
            </div>
            <button
              type="button"
              class="px-4 py-2 rounded-lg bg-gray-100 text-gray-700 hover:bg-gray-200 transition-colors"
              @click="clearSelected"
              :disabled="selected.length === 0"
            >
              清空
            </button>
          </div>

          <!-- Meta inputs -->
          <div class="rounded-xl border border-gray-200 p-4 bg-gray-50 space-y-3">
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">名称 *</label>
              <input
                v-model="pathMeta.title"
                type="text"
                placeholder="例如：AI Engineer Starter"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
              />
            </div>
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">介绍</label>
              <textarea
                v-model="pathMeta.description"
                rows="3"
                placeholder="简要介绍这个学习路径的目标与内容"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none bg-white"
              />
            </div>

            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">封面</label>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div class="rounded-xl border border-gray-200 bg-white overflow-hidden">
                  <div class="aspect-video bg-gray-100">
                    <img
                      v-if="pathMeta.coverImageUrl"
                      :src="pathMeta.coverImageUrl"
                      alt="Selected cover"
                      class="w-full h-full object-cover"
                    />
                    <div v-else class="w-full h-full flex items-center justify-center text-sm text-gray-500">
                      未选择封面
                    </div>
                  </div>
                  <div class="p-3">
                    <p class="text-xs text-gray-500">左侧为当前选择的封面预览</p>
                  </div>
                </div>

                <div class="rounded-xl border border-gray-200 bg-white p-3">
                  <div v-if="uploadedCoverUrl" class="space-y-3">
                    <button
                      type="button"
                      class="w-full rounded-lg overflow-hidden border-2"
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
                      class="rounded-lg overflow-hidden border-2"
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
                      class="inline-flex items-center justify-center px-3 py-2 rounded-lg bg-gray-100 text-gray-700 hover:bg-gray-200 text-xs font-semibold"
                      @click="openCoverFilePicker"
                    >
                      上传图片
                    </button>
                    <p class="text-xs text-gray-500">上传后右侧仅显示上传图</p>
                  </div>
                </div>
              </div>
            </div>

            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">分类</label>
              <select
                v-model.number="pathMeta.categoryId"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg bg-white text-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50"
                :disabled="categoriesLoading || categories.length === 0"
              >
                <option :value="null">未选择</option>
                <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
              </select>
              <p v-if="categoriesError" class="text-xs text-red-600 mt-2">{{ categoriesError }}</p>
              <p v-else class="text-xs text-gray-500 mt-2">从数据库读取分类（可不选）。</p>
            </div>

            <div class="flex items-center justify-between gap-3">
              <div class="min-w-0">
                <div class="text-sm font-semibold text-gray-700">是否公开</div>
                <div class="text-xs text-gray-500">公开：会出现在 LearningPool；私有：仅自己可见</div>
              </div>
              <button
                type="button"
                class="inline-flex items-center gap-2 rounded-lg bg-gray-100 px-3 py-2 text-xs font-semibold text-gray-700 hover:bg-gray-200"
                @click="pathMeta.isPublic = !pathMeta.isPublic"
              >
                <span>{{ pathMeta.isPublic ? 'Public' : 'Private' }}</span>
                <span
                  class="relative h-5 w-9 rounded-full transition-colors"
                  :class="pathMeta.isPublic ? 'bg-blue-600' : 'bg-gray-300'"
                >
                  <span
                    class="absolute left-0.5 top-0.5 h-4 w-4 rounded-full bg-white transition-transform"
                    :class="pathMeta.isPublic ? 'translate-x-0' : 'translate-x-4'"
                  />
                </span>
              </button>
            </div>
          </div>

          <div
            class="rounded-xl border-2 border-dashed p-4"
            :class="selected.length ? 'border-gray-200 bg-gray-50' : 'border-blue-200 bg-blue-50'"
          >
            <div v-if="selected.length === 0" class="text-sm text-gray-600">
              将左侧资源拖拽到这里，或点击“添加”。
            </div>

            <div v-else class="space-y-2">
              <div v-for="(r, idx) in selected" :key="r.id" class="space-y-2">
                <article
                  :class="[
                    'rounded-xl border p-3 flex gap-3 transition',
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
                  <div class="w-8 h-8 rounded-lg bg-gray-100 text-gray-700 flex items-center justify-center text-xs font-semibold shrink-0">
                    {{ idx + 1 }}
                  </div>
                  <img :src="r.thumbnail" :alt="r.title" class="w-24 h-16 object-cover rounded-lg bg-gray-100 shrink-0" />
                  <div class="min-w-0 flex-1">
                    <div class="flex items-start justify-between gap-2">
                      <h3 class="text-gray-900 font-semibold text-sm line-clamp-1">{{ r.title }}</h3>
                      <button type="button" class="text-gray-400 hover:text-gray-700" @click="removeResource(r.id)" aria-label="Remove">
                        <X class="w-4 h-4" />
                      </button>
                    </div>
                    <p class="text-gray-600 text-xs mt-1 line-clamp-2">{{ r.summary }}</p>
                    <div class="mt-2 flex flex-wrap gap-2 text-xs text-gray-500">
                      <span v-if="r.platform" class="px-2 py-1 rounded-full bg-gray-100 text-gray-700">{{ r.platform }}</span>
                      <span class="px-2 py-1 rounded-full text-xs font-semibold" :class="typeBadge(r.type)">{{ r.type }}</span>
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
            <button
              type="button"
              class="w-full px-4 py-3 rounded-xl bg-blue-600 text-white font-semibold hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
              :disabled="!pathMeta.title.trim() || selected.length === 0"
              @click="createLearningPath"
            >
              创建 LearningPath
            </button>
          </div>
        </section>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ChevronDown, Plus, Search, X } from 'lucide-vue-next'
import { createMyResourceFromUrl, listMyResources, type DbResource } from '../api/resource'
import { addResourceToMyLearningPath, createLearningPathWithCategory } from '../api/learningPath'
import { listCategories, type Category } from '../api/category'

type PathMeta = {
  title: string
  description: string
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

const pathMeta = reactive<PathMeta>({ title: '', description: '', isPublic: true, categoryId: null, coverImageUrl: '' })

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
    categoriesError.value = e?.message || '分类加载失败'
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
    newResourceError.value = '链接格式不正确，请输入完整的 http(s) URL'
    return
  }

  if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') {
    newResourceError.value = '仅支持 http(s) 链接'
    return
  }

  const exists = allResources.value.some(r => (r.source_url || '') === parsed.toString())
  if (exists) {
    newResourceError.value = '该链接已存在于资源列表'
    return
  }

  newResourceLoading.value = true
  try {
    if (pathMeta.categoryId == null) {
      throw new Error('请选择分类')
    }
    await createMyResourceFromUrl(parsed.toString(), { category_id: pathMeta.categoryId })
    newResourceUrl.value = ''
    await loadResources()
  } catch (e: any) {
    newResourceError.value = String(e?.response?.data?.detail || e?.message || '生成失败')
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
    alert('请选择分类')
    return
  }

  // Rule: cover_image_url always uses the first resource thumbnail.
  const coverUrl = String(selected.value[0]?.thumbnail || '').trim() || null
  if (coverUrl) selectCover(coverUrl)

  try {
    const createdDb = await createLearningPathWithCategory({
      title: pathMeta.title,
      description: pathMeta.description,
      is_public: pathMeta.isPublic,
      cover_image_url: coverUrl,
      category_id: pathMeta.categoryId,
    })

    const lpId = Number((createdDb as any)?.id)
    if (!Number.isFinite(lpId) || lpId <= 0) throw new Error('创建失败：无效的 learning path id')

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
    alert(String(e?.response?.data?.detail || e?.message || '创建失败'))
    return
  }

  pathMeta.title = ''
  pathMeta.description = ''
  pathMeta.isPublic = true
  pathMeta.categoryId = null
  pathMeta.coverImageUrl = defaultCoverUrls[0] || ''
  uploadedCoverUrl.value = ''
  selected.value = []
  searchQuery.value = ''
}
</script>
