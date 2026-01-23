<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <div class="flex items-center justify-between mb-6">
      <h1 class="text-2xl font-bold text-gray-900">我的资源</h1>
      <button
        @click="openAddModal"
        class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-semibold"
      >
        Add Resource
      </button>
    </div>

    <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
      <div class="p-6 border-b border-gray-200">
        <div class="flex flex-col sm:flex-row gap-4 items-start sm:items-center">
          <div class="flex-1">
            <div class="relative">
              <Search class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                v-model="searchKeyword"
                placeholder="搜索资源标题..."
                class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
          </div>
          <div class="flex gap-2">
            <select
              v-model="filterCategory"
              class="px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">全部分类</option>
              <option v-for="cat in dbCategories" :key="cat.id" :value="cat.id">
                {{ cat.name }}
              </option>
            </select>
            <select
              v-model="filterType"
              class="px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">全部类型</option>
              <option value="video">视频</option>
              <option value="article">文章</option>
              <option value="document">文档</option>
            </select>
          </div>
        </div>
      </div>

      <div class="p-6">
        <div v-if="loading" class="text-center py-12">
          <div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
          <p class="mt-3 text-gray-600">加载中...</p>
        </div>
        <div v-else-if="resources.length === 0" class="text-center py-12">
          <p class="text-gray-600">暂无资源</p>
        </div>
        <div v-else class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-6">
          <div
            v-for="resource in filteredResources"
            :key="resource.id"
            class="bg-white rounded-xl shadow-lg overflow-hidden transition-all cursor-pointer h-90 flex flex-col hover:shadow-xl"
            @click="viewResource(resource)"
          >
            <div class="relative h-32">
              <img :src="resource.thumbnail || fallbackThumb" :alt="resource.title" class="w-full h-full object-cover" />
              <div class="absolute top-3 right-3">
                <span class="px-2 py-1 rounded-full flex items-center gap-1 bg-blue-100 text-blue-700 text-xs font-semibold">
                  {{ resource.type }}
                </span>
              </div>
              <div class="absolute bottom-3 left-3">
                <span class="px-2 py-1 rounded-full bg-black bg-opacity-60 text-white text-xs flex items-center gap-1">
                  {{ resource.platform || '—' }}
                </span>
              </div>
            </div>
            <div class="p-4 flex flex-col flex-1 min-h-0">
              <h3 class="text-gray-900 font-semibold text-sm truncate mb-2">{{ resource.title }}</h3>
              <p class="text-gray-600 text-sm mb-3 line-clamp-3">{{ resource.summary }}</p>
              <div class="space-y-1 text-xs text-gray-600 mb-3">
                <div class="flex items-center justify-between gap-3">
                  <span class="text-gray-500">分类</span>
                  <span class="font-semibold text-gray-700 truncate">{{ resource.category || '—' }}</span>
                </div>
                <div class="flex items-center justify-between gap-3">
                  <span class="text-gray-500">添加时间</span>
                  <span class="font-semibold text-gray-700">{{ resource.addedDate || '—' }}</span>
                </div>
              </div>
              <div class="mt-auto">
                <div class="flex items-center gap-1 justify-start mb-2">
                  <button
                    type="button"
                    class="inline-flex items-center gap-1 rounded bg-gray-100 px-2 py-1 text-xs font-semibold text-gray-700 hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed"
                    @click.stop="togglePublic(resource)"
                    :disabled="publicUpdatingId === resource.id"
                    aria-label="Toggle public/private"
                  >
                    <span>{{ resource.is_public ? '公开' : '私有' }}</span>
                    <span class="ml-1 relative h-4 w-7 rounded-full transition-colors" :class="resource.is_public ? 'bg-green-500' : 'bg-gray-300'">
                      <span class="absolute left-0.5 top-0.5 h-3 w-3 rounded-full bg-white transition-transform" :class="resource.is_public ? 'translate-x-3' : ''" />
                    </span>
                  </button>
                </div>
                <div class="flex items-center gap-1 justify-start">
                  <button @click.stop="viewResource(resource)" class="flex-1 px-2 py-1 bg-blue-600 text-white rounded hover:bg-blue-700 transition-colors text-xs font-semibold">View</button>
                  <button type="button" class="flex-1 px-2 py-1 rounded bg-white border border-gray-200 text-gray-700 hover:bg-gray-50 font-semibold text-xs" @click.stop="editResource(resource)">Edit</button>
                  <button type="button" class="flex-1 px-2 py-1 rounded bg-pink-600 text-white hover:bg-pink-700 font-semibold text-xs disabled:opacity-50 disabled:cursor-not-allowed" :disabled="deletingId === resource.id" @click.stop="deleteResource(resource)">{{ deletingId === resource.id ? 'Deleting…' : 'Delete' }}</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 添加资源模态框 -->
    <div v-if="showAddModal" class="fixed inset-0 bg-black/20 backdrop-blur-sm flex items-center justify-center p-4 z-50">
      <div class="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b border-gray-200 p-6 flex items-center justify-between">
          <h2 class="text-gray-900">Add New Resource</h2>
          <button type="button" @click="closeAddModal" class="text-gray-400 hover:text-gray-600">
            <X class="w-6 h-6" />
          </button>
        </div>

        <div class="p-6 space-y-4">
          <div>
            <label class="block text-gray-700 mb-2">支持的平台（任选其一填写链接）</label>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
              <div v-for="p in supportedPlatforms" :key="p.key" class="rounded-lg border border-gray-200 bg-white p-3">
                <div class="text-xs font-semibold text-gray-700 mb-2">{{ p.label }}</div>
                <input
                  type="url"
                  :placeholder="p.placeholder"
                  v-model="(platformUrlInputs as any)[p.key]"
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
            </div>
            <p class="mt-2 text-xs text-gray-500">已自动选择第一个非空输入作为解析与提交的 URL。</p>
            <p v-if="extractError" class="mt-2 text-sm text-red-600">{{ extractError }}</p>
          </div>

          <div>
            <label class="block text-gray-700 mb-2">Category</label>
            <div class="relative">
              <Tag class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <select
                v-model="addCategoryId"
                class="w-full appearance-none pl-10 pr-10 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white cursor-pointer"
              >
                <option value="">选择分类</option>
                <option v-for="c in dbCategories" :key="c.id" :value="String(c.id)">{{ c.name }}</option>
              </select>
              <ChevronDown class="absolute right-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400 pointer-events-none" />
            </div>
          </div>

          <!-- 公开/私有选项 -->
          <div>
            <label class="block text-gray-700 mb-2">资源状态</label>
            <div class="flex items-center space-x-4">
              <label class="flex items-center">
                <input type="radio" v-model="isPublic" :value="false" class="mr-2">
                <span>私有</span>
              </label>
              <label class="flex items-center">
                <input type="radio" v-model="isPublic" :value="true" class="mr-2">
                <span>公开</span>
              </label>
            </div>
          </div>

          <div class="rounded-lg border border-gray-200 bg-gray-50 p-4">
            <div class="flex items-center justify-between gap-3 mb-2">
              <h3 class="text-gray-900 text-sm font-semibold">Parsed Info</h3>
              <span v-if="extracting" class="text-xs text-gray-500">Parsing…</span>
            </div>

            <div class="space-y-3">
              <div v-if="extractedMeta?.thumbnail_url" class="rounded-lg border border-gray-200 bg-white p-2">
                <img
                  :src="extractedMeta.thumbnail_url"
                  :alt="extractedMeta?.title || 'thumbnail'"
                  class="h-28 w-full object-cover rounded-md"
                />
              </div>

              <div>
                <div class="text-xs text-gray-500 mb-1">Title</div>
                <div class="text-sm text-gray-900 wrap-break-word">{{ extractedMeta?.title || '—' }}</div>
              </div>

              <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <div class="text-xs text-gray-500 mb-1">Author</div>
                  <div class="text-sm text-gray-700 wrap-break-word">{{ extractedMeta?.author || '—' }}</div>
                </div>
                <div>
                  <div class="text-xs text-gray-500 mb-1">Publish date</div>
                  <div class="text-sm text-gray-700 wrap-break-word">{{ formatExtractDate(extractedMeta?.publish_date || null) || '—' }}</div>
                </div>
              </div>

              <div>
                <div class="text-xs text-gray-500 mb-1">Video ID</div>
                <div class="text-sm text-gray-700 wrap-break-word">{{ extractedMeta?.video_id || '—' }}</div>
              </div>

              <div>
                <div class="text-xs text-gray-500 mb-1">Description</div>
                <div class="text-sm text-gray-700 whitespace-pre-wrap wrap-break-word max-h-48 overflow-auto">{{ extractedMeta?.description || '—' }}</div>
              </div>

              <div>
                <div class="text-xs text-gray-500 mb-1">Chapters</div>
                <div v-if="(extractedMeta?.chapters || []).length === 0" class="text-sm text-gray-700">—</div>
                <div v-else class="max-h-56 overflow-auto rounded-lg border border-gray-200 bg-white">
                  <div
                    v-for="ch in (extractedMeta?.chapters || []).slice(0, 12)"
                    :key="ch.start_seconds + ':' + ch.title"
                    class="flex items-start justify-between gap-3 px-3 py-2 border-b border-gray-100 last:border-b-0"
                  >
                    <div class="min-w-0">
                      <div class="text-sm text-gray-900 wrap-break-word">{{ ch.title }}</div>
                      <div v-if="ch.description" class="text-xs text-gray-500 mt-0.5 wrap-break-word">{{ ch.description }}</div>
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

        <div class="sticky bottom-0 bg-gray-50 border-t border-gray-200 p-6 flex gap-3 justify-end">
          <button type="button" @click="closeAddModal" class="px-6 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">Cancel</button>
          <button
            type="button"
            @click="confirmAdd"
            :disabled="!urlInput || extracting || !extractedMeta?.title || submitting"
            class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {{ submitting ? 'Saving…' : 'Add Resource' }}
          </button>
        </div>
      </div>
    </div>

    <!-- 删除确认模态框 -->
    <div v-if="showDeleteConfirm" class="fixed inset-0 bg-black/20 backdrop-blur-sm flex items-center justify-center p-4 z-50">
      <div class="bg-white rounded-xl shadow-2xl max-w-md w-full overflow-hidden">
        <div class="border-b border-gray-200 p-6 flex items-center justify-between">
          <h2 class="text-gray-900 text-lg font-semibold">确认删除</h2>
          <button type="button" @click="closeDeleteConfirm" class="text-gray-400 hover:text-gray-600" :disabled="deletingId !== null">
            <X class="w-6 h-6" />
          </button>
        </div>

        <div class="p-6 space-y-3">
          <div class="text-gray-700">是否确认删除该资源？</div>
          <div v-if="deleteTarget" class="rounded-lg border border-gray-200 bg-gray-50 p-3">
            <div class="text-gray-900 font-semibold line-clamp-1">{{ deleteTarget.title }}</div>
            <div class="text-xs text-gray-600 line-clamp-1 mt-1">ID: {{ deleteTarget.id }}</div>
          </div>
          <p v-if="deleteError" class="text-sm text-red-600">{{ deleteError }}</p>
        </div>

        <div class="bg-gray-50 border-t border-gray-200 p-6 flex gap-3 justify-end">
          <button
            type="button"
            class="px-6 py-2 bg-white border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
            @click="closeDeleteConfirm"
            :disabled="deletingId !== null"
          >
            取消
          </button>
          <button
            type="button"
            class="px-6 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
            @click="confirmDelete"
            :disabled="deletingId !== null"
          >
            {{ deletingId !== null ? '删除中...' : '确认删除' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { ChevronDown, Image, Search, Tag, X } from 'lucide-vue-next'
import { createMyResourceFromUrl, deleteMyResource, extractVideoMetadata, listMyResources, type DbResource, type UrlExtractResponse } from '../api/resource'
import { listCategories, type Category } from '../api/category'

const router = useRouter()

type UiResource = {
  id: number
  title: string
  summary: string
  category: string
  platform: string
  thumbnail: string
  type: 'video' | 'document' | 'article'
  addedDate?: string
  is_public?: boolean
}

const resources = ref<UiResource[]>([])
const searchKeyword = ref('')
const filterCategory = ref('')
const filterType = ref('')
const loading = ref(false)
const deletingId = ref<number | null>(null)
const publicUpdatingId = ref<number | null>(null)

const showDeleteConfirm = ref(false)
const deleteTarget = ref<UiResource | null>(null)
const deleteError = ref('')

const showAddModal = ref(false)
const platformUrlInputs = reactive({
  youtube: '',
  bilibili: '',
  github: '',
  medium: '',
  reddit: '',
  substack: '',
  devto: '',
})

const supportedPlatforms = [
  { key: 'youtube', label: 'YouTube', placeholder: 'https://www.youtube.com/watch?v=...' },
  { key: 'bilibili', label: 'Bilibili', placeholder: 'https://www.bilibili.com/video/...' },
  { key: 'github', label: 'GitHub', placeholder: 'https://github.com/... (repo / issue / doc)' },
  { key: 'medium', label: 'Medium', placeholder: 'https://medium.com/.../...' },
  { key: 'reddit', label: 'Reddit', placeholder: 'https://www.reddit.com/r/.../comments/...' },
  { key: 'substack', label: 'Substack', placeholder: 'https://xxx.substack.com/p/...' },
  { key: 'devto', label: 'Dev.to', placeholder: 'https://dev.to/.../...' },
]

const urlInput = computed(() => {
  for (const p of supportedPlatforms) {
    const v = String((platformUrlInputs as any)[p.key] || '').trim()
    if (v) return v
  }
  return ''
})
const extracting = ref(false)
const extractError = ref('')
const extractedMeta = ref<UrlExtractResponse | null>(null)
const submitting = ref(false)
const submitError = ref('')
const isPublic = ref(false)

const dbCategories = ref<Category[]>([])
const addCategoryId = ref('')

const fallbackThumb = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400&h=225&fit=crop'

function formatDate(iso?: string | null) {
  if (!iso) return ''
  const d = new Date(iso)
  if (Number.isNaN(d.getTime())) return ''
  return d.toLocaleDateString()
}

function formatExtractDate(iso?: string | null) {
  if (!iso) return ''
  const d = new Date(iso)
  if (Number.isNaN(d.getTime())) return ''
  return d.toLocaleDateString()
}

function mapDbToUi(r: DbResource): UiResource {
  const platform = String((r as any).platform || '').trim() || '—'
  const rawType = String((r as any).resource_type || '').trim().toLowerCase()
  const type: UiResource['type'] = rawType === 'document' || rawType === 'article' ? rawType : 'video'
  return {
    id: r.id,
    title: r.title,
    summary: String((r as any).summary || '').trim(),
    category: String((r as any).category_name || '').trim() || '其他',
    platform,
    thumbnail: String((r as any).thumbnail || '').trim() || fallbackThumb,
    type,
    addedDate: formatDate(r.created_at),
    is_public: (r as any).is_public,
  }
}

async function togglePublic(resource: UiResource) {
  alert('当前版本不支持 Public/Private 切换（新 schema 已移除 is_public）。')
}

async function load() {
  loading.value = true;
  try {
    const data = await listMyResources()
    resources.value = (data || []).map(mapDbToUi)
  } catch (e: any) {
    const msg = e?.response?.data?.detail || e?.message || 'Failed to load my resources'
    alert(String(msg))
    resources.value = []
  } finally {
    loading.value = false;
  }
}

async function loadCategories() {
  try {
    dbCategories.value = await listCategories()
    const other = dbCategories.value.find(c => String(c.code).toLowerCase() === 'other')
    if (other && !addCategoryId.value) addCategoryId.value = String(other.id)
  } catch (e: any) {
    console.error('Error loading categories:', e)
    dbCategories.value = []
  }
}

onMounted(() => {
  void loadCategories()
  load()
})

const filteredResources = computed(() => {
  const q = searchKeyword.value.trim().toLowerCase()
  const cat = filterCategory.value
  const type = filterType.value

  return resources.value.filter(r => {
    const matchCategory = !cat || cat === '' || r.category === cat
    const matchType = !type || type === '' || r.type === type
    if (!matchCategory || !matchType) return false
    if (!q) return true
    return (
      r.title.toLowerCase().includes(q) ||
      r.summary.toLowerCase().includes(q) ||
      r.category.toLowerCase().includes(q) ||
      r.platform.toLowerCase().includes(q)
    )
  })
})

function setView(mode: 'grid' | 'list') {
  // This function is not implemented in the template
}

function openAddModal() {
  showAddModal.value = true
  for (const p of supportedPlatforms) {
    ;(platformUrlInputs as any)[p.key] = ''
  }
  if (!addCategoryId.value) {
    const other = dbCategories.value.find(c => String(c.code).toLowerCase() === 'other')
    addCategoryId.value = other ? String(other.id) : ''
  }
  extractedMeta.value = null
  extractError.value = ''
  submitError.value = ''
}

function closeAddModal() {
  showAddModal.value = false
  for (const p of supportedPlatforms) {
    ;(platformUrlInputs as any)[p.key] = ''
  }
  addCategoryId.value = ''
  extractedMeta.value = null
  extractError.value = ''
  submitError.value = ''
}

async function confirmAdd() {
  if (!urlInput.value || !extractedMeta.value?.title) return
  submitError.value = ''
  submitting.value = true
  try {
    const catId = addCategoryId.value ? Number(addCategoryId.value) : NaN
    if (!Number.isFinite(catId)) throw new Error('请选择分类')
    await createMyResourceFromUrl({ 
      url: urlInput.value, 
      category_id: catId,
      is_public: isPublic.value
    })
    closeAddModal()
    await load()
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

function getResourceTypeClass(type: string) {
  switch (type) {
    case 'video':
      return 'bg-blue-100 text-blue-600'
    case 'article':
      return 'bg-green-100 text-green-600'
    case 'document':
      return 'bg-yellow-100 text-yellow-600'
    default:
      return 'bg-gray-100 text-gray-600'
  }
}

function viewResource(resource: UiResource) {
  const name = resource.type === 'video'
    ? 'my-resource-video'
    : resource.type === 'document'
      ? 'my-resource-document'
      : 'my-resource-article'
  router.push({ name, params: { id: resource.id } })
}

function editResource(resource: UiResource) {
  router.push({ name: 'my-resource-edit', params: { id: resource.id } })
}

async function deleteResource(resource: UiResource) {
  if (deletingId.value !== null) return
  deleteError.value = ''
  deleteTarget.value = resource
  showDeleteConfirm.value = true
}

function closeDeleteConfirm() {
  if (deletingId.value !== null) return
  showDeleteConfirm.value = false
  deleteTarget.value = null
  deleteError.value = ''
}

async function confirmDelete() {
  if (!deleteTarget.value) return
  if (deletingId.value !== null) return
  deleteError.value = ''
  deletingId.value = deleteTarget.value.id
  try {
    await deleteMyResource(deleteTarget.value.id)
    resources.value = resources.value.filter(r => r.id !== deleteTarget.value!.id)
    showDeleteConfirm.value = false
    deleteTarget.value = null
  } catch (e: any) {
    const msg = e?.response?.data?.detail || e?.message || 'Failed to delete resource'
    deleteError.value = String(msg)
  } finally {
    deletingId.value = null
  }
}
</script>