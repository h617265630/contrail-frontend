<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

// 示例数据，实际应该从 API 获取
const myPaths = ref([
  {
    id: 1,
    topic: 'Python 基础入门',
    description: '学习 Python 编程语言基础',
    difficulty: 'beginner',
    estimated_duration: '4周',
    stages_count: 3,
    created_at: '2024-01-15'
  },
  {
    id: 2,
    topic: 'React 全栈开发',
    description: '掌握 React 和现代前端技术',
    difficulty: 'intermediate',
    estimated_duration: '8周',
    stages_count: 5,
    created_at: '2024-01-10'
  }
])

const myResources = ref([
  {
    id: 1,
    title: 'Python Official Documentation',
    url: 'https://docs.python.org/3/',
    type: 'document',
    saved_at: '2024-01-15'
  },
  {
    id: 2,
    title: 'React GitHub',
    url: 'https://github.com/facebook/react',
    type: 'github',
    saved_at: '2024-01-14'
  }
])

const activeTab = ref<'paths' | 'resources'>('paths')

function getTypeIcon(type: string): string {
  switch (type) {
    case 'video': return '🎥'
    case 'github': return '💻'
    case 'document': return '📄'
    default: return '🔗'
  }
}

function viewPathDetail(path: any) {
  // 跳转到详情页
  console.log('查看路径详情', path.id)
}

function openResource(url: string) {
  window.open(url, '_blank')
}
</script>

<template>
  <div class="min-h-screen bg-background py-8 px-4">
    <div class="max-w-4xl mx-auto">
      <!-- 标题 -->
      <div class="mb-8">
        <h1 class="text-3xl font-bold">我的资源库</h1>
        <p class="text-muted-foreground mt-2">管理你的学习路径和资源</p>
      </div>
      
      <!-- Tab 切换 -->
      <div class="flex gap-4 mb-6 border-b">
        <button 
          @click="activeTab = 'paths'"
          class="px-4 py-2 border-b-2 transition-colors"
          :class="activeTab === 'paths' ? 'border-primary text-primary' : 'border-transparent'"
        >
          📚 我的学习路径
        </button>
        <button 
          @click="activeTab = 'resources'"
          class="px-4 py-2 border-b-2 transition-colors"
          :class="activeTab === 'resources' ? 'border-primary text-primary' : 'border-transparent'"
        >
          📖 我的资源
        </button>
      </div>
      
      <!-- 学习路径列表 -->
      <div v-if="activeTab === 'paths'" class="space-y-4">
        <div 
          v-for="path in myPaths" 
          :key="path.id"
          class="border rounded-md p-4 hover:shadow-md transition-shadow cursor-pointer"
          @click="viewPathDetail(path)"
        >
          <div class="flex items-start justify-between">
            <div>
              <h3 class="text-lg font-semibold">{{ path.topic }}</h3>
              <p class="text-sm text-gray-600 mt-1">{{ path.description }}</p>
              <div class="flex gap-4 mt-3 text-xs text-gray-500">
                <span>📊 {{ path.difficulty }}</span>
                <span>⏱️ {{ path.estimated_duration }}</span>
                <span>📚 {{ path.stages_count }} 个阶段</span>
              </div>
            </div>
            <span class="text-xs text-gray-400">{{ path.created_at }}</span>
          </div>
        </div>
        
        <div v-if="myPaths.length === 0" class="text-center py-12 text-gray-500">
          <p>暂无学习路径</p>
          <button 
            @click="router.push({ name: 'generate-path' })"
            class="mt-4 px-4 py-2 bg-primary text-primary-foreground rounded"
          >
            开始生成
          </button>
        </div>
      </div>
      
      <!-- 资源列表 -->
      <div v-if="activeTab === 'resources'" class="space-y-4">
        <div 
          v-for="resource in myResources" 
          :key="resource.id"
          class="border rounded-md p-4 hover:shadow-md transition-shadow"
        >
          <div class="flex items-start gap-3">
            <span class="text-2xl">{{ getTypeIcon(resource.type) }}</span>
            <div class="flex-1">
              <h3 class="font-medium">{{ resource.title }}</h3>
              <p class="text-sm text-blue-500 truncate mt-1">{{ resource.url }}</p>
              <p class="text-xs text-gray-400 mt-2">保存于 {{ resource.saved_at }}</p>
            </div>
            <button 
              @click="openResource(resource.url)"
              class="px-3 py-1 text-sm border rounded hover:bg-accent"
            >
              访问
            </button>
          </div>
        </div>
        
        <div v-if="myResources.length === 0" class="text-center py-12 text-gray-500">
          <p>暂无保存的资源</p>
          <p class="text-sm mt-2">在生成学习路径后，可以将资源保存到这里</p>
        </div>
      </div>
    </div>
  </div>
</template>
