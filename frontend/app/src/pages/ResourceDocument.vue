<template>
  <div class="min-h-screen bg-slate-50">
    <div class="max-w-6xl mx-auto p-6 space-y-6">
      <div class="flex flex-col gap-2">
        <p class="text-sm uppercase tracking-wide text-blue-600 font-semibold">Document Resource</p>
        <h1 class="text-3xl font-semibold text-slate-900">{{ resource.title }}</h1>
        <div class="flex flex-wrap items-center gap-3 text-sm text-slate-600">
          <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-blue-100 text-blue-700 font-medium">{{ resource.category }}</span>
          <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-slate-100 text-slate-700">
            <FileText class="w-4 h-4" />
            {{ resource.pages }} pages
          </span>
          <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-100 text-emerald-700">
            <Sparkles class="w-4 h-4" />
            Updated {{ resource.date }}
          </span>
        </div>
      </div>

      <div class="grid gap-6 lg:grid-cols-[2fr_1fr]">
        <div class="bg-white rounded-2xl shadow-sm overflow-hidden border border-slate-100">
          <div class="flex items-center justify-between px-4 py-3 border-b border-slate-100 bg-slate-50">
            <div class="flex items-center gap-2 text-sm text-slate-700">
              <BookOpen class="w-4 h-4 text-blue-600" />
              <span>Reader</span>
            </div>
            <div class="flex items-center gap-2">
              <button class="px-3 py-2 rounded-lg bg-slate-900 text-white text-sm font-semibold hover:bg-black">Start reading</button>
              <button class="p-2 rounded-lg border border-slate-200 text-slate-700 hover:bg-white">
                <Download class="w-4 h-4" />
              </button>
            </div>
          </div>
          <div class="aspect-[4/3] bg-slate-900">
            <iframe :src="resource.previewUrl" class="w-full h-full" title="Document preview"></iframe>
          </div>
          <div class="p-6 space-y-4">
            <div class="space-y-2">
              <h2 class="text-xl font-semibold text-slate-900">Overview</h2>
              <p class="text-slate-700 leading-relaxed">{{ resource.description }}</p>
            </div>
            <div class="grid sm:grid-cols-2 gap-3">
              <div v-for="item in highlights" :key="item" class="flex items-start gap-2 p-3 rounded-lg bg-slate-50 border border-slate-100 text-sm text-slate-700">
                <span class="mt-1 h-2 w-2 rounded-full bg-blue-500"></span>
                <span>{{ item }}</span>
              </div>
            </div>
            <div class="space-y-2">
              <div class="flex items-center gap-2">
                <ListChecks class="w-4 h-4 text-slate-500" />
                <h3 class="text-lg font-semibold text-slate-900">Table of contents</h3>
              </div>
              <ol class="space-y-2 text-sm text-slate-700 list-decimal list-inside">
                <li v-for="section in resource.sections" :key="section.title" class="flex items-center justify-between">
                  <span>{{ section.title }}</span>
                  <span class="text-xs text-slate-500">p. {{ section.page }}</span>
                </li>
              </ol>
            </div>
          </div>
        </div>

        <div class="space-y-4">
          <div class="p-4 rounded-2xl bg-white border border-slate-200 space-y-3">
            <h3 class="font-semibold text-slate-900">Meta</h3>
            <div class="space-y-2 text-sm text-slate-700">
              <div class="flex items-center gap-2">
                <LinkIcon class="w-4 h-4 text-slate-500" />
                <a :href="resource.url" target="_blank" class="text-blue-600 hover:underline">{{ resource.url }}</a>
              </div>
              <div class="flex items-center gap-2">
                <UserRound class="w-4 h-4 text-slate-500" />
                <span>Author {{ resource.author }}</span>
              </div>
              <div class="flex items-center gap-2">
                <GraduationCap class="w-4 h-4 text-slate-500" />
                <span>Level {{ resource.level }}</span>
              </div>
              <div class="flex flex-wrap gap-2">
                <span v-for="tag in resource.tags" :key="tag" class="px-3 py-1 rounded-full bg-slate-100 text-slate-800 text-xs font-semibold">{{ tag }}</span>
              </div>
            </div>
            <div class="grid grid-cols-2 gap-2 text-sm text-slate-800">
              <div class="p-3 rounded-lg bg-slate-50 border border-slate-100 flex items-center justify-between">
                <span>Reading time</span>
                <span class="font-semibold">{{ resource.readingTime }}</span>
              </div>
              <div class="p-3 rounded-lg bg-slate-50 border border-slate-100 flex items-center justify-between">
                <span>Last synced</span>
                <span class="font-semibold">{{ resource.synced }}</span>
              </div>
            </div>
            <div class="flex gap-2">
              <RouterLink
                :to="{ name: 'resource-add-to-path', params: { type: 'document', id: resourceId } }"
                class="flex-1 px-3 py-2 rounded-lg bg-blue-600 text-white font-semibold hover:bg-blue-700 text-center"
              >
                Add to path
              </RouterLink>
              <button class="px-3 py-2 rounded-lg border border-slate-200 text-slate-700 hover:bg-white">Bookmark</button>
            </div>
          </div>

          <div class="p-4 rounded-2xl bg-white border border-slate-200 space-y-3">
            <div class="flex items-center gap-2">
              <MessagesSquare class="w-4 h-4 text-green-500" />
              <h3 class="font-semibold text-slate-900">Notes</h3>
            </div>
            <textarea class="w-full min-h-[140px] p-3 rounded-lg border border-slate-200 focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm text-slate-800" placeholder="Capture learnings or next steps" />
            <button class="w-full px-3 py-2 rounded-lg bg-slate-900 text-white font-semibold hover:bg-black">Save note</button>
          </div>

          <div class="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-3">
            <div class="flex items-center gap-2">
              <Sparkles class="w-4 h-4 text-amber-500" />
              <h3 class="font-semibold text-slate-900">Related reads</h3>
            </div>
            <div class="space-y-3">
              <div v-for="doc in related" :key="doc.id" class="flex items-center gap-3 p-3 rounded-lg bg-white border border-slate-100">
                <div class="h-12 w-12 rounded-lg bg-blue-50 text-blue-700 font-semibold flex items-center justify-center">PDF</div>
                <div class="flex-1">
                  <p class="font-semibold text-slate-900">{{ doc.title }}</p>
                  <p class="text-xs text-slate-600">{{ doc.pages }} pages</p>
                </div>
                <RouterLink :to="{ name: 'resource-document', params: { id: doc.id } }" class="text-blue-600 text-sm font-semibold">Open</RouterLink>
              </div>
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
import { BookOpen, Download, FileText, GraduationCap, Link as LinkIcon, ListChecks, MessagesSquare, Sparkles, UserRound } from 'lucide-vue-next'

const route = useRoute()
const resourceId = computed(() => route.params.id as string || '2')

type DocumentResource = {
  title: string
  description: string
  pages: number
  previewUrl: string
  url: string
  date: string
  author: string
  category: string
  tags: readonly string[]
  sections: readonly { title: string; page: number }[]
  readingTime: string
  synced: string
  level: string
}

const documentResources: Record<string, DocumentResource> = {
  '2': {
    title: 'Node.js Best Practices',
    description: 'Comprehensive guide to writing production-ready Node.js applications with clean architecture and observability in mind.',
    pages: 85,
    previewUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    url: 'https://example.com/nodejs-best-practices',
    date: '2024-12-19',
    author: 'Alex Rivera',
    category: 'Backend',
    tags: ['Node.js', 'Backend', 'Architecture'],
    sections: [
      { title: 'Foundations', page: 4 },
      { title: 'API design principles', page: 18 },
      { title: 'Observability and logging', page: 36 },
      { title: 'Security hardening', page: 52 },
      { title: 'Deployment checklist', page: 72 }
    ],
    readingTime: '45 min',
    synced: 'Today',
    level: 'Intermediate'
  },
  '5': {
    title: 'Docker & Kubernetes Guide',
    description: 'Complete guide to containerization and orchestration with Docker and Kubernetes, including production checklists.',
    pages: 120,
    previewUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    url: 'https://example.com/docker-k8s',
    date: '2024-12-16',
    author: 'Priya Nair',
    category: 'DevOps',
    tags: ['Docker', 'Kubernetes', 'DevOps'],
    sections: [
      { title: 'Container basics', page: 5 },
      { title: 'Orchestrating workloads', page: 28 },
      { title: 'Security and policies', page: 54 },
      { title: 'Observability', page: 78 },
      { title: 'Scaling and costs', page: 102 }
    ],
    readingTime: '1h 10min',
    synced: 'Yesterday',
    level: 'Advanced'
  }
}

const resource = computed(() => documentResources[resourceId.value] || Object.values(documentResources)[0])

const highlights = [
  'Architecture decisions with practical examples',
  'Checklists you can apply immediately',
  'Instrumentation patterns that scale',
  'Security defaults for production'
]

const related = [
  { id: '5', title: 'Docker & Kubernetes Guide', pages: 120 },
  { id: '9', title: 'CI/CD Pipeline Setup', pages: 45 }
]
</script>
