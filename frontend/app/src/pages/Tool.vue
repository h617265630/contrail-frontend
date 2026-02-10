<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
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
                      <th class="py-2 pr-3 text-right">Actions</th>
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
                      <td class="py-2 pr-3 text-right">
                        <Button
                          type="button"
                          variant="ghost"
                          size="sm"
                          class="rounded-none text-red-500 hover:bg-red-50 hover:text-red-600"
                          :disabled="deleting[r.id]"
                          @click="openDeleteConfirm(r)"
                        >
                          <Trash2 class="h-4 w-4" />
                        </Button>
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

    <div v-if="showDeleteConfirm" class="fixed inset-0 z-50 flex items-center justify-center bg-black/20 p-4 backdrop-blur-sm">
      <Card class="w-full max-w-md rounded-none" :hoverable="false">
        <div class="flex items-center justify-between border-b border-border p-6">
          <h2 class="text-lg font-semibold text-foreground">Confirm delete</h2>
          <Button
            type="button"
            variant="ghost"
            size="icon"
            class="rounded-none"
            @click="closeDeleteConfirm"
            :disabled="deletingId !== null"
          >
            <X class="h-5 w-5" />
          </Button>
        </div>

        <div class="space-y-3 p-6">
          <div class="text-sm text-foreground">Are you sure you want to delete this resource?</div>
          <div v-if="activeTab !== 'myresource'" class="text-xs text-muted-foreground">Tip: Deleting is intended for MyResource tab (detaches from current user).</div>
          <div v-if="deleteTarget" class="border border-border bg-muted/30 p-3">
            <div class="line-clamp-1 font-semibold text-foreground">{{ deleteTarget.title }}</div>
            <div class="mt-1 line-clamp-1 text-xs text-muted-foreground">ID: {{ deleteTarget.id }}</div>
          </div>
          <p v-if="deleteError" class="text-sm text-destructive">{{ deleteError }}</p>
        </div>

        <div class="flex justify-end gap-2 border-t border-border bg-muted/30 p-6">
          <Button type="button" variant="outline" class="rounded-none" @click="closeDeleteConfirm" :disabled="deletingId !== null">
            Cancel
          </Button>
          <Button
            type="button"
            class="rounded-none bg-red-50 text-red-600 hover:bg-red-100"
            @click="confirmDelete"
            :disabled="deletingId !== null"
          >
            {{ deletingId !== null ? 'Deleting…' : 'Confirm' }}
          </Button>
        </div>
      </Card>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { listCategories, type Category } from '../api/category'
import { listMyLearningPaths, listPublicLearningPaths, type PublicLearningPath } from '../api/learningPath'
import { deleteMyResource, deleteResource, listMyResources, listResources, type DbResource } from '../api/resource'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'
import { formatPlatform } from '../utils/platform'
import { Trash2, X } from 'lucide-vue-next'

type Tab = 'resource' | 'myresource' | 'category' | 'learningpath' | 'mylearningpath'

const activeTab = ref<Tab>('resource')
const loading = ref(false)
const error = ref('')

const resources = ref<DbResource[]>([])
const categories = ref<Category[]>([])
const learningPaths = ref<PublicLearningPath[]>([])
const deleting = ref<Record<number, boolean>>({})

const showDeleteConfirm = ref(false)
const deleteTarget = ref<DbResource | null>(null)
const deleteError = ref('')
const deletingId = ref<number | null>(null)

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

function openDeleteConfirm(resource: DbResource) {
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
  const resourceId = deleteTarget.value.id
  deletingId.value = resourceId
  deleting.value = { ...deleting.value, [resourceId]: true }
  try {
    if (activeTab.value === 'myresource') {
      await deleteMyResource(resourceId)
    } else if (activeTab.value === 'resource') {
      await deleteResource(resourceId)
    } else {
      throw new Error('Delete is only supported for Resource / MyResource tabs')
    }
    resources.value = resources.value.filter((r) => r.id !== resourceId)
    showDeleteConfirm.value = false
    deleteTarget.value = null
  } catch (e: any) {
    deleteError.value = String(e?.response?.data?.detail || e?.message || '删除失败')
  } finally {
    deletingId.value = null
    deleting.value = { ...deleting.value, [resourceId]: false }
  }
}

onMounted(() => {
  loadTab(activeTab.value)
})
</script>
