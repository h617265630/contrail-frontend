<template>
  <div class="max-w-7xl mx-auto space-y-10">
    <section class="space-y-4">
      <div class="flex items-center justify-between">
        <div>
          <h2 class="text-xl font-semibold text-gray-900">Learning Paths</h2>
          <p class="text-gray-600 text-sm">
            <span v-if="searchQuery">搜索 "{{ searchQuery }}" 的结果：{{ learningPaths.length }} 个学习路径</span>
            <span v-else>所有公开学习路径：{{ learningPaths.length }} 个</span>
          </p>
        </div>
      </div>
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
        <RouterLink
          v-for="path in learningPaths"
          :key="path.id"
          :to="{ name: 'learningpath', params: { id: path.id } }"
          class="block"
        >
          <Card as="article" :hoverable="true">
            <div class="relative h-28 bg-gray-100">
              <img :src="path.cover_image_url || fallbackThumb" :alt="path.title" class="w-full h-full object-cover" />
            </div>
            <div class="p-4 flex flex-col gap-3">
              <div class="space-y-1">
                <h3 class="text-gray-900 font-semibold text-sm leading-snug line-clamp-2" :title="path.title">{{ path.title }}</h3>
                <p class="text-gray-600 text-xs line-clamp-2" :title="path.description">{{ path.description }}</p>
              </div>
              <div class="flex items-center justify-between text-xs text-gray-500">
                <span>{{ path.category_name || '未分类' }}</span>
                <span>{{ path.level || 'Beginner' }}</span>
              </div>
            </div>
          </Card>
        </RouterLink>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { RouterLink, useRoute } from 'vue-router'
import Card from '../components/ui/Card.vue'
import { listPublicLearningPaths, type PublicLearningPath } from '../api/learningPath'

const route = useRoute()
const fallbackThumb = 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=900&h=506&fit=crop'
const allPaths = ref<PublicLearningPath[]>([])

// 从 URL 参数获取搜索关键词
const searchQuery = computed(() => String(route.query.search || '').trim())

// 根据搜索关键词过滤学习路径
const learningPaths = computed(() => {
  const query = searchQuery.value.toLowerCase()
  if (!query) return allPaths.value
  
  return allPaths.value.filter(path => {
    const title = (path.title || '').toLowerCase()
    const description = (path.description || '').toLowerCase()
    const category = (path.category_name || '').toLowerCase()
    
    return title.includes(query) || 
           description.includes(query) || 
           category.includes(query)
  })
})

async function loadPaths() {
  try {
    allPaths.value = await listPublicLearningPaths()
  } catch {
    allPaths.value = []
  }
}

onMounted(() => {
  loadPaths()
})

// 监听搜索参数变化
watch(() => route.query.search, () => {
  // 搜索参数变化时，computed 会自动重新计算
})
</script>
