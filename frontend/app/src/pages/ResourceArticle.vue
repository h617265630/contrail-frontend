<template>
  <div class="min-h-screen bg-slate-50">
    <div class="max-w-6xl mx-auto p-6 space-y-6">
      <div v-if="loading" class="rounded-2xl bg-white p-6 shadow-sm text-slate-700">Loading…</div>
      <div v-else-if="error" class="rounded-2xl bg-white p-6 shadow-sm text-red-600">{{ error }}</div>

      <template v-else>
        <div class="flex flex-col gap-2">
          <p class="text-sm uppercase tracking-wide text-emerald-600 font-semibold">Article Resource</p>
          <h1 class="text-3xl font-semibold text-slate-900">{{ resource.title }}</h1>
          <div class="flex flex-wrap items-center gap-3 text-sm text-slate-600">
            <span
              v-if="resource.category"
              class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-100 text-emerald-700 font-medium"
            >
              {{ resource.category }}
            </span>
            <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-slate-100 text-slate-700">
              <BookOpen class="w-4 h-4" />
              {{ resource.resource_type }}
            </span>
            <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-slate-100 text-slate-700">
              <Sparkles class="w-4 h-4" />
              {{ updatedText ? `Updated ${updatedText}` : '—' }}
            </span>
          </div>
        </div>

        <div class="grid gap-6 lg:grid-cols-[2fr_1fr]">
          <div class="bg-white rounded-2xl shadow-sm overflow-hidden border border-slate-100">
            <div class="flex items-center justify-between px-4 py-3 border-b border-slate-100 bg-slate-50">
              <div class="flex items-center gap-2 text-sm text-slate-700">
                <BookOpen class="w-4 h-4 text-emerald-600" />
                <span>Reader</span>
              </div>
              <div class="flex items-center gap-2">
                <button
                  type="button"
                  class="px-3 py-2 rounded-lg bg-slate-900 text-white text-sm font-semibold hover:bg-black disabled:opacity-50"
                  :disabled="!resource.url"
                  @click="openSource"
                >
                  Start reading
                </button>
                <button
                  type="button"
                  class="p-2 rounded-lg border border-slate-200 text-slate-700 hover:bg-white disabled:opacity-50"
                  :disabled="!resource.url"
                  @click="openSource"
                >
                  <Download class="w-4 h-4" />
                </button>
              </div>
            </div>
            <div class="aspect-4/3 bg-slate-900">
              <iframe v-if="resource.url" :src="resource.url" class="w-full h-full" title="Article preview"></iframe>
              <div v-else class="w-full h-full flex items-center justify-center text-white/80 text-sm">Preview is unavailable</div>
            </div>
            <div class="p-6 space-y-4">
              <div class="space-y-2">
                <h2 class="text-xl font-semibold text-slate-900">Overview</h2>
                <p class="text-slate-700 leading-relaxed whitespace-pre-wrap">{{ resource.description || '—' }}</p>
              </div>
            </div>
          </div>

          <div class="space-y-4">
            <div class="p-4 rounded-2xl bg-white border border-slate-200 space-y-3">
              <h3 class="font-semibold text-slate-900">Meta</h3>
              <div class="space-y-2 text-sm text-slate-700">
                <div class="flex items-center gap-2">
                  <LinkIcon class="w-4 h-4 text-slate-500" />
                  <a v-if="resource.url" :href="resource.url" target="_blank" class="text-emerald-600 hover:underline break-all">{{ resource.url }}</a>
                  <span v-else>—</span>
                </div>
                <div class="flex items-center gap-2">
                  <UserRound class="w-4 h-4 text-slate-500" />
                  <span>Author {{ resource.author || '—' }}</span>
                </div>
                <div class="flex items-center gap-2">
                  <GraduationCap class="w-4 h-4 text-slate-500" />
                  <span>Source {{ resource.source || '—' }}</span>
                </div>
              </div>
              <div class="grid grid-cols-2 gap-2 text-sm text-slate-800">
                <div class="p-3 rounded-lg bg-slate-50 border border-slate-100 flex items-center justify-between">
                  <span>Created</span>
                  <span class="font-semibold">{{ createdText || '—' }}</span>
                </div>
                <div class="p-3 rounded-lg bg-slate-50 border border-slate-100 flex items-center justify-between">
                  <span>Published</span>
                  <span class="font-semibold">{{ publishedText || '—' }}</span>
                </div>
              </div>
              <div class="flex gap-2">
                <RouterLink
                  :to="{ name: 'resource-add-to-path', params: { type: 'article', id: resourceId } }"
                  class="flex-1 px-3 py-2 rounded-lg bg-emerald-600 text-white font-semibold hover:bg-emerald-700 text-center"
                >
                  Add to path
                </RouterLink>
                <button type="button" class="px-3 py-2 rounded-lg border border-slate-200 text-slate-700 hover:bg-white" @click="openSource" :disabled="!resource.url">
                  Open
                </button>
              </div>
            </div>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, RouterLink } from 'vue-router'
import { BookOpen, Download, GraduationCap, Link as LinkIcon, Sparkles, UserRound } from 'lucide-vue-next'
import { getMyResourceDetail, getResourceDetail, type DbResourceDetail } from '../api/resource'
import { getMyProgressForItem, upsertMyProgress } from '../api/progress'

const route = useRoute()

const loading = ref(false)
const error = ref('')

const resourceId = computed(() => String(route.params.id || '').trim())
const resourceIdNumber = computed(() => {
  const raw = resourceId.value
  if (!raw) return null
  if (!/^\d+$/.test(raw)) return null
  const n = Number(raw)
  return Number.isFinite(n) ? n : null
})

const resource = ref<DbResourceDetail>({
  id: 0,
  title: '',
  description: null,
  resource_type: 'article',
  url: null,
  source: null,
  category: null,
  thumbnail_url: null,
  created_at: null,
  author: null,
  publish_date: null,
  video_id: null,
  chapters: [],
})

const pathItemId = computed(() => {
  const raw = String((route.query as any)?.path_item_id || '').trim()
  if (!raw) return null
  if (!/^\d+$/.test(raw)) return null
  const n = Number(raw)
  return Number.isFinite(n) ? n : null
})

const trackedProgress = ref(0)
let progressTimer: number | null = null
const progressUpdating = ref(false)

function stopProgressTimer() {
  if (progressTimer != null) {
    window.clearInterval(progressTimer)
    progressTimer = null
  }
}

async function startProgressTimer() {
  stopProgressTimer()
  if (pathItemId.value == null) return

  try {
    const row = await getMyProgressForItem(pathItemId.value)
    trackedProgress.value = Number(row?.progress_percentage) || 0
  } catch {
    trackedProgress.value = 0
  }

  progressTimer = window.setInterval(async () => {
    const pid = pathItemId.value
    if (pid == null) return
    if (progressUpdating.value) return
    progressUpdating.value = true
    try {
      const next = Math.min(Math.max(0, trackedProgress.value) + 5, 95)
      trackedProgress.value = next
      await upsertMyProgress({ path_item_id: pid, progress_percentage: next })
    } catch {
      // ignore
    } finally {
      progressUpdating.value = false
    }
  }, 15_000)
}

function formatDate(iso?: string | null) {
  if (!iso) return ''
  const d = new Date(iso)
  if (Number.isNaN(d.getTime())) return ''
  return d.toLocaleDateString()
}

const createdText = computed(() => formatDate(resource.value.created_at || null))
const publishedText = computed(() => formatDate(resource.value.publish_date || null))
const updatedText = computed(() => publishedText.value || createdText.value)

function openSource() {
  const url = String(resource.value.url || '').trim()
  if (!url) return
  window.open(url, '_blank', 'noopener,noreferrer')
}

async function load() {
  error.value = ''
  loading.value = true
  try {
    const dbId = resourceIdNumber.value
    if (dbId == null) throw new Error('Invalid resource id')
    const isMy = String(route.path || '').startsWith('/my-resources')
    const data = isMy ? await getMyResourceDetail(dbId) : await getResourceDetail(dbId)
    resource.value = {
      ...data,
      chapters: Array.isArray(data.chapters) ? data.chapters : [],
    }
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || 'Failed to load resource')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  void load()
  void startProgressTimer()
})

watch(pathItemId, () => {
  void startProgressTimer()
})

onBeforeUnmount(() => {
  stopProgressTimer()
})
</script>
