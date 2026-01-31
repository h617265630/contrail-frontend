<template>
  <div class="min-h-screen bg-background">
    <div class="mx-auto max-w-7xl space-y-6 px-4 py-8">
      <Card :hoverable="false" padded>
        <div class="flex items-start justify-between gap-4">
          <div class="min-w-0">
            <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Edit LearningPath</h1>
            <p class="mt-2 text-sm text-muted-foreground">修改名称/介绍，并编辑学习路径中的资源。</p>
          </div>
          <Button :as="RouterLinkComp" to="/my-paths" variant="outline" size="sm" class="rounded-md">
            返回 My Paths
          </Button>
        </div>
      </Card>

      <Card v-if="!loaded" :hoverable="false" padded>
        <p class="text-sm text-muted-foreground">加载中...</p>
      </Card>

      <Card v-else-if="!exists" :hoverable="false" padded>
        <p class="text-foreground font-semibold">未找到该 LearningPath</p>
        <Button :as="RouterLinkComp" to="/my-paths" variant="link" size="sm" class="mt-2 px-0">
          返回 My Paths
        </Button>
      </Card>
      <div v-else class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Resources panel -->
        <Card as="section" :hoverable="false" padded className="space-y-4">
          <div class="flex items-center justify-between gap-3">
            <h2 class="text-lg font-semibold text-foreground">Resources</h2>
            <span class="text-sm text-muted-foreground">{{ filteredResources.length }} results</span>
          </div>

          <div class="relative">
            <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
            <Input v-model="searchQuery" type="search" placeholder="Search resources..." class="h-9 rounded-md pl-9" />
          </div>

          <div class="max-h-130 overflow-y-auto pr-1 space-y-3">
            <article
              v-for="r in filteredResources"
              :key="r.id"
              class="border border-border rounded-md overflow-hidden transition bg-card text-card-foreground hover:bg-muted/20"
              draggable="true"
              @dragstart="handleDragStart($event, r)"
            >
              <div class="flex gap-3 p-3">
                <img :src="r.thumbnail" :alt="r.title" class="w-24 h-16 object-cover rounded-md bg-muted shrink-0" />
                <div class="min-w-0 flex-1">
                  <div class="flex items-start justify-between gap-2">
                    <h3 class="text-foreground font-semibold text-sm line-clamp-1" :title="r.title">{{ r.title }}</h3>
                    <span class="px-2 py-1 rounded-full text-xs font-semibold" :class="typeBadge(r.type)">{{ r.type }}</span>
                  </div>
                  <p class="text-muted-foreground text-xs mt-1 line-clamp-2">{{ r.summary }}</p>
                  <div class="mt-2 flex flex-wrap gap-2 text-xs text-muted-foreground">
                    <span class="px-2 py-1 rounded-full bg-muted text-foreground">{{ r.category }}</span>
                  </div>
                </div>
              </div>
              <div class="border-t border-border p-3 flex items-center justify-between">
                <span class="text-xs text-muted-foreground">拖拽到右侧学习路径区域</span>
                <Button type="button" variant="outline" size="sm" class="rounded-md" @click="addResource(r)">
                  <Plus class="w-3.5 h-3.5" />
                  添加
                </Button>
              </div>
            </article>
          </div>
        </Card>

        <!-- Builder panel -->
        <Card as="section" :hoverable="false" padded className="space-y-4" @dragover.prevent @drop="onDrop">
          <div class="flex items-center justify-between gap-3">
            <div class="min-w-0">
              <h2 class="text-lg font-semibold text-foreground">LearningPath Builder</h2>
              <p class="text-sm text-muted-foreground">
                <span>{{ selected.length }} items</span>
              </p>
            </div>
            <Button
              type="button"
              variant="outline"
              size="sm"
              class="rounded-md"
              @click="clearSelected"
              :disabled="selected.length === 0"
            >
              清空
            </Button>
          </div>

          <div class="rounded-md border border-border p-4 bg-muted/20 space-y-3">
            <div>
              <label class="block text-sm font-semibold text-foreground mb-2">名称 *</label>
              <Input v-model="meta.title" type="text" placeholder="例如：AI Engineer Starter" class="h-9 rounded-md bg-background" />
            </div>
            <div>
              <label class="block text-sm font-semibold text-foreground mb-2">介绍</label>
              <textarea
                v-model="meta.description"
                rows="3"
                placeholder="简要介绍这个学习路径的目标与内容"
                class="w-full px-3 py-2 border border-input rounded-md bg-background text-sm text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background resize-none"
              />
            </div>

            <div>
              <label class="block text-sm font-semibold text-foreground mb-2">封面</label>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div class="rounded-md border border-border bg-background overflow-hidden">
                  <div class="aspect-video bg-muted">
                    <img
                      v-if="meta.coverImageUrl"
                      :src="meta.coverImageUrl"
                      alt="Selected cover"
                      class="w-full h-full object-cover"
                    />
                    <div v-else class="w-full h-full flex items-center justify-center text-sm text-muted-foreground">
                      未选择封面
                    </div>
                  </div>
                  <div class="p-3">
                    <p class="text-xs text-muted-foreground">左侧为当前选择的封面预览</p>
                  </div>
                </div>

                <div class="rounded-md border border-border bg-background p-3">
                  <div v-if="uploadedCoverUrl" class="space-y-3">
                    <button
                      type="button"
                      class="w-full rounded-md overflow-hidden border-2"
                      :class="meta.coverImageUrl === uploadedCoverUrl ? 'border-primary' : 'border-border hover:border-muted-foreground/30'"
                      @click="selectCover(uploadedCoverUrl)"
                    >
                      <div class="aspect-video bg-muted">
                        <img :src="uploadedCoverUrl" alt="Uploaded cover" class="w-full h-full object-cover" />
                      </div>
                    </button>
                  </div>

                  <div v-else class="grid grid-cols-4 sm:grid-cols-5 gap-2">
                    <button
                      v-for="(u, idx) in defaultCoverUrls"
                      :key="idx"
                      type="button"
                      class="rounded-md overflow-hidden border-2"
                      :class="meta.coverImageUrl === u ? 'border-primary' : 'border-border hover:border-muted-foreground/30'"
                      @click="selectCover(u)"
                    >
                      <div class="aspect-video bg-muted">
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
                    <Button type="button" variant="outline" size="sm" class="rounded-md" @click="openCoverFilePicker">
                      上传图片
                    </Button>
                    <p class="text-xs text-muted-foreground">上传后右侧仅显示上传图</p>
                  </div>
                </div>
              </div>
            </div>

            <div>
              <label class="block text-sm font-semibold text-foreground mb-2">分类</label>
              <select
                v-model.number="meta.categoryId"
                class="w-full h-9 px-3 border border-input rounded-md bg-background text-sm text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background disabled:opacity-50"
                :disabled="categoriesLoading || categories.length === 0"
              >
                <option :value="null">未选择</option>
                <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
              </select>
              <p v-if="categoriesError" class="text-xs text-destructive mt-2">{{ categoriesError }}</p>
              <p v-else class="text-xs text-muted-foreground mt-2">从数据库读取分类（可不选）。</p>
            </div>

            <div class="flex items-center justify-between gap-3">
              <div class="min-w-0">
                <div class="text-sm font-semibold text-foreground">是否公开</div>
                <div class="text-xs text-muted-foreground">公开：会出现在 LearningPool；私有：仅自己可见</div>
              </div>
              <Button type="button" variant="outline" size="sm" class="rounded-md" @click="meta.isPublic = !meta.isPublic">
                <span>{{ meta.isPublic ? 'Public' : 'Private' }}</span>
                <span
                  class="relative h-5 w-9 rounded-full transition-colors"
                  :class="meta.isPublic ? 'bg-primary' : 'bg-muted-foreground/30'"
                >
                  <span
                    class="absolute left-0.5 top-0.5 h-4 w-4 rounded-full bg-white transition-transform"
                    :class="meta.isPublic ? 'translate-x-0' : 'translate-x-4'"
                  />
                </span>
              </Button>
            </div>
          </div>

          <div
            class="rounded-md border-2 border-dashed p-4"
            :class="selected.length ? 'border-border bg-muted/20' : 'border-primary/30 bg-primary/5'"
          >
            <div v-if="selected.length === 0" class="text-sm text-muted-foreground">将左侧资源拖拽到这里，或点击“添加”。</div>

            <div v-else class="space-y-2">
              <div v-for="(r, idx) in selected" :key="r.id" class="space-y-2">
                <article
                  :class="[
                    'rounded-md border p-3 flex gap-3 transition',
                    selectedDragState.draggingId === r.id
                      ? 'bg-pink-50/60 backdrop-blur-md border-pink-200/60'
                      : 'bg-card border-border',
                  ]"
                  draggable="true"
                  @dragstart="onSelectedDragStart($event, r.id, idx)"
                  @dragend="onSelectedDragEnd"
                  @dragover.prevent="onSelectedDragOver(idx)"
                  @drop.prevent="onSelectedDrop($event, idx)"
                >
                  <div
                    class="w-8 h-8 rounded-md bg-muted text-foreground flex items-center justify-center text-xs font-semibold shrink-0"
                  >
                    {{ idx + 1 }}
                  </div>
                  <img :src="r.thumbnail" :alt="r.title" class="w-24 h-16 object-cover rounded-md bg-muted shrink-0" />
                  <div class="min-w-0 flex-1">
                    <div class="flex items-center justify-between gap-2">
                      <h3 class="text-foreground font-semibold text-sm line-clamp-1">{{ r.title }}</h3>
                      <button type="button" class="text-muted-foreground hover:text-foreground" @click="removeResource(r.id)" aria-label="Remove">
                        <X class="w-4 h-4" />
                      </button>
                    </div>
                    <p class="text-muted-foreground text-xs mt-1 line-clamp-2">{{ r.summary }}</p>
                    <div class="mt-2 flex flex-wrap gap-2 text-xs text-muted-foreground">
                      <span class="px-2 py-1 rounded-full bg-muted text-foreground">{{ r.category }}</span>
                      <span class="px-2 py-1 rounded-full text-xs font-semibold" :class="typeBadge(r.type)">{{ r.type }}</span>
                    </div>
                  </div>
                </article>

                <div
                  v-if="idx !== selected.length - 1"
                  class="flex justify-center text-muted-foreground/50"
                  @dragover.prevent
                  @drop.prevent="onSelectedDrop($event, idx + 1)"
                >
                  <ChevronDown class="w-5 h-5" />
                </div>
              </div>
            </div>
          </div>

          <div class="pt-2">
            <Button type="button" class="w-full rounded-md" :disabled="!meta.title.trim()" @click="save">
              保存修改
            </Button>
          </div>
        </Card>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import { ChevronDown, Plus, Search, X } from 'lucide-vue-next'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import {
  addResourceToMyLearningPath,
  getMyLearningPathDetail,
  removeResourceFromMyLearningPath,
  updateMyLearningPath as updateMyLearningPathDb,
} from '../api/learningPath'
import { listMyResources, type DbResource } from '../api/resource'
import { listCategories, type Category } from '../api/category'

const RouterLinkComp = RouterLink

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
  type: ResourceType
  category: string
  thumbnail: string
}

const route = useRoute()
const router = useRouter()

const loaded = ref(false)
const exists = ref(false)

const categories = ref<Category[]>([])
const categoriesLoading = ref(false)
const categoriesError = ref('')

const allResources = ref<UiResource[]>([])
const searchQuery = ref('')

const filteredResources = computed(() => {
  const q = searchQuery.value.trim().toLowerCase()
  if (!q) return allResources.value
  return allResources.value.filter(r => r.title.toLowerCase().includes(q) || r.summary.toLowerCase().includes(q))
})

const selected = ref<UiResource[]>([])
const meta = reactive<PathMeta>({ title: '', description: '', isPublic: true, categoryId: null, coverImageUrl: '' })

const coverFileInput = ref<HTMLInputElement | null>(null)
const uploadedCoverUrl = ref<string>('')

function makeCoverSvg(seed: number) {
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
  meta.coverImageUrl = String(url || '').trim()
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

const idNum = computed(() => {
  const raw = String(route.params.id || '').trim()
  const n = Number(raw)
  return Number.isFinite(n) ? n : NaN
})

async function loadCategories() {
  categoriesLoading.value = true
  categoriesError.value = ''
  try {
    categories.value = await listCategories()
  } catch (e: any) {
    categories.value = []
    categoriesError.value = String(e?.response?.data?.detail || e?.message || '加载分类失败')
  } finally {
    categoriesLoading.value = false
  }
}

const selectedDragState = reactive({
  draggingId: -1 as number,
  fromIndex: -1 as number,
  overIndex: -1 as number,
})

function normalizePresentedType(raw: unknown): ResourceType {
  const t = String(raw || '').trim().toLowerCase()
  if (t === 'video') return 'video'
  if (t === 'document') return 'document'
  if (t === 'article') return 'article'
  if (t === 'clip') return 'clip'
  if (t === 'link') return 'link'
  return 'link'
}

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

function mapDbResourceToUi(r: any): UiResource {
  return {
    id: Number(r.id),
    title: String(r.title || '').trim() || `Resource ${r.id}`,
    summary: String(r.summary || '').trim(),
    type: normalizePresentedType((r as any)?.resource_type),
    category: String((r as any)?.category_name || r.category || 'Uncategorized'),
    thumbnail: String((r as any)?.thumbnail || '').trim(),
  }
}

async function loadResources() {
  try {
    const rows = await listMyResources()
    allResources.value = Array.isArray(rows) ? rows.map(mapDbResourceToUi) : []
  } catch {
    allResources.value = []
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
  if (e.dataTransfer) e.dataTransfer.effectAllowed = 'copy'
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

  moveSelected(fromIndex, dropIndex)
}

function onSelectedDragEnd() {
  selectedDragState.draggingId = -1
  selectedDragState.fromIndex = -1
  selectedDragState.overIndex = -1
}

async function save() {
  if (!meta.title.trim()) return

  const lpId = Number(idNum.value)
  if (!Number.isFinite(lpId) || lpId <= 0) return

  // Rule: cover uses first item thumbnail.
  const coverUrl = String(selected.value[0]?.thumbnail || '').trim() || null
  if (coverUrl) selectCover(coverUrl)

  // 1) Persist meta to backend so LearningPool can see public paths.
  try {
    await updateMyLearningPathDb(lpId, {
      title: meta.title,
      description: meta.description,
      is_public: meta.isPublic,
      cover_image_url: coverUrl,
      category_id: meta.categoryId,
    })
  } catch (e: any) {
    alert(String(e?.response?.data?.detail || e?.message || '保存失败'))
    return
  }

  // 2) Rebuild items to match current selection + order.
  try {
    const detail = await getMyLearningPathDetail(lpId)
    const existing = Array.isArray((detail as any)?.path_items) ? (detail as any).path_items : []
    for (const it of existing) {
      const rid = Number((it as any)?.resource_id)
      if (Number.isFinite(rid) && rid > 0) {
        await removeResourceFromMyLearningPath(lpId, rid)
      }
    }

    for (let i = 0; i < selected.value.length; i++) {
      const r = selected.value[i]
      await addResourceToMyLearningPath(lpId, {
        resource_id: r.id,
        order_index: i + 1,
        is_optional: false,
      })
    }
  } catch (e: any) {
    alert(String(e?.response?.data?.detail || e?.message || '保存路径内容失败'))
    return
  }

  router.push({ name: 'my-paths' })
}

async function load() {
  loaded.value = false
  exists.value = false

  if (!meta.coverImageUrl) selectCover(defaultCoverUrls[0] || '')

  const lpId = Number(idNum.value)
  if (!Number.isFinite(lpId) || lpId <= 0) {
    loaded.value = true
    exists.value = false
    return
  }

  await Promise.all([loadCategories(), loadResources()])

  try {
    const db = await getMyLearningPathDetail(lpId)
    exists.value = true
    meta.title = String((db as any)?.title || '')
    meta.description = String((db as any)?.description || '')
    meta.isPublic = Boolean((db as any)?.is_public)
    meta.categoryId = ((db as any)?.category_id ?? null) as any

    const cover = String((db as any)?.cover_image_url || '').trim()
    if (cover) selectCover(cover)

    const byId = new Map(allResources.value.map(r => [r.id, r]))
    const items = Array.isArray((db as any)?.path_items) ? (db as any).path_items : []
    const next: UiResource[] = []
    for (const it of items) {
      const rid = Number((it as any)?.resource_id)
      const rdata = (it as any)?.resource_data
      if (rdata && typeof rdata === 'object') {
        next.push({
          id: rid,
          title: String((rdata as any)?.title || `Resource ${rid}`),
          summary: String((rdata as any)?.summary || ''),
          type: normalizePresentedType((rdata as any)?.resource_type),
          category: String((rdata as any)?.category_name || (rdata as any)?.category || 'Uncategorized'),
          thumbnail: String((rdata as any)?.thumbnail || '').trim(),
        })
      } else {
        const hit = byId.get(rid)
        if (hit) next.push(hit)
      }
    }
    selected.value = next

    const firstThumb = String(selected.value[0]?.thumbnail || '').trim()
    if (firstThumb) selectCover(firstThumb)
  } catch {
    exists.value = false
  } finally {
    loaded.value = true
  }
}

onMounted(() => {
  void load()
})
</script>
