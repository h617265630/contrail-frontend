<template>
  <div class="min-h-screen bg-slate-50">
    <div class="max-w-7xl mx-auto p-6 space-y-6">
      <div class="flex items-center justify-between gap-4">
        <div class="min-w-0">
          <h1 class="text-2xl font-semibold text-slate-900 truncate">Add Resource to LearningPath</h1>
          <p class="text-sm text-slate-600">选择一个 learningpath，并查看其内容</p>
        </div>
        <RouterLink
          to="/my-paths"
          class="px-4 py-2 rounded-lg bg-white border border-slate-200 text-slate-700 text-sm font-semibold hover:bg-slate-50"
        >
          返回 MyPaths
        </RouterLink>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Column 1: Resource -->
        <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
          <div class="p-4 border-b border-slate-100 bg-slate-50">
            <h2 class="text-slate-900 font-semibold">Resource</h2>
            <p class="text-sm text-slate-600">根据 id 展示</p>
          </div>

          <div v-if="resourceLoading" class="p-6 text-sm text-slate-600">Loading…</div>
          <div v-else-if="resourceError" class="p-6 text-sm text-red-600">{{ resourceError }}</div>

          <div
            v-else-if="resource"
            class="p-4 space-y-3"
            :class="isDragging ? 'opacity-70' : ''"
          >
            <div class="h-36 rounded-xl bg-slate-100 overflow-hidden">
              <img :src="resource.thumbnail" :alt="resource.title" class="w-full h-full object-cover" />
            </div>
            <div class="space-y-1">
              <div class="text-slate-900 font-semibold">{{ resource.title }}</div>
              <div class="text-sm text-slate-600 line-clamp-3">{{ resource.description }}</div>
            </div>
            <div class="flex flex-wrap gap-2">
              <span class="px-2 py-1 rounded-full bg-blue-50 text-blue-700 text-xs font-semibold">{{ resource.category }}</span>
              <span class="px-2 py-1 rounded-full bg-slate-100 text-slate-700 text-xs">{{ resource.type }}</span>
              <span v-if="resource.type === 'video' && resource.duration" class="px-2 py-1 rounded-full bg-slate-100 text-slate-700 text-xs">
                {{ resource.duration }}
              </span>
              <span v-if="resource.type !== 'video' && resource.pages" class="px-2 py-1 rounded-full bg-slate-100 text-slate-700 text-xs">
                {{ resource.pages }} pages
              </span>
            </div>

            <div
              class="rounded-xl border border-dashed border-slate-300 bg-slate-50 p-3 text-xs text-slate-600"
            >
              拖拽此卡片到右侧 Selected Path 中添加
            </div>

            <div
              class="rounded-xl border border-slate-200 bg-white p-3 cursor-grab active:cursor-grabbing"
              draggable="true"
              @dragstart="onDragStart"
              @dragend="onDragEnd"
            >
              <div class="font-semibold text-slate-900 text-sm truncate">{{ resource.title }}</div>
              <div class="text-xs text-slate-600 truncate">{{ resource.url }}</div>
            </div>
          </div>

          <div v-else class="p-6 text-sm text-slate-600">未找到该资源（id: {{ resourceId }}）</div>
        </div>

        <!-- Column 2: All LearningPaths -->
        <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
          <div class="p-4 border-b border-slate-100 bg-slate-50">
            <h2 class="text-slate-900 font-semibold">My LearningPaths</h2>
            <p class="text-sm text-slate-600">选择一个路径</p>
          </div>

          <div v-if="paths.length === 0" class="p-6 space-y-3">
            <div class="text-sm text-slate-700 font-semibold">还没有创建任何 LearningPath</div>
            <RouterLink
              to="/createpath"
              class="inline-flex px-4 py-2 rounded-lg bg-blue-600 text-white text-sm font-semibold hover:bg-blue-700"
            >
              去创建
            </RouterLink>
          </div>

          <div v-else class="p-3 space-y-2">
            <button
              v-for="p in paths"
              :key="p.id"
              type="button"
              class="w-full text-left rounded-xl border px-4 py-3 hover:bg-slate-50 transition"
              :class="selectedPathId === p.id ? 'border-blue-500 bg-blue-50/40' : 'border-slate-200 bg-white'"
              @click="selectedPathId = p.id"
            >
              <div class="flex items-start justify-between gap-3">
                <div class="min-w-0">
                  <div class="font-semibold text-slate-900 truncate">{{ p.title }}</div>
                  <div class="text-xs text-slate-600 line-clamp-2">{{ p.description || '（无介绍）' }}</div>
                </div>
                <div class="text-xs text-slate-500 shrink-0">—</div>
              </div>
            </button>
          </div>
        </div>

        <!-- Column 3: Selected LearningPath detail -->
        <div
          class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden"
          @dragover.prevent
          @drop.prevent="onDrop"
        >
          <div class="p-4 border-b border-slate-100 bg-slate-50">
            <h2 class="text-slate-900 font-semibold">Selected Path</h2>
            <p class="text-sm text-slate-600">默认展示第一条</p>
          </div>

          <div v-if="!selectedPath" class="p-6 text-sm text-slate-600">暂无可展示的 LearningPath</div>

          <div v-else class="p-4 space-y-4">
            <div>
              <div class="text-lg font-semibold text-slate-900">{{ selectedPath.title }}</div>
              <div class="text-sm text-slate-600 mt-1">{{ selectedPath.description || '（无介绍）' }}</div>
            </div>

            <div class="flex items-center justify-between gap-3">
              <div class="text-sm text-slate-700">
                <span class="font-semibold">操作：</span>
                <span class="text-slate-600">将左侧 resource 拖到本卡片，然后点击确认</span>
              </div>
              <button
                type="button"
                class="px-4 py-2 rounded-lg bg-blue-600 text-white text-sm font-semibold hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
                :disabled="!selectedPath || !resource || !hasDraftChange || saving"
                @click="confirmAddToPath"
              >
                {{ saving ? 'Saving…' : '确认添加' }}
              </button>
            </div>

            <div
              class="rounded-xl border border-dashed p-3 text-sm"
              :class="isOverDropZone ? 'border-blue-400 bg-blue-50/40 text-blue-700' : 'border-slate-300 bg-slate-50 text-slate-600'"
              @dragenter.prevent="isOverDropZone = true"
              @dragleave.prevent="isOverDropZone = false"
            >
              {{ isOverDropZone ? '松开以添加到该路径' : '将 Resource 拖到这里' }}
            </div>

            <div class="space-y-2">
              <div class="text-sm font-semibold text-slate-900">内容</div>
              <div v-if="draftItems.length === 0" class="text-sm text-slate-600">（该路径暂无资源）</div>
              <div v-else class="space-y-2">
                <div
                  v-for="(it, idx) in draftItems"
                  :key="it.id"
                  class="space-y-2"
                >
                  <div
                    class="flex items-start gap-3 rounded-xl border bg-white p-3 transition border-slate-200"
                  >
                    <div class="h-7 w-7 rounded-lg bg-slate-100 text-slate-700 flex items-center justify-center text-xs font-semibold shrink-0">
                      {{ idx + 1 }}
                    </div>
                    <img :src="it.thumbnail" :alt="it.title" class="h-14 w-14 rounded-lg object-cover bg-slate-100 shrink-0" />
                    <div class="min-w-0 flex-1">
                      <div class="font-semibold text-slate-900 line-clamp-1">{{ it.title }}</div>
                      <div class="text-xs text-slate-600 line-clamp-2">{{ it.description }}</div>
                      <div class="mt-1 flex flex-wrap gap-2">
                        <span class="px-2 py-0.5 rounded-full bg-blue-50 text-blue-700 text-xs font-semibold">{{ it.category }}</span>
                        <span class="px-2 py-0.5 rounded-full bg-slate-100 text-slate-700 text-xs">{{ it.type }}</span>
                      </div>
                    </div>
                  </div>

                  <div v-if="idx !== draftItems.length - 1" class="h-2" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { RouterLink, useRoute } from 'vue-router'

import { addResourceToMyLearningPath, listMyLearningPaths, type MyLearningPath } from '../api/learningPath'
import { getMyResourceDetail, getResourceDetail, type DbResourceDetail } from '../api/resource'

const route = useRoute()

const resourceType = computed(() => (route.params.type as string) || 'document')
const resourceId = computed(() => (route.params.id as string) || '')

const resourceLoading = ref(false)
const resourceError = ref('')
type UiResource = {
  id: string
  title: string
  description: string
  url: string
  type: 'video' | 'document' | 'article'
  category: string
  thumbnail: string
  duration?: string
  pages?: number
}

const resourceFromDb = ref<UiResource | null>(null)
const isDragging = ref(false)
const isOverDropZone = ref(false)
const saving = ref(false)
const pendingAdd = ref(false)

const paths = ref<MyLearningPath[]>([])
const selectedPathId = ref<number | null>(null)

async function loadPaths() {
  try {
    const data = await listMyLearningPaths()
    paths.value = data || []
    if (selectedPathId.value == null && paths.value.length > 0) {
      selectedPathId.value = paths.value[0].id
    }
  } catch {
    paths.value = []
    selectedPathId.value = null
  }
}

watch(
  () => paths.value,
  () => {
    if (selectedPathId.value != null) return
    if (paths.value.length > 0) selectedPathId.value = paths.value[0].id
  },
  { immediate: true },
)

const resource = computed<UiResource | null>(() => {
  return resourceFromDb.value
})

const selectedPath = computed<MyLearningPath | null>(() => {
  if (selectedPathId.value == null) return null
  return paths.value.find(p => p.id === selectedPathId.value) ?? null
})

watch(
  selectedPathId,
  () => {
    // We don't load full existing items here; only track a pending add.
    pendingAdd.value = false
  },
  { immediate: true },
)

const hasDraftChange = computed(() => {
  if (!selectedPath.value) return false
  if (!resource.value) return false
  return pendingAdd.value
})

const draftItems = computed<UiResource[]>(() => {
  if (!pendingAdd.value) return []
  return resource.value ? [resource.value] : []
})

function normalizeUiType(raw: string): UiResource['type'] {
  const t = String(raw || '').trim().toLowerCase()
  if (t === 'video') return 'video'
  if (t === 'clip' || t === 'article') return 'article'
  return 'document'
}

function mapDbToUi(detail: DbResourceDetail): UiResource {
  const fallbackThumb = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400&h=225&fit=crop'
  const kind = String((detail as any).resource_kind || detail.resource_type || '').trim()
  const uiType = normalizeUiType(kind || resourceType.value)
  return {
    id: String(detail.id),
    title: String(detail.title || ''),
    description: String(detail.description || ''),
    url: String(detail.url || ''),
    type: uiType,
    category: String(detail.category || 'Other'),
    thumbnail: String(detail.thumbnail_url || fallbackThumb),
    duration: undefined,
    pages: undefined,
  }
}

async function loadDbResourceIfNeeded() {
  resourceFromDb.value = null
  resourceError.value = ''

  const raw = String(resourceId.value || '').trim()
  if (!raw) return
  if (!/^\d+$/.test(raw)) return

  resourceLoading.value = true
  try {
    let detail: DbResourceDetail
    try {
      detail = await getResourceDetail(Number(raw))
    } catch {
      detail = await getMyResourceDetail(Number(raw))
    }
    resourceFromDb.value = mapDbToUi(detail)
  } catch (e: any) {
    const msg = e?.response?.data?.detail || e?.message || ''
    resourceError.value = String(msg || 'Failed to load resource')
  } finally {
    resourceLoading.value = false
  }
}

watch(
  () => route.params.id,
  () => {
    void loadDbResourceIfNeeded()
  },
  { immediate: true },
)

function onDragStart(e: DragEvent) {
  if (!resource.value) return
  isDragging.value = true
  try {
    e.dataTransfer?.setData('text/plain', String(resource.value.id))
    e.dataTransfer?.setData('application/x-resource-id', String(resource.value.id))
    e.dataTransfer?.setData('application/x-resource-type', String(resource.value.type))
    e.dataTransfer!.effectAllowed = 'copy'
  } catch {
    // ignore
  }
}

function onDragEnd() {
  isDragging.value = false
  isOverDropZone.value = false
}

function onDrop(e: DragEvent) {
  isOverDropZone.value = false

  // Add from left resource panel
  const rid = (e.dataTransfer?.getData('application/x-resource-id') || e.dataTransfer?.getData('text/plain') || '').trim()
  if (!rid) return
  if (resource.value && String(resource.value.id) === rid) {
    pendingAdd.value = true
  }
}

async function confirmAddToPath() {
  if (!selectedPath.value) return
  if (!resource.value) return
  if (!hasDraftChange.value) return

  saving.value = true
  try {
    const rt = String(resourceType.value || '').toLowerCase()
    const backendType = rt === 'video' ? 'video' : rt === 'clip' ? 'clip' : 'link'
    await addResourceToMyLearningPath(selectedPath.value.id, {
      resource_type: backendType,
      resource_id: Number(resource.value.id),
      title: resource.value.title,
      description: resource.value.description,
    })
    pendingAdd.value = false
    await loadPaths()
  } catch (e: any) {
    const msg = e?.response?.data?.detail || e?.message || 'Failed to add to path'
    alert(String(msg))
  } finally {
    saving.value = false
  }
}

void loadPaths()
</script>
