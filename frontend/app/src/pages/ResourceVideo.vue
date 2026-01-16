<template>
  <div class="min-h-screen bg-slate-50">
    <div class="max-w-6xl mx-auto p-6 space-y-4">
      <div v-if="loading" class="rounded-2xl bg-white p-6 shadow-sm text-slate-700">Loading…</div>

      <div v-else-if="error" class="rounded-2xl bg-white p-6 shadow-sm text-red-600">{{ error }}</div>

      <template v-else>
        <div class="space-y-3">
          <div class="rounded-2xl bg-black overflow-hidden shadow-sm">
            <div class="relative w-full aspect-video">
              <iframe
                v-if="embedUrl"
                :key="iframeKey"
                class="absolute inset-0 h-full w-full"
                :src="embedUrl"
                title="YouTube video player"
                frameborder="0"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                allowfullscreen
              />
              <div v-else class="absolute inset-0 flex items-center justify-center text-white/80">
                Video preview is unavailable
              </div>
            </div>
          </div>

          <h1 class="text-xl sm:text-2xl font-semibold text-slate-900">{{ resource.title }}</h1>

          <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
            <div class="flex flex-wrap items-center gap-3 text-sm text-slate-600">
              <span class="inline-flex items-center gap-2 rounded-full bg-slate-100 px-3 py-1">
                <UserRound class="h-4 w-4" />
                {{ resource.author || 'Unknown author' }}
              </span>
              <span v-if="publishedText" class="inline-flex items-center gap-2 rounded-full bg-slate-100 px-3 py-1">
                <Calendar class="h-4 w-4" />
                {{ publishedText }}
              </span>
              <span v-if="addedText" class="inline-flex items-center gap-2 rounded-full bg-slate-100 px-3 py-1">
                <Clock class="h-4 w-4" />
                Added {{ addedText }}
              </span>
            </div>

            <div class="flex items-center gap-2">
              <button
                type="button"
                class="px-3 py-2 rounded-lg bg-white text-slate-900 text-sm font-semibold shadow-sm hover:bg-slate-50"
                @click="goSaveToPath"
              >
                Save to path
              </button>
              <button
                type="button"
                class="p-2 rounded-lg bg-white text-slate-900 shadow-sm hover:bg-slate-50"
                :aria-label="'Open source URL'"
                @click="openSource"
              >
                <Download class="w-4 h-4" />
              </button>
            </div>
          </div>
        </div>

        <div class="grid gap-6 lg:grid-cols-3">
          <div class="lg:col-span-2 space-y-6">
            <div class="rounded-2xl bg-white p-5 shadow-sm space-y-2">
              <h2 class="text-lg font-semibold text-slate-900">Description</h2>
              <p class="text-slate-700 whitespace-pre-wrap leading-relaxed">{{ resource.description || '—' }}</p>
            </div>

            <div class="rounded-2xl bg-white p-5 shadow-sm space-y-3">
              <div class="flex items-center justify-between">
                <h3 class="text-lg font-semibold text-slate-900">Chapters</h3>
                <span class="text-xs rounded-full bg-slate-100 px-2 py-1 text-slate-600">{{ resource.chapters.length }} sections</span>
              </div>

              <div v-if="resource.chapters.length === 0" class="text-sm text-slate-600">No chapters found in the description.</div>

              <div v-else class="space-y-2">
                <button
                  v-for="(ch, idx) in resource.chapters"
                  :key="ch.start_seconds + ':' + ch.title"
                  type="button"
                  class="w-full text-left flex items-center gap-3 rounded-xl border border-slate-100 bg-slate-50 p-3 hover:bg-slate-100"
                  @click="seekTo(ch.start_seconds)"
                >
                  <div class="h-10 w-10 shrink-0 rounded-lg bg-blue-100 text-blue-700 font-semibold flex items-center justify-center">
                    {{ idx + 1 }}
                  </div>
                  <div class="min-w-0 flex-1">
                    <p class="font-semibold text-slate-900 truncate">{{ ch.title }}</p>
                    <p v-if="ch.description" class="text-sm text-slate-600 line-clamp-2">{{ ch.description }}</p>
                  </div>
                  <span class="shrink-0 text-xs text-slate-500">{{ ch.timestamp }}</span>
                </button>
              </div>
            </div>
          </div>

          <div class="space-y-4">
            <div class="rounded-2xl bg-white p-5 shadow-sm space-y-3">
              <h3 class="font-semibold text-slate-900">Source</h3>
              <div class="space-y-2 text-sm text-slate-700">
                <div class="flex items-center gap-2">
                  <LinkIcon class="w-4 h-4 text-slate-500" />
                  <a v-if="resource.url" :href="resource.url" target="_blank" class="text-blue-600 hover:underline break-all">{{ resource.url }}</a>
                  <span v-else>—</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Calendar, Clock, Download, Link as LinkIcon, Play, UserRound } from 'lucide-vue-next'
import { getMyResourceDetail, type DbResourceDetail } from '../api/resource'
import { getResourceById } from '../data/resourcesStore'

const route = useRoute()
const router = useRouter()

const loading = ref(false)
const error = ref('')

const resource = ref<DbResourceDetail>({
  id: 0,
  title: '',
  description: null,
  resource_type: 'link',
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

const startSeconds = ref(0)

const resourceIdRaw = computed(() => String(route.params.id || '').trim())

const resourceIdNumber = computed(() => {
  const raw = resourceIdRaw.value
  if (!raw) return null
  // Only treat as DB id when it is purely numeric.
  if (!/^\d+$/.test(raw)) return null
  const n = Number(raw)
  return Number.isFinite(n) ? n : null
})

function extractYouTubeId(url: string): string {
  const raw = String(url || '').trim()
  if (!raw) return ''
  try {
    const u = new URL(raw)
    const host = u.hostname.replace(/^www\./, '')
    if (host === 'youtu.be') {
      return u.pathname.replace(/^\//, '').split('/')[0] || ''
    }
    if (host === 'youtube.com' || host === 'm.youtube.com') {
      const v = u.searchParams.get('v')
      if (v) return v
      const parts = u.pathname.split('/').filter(Boolean)
      // /embed/<id>
      if (parts[0] === 'embed' && parts[1]) return parts[1]
    }
  } catch {
    // ignore
  }
  return ''
}

function mapLocalToDbDetail(idRaw: string): DbResourceDetail {
  const local = getResourceById(idRaw)
  if (!local) {
    throw new Error('Resource not found')
  }

  return {
    id: 0,
    title: local.title,
    description: local.description,
    resource_type: local.type,
    url: local.url,
    source: local.source,
    category: local.category,
    thumbnail_url: local.thumbnail,
    created_at: local.addedDate || null,
    author: null,
    publish_date: null,
    video_id: local.type === 'video' ? extractYouTubeId(local.url) : null,
    chapters: [],
  }
}

function formatDate(iso?: string | null) {
  if (!iso) return ''
  const d = new Date(iso)
  if (Number.isNaN(d.getTime())) return ''
  return d.toLocaleDateString()
}

const publishedText = computed(() => formatDate(resource.value.publish_date || null))
const addedText = computed(() => formatDate(resource.value.created_at || null))

const canEmbedPreview = computed(() => true)

const embedUrl = computed(() => {
  if (!canEmbedPreview.value) return ''
  const vid = (resource.value.video_id || '').trim()
  if (!vid) return ''
  const params = new URLSearchParams({
    start: String(Math.max(0, startSeconds.value || 0)),
    rel: '0',
    modestbranding: '1',
  })
  return `https://www.youtube.com/embed/${encodeURIComponent(vid)}?${params.toString()}`
})

const iframeKey = computed(() => `${resource.value.video_id || 'no-video'}:${startSeconds.value}`)

async function load() {
  error.value = ''
  loading.value = true
  try {
    const raw = resourceIdRaw.value
    if (!raw) throw new Error('Invalid resource id')

    const dbId = resourceIdNumber.value
    if (dbId != null) {
      try {
        const data = await getMyResourceDetail(dbId)
        resource.value = {
          ...data,
          chapters: Array.isArray(data.chapters) ? data.chapters : [],
        }
      } catch (e: any) {
        // If backend is unavailable / unauthorized / not found, but we have a local seed/custom
        // resource with the same id, render it as a fallback.
        resource.value = mapLocalToDbDetail(raw)
      }
    } else {
      // Local-only resource (e.g. created in CreatePath and stored in localStorage)
      resource.value = mapLocalToDbDetail(raw)
    }
    startSeconds.value = 0
  } catch (e: any) {
    error.value = String(e?.response?.data?.detail || e?.message || 'Failed to load resource')
  } finally {
    loading.value = false
  }
}

function seekTo(seconds: number) {
  startSeconds.value = Math.max(0, Number(seconds) || 0)
}

function openSource() {
  if (!resource.value.url) return
  window.open(String(resource.value.url), '_blank')
}

function goSaveToPath() {
  if (!resourceIdRaw.value) return
  router.push({ name: 'resource-add-to-path', params: { type: 'video', id: resourceIdRaw.value } })
}

watch(
  () => route.params.id,
  () => {
    load()
  }
)

onMounted(() => {
  load()
})
</script>
