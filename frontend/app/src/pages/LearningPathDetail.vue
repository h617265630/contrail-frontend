<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">{{ path?.title || 'Learning Path' }}</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground whitespace-pre-wrap">
            {{ path?.description || 'This learning path is not found in the current dataset.' }}
          </p>
        </div>
        <div class="md:col-span-4 md:flex md:justify-end md:items-end">
          <div class="flex gap-2">
            <Button
              :as="RouterLinkComp"
              :to="fromMyPaths ? '/my-paths' : '/learningpool'"
              variant="outline"
              size="sm"
              class="rounded-none"
            >
              {{ fromMyPaths ? '返回 My Paths' : '返回 LearningPool' }}
            </Button>
            <Button
              type="button"
              variant="outline"
              size="sm"
              class="rounded-none"
              :class="
                fromMyPaths
                  ? 'bg-[#8ecbff] text-white hover:bg-[#8ecbff]/90 hover:text-white'
                  : 'bg-foreground text-background hover:bg-foreground/90 hover:text-background'
              "
              :disabled="fromMyPaths ? false : usingThisPath"
              @click="fromMyPaths ? startLearning() : openUseThisPath()"
            >
              {{ fromMyPaths ? 'Start' : (usingThisPath ? 'Saving…' : 'Use this path') }}
            </Button>
          </div>
        </div>
      </div>

      <div v-if="path" class="mt-6 flex flex-wrap gap-2 text-xs">
        <span class="px-2 py-1 border border-border bg-background text-foreground font-semibold">{{ path.category }}</span>
        <span class="px-2 py-1 border border-border bg-background text-muted-foreground">{{ path.level }}</span>
        <span class="px-2 py-1 border border-border bg-background text-muted-foreground">{{ path.items }} items</span>
      </div>
    </section>

    <Card as="section" :hoverable="false" class="rounded-none overflow-hidden mt-10" v-if="path">
      <div class="relative h-44 bg-muted">
        <img :src="path.thumbnail" :alt="path.title" class="w-full h-full object-cover object-center" />
        <span
          v-if="path.type"
          class="absolute right-3 top-3 px-2 py-1 rounded-full border border-border bg-background text-[10px] font-semibold tracking-[0.14em] uppercase text-foreground"
        >
          {{ path.type }}
        </span>
      </div>
    </Card>

    <section class="space-y-4">
      <div class="flex items-end justify-between gap-4">
        <div>
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">路径内容</h2>
          <p class="text-sm text-muted-foreground">{{ modules.length }} modules</p>
        </div>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Card
          v-for="m in modules"
          :key="m.id"
          as="article"
          :hoverable="true"
          class="rounded-none cursor-pointer"
          @click="openResource(m.resourceId, m.type)"
        >
          <div class="p-5">
            <div class="flex items-start justify-between gap-3">
              <div class="min-w-0">
                <h3 class="text-foreground font-semibold line-clamp-1" :title="m.title">{{ m.title }}</h3>
                <p class="text-muted-foreground text-sm mt-1 line-clamp-2" :title="m.summary">{{ m.summary }}</p>
              </div>
              <span class="px-2 py-1 text-xs font-semibold" :class="typeBadge(m.type)">
                {{ m.type }}
              </span>
            </div>
            <div class="mt-4 flex items-center justify-between text-xs text-muted-foreground">
              <span class="inline-flex items-center gap-1">
                <Clock class="w-4 h-4" />
                {{ m.duration }}
              </span>
              <span class="inline-flex items-center gap-1">
                <Layers class="w-4 h-4" />
                {{ m.level }}
              </span>
            </div>
          </div>
        </Card>
      </div>
    </section>

    <section class="space-y-4">
      <div class="flex items-end justify-between gap-4">
        <div>
          <h2 class="text-sm font-medium tracking-[0.14em] uppercase text-foreground">评论</h2>
          <p class="text-sm text-muted-foreground">{{ comments.length }} 条</p>
        </div>
      </div>

      <Card as="div" :hoverable="false" class="rounded-none">
        <div class="p-5 space-y-3">
          <textarea
            v-model="commentDraft"
            class="w-full min-h-24 p-3 rounded-none border border-border bg-background text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 focus:ring-offset-background"
            placeholder="写下你对这个 learningpath 的评论…"
          />
          <div class="flex justify-end">
            <Button
              type="button"
              variant="outline"
              size="sm"
              class="rounded-none bg-[#8ecbff] text-white hover:bg-[#8ecbff]/90 hover:text-white"
              @click="submitComment"
            >
              发布
            </Button>
          </div>
        </div>
      </Card>

      <div v-if="comments.length === 0" class="text-sm text-muted-foreground">还没有评论。</div>
      <div v-else class="space-y-3">
        <Card v-for="c in comments" :key="c.id" as="div" :hoverable="false" class="rounded-none">
          <div class="p-4">
            <div class="text-xs text-muted-foreground">{{ formatTime(c.createdAt) }}</div>
            <div class="mt-2 text-sm text-foreground whitespace-pre-wrap">{{ c.text }}</div>
          </div>
        </Card>
      </div>
    </section>

    <Card v-if="!path" as="div" :hoverable="false" class="rounded-none">
      <div class="p-5 text-sm text-muted-foreground">
        未找到该 learning path（id: {{ id }}）。你可以先从 LearningPool 里选择一个已有的卡片进入。
      </div>
    </Card>
  </div>

  <div v-if="showUseModal" class="fixed inset-0 bg-black/20 backdrop-blur-sm flex items-center justify-center p-4 z-50">
    <Card as="div" :hoverable="false" class="rounded-none max-w-md w-full">
      <div class="p-6 border-b border-border flex items-center justify-between">
        <h2 class="text-foreground text-sm font-medium tracking-[0.14em] uppercase">{{ useModalTitle }}</h2>
        <Button type="button" variant="ghost" size="icon" class="rounded-none" @click="closeUseModal" :disabled="usingThisPath" aria-label="Close">
          ×
        </Button>
      </div>

      <div class="p-6 space-y-3">
        <p class="text-foreground">{{ useModalMessage }}</p>
        <p v-if="useModalHint" class="text-sm text-muted-foreground">{{ useModalHint }}</p>
      </div>

      <div class="p-6 pt-0 flex items-center justify-end gap-3">
        <Button
          v-if="useModalState === 'confirm'"
          type="button"
          variant="outline"
          size="sm"
          class="rounded-none"
          @click="closeUseModal"
          :disabled="usingThisPath"
        >
          取消
        </Button>
        <Button
          v-if="useModalState === 'confirm'"
          type="button"
          variant="outline"
          size="sm"
          class="rounded-none bg-foreground text-background hover:bg-foreground/90 hover:text-background"
          @click="confirmUseThisPath"
          :disabled="usingThisPath"
        >
          {{ usingThisPath ? 'Saving…' : '保存到 My Paths' }}
        </Button>

        <Button
          v-else
          type="button"
          variant="outline"
          size="sm"
          class="rounded-none"
          @click="closeUseModal"
        >
          确定
        </Button>
      </div>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, watch, onMounted } from 'vue'
import { useRoute, RouterLink, useRouter } from 'vue-router'
import { BookOpen, Clock, Home as HomeIcon, Layers, Library } from 'lucide-vue-next'
import { Button } from '../components/ui/button'
import Card from '../components/ui/Card.vue'
import { getPublicLearningPathDetail, getMyLearningPathDetail, attachPublicLearningPathToMe } from '../api/learningPath'
import { getMyResourceDetail, getResourceDetail, type DbResourceDetail } from '../api/resource'

const RouterLinkComp = RouterLink

type Module = {
  id: string
  resourceId: string
  title: string
  summary: string
  type: 'video' | 'document' | 'article' | 'clip' | 'link' | 'unknown'
  duration: string
  level: 'Beginner' | 'Intermediate' | 'Advanced'
}

const route = useRoute()
const router = useRouter()
const id = computed(() => String(route.params.id || ''))

const fromMyPaths = computed(() => String(route.query.from || '') === 'my-paths')

const path = ref<any | null>(null)
const modules = ref<Module[]>([])
 
const loading = ref(false)
const error = ref('')

const resourceCache = ref<Record<string, DbResourceDetail>>({})

function _inferModuleType(item: any, r: any | null): Module['type'] {
  const presented = String(r?.resource_type || '').trim().toLowerCase()
  const raw = String(item?.resource_type || '').trim().toLowerCase()
  const candidate = presented || raw

  if (candidate === 'video') return 'video'
  if (candidate === 'document') return 'document'
  if (candidate === 'article') return 'article'
  if (candidate === 'clip') return 'clip'

  if (candidate === 'link') {
    const url = String(r?.source_url || '').trim().toLowerCase()
    const base = url.split('?', 1)[0]
    if (url.includes('youtube.com') || url.includes('youtu.be')) return 'video'
    if (base.endsWith('.pdf')) return 'document'
    return 'article'
  }

  return 'unknown'
}

async function _fetchResourceDetail(resourceId: number) {
  try {
    return await getResourceDetail(resourceId)
  } catch {
    try {
      return await getMyResourceDetail(resourceId)
    } catch {
      return null
    }
  }
}

async function hydrateMissingResourceData(detail: any) {
  const items = Array.isArray(detail?.path_items) ? detail.path_items : []
  const missing = items
    .filter((it: any) => !it?.resource_data)
    .map((it: any) => Number(it?.resource_id))
    .filter((n: number) => Number.isFinite(n) && n > 0)

  const uniq = Array.from(new Set(missing))
  if (uniq.length === 0) return

  await Promise.allSettled(
    uniq.map(async (rid) => {
      const idNumber = Number(rid)
      if (!Number.isFinite(idNumber) || idNumber <= 0) return
      const key = String(idNumber)
      if (resourceCache.value[key]) return
      const r = await _fetchResourceDetail(idNumber)
      if (r) resourceCache.value[key] = r
    }),
  )

  // Patch modules using fetched resource detail.
  modules.value = modules.value.map((m) => {
    const r = resourceCache.value[String(m.resourceId)]
    if (!r) return m
    const nextTitle = String(r.title || '').trim() || m.title
    const nextSummary = String(r.summary || '').trim() || m.summary
    const nextType = _inferModuleType({ resource_type: m.type }, r)
    return {
      ...m,
      title: nextTitle,
      summary: nextSummary,
      type: nextType,
    }
  })
}

onMounted(async () => {
  loading.value = true
  error.value = ''
  try {
    const raw = String(route.params.id || '')
    const isMy = fromMyPaths.value
    if (/^\d+$/.test(raw)) {
      const nid = Number(raw)
      const detail = isMy ? await getMyLearningPathDetail(nid) : await getPublicLearningPathDetail(nid)
      if (detail) {
        path.value = {
          id: detail.id,
          title: detail.title,
          type: String((detail as any)?.type || '').trim(),
          description: detail.description,
          thumbnail: String(detail.cover_image_url || '') || '',
          category: detail.category_name || 'Learning Path',
          level: detail.is_public ? 'Public' : 'Private',
          items: Array.isArray(detail.path_items) ? detail.path_items.length : 0,
        }

        modules.value = (detail.path_items || []).map((it: any) => {
          const r = (it?.resource_data || null) as any
          const uiType: Module['type'] = _inferModuleType(it, r)
          return {
            id: String(it.id),
            resourceId: String(it.resource_id),
            title: String(it.title || r?.title || `Resource ${it.resource_id}`),
            summary: String(r?.summary || ''),
            type: uiType,
            duration: '',
            level: 'Beginner',
          }
        })

        await hydrateMissingResourceData(detail)
        loading.value = false
        return
      }
    }
    error.value = 'Learning path not found'
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || '加载失败')
  } finally {
    loading.value = false
  }
})

const usingThisPath = ref(false)

function startLearning() {
  if (!id.value) return
  router.push({ name: 'learningpath-linear', params: { id: id.value } })
}

type UseModalState = 'confirm' | 'done' | 'error'
const showUseModal = ref(false)
const useModalState = ref<UseModalState>('confirm')
const useModalTitle = ref('Use this path')
const useModalMessage = ref('将该路径保存到你的 My Paths？')
const useModalHint = ref('')

function openUseThisPath() {
  if (fromMyPaths.value) {
    // From My Paths: UX expects Start -> linear page.
    startLearning()
    return
  }
  // Public path: confirm attach-to-me.
  showUseModal.value = true
  useModalState.value = 'confirm'
  useModalTitle.value = 'Use this path'
  useModalMessage.value = '将该路径保存到你的 My Paths？'
  useModalHint.value = '保存后可在 My Paths 中查看与编辑。'
}

function closeUseModal() {
  showUseModal.value = false
  useModalHint.value = ''
  useModalState.value = 'confirm'
}

async function confirmUseThisPath() {
  if (usingThisPath.value) return
  const raw = String(route.params.id || '').trim()
  if (!/^\d+$/.test(raw)) return

  usingThisPath.value = true
  try {
    const nid = Number(raw)
    const res = await attachPublicLearningPathToMe(nid)
    useModalState.value = 'done'
    useModalTitle.value = res?.already_exists ? '已保存' : '保存成功'
    useModalMessage.value = res?.already_exists ? '该路径已经在 My Paths 里了。' : '已保存到 My Paths。'
    useModalHint.value = ''
    const nextId = res?.learning_path?.id
    if (typeof nextId === 'number') {
      router.push({ name: 'learningpath', params: { id: String(nextId) }, query: { from: 'my-paths' } })
    }
  } catch (e: any) {
    useModalState.value = 'error'
    useModalTitle.value = '保存失败'
    useModalMessage.value = String(e?.response?.data?.detail || e?.message || '保存失败')
    useModalHint.value = ''
  } finally {
    usingThisPath.value = false
  }
}

function typeBadge(type: Module['type']) {
  switch (type) {
    case 'video':
      return 'bg-purple-50 text-purple-700'
    case 'clip':
      return 'bg-purple-50 text-purple-700'
    case 'document':
      return 'bg-blue-50 text-blue-700'
    case 'article':
      return 'bg-green-50 text-green-700'
    case 'link':
      return 'bg-gray-100 text-gray-700'
    default:
      return 'bg-gray-100 text-gray-700'
  }
}

function openResource(resourceId: string, type: Module['type'], pathItemId?: string) {
  if (!resourceId) return
  const query: Record<string, any> = {}
  if (pathItemId) query.path_item_id = String(pathItemId)

  if (type === 'video' || type === 'clip') {
    router.push({ name: 'resource-video', params: { id: String(resourceId) }, query })
    return
  }
  if (type === 'document') {
    router.push({ name: 'resource-document', params: { id: String(resourceId) }, query })
    return
  }
  router.push({ name: 'resource-article', params: { id: String(resourceId) }, query })
}
// Comments (in-memory only; no local mock data dependency)
type LearningPathComment = { id: string; text: string; createdAt: string }
const commentDraft = ref('')
const comments = ref<LearningPathComment[]>([])

watch(
  id,
  () => {
    comments.value = []
    commentDraft.value = ''
  },
  { immediate: true },
)

function submitComment() {
  const text = String(commentDraft.value || '').trim()
  if (!text) return
  comments.value = [{ id: `${Date.now()}`, text, createdAt: new Date().toISOString() }, ...comments.value]
  commentDraft.value = ''
}

function formatTime(iso: string) {
  const d = new Date(iso)
  if (Number.isNaN(d.getTime())) return iso
  return d.toLocaleString()
}
</script>
