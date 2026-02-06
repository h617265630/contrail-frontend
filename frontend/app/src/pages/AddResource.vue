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
      <div class="border-b border-border bg-background px-6 py-4">
        <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
          <div class="flex items-center gap-2">
            <Button
              type="button"
              size="sm"
              class="gen-btn"
              :class="mode === 'url' ? 'gen-btn--active' : ''"
              @click="setMode('url')"
            >
              add resource from url
            </Button>
            <Button
              type="button"
              size="sm"
              class="gen-btn"
              :class="mode === 'md' ? 'gen-btn--active' : ''"
              @click="setMode('md')"
            >
              generate resources from .md
            </Button>
          </div>
        </div>
      </div>

      <div v-if="mode === 'url'" class="p-6 space-y-6">
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

        <div class="rounded-none border border-border bg-muted/30 p-6">
          <div class="flex items-center justify-between gap-3 mb-4">
            <h3 class="text-foreground text-base font-semibold">Preview</h3>
            <span v-if="extracting" class="text-sm text-muted-foreground">Loading…</span>
          </div>

          <div v-if="!extractedMeta && !extracting" class="text-center py-8 text-muted-foreground">
            Paste a URL to preview extracted metadata.
          </div>

          <div v-else class="grid gap-6 lg:grid-cols-12">
            <!-- Left: Card Preview (deck-card-ui-skill style) -->
            <div class="lg:col-span-4 flex flex-col items-center pt-8">
              <div class="text-xs font-semibold text-muted-foreground mb-3">Card Preview</div>
              <div
                :class="['w-56 h-72 rounded-md border shadow-sm cursor-pointer hover:shadow-xl transition-all duration-300 card-hover', weightCardClass]"
              >
                <div class="h-full flex flex-col overflow-hidden rounded-md">
                  <!-- Card Header with Category -->
                  <div class="px-3 py-2 border-b border-border flex items-center justify-between">
                    <span
                      class="px-2 py-0.5 text-xs font-medium rounded"
                      :style="{ backgroundColor: '#3b82f620', color: '#3b82f6' }"
                    >
                      {{ selectedPlatform || 'video' }}
                    </span>
                    <span class="text-xs text-muted-foreground">#{{ extractedMeta?.video_id?.slice(0, 6) || '---' }}</span>
                  </div>

                  <!-- Card Image -->
                  <div class="relative h-28 bg-white overflow-hidden px-2">
                    <img
                      v-if="extractedMeta?.thumbnail_url"
                      :src="extractedMeta.thumbnail_url"
                      :alt="extractedMeta?.title || 'thumbnail'"
                      class="w-full h-full object-cover"
                    />
                    <div v-else class="w-full h-full flex items-center justify-center">
                      <div class="w-12 h-12 rounded-full flex items-center justify-center text-xl font-bold text-white bg-blue-500">
                        {{ (extractedMeta?.title || 'R').charAt(0) }}
                      </div>
                    </div>
                  </div>

                  <!-- Card Title -->
                  <div class="px-3 py-2 border-b border-border bg-white">
                    <h3 class="text-sm font-bold text-foreground line-clamp-1">
                      {{ extractedMeta?.title || 'Untitled' }}
                    </h3>
                  </div>

                  <!-- Card Description -->
                  <div class="px-3 py-2 flex-1 bg-muted/30">
                    <p class="text-xs text-muted-foreground line-clamp-2">
                      {{ extractedMeta?.description || 'No description' }}
                    </p>
                  </div>

                  <!-- Card Footer -->
                  <div class="px-3 py-2 border-t border-border flex items-center justify-between">
                    <span class="text-xs text-muted-foreground">{{ extractedMeta?.author || '—' }}</span>
                    <span class="text-xs font-medium text-foreground">{{ formatExtractDate(extractedMeta?.publish_date || null) || '—' }}</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- Right: Detailed Data -->
            <div class="lg:col-span-8 space-y-4">
              <!-- Thumbnail -->
              <div>
                <div class="text-xs font-semibold text-muted-foreground mb-2">Thumbnail</div>
                <div class="rounded-none border border-border bg-background p-2">
                  <div class="h-40 w-full rounded-none bg-muted">
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

              <!-- Title -->
              <div>
                <div class="text-xs font-semibold text-muted-foreground mb-1">Title</div>
                <div class="text-sm text-foreground font-medium">{{ extractedMeta?.title || '—' }}</div>
              </div>

              <!-- Author & Video ID -->
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <div class="text-xs font-semibold text-muted-foreground mb-1">Author</div>
                  <div class="text-sm text-foreground">{{ extractedMeta?.author || '—' }}</div>
                </div>
                <div>
                  <div class="text-xs font-semibold text-muted-foreground mb-1">Video ID</div>
                  <div class="text-sm text-foreground font-mono">{{ extractedMeta?.video_id || '—' }}</div>
                </div>
              </div>

              <!-- Description -->
              <div>
                <div class="text-xs font-semibold text-muted-foreground mb-1">Description</div>
                <div class="text-sm text-foreground whitespace-pre-wrap max-h-32 overflow-auto border border-border rounded-none p-2 bg-background">{{ extractedMeta?.description || '—' }}</div>
              </div>

              <!-- Additional Options -->
              <div class="border-t border-border pt-4">
                <div class="text-xs font-semibold text-muted-foreground mb-3">Additional Options</div>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <!-- Category -->
                  <div>
                    <label class="block text-sm font-medium text-foreground mb-2">Category</label>
                    <select
                      v-model="categoryId"
                      class="w-full h-10 px-3 border border-border rounded-none focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 focus:ring-offset-background bg-background cursor-pointer"
                    >
                      <option value="">Select category</option>
                      <option v-for="c in dbCategories" :key="c.id" :value="String(c.id)">{{ c.name }}</option>
                    </select>
                  </div>

                  <!-- Visibility -->
                  <div>
                    <label class="block text-sm font-medium text-foreground mb-2">Visibility</label>
                    <div class="flex items-center gap-4 h-10">
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

                  <!-- Weight -->
                  <div>
                    <label class="block text-sm font-medium text-foreground mb-2">Weight</label>
                    <select
                      v-model="selectedWeight"
                      class="w-full h-10 px-3 border border-border rounded-none focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 focus:ring-offset-background bg-background cursor-pointer"
                    >
                      <option value="">Select weight</option>
                      <option value="soil">Soil</option>
                      <option value="iron">Iron</option>
                      <option value="bronze">Bronze</option>
                      <option value="silver">Silver</option>
                      <option value="gold">Gold</option>
                    </select>
                  </div>
                </div>
              </div>

                          </div>
          </div>
        </div>

        <p v-if="submitError" class="text-sm text-destructive">{{ submitError }}</p>
      </div>

      <div v-else class="p-6 space-y-6">
        <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
          <div class="text-sm font-semibold text-foreground">Your Markdown/TXT files</div>
          <Button type="button" size="sm" class="gen-btn" @click="goToCreator">
            Go to Markdown editor
          </Button>
        </div>

        <div v-if="mdFilesError" class="text-sm text-destructive">{{ mdFilesError }}</div>

        <div v-else class="grid gap-6 lg:grid-cols-12">
          <div class="lg:col-span-3">
            <div v-if="mdFilesLoading" class="text-sm text-muted-foreground">Loading…</div>
            <div v-else-if="mdFiles.length === 0" class="text-sm text-muted-foreground">No markdown files yet.</div>
            <div v-else class="grid grid-cols-1 gap-3">
              <button
                v-for="f in mdFiles"
                :key="f.id"
                type="button"
                class="text-left border border-border bg-background p-3 transition rounded-none hover:bg-muted/30"
                :class="selectedMdFile?.id === f.id ? 'ring-2 ring-ring' : ''"
                @click="selectMdFile(f)"
              >
                <div class="text-sm font-semibold text-foreground truncate">{{ f.title || f.original_filename || 'Untitled' }}</div>
                <div class="mt-1 text-xs text-muted-foreground truncate">{{ f.file_type }}</div>
              </button>
            </div>
          </div>

          <div class="lg:col-span-9 grid gap-6 lg:grid-cols-12">
            <div class="lg:col-span-6">
              <div class="text-xs font-semibold text-muted-foreground">Content</div>
              <div class="mt-2 rounded-none border border-border bg-background p-4">
                <pre class="max-h-[520px] overflow-auto whitespace-pre-wrap text-sm text-foreground">{{ mdSelectedContent || 'Select a file to preview.' }}</pre>
              </div>
            </div>
            <div class="lg:col-span-6">
              <div class="flex items-center justify-between">
                <div class="text-xs font-semibold text-muted-foreground">URLs ({{ mdExtractedUrls.length }})</div>
                <Button
                  type="button"
                  size="sm"
                  variant="outline"
                  class="rounded-none"
                  :disabled="mdExtractedUrls.length === 0"
                  @click="useFirstMdUrl"
                >
                  Use first URL
                </Button>
              </div>
              <div class="mt-2 grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div
                  v-for="u in mdExtractedUrls"
                  :key="u"
                  class="rounded-none border border-border bg-background p-3"
                >
                  <div class="text-xs font-semibold text-muted-foreground">{{ guessUrlKind(u) }}</div>
                  <div class="mt-1 text-sm text-foreground break-all">{{ u }}</div>
                  <div class="mt-3 flex justify-end">
                    <Button type="button" size="sm" class="gen-btn" @click="useMdUrl(u)">
                      Use this URL
                    </Button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
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
            class="rounded-none border-border bg-black px-3 text-xs font-semibold tracking-[0.14em] uppercase text-white transition-all hover:-translate-y-px hover:bg-[#8ecbff] hover:text-white hover:shadow-sm active:translate-y-0"
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
import { listMyUserFiles, type UserFile } from '../api/userFile'

const route = useRoute()
const router = useRouter()

const mode = computed(() => ((route.query as any)?.mode === 'md' ? 'md' : 'url'))

function setMode(next: 'url' | 'md') {
  const current = (route.query as any) || {}
  router.replace({ query: { ...current, mode: next } })
}

const mdFilesLoading = ref(false)
const mdFilesError = ref('')
const mdFiles = ref<UserFile[]>([])
const selectedMdFile = ref<UserFile | null>(null)
const mdSelectedContent = ref('')

function extractUrls(text: string) {
  const input = String(text || '')
  const matches = input.match(/https?:\/\/[^\s)\]>]+/g) || []
  const cleaned = matches
    .map((u) => u.replace(/[),.;\]]+$/g, ''))
    .map((u) => u.trim())
    .filter(Boolean)
  return Array.from(new Set(cleaned))
}

function guessUrlKind(url: string) {
  const u = String(url || '').toLowerCase()
  if (u.includes('youtube.com') || u.includes('youtu.be') || u.includes('bilibili.com') || u.includes('vimeo.com')) return 'video'
  if (u.endsWith('.pdf') || u.endsWith('.doc') || u.endsWith('.docx') || u.endsWith('.ppt') || u.endsWith('.pptx') || u.endsWith('.xls') || u.endsWith('.xlsx')) return 'document'
  if (u.includes('github.com') || u.includes('medium.com') || u.includes('substack.com') || u.includes('dev.to')) return 'document'
  return 'link'
}

const mdExtractedUrls = computed(() => extractUrls(mdSelectedContent.value))

async function loadMdFiles() {
  mdFilesError.value = ''
  mdFilesLoading.value = true
  try {
    const files = await listMyUserFiles()
    mdFiles.value = files.filter((f) => f.file_type === 'md' || f.file_type === 'txt')
  } catch (e: any) {
    mdFilesError.value = e?.response?.data?.detail || e?.message || 'Failed to load markdown files'
    mdFiles.value = []
  } finally {
    mdFilesLoading.value = false
  }
}

function selectMdFile(file: UserFile) {
  selectedMdFile.value = file
  mdSelectedContent.value = String(file.content || '')
}

function goToCreator() {
  router.push({ name: 'creator' })
}

function useMdUrl(url: string) {
  urlInput.value = url
  setMode('url')
  const detected = detectPlatformFromUrl(url)
  if (detected) selectedPlatform.value = detected
}

function useFirstMdUrl() {
  if (mdExtractedUrls.value.length === 0) return
  useMdUrl(mdExtractedUrls.value[0])
}

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
const selectedWeight = ref('')

type Weight = '' | 'soil' | 'iron' | 'bronze' | 'silver' | 'gold'

const weightCardClass = computed(() => {
  const w = (selectedWeight.value || '') as Weight
  if (w === 'soil') return 'border-stone-200 bg-stone-50'
  if (w === 'iron') return 'border-slate-300 bg-slate-50'
  if (w === 'bronze') return 'border-amber-300 bg-amber-50'
  if (w === 'silver') return 'border-zinc-200 bg-zinc-50'
  if (w === 'gold') return 'border-yellow-300 bg-yellow-50'
  return 'border-border bg-card'
})

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
  if (mode.value === 'md') {
    void loadMdFiles()
  }
})

watch(
  () => (route.query as any)?.url,
  () => {
    applyPrefillFromRoute()
  },
)
</script>

<style scoped>
.card-hover:hover {
  animation: card-tilt-up 0.4s ease forwards;
}

@keyframes card-tilt-up {
  0% {
    transform: rotate(0deg) scale(1);
  }
  30% {
    transform: rotate(-6deg) scale(1.08);
  }
  100% {
    transform: rotate(0deg) scale(1.25);
  }
}

.line-clamp-1 {
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
