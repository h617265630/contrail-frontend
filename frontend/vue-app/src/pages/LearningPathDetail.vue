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
                to="/learningpool"
                class="px-4 py-2 rounded-lg flex items-center gap-2 transition-colors text-gray-600 hover:bg-gray-100"
              >
                返回 LearningPool
              </RouterLink>
              <RouterLink
                :to="{ name: 'learningpath-linear', params: { id } }"
                class="px-4 py-2 rounded-lg flex items-center gap-2 transition-colors bg-blue-600 text-white hover:bg-blue-700"
              >
                Start
              </RouterLink>
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
            class="w-full min-h-[96px] p-3 rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm text-gray-900"
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
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { useRoute, RouterLink, useRouter } from 'vue-router'
import { BookOpen, Clock, Home as HomeIcon, Layers, Library } from 'lucide-vue-next'
import { learningPoolPaths } from '../data/learningPool'
import { getMyLearningPath } from '../data/myPaths'
import { getResourceById, listAllResources } from '../data/resourcesStore'
import { addLearningPathComment, listLearningPathComments, type LearningPathComment } from '../data/learningPathComments'

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

const currentTab = computed(() => (route.path.startsWith('/resources') ? 'resourceLibrary' : 'learningPath'))

const poolPath = computed(() => learningPoolPaths.find(p => p.id === id.value) || null)

const myPath = computed(() => getMyLearningPath(id.value))

const path = computed(() => {
  if (poolPath.value) return poolPath.value
  if (!myPath.value) return null

  const cover = myPath.value.resourceIds[0] ? getResourceById(myPath.value.resourceIds[0]) : null
  return {
    id: myPath.value.id,
    title: myPath.value.title,
    description: myPath.value.description,
    thumbnail: cover?.thumbnail || '',
    category: 'My Paths',
    level: 'Custom',
    items: myPath.value.resourceIds.length,
  }
})

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
    router.push({ name: 'resource-video', params: { id: resourceId } })
    return
  }
  router.push({ name: 'resource-document', params: { id: resourceId } })
}

const modules = computed<Module[]>(() => {
  // MyPaths：优先展示真实资源列表
  if (myPath.value) {
    const levels: Module['level'][] = ['Beginner', 'Intermediate', 'Advanced']
    return myPath.value.resourceIds
      .map((rid, idx) => {
        const r = getResourceById(rid)
        if (!r) return null
        return {
          id: `${id.value}-${rid}`,
          resourceId: rid,
          title: r.title,
          description: r.description,
          type: r.type,
          duration: r.duration || (typeof r.pages === 'number' ? `${r.pages} pages` : '—'),
          level: levels[Math.min(levels.length - 1, Math.floor(idx / 3))],
        } as Module
      })
      .filter(Boolean) as Module[]
  }

  // LearningPool：用资源库里的真实资源填充，保证点击可直接学习
  const resources = listAllResources()
  const levels: Module['level'][] = ['Beginner', 'Intermediate', 'Advanced']
  const count = Math.min(8, resources.length)
  return Array.from({ length: count }).map((_, idx) => {
    const r = resources[idx]
    return {
      id: `${id.value}-${r.id}`,
      resourceId: r.id,
      title: r.title,
      description: r.description,
      type: r.type,
      duration: r.duration || (typeof r.pages === 'number' ? `${r.pages} pages` : '—'),
      level: levels[Math.min(levels.length - 1, Math.floor(idx / 3))],
    }
  })
})

const commentDraft = ref('')
const comments = ref<LearningPathComment[]>([])

watch(
  id,
  (nextId) => {
    comments.value = nextId ? listLearningPathComments(nextId) : []
    commentDraft.value = ''
  },
  { immediate: true },
)

function submitComment() {
  if (!id.value) return
  try {
    addLearningPathComment(id.value, commentDraft.value)
    comments.value = listLearningPathComments(id.value)
    commentDraft.value = ''
  } catch {
    // ignore empty
  }
}

function formatTime(iso: string) {
  const d = new Date(iso)
  if (Number.isNaN(d.getTime())) return iso
  return d.toLocaleString()
}
</script>
