<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
      <div class="flex items-center justify-between gap-4">
        <div class="min-w-0">
          <h1 class="text-xl md:text-2xl font-semibold text-foreground truncate">Add Resource to LearningPath</h1>
          <p class="text-sm text-muted-foreground">Select a learning path and preview its content</p>
        </div>
        <Button :as="RouterLinkComp" to="/my-paths" variant="outline" size="sm" class="rounded-md">
          Back to MyPaths
        </Button>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Column 1: Resource -->
        <div class="rounded-md border border-border bg-background overflow-hidden">
          <div class="p-4 border-b border-border bg-muted/30">
            <h2 class="text-foreground font-semibold">Resource</h2>
            <p class="text-sm text-muted-foreground">Preview by ID</p>
          </div>

          <div v-if="resourceLoading" class="p-6 text-sm text-muted-foreground">Loading…</div>
          <div v-else-if="resourceError" class="p-6 text-sm text-destructive">{{ resourceError }}</div>

          <div
            v-else-if="resource"
            class="p-4 space-y-3"
            :class="isDragging ? 'opacity-70' : ''"
          >
            <div class="h-36 rounded-md bg-muted overflow-hidden">
              <img :src="resource.thumbnail" :alt="resource.title" class="w-full h-full object-cover" />
            </div>
            <div class="space-y-1">
              <div class="text-foreground font-semibold">{{ resource.title }}</div>
              <div class="text-sm text-muted-foreground line-clamp-3">{{ resource.summary }}</div>
            </div>
            <div class="flex flex-wrap gap-2">
              <span class="px-2 py-1 border border-border bg-background/90 text-foreground text-xs font-semibold">{{ formatPlatform(resource.platform) }}</span>
              <span class="px-2 py-1 border border-border bg-background/90 text-foreground text-xs">{{ resource.type }}</span>
            </div>

            <div
              class="rounded-md border border-dashed border-border bg-muted/30 p-3 text-xs text-muted-foreground"
            >
              Drag the card below to Selected Path
            </div>

            <div
              class="rounded-md border border-border bg-background p-3 cursor-grab active:cursor-grabbing"
              draggable="true"
              @dragstart="onDragStart"
              @dragend="onDragEnd"
            >
              <div class="font-semibold text-foreground text-sm truncate">{{ resource.title }}</div>
              <div class="text-xs text-muted-foreground truncate">{{ resource.source_url }}</div>
            </div>
          </div>

          <div v-else class="p-6 text-sm text-muted-foreground">Resource not found (id: {{ resourceId }})</div>
        </div>

        <!-- Column 2: All LearningPaths -->
        <div class="rounded-md border border-border bg-background overflow-hidden">
          <div class="p-4 border-b border-border bg-muted/30">
            <h2 class="text-foreground font-semibold">My LearningPaths</h2>
            <p class="text-sm text-muted-foreground">Select a path</p>
          </div>

          <div v-if="paths.length === 0" class="p-6 space-y-3">
            <div class="text-sm text-foreground font-semibold">You haven't created any learning paths yet</div>
            <Button :as="RouterLinkComp" to="/createpath" size="sm" class="rounded-md bg-[#8ecbff] text-white hover:bg-[#8ecbff]/90 hover:text-white">
              Create one
            </Button>
          </div>

          <div v-else class="p-3 space-y-2">
            <button
              v-for="p in paths"
              :key="p.id"
              type="button"
              class="w-full text-left rounded-md border px-4 py-3 hover:bg-muted/30 transition"
              :class="selectedPathId === p.id ? 'border-foreground bg-muted/30' : 'border-border bg-background'"
              @click="selectedPathId = p.id"
            >
              <div class="flex items-start justify-between gap-3">
                <div class="min-w-0">
                  <div class="font-semibold text-foreground truncate">{{ p.title }}</div>
                  <div class="text-xs text-muted-foreground line-clamp-2">{{ p.description || '(No description)' }}</div>
                </div>
                <div class="text-xs text-muted-foreground shrink-0">—</div>
              </div>
            </button>
          </div>
        </div>

        <!-- Column 3: Selected LearningPath detail -->
        <div
          class="rounded-md border border-border bg-background overflow-hidden"
          @dragover.prevent
          @drop.prevent="onDrop"
        >
          <div class="p-4 border-b border-border bg-muted/30">
            <h2 class="text-foreground font-semibold">Selected Path</h2>
            <p class="text-sm text-muted-foreground">Shows the first one by default</p>
          </div>

          <div v-if="!selectedPath" class="p-6 text-sm text-muted-foreground">No learning path to display</div>

          <div v-else class="p-4 space-y-4">
            <div>
              <div class="text-lg font-semibold text-foreground">{{ selectedPath.title }}</div>
              <div class="text-sm text-muted-foreground mt-1">{{ selectedPath.description || '(No description)' }}</div>
            </div>

            <div class="flex items-center justify-between gap-3">
              <div class="text-sm text-foreground">
                <span class="font-semibold">Steps:</span>
                <span class="text-muted-foreground">Drag the resource from the left panel here, then click confirm</span>
              </div>
              <Button
                type="button"
                size="sm"
                class="rounded-md bg-[#8ecbff] text-white hover:bg-[#8ecbff]/90 hover:text-white disabled:opacity-50 disabled:cursor-not-allowed"
                :disabled="!selectedPath || !resource || !hasDraftChange || saving"
                @click="confirmAddToPath"
              >
                {{ saving ? 'Saving…' : 'Confirm add' }}
              </Button>
            </div>

            <div
              class="rounded-md border border-dashed p-3 text-sm"
              :class="isOverDropZone ? 'border-foreground bg-muted/30 text-foreground' : 'border-border bg-muted/30 text-muted-foreground'"
              @dragenter.prevent="isOverDropZone = true"
              @dragleave.prevent="isOverDropZone = false"
            >
              {{ isOverDropZone ? 'Release to add to this path' : 'Drag the resource here' }}
            </div>

            <div class="space-y-2">
              <div class="text-sm font-semibold text-foreground">Content</div>
              <div v-if="draftItems.length === 0" class="text-sm text-muted-foreground">(This path has no resources yet)</div>
              <div v-else class="space-y-2">
                <div
                  v-for="(it, idx) in draftItems"
                  :key="it.id"
                  class="space-y-2"
                >
                  <div
                    class="flex items-start gap-3 rounded-md border bg-background p-3 transition border-border"
                  >
                    <div class="h-7 w-7 rounded-md bg-muted text-foreground flex items-center justify-center text-xs font-semibold shrink-0">
                      {{ idx + 1 }}
                    </div>
                    <img :src="it.thumbnail" :alt="it.title" class="h-14 w-14 rounded-md object-cover bg-muted shrink-0" />
                    <div class="min-w-0 flex-1">
                      <div class="font-semibold text-foreground line-clamp-1">{{ it.title }}</div>
                      <div class="text-xs text-muted-foreground line-clamp-2">{{ it.summary }}</div>
                      <div class="mt-1 flex flex-wrap gap-2">
                        <span class="px-2 py-0.5 border border-border bg-background/90 text-foreground text-xs font-semibold">{{ formatPlatform(it.platform) }}</span>
                        <span class="px-2 py-0.5 border border-border bg-background/90 text-foreground text-xs">{{ it.type }}</span>
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
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { RouterLink, useRoute } from 'vue-router'

import { Button } from '../components/ui/button'

import { addResourceToMyLearningPath, listMyLearningPaths, type MyLearningPath } from '../api/learningPath'
import { getMyResourceDetail, getResourceDetail, type DbResourceDetail } from '../api/resource'
import { formatPlatform } from '../utils/platform'

const RouterLinkComp = RouterLink

const route = useRoute()

const resourceType = computed(() => (route.params.type as string) || 'document')
const resourceId = computed(() => (route.params.id as string) || '')

const resourceLoading = ref(false)
const resourceError = ref('')
type UiResource = {
  id: string
  title: string
  summary: string
  source_url: string
  type: 'video' | 'document' | 'article'
  platform: string
  thumbnail: string
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
  if (t === 'document') return 'document'
  if (t === 'article') return 'article'
  return 'article'
}

function mapDbToUi(detail: DbResourceDetail): UiResource {
  const fallbackThumb = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400&h=225&fit=crop'
  const kind = String(detail.resource_type || '').trim()
  const uiType = normalizeUiType(kind || resourceType.value)
  return {
    id: String(detail.id),
    title: String(detail.title || ''),
    summary: String((detail as any).summary || ''),
    source_url: String((detail as any).source_url || ''),
    type: uiType,
    platform: String((detail as any).platform || ''),
    thumbnail: String((detail as any).thumbnail || fallbackThumb),
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
    await addResourceToMyLearningPath(selectedPath.value.id, {
      resource_id: Number(resource.value.id),
      order_index: 1,
      is_optional: false,
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
