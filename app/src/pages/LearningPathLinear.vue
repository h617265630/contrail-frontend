<template>
  <div class="mx-auto max-w-7xl space-y-6 px-4 py-6">
    <section class="pb-0">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">{{ path?.title || learningPath.title }}</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground whitespace-pre-wrap">
            {{ path?.description || learningPath.description }}
          </p>
        </div>
        <div class="md:col-span-4 md:flex md:justify-end md:items-end">
          <div class="text-right">
            <p class="text-xs font-medium tracking-[0.14em] uppercase text-muted-foreground">Overall Progress</p>
            <p class="mt-2 text-2xl font-semibold text-foreground">{{ learningPath.totalProgress }}%</p>
          </div>
        </div>
      </div>

      <div v-if="path" class="mt-6 flex flex-wrap gap-2 text-xs">
        <span class="px-2 py-1 border border-border bg-background text-foreground font-semibold">{{ path.category }}</span>
        <span class="px-2 py-1 border border-border bg-background text-muted-foreground">{{ path.level }}</span>
        <span class="px-2 py-1 border border-border bg-background text-muted-foreground">{{ path.items }} items</span>
      </div>

      <div class="mt-6">
        <div class="h-2 w-full bg-muted">
          <div class="h-2 bg-foreground transition-all duration-300" :style="{ width: `${learningPath.totalProgress}%` }" />
        </div>
      </div>
    </section>

    <Card as="section" :hoverable="false" className="-mt-6 rounded-none overflow-hidden" v-if="path">
      <div class="relative h-56 md:h-64 bg-muted">
        <img :src="path.thumbnail" :alt="path.title" class="w-full h-full object-cover" />
        <span
          v-if="path.type"
          class="absolute right-3 top-3 px-2 py-1 rounded-full border border-border bg-background text-[10px] font-semibold tracking-[0.14em] uppercase text-foreground"
        >
          {{ path.type }}
        </span>
      </div>
    </Card>

      <!-- Learning Path Timeline (from temp.vue) -->
      <div class="relative">
        <!-- Vertical Line -->
        <div class="absolute left-6 top-0 bottom-0 w-0.5 bg-border" />

        <!-- Path Items -->
        <div class="space-y-8">
          <div v-for="(item, index) in learningPath.items" :key="item.id">
            <div class="relative pl-16">
              <!-- Timeline Node -->
              <div class="absolute left-0 top-6 w-12 h-12 flex items-center justify-center">
                <div
                  class="w-12 h-12 rounded-full flex items-center justify-center"
                  :class="
                    item.completed
                      ? 'bg-foreground text-background'
                      : item.progress > 0
                        ? 'bg-foreground text-background'
                        : 'bg-background border-4 border-border text-muted-foreground'
                  "
                >
                  <CheckCircle2 v-if="item.completed" class="w-6 h-6" />
                  <Circle v-else class="w-6 h-6" />
                </div>
              </div>

              <!-- Card Content - 水平分为左右两个子卡片 -->
              <Card :hoverable="false" class="rounded-none overflow-hidden">
                <div class="grid grid-cols-1 lg:grid-cols-2 divide-y lg:divide-y-0 lg:divide-x divide-border">
                  <!-- 左边的Card - 内容展示 -->
                  <div class="p-6">
                    <!-- 缩略图 -->
                    <div
                      class="relative mb-4 overflow-hidden bg-muted group cursor-pointer"
                      role="button"
                      tabindex="0"
                      @click="goToResource(item)"
                      @keydown.enter.prevent="goToResource(item)"
                      @keydown.space.prevent="goToResource(item)"
                    >
                      <img :src="item.thumbnail" :alt="item.title" class="w-full h-48 object-cover" />

                      <!-- 视频播放图标覆盖层 -->
                      <div
                        v-if="item.type === 'video'"
                        class="absolute inset-0 bg-black/30 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity"
                      >
                        <div class="w-16 h-16 bg-background rounded-full flex items-center justify-center">
                          <Play class="w-8 h-8 text-foreground ml-1" />
                        </div>
                      </div>

                      <!-- 类型标签 -->
                      <div class="absolute top-3 left-3">
                        <div class="px-3 py-1 rounded-full flex items-center gap-2" :class="typeColor(item.type)">
                          <component :is="typeIcon(item.type)" class="w-5 h-5" />
                          <span class="text-sm capitalize">{{ item.type }}</span>
                        </div>
                      </div>
                    </div>

                    <!-- 标题和描述 -->
                    <div class="mb-4">
                      <h3 class="text-foreground mb-2">{{ item.title }}</h3>
                      <p class="text-sm text-muted-foreground">{{ item.summary }}</p>
                    </div>

                    <!-- Continue Learning 按钮 -->
                    <Button type="button" class="w-full rounded-none" @click="goToResource(item)">
                      <Play v-if="item.type === 'video'" class="w-4 h-4" />
                      {{ item.progress === 0 ? 'Start Learning' : 'Continue Learning' }}
                    </Button>
                  </div>

                  <!-- 右边的Card - 进度和笔记 -->
                  <div class="p-6 bg-muted/30">
                    <!-- 学习进度 -->
                    <div class="mb-6">
                      <h4 class="text-foreground mb-3">Learning Progress</h4>

                      <!-- 进度条 -->
                      <div class="mb-4">
                        <div class="flex items-center justify-between mb-2">
                          <span class="text-sm text-muted-foreground">Completion</span>
                          <span class="text-sm text-foreground">{{ item.progress }}%</span>
                        </div>
                        <div class="h-2 w-full bg-muted">
                          <div
                            class="h-2 transition-all duration-300"
                            :class="item.completed ? 'bg-foreground' : 'bg-foreground'"
                            :style="{ width: `${item.progress}%` }"
                          />
                        </div>
                      </div>

                      <!-- 详细进度信息 -->
                      <div class="space-y-2">
                        <div v-if="item.type === 'video'" class="flex items-center justify-between text-sm">
                          <span class="text-muted-foreground">Duration:</span>
                          <span class="text-foreground">{{ item.duration || '—' }}</span>
                        </div>
                        <div v-else class="flex items-center justify-between text-sm">
                          <span class="text-muted-foreground">Pages:</span>
                          <span class="text-foreground">{{ typeof item.totalPages === 'number' ? item.totalPages : '—' }}</span>
                        </div>

                        <div class="flex items-center justify-between text-sm">
                          <span class="text-muted-foreground">Status:</span>
                          <span
                            class="px-2 py-1 border border-border bg-background text-xs"
                            :class="
                              item.completed
                                ? 'text-foreground'
                                : item.progress > 0
                                  ? 'text-foreground'
                                  : 'text-muted-foreground'
                            "
                          >
                            {{ item.completed ? 'Completed' : item.progress > 0 ? 'In Progress' : 'Not Started' }}
                          </span>
                        </div>
                      </div>
                    </div>

                    <!-- 笔记区域 -->
                    <div>
                      <div class="flex items-center gap-2 mb-3">
                        <StickyNote class="w-4 h-4 text-muted-foreground" />
                        <h4 class="text-foreground">My Notes</h4>
                      </div>

                      <div v-if="editingNotes === item.id">
                        <textarea
                          v-model="noteDraft"
                          class="w-full resize-none border border-border bg-background p-3 text-sm text-foreground outline-none transition placeholder:text-muted-foreground focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background rounded-none"
                          rows="6"
                          placeholder="Add your notes here..."
                        />
                        <div class="flex gap-2 mt-2">
                          <Button type="button" size="sm" class="rounded-none" @click="saveNotes(item.id)">Save</Button>
                          <Button type="button" variant="outline" size="sm" class="rounded-none" @click="cancelNotes()">Cancel</Button>
                        </div>
                      </div>

                      <div v-else class="cursor-pointer" @click="startEdit(item.id)">
                        <div
                          v-if="item.notes"
                          class="min-h-30 whitespace-pre-wrap border border-border bg-muted/30 p-3 text-sm text-foreground"
                        >
                          {{ item.notes }}
                        </div>
                        <div
                          v-else
                          class="min-h-30 flex items-center justify-center border border-dashed border-border p-3 text-sm text-muted-foreground"
                        >
                          Click to add notes...
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </Card>
            </div>

            <!-- Arrow between cards -->
            <div v-if="index < learningPath.items.length - 1" class="relative pl-16 py-4">
              <div class="absolute left-6 top-0 bottom-0 flex items-center justify-center">
                <div class="flex flex-col items-center">
                  <ArrowDown class="w-6 h-6 text-muted-foreground animate-bounce" />
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Completion Celebration - 祝福语 -->
        <div class="relative pl-16 mt-8">
          <div class="absolute left-0 top-6 w-12 h-12 flex items-center justify-center">
            <div
              class="w-12 h-12 rounded-full flex items-center justify-center bg-foreground text-background"
            >
              <Award class="w-6 h-6" />
            </div>
          </div>

          <Card :hoverable="false" class="rounded-none p-8">
            <div class="text-center">
              <div class="flex items-center justify-center gap-2 mb-4">
                <Sparkles class="w-6 h-6 text-muted-foreground" />
                <h2 class="text-foreground">Congratulations!</h2>
                <Sparkles class="w-6 h-6 text-muted-foreground" />
              </div>

              <p class="text-foreground mb-4 text-lg">您已完成整个学习路径的旅程！</p>

              <div class="space-y-2 text-muted-foreground mb-6">
                <p>
                  从这里开始，您已经掌握了 <span class="text-foreground">{{ learningPath.title }}</span> 的所有核心知识。
                </p>
                <p>每一步的努力都值得骄傲，每一个笔记都是您成长的见证。</p>
                <p class="text-foreground">继续保持这份热情，将所学应用到实践中，创造属于您的精彩项目！</p>
              </div>

              <div class="flex flex-wrap items-center justify-center gap-2">
                <Button type="button" size="sm" class="rounded-none">
                  <Award class="w-4 h-4" />
                  View Certificate
                </Button>
                <Button type="button" variant="outline" size="sm" class="rounded-none">Start New Path</Button>
              </div>
            </div>
          </Card>
        </div>
      </div>
    </div>
</template>

<script setup lang="ts">
import { computed, onBeforeUnmount, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import {
  ArrowDown,
  Award,
  BookOpen,
  CheckCircle2,
  Circle,
  FileText,
  Play,
  Sparkles,
  StickyNote,
  Video,
} from 'lucide-vue-next'
import { getMyLearningPathDetail, type MyLearningPathDetail } from '../api/learningPath'
import { getMyResourceDetail, type DbResourceDetail } from '../api/resource'
import { listMyProgressForLearningPath, type ProgressRow } from '../api/progress'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'

type PathItem = {
  id: number
  resourceId: number
  title: string
  summary: string
  type: 'video' | 'document' | 'article'
  duration: string
  progress: number
  notes: string
  completed: boolean
  thumbnail: string
  currentPage?: number
  totalPages?: number
}

type LearningPathData = {
  id: number
  title: string
  description: string
  totalProgress: number
  items: PathItem[]
}

const route = useRoute()
const router = useRouter()
const idRaw = computed(() => String(route.params.id || '').trim())
const learningPathId = computed(() => {
  if (!/^\d+$/.test(idRaw.value)) return null
  const n = Number(idRaw.value)
  return Number.isFinite(n) ? n : null
})

const loading = ref(false)
const error = ref('')

const lp = ref<MyLearningPathDetail | null>(null)
const resourcesById = ref<Record<number, DbResourceDetail>>({})
const progressByPathItemId = ref<Record<number, number>>({})

function asPresentedType(raw: unknown): PathItem['type'] {
  const t = String(raw || '').toLowerCase().trim()
  if (t === 'document') return 'document'
  if (t === 'article') return 'article'
  return 'video'
}

function getEmbeddedResource(it: any): DbResourceDetail | null {
  const r = it?.resource_data
  return r && typeof r === 'object' ? (r as DbResourceDetail) : null
}

const path = computed(() => {
  if (!lp.value) return null
  const firstItem: any = lp.value.path_items?.[0]
  const cover = getEmbeddedResource(firstItem) || (firstItem?.resource_id ? resourcesById.value[Number(firstItem.resource_id)] : undefined)
  return {
    id: lp.value.id,
    title: lp.value.title,
    description: lp.value.description || '',
    thumbnail: (cover?.thumbnail || '').trim(),
    type: String((lp.value as any)?.type || '').trim(),
    category: lp.value.category_name || 'My Paths',
    level: lp.value.is_public ? 'Public' : 'Private',
    items: (lp.value.path_items || []).length,
  }
})

const notesByPathItemId = ref<Record<number, string>>({})

const editingNotes = ref<number | null>(null)
const noteDraft = ref('')

watch(
  idRaw,
  () => {
    editingNotes.value = null
    noteDraft.value = ''
  },
  { immediate: true },
)

const learningPath = computed<LearningPathData>(() => {
  const title = path.value?.title || 'Learning Path'
  const description = path.value?.description || ''

  const items: PathItem[] = (lp.value?.path_items || [])
    .slice()
    .sort((a, b) => (a.order_index || 0) - (b.order_index || 0))
    .map((it) => {
      const embedded = getEmbeddedResource(it as any)
      const res = embedded || resourcesById.value[it.resource_id]
      const type = asPresentedType(res?.resource_type || (it as any).resource_type)

      const pid = Number(it.id)
      const progress = progressByPathItemId.value[pid] ?? 0

      return {
        id: pid,
        resourceId: Number(it.resource_id),
        title: String(res?.title || it.title || `Resource ${it.resource_id}`),
        summary: String(res?.summary || ''),
        type,
        duration: type === 'video' ? '—' : '—',
        progress,
        notes: notesByPathItemId.value[pid] ?? '',
        completed: progress >= 100,
        thumbnail: (res?.thumbnail || '').trim() || 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400&h=225&fit=crop',
      }
    })

  const totalProgress = items.length
    ? Math.round(items.reduce((sum, item) => sum + item.progress, 0) / items.length)
    : 0

  return {
    id: lp.value?.id || 0,
    title,
    description,
    totalProgress,
    items,
  }
})

function startEdit(itemId: number) {
  editingNotes.value = itemId
  noteDraft.value = notesByPathItemId.value[itemId] || ''
}

function saveNotes(itemId: number) {
  notesByPathItemId.value = {
    ...notesByPathItemId.value,
    [itemId]: noteDraft.value,
  }
  editingNotes.value = null
  noteDraft.value = ''
}

function cancelNotes() {
  editingNotes.value = null
  noteDraft.value = ''
}

function typeIcon(type: PathItem['type']) {
  switch (type) {
    case 'video':
      return Video
    case 'document':
      return FileText
    case 'article':
      return BookOpen
  }
}

function typeColor(type: PathItem['type']) {
  switch (type) {
    case 'video':
      return 'bg-purple-100 text-purple-600'
    case 'document':
      return 'bg-blue-100 text-blue-600'
    case 'article':
      return 'bg-green-100 text-green-600'
  }
}

function goToResource(item: PathItem) {
  const name = item.type === 'video' ? 'resource-video' : item.type === 'document' ? 'resource-document' : 'resource-article'
  router.push({
    name,
    params: { id: String(item.resourceId) },
    query: { path_item_id: String(item.id), learning_path_id: String(learningPathId.value || '') },
  })
}

let pollTimer: number | null = null

async function refreshProgress() {
  const lid = learningPathId.value
  if (!lid) return
  try {
    const rows = await listMyProgressForLearningPath(lid)
    const next: Record<number, number> = {}
    for (const r of rows || []) {
      next[Number((r as ProgressRow).path_item_id)] = Number((r as ProgressRow).progress_percentage) || 0
    }
    progressByPathItemId.value = next
  } catch {
    // ignore polling errors
  }
}

async function load() {
  error.value = ''
  loading.value = true
  try {
    const lid = learningPathId.value
    if (!lid) throw new Error('Invalid learning path id')

    lp.value = await getMyLearningPathDetail(lid)

    // Progress first (so UI paints quickly)
    await refreshProgress()

    // Prefer embedded resource_data from learning path detail; only fetch missing details.
    const embeddedMap: Record<number, DbResourceDetail> = {}
    const missing: number[] = []
    for (const it of lp.value.path_items || []) {
      const rid = Number((it as any).resource_id)
      if (!rid) continue
      const embedded = getEmbeddedResource(it as any)
      if (embedded) embeddedMap[rid] = embedded
      else missing.push(rid)
    }

    const uniqueMissing = Array.from(new Set(missing))
    const fetchedPairs = await Promise.all(
      uniqueMissing.map(async (rid) => {
        const r = await getMyResourceDetail(rid)
        return [rid, r] as const
      }),
    )
    for (const [rid, r] of fetchedPairs) embeddedMap[rid] = r
    resourcesById.value = embeddedMap
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || 'Failed to load learning path')
    lp.value = null
    resourcesById.value = {}
    progressByPathItemId.value = {}
  } finally {
    loading.value = false
  }
}

watch(
  learningPathId,
  async () => {
    if (pollTimer != null) {
      window.clearInterval(pollTimer)
      pollTimer = null
    }
    await load()
    pollTimer = window.setInterval(() => {
      void refreshProgress()
    }, 10_000)
  },
  { immediate: true },
)

onBeforeUnmount(() => {
  if (pollTimer != null) {
    window.clearInterval(pollTimer)
    pollTimer = null
  }
})
</script>
