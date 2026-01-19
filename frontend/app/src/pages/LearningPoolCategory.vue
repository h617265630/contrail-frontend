<template>
  <div class="min-h-screen bg-linear-to-br from-blue-50 to-indigo-100 p-6">
    <div class="max-w-7xl mx-auto space-y-8">
      <div class="bg-white rounded-2xl shadow-xl p-8">
        <div class="flex items-start justify-between gap-4">
          <div class="min-w-0">
            <h1 class="text-gray-900 mb-2">分类：{{ category }}</h1>
            <p class="text-gray-600">以瀑布流方式展示该分类下的 learning paths</p>
          </div>
          <RouterLink
            to="/learningpool"
            class="px-4 py-2 rounded-lg bg-white border border-gray-200 text-gray-700 hover:bg-gray-50 transition-colors"
          >
            返回 LearningPool
          </RouterLink>
        </div>
      </div>

      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <h2 class="text-xl font-semibold text-gray-900">结果</h2>
          <span class="text-sm text-gray-500">{{ filteredPaths.length }} paths</span>
        </div>

        <div v-if="filteredPaths.length" class="columns-1 sm:columns-2 lg:columns-3 gap-4">
          <RouterLink
            v-for="p in filteredPaths"
            :key="p.id"
            :to="{ name: 'learningpath', params: { id: p.id } }"
            class="block mb-4 break-inside-avoid"
          >
            <Card as="article" :hoverable="true">
              <div class="h-32 bg-gray-100">
                <img :src="p.thumbnail" :alt="p.title" class="w-full h-full object-cover" />
              </div>
              <div class="p-5 space-y-2">
                <div class="flex items-start justify-between gap-2">
                  <h3 class="text-gray-900 font-semibold line-clamp-2" :title="p.title">{{ p.title }}</h3>
                  <span v-if="p.isAI" class="px-2 py-1 rounded-full bg-purple-50 text-purple-700 text-xs font-semibold">AI</span>
                </div>
                <p class="text-gray-600 text-sm whitespace-pre-wrap">{{ p.description }}</p>
                <div class="flex flex-wrap gap-2">
                  <span class="px-2 py-1 rounded-full bg-blue-50 text-blue-700 text-xs font-semibold">{{ p.category }}</span>
                  <span class="px-2 py-1 rounded-full bg-gray-100 text-gray-700 text-xs">{{ p.level }}</span>
                  <span class="px-2 py-1 rounded-full bg-green-50 text-green-700 text-xs">{{ p.items }} items</span>
                </div>
              </div>
            </Card>
          </RouterLink>
        </div>

        <div v-else class="bg-white rounded-xl border border-gray-200 p-5 text-sm text-gray-700">
          当前分类下没有 learning paths：{{ category }}。
        </div>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute, RouterLink } from 'vue-router'
import { learningPoolPaths, type LearningPoolPath } from '../data/learningPool'
import Card from '../components/ui/Card.vue'
import { listPublicLearningPaths, type PublicLearningPath } from '../api/learningPath'

const route = useRoute()
const category = computed(() => decodeURIComponent(String(route.params.category || '')))

const dynamicPaths = ref<LearningPoolPath[]>([])

function inferCategoryFromText(text: string): LearningPoolPath['category'] {
  const t = text.toLowerCase()
  if (t.includes('ai') || t.includes('llm') || t.includes('rag') || t.includes('agent')) return 'AI'
  if (t.includes('front') || t.includes('vue') || t.includes('react') || t.includes('css')) return 'Frontend'
  if (t.includes('back') || t.includes('api') || t.includes('fastapi') || t.includes('node')) return 'Backend'
  if (t.includes('devops') || t.includes('docker') || t.includes('k8s') || t.includes('kubernetes') || t.includes('ci')) return 'DevOps'
  if (t.includes('db') || t.includes('sql') || t.includes('database') || t.includes('postgres')) return 'Database'
  if (t.includes('design') || t.includes('figma') || t.includes('ux')) return 'Design'
  if (t.includes('product') || t.includes('pm') || t.includes('roadmap')) return 'Product'
  if (t.includes('career') || t.includes('resume') || t.includes('interview')) return 'Career'
  return 'Backend'
}

function mapDbToPool(p: PublicLearningPath): LearningPoolPath {
  const title = String(p.title || '').trim() || `Path ${p.id}`
  const description = String(p.description || '').trim()
  const cat = inferCategoryFromText(`${title}\n${description}`)
  return {
    id: String(p.id),
    title,
    description: description || '（无介绍）',
    category: cat,
    level: 'Beginner',
    items: 0,
    thumbnail: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=900&h=506&fit=crop',
    hotScore: 50,
    isAI: cat === 'AI',
  }
}

onMounted(async () => {
  try {
    const db = await listPublicLearningPaths()
    dynamicPaths.value = (db || []).map(mapDbToPool)
  } catch {
    dynamicPaths.value = []
  }
})

const filteredPaths = computed(() => {
  const combined = [...learningPoolPaths, ...dynamicPaths.value]
  const byId = new Map<string, LearningPoolPath>()
  for (const p of combined) byId.set(p.id, p)
  return Array.from(byId.values()).filter(p => p.category === category.value)
})
</script>
