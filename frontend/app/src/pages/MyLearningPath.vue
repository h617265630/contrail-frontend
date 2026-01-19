<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="max-w-7xl mx-auto space-y-10">
    <div class="space-y-2">
      <h1 class="text-2xl font-semibold text-gray-900">My Paths</h1>
      <p class="text-gray-600">只显示你在数据库中创建/添加的 LearningPath</p>
    </div>

    <Card v-if="loading" as="section" :hoverable="false" className="rounded-2xl p-6">
      <p class="text-gray-700 font-semibold">Loading…</p>
    </Card>

    <Card v-else-if="error" as="section" :hoverable="false" className="rounded-2xl p-6">
      <p class="text-red-600 font-semibold">{{ error }}</p>
    </Card>

    <Card v-else-if="paths.length === 0" as="section" :hoverable="false" className="rounded-2xl p-8">
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
            :to="{ name: 'learningpath-edit', params: { id: String(path.id) } }"
            class="px-4 py-2 rounded-lg bg-white border border-gray-200 text-gray-700 hover:bg-gray-50 text-sm font-semibold"
          >
            编辑
          </RouterLink>
          <button
            type="button"
            class="px-4 py-2 rounded-lg bg-red-50 border border-red-200 text-red-700 hover:bg-red-100 text-sm font-semibold"
            @click="openDeleteConfirm(path.id)"
          >
            删除
          </button>
        </div>
      </div>
    </Card>
  </div>
  </div>

  <div v-if="showDeleteConfirm" class="fixed inset-0 bg-black/20 backdrop-blur-sm flex items-center justify-center p-4 z-50">
    <div class="bg-white rounded-xl shadow-2xl max-w-md w-full">
      <div class="p-6 border-b border-gray-200 flex items-center justify-between">
        <h2 class="text-gray-900 text-lg font-semibold">确认删除</h2>
        <button type="button" class="text-gray-400 hover:text-gray-600" @click="closeDeleteConfirm">
          <span class="sr-only">Close</span>
          ×
        </button>
      </div>

      <div class="p-6 space-y-3">
        <p class="text-gray-700">确定要删除这个 LearningPath 吗？</p>
        <p class="text-sm text-gray-500">删除后将无法恢复。</p>
      </div>

      <div class="p-6 pt-0 flex items-center justify-end gap-3">
        <button
          type="button"
          class="px-4 py-2 rounded-lg bg-white border border-gray-200 text-gray-700 hover:bg-gray-50 font-semibold"
          @click="closeDeleteConfirm"
        >
          取消
        </button>
        <button
          type="button"
          class="px-4 py-2 rounded-lg bg-pink-600 text-white hover:bg-pink-700 font-semibold"
          @click="confirmDelete"
        >
          删除
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import Card from '../components/ui/Card.vue'

import { deleteMyLearningPath, listMyLearningPaths, type MyLearningPath } from '../api/learningPath'

const paths = ref<MyLearningPath[]>([])
const loading = ref(false)
const error = ref('')

const router = useRouter()

const showDeleteConfirm = ref(false)
const deleteTargetId = ref<number | null>(null)

async function loadPaths() {
  loading.value = true
  error.value = ''
  try {
    const data = await listMyLearningPaths()
    paths.value = Array.isArray(data) ? data : []
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || 'Failed to load learning paths')
  } finally {
    loading.value = false
  }
}

onMounted(loadPaths)

function openDetail(id: number) {
  router.push({ name: 'learningpath', params: { id: String(id) }, query: { from: 'my-paths' } })
}

function openDeleteConfirm(id: number) {
  deleteTargetId.value = id
  showDeleteConfirm.value = true
}

function closeDeleteConfirm() {
  showDeleteConfirm.value = false
  deleteTargetId.value = null
}

async function confirmDelete() {
  if (deleteTargetId.value == null) return
  try {
    await deleteMyLearningPath(deleteTargetId.value)
    await loadPaths()
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || 'Failed to delete learning path')
  } finally {
    closeDeleteConfirm()
  }
}
</script>
