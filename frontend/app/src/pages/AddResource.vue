<template>
  <div class="mx-auto max-w-7xl space-y-10 px-4 py-8">
    <section class="border-b border-border pb-8">
      <div class="grid gap-6 md:grid-cols-12 md:items-end">
        <div class="md:col-span-8">
          <h1 class="text-xl font-semibold tracking-tight text-foreground md:text-2xl">Add resource</h1>
          <p class="mt-3 max-w-2xl text-sm leading-relaxed text-muted-foreground">Choose a platform and paste the URL. We'll extract metadata automatically.</p>
        </div>
        <div class="md:col-span-4 md:flex md:justify-end md:items-end">
          <Button type="button" variant="outline" size="sm" class="rounded-none" @click="$router.back()">
            Back
          </Button>
        </div>
      </div>
    </section>

    <Card as="section" :hoverable="false" class="rounded-none">
      <div class="p-6 space-y-6">
        <!-- 平台选择和URL输入 -->
        <div>
          <label class="block text-sm font-semibold text-foreground mb-3">URL</label>
          <div class="flex gap-3">
            <select
              v-model="selectedPlatform"
              class="w-48 h-10 px-3 border border-border rounded-none focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 focus:ring-offset-background bg-background cursor-pointer"
            >
              <option value="">Platform</option>
              <option v-for="p in supportedPlatforms" :key="p.key" :value="p.key">
                {{ p.label }}
              </option>
            </select>
            <Input
              v-model="urlInput"
              type="url"
              :placeholder="selectedPlatformPlaceholder"
              class="h-10 flex-1 rounded-none"
            />
          </div>
          <p v-if="extractError" class="mt-2 text-sm text-destructive">{{ extractError }}</p>
        </div>

        <!-- 分类选择 -->
        <div>
          <label class="block text-sm font-semibold text-foreground mb-3">Category</label>
          <div class="relative">
            <Tag class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-muted-foreground" />
            <select
              v-model="categoryId"
              class="w-full h-10 appearance-none pl-10 pr-10 px-3 border border-border rounded-none focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 focus:ring-offset-background bg-background cursor-pointer"
            >
              <option value="">Category</option>
              <option v-for="c in dbCategories" :key="c.id" :value="String(c.id)">{{ c.name }}</option>
            </select>
            <ChevronDown class="absolute right-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-muted-foreground pointer-events-none" />
          </div>
        </div>

        <!-- 资源状态 -->
        <div>
          <label class="block text-sm font-semibold text-foreground mb-3">Visibility</label>
          <div class="flex items-center space-x-4">
            <label class="flex items-center cursor-pointer">
              <input type="radio" v-model="isPublic" :value="true" class="mr-2">
              <span class="text-muted-foreground">Public</span>
            </label>
            <label class="flex items-center cursor-pointer">
              <input type="radio" v-model="isPublic" :value="false" class="mr-2">
              <span class="text-muted-foreground">Private</span>
            </label>
          </div>
        </div>

        <!-- 解析信息 -->
        <div class="rounded-none border border-border bg-muted/30 p-6">
          <div class="flex items-center justify-between gap-3 mb-4">
            <h3 class="text-foreground text-base font-semibold">Preview</h3>
            <span v-if="extracting" class="text-sm text-muted-foreground">Loading…</span>
          </div>

          <div v-if="!extractedMeta && !extracting" class="text-center py-8 text-muted-foreground">
            Paste a URL to preview extracted metadata.
          </div>

          <div v-else class="grid gap-4 md:grid-cols-2">
            <div class="space-y-3">
              <div class="text-xs font-semibold text-muted-foreground">Thumbnail</div>
              <div class="rounded-none border border-border bg-background p-3">
                <div class="h-56 w-full rounded-none bg-muted">
                  <img
                    v-if="extractedMeta?.thumbnail_url"
                    :src="extractedMeta.thumbnail_url"
                    :alt="extractedMeta?.title || 'thumbnail'"
                    class="h-full w-full object-contain rounded-none"
                  />
                  <div v-else class="h-full w-full flex items-center justify-center text-sm text-muted-foreground">
                    No image
                  </div>
                </div>
              </div>
            </div>

            <div class="space-y-4">
              <div>
                <div class="text-xs font-semibold text-muted-foreground mb-1">Title</div>
                <div class="text-sm text-foreground">{{ extractedMeta?.title || '—' }}</div>
              </div>

              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <div class="text-xs font-semibold text-muted-foreground mb-1">Author</div>
                  <div class="text-sm text-foreground">{{ extractedMeta?.author || '—' }}</div>
                </div>
                <div>
                  <div class="text-xs font-semibold text-muted-foreground mb-1">Published</div>
                  <div class="text-sm text-foreground">{{ formatExtractDate(extractedMeta?.publish_date || null) || '—' }}</div>
                </div>
              </div>

              <div>
                <div class="text-xs font-semibold text-muted-foreground mb-1">Video ID</div>
                <div class="text-sm text-foreground">{{ extractedMeta?.video_id || '—' }}</div>
              </div>

              <div>
                <div class="text-xs font-semibold text-muted-foreground mb-1">Description</div>
                <div class="text-sm text-foreground whitespace-pre-wrap max-h-48 overflow-auto">{{ extractedMeta?.description || '—' }}</div>
              </div>

              <div>
                <div class="text-xs font-semibold text-muted-foreground mb-1">Chapters</div>
                <div v-if="(extractedMeta?.chapters || []).length === 0" class="text-sm text-foreground">—</div>
                <div v-else class="max-h-64 overflow-auto rounded-none border border-border bg-background">
                  <div
                    v-for="ch in (extractedMeta?.chapters || []).slice(0, 12)"
                    :key="ch.start_seconds + ':' + ch.title"
                    class="flex items-start justify-between gap-3 px-3 py-2 border-b border-border last:border-b-0"
                  >
                    <div class="min-w-0">
                      <div class="text-sm text-foreground">{{ ch.title }}</div>
                      <div v-if="ch.description" class="text-xs text-muted-foreground mt-0.5">{{ ch.description }}</div>
                    </div>
                    <div class="shrink-0 text-xs font-semibold text-muted-foreground">{{ ch.timestamp }}</div>
                  </div>
                </div>
                <div v-if="(extractedMeta?.chapters || []).length > 12" class="mt-1 text-xs text-muted-foreground">
                  Showing first 12 chapters only.
                </div>
              </div>
            </div>
          </div>
        </div>

        <p v-if="submitError" class="text-sm text-destructive">{{ submitError }}</p>
      </div>

      <div class="border-t border-border bg-muted/30 p-6">
        <div class="flex flex-col-reverse gap-3 sm:flex-row sm:items-center sm:justify-between">
          <Button type="button" variant="outline" size="sm" class="rounded-none" @click="$router.back()">
            Cancel
          </Button>
          <Button
            type="button"
            variant="outline"
            size="sm"
            class="rounded-none bg-foreground text-background hover:bg-foreground/90 hover:text-background"
            @click="confirmAdd"
            :disabled="!urlInput || extracting || !extractedMeta?.title || submitting"
          >
            {{ submitting ? 'Saving…' : 'Add resource' }}
          </Button>
        </div>
      </div>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ChevronDown, Tag } from 'lucide-vue-next'
import { createMyResourceFromUrl, extractVideoMetadata, type UrlExtractResponse } from '../api/resource'
import { listCategories, type Category } from '../api/category'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import Card from '../components/ui/Card.vue'

const route = useRoute()
const router = useRouter()

const supportedPlatforms = [
  { key: 'youtube', label: 'YouTube', placeholder: 'https://www.youtube.com/watch?v=...' },
  { key: 'bilibili', label: 'Bilibili', placeholder: 'https://www.bilibili.com/video/...' },
  { key: 'github', label: 'GitHub', placeholder: 'https://github.com/... (repo / issue / doc)' },
  { key: 'medium', label: 'Medium', placeholder: 'https://medium.com/.../...' },
  { key: 'substack', label: 'Substack', placeholder: 'https://xxx.substack.com/p/...' },
  { key: 'devto', label: 'Dev.to', placeholder: 'https://dev.to/.../...' },
  { key: 'other', label: 'Other', placeholder: 'Paste a URL (may not be supported yet)' },
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
  if (!selectedPlatform.value) return 'Select a platform first'
  const platform = supportedPlatforms.find(p => p.key === selectedPlatform.value)
  return platform?.placeholder || 'Paste a resource URL'
})

function detectPlatformFromUrl(url: string) {
  const u = String(url || '').toLowerCase()
  if (!u) return ''
  if (u.includes('youtube.com') || u.includes('youtu.be')) return 'youtube'
  if (u.includes('bilibili.com')) return 'bilibili'
  if (u.includes('github.com')) return 'github'
  if (u.includes('medium.com')) return 'medium'
  if (u.includes('substack.com')) return 'substack'
  if (u.includes('dev.to')) return 'devto'
  return ''
}

function applyPrefillFromRoute() {
  const q = (route.query as any)?.url
  const next = Array.isArray(q) ? String(q[0] || '').trim() : String(q || '').trim()
  if (!next) return
  urlInput.value = next
  const detected = detectPlatformFromUrl(next)
  if (detected) selectedPlatform.value = detected
}

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
          if (selectedPlatform.value === 'other') {
            extractError.value = 'Not supported yet.'
          } else {
            const msg = err?.response?.data?.detail || err?.message || '解析失败'
            extractError.value = String(msg)
          }
          extracting.value = false
        })
    }, 1200) as unknown as number
  },
  { immediate: false }
)

onMounted(() => {
  void loadCategories()
  applyPrefillFromRoute()
})

watch(
  () => (route.query as any)?.url,
  () => {
    applyPrefillFromRoute()
  },
)
</script>
