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
import { computed } from 'vue'
import { useRoute, RouterLink } from 'vue-router'
import { learningPoolPaths } from '../data/learningPool'
import Card from '../components/ui/Card.vue'

const route = useRoute()
const category = computed(() => decodeURIComponent(String(route.params.category || '')))

const filteredPaths = computed(() => learningPoolPaths.filter(p => p.category === category.value))
</script>
