<template>
  <div class="min-h-screen bg-gray-50">

    
    <div class="p-6">
      <div class="max-w-5xl mx-auto space-y-8">
      <div class="bg-white rounded-2xl shadow-xl overflow-hidden">
        <div class="h-44 bg-gray-100">
          <img v-if="path" :src="path.thumbnail" :alt="path.title" class="w-full h-full object-cover" />
        </div>
        <div class="p-8">
          <div class="flex flex-col md:flex-row md:items-start md:justify-between gap-4">
            <div class="min-w-0">
              <h1 class="text-gray-900 mb-2">{{ path?.title || 'Learning Path' }}</h1>
              <p class="text-gray-600 whitespace-pre-wrap">{{ path?.description || 'This learning path is not found in the current dataset.' }}</p>
              <div class="mt-4 flex flex-wrap gap-2 text-sm">
                <span v-if="path" class="px-3 py-1 rounded-full bg-blue-50 text-blue-700 font-semibold">{{ path.category }}</span>
                <span v-if="path" class="px-3 py-1 rounded-full bg-gray-100 text-gray-700">{{ path.level }}</span>
                <span v-if="path" class="px-3 py-1 rounded-full bg-green-50 text-green-700">{{ path.items }} items</span>
              </div>
            </div>
            <div class="flex gap-2">
              <RouterLink
                :to="fromMyPaths ? '/my-paths' : '/learningpool'"
                class="px-4 py-2 rounded-lg flex items-center gap-2 transition-colors text-gray-600 hover:bg-gray-100"
              >
                {{ fromMyPaths ? '返回 My Paths' : '返回 LearningPool' }}
              </RouterLink>
              <button
                type="button"
                class="px-4 py-2 rounded-lg flex items-center gap-2 transition-colors bg-blue-600 text-white hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
                :disabled="fromMyPaths ? false : usingThisPath"
                @click="fromMyPaths ? startLearning() : openUseThisPath()"
              >
                {{ fromMyPaths ? 'Start' : (usingThisPath ? 'Saving…' : 'Use this path') }}
              </button>
            </div>
          </div>
        </div>
      </div>

      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <h2 class="text-xl font-semibold text-gray-900">路径内容</h2>
          <span class="text-sm text-gray-500">{{ modules.length }} modules</span>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <article
            v-for="m in modules"
            :key="m.id"
            class="bg-white rounded-xl shadow-lg p-5 cursor-pointer hover:shadow-xl transition"
            @click="openResource(m.resourceId, m.type)"
          >
            <div class="flex items-start justify-between gap-3">
              <div class="min-w-0">
                <h3 class="text-gray-900 font-semibold line-clamp-1" :title="m.title">{{ m.title }}</h3>
                <p class="text-gray-600 text-sm mt-1 line-clamp-2" :title="m.description">{{ m.description }}</p>
              </div>
              <span class="px-2 py-1 rounded-full text-xs font-semibold" :class="typeBadge(m.type)">
                {{ m.type }}
              </span>
            </div>
            <div class="mt-4 flex items-center justify-between text-xs text-gray-500">
              <span class="inline-flex items-center gap-1">
                <Clock class="w-4 h-4" />
                {{ m.duration }}
              </span>
              <span class="inline-flex items-center gap-1">
                <Layers class="w-4 h-4" />
                {{ m.level }}
              </span>
            </div>
          </article>
        </div>
      </section>

      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <h2 class="text-xl font-semibold text-gray-900">评论</h2>
          <span class="text-sm text-gray-500">{{ comments.length }} 条</span>
        </div>

        <div class="bg-white rounded-xl border border-gray-200 p-5 space-y-3">
          <textarea
            v-model="commentDraft"
            class="w-full min-h-24 p-3 rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm text-gray-900"
            placeholder="写下你对这个 learningpath 的评论…"
          />
          <div class="flex justify-end">
            <button
              type="button"
              class="px-4 py-2 rounded-lg bg-blue-600 text-white font-semibold hover:bg-blue-700"
              @click="submitComment"
            >
              发布
            </button>
          </div>
        </div>

        <div v-if="comments.length === 0" class="text-sm text-gray-600">还没有评论。</div>
        <div v-else class="space-y-3">
          <div v-for="c in comments" :key="c.id" class="bg-white rounded-xl border border-gray-200 p-4">
            <div class="text-xs text-gray-500">{{ formatTime(c.createdAt) }}</div>
            <div class="mt-2 text-sm text-gray-900 whitespace-pre-wrap">{{ c.text }}</div>
          </div>
        </div>
      </section>

      <div v-if="!path" class="bg-white rounded-xl border border-gray-200 p-5 text-sm text-gray-700">
        未找到该 learning path（id: {{ id }}）。你可以先从 LearningPool 里选择一个已有的卡片进入。
      </div>
      </div>
    </div>
  </div>

  <div v-if="showUseModal" class="fixed inset-0 bg-black/20 backdrop-blur-sm flex items-center justify-center p-4 z-50">
    <div class="bg-white rounded-xl shadow-2xl max-w-md w-full">
      <div class="p-6 border-b border-gray-200 flex items-center justify-between">
        <h2 class="text-gray-900 text-lg font-semibold">{{ useModalTitle }}</h2>
        <button type="button" class="text-gray-400 hover:text-gray-600" @click="closeUseModal" :disabled="usingThisPath">
          <span class="sr-only">Close</span>
          ×
        </button>
      </div>

      <div class="p-6 space-y-3">
        <p class="text-gray-700">{{ useModalMessage }}</p>
        <p v-if="useModalHint" class="text-sm text-gray-500">{{ useModalHint }}</p>
      </div>

      <div class="p-6 pt-0 flex items-center justify-end gap-3">
        <button
          v-if="useModalState === 'confirm'"
          type="button"
          class="px-4 py-2 rounded-lg bg-white border border-gray-200 text-gray-700 hover:bg-gray-50 font-semibold"
          @click="closeUseModal"
          :disabled="usingThisPath"
        >
          取消
        </button>
        <button
          v-if="useModalState === 'confirm'"
          type="button"
          class="px-4 py-2 rounded-lg bg-blue-600 text-white hover:bg-blue-700 font-semibold disabled:opacity-50 disabled:cursor-not-allowed"
          @click="confirmUseThisPath"
          :disabled="usingThisPath"
        >
          {{ usingThisPath ? 'Saving…' : '保存到 My Paths' }}
        </button>

        <button
          v-else
          type="button"
          class="px-4 py-2 rounded-lg bg-blue-600 text-white hover:bg-blue-700 font-semibold"
          @click="closeUseModal"
        >
          确定
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, watch, onMounted } from 'vue'
import { useRoute, RouterLink, useRouter } from 'vue-router'
import { BookOpen, Clock, Home as HomeIcon, Layers, Library } from 'lucide-vue-next'
import { getPublicLearningPathDetail, getMyLearningPathDetail, attachPublicLearningPathToMe } from '../api/learningPath'

type Module = {
  id: string
  resourceId: string
  title: string
  description: string
  type: 'video' | 'document' | 'article'
  duration: string
  level: 'Beginner' | 'Intermediate' | 'Advanced'
}

const route = useRoute()
const router = useRouter()
const id = computed(() => String(route.params.id || ''))

const fromMyPaths = computed(() => String(route.query.from || '') === 'my-paths')

const path = ref<any | null>(null)
const modules = ref<any[]>([])
 
const loading = ref(false)
const error = ref('')

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
          description: detail.description,
          thumbnail: String(detail.cover_image_url || '') || '',
          category: detail.category_name || 'Learning Path',
          level: detail.is_public ? 'Public' : 'Private',
          items: Array.isArray(detail.path_items) ? detail.path_items.length : 0,
        }

        modules.value = (detail.path_items || []).map((it: any) => {
          // type 显示原始 resource_kind 或 resource_type
          const rk = String(it?.resource_data?.resource_kind || it?.resource_data?.resource_type || it?.resource_type || '').toLowerCase()
          const uiType: Module['type'] = rk === 'video' ? 'video' : rk === 'clip' ? 'clip' : rk === 'link' ? 'link' : rk === 'document' ? 'document' : rk === 'article' ? 'article' : 'unknown'
          return {
            id: it.id,
            resourceId: it.resource_id,
            title: it.title || (it.resource_data?.title || `Resource ${it.resource_id}`),
            description: it.description || (it.resource_data?.description || ''),
            type: uiType,
            duration: '', // duration 字段隐藏
            level: 'Beginner',
            resource_data: it.resource_data || null,
          }
        })
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
    case 'document':
      return 'bg-blue-50 text-blue-700'
    case 'article':
      return 'bg-green-50 text-green-700'
  }
}

function openResource(resourceId: string, type: Module['type']) {
  if (!resourceId) return
  if (type === 'video') {
    router.push({ name: 'resource-video', params: { id: String(resourceId) } })
    return
  }
  router.push({ name: 'resource-document', params: { id: String(resourceId) } })
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
