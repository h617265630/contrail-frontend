<template>
  <div class="min-h-screen bg-slate-50">
    <div class="max-w-7xl mx-auto p-6">
      <div class="grid gap-6 lg:grid-cols-12">
        <aside class="lg:col-span-3">
          <div class="rounded-2xl bg-white p-4 shadow-sm border border-slate-100">
            <p class="text-sm font-semibold text-slate-900">Tools</p>
            <p class="text-xs text-slate-500 mt-1">查看数据库数据</p>

            <div class="mt-4 space-y-2">
              <button
                type="button"
                class="w-full text-left rounded-xl px-3 py-2 text-sm font-semibold"
                :class="activeTab === 'category' ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
                @click="selectTab('category')"
              >
                Category
              </button>
              <button
                type="button"
                class="w-full text-left rounded-xl px-3 py-2 text-sm font-semibold"
                :class="activeTab === 'resource' ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
                @click="selectTab('resource')"
              >
                Resource
              </button>
                 <button
                type="button"
                class="w-full text-left rounded-xl px-3 py-2 text-sm font-semibold"
                :class="activeTab === 'learningpath' ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
                @click="selectTab('learningpath')"
              >
                LearningPath
              </button>
              <button
                type="button"
                class="w-full text-left rounded-xl px-3 py-2 text-sm font-semibold"
                :class="activeTab === 'myresource' ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
                @click="selectTab('myresource')"
              >
                MyResource
              </button>
              <button
                type="button"
                class="w-full text-left rounded-xl px-3 py-2 text-sm font-semibold"
                :class="activeTab === 'mylearningpath' ? 'bg-blue-600 text-white' : 'text-slate-700 hover:bg-slate-50'"
                @click="selectTab('mylearningpath')"
              >
                MyPath
              </button>
            </div>
          </div>
        </aside>

        <main class="lg:col-span-9">
          <div class="rounded-2xl bg-white p-5 shadow-sm border border-slate-100">
            <div class="flex items-center justify-between gap-3">
              <div>
                <h1 class="text-xl font-semibold text-slate-900">{{ title }}</h1>
                <p class="text-sm text-slate-600 mt-1">{{ subtitle }}</p>
              </div>
              <button
                type="button"
                class="px-4 py-2 rounded-lg bg-slate-900 text-white text-sm font-semibold hover:bg-black disabled:opacity-50"
                :disabled="loading"
                @click="reload"
              >
                Reload
              </button>
            </div>
          </div>

          <div v-if="loading" class="mt-4 rounded-2xl bg-white p-6 shadow-sm text-slate-700 border border-slate-100">
            Loading…
          </div>

          <div v-else-if="error" class="mt-4 rounded-2xl bg-white p-6 shadow-sm text-red-600 border border-slate-100">
            {{ error }}
          </div>

          <div v-else class="mt-4 rounded-2xl bg-white p-4 shadow-sm border border-slate-100">
            <div v-if="activeTab === 'resource' || activeTab === 'myresource'">
              <div class="overflow-x-auto">
                <table class="min-w-full text-sm">
                  <thead class="text-left text-slate-500">
                    <tr class="border-b border-slate-100">
                      <th class="py-2 pr-3">ID</th>
                      <th class="py-2 pr-3">Title</th>
                      <th class="py-2 pr-3">Type</th>
                      <th class="py-2 pr-3">Platform</th>
                      <th class="py-2 pr-3">Summary</th>
                      <th class="py-2 pr-3">Source URL</th>
                    </tr>
                  </thead>
                  <tbody class="text-slate-900">
                    <tr v-for="r in resources" :key="r.id" class="border-b border-slate-50">
                      <td class="py-2 pr-3 whitespace-nowrap">{{ r.id }}</td>
                      <td class="py-2 pr-3">{{ r.title }}</td>
                      <td class="py-2 pr-3 whitespace-nowrap">{{ r.resource_type }}</td>
                      <td class="py-2 pr-3 whitespace-nowrap">{{ r.platform || '—' }}</td>
                      <td class="py-2 pr-3">{{ r.summary || '—' }}</td>
                      <td class="py-2 pr-3">
                        <a v-if="r.source_url" :href="r.source_url" target="_blank" class="text-blue-600 hover:underline break-all">{{ r.source_url }}</a>
                        <span v-else>—</span>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <div v-else-if="activeTab === 'category'">
              <div class="overflow-x-auto">
                <table class="min-w-full text-sm">
                  <thead class="text-left text-slate-500">
                    <tr class="border-b border-slate-100">
                      <th class="py-2 pr-3">ID</th>
                      <th class="py-2 pr-3">Name</th>
                      <th class="py-2 pr-3">Code</th>
                      <th class="py-2 pr-3">Description</th>
                    </tr>
                  </thead>
                  <tbody class="text-slate-900">
                    <tr v-for="c in categories" :key="c.id" class="border-b border-slate-50">
                      <td class="py-2 pr-3 whitespace-nowrap">{{ c.id }}</td>
                      <td class="py-2 pr-3 whitespace-nowrap">{{ c.name }}</td>
                      <td class="py-2 pr-3 whitespace-nowrap">{{ c.code }}</td>
                      <td class="py-2 pr-3">{{ c.description || '—' }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <div v-else>
              <div class="overflow-x-auto">
                <table class="min-w-full text-sm">
                  <thead class="text-left text-slate-500">
                    <tr class="border-b border-slate-100">
                      <th class="py-2 pr-3">ID</th>
                      <th class="py-2 pr-3">Title</th>
                      <th class="py-2 pr-3">Public</th>
                      <th class="py-2 pr-3">Category</th>
                    </tr>
                  </thead>
                  <tbody class="text-slate-900">
                    <tr v-for="lp in learningPaths" :key="lp.id" class="border-b border-slate-50">
                      <td class="py-2 pr-3 whitespace-nowrap">{{ lp.id }}</td>
                      <td class="py-2 pr-3">{{ lp.title }}</td>
                      <td class="py-2 pr-3 whitespace-nowrap">{{ lp.is_public ? 'true' : 'false' }}</td>
                      <td class="py-2 pr-3 whitespace-nowrap">{{ lp.category_name || '—' }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { listCategories, type Category } from '../api/category'
import { listMyLearningPaths, listPublicLearningPaths, type PublicLearningPath } from '../api/learningPath'
import { listMyResources, listResources, type DbResource } from '../api/resource'

type Tab = 'resource' | 'myresource' | 'category' | 'learningpath' | 'mylearningpath'

const activeTab = ref<Tab>('resource')
const loading = ref(false)
const error = ref('')

const resources = ref<DbResource[]>([])
const categories = ref<Category[]>([])
const learningPaths = ref<PublicLearningPath[]>([])

const title = computed(() => {
  if (activeTab.value === 'resource') return 'Resources'
  if (activeTab.value === 'myresource') return 'My Resources'
  if (activeTab.value === 'category') return 'Categories'
  if (activeTab.value === 'learningpath') return 'LearningPaths'
  return 'My LearningPaths'
})

const subtitle = computed(() => {
  if (activeTab.value === 'resource') return `共 ${resources.value.length} 条`
  if (activeTab.value === 'myresource') return `共 ${resources.value.length} 条`
  if (activeTab.value === 'category') return `共 ${categories.value.length} 条`
  return `共 ${learningPaths.value.length} 条`
})

async function loadResources() {
  const data = await (activeTab.value === 'myresource' ? listMyResources() : listResources())
  resources.value = Array.isArray(data) ? data : []
}

async function loadCategories() {
  const data = await listCategories()
  categories.value = Array.isArray(data) ? data : []
}

async function loadLearningPaths() {
  const data = await (activeTab.value === 'mylearningpath' ? listMyLearningPaths() : listPublicLearningPaths())
  learningPaths.value = Array.isArray(data) ? data : []
}

async function loadTab(tab: Tab) {
  loading.value = true
  error.value = ''
  try {
    if (tab === 'resource' || tab === 'myresource') {
      await loadResources()
    } else if (tab === 'category') {
      await loadCategories()
    } else {
      await loadLearningPaths()
    }
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || '加载失败')
  } finally {
    loading.value = false
  }
}

function selectTab(tab: Tab) {
  if (activeTab.value === tab) return
  activeTab.value = tab
  loadTab(tab)
}

function reload() {
  loadTab(activeTab.value)
}

onMounted(() => {
  loadTab(activeTab.value)
})
</script>
