<template>
  <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <div class="mb-6">
      <button
        @click="$router.back()"
        class="inline-flex items-center gap-2 text-gray-600 hover:text-gray-900 transition-colors"
      >
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
        </svg>
        返回
      </button>
    </div>

    <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
      <div class="border-b border-gray-200 p-6">
        <h1 class="text-2xl font-bold text-gray-900">添加新资源</h1>
        <p class="mt-2 text-sm text-gray-600">选择平台并输入资源链接，系统将自动解析资源信息</p>
      </div>

      <div class="p-6 space-y-6">
        <!-- 平台选择和URL输入 -->
        <div>
          <label class="block text-sm font-semibold text-gray-700 mb-3">资源链接</label>
          <div class="flex gap-3">
            <select
              v-model="selectedPlatform"
              class="w-48 px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white cursor-pointer"
            >
              <option value="">选择平台</option>
              <option v-for="p in supportedPlatforms" :key="p.key" :value="p.key">
                {{ p.label }}
              </option>
            </select>
            <input
              v-model="urlInput"
              type="url"
              :placeholder="selectedPlatformPlaceholder"
              class="flex-1 px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
          <p v-if="extractError" class="mt-2 text-sm text-red-600">{{ extractError }}</p>
        </div>

        <!-- 分类选择 -->
        <div>
          <label class="block text-sm font-semibold text-gray-700 mb-3">分类</label>
          <div class="relative">
            <Tag class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <select
              v-model="categoryId"
              class="w-full appearance-none pl-10 pr-10 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white cursor-pointer"
            >
              <option value="">选择分类</option>
              <option v-for="c in dbCategories" :key="c.id" :value="String(c.id)">{{ c.name }}</option>
            </select>
            <ChevronDown class="absolute right-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400 pointer-events-none" />
          </div>
        </div>

        <!-- 资源状态 -->
        <div>
          <label class="block text-sm font-semibold text-gray-700 mb-3">资源状态</label>
          <div class="flex items-center space-x-4">
            <label class="flex items-center cursor-pointer">
              <input type="radio" v-model="isPublic" :value="true" class="mr-2">
              <span class="text-gray-700">公开</span>
            </label>
            <label class="flex items-center cursor-pointer">
              <input type="radio" v-model="isPublic" :value="false" class="mr-2">
              <span class="text-gray-700">私有</span>
            </label>
          </div>
        </div>

        <!-- 解析信息 -->
        <div class="rounded-lg border border-gray-200 bg-gray-50 p-6">
          <div class="flex items-center justify-between gap-3 mb-4">
            <h3 class="text-gray-900 text-base font-semibold">解析信息</h3>
            <span v-if="extracting" class="text-sm text-gray-500">解析中...</span>
          </div>

          <div v-if="!extractedMeta && !extracting" class="text-center py-8 text-gray-500">
            请输入资源链接，系统将自动解析
          </div>

          <div v-else class="space-y-4">
            <div v-if="extractedMeta?.thumbnail_url" class="rounded-lg border border-gray-200 bg-white p-3">
              <img
                :src="extractedMeta.thumbnail_url"
                :alt="extractedMeta?.title || 'thumbnail'"
                class="h-48 w-full object-cover rounded-md"
              />
            </div>

            <div>
              <div class="text-xs font-semibold text-gray-500 mb-1">标题</div>
              <div class="text-sm text-gray-900">{{ extractedMeta?.title || '—' }}</div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <div class="text-xs font-semibold text-gray-500 mb-1">作者</div>
                <div class="text-sm text-gray-700">{{ extractedMeta?.author || '—' }}</div>
              </div>
              <div>
                <div class="text-xs font-semibold text-gray-500 mb-1">发布日期</div>
                <div class="text-sm text-gray-700">{{ formatExtractDate(extractedMeta?.publish_date || null) || '—' }}</div>
              </div>
            </div>

            <div>
              <div class="text-xs font-semibold text-gray-500 mb-1">视频 ID</div>
              <div class="text-sm text-gray-700">{{ extractedMeta?.video_id || '—' }}</div>
            </div>

            <div>
              <div class="text-xs font-semibold text-gray-500 mb-1">描述</div>
              <div class="text-sm text-gray-700 whitespace-pre-wrap max-h-48 overflow-auto">{{ extractedMeta?.description || '—' }}</div>
            </div>

            <div>
              <div class="text-xs font-semibold text-gray-500 mb-1">章节</div>
              <div v-if="(extractedMeta?.chapters || []).length === 0" class="text-sm text-gray-700">—</div>
              <div v-else class="max-h-64 overflow-auto rounded-lg border border-gray-200 bg-white">
                <div
                  v-for="ch in (extractedMeta?.chapters || []).slice(0, 12)"
                  :key="ch.start_seconds + ':' + ch.title"
                  class="flex items-start justify-between gap-3 px-3 py-2 border-b border-gray-100 last:border-b-0"
                >
                  <div class="min-w-0">
                    <div class="text-sm text-gray-900">{{ ch.title }}</div>
                    <div v-if="ch.description" class="text-xs text-gray-500 mt-0.5">{{ ch.description }}</div>
                  </div>
                  <div class="shrink-0 text-xs font-semibold text-gray-500">{{ ch.timestamp }}</div>
                </div>
              </div>
              <div v-if="(extractedMeta?.chapters || []).length > 12" class="mt-1 text-xs text-gray-500">
                仅展示前 12 条章节
              </div>
            </div>
          </div>
        </div>

        <p v-if="submitError" class="text-sm text-red-600">{{ submitError }}</p>
      </div>

      <div class="bg-gray-50 border-t border-gray-200 p-6 flex gap-3 justify-end">
        <button
          type="button"
          @click="$router.back()"
          class="px-6 py-2.5 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors font-semibold"
        >
          取消
        </button>
        <button
          type="button"
          @click="confirmAdd"
          :disabled="!urlInput || extracting || !extractedMeta?.title || submitting"
          class="px-6 py-2.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed font-semibold"
        >
          {{ submitting ? '保存中...' : '添加资源' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { ChevronDown, Tag } from 'lucide-vue-next'
import { createMyResourceFromUrl, extractVideoMetadata, type UrlExtractResponse } from '../api/resource'
import { listCategories, type Category } from '../api/category'

const router = useRouter()

const supportedPlatforms = [
  { key: 'youtube', label: 'YouTube', placeholder: 'https://www.youtube.com/watch?v=...' },
  { key: 'bilibili', label: 'Bilibili', placeholder: 'https://www.bilibili.com/video/...' },
  { key: 'xiaohongshu', label: '小红书', placeholder: 'https://www.xiaohongshu.com/explore/...' },
  { key: 'github', label: 'GitHub', placeholder: 'https://github.com/... (repo / issue / doc)' },
  { key: 'medium', label: 'Medium', placeholder: 'https://medium.com/.../...' },
  { key: 'reddit', label: 'Reddit', placeholder: 'https://www.reddit.com/r/.../comments/...' },
  { key: 'substack', label: 'Substack', placeholder: 'https://xxx.substack.com/p/...' },
  { key: 'devto', label: 'Dev.to', placeholder: 'https://dev.to/.../...' },
]

const selectedPlatform = ref('')
const urlInput = ref('')
const extracting = ref(false)
const extractError = ref('')
const extractedMeta = ref<UrlExtractResponse | null>(null)
const submitting = ref(false)
const submitError = ref('')
const isPublic = ref(true)

const dbCategories = ref<Category[]>([])
const categoryId = ref('')

const selectedPlatformPlaceholder = computed(() => {
  if (!selectedPlatform.value) return '请先选择平台'
  const platform = supportedPlatforms.find(p => p.key === selectedPlatform.value)
  return platform?.placeholder || '输入资源链接'
})

function formatExtractDate(iso?: string | null) {
  if (!iso) return ''
  const d = new Date(iso)
  if (Number.isNaN(d.getTime())) return ''
  return d.toLocaleDateString()
}

async function loadCategories() {
  try {
    dbCategories.value = await listCategories()
    const other = dbCategories.value.find(c => String(c.code).toLowerCase() === 'other')
    if (other && !categoryId.value) categoryId.value = String(other.id)
  } catch (e: any) {
    console.error('Error loading categories:', e)
    dbCategories.value = []
  }
}

async function confirmAdd() {
  if (!urlInput.value || !extractedMeta.value?.title) return
  submitError.value = ''
  submitting.value = true
  try {
    const catId = categoryId.value ? Number(categoryId.value) : NaN
    if (!Number.isFinite(catId)) throw new Error('请选择分类')
    await createMyResourceFromUrl(urlInput.value, { 
      category_id: catId,
      is_public: isPublic.value
    })
    router.push({ name: 'my-resources' })
  } catch (e: any) {
    const msg = e?.response?.data?.detail || e?.message || 'Failed to add resource'
    submitError.value = String(msg)
  } finally {
    submitting.value = false
  }
}

let extractTimer: number | null = null
watch(
  () => urlInput.value,
  (nextUrl) => {
    extractError.value = ''
    extractedMeta.value = null

    if (extractTimer) {
      clearTimeout(extractTimer)
      extractTimer = null
    }

    const raw = String(nextUrl || '').trim()
    if (!raw) {
      extracting.value = false
      return
    }

    extracting.value = true
    extractTimer = window.setTimeout(() => {
      extractVideoMetadata(raw)
        .then((res) => {
          extractedMeta.value = res
          extracting.value = false
        })
        .catch((err) => {
          const msg = err?.response?.data?.detail || err?.message || '解析失败'
          extractError.value = String(msg)
          extracting.value = false
        })
    }, 1200) as unknown as number
  },
  { immediate: false }
)

onMounted(() => {
  void loadCategories()
})
</script>
