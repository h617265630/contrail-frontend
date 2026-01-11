<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-6">
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
              <RouterLink to="/learningpool" class="px-4 py-2 rounded-lg bg-white border border-gray-200 text-gray-700 text-sm hover:bg-gray-50">
                返回 LearningPool
              </RouterLink>
              <button class="px-4 py-2 rounded-lg bg-blue-600 text-white text-sm font-semibold hover:bg-blue-700">
                Start
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
          <article v-for="m in modules" :key="m.id" class="bg-white rounded-xl shadow-lg p-5">
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

      <div v-if="!path" class="bg-white rounded-xl border border-gray-200 p-5 text-sm text-gray-700">
        未找到该 learning path（id: {{ id }}）。你可以先从 LearningPool 里选择一个已有的卡片进入。
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, RouterLink } from 'vue-router'
import { Clock, Layers } from 'lucide-vue-next'
import { learningPoolPaths } from '../data/learningPool'

type Module = {
  id: string
  title: string
  description: string
  type: 'video' | 'document' | 'article'
  duration: string
  level: 'Beginner' | 'Intermediate' | 'Advanced'
}

const route = useRoute()
const id = computed(() => String(route.params.id || ''))

const path = computed(() => learningPoolPaths.find(p => p.id === id.value) || null)

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

const modules = computed<Module[]>(() => {
  const baseTitle = path.value?.title || `Path ${id.value}`
  const levels: Module['level'][] = ['Beginner', 'Intermediate', 'Advanced']
  const types: Module['type'][] = ['video', 'document', 'article']

  // 生成示例模块（后续可替换为真实后端数据）
  return Array.from({ length: 8 }).map((_, idx) => ({
    id: `${id.value}-${idx + 1}`,
    title: `${baseTitle} · Module ${idx + 1}`,
    description: '这里是模块简介（示例）。后续可以接入真实的资源列表与进度。',
    type: types[idx % types.length],
    duration: `${20 + idx * 5} min`,
    level: levels[Math.min(levels.length - 1, Math.floor(idx / 3))],
  }))
})
</script>
