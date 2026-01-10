<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-6">
    <div class="max-w-7xl mx-auto space-y-6">
      <div class="bg-white rounded-2xl shadow-xl p-8">
        <div class="flex items-start justify-between gap-4">
          <div class="min-w-0">
            <h1 class="text-gray-900 mb-2">Edit LearningPath</h1>
            <p class="text-gray-600">修改名称/介绍，并编辑学习路径中的资源。</p>
          </div>
          <RouterLink
            to="/mypaths"
            class="px-4 py-2 rounded-lg bg-white border border-gray-200 text-gray-700 hover:bg-gray-50 transition-colors"
          >
            返回 My Paths
          </RouterLink>
        </div>
      </div>

      <div v-if="!loaded" class="bg-white rounded-2xl shadow-xl p-6">
        <p class="text-gray-600">加载中...</p>
      </div>

      <div v-else-if="!exists" class="bg-white rounded-2xl shadow-xl p-6">
        <p class="text-gray-900 font-semibold">未找到该 LearningPath</p>
        <RouterLink to="/mypaths" class="inline-flex mt-4 text-blue-600 hover:text-blue-700 text-sm font-semibold">
          返回 My Paths
        </RouterLink>
      </div>

      <div v-else class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Resources panel -->
        <section class="bg-white rounded-2xl shadow-xl p-6 space-y-4">
          <div class="flex items-center justify-between gap-3">
            <h2 class="text-lg font-semibold text-gray-900">Resources</h2>
            <span class="text-sm text-gray-500">{{ filteredResources.length }} results</span>
          </div>

          <div class="relative">
            <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              v-model="searchQuery"
              type="search"
              placeholder="Search resources..."
              class="w-full pl-9 pr-3 py-2 rounded-lg border border-gray-200 bg-white text-sm text-gray-900 placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <div class="max-h-[520px] overflow-y-auto pr-1 space-y-3">
            <article
              v-for="r in filteredResources"
              :key="r.id"
              class="border border-gray-200 rounded-xl overflow-hidden hover:shadow-md transition bg-white"
              draggable="true"
              @dragstart="handleDragStart($event, r)"
            >
              <div class="flex gap-3 p-3">
                <img :src="r.thumbnail" :alt="r.title" class="w-24 h-16 object-cover rounded-lg bg-gray-100 flex-shrink-0" />
                <div class="min-w-0 flex-1">
                  <div class="flex items-start justify-between gap-2">
                    <h3 class="text-gray-900 font-semibold text-sm line-clamp-1" :title="r.title">{{ r.title }}</h3>
                    <span class="px-2 py-1 rounded-full text-xs font-semibold" :class="typeBadge(r.type)">{{ r.type }}</span>
                  </div>
                  <p class="text-gray-600 text-xs mt-1 line-clamp-2">{{ r.description }}</p>
                  <div class="mt-2 flex flex-wrap gap-2 text-xs text-gray-500">
                    <span class="px-2 py-1 rounded-full bg-gray-100 text-gray-700">{{ r.category }}</span>
                    <span v-if="r.duration" class="px-2 py-1 rounded-full bg-gray-100 text-gray-700">{{ r.duration }}</span>
                    <span v-if="r.pages" class="px-2 py-1 rounded-full bg-gray-100 text-gray-700">{{ r.pages }} pages</span>
                  </div>
                </div>
              </div>
              <div class="border-t border-gray-100 p-3 flex items-center justify-between">
                <span class="text-xs text-gray-400">拖拽到右侧学习路径区域</span>
                <button
                  type="button"
                  class="px-3 py-1.5 rounded-lg bg-blue-600 text-white text-xs font-semibold hover:bg-blue-700 transition-colors inline-flex items-center gap-2"
                  @click="addResource(r)"
                >
                  <Plus class="w-3.5 h-3.5" />
                  添加
                </button>
              </div>
            </article>
          </div>
        </section>

        <!-- Builder panel -->
        <section class="bg-white rounded-2xl shadow-xl p-6 space-y-4" @dragover.prevent @drop="onDrop">
          <div class="flex items-center justify-between gap-3">
            <div class="min-w-0">
              <h2 class="text-lg font-semibold text-gray-900">LearningPath Builder</h2>
              <p class="text-sm text-gray-600">
                <span class="text-gray-500">{{ selected.length }} items</span>
              </p>
            </div>
            <button
              type="button"
              class="px-4 py-2 rounded-lg bg-gray-100 text-gray-700 hover:bg-gray-200 transition-colors"
              @click="clearSelected"
              :disabled="selected.length === 0"
            >
              清空
            </button>
          </div>

          <div class="rounded-xl border border-gray-200 p-4 bg-gray-50 space-y-3">
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">名称 *</label>
              <input
                v-model="meta.title"
                type="text"
                placeholder="例如：AI Engineer Starter"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
              />
            </div>
            <div>
              <label class="block text-sm font-semibold text-gray-700 mb-2">介绍</label>
              <textarea
                v-model="meta.description"
                rows="3"
                placeholder="简要介绍这个学习路径的目标与内容"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none bg-white"
              />
            </div>
          </div>

          <div
            class="rounded-xl border-2 border-dashed p-4"
            :class="selected.length ? 'border-gray-200 bg-gray-50' : 'border-blue-200 bg-blue-50'"
          >
            <div v-if="selected.length === 0" class="text-sm text-gray-600">将左侧资源拖拽到这里，或点击“添加”。</div>

            <div v-else class="space-y-2">
              <div v-for="(r, idx) in selected" :key="r.id" class="space-y-2">
                <article
                  :class="[
                    'rounded-xl border p-3 flex gap-3 transition',
                    selectedDragState.draggingId === r.id
                      ? 'bg-pink-50/60 backdrop-blur-md border-pink-200/60'
                      : 'bg-white border-gray-200',
                  ]"
                  draggable="true"
                  @dragstart="onSelectedDragStart($event, r.id, idx)"
                  @dragend="onSelectedDragEnd"
                  @dragover.prevent="onSelectedDragOver(idx)"
                  @drop.prevent="onSelectedDrop($event, idx)"
                >
                  <div
                    class="w-8 h-8 rounded-lg bg-gray-100 text-gray-700 flex items-center justify-center text-xs font-semibold flex-shrink-0"
                  >
                    {{ idx + 1 }}
                  </div>
                  <img :src="r.thumbnail" :alt="r.title" class="w-24 h-16 object-cover rounded-lg bg-gray-100 flex-shrink-0" />
                  <div class="min-w-0 flex-1">
                    <div class="flex items-start justify-between gap-2">
                      <h3 class="text-gray-900 font-semibold text-sm line-clamp-1">{{ r.title }}</h3>
                      <button type="button" class="text-gray-400 hover:text-gray-700" @click="removeResource(r.id)" aria-label="Remove">
                        <X class="w-4 h-4" />
                      </button>
                    </div>
                    <p class="text-gray-600 text-xs mt-1 line-clamp-2">{{ r.description }}</p>
                    <div class="mt-2 flex flex-wrap gap-2 text-xs text-gray-500">
                      <span class="px-2 py-1 rounded-full bg-gray-100 text-gray-700">{{ r.category }}</span>
                      <span class="px-2 py-1 rounded-full text-xs font-semibold" :class="typeBadge(r.type)">{{ r.type }}</span>
                    </div>
                  </div>
                </article>

                <div
                  v-if="idx !== selected.length - 1"
                  class="flex justify-center text-gray-300"
                  @dragover.prevent
                  @drop.prevent="onSelectedDrop($event, idx + 1)"
                >
                  <ChevronDown class="w-5 h-5" />
                </div>
              </div>
            </div>
          </div>

          <div class="pt-2">
            <button
              type="button"
              class="w-full px-4 py-3 rounded-xl bg-blue-600 text-white font-semibold hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
              :disabled="!meta.title.trim()"
              @click="save"
            >
              保存修改
            </button>
          </div>
        </section>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import { ChevronDown, Plus, Search, X } from 'lucide-vue-next'
import { type Resource } from '../data/resources'
import { getMyLearningPath, updateMyLearningPath } from '../data/myPaths'
import { listAllResources } from '../data/resourcesStore'

type PathMeta = {
  title: string
  description: string
}

const route = useRoute()
const router = useRouter()

const loaded = ref(false)
const exists = ref(false)

const allResources = ref<Resource[]>(listAllResources())
const searchQuery = ref('')

const filteredResources = computed(() => {
  const q = searchQuery.value.trim().toLowerCase()
  if (!q) return allResources.value
  return allResources.value.filter(r => r.title.toLowerCase().includes(q) || r.description.toLowerCase().includes(q))
})

const selected = ref<Resource[]>([])
const meta = reactive<PathMeta>({ title: '', description: '' })

const selectedDragState = reactive({
  draggingId: '' as string,
  fromIndex: -1 as number,
  overIndex: -1 as number,
})

function typeBadge(type: Resource['type']) {
  switch (type) {
    case 'video':
      return 'bg-purple-50 text-purple-700'
    case 'document':
      return 'bg-blue-50 text-blue-700'
    case 'article':
      return 'bg-green-50 text-green-700'
  }
}

function addResource(resource: Resource) {
  if (selected.value.some(r => r.id === resource.id)) return
  selected.value = [...selected.value, resource]
}

function removeResource(id: string) {
  selected.value = selected.value.filter(r => r.id !== id)
}

function clearSelected() {
  selected.value = []
}

function onDrop(e: DragEvent) {
  // 1) Reorder inside builder: drop to empty area -> move to end
  const reorderId = e.dataTransfer?.getData('application/x-selected-resource-id') || ''
  const reorderFromStr = e.dataTransfer?.getData('application/x-selected-resource-from') || ''
  if (reorderId && reorderFromStr) {
    const fromIndex = Number(reorderFromStr)
    if (Number.isFinite(fromIndex)) {
      moveSelected(fromIndex, selected.value.length - 1)
    }
    return
  }

  // 2) Add from resources panel
  const resourceId = e.dataTransfer?.getData('text/plain') || ''
  const hit = allResources.value.find(r => r.id === resourceId)
  if (hit) addResource(hit)
}

function handleDragStart(e: DragEvent, resource: Resource) {
  e.dataTransfer?.setData('text/plain', resource.id)
  if (e.dataTransfer) e.dataTransfer.effectAllowed = 'copy'
}

function moveSelected(fromIndex: number, toIndex: number) {
  if (fromIndex === toIndex) return
  if (fromIndex < 0 || fromIndex >= selected.value.length) return
  if (toIndex < 0) toIndex = 0
  if (toIndex >= selected.value.length) toIndex = selected.value.length - 1

  const next = [...selected.value]
  const [item] = next.splice(fromIndex, 1)
  next.splice(toIndex, 0, item)
  selected.value = next
}

function onSelectedDragStart(e: DragEvent, id: string, idx: number) {
  selectedDragState.draggingId = id
  selectedDragState.fromIndex = idx
  selectedDragState.overIndex = idx

  e.dataTransfer?.setData('application/x-selected-resource-id', id)
  e.dataTransfer?.setData('application/x-selected-resource-from', String(idx))
  if (e.dataTransfer) e.dataTransfer.effectAllowed = 'move'
}

function onSelectedDragOver(idx: number) {
  selectedDragState.overIndex = idx
}

function onSelectedDrop(e: DragEvent, dropIndex: number) {
  const fromStr = e.dataTransfer?.getData('application/x-selected-resource-from') || ''
  if (!fromStr) return
  const fromIndex = Number(fromStr)
  if (!Number.isFinite(fromIndex)) return

  moveSelected(fromIndex, dropIndex)
}

function onSelectedDragEnd() {
  selectedDragState.draggingId = ''
  selectedDragState.fromIndex = -1
  selectedDragState.overIndex = -1
}

function save() {
  const id = String(route.params.id || '')
  if (!id) return
  if (!meta.title.trim()) return

  updateMyLearningPath(id, {
    title: meta.title,
    description: meta.description,
    resourceIds: selected.value.map(r => r.id),
  })

  router.push({ name: 'mypaths' })
}

onMounted(() => {
  const id = String(route.params.id || '')
  const path = id ? getMyLearningPath(id) : null
  loaded.value = true
  exists.value = Boolean(path)
  if (!path) return

  meta.title = path.title
  meta.description = path.description

  const byId = new Map(allResources.value.map(r => [r.id, r]))
  selected.value = path.resourceIds.map(rid => byId.get(rid)).filter(Boolean) as Resource[]
})
</script>
