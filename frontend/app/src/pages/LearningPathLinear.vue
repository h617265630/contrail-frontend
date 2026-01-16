<template>
  <div class="min-h-screen bg-linear-to-br from-blue-50 to-indigo-100 p-6">
    <div class="max-w-5xl mx-auto">
      <!-- Banner (similar to /learningpath/:id detail banner) -->
      <div class="bg-white rounded-2xl shadow-xl overflow-hidden mb-8">
        <div class="h-44 bg-gray-100">
          <img v-if="path" :src="path.thumbnail" :alt="path.title" class="w-full h-full object-cover" />
        </div>
        <div class="p-8">
          <div class="flex flex-col gap-4">
            <div class="min-w-0">
              <h1 class="text-gray-900 mb-2">{{ path?.title || learningPath.title }}</h1>
              <p class="text-gray-600 whitespace-pre-wrap">
                {{ path?.description || learningPath.description }}
              </p>
              <div class="mt-4 flex flex-wrap gap-2 text-sm">
                <span v-if="path" class="px-3 py-1 rounded-full bg-blue-50 text-blue-700 font-semibold">{{ path.category }}</span>
                <span v-if="path" class="px-3 py-1 rounded-full bg-gray-100 text-gray-700">{{ path.level }}</span>
                <span v-if="path" class="px-3 py-1 rounded-full bg-green-50 text-green-700">{{ path.items }} items</span>
              </div>
            </div>

            <!-- Overall Progress -->
            <div>
              <div class="flex items-center justify-between mb-2">
                <span class="text-gray-700">Overall Progress</span>
                <span class="text-blue-600">{{ learningPath.totalProgress }}%</span>
              </div>
              <div class="w-full bg-gray-200 rounded-full h-3">
                <div
                  class="bg-blue-600 h-3 rounded-full transition-all duration-300"
                  :style="{ width: `${learningPath.totalProgress}%` }"
                />
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Learning Path Timeline (from temp.vue) -->
      <div class="relative">
        <!-- Vertical Line -->
        <div class="absolute left-6 top-0 bottom-0 w-0.5 bg-blue-200" />

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
                      ? 'bg-green-500 text-white'
                      : item.progress > 0
                        ? 'bg-blue-500 text-white'
                        : 'bg-white border-4 border-gray-300 text-gray-400'
                  "
                >
                  <CheckCircle2 v-if="item.completed" class="w-6 h-6" />
                  <Circle v-else class="w-6 h-6" />
                </div>
              </div>

              <!-- Card Content - 水平分为左右两个子卡片 -->
              <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                <div class="grid grid-cols-1 lg:grid-cols-2 divide-y lg:divide-y-0 lg:divide-x divide-gray-200">
                  <!-- 左边的Card - 内容展示 -->
                  <div class="p-6">
                    <!-- 缩略图 -->
                    <div class="relative mb-4 rounded-lg overflow-hidden bg-gray-100 group">
                      <img :src="item.thumbnail" :alt="item.title" class="w-full h-48 object-cover" />

                      <!-- 视频播放图标覆盖层 -->
                      <div
                        v-if="item.type === 'video'"
                        class="absolute inset-0 bg-black bg-opacity-30 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity"
                      >
                        <div class="w-16 h-16 bg-white rounded-full flex items-center justify-center">
                          <Play class="w-8 h-8 text-blue-600 ml-1" />
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
                      <h3 class="text-gray-900 mb-2">{{ item.title }}</h3>
                      <p class="text-gray-600">{{ item.description }}</p>
                    </div>

                    <!-- Continue Learning 按钮 -->
                    <button
                      type="button"
                      class="w-full px-4 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center justify-center gap-2"
                      @click="goToResource(item)"
                    >
                      <Play v-if="item.type === 'video'" class="w-4 h-4" />
                      {{ item.progress === 0 ? 'Start Learning' : 'Continue Learning' }}
                    </button>
                  </div>

                  <!-- 右边的Card - 进度和笔记 -->
                  <div class="p-6 bg-gray-50">
                    <!-- 学习进度 -->
                    <div class="mb-6">
                      <h4 class="text-gray-900 mb-3">Learning Progress</h4>

                      <!-- 进度条 -->
                      <div class="mb-4">
                        <div class="flex items-center justify-between mb-2">
                          <span class="text-sm text-gray-600">Completion</span>
                          <span class="text-sm text-blue-600">{{ item.progress }}%</span>
                        </div>
                        <div class="w-full bg-gray-200 rounded-full h-2.5">
                          <div
                            class="h-2.5 rounded-full transition-all duration-300"
                            :class="item.completed ? 'bg-green-500' : 'bg-blue-500'"
                            :style="{ width: `${item.progress}%` }"
                          />
                        </div>
                      </div>

                      <!-- 详细进度信息 -->
                      <div class="space-y-2">
                        <div v-if="item.type === 'video'" class="flex items-center justify-between text-sm">
                          <span class="text-gray-600">Duration:</span>
                          <span class="text-gray-900">{{ item.duration || '—' }}</span>
                        </div>
                        <div v-else class="flex items-center justify-between text-sm">
                          <span class="text-gray-600">Pages:</span>
                          <span class="text-gray-900">{{ typeof item.totalPages === 'number' ? item.totalPages : '—' }}</span>
                        </div>

                        <div class="flex items-center justify-between text-sm">
                          <span class="text-gray-600">Status:</span>
                          <span
                            class="px-2 py-1 rounded-full text-xs"
                            :class="
                              item.completed
                                ? 'bg-green-100 text-green-700'
                                : item.progress > 0
                                  ? 'bg-blue-100 text-blue-700'
                                  : 'bg-gray-200 text-gray-700'
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
                        <StickyNote class="w-4 h-4 text-gray-600" />
                        <h4 class="text-gray-900">My Notes</h4>
                      </div>

                      <div v-if="editingNotes === item.id">
                        <textarea
                          v-model="noteDraft"
                          class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
                          rows="6"
                          placeholder="Add your notes here..."
                        />
                        <div class="flex gap-2 mt-2">
                          <button
                            type="button"
                            class="px-3 py-1 bg-blue-600 text-white rounded hover:bg-blue-700 transition-colors text-sm"
                            @click="saveNotes(item.id)"
                          >
                            Save
                          </button>
                          <button
                            type="button"
                            class="px-3 py-1 bg-gray-200 text-gray-700 rounded hover:bg-gray-300 transition-colors text-sm"
                            @click="cancelNotes()"
                          >
                            Cancel
                          </button>
                        </div>
                      </div>

                      <div v-else class="cursor-pointer" @click="startEdit(item.id)">
                        <div
                          v-if="item.notes"
                          class="p-3 bg-yellow-50 border border-yellow-200 rounded-lg text-gray-700 hover:bg-yellow-100 transition-colors min-h-30 whitespace-pre-wrap"
                        >
                          {{ item.notes }}
                        </div>
                        <div
                          v-else
                          class="p-3 border-2 border-dashed border-gray-300 rounded-lg text-gray-400 hover:border-gray-400 hover:text-gray-500 transition-colors min-h-30 flex items-center justify-center"
                        >
                          Click to add notes...
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Arrow between cards -->
            <div v-if="index < learningPath.items.length - 1" class="relative pl-16 py-4">
              <div class="absolute left-6 top-0 bottom-0 flex items-center justify-center">
                <div class="flex flex-col items-center">
                  <ArrowDown class="w-6 h-6 text-blue-400 animate-bounce" />
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Completion Celebration - 祝福语 -->
        <div class="relative pl-16 mt-8">
          <div class="absolute left-0 top-6 w-12 h-12 flex items-center justify-center">
            <div
              class="w-12 h-12 rounded-full flex items-center justify-center bg-linear-to-br from-yellow-400 to-orange-500 text-white shadow-lg"
            >
              <Award class="w-6 h-6" />
            </div>
          </div>

          <div class="bg-linear-to-br from-purple-50 to-pink-50 rounded-xl shadow-lg p-8 border-2 border-purple-200">
            <div class="text-center">
              <div class="flex items-center justify-center gap-2 mb-4">
                <Sparkles class="w-8 h-8 text-purple-600" />
                <h2 class="text-gray-900">Congratulations!</h2>
                <Sparkles class="w-8 h-8 text-purple-600" />
              </div>

              <p class="text-gray-700 mb-4 text-lg">🎉 您已完成整个学习路径的旅程！</p>

              <div class="space-y-2 text-gray-600 mb-6">
                <p>
                  从这里开始，您已经掌握了 <span class="text-purple-600">{{ learningPath.title }}</span> 的所有核心知识。
                </p>
                <p>每一步的努力都值得骄傲，每一个笔记都是您成长的见证。</p>
                <p class="text-gray-700">继续保持这份热情，将所学应用到实践中，创造属于您的精彩项目！</p>
              </div>

              <div class="flex items-center justify-center gap-4">
                <button
                  type="button"
                  class="px-6 py-3 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors flex items-center gap-2"
                >
                  <Award class="w-4 h-4" />
                  View Certificate
                </button>
                <button
                  type="button"
                  class="px-6 py-3 bg-white text-purple-600 border-2 border-purple-600 rounded-lg hover:bg-purple-50 transition-colors"
                >
                  Start New Path
                </button>
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
import { learningPoolPaths } from '../data/learningPool'
import { getMyLearningPath } from '../data/myPaths'
import { getResourceById, listAllResources } from '../data/resourcesStore'
import {
  getMyPathResourceEntry,
  loadMyPathResourceState,
  saveMyPathResourceState,
  setMyPathResourceEntry,
} from '../data/myPathResourceState'
import type { Resource } from '../data/resources'

type PathItem = {
  id: string
  title: string
  description: string
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
  id: string
  title: string
  description: string
  totalProgress: number
  items: PathItem[]
}

const route = useRoute()
const router = useRouter()
const id = computed(() => String(route.params.id || ''))

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

const resourceState = ref(loadMyPathResourceState())

const editingNotes = ref<string | null>(null)
const noteDraft = ref('')

watch(
  id,
  () => {
    editingNotes.value = null
    noteDraft.value = ''
  },
  { immediate: true },
)

const resourcesForPath = computed<Resource[]>(() => {
  if (myPath.value) {
    return myPath.value.resourceIds
      .map(rid => getResourceById(rid))
      .filter(Boolean) as Resource[]
  }

  const resources = listAllResources()
  const desiredCount = poolPath.value?.items ?? 8
  return resources.slice(0, Math.min(desiredCount, resources.length))
})

const learningPath = computed<LearningPathData>(() => {
  const title = path.value?.title || 'Learning Path'
  const description = path.value?.description || ''

  const items: PathItem[] = resourcesForPath.value.map((r) => {
    const entry = getMyPathResourceEntry(resourceState.value, id.value, r.id)
    const progress = entry.progress ?? 0
    const totalPages = typeof r.pages === 'number' ? r.pages : undefined
    const currentPage = typeof totalPages === 'number' ? Math.round((progress / 100) * totalPages) : undefined

    return {
      id: r.id,
      title: r.title,
      description: r.description,
      type: r.type,
      duration: r.duration || (typeof r.pages === 'number' ? `${r.pages} pages` : '—'),
      progress,
      notes: entry.note ?? '',
      completed: progress >= 100,
      thumbnail: r.thumbnail,
      totalPages,
      currentPage,
    }
  })

  const totalProgress = items.length
    ? Math.round(items.reduce((sum, item) => sum + item.progress, 0) / items.length)
    : 0

  return {
    id: id.value,
    title,
    description,
    totalProgress,
    items,
  }
})

function startEdit(itemId: string) {
  editingNotes.value = itemId
  const entry = getMyPathResourceEntry(resourceState.value, id.value, itemId)
  noteDraft.value = entry.note || ''
}

function saveNotes(itemId: string) {
  const current = getMyPathResourceEntry(resourceState.value, id.value, itemId)
  const next = setMyPathResourceEntry(resourceState.value, id.value, itemId, {
    ...current,
    note: noteDraft.value,
  })
  resourceState.value = next
  saveMyPathResourceState(next)
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
  if (item.type === 'video') {
    router.push({ name: 'resource-video', params: { id: item.id } })
    return
  }

  // document / article -> document page
  router.push({ name: 'resource-document', params: { id: item.id } })
}
</script>
