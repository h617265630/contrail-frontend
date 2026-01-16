<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="max-w-7xl mx-auto space-y-10">
    <div class="space-y-2">
      <h1 class="text-2xl font-semibold text-gray-900">My Paths</h1>
      <p class="text-gray-600">你创建的 LearningPath 会出现在这里</p>
    </div>

    <!-- LearningPool 分类区域 -->
    <section class="space-y-4">
      <div class="flex items-center justify-between">
        <h2 class="text-xl font-semibold text-gray-900">分类</h2>
        <span class="text-sm text-gray-500">{{ categories.length }} categories</span>
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

    <Card v-if="paths.length === 0" as="section" :hoverable="false" className="rounded-2xl p-8">
      <p class="text-gray-700 font-semibold">还没有创建任何 LearningPath</p>
      <p class="text-gray-600 text-sm mt-1">去 CreatePath 页面创建一个新的学习路径。</p>
      <RouterLink
        to="/createpath"
        class="inline-flex mt-4 px-4 py-2 rounded-lg bg-blue-600 text-white font-semibold hover:bg-blue-700"
      >
        去创建
      </RouterLink>
    </Card>

    <Card
      v-for="path in paths"
      :key="path.id"
      as="section"
      :hoverable="true"
      className="rounded-2xl p-4 cursor-pointer"
      @click="openDetail(path.id)"
    >
      <div class="flex items-center justify-between gap-6">
        <div class="min-w-0">
          <h2 class="text-lg font-semibold text-gray-900 truncate">{{ path.title }}</h2>
          <p class="text-gray-600 text-sm line-clamp-2">{{ path.description || '（无介绍）' }}</p>
        </div>
        <div class="flex items-center gap-2 shrink-0" @click.stop>
          <RouterLink
            :to="{ name: 'learningpath-edit', params: { id: path.id } }"
            class="px-4 py-2 rounded-lg bg-white border border-gray-200 text-gray-700 hover:bg-gray-50 text-sm font-semibold"
          >
            编辑
          </RouterLink>
          <button
            type="button"
            class="px-4 py-2 rounded-lg bg-red-50 border border-red-200 text-red-700 hover:bg-red-100 text-sm font-semibold"
            @click="handleDelete(path.id)"
          >
            删除
          </button>
        </div>
      </div>

      <div class="overflow-x-auto pb-2" @click.stop>
        <div class="flex gap-3 min-w-full">
          <Card
            v-for="item in itemsForPath(path)"
            :key="item.id"
            as="article"
            :hoverable="true"
            className="w-48 sm:w-52 lg:w-56 shrink-0"
          >
            <div class="relative h-20 bg-gray-100">
              <img :src="item.thumbnail" :alt="item.title" class="w-full h-full object-cover" />
            </div>
            <div class="p-3 space-y-1">
              <h3 class="text-gray-900 font-semibold text-xs leading-snug line-clamp-1" :title="item.title">
                {{ item.title }}
              </h3>
              <p class="text-gray-600 text-[11px] mt-1 line-clamp-2" :title="item.description">
                {{ item.description }}
              </p>

              <!-- 可编辑介绍区域 -->
              <div class="mt-2" @click.stop>
                <label class="text-[11px] font-semibold text-gray-700">介绍（可编辑）</label>
                <textarea
                  class="mt-1 w-full resize-none rounded-lg border border-gray-200 bg-white px-2 py-1.5 text-xs text-gray-900 outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  rows="1"
                  :value="getNote(path.id, item.id)"
                  placeholder="写下你对这个资源的备注/总结…"
                  @input="setNote(path.id, item.id, ($event.target as HTMLTextAreaElement).value)"
                />
              </div>

              <!-- 进度条（参考 linear 页面） -->
              <div class="mt-2" @click.stop>
                <div class="flex items-center gap-3">
                  <div class="flex-1 bg-gray-200 rounded-full h-2.5">
                    <div
                      class="h-2.5 rounded-full transition-all duration-300"
                      :class="getProgress(path.id, item.id) >= 100 ? 'bg-green-500' : 'bg-blue-500'"
                      :style="{ width: `${getProgress(path.id, item.id)}%` }"
                    />
                  </div>
                  <span class="text-xs text-blue-600 shrink-0">{{ getProgress(path.id, item.id) }}%</span>
                </div>
              </div>
            </div>
          </Card>
        </div>
      </div>
    </Card>
  </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import Card from '../components/ui/Card.vue'

import { deleteMyLearningPath, listMyLearningPaths, type MyLearningPath } from '../data/myPaths'
import { type Resource } from '../data/resources'
import { listAllResources } from '../data/resourcesStore'
import { learningPoolCategories } from '../data/learningPool'
import {
  getMyPathResourceEntry,
  loadMyPathResourceState,
  saveMyPathResourceState,
  setMyPathResourceEntry,
  type MyPathResourceState,
} from '../data/myPathResourceState'

const paths = ref<MyLearningPath[]>([])
const resourceState = ref<MyPathResourceState>({})

const categories = [...learningPoolCategories]

const router = useRouter()

const resourceById = new Map(listAllResources().map(r => [r.id, r]))

function itemsForPath(path: MyLearningPath): Resource[] {
  return path.resourceIds.map(id => resourceById.get(id)).filter(Boolean) as Resource[]
}

function getNote(pathId: string, resourceId: string) {
  return getMyPathResourceEntry(resourceState.value, pathId, resourceId).note
}

function getProgress(pathId: string, resourceId: string) {
  return getMyPathResourceEntry(resourceState.value, pathId, resourceId).progress
}

function setNote(pathId: string, resourceId: string, note: string) {
  const existing = getMyPathResourceEntry(resourceState.value, pathId, resourceId)
  resourceState.value = setMyPathResourceEntry(resourceState.value, pathId, resourceId, {
    ...existing,
    note,
  })
  saveMyPathResourceState(resourceState.value)
}

function setProgress(pathId: string, resourceId: string, progress: number) {
  const existing = getMyPathResourceEntry(resourceState.value, pathId, resourceId)
  resourceState.value = setMyPathResourceEntry(resourceState.value, pathId, resourceId, {
    ...existing,
    progress,
  })
  saveMyPathResourceState(resourceState.value)
}

onMounted(() => {
  paths.value = listMyLearningPaths()
  resourceState.value = loadMyPathResourceState()
})

function openDetail(id: string) {
  router.push({ name: 'learningpath', params: { id } })
}

function handleDelete(id: string) {
  if (!confirm('确定要删除这个 LearningPath 吗？')) return
  deleteMyLearningPath(id)
  paths.value = listMyLearningPaths()
}
</script>
