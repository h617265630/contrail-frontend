<template>
  <div class="min-h-screen bg-slate-50">
    <div class="max-w-7xl mx-auto p-6 space-y-6">
      <div class="flex items-center justify-between gap-4">
        <div class="min-w-0">
          <h1 class="text-2xl font-semibold text-slate-900 truncate">Add Resource to LearningPath</h1>
          <p class="text-sm text-slate-600">选择一个 learningpath，并查看其内容</p>
        </div>
        <RouterLink
          to="/mypaths"
          class="px-4 py-2 rounded-lg bg-white border border-slate-200 text-slate-700 text-sm font-semibold hover:bg-slate-50"
        >
          返回 MyPaths
        </RouterLink>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Column 1: Resource -->
        <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
          <div class="p-4 border-b border-slate-100 bg-slate-50">
            <h2 class="text-slate-900 font-semibold">Resource</h2>
            <p class="text-sm text-slate-600">根据 id 展示</p>
          </div>

          <div v-if="resource" class="p-4 space-y-3">
            <div class="h-36 rounded-xl bg-slate-100 overflow-hidden">
              <img :src="resource.thumbnail" :alt="resource.title" class="w-full h-full object-cover" />
            </div>
            <div class="space-y-1">
              <div class="text-slate-900 font-semibold">{{ resource.title }}</div>
              <div class="text-sm text-slate-600 line-clamp-3">{{ resource.description }}</div>
            </div>
            <div class="flex flex-wrap gap-2">
              <span class="px-2 py-1 rounded-full bg-blue-50 text-blue-700 text-xs font-semibold">{{ resource.category }}</span>
              <span class="px-2 py-1 rounded-full bg-slate-100 text-slate-700 text-xs">{{ resource.type }}</span>
              <span v-if="resource.type === 'video' && resource.duration" class="px-2 py-1 rounded-full bg-slate-100 text-slate-700 text-xs">
                {{ resource.duration }}
              </span>
              <span v-if="resource.type !== 'video' && resource.pages" class="px-2 py-1 rounded-full bg-slate-100 text-slate-700 text-xs">
                {{ resource.pages }} pages
              </span>
            </div>
          </div>

          <div v-else class="p-6 text-sm text-slate-600">未找到该资源（id: {{ resourceId }}）</div>
        </div>

        <!-- Column 2: All LearningPaths -->
        <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
          <div class="p-4 border-b border-slate-100 bg-slate-50">
            <h2 class="text-slate-900 font-semibold">My LearningPaths</h2>
            <p class="text-sm text-slate-600">选择一个路径</p>
          </div>

          <div v-if="paths.length === 0" class="p-6 space-y-3">
            <div class="text-sm text-slate-700 font-semibold">还没有创建任何 LearningPath</div>
            <RouterLink
              to="/createpath"
              class="inline-flex px-4 py-2 rounded-lg bg-blue-600 text-white text-sm font-semibold hover:bg-blue-700"
            >
              去创建
            </RouterLink>
          </div>

          <div v-else class="p-3 space-y-2">
            <button
              v-for="p in paths"
              :key="p.id"
              type="button"
              class="w-full text-left rounded-xl border px-4 py-3 hover:bg-slate-50 transition"
              :class="selectedPathId === p.id ? 'border-blue-500 bg-blue-50/40' : 'border-slate-200 bg-white'"
              @click="selectedPathId = p.id"
            >
              <div class="flex items-start justify-between gap-3">
                <div class="min-w-0">
                  <div class="font-semibold text-slate-900 truncate">{{ p.title }}</div>
                  <div class="text-xs text-slate-600 line-clamp-2">{{ p.description || '（无介绍）' }}</div>
                </div>
                <div class="text-xs text-slate-500 flex-shrink-0">{{ p.resourceIds.length }} items</div>
              </div>
            </button>
          </div>
        </div>

        <!-- Column 3: Selected LearningPath detail -->
        <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
          <div class="p-4 border-b border-slate-100 bg-slate-50">
            <h2 class="text-slate-900 font-semibold">Selected Path</h2>
            <p class="text-sm text-slate-600">默认展示第一条</p>
          </div>

          <div v-if="!selectedPath" class="p-6 text-sm text-slate-600">暂无可展示的 LearningPath</div>

          <div v-else class="p-4 space-y-4">
            <div>
              <div class="text-lg font-semibold text-slate-900">{{ selectedPath.title }}</div>
              <div class="text-sm text-slate-600 mt-1">{{ selectedPath.description || '（无介绍）' }}</div>
            </div>

            <div class="space-y-2">
              <div class="text-sm font-semibold text-slate-900">内容</div>
              <div v-if="selectedItems.length === 0" class="text-sm text-slate-600">（该路径暂无资源）</div>
              <div v-else class="space-y-2">
                <div
                  v-for="it in selectedItems"
                  :key="it.id"
                  class="flex items-start gap-3 rounded-xl border border-slate-200 bg-white p-3"
                >
                  <img :src="it.thumbnail" :alt="it.title" class="h-14 w-14 rounded-lg object-cover bg-slate-100" />
                  <div class="min-w-0 flex-1">
                    <div class="font-semibold text-slate-900 line-clamp-1">{{ it.title }}</div>
                    <div class="text-xs text-slate-600 line-clamp-2">{{ it.description }}</div>
                    <div class="mt-1 flex flex-wrap gap-2">
                      <span class="px-2 py-0.5 rounded-full bg-blue-50 text-blue-700 text-xs font-semibold">{{ it.category }}</span>
                      <span class="px-2 py-0.5 rounded-full bg-slate-100 text-slate-700 text-xs">{{ it.type }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { RouterLink, useRoute } from 'vue-router'

import { listMyLearningPaths, type MyLearningPath } from '../data/myPaths'
import { getResourceById, listAllResources } from '../data/resourcesStore'
import type { Resource } from '../data/resources'

const route = useRoute()

const resourceType = computed(() => (route.params.type as string) || 'document')
const resourceId = computed(() => (route.params.id as string) || '')

const paths = ref<MyLearningPath[]>(listMyLearningPaths())
const selectedPathId = ref<string>('')

watch(
  () => paths.value,
  (next) => {
    if (selectedPathId.value) return
    if (next.length > 0) selectedPathId.value = next[0].id
  },
  { immediate: true },
)

const resource = computed<Resource | null>(() => {
  // Prefer unified resources store
  const r = getResourceById(resourceId.value)
  return r ?? null
})

const selectedPath = computed<MyLearningPath | null>(() => {
  if (!selectedPathId.value) return null
  return paths.value.find(p => p.id === selectedPathId.value) ?? null
})

const selectedItems = computed<Resource[]>(() => {
  const p = selectedPath.value
  if (!p) return []

  const byId = new Map(listAllResources().map(r => [r.id, r]))
  return p.resourceIds.map(id => byId.get(id)).filter(Boolean) as Resource[]
})
</script>
