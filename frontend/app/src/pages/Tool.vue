<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Tools</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">查看数据库数据</p>
        </div>
      </div>
    </section>

    <section>
      <div class="grid gap-6 lg:grid-cols-12">
        <aside class="lg:col-span-3">
          <Card className="rounded-none" :hoverable="false" padded>
            <p class="text-sm font-semibold text-foreground">Tools</p>
            <p class="text-xs text-muted-foreground mt-1">查看数据库数据</p>

            <div class="mt-4 space-y-2">
              <Button
                type="button"
                variant="ghost"
                class="w-full justify-start rounded-none"
                :class="activeTab === 'category' ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : 'text-foreground hover:bg-muted/30'"
                @click="selectTab('category')"
              >
                Category
              </Button>
              <Button
                type="button"
                variant="ghost"
                class="w-full justify-start rounded-none"
                :class="activeTab === 'resource' ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : 'text-foreground hover:bg-muted/30'"
                @click="selectTab('resource')"
              >
                Resource
              </Button>
              <Button
                type="button"
                variant="ghost"
                class="w-full justify-start rounded-none"
                :class="activeTab === 'learningpath' ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : 'text-foreground hover:bg-muted/30'"
                @click="selectTab('learningpath')"
              >
                LearningPath
              </Button>
              <Button
                type="button"
                variant="ghost"
                class="w-full justify-start rounded-none"
                :class="activeTab === 'myresource' ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : 'text-foreground hover:bg-muted/30'"
                @click="selectTab('myresource')"
              >
                MyResource
              </Button>
              <Button
                type="button"
                variant="ghost"
                class="w-full justify-start rounded-none"
                :class="activeTab === 'mylearningpath' ? 'bg-foreground text-background hover:bg-foreground/90 hover:text-background' : 'text-foreground hover:bg-muted/30'"
                @click="selectTab('mylearningpath')"
              >
                MyPath
              </Button>
            </div>
          </Card>
        </aside>

        <main class="lg:col-span-9 space-y-4">
          <Card className="rounded-none" :hoverable="false" padded>
            <div class="flex items-center justify-between gap-3">
              <div>
                <h2 class="text-xl font-semibold text-foreground">{{ title }}</h2>
                <p class="text-sm text-muted-foreground mt-1">{{ subtitle }}</p>
              </div>
              <Button type="button" variant="outline" size="sm" class="rounded-none" :disabled="loading" @click="reload">
                Reload
              </Button>
            </div>
          </Card>

          <Card v-if="loading" className="rounded-none" :hoverable="false" padded>
            <div class="text-sm text-muted-foreground">Loading…</div>
          </Card>

          <Card v-else-if="error" className="rounded-none" :hoverable="false" padded>
            <div class="text-sm text-destructive">{{ error }}</div>
          </Card>

          <Card v-else className="rounded-none" :hoverable="false" padded>
            <div v-if="activeTab === 'resource' || activeTab === 'myresource'">
              <div class="overflow-x-auto">
                <table class="min-w-full text-sm">
                  <thead class="text-left text-slate-500">
                    <tr class="border-b border-slate-100">
                      <th class="py-2 pr-3">ID</th>
                      <th class="py-2 pr-3">Title</th>
                      <th class="py-2 pr-3">Type</th>
                      <th class="py-2 pr-3">Platform</th>
                      <th class="py-2 pr-3">Category</th>
                      <th class="py-2 pr-3">Summary</th>
                      <th class="py-2 pr-3">Source URL</th>
                    </tr>
                  </thead>
                  <tbody class="text-slate-900">
                    <tr v-for="r in resources" :key="r.id" class="border-b border-slate-50">
                      <td class="py-2 pr-3 whitespace-nowrap">{{ r.id }}</td>
                      <td class="py-2 pr-3">{{ r.title }}</td>
                      <td class="py-2 pr-3 whitespace-nowrap">{{ r.resource_type }}</td>
                      <td class="py-2 pr-3 whitespace-nowrap">{{ formatPlatform(r.platform) }}</td>
                      <td class="py-2 pr-3 whitespace-nowrap">{{ r.category_name || r.category_id || '—' }}</td>
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
          </Card>
        </main>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { listCategories, type Category } from '../api/category'
import { listMyLearningPaths, listPublicLearningPaths, type PublicLearningPath } from '../api/learningPath'
import { listMyResources, listResources, type DbResource } from '../api/resource'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'
import { formatPlatform } from '../utils/platform'

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
