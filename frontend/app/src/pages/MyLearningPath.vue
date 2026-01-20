<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="max-w-7xl mx-auto space-y-10">
    <div class="flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
      <div class="space-y-2">
        <h1 class="text-2xl font-semibold text-gray-900">My Paths</h1>
        <p class="text-gray-600">只显示你在数据库中创建/添加的 LearningPath</p>
      </div>

      <div class="inline-flex rounded-lg bg-white border border-gray-200 p-1 w-fit">
        <button
          type="button"
          class="px-3 py-1.5 rounded-md text-sm font-semibold"
          :class="viewMode === 'grid' ? 'bg-gray-900 text-white' : 'text-gray-700 hover:bg-gray-50'"
          @click="viewMode = 'grid'"
        >
          卡片
        </button>
        <button
          type="button"
          class="px-3 py-1.5 rounded-md text-sm font-semibold"
          :class="viewMode === 'list' ? 'bg-gray-900 text-white' : 'text-gray-700 hover:bg-gray-50'"
          @click="viewMode = 'list'"
        >
          列表
        </button>
      </div>
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

    <section v-else-if="viewMode === 'grid'" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
      <Card
        v-for="path in paths"
        :key="path.id"
        as="article"
        :hoverable="true"
        className="rounded-2xl p-3 cursor-pointer"
        @click="openDetail(path.id)"
      >
        <div class="rounded-xl overflow-hidden bg-gray-100 aspect-video relative">
          <img
            v-if="coverFor(path.id)"
            :src="coverFor(path.id)"
            :alt="path.title"
            class="w-full h-full object-cover object-left-top"
            loading="lazy"
          />
          <div
            v-else
            class="absolute inset-0 bg-linear-to-br from-blue-50 to-indigo-100 flex flex-col items-center justify-center"
          >
            <ImageIcon class="w-10 h-10 text-blue-600" />
            <div class="mt-2 text-xs font-semibold text-gray-700 text-center px-2">
              {{ path.category_name || 'Learning Path' }}
            </div>
          </div>
        </div>

        <div class="mt-3 min-w-0">
          <h2 class="text-sm font-semibold text-gray-900 line-clamp-1">{{ path.title }}</h2>
          <p class="mt-1 text-gray-600 text-xs line-clamp-3">{{ path.description || '（无介绍）' }}</p>
        </div>

        <div class="mt-3 flex items-center gap-2" @click.stop>
          <RouterLink
            :to="{ name: 'learningpath-edit', params: { id: String(path.id) } }"
            class="flex-1 px-3 py-2 rounded-lg bg-white border border-gray-200 text-gray-700 hover:bg-gray-50 text-xs font-semibold text-center"
          >
            编辑
          </RouterLink>
          <button
            type="button"
            class="flex-1 px-3 py-2 rounded-lg bg-red-50 border border-red-200 text-red-700 hover:bg-red-100 text-xs font-semibold"
            @click="openDeleteConfirm(path.id)"
          >
            删除
          </button>
        </div>
      </Card>
    </section>

    <section v-else class="space-y-3">
      <Card
        v-for="path in paths"
        :key="path.id"
        as="article"
        :hoverable="true"
        className="rounded-2xl p-4 cursor-pointer"
        @click="openDetail(path.id)"
      >
        <div class="flex gap-4">
          <div class="w-32 shrink-0 rounded-xl overflow-hidden bg-gray-100 aspect-video relative">
            <img
              v-if="coverFor(path.id)"
              :src="coverFor(path.id)"
              :alt="path.title"
              class="w-full h-full object-cover object-left-top"
              loading="lazy"
            />
            <div
              v-else
              class="absolute inset-0 bg-linear-to-br from-blue-50 to-indigo-100 flex flex-col items-center justify-center"
            >
              <ImageIcon class="w-7 h-7 text-blue-600" />
            </div>
          </div>

          <div class="min-w-0 flex-1">
            <h2 class="text-base font-semibold text-gray-900 line-clamp-1">{{ path.title }}</h2>
            <p class="mt-1 text-gray-600 text-sm line-clamp-2">{{ path.description || '（无介绍）' }}</p>

            <div class="mt-3 flex items-center gap-2" @click.stop>
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
        </div>
      </Card>
    </section>
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

import { deleteMyLearningPath, getMyLearningPathDetail, listMyLearningPaths, type MyLearningPath } from '../api/learningPath'
import { getMyResourceDetail, getResourceDetail } from '../api/resource'
import { Image as ImageIcon } from 'lucide-vue-next'

const paths = ref<MyLearningPath[]>([])
const loading = ref(false)
const error = ref('')

const viewMode = ref<'grid' | 'list'>('grid')

const coverByPathId = ref<Record<number, string>>({})

const router = useRouter()

const showDeleteConfirm = ref(false)
const deleteTargetId = ref<number | null>(null)

async function loadPaths() {
  loading.value = true
  error.value = ''
  try {
    const data = await listMyLearningPaths()
    paths.value = Array.isArray(data) ? data : []

    // Load cover images from the first resource in each path.
    await Promise.allSettled(
      paths.value.map(async (p) => {
        try {
          const explicitCover = String((p as any)?.cover_image_url || '').trim()
          if (explicitCover) {
            coverByPathId.value[p.id] = explicitCover
            return
          }

          const detail = await getMyLearningPathDetail(p.id)
          const items = Array.isArray(detail.path_items) ? detail.path_items : []

          // “第一个 resource”：优先按 position 最小的 path item；如果 position 异常则按返回顺序。
          let first = items[0] || null
          for (const it of items) {
            const a = Number((first as any)?.position)
            const b = Number((it as any)?.position)
            const aOk = Number.isFinite(a)
            const bOk = Number.isFinite(b)
            if (!first) {
              first = it
              continue
            }
            if (bOk && (!aOk || b < a)) {
              first = it
            }
          }

          let thumb = String((first as any)?.resource_data?.thumbnail_url || '').trim()

          // 如果学习路径详情里没带缩略图，则回退去拉一次 resource 详情（先 public，再 my）。
          if (!thumb) {
            const rid = Number((first as any)?.resource_id)
            if (Number.isFinite(rid) && rid > 0) {
              try {
                const r = await getResourceDetail(rid)
                thumb = String(r?.thumbnail_url || '').trim()
              } catch {
                try {
                  const r = await getMyResourceDetail(rid)
                  thumb = String(r?.thumbnail_url || '').trim()
                } catch {
                  // ignore
                }
              }
            }
          }

          // Rule: use first resource thumbnail if present; otherwise show placeholder.
          coverByPathId.value[p.id] = thumb
        } catch {
          coverByPathId.value[p.id] = coverByPathId.value[p.id] || ''
        }
      }),
    )
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

function coverFor(id: number) {
  return String(coverByPathId.value[id] || '').trim()
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
