<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-6">
    <div class="max-w-5xl mx-auto scale-[0.8] origin-top">
      <!-- Header -->
      <div class="bg-white rounded-2xl shadow-xl p-8 mb-8">
        <h1 class="text-gray-900 mb-2">{{ learningPath.title }}</h1>
        <p class="text-gray-600 mb-6">{{ learningPath.description }}</p>

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

      <!-- Learning Path Timeline -->
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
                          <span class="text-gray-600">Watch Time:</span>
                          <span class="text-gray-900">{{ item.watchedDuration }} / {{ item.totalDuration }}</span>
                        </div>
                        <div v-else class="flex items-center justify-between text-sm">
                          <span class="text-gray-600">Pages Read:</span>
                          <span class="text-gray-900">{{ item.currentPage }} / {{ item.totalPages }}</span>
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
                          v-if="notesByItemId[item.id]"
                          class="p-3 bg-yellow-50 border border-yellow-200 rounded-lg text-gray-700 hover:bg-yellow-100 transition-colors min-h-[120px] whitespace-pre-wrap"
                        >
                          {{ notesByItemId[item.id] }}
                        </div>
                        <div
                          v-else
                          class="p-3 border-2 border-dashed border-gray-300 rounded-lg text-gray-400 hover:border-gray-400 hover:text-gray-500 transition-colors min-h-[120px] flex items-center justify-center"
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
            <div class="w-12 h-12 rounded-full flex items-center justify-center bg-gradient-to-br from-yellow-400 to-orange-500 text-white shadow-lg">
              <Award class="w-6 h-6" />
            </div>
          </div>

          <div class="bg-gradient-to-br from-purple-50 to-pink-50 rounded-xl shadow-lg p-8 border-2 border-purple-200">
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
import { computed, reactive, ref } from 'vue'
import {
  Award,
  BookOpen,
  CheckCircle2,
  Circle,
  FileText,
  Play,
  Sparkles,
  StickyNote,
  Video,
  ArrowDown,
} from 'lucide-vue-next'

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
  watchedDuration?: string
  totalDuration?: string
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

const learningPath = ref<LearningPathData>({
  id: '1',
  title: 'Full Stack Web Development',
  description: 'Master modern web development from frontend to backend',
  totalProgress: 45,
  items: [
    {
      id: '1',
      title: 'HTML & CSS Fundamentals',
      description: 'Learn the basics of HTML5 and CSS3, including semantic markup, flexbox, and grid layout systems.',
      type: 'video',
      duration: '2h 30min',
      progress: 100,
      notes:
        'Completed all exercises. Key takeaways: semantic HTML is important for SEO, CSS Grid is powerful for complex layouts.',
      completed: true,
      thumbnail: 'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=400&h=225&fit=crop',
      watchedDuration: '2h 30min',
      totalDuration: '2h 30min',
    },
    {
      id: '2',
      title: 'JavaScript ES6+ Features',
      description: 'Deep dive into modern JavaScript including arrow functions, destructuring, promises, and async/await.',
      type: 'video',
      duration: '3h 15min',
      progress: 75,
      notes: 'Currently on async/await section. Need to practice more with Promise chains and error handling.',
      completed: false,
      thumbnail: 'https://images.unsplash.com/photo-1627398242454-45a1465c2479?w=400&h=225&fit=crop',
      watchedDuration: '2h 26min',
      totalDuration: '3h 15min',
    },
    {
      id: '3',
      title: 'React Fundamentals Documentation',
      description: 'Official React documentation covering components, props, state, and hooks.',
      type: 'document',
      duration: '4h',
      progress: 40,
      notes: 'Understanding useState and useEffect hooks. Will revisit useContext and useReducer later.',
      completed: false,
      thumbnail: 'https://images.unsplash.com/photo-1633356122102-3fe601e05bd2?w=400&h=225&fit=crop',
      currentPage: 48,
      totalPages: 120,
    },
    {
      id: '4',
      title: 'Building RESTful APIs with Node.js',
      description: 'Learn to create scalable backend services using Express.js and Node.js.',
      type: 'article',
      duration: '2h 45min',
      progress: 0,
      notes: '',
      completed: false,
      thumbnail: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400&h=225&fit=crop',
      currentPage: 0,
      totalPages: 25,
    },
    {
      id: '5',
      title: 'Database Design with PostgreSQL',
      description: 'Understanding relational databases, SQL queries, and database optimization techniques.',
      type: 'video',
      duration: '3h',
      progress: 0,
      notes: '',
      completed: false,
      thumbnail: 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=400&h=225&fit=crop',
      watchedDuration: '0min',
      totalDuration: '3h',
    },
  ],
})

const notesByItemId = reactive<Record<string, string>>({})
for (const item of learningPath.value.items) notesByItemId[item.id] = item.notes

const editingNotes = ref<string | null>(null)
const noteDraft = ref('')

function startEdit(itemId: string) {
  editingNotes.value = itemId
  noteDraft.value = notesByItemId[itemId] || ''
}

function saveNotes(itemId: string) {
  notesByItemId[itemId] = noteDraft.value
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

const learningPathItems = computed(() => learningPath.value.items)
</script>