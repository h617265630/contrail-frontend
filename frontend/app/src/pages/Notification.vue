<template>
  <div class="min-h-screen bg-linear-to-br from-blue-50 to-indigo-100 p-6">
    <div class="max-w-7xl mx-auto space-y-8">
      <header class="bg-white rounded-2xl shadow-lg p-6">
        <h1 class="text-gray-900 mb-2">Notifications</h1>
        <p class="text-gray-600">Highlights and the latest product updates</p>
      </header>

      <section class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <article class="bg-white rounded-2xl shadow-lg overflow-hidden">
          <div class="h-44 bg-gray-100">
            <img :src="hottest.thumbnail" :alt="hottest.title" class="w-full h-full object-cover" />
          </div>
          <div class="p-6 space-y-3">
            <div class="flex items-start justify-between gap-3">
              <div class="min-w-0">
                <p class="text-xs font-semibold text-orange-600 uppercase tracking-wide">Hottest learning path</p>
                <h2 class="text-xl font-semibold text-gray-900 truncate" :title="hottest.title">{{ hottest.title }}</h2>
              </div>
              <span class="shrink-0 px-2 py-1 rounded-full bg-orange-50 text-orange-700 text-xs font-semibold">HOT</span>
            </div>

            <p class="text-gray-600 text-sm whitespace-pre-wrap line-clamp-3" :title="hottest.description">{{ hottest.description }}</p>

            <div class="flex flex-wrap gap-2">
              <span class="px-2 py-1 rounded-full bg-blue-50 text-blue-700 text-xs font-semibold">{{ hottest.category }}</span>
              <span class="px-2 py-1 rounded-full bg-gray-100 text-gray-700 text-xs">{{ hottest.level }}</span>
              <span class="px-2 py-1 rounded-full bg-green-50 text-green-700 text-xs">{{ hottest.items }} items</span>
              <span class="px-2 py-1 rounded-full bg-purple-50 text-purple-700 text-xs">Score {{ hottest.hotScore }}</span>
            </div>

            <RouterLink
              :to="{ name: 'learningpath', params: { id: hottest.id } }"
              class="inline-flex items-center justify-center px-4 py-2 rounded-lg bg-blue-600 text-white font-semibold hover:bg-blue-700 transition-colors"
            >
              View
            </RouterLink>
          </div>
        </article>

        <article class="bg-white rounded-2xl shadow-lg overflow-hidden">
          <div class="h-44 bg-gray-100">
            <img :src="stable.thumbnail" :alt="stable.title" class="w-full h-full object-cover" />
          </div>
          <div class="p-6 space-y-3">
            <div class="flex items-start justify-between gap-3">
              <div class="min-w-0">
                <p class="text-xs font-semibold text-emerald-700 uppercase tracking-wide">Most stable learning path</p>
                <h2 class="text-xl font-semibold text-gray-900 truncate" :title="stable.title">{{ stable.title }}</h2>
              </div>
              <span class="shrink-0 px-2 py-1 rounded-full bg-emerald-50 text-emerald-700 text-xs font-semibold">STABLE</span>
            </div>

            <p class="text-gray-600 text-sm whitespace-pre-wrap line-clamp-3" :title="stable.description">{{ stable.description }}</p>

            <div class="flex flex-wrap gap-2">
              <span class="px-2 py-1 rounded-full bg-blue-50 text-blue-700 text-xs font-semibold">{{ stable.category }}</span>
              <span class="px-2 py-1 rounded-full bg-gray-100 text-gray-700 text-xs">{{ stable.level }}</span>
              <span class="px-2 py-1 rounded-full bg-green-50 text-green-700 text-xs">{{ stable.items }} items</span>
              <span class="px-2 py-1 rounded-full bg-purple-50 text-purple-700 text-xs">Score {{ stable.hotScore }}</span>
            </div>

            <RouterLink
              :to="{ name: 'learningpath', params: { id: stable.id } }"
              class="inline-flex items-center justify-center px-4 py-2 rounded-lg bg-blue-600 text-white font-semibold hover:bg-blue-700 transition-colors"
            >
              View
            </RouterLink>
          </div>
        </article>
      </section>

      <section class="bg-white rounded-2xl shadow-lg p-6">
        <div class="flex items-center justify-between mb-4">
          <h2 class="text-xl font-semibold text-gray-900">What’s new</h2>
          <span class="text-sm text-gray-500">Latest updates</span>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <article
            v-for="n in news"
            :key="n.id"
            class="rounded-xl border border-gray-100 bg-gray-50 p-4"
          >
            <div class="flex items-start justify-between gap-3">
              <div class="min-w-0">
                <p class="text-xs text-gray-500">{{ n.date }}</p>
                <h3 class="text-gray-900 font-semibold mt-1 line-clamp-1" :title="n.title">{{ n.title }}</h3>
              </div>
              <span class="shrink-0 px-2 py-1 rounded-full bg-blue-50 text-blue-700 text-xs font-semibold">New</span>
            </div>
            <p class="text-gray-600 text-sm mt-2 line-clamp-3" :title="n.body">{{ n.body }}</p>
          </article>
        </div>
      </section>
    </div>
  </div>
</template>


<script setup lang="ts">
import { ref } from 'vue'
import { RouterLink } from 'vue-router'

const hottest = ref({
  id: '1',
  title: 'AI Engineer Starter',
  description: '入门 AI 工程师的系统路径',
  thumbnail: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=900&h=506&fit=crop',
  category: 'AI',
  level: 'Beginner',
  items: 8,
  hotScore: 99,
})

const stable = ref({
  id: '2',
  title: 'Frontend Mastery',
  description: '现代前端开发全栈路线',
  thumbnail: 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=900&h=506&fit=crop',
  category: 'Frontend',
  level: 'Intermediate',
  items: 12,
  hotScore: 88,
})

type NewsItem = {
  id: string
  date: string
  title: string
  body: string
}

const news: NewsItem[] = [
  {
    id: 'n1',
    date: '2026-01-12',
    title: 'Account center is live',
    body: 'You can now view your profile, change your password, and see plan details directly in the sidebar.',
  },
  {
    id: 'n2',
    date: '2026-01-12',
    title: 'Resource video details',
    body: 'Video pages support enriched metadata such as author, publish date, and chapters (when available).',
  },
  {
    id: 'n3',
    date: '2026-01-12',
    title: 'Build-level typecheck improvements',
    body: 'Frontend build now runs typecheck without emitting files into src, reducing TS output conflicts.',
  },
]
</script>
