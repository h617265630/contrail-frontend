<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-6">
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

          <div class="max-h-[520px] overflow-y-auto pr-1 space-y-3">
            <article
              v-for="r in filteredResources"
              :key="r.id"
              class="border border-gray-200 rounded-xl overflow-hidden hover:shadow-md transition bg-white"
              draggable="true"
              @dragstart="handleDragStart($event, r)"
            >
              <div class="flex gap-3 p-3">
                <img :src="r.thumbnail" :alt="r.title" class="w-24 h-16 object-cover rounded-lg bg-gray-100 flex-shrink-0" />
                <div class="min-w-0 flex-1">
                  <div class="flex items-start justify-between gap-2">
                    <h3 class="text-gray-900 font-semibold text-sm line-clamp-1" :title="r.title">{{ r.title }}</h3>
                    <span class="px-2 py-1 rounded-full text-xs font-semibold" :class="typeBadge(r.type)">{{ r.type }}</span>
                  </div>
                  <p class="text-gray-600 text-xs mt-1 line-clamp-2">{{ r.description }}</p>
                  <div class="mt-2 flex flex-wrap gap-2 text-xs text-gray-500">
                    <span class="px-2 py-1 rounded-full bg-gray-100 text-gray-700">{{ r.category }}</span>
                    <span v-if="r.duration" class="px-2 py-1 rounded-full bg-gray-100 text-gray-700">{{ r.duration }}</span>
                    <span v-if="r.pages" class="px-2 py-1 rounded-full bg-gray-100 text-gray-700">{{ r.pages }} pages</span>
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
                  <div class="w-8 h-8 rounded-lg bg-gray-100 text-gray-700 flex items-center justify-center text-xs font-semibold flex-shrink-0">
                    {{ idx + 1 }}
                  </div>
                  <img :src="r.thumbnail" :alt="r.title" class="w-24 h-16 object-cover rounded-lg bg-gray-100 flex-shrink-0" />
                  <div class="min-w-0 flex-1">
                    <div class="flex items-start justify-between gap-2">
                      <h3 class="text-gray-900 font-semibold text-sm line-clamp-1">{{ r.title }}</h3>
                      <button type="button" class="text-gray-400 hover:text-gray-700" @click="removeResource(r.id)" aria-label="Remove">
                        <X class="w-4 h-4" />
                      </button>
                    </div>
                    <p class="text-gray-600 text-xs mt-1 line-clamp-2">{{ r.description }}</p>
                    <div class="mt-2 flex flex-wrap gap-2 text-xs text-gray-500">
                      <span class="px-2 py-1 rounded-full bg-gray-100 text-gray-700">{{ r.category }}</span>
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
              :disabled="!pathMeta.title.trim()"
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
import { computed, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ChevronDown, Plus, Search, X } from 'lucide-vue-next'
import { resourceSeed, type Resource } from '../data/resources'
import { addMyLearningPath } from '../data/myPaths'
import { listAllResources, upsertResource } from '../data/resourcesStore'

type PathMeta = {
  title: string
  description: string
}

const router = useRouter()

const allResources = ref<Resource[]>(listAllResources())
const searchQuery = ref('')

const newResourceUrl = ref('')
const newResourceError = ref('')
const newResourceLoading = ref(false)

const defaultThumbnail = resourceSeed[0]?.thumbnail ?? ''

const filteredResources = computed(() => {
  const q = searchQuery.value.trim().toLowerCase()
  if (!q) return allResources.value
  return allResources.value.filter(r => r.title.toLowerCase().includes(q) || r.description.toLowerCase().includes(q))
})

const selected = ref<Resource[]>([])

const selectedDragState = reactive({
  draggingId: '' as string,
  fromIndex: -1 as number,
  overIndex: -1 as number,
})

const pathMeta = reactive<PathMeta>({ title: '', description: '' })

function typeBadge(type: Resource['type']) {
  switch (type) {
    case 'video':
      return 'bg-purple-50 text-purple-700'
    case 'document':
      return 'bg-blue-50 text-blue-700'
    case 'article':
      return 'bg-green-50 text-green-700'
  }
}

function inferTypeFromUrl(url: URL): Resource['type'] {
  const host = url.hostname.toLowerCase()
  const path = url.pathname.toLowerCase()
  if (host.includes('youtube.com') || host.includes('youtu.be') || host.includes('bilibili.com') || host.includes('vimeo.com')) {
    return 'video'
  }
  if (path.endsWith('.mp4') || path.endsWith('.mov') || path.endsWith('.m4v') || path.endsWith('.webm')) {
    return 'video'
  }
  return 'document'
}

async function fetchMetaForUrl(url: URL): Promise<{ title: string; description: string; thumbnail: string } | null> {
  const href = url.toString()
  const host = url.hostname.toLowerCase()

  // Prefer oEmbed where available (often supports CORS)
  try {
    if (host.includes('youtube.com') || host.includes('youtu.be')) {
      const endpoint = `https://www.youtube.com/oembed?format=json&url=${encodeURIComponent(href)}`
      const res = await fetch(endpoint)
      if (res.ok) {
        const data = (await res.json()) as { title?: string; thumbnail_url?: string }
        return {
          title: data.title ?? '',
          description: '',
          thumbnail: data.thumbnail_url ?? '',
        }
      }
    }
    if (host.includes('vimeo.com')) {
      const endpoint = `https://vimeo.com/api/oembed.json?url=${encodeURIComponent(href)}`
      const res = await fetch(endpoint)
      if (res.ok) {
        const data = (await res.json()) as { title?: string; description?: string; thumbnail_url?: string }
        return {
          title: data.title ?? '',
          description: data.description ?? '',
          thumbnail: data.thumbnail_url ?? '',
        }
      }
    }
  } catch {
    // ignore and fallback
  }

  // Fallback: fetch HTML and parse OpenGraph (may fail due to CORS)
  try {
    const res = await fetch(href)
    if (!res.ok) return null
    const html = await res.text()
    const doc = new DOMParser().parseFromString(html, 'text/html')
    const ogTitle = doc.querySelector('meta[property="og:title"]')?.getAttribute('content') ?? ''
    const ogDesc = doc.querySelector('meta[property="og:description"]')?.getAttribute('content') ?? ''
    const ogImg = doc.querySelector('meta[property="og:image"]')?.getAttribute('content') ?? ''
    const title = ogTitle || doc.querySelector('title')?.textContent?.trim() || ''
    const description = ogDesc || doc.querySelector('meta[name="description"]')?.getAttribute('content') || ''

    return {
      title,
      description,
      thumbnail: ogImg,
    }
  } catch {
    return null
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

  const exists = allResources.value.some(r => r.url === parsed.toString())
  if (exists) {
    newResourceError.value = '该链接已存在于资源列表'
    return
  }

  newResourceLoading.value = true
  const meta = await fetchMetaForUrl(parsed)
  newResourceLoading.value = false

  const type = inferTypeFromUrl(parsed)
  const hostLabel = parsed.hostname.replace(/^www\./, '')
  const today = new Date().toISOString().slice(0, 10)

  if (!meta) {
    // Most common reason is CORS; keep UX simple but informative.
    newResourceError.value = '已生成资源，但无法自动抓取标题/简介/图片（可能是跨域限制）'
  }

  const resource: Resource = {
    id: `u_${Date.now()}_${Math.random().toString(16).slice(2)}`,
    title: meta?.title?.trim() || hostLabel || 'External Resource',
    description: meta?.description?.trim() || '从链接生成的资源',
    url: parsed.toString(),
    type,
    category: 'Custom',
    thumbnail: meta?.thumbnail?.trim() || defaultThumbnail,
    addedDate: today,
    source: hostLabel || 'External',
  }

  // Save to resource “database” (localStorage)
  upsertResource(resource)
  allResources.value = listAllResources()
  newResourceUrl.value = ''
}

function addResource(resource: Resource) {
  if (selected.value.some(r => r.id === resource.id)) return
  selected.value = [...selected.value, resource]
}

function removeResource(id: string) {
  selected.value = selected.value.filter(r => r.id !== id)
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
  const hit = allResources.value.find(r => r.id === resourceId)
  if (hit) addResource(hit)
}

function handleDragStart(e: DragEvent, resource: Resource) {
  e.dataTransfer?.setData('text/plain', resource.id)
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

function onSelectedDragStart(e: DragEvent, id: string, idx: number) {
  selectedDragState.draggingId = id
  selectedDragState.fromIndex = idx
  selectedDragState.overIndex = idx

  e.dataTransfer?.setData('application/x-selected-resource-id', id)
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
  selectedDragState.draggingId = ''
  selectedDragState.fromIndex = -1
  selectedDragState.overIndex = -1
}

function createLearningPath() {
  if (!pathMeta.title.trim()) return
  const created = addMyLearningPath({
    title: pathMeta.title,
    description: pathMeta.description,
    resources: selected.value,
  })

  alert('创建成功')
  router.push({ name: 'learningpath', params: { id: created.id } })

  pathMeta.title = ''
  pathMeta.description = ''
  selected.value = []
  searchQuery.value = ''
}
</script>
