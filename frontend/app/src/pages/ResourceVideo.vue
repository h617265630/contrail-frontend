<template>
  <div class="min-h-screen bg-slate-50">
    <div class="max-w-6xl mx-auto p-6 space-y-6">
      <div class="flex flex-col gap-2">
        <p class="text-sm uppercase tracking-wide text-blue-600 font-semibold">Video Resource</p>
        <h1 class="text-3xl font-semibold text-slate-900">{{ resource.title }}</h1>
        <div class="flex flex-wrap items-center gap-3 text-sm text-slate-600">
          <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-blue-100 text-blue-700 font-medium">{{ resource.category }}</span>
          <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-slate-100 text-slate-700">
            <Clock class="w-4 h-4" />
            {{ resource.duration }}
          </span>
          <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-green-100 text-green-700">
            <ShieldCheck class="w-4 h-4" />
            Verified source
          </span>
        </div>
      </div>

      <div class="bg-white rounded-2xl shadow-sm overflow-hidden">
        <div class="relative bg-black">
          <video class="w-full aspect-video" controls :poster="resource.thumbnail">
            <source :src="resource.videoUrl" type="video/mp4" />
          </video>
          <div class="absolute bottom-4 left-4 flex items-center gap-2 px-3 py-1 rounded-full bg-black/70 text-white text-xs">
            <Play class="w-4 h-4" />
            HD 1080p
          </div>
          <div class="absolute bottom-4 right-4 flex items-center gap-2">
            <button class="px-3 py-2 rounded-lg bg-white/90 text-slate-900 text-sm font-semibold shadow-sm hover:bg-white">
              Save to path
            </button>
            <button class="p-2 rounded-lg bg-white/90 text-slate-900 shadow-sm hover:bg-white">
              <Download class="w-4 h-4" />
            </button>
          </div>
        </div>

        <div class="p-6 grid gap-6 lg:grid-cols-3">
          <div class="lg:col-span-2 space-y-6">
            <div class="space-y-2">
              <h2 class="text-xl font-semibold text-slate-900">Summary</h2>
              <p class="text-slate-700 leading-relaxed">{{ resource.description }}</p>
            </div>

            <div class="space-y-3">
              <div class="flex items-center justify-between">
                <h3 class="text-lg font-semibold text-slate-900">Chapters</h3>
                <span class="text-xs px-2 py-1 rounded-full bg-slate-100 text-slate-600">{{ chapters.length }} sections</span>
              </div>
              <div class="space-y-2">
                <div v-for="chapter in chapters" :key="chapter.title" class="flex items-center gap-3 p-3 rounded-lg bg-slate-50 border border-slate-100">
                  <div class="h-10 w-10 rounded-lg bg-blue-100 text-blue-700 font-semibold flex items-center justify-center">
                    {{ chapter.order }}
                  </div>
                  <div class="flex-1">
                    <p class="font-semibold text-slate-900">{{ chapter.title }}</p>
                    <p class="text-sm text-slate-600">{{ chapter.duration }}</p>
                  </div>
                  <span class="text-xs text-slate-500">{{ chapter.timestamp }}</span>
                </div>
              </div>
            </div>

            <div class="space-y-3">
              <div class="flex items-center gap-2">
                <AlignLeft class="w-4 h-4 text-slate-500" />
                <h3 class="text-lg font-semibold text-slate-900">Key takeaways</h3>
              </div>
              <ul class="grid sm:grid-cols-2 gap-2 text-sm text-slate-700 list-disc list-inside">
                <li v-for="point in resource.takeaways" :key="point">{{ point }}</li>
              </ul>
            </div>

            <div class="space-y-3">
              <div class="flex items-center gap-2">
                <MessageSquare class="w-4 h-4 text-slate-500" />
                <h3 class="text-lg font-semibold text-slate-900">Transcript preview</h3>
              </div>
              <div class="p-4 rounded-xl bg-slate-50 border border-slate-100 text-sm text-slate-700 leading-relaxed">
                {{ resource.transcript }}
              </div>
            </div>
          </div>

          <div class="space-y-4">
            <div class="p-4 rounded-xl border border-slate-200 bg-slate-50 space-y-3">
              <h3 class="font-semibold text-slate-900">Meta</h3>
              <div class="space-y-2 text-sm text-slate-700">
                <div class="flex items-center gap-2">
                  <LinkIcon class="w-4 h-4 text-slate-500" />
                  <a :href="resource.url" target="_blank" class="text-blue-600 hover:underline">{{ resource.url }}</a>
                </div>
                <div class="flex items-center gap-2">
                  <Calendar class="w-4 h-4 text-slate-500" />
                  <span>Published {{ resource.date }}</span>
                </div>
                <div class="flex items-center gap-2">
                  <UserRound class="w-4 h-4 text-slate-500" />
                  <span>Author {{ resource.author }}</span>
                </div>
                <div class="flex flex-wrap gap-2">
                  <span v-for="tag in resource.tags" :key="tag" class="px-3 py-1 rounded-full bg-white text-slate-800 border border-slate-200 text-xs font-semibold">{{ tag }}</span>
                </div>
              </div>
              <div class="flex gap-2">
                <button class="flex-1 px-3 py-2 rounded-lg bg-blue-600 text-white font-semibold hover:bg-blue-700">Add to path</button>
                <button class="px-3 py-2 rounded-lg border border-slate-200 text-slate-700 hover:bg-white">Bookmark</button>
              </div>
            </div>

            <div class="p-4 rounded-xl border border-slate-200 bg-white space-y-3">
              <div class="flex items-center gap-2">
                <Sparkles class="w-4 h-4 text-amber-500" />
                <h3 class="font-semibold text-slate-900">Recommended next</h3>
              </div>
              <div class="space-y-3">
                <div v-for="rec in recommendations" :key="rec.id" class="flex items-center gap-3 p-3 rounded-lg bg-slate-50 border border-slate-100">
                  <img :src="rec.thumbnail" :alt="rec.title" class="w-14 h-14 object-cover rounded-lg" />
                  <div class="flex-1">
                    <p class="font-semibold text-slate-900">{{ rec.title }}</p>
                    <p class="text-xs text-slate-600">{{ rec.duration }}</p>
                  </div>
                  <RouterLink :to="{ name: 'resource-video', params: { id: rec.id } }" class="text-blue-600 text-sm font-semibold">View</RouterLink>
                </div>
              </div>
            </div>

            <div class="p-4 rounded-xl border border-slate-200 bg-white space-y-3">
              <div class="flex items-center gap-2">
                <MessageSquare class="w-4 h-4 text-green-500" />
                <h3 class="font-semibold text-slate-900">Notes</h3>
              </div>
              <textarea class="w-full min-h-[140px] p-3 rounded-lg border border-slate-200 focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm text-slate-800" placeholder="Write your takeaways or timestamps..." />
              <button class="w-full px-3 py-2 rounded-lg bg-slate-900 text-white font-semibold hover:bg-black">Save note</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, RouterLink } from 'vue-router'
import { AlignLeft, Calendar, Clock, Download, Link as LinkIcon, MessageSquare, Play, ShieldCheck, Sparkles, UserRound } from 'lucide-vue-next'

const route = useRoute()
const resourceId = computed(() => route.params.id as string || '1')

const videoResources = {
  '1': {
    title: 'Advanced React Patterns',
    description: 'Deep dive into render props, compound components, state reducers, and when to reach for each pattern.',
    duration: '45 min',
    thumbnail: 'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=900&h=506&fit=crop',
    videoUrl: 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4',
    url: 'https://example.com/react-patterns',
    date: '2024-12-20',
    author: 'Sarah Chen',
    category: 'Frontend',
    tags: ['React', 'Patterns', 'Frontend'],
    takeaways: ['When to use render props vs. HOCs', 'Composing logic without prop drilling', 'State reducer pattern for reusable state', 'Testing advanced component APIs'],
    transcript: 'In this session we explore how to scale complex React components using composition-first techniques...'
  },
  '4': {
    title: 'TypeScript Deep Dive',
    description: 'Master advanced generics, utility types, and patterns for scalable React + TS applications.',
    duration: '2h 15min',
    thumbnail: 'https://images.unsplash.com/photo-1516116216624-53e697fedbea?w=900&h=506&fit=crop',
    videoUrl: 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4',
    url: 'https://example.com/typescript-deep-dive',
    date: '2024-12-17',
    author: 'Leo Park',
    category: 'Frontend',
    tags: ['TypeScript', 'Types', 'React'],
    takeaways: ['Distributive conditional types', 'Inferring props from JSX usage', 'Safely typing async flows', 'Refining API responses'],
    transcript: 'We start with a refresher on TypeScript’s type system, then move into advanced mapped and conditional types...'
  }
} as const

const resource = computed(() => videoResources[resourceId.value] || Object.values(videoResources)[0])

const chapters = [
  { order: 1, title: 'Setup and goals', duration: '04:12', timestamp: '00:00' },
  { order: 2, title: 'Render props in practice', duration: '12:45', timestamp: '04:12' },
  { order: 3, title: 'Compound components', duration: '10:30', timestamp: '16:57' },
  { order: 4, title: 'State reducers', duration: '08:10', timestamp: '27:27' },
  { order: 5, title: 'Refinement & Q/A', duration: '09:05', timestamp: '35:37' }
]

const recommendations = [
  { id: '4', title: 'TypeScript Deep Dive', duration: '2h 15min', thumbnail: 'https://images.unsplash.com/photo-1516116216624-53e697fedbea?w=300&h=170&fit=crop' },
  { id: '8', title: 'MongoDB Complete Course', duration: '3h 45min', thumbnail: 'https://images.unsplash.com/photo-1551033406-611cf9a28f67?w=300&h=170&fit=crop' }
]
</script>
