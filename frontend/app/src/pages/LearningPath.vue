<template>
  <div class="min-h-screen bg-linear-to-br from-blue-50 to-indigo-100 p-6">
    <div class="max-w-7xl mx-auto space-y-10">
      <!-- Header -->
      <div class="bg-white rounded-2xl shadow-xl p-8">
        <h1 class="text-gray-900 mb-2">LearningPool</h1>
        <p class="text-gray-600">浏览所有 learning paths，并按分类快速发现热门与 AI 相关内容</p>
      </div>

      <!-- Section 1: Categories (8 labels) -->
      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <h2 class="text-xl font-semibold text-gray-900">分类</h2>
          <span class="text-sm text-gray-500">8 categories</span>
        </div>
        <div class="flex flex-wrap gap-3">
          <RouterLink
            v-for="cat in categories"
            :key="cat"
            :to="{ name: 'learningpool-category', params: { category: cat } }"
            class="px-4 py-2 rounded-full bg-white border border-gray-200 shadow-sm text-gray-700 text-sm font-semibold hover:bg-gray-50 hover:border-gray-300 transition-colors"
          >
            {{ cat }}
          </RouterLink>
        </div>
      </section>

      <!-- Section 2: Hot paths -->
      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <h2 class="text-xl font-semibold text-gray-900">热门 learning paths</h2>
          <span class="text-sm text-gray-500">Top picks</span>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <RouterLink
            v-for="p in hotPaths"
            :key="p.id"
            :to="{ name: 'learningpath', params: { id: p.id } }"
            class="block"
          >
            <article class="bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-xl transition">
              <div class="h-36 bg-gray-100">
                <img :src="p.thumbnail" :alt="p.title" class="w-full h-full object-cover" />
              </div>
              <div class="p-4 space-y-2">
                <div class="flex items-start justify-between gap-2">
                  <h3 class="text-gray-900 font-semibold line-clamp-1" :title="p.title">{{ p.title }}</h3>
                  <span class="px-2 py-1 rounded-full bg-orange-50 text-orange-700 text-xs font-semibold">HOT</span>
                </div>
                <p class="text-gray-600 text-sm line-clamp-2" :title="p.description">{{ p.description }}</p>
                <div class="flex flex-wrap gap-2">
                  <span class="px-2 py-1 rounded-full bg-blue-50 text-blue-700 text-xs font-semibold">{{ p.category }}</span>
                  <span class="px-2 py-1 rounded-full bg-gray-100 text-gray-700 text-xs">{{ p.level }}</span>
                </div>
              </div>
            </article>
          </RouterLink>
        </div>
      </section>

      <!-- Section 3: AI related -->
      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <h2 class="text-xl font-semibold text-gray-900">AI 相关</h2>
          <span class="text-sm text-gray-500">AI</span>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <RouterLink
            v-for="p in aiPaths"
            :key="p.id"
            :to="{ name: 'learningpath', params: { id: p.id } }"
            class="block"
          >
            <article class="bg-white rounded-xl shadow-lg p-5 hover:shadow-xl transition">
              <div class="flex items-start justify-between gap-3">
                <div class="min-w-0">
                  <h3 class="text-gray-900 font-semibold line-clamp-1" :title="p.title">{{ p.title }}</h3>
                  <p class="text-gray-600 text-sm mt-1 line-clamp-2" :title="p.description">{{ p.description }}</p>
                </div>
                <span class="px-2 py-1 rounded-full bg-purple-50 text-purple-700 text-xs font-semibold">AI</span>
              </div>
              <div class="mt-4 flex flex-wrap gap-2">
                <span class="px-2 py-1 rounded-full bg-blue-50 text-blue-700 text-xs font-semibold">{{ p.category }}</span>
                <span class="px-2 py-1 rounded-full bg-gray-100 text-gray-700 text-xs">{{ p.level }}</span>
              </div>
            </article>
          </RouterLink>
        </div>
      </section>

      <!-- Section 4: Other -->
      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <h2 class="text-xl font-semibold text-gray-900">其他</h2>
          <span class="text-sm text-gray-500">Non-AI</span>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <RouterLink
            v-for="p in otherPaths"
            :key="p.id"
            :to="{ name: 'learningpath', params: { id: p.id } }"
            class="block"
          >
            <article class="bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-xl transition">
              <div class="p-5 space-y-2">
                <div class="flex items-center justify-between gap-3">
                  <h3 class="text-gray-900 font-semibold line-clamp-1" :title="p.title">{{ p.title }}</h3>
                  <span class="px-2 py-1 rounded-full bg-gray-100 text-gray-700 text-xs">{{ p.category }}</span>
                </div>
                <p class="text-gray-600 text-sm line-clamp-3" :title="p.description">{{ p.description }}</p>
                <div class="flex flex-wrap gap-2">
                  <span class="px-2 py-1 rounded-full bg-indigo-50 text-indigo-700 text-xs font-semibold">{{ p.level }}</span>
                  <span class="px-2 py-1 rounded-full bg-green-50 text-green-700 text-xs">{{ p.items }} items</span>
                </div>
              </div>
            </article>
          </RouterLink>
        </div>
      </section>

      <!-- Section 5: Waterfall (all paths) -->
      <section class="space-y-4">
        <div class="flex items-center justify-between">
          <h2 class="text-xl font-semibold text-gray-900">全部（瀑布流）</h2>
          <span class="text-sm text-gray-500">{{ allPaths.length }} total</span>
        </div>

        <div class="columns-1 sm:columns-2 md:columns-3 lg:columns-5 gap-4">
          <RouterLink
            v-for="p in allPaths"
            :key="p.id"
            :to="{ name: 'learningpath', params: { id: p.id } }"
            class="block mb-4 break-inside-avoid"
          >
            <article class="bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-xl transition">
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
            </article>
          </RouterLink>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { listPublicLearningPaths, type PublicLearningPath } from '../api/learningPath'
import { RouterLink } from 'vue-router'

const categories = ['AI','Frontend','Backend','DevOps','Database','Design','Product','Career']

function inferCategoryFromText(text: string): string {
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

const allPaths = ref<any[]>([])

function mapDbToPool(p: PublicLearningPath): LearningPoolPath {
  const title = String(p.title || '').trim() || `Path ${p.id}`
  const description = String(p.description || '').trim()
  const category = inferCategoryFromText(`${title}\n${description}`)
  return {
    id: String(p.id),
    title,
    description: description || '（无介绍）',
    category,
    level: 'Beginner',
    items: 0,
    thumbnail: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=900&h=506&fit=crop',
    hotScore: 50,
    isAI: category === 'AI',
  }
}

onMounted(async () => {
  try {
    const db = await listPublicLearningPaths()
    const mapped = (db || []).map(mapDbToPool)
    allPaths.value = mapped
  } catch {
    // keep static fallback
  }
})

const hotPaths = computed(() => [...allPaths.value].sort((a, b) => b.hotScore - a.hotScore).slice(0, 4))
const aiPaths = computed(() => allPaths.value.filter(p => p.isAI))
const otherPaths = computed(() => allPaths.value.filter(p => !p.isAI))
</script>
