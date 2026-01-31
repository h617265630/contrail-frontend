<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">My Resources</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">Manage the learning resources you saved.</p>
        </div>
        <div class="md:col-span-4 md:flex md:justify-end md:items-end">
          <div class="flex gap-2">
            <Button
              type="button"
              size="sm"
              class="rounded-none hover:bg-[#8ecbff] hover:text-white"
              @click="router.push({ name: 'add-resource' })"
            >
              Add Resource
            </Button>
          </div>
        </div>
      </div>

      <div class="mt-6 grid gap-4 md:grid-cols-12 md:items-center">
        <div class="md:col-span-8">
          <div class="relative">
            <Search class="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <Input v-model="searchKeyword" placeholder="Search resources..." class="pl-9 rounded-none" />
          </div>
        </div>
        <div class="md:col-span-4 md:flex md:justify-end">
          <div class="flex items-center gap-2">
            <select
              v-model="filterType"
              class="h-10 w-full md:w-auto border border-border bg-background px-3 text-sm text-foreground outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background rounded-none"
            >
              <option value="">All types</option>
              <option value="video">Video</option>
              <option value="article">Article</option>
              <option value="document">Document</option>
            </select>
          </div>
        </div>
      </div>
    </section>

    <section>
      <div v-if="loading" class="py-12 text-center">
        <div class="inline-block h-8 w-8 animate-spin border-b-2 border-foreground" />
        <p class="mt-3 text-sm text-muted-foreground">Loading...</p>
      </div>

      <div v-else-if="resources.length === 0" class="py-12 text-center">
        <p class="text-sm text-muted-foreground">No resources yet</p>
      </div>

      <div v-else class="grid grid-cols-1 gap-6 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5">
        <Card
          v-for="resource in filteredResources"
          :key="resource.id"
          class="rounded-none cursor-pointer"
          :hoverable="true"
          @click="viewResource(resource)"
        >
          <div class="relative h-32 bg-muted">
            <img :src="resource.thumbnail || fallbackThumb" :alt="resource.title" class="h-full w-full object-cover" />
            <div class="absolute top-3 right-3">
              <span class="px-2 py-1 border border-border bg-background text-foreground text-xs font-semibold">
                {{ resource.type }}
              </span>
            </div>
            <div class="absolute bottom-3 left-3">
              <span class="px-2 py-1 border border-border bg-background/90 text-foreground text-xs">
                {{ formatPlatform(resource.platform) }}
              </span>
            </div>
          </div>

          <div class="p-4 flex min-h-0 flex-1 flex-col">
            <h3 class="truncate text-sm font-semibold text-foreground">{{ resource.title }}</h3>
            <p class="mt-2 line-clamp-3 text-sm text-muted-foreground">{{ resource.summary }}</p>

            <div class="mt-3 space-y-1 text-xs text-muted-foreground">
              <div class="flex items-center justify-between gap-3">
                <span>Category</span>
                <span class="truncate text-foreground">{{ resource.category || '—' }}</span>
              </div>
              <div class="flex items-center justify-between gap-3">
                <span>Added</span>
                <span class="text-foreground">{{ resource.addedDate || '—' }}</span>
              </div>
            </div>

            <div class="mt-auto pt-4">
              <div class="flex items-center gap-2">
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  class="rounded-none"
                  @click.stop="togglePublic(resource)"
                  :disabled="publicUpdatingId === resource.id"
                >
                  {{ resource.is_system_public ? 'Public' : 'Private' }}
                </Button>
              </div>

              <div class="mt-2 grid grid-cols-3 gap-2">
                <Button
                  type="button"
                  size="sm"
                  class="rounded-none bg-[#8ecbff] text-white hover:bg-[#8ecbff]/90 hover:text-white"
                  @click.stop="viewResource(resource)"
                >
                  View
                </Button>
                <Button type="button" variant="outline" size="sm" class="rounded-none" @click.stop="editResource(resource)">Edit</Button>
                <Button
                  type="button"
                  variant="destructive"
                  size="sm"
                  class="rounded-none"
                  :disabled="deletingId === resource.id"
                  @click.stop="deleteResource(resource)"
                >
                  {{ deletingId === resource.id ? 'Deleting…' : 'Delete' }}
                </Button>
              </div>
            </div>
          </div>
        </Card>
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
          <Button type="button" variant="destructive" class="rounded-none" @click="confirmDelete" :disabled="deletingId !== null">
            {{ deletingId !== null ? 'Deleting...' : 'Confirm' }}
          </Button>
        </div>
      </Card>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { Search, X } from 'lucide-vue-next'
import { deleteMyResource, listMyResources, type DbResource } from '../api/resource'
import Card from '../components/ui/Card.vue'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import { formatPlatform } from '../utils/platform'

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
  is_system_public?: boolean
}

const resources = ref<UiResource[]>([])
const searchKeyword = ref('')
const filterType = ref('')
const loading = ref(false)
const deletingId = ref<number | null>(null)
const publicUpdatingId = ref<number | null>(null)

const showDeleteConfirm = ref(false)
const deleteTarget = ref<UiResource | null>(null)
const deleteError = ref('')

const fallbackThumb = 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400&h=225&fit=crop'

function formatDate(iso?: string | null) {
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
    category: String((r as any).category_name || '').trim() || 'Other',
    platform,
    thumbnail: String((r as any).thumbnail || '').trim() || fallbackThumb,
    type,
    addedDate: formatDate(r.created_at),
    is_system_public: (r as any).is_system_public,
  }
}

async function togglePublic(resource: UiResource) {
  alert('Public/Private toggle is not supported yet.')
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

onMounted(() => {
  load()
})

const filteredResources = computed(() => {
  const q = searchKeyword.value.trim().toLowerCase()
  const type = filterType.value

  return resources.value.filter(r => {
    const platform = String(r.platform || '').trim().toLowerCase()
    if (platform === 'xiaohongshu' || platform === 'xhs' || platform.includes('xiaohongshu')) return false
    if (platform === 'reddit') return false
    const matchType = !type || type === '' || r.type === type
    if (!matchType) return false
    if (!q) return true
    return (
      r.title.toLowerCase().includes(q) ||
      r.summary.toLowerCase().includes(q) ||
      r.category.toLowerCase().includes(q) ||
      r.platform.toLowerCase().includes(q)
    )
  })
})

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